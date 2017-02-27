function [] = getChildrenHandles(self)
%GETCHILDRENHANDLES <purpose in one line!>
% -------------------------------------------------------------------------
% <Detailed description of the function>
%
% Usage: [y] = getChildrenHandles(input)
%
%   Input:   ---------
%
%  Output:   ---------
%
%
% Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date   :  17-Jun-2015 16:16:02
% Updated:  <>
%



self.AxesHandles   = cell2array(findobj(self.HandleFigure,...
    'Type','axes','-and','-not','tag','legend'));
self.PlotHandles   = cell2array(get(self.AxesHandles,'Children'));

self.TitleHandles  = cell2array(get(self.AxesHandles,'Title'));

vXLabelHandles     = cell2array(get(self.AxesHandles,'XLabel'));
vYLabelHandles     = cell2array(get(self.AxesHandles,'YLabel'));
self.LabelHandles  = [vXLabelHandles,vYLabelHandles];

self.LegendHandles = cell2array(findobj(self.HandleFigure,'tag','legend'));

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


% End of file: getChildrenHandles.m
