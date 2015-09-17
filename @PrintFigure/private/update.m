function [] = update(self)
%Apply all properties of the profile to the figure
% -------------------------------------------------------------------------
%
% Usage: [] = update(self)
%
%   Input:   ---------
%
%  Output:   ---------
%
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  17-Jun-2015 15:55:26
% Updated:  <>
%



set(self.HandleFigure,'PaperUnits',self.DefaultPaperUnits);

setPropertyValues(self);

% get all "children", ie. categories like 'axes' or 'figure'
caszChildrenNames = fieldnames(self.FigureProperties);
numChildren       = length(caszChildrenNames);

for aaChild = 1:numChildren,
    % get all defined properties for the current child
    caszProperties = fieldnames(self.FigureProperties.(caszChildrenNames{aaChild}));
    numProperties  = length(caszProperties);
    
    % set the properties by fetching the value and converting cells into
    % array. This stems from parsejson which converts array entries in the
    % json file into cells
    switch caszChildrenNames{aaChild},
        case 'figure',
            for bbProperty = 1:numProperties,
                currVal = self.FigureProperties.(caszChildrenNames{aaChild}).(caszProperties{bbProperty});
                
                if iscell(currVal), currVal = cell2mat(currVal);    end
                
                set(self.HandleFigure, caszProperties{bbProperty}, currVal);
            end
            
        case 'axes',
            for bbProperty = 1:numProperties,
                currVal = self.FigureProperties.(caszChildrenNames{aaChild}).(caszProperties{bbProperty});
                
                if iscell(currVal), currVal = cell2mat(currVal);    end
                
                set(self.AxesHandles, caszProperties{bbProperty}, currVal);
            end
            
        case 'line',
            for bbProperty = 1:numProperties,
                currVal = self.FigureProperties.(caszChildrenNames{aaChild}).(caszProperties{bbProperty});
                
                if iscell(currVal), currVal = cell2mat(currVal);    end
                
                for ccHandle = 1:length(self.PlotHandles),
                    if ~strcmpi(get(self.PlotHandles(ccHandle),'Type'),self.caszBadPlotTypes),
                        set(self.PlotHandles(ccHandle), ...
                            caszProperties{bbProperty}, ...
                            currVal);
                    end
                end
            end
            
        case 'label',
            for bbProperty = 1:numProperties,
                currVal = self.FigureProperties.(caszChildrenNames{aaChild}).(caszProperties{bbProperty});
                
                if iscell(currVal), currVal = cell2mat(currVal);    end
                
                set(self.LabelHandles, caszProperties{bbProperty}, currVal);
            end
            
        case 'legend'
            for bbProperty = 1:numProperties,
                currVal = self.FigureProperties.(caszChildrenNames{aaChild}).(caszProperties{bbProperty});
                
                if iscell(currVal), currVal = cell2mat(currVal);    end
                
                set(self.LegendHandles, caszProperties{bbProperty}, currVal);
            end
    end
end
    
self.bProfileSet = true;

% seems awkward, but wait a bit to let all properties have effect.
% Some times, the papersize doesn't get applied when printed but maybe this
% isn't the root of the problem
pause(0.5);




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

% End of file: update.m
