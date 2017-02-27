function [] = handleExtraSpace(self)
%HANDLEEXTRASPACE <purpose in one line!>
% -------------------------------------------------------------------------
% <Detailed description of the function>
%
% Usage: [] = handleExtraSpace(self)
%
%   Input:   ---------
%
%  Output:   ---------
%
%
% Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date   :  27-Jan-2016 19:40:18
% Updated:  <>
%


numAxes     = length(self.AxesHandles);
for aaAxes = 1:numAxes,
    szUnit = get(self.AxesHandles(aaAxes),'Units');
    set(self.AxesHandles(aaAxes),'Units','normalized');
    
    
    vPosition = get(self.AxesHandles(aaAxes),'Position');
    
    set(self.AxesHandles(aaAxes),'Position',[...
        vPosition(1) + self.ExtraSpace(1),...
        vPosition(2) + self.ExtraSpace(2),...
        vPosition(3) + self.ExtraSpace(3),...
        vPosition(4) + self.ExtraSpace(4)...
        ]...
        );

    
    set(self.AxesHandles(aaAxes),'Units',szUnit);
end



% End of file: handleExtraSpace.m
