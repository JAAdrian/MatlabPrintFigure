classdef PrintFigure < handle
%PRINTFIGURE <purpose in one line!>
% -------------------------------------------------------------------------
% <Detailed description of the function>
% 
% PrintFigure Properties:
%	propA - <description>
%	propB - <description>
% 
% PrintFigure Methods:
%	doThis - <description>
%	doThat - <description>
% 
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  15-Jun-2015 17:54:58
% Updated:  <>
% 

% TODO:
% - really a good idea to capture the figure?

properties (Constant, Hidden)
    caszPossibleFormatsBitmap = {...
        'jpeg',...
        'png',...
        'tiff',...
        'tiffn',...
        'bmpmono',...
        'bmp',...
        'bmp16m',...
        'bmp256',...
        'hdf',...
        'pbm',...
        'pbmraw',...
        'pcxmono',...
        'pcx24b',...
        'pcx256',...
        'pcx16',...
        'pgmraw',...
        'ppm',...
        'ppmraw',...
        };
    
    caszPossibleFormatsVector = {...
        'pdf',... <- must be at this position!
        'eps',...
        'epsc',...
        'eps2',...
        'epsc2',...
        'svg',...
        'ps',...
        'psc',...
        'ps2',...
        'psc2',...
        'meta',...
        };
    
    caszBadPlotTypes = {'histogram','image'};
    
    DefaultType = 'paper';
end

properties (Access = private)
    AxesHandles;
    PlotHandles;
    TitleHandles;
    LabelHandles;
    LegendHandles;
    
    PaperUnits = 'centimeters';
    
    PaperPosition = [0 0 21 13];
    PaperSize;
    
    AxesFontSize;
    AxesFontName;
    AxisLineWidth;
    XColor;
    YColor;
    
    TickLength;
    TickDir;
    Box;
    XGrid;
    YGrid;
    
    PlotLineWidth;
    MarkerSize;
    
    LabelFontName;
    LabelFontSize;
    
    Interpreter;
    TickLabelInterpreter;
    
    % variable in which the figure is saved if the object should be saved
    SavedFigureFile;
end


properties (SetAccess = private, GetAccess = public)
    HandleFigure;
end


properties (Access = public)
    Type;
    Format     = 'pdf';
    Resolution = 200;
end



methods
    function self = PrintFigure(hFigure)
        if nargin,
            if isgraphics(hFigure,'figure'),
                self.HandleFigure = hFigure;
            else
                error(['Argument not recognized! Pass a valid handle to ',...
                    'an existing figure']);
            end
        else
            self.HandleFigure = gcf;
        end
        
        lock(self);
        
        % get all handles
        getChildrenHandles(self)
        
        self.Type = self.DefaultType;
        
        update(self);
    end
    
    
    
    function [] = update(self)
        set(self.HandleFigure,'PaperUnits',self.PaperUnits);
        
        setPropertyValues(self);
        
        set(self.HandleFigure,...
            'PaperPositionMode','manual',...
            'PaperUnits',self.PaperUnits,...
            'PaperSize',self.PaperSize,...
            'PaperPosition',self.PaperPosition);
        
        set(self.AxesHandles,...
            'FontSize',self.AxesFontSize,...
            'FontName',self.AxesFontName,...
            'LineWidth',self.AxisLineWidth,...
            'TickDir',self.TickDir,...
            'TickLength',self.TickLength,...
            'Box',self.Box,...
            'XGrid',self.XGrid,...
            'YGrid',self.YGrid,...
            'XColor',self.XColor,...
            'YColor',self.YColor,...
            'TickLabelInterpreter',self.TickLabelInterpreter);
        
        for aaHandle = 1:length(self.PlotHandles),
            if ~strcmpi(get(self.PlotHandles(aaHandle),'Type'),self.caszBadPlotTypes),
                set(self.PlotHandles(aaHandle),...
                    'LineWidth',self.PlotLineWidth,...
                    'MarkerSize',self.MarkerSize);
            end
        end
        
        set(self.LabelHandles,...
            'FontName',self.LabelFontName,...
            'FontSize',self.LabelFontSize,...
            'Interpreter',self.Interpreter);
        set(self.TitleHandles,...
            'FontName',self.LabelFontName,...
            'FontSize',self.LabelFontSize,...
            'Interpreter',self.Interpreter);
        
        set(self.LegendHandles,...
            'FontSize',self.LabelFontSize,...
            'EdgeColor',0.3*ones(3,1),...
            'Interpreter',self.Interpreter);
    end
    
    function [] = applyParulaMap(self)
        if exist('parula','file'),
            colormap(self.HandleFigure,parula);
        else
            % different implementation if MATLAB version < R2014b
            colormap(self.HandleFigure,paruly);
        end
    end
    
    
    function [] = print(self,szFilename)
        if ismember(self.Format,self.caszPossibleFormatsBitmap),
            print(...
                self.HandleFigure,...
                sprintf('-d%s',self.Format),...
                sprintf('-r%i',self.Resolution),...
                szFilename);
        else
            print(...
                self.HandleFigure,...
                sprintf('-d%s',self.Format),...
                szFilename);
            
            % If the format was eps or epsc: fix the linestyles
            [szPath,szFilename,szExt] = fileparts(szFilename);
            if isempty(szExt),
                szExt = '.eps';
            end
            
            if ismember(self.Format,{'eps','epsc','eps2','epsc2'}),
                fixPSlinestyle(fullfile(szPath,[szFilename,szExt]));
            end
        end
    end
    
    function [] = saveFigure(self,szFilename)
        savefig(szFilename);
        szFigName = [szFilename,'.fig'];
        
        fid = fopen(szFigName);
        self.SavedFigureFile = fread(fid,inf,'uint8');
        fclose(fid);
        delete(szFigName);
        
        self.release;
        self.HandleFigure = [];
        
        obj = self; %#ok<NASGU>
        save(szFilename,'obj');
        clear obj;        
    end
    
    function [] = loadFigure(self)
        szFigName = 'tmp.fig';
        
        fid = fopen(szFigName,'w');
        fwrite(fid,self.SavedFigureFile,'uint8');
        fclose(fid);
        
        self.HandleFigure = openfig(szFigName);
        delete(szFigName);
        
        getChildrenHandles(self);
    end
    
    
    
    function [] = lock(self)
        set(self.HandleFigure,'CloseRequestFcn',@CloseReqFun);
    end
    
    function [] = release(self)
        if isgraphics(self.HandleFigure,'figure'),
            set(self.HandleFigure,'CloseRequestFcn','closereq');
        end
    end
    
    function [] = close(self)
        if isgraphics(self.HandleFigure,'figure'),
            delete(self.HandleFigure);
        end
    end
    
    function delete(self)
        if isgraphics(self.HandleFigure,'figure'),
            set(self.HandleFigure,'CloseRequestFcn','closereq');
        end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% setter/getter methods %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [] = set.Type(self,szType)
        stProfileFiles   = listFiles('profiles','*.json',0);
        caszProfileNames = {stProfileFiles.name};
        
        caszProfileNames = removeFileparts(caszProfileNames);
        
        if strcmpi(szType,'help') || isempty(szType),
            caIdx = strfind(caszProfileNames,self.DefaultType);
            idx   = find(~cellfun(@isempty,caIdx));
            caszProfileNames = [caszProfileNames(idx) caszProfileNames];
            caszProfileNames(idx+1) = [];
            
            printdefaults('Type',caszProfileNames{:});
        else
            assert(ismember(szType,caszProfileNames),['Make sure to use ',...
                'an available type profile for formating! See obj.Type = ''help''; ',...
                'for a list of available type profiles']);
            
            self.Type = szType;
            
            update(self);
        end
    end
    
    function [] = set.Format(self,szFormat)
        caszAllFormats = [self.caszPossibleFormatsVector, self.caszPossibleFormatsBitmap];
        
        if strcmpi(szFormat,'help') || isempty(szFormat),
            printdefaults('Format',caszAllFormats{:});
        else
            assert(ismember(szFormat,caszAllFormats),['Make sure to use ',...
                'a supported format for printing! See obj.Format = ''help'' ',...
                'for a list of supported formats']);
            
            self.Format = szFormat;
        end
        
    end
    
    function [] = set.Resolution(self,iResolution)
        if iResolution > 600,
            warning('Resolutions of >600 might lead to very large filesizes!');
        end
        assert(iResolution >=0, 'Pass a non-negative value for the resolution!');
        
        self.Resolution = iResolution;
    end
end





methods (Access = private)
    function [] = getChildrenHandles(self)
        self.AxesHandles   = cell2array(findobj(self.HandleFigure,'Type','axes'));
        self.PlotHandles   = cell2array(get(self.AxesHandles,'Children'));
        self.TitleHandles  = cell2array(get(self.AxesHandles,'Title'));
        
        vXLabelHandles     = cell2array(get(self.AxesHandles,'XLabel'));
        vYLabelHandles     = cell2array(get(self.AxesHandles,'YLabel'));
        self.LabelHandles  = [vXLabelHandles,vYLabelHandles];
        
        self.LegendHandles = cell2array(findobj(self.HandleFigure,'tag','legend'));
    end
    
    
    function [] = setPropertyValues(self)
        szProfileFile = fullfile('profiles',[self.Type, '.json']);
        
        stProfile = parsejson(fileread(szProfileFile));
        
        caszFieldnames = fieldnames(stProfile);
        numFields = length(caszFieldnames);
        
        
        
        
        for aaField = 1:numFields,
            currField = stProfile.(caszFieldnames{aaField});
            
            if iscell(currField),
                currField = cell2mat(currField);
            end
            
            self.(caszFieldnames{aaField}) = currField;
        end
        
        
        
        
        self.PaperSize = get(self.HandleFigure,'PaperSize');
        
        if strcmp(self.Format,'pdf'),
            self.PaperSize = self.PaperPosition([3,4]);
        end
    end
    

end


end




function printdefaults(varargin)

szDefaultsString = sprintf('''%s'' Options:\n{''%s''} |',varargin{1},varargin{2});

for aaArg = 3:nargin,
    szDefaultsString = sprintf('%s ''%s'' |',szDefaultsString,varargin{aaArg});
    
    if ~mod(aaArg,9),
        szDefaultsString = sprintf('%s\n',szDefaultsString);
    end
end
szDefaultsString = [szDefaultsString(1:end-1), '\n'];

fprintf(szDefaultsString);
end


function vArray = cell2array(caCell)
if iscell(caCell)
    vArray = [];
    for aaCell = 1:numel(caCell),
        vArray = [vArray; caCell{aaCell}]; %#ok<AGROW>
    end
else
    vArray = caCell;
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
error(nargchk(1, 2, nargin)); %#ok<NCHKN>
if ~ischar(varargin{1}) || (nargin == 2 && ~ischar(varargin{2}))
  error('Input arguments must be file names (char).');
end

% Make sure the files specified are postscript files
[p1, n1, e1] = fileparts(varargin{1}); %#ok<ASGLU>
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
    [replacestr, remline2] = strtok(remline    , '%'); %#ok<ASGLU>
    
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

function map = paruly(n)
%PARULY Blueish-greenish-orangey-yellowish color map mimics, but
% does not exactly match, the default parula color map introduced
% in Matlab R2014b.
%
% Syntax and Description:
% map = paruly(n) returns an n-by-3 matrix containing a parula-like
% colormap. If n is not specified, a value of 64 is used.
%
% Chad A. Greene. The University of Texas at Austin.
%
% See also AUTUMN, BONE, COOL, COPPER, FLAG, GRAY, HOT, HSV,
% JET, LINES, PINK, SPRING, SUMMER, WINTER, COLORMAP.

if nargin==0
    n = 64;
end
assert(isscalar(n)==1,'paruly input must be a scalar.')

C = load('parulynomials.mat');

x = linspace(0,1,n)';

r = polyval(C.R,x);
g = polyval(C.G,x);
b = polyval(C.B,x);

% Clamp:
r(r<0)=0;
g(g<0)=0;
b(b<0)=0;
r(r>1)=1;
g(g>1)=1;
b(b>1)=1;

map = [r g b];

end


function [caszOutNames] = removeFileparts(caszInNames)
numNames = length(caszInNames);

caszOutNames = cell(size(caszInNames));
for aaName = 1:numNames,
    [dummy,szName] = fileparts(caszInNames{aaName});
    
    caszOutNames{aaName} = szName;
end
end


function [] = CloseReqFun(handleobj,callbackdata) %#ok<INUSD>
warning(sprintf(['The figure cannot be closed until you ',...
    'delete this object or call ''obj.close''.\n',...
    '''delete(handle_to_your_figure)'' always works...'])); %#ok<SPWRN>
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
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the
%       distribution.
%     * Neither the name of the <organization> nor the
%       names of its contributors may be used to endorse or promote
%       products derived from this software without specific prior written
%       permission.
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

% End of file: PrintFigure.m
