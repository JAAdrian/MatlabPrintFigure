function [] = print(self,szFilename,szNoFix)
%PRINT2 <purpose in one line!>
% -------------------------------------------------------------------------
% <Detailed description of the function>
% 
% Usage: [y] = print(input)
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
    
    if strcmpi(szNoFix,'nofix') && ismember(self.Format,{'eps','epsc','eps2','epsc2'}),
        % If the format was eps or epsc: fix the linestyles
        [szPath,szFilename,szExt] = fileparts(szFilename);
        if isempty(szExt),
            szExt = '.eps';
        end
        
        fixPSlinestyle(fullfile(szPath,[szFilename,szExt]));
    end
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
