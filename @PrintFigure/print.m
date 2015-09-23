function [] = print(self,szFilename,szNoFix)
%Prints the figure to disk
% -------------------------------------------------------------------------
%
% Usage: [] = print(self,szFilename,szNoFix)
%
%   Input:   ---------
%
%  Output:   ---------
%
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  17-Jun-2015 15:56:40
% Updated:  <>
%

if nargin < 3 || isempty(szNoFix),
    szNoFix = false;
end
if nargin < 2 || isempty(szFilename),
    error('Pass a filename for the figure to be printed!');
end

% handle the case when no profile has been set and the figure is to be
% printed -> print as seen on the screen
if ~self.bProfileSet,
    set(self.HandleFigure,...
        'PaperPositionMode','auto'...
        );
    
    if strcmp(self.Format,'pdf'),
        set(self.HandleFigure,...
            'PaperPosition',...
            [0, 0, get(self.HandleFigure,'PaperSize')]);
    end
end

% check whether the figure should have transparent background and apply if
% desired
if self.Transparent,
    set(self.AxesHandles,'Color','none');
end

if ismember(self.Format,self.BitmapFormats),
    print(...
        self.HandleFigure,...
        sprintf('-d%s',self.Format),...
        sprintf('-r%i',self.Resolution),...
        sprintf('-%s',self.Renderer),...
        szFilename...
        );
else
    print(...
        self.HandleFigure,...
        sprintf('-d%s',self.Format),...
        sprintf('-%s',self.Renderer),...
        szFilename...
        );
    
    if ~strcmpi(szNoFix,'nofix') && ismember(self.Format,{'eps','epsc','eps2','epsc2'}),
        % If the format was eps or epsc: fix the linestyles
        [szPath,szFilename,szExt] = fileparts(szFilename);
        if isempty(szExt),
            szExt = '.eps';
        end
        
        fixPSlinestyle(fullfile(szPath,[szFilename,szExt]));
        
        if self.Transparent,
            transparent_eps(self,fullfile(szPath,[szFilename,szExt]));
        end
    end
end


end




function fixPSlinestyle(varargin)
%FIXPSLINESTYLE Fix line styles in exported post script files
%
% FIXPSLINESTYLE(FILENAME) fixes the line styles in the postscript file
%   FILENAME. The file will be over-written. This takes a .PS or .EPS file
%   and fixes the dotted and dashed line styles to be a little bit more
%   esthetically pleasing. It fixes the four default line styles (line,
%   dotted, dashed, dashdot).
%
% FIXPSLINESTYLE(FILENAME, NEWFILENAME) creates a new file NEWFILENAME.
%
%   This is meant to be used with postscript files created by MATLAB
%   (print, export).
%
% Example:
%   x  = 1:.1:10;
%   y1 = sin(x);
%   y2 = cos(x);
%   h  = plot(x, y1, '--', x, y2, '-.');
%   set(h, 'LineWidth', 2);
%   grid on;
%   legend('line 1', 'line2');
%
%   print -depsc test.eps
%   fixPSlinestyle('test.eps', 'fixed_test.eps');
%
% See also PRINT.

% Copyright 2005-2010 The MathWorks, Inc.

% Error checking
error(nargchk(1, 2, nargin));
if ~ischar(varargin{1}) || (nargin == 2 && ~ischar(varargin{2}))
  error('Input arguments must be file names (char).');
end

% Make sure the files specified are postscript files
[p1, n1, e1] = fileparts(varargin{1});
if isempty(e1) || ~ismember(lower(e1), {'.ps', '.eps'})
  error('The extension has to be .ps or .eps');
end

% Open file and read it in
fid = fopen(varargin{1}, 'r');
str = fread(fid);
str = char(str');
fclose(fid);

% Find where the line types are defined
id   = strfind(str, '% line types:');

% (JA) fixed very error prune implementation
if ~isempty(id),
    str1 = str(1:id-1);
    [line1     , remline ] = strtok(str(id:end), '/');
    [replacestr, remline2] = strtok(remline    , '%');
    
    % Define the new line styles
    solidLine   = sprintf('/SO { [] 0 setdash } bdef\n');
    dotLine     = sprintf('/DO { [3 dpi2point mul 3 dpi2point mul] 0 setdash } bdef\n');
    dashedLine  = sprintf('/DA { [6 dpi2point mul] 0 setdash } bdef\n');
    dashdotLine = sprintf('/DD { [2 dpi2point mul 2 dpi2point mul 6 dpi2point mul 2 dpi2point mul] 0 setdash } bdef\n');
    
    % Construct the new file with the new line style definitions
    newText     = [str1, line1, solidLine, dotLine, dashedLine, dashdotLine, remline2];
else
    newText = str;
end

% Check for output file name
if nargin == 2
  [p2, n2, e2] = fileparts(varargin{2});
  if isempty(e2)
    fname = fullfile(p2, [n2, e1]);
  else
    if strcmpi(e1, e2)
      fname = varargin{2};
    else
      error('Output file must have same file extension.');
    end
  end
else % if not defined, over-write
  fname = varargin{1};
end

% Write out to file
fid = fopen(fname, 'w');
fprintf(fid, '%s', newText);
fclose(fid);


end




%-------------------- Licence ---------------------------------------------
% Copyright (c) 2015, J.-A. Adrian
% Institute for Hearing Technology and Audiology
% Jade University of Applied Sciences
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%
%	1. Redistributions of source code must retain the above copyright
%	   notice, this list of conditions and the following disclaimer.
%	2. Redistributions in binary form must reproduce the above copyright
%	   notice, this list of conditions and the following disclaimer in the
%	   documentation and/or other materials provided with the
%	   distribution
%	3. Neither the name of the <organization> nor the
%	   names of its contributors may be used to endorse or promote
%	   products derived from this software without specific prior written
%	   permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
% THE POSSIBILITY OF SUCH DAMAGE.

% End of file: print.m
