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
% Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date   :  17-Jun-2015 15:55:26
% Updated:  <>
%



set(self.HandleFigure,'PaperUnits',self.DefaultPaperUnits);

setPropertyValues(self);

% get all "children", ie. categories like 'axes' or 'figure', etc.
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
                
                if all(isprop(self.HandleFigure,caszProperties{bbProperty})),
                    set(self.HandleFigure, caszProperties{bbProperty}, currVal);
                end
            end
            
        case 'axes',
            for bbProperty = 1:numProperties,
                currVal = self.FigureProperties.(caszChildrenNames{aaChild}).(caszProperties{bbProperty});
                
                if iscell(currVal), currVal = cell2mat(currVal);    end
                
                if all(isprop(self.AxesHandles,caszProperties{bbProperty})),
                    set(self.AxesHandles, caszProperties{bbProperty}, currVal);
                end
            end
            
        case 'line',
            for bbProperty = 1:numProperties,
                currVal = self.FigureProperties.(caszChildrenNames{aaChild}).(caszProperties{bbProperty});
                
                if iscell(currVal), currVal = cell2mat(currVal);    end
                
                for ccHandle = 1:length(self.PlotHandles),
                    if isprop(self.PlotHandles(ccHandle),caszProperties{bbProperty}),
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
                
                if all(isprop(self.LabelHandles,caszProperties{bbProperty})),
                    set(self.LabelHandles, caszProperties{bbProperty}, currVal);
                end
            end
            
        case 'title',
            for bbProperty = 1:numProperties,
                currVal = self.FigureProperties.(caszChildrenNames{aaChild}).(caszProperties{bbProperty});
                
                if iscell(currVal), currVal = cell2mat(currVal);    end
                
                if all(isprop(self.LabelHandles,caszProperties{bbProperty})),
                    set(self.LabelHandles, caszProperties{bbProperty}, currVal);
                end
            end
            
        case 'legend'
            for bbProperty = 1:numProperties,
                currVal = self.FigureProperties.(caszChildrenNames{aaChild}).(caszProperties{bbProperty});
                
                if iscell(currVal), currVal = cell2mat(currVal);    end
                
                if all(isprop(self.LegendHandles,caszProperties{bbProperty})),
                    set(self.LegendHandles, caszProperties{bbProperty}, currVal);
                end
            end
    end
end
    
self.bProfileSet = true;

% seems awkward, but wait a bit to let all properties have effect.
% Some times, the papersize doesn't get applied when printed but maybe this
% isn't the root of the problem
pause(0.5);



% End of file: update.m
