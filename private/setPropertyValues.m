function [] = setPropertyValues(self)
%SETPROPERTYVALUES <purpose in one line!>
% -------------------------------------------------------------------------
% <Detailed description of the function>
% 
% Usage: [y] = setPropertyValues(input)
% 
%   Input:   ---------
% 
%  Output:   ---------
% 
% 
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  17-Jun-2015 16:16:35
% Updated:  <>
% 



szProfileFile = fullfile(self.ClassFolder,'profiles',[self.Profile, '.json']);

stProfile = parsejson(fileread(szProfileFile));


caszFieldnames = fieldnames(stProfile);
numFields      = length(caszFieldnames);
for aaField = 1:numFields,
    currField = stProfile.(caszFieldnames{aaField});
    
    if iscell(currField),
        currField = cell2mat(currField);
    end
    
    self.FigureProperties.(caszFieldnames{aaField}) = currField;
end




self.FigureProperties.PaperSize = get(self.HandleFigure,'PaperSize');

if strcmp(self.Format,'pdf'),
    self.FigureProperties.PaperSize = self.FigureProperties.PaperPosition([3,4]);
end

if ~isfield(self.FigureProperties,'PaperUnits'),
    self.FigureProperties.PaperUnits = self.DefaultPaperUnits;
end
if ~isfield(self.FigureProperties,'PaperPosition'),
    self.FigureProperties.PaperPosition = self.DefaultPaperPosition;
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

% End of file: setPropertyValues.m
