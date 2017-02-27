function [] = parula(self)
%Apply the Parula colormap to the figure
% -------------------------------------------------------------------------
%
% Usage: [] = parula(self)
%
%   Input:   ---------
%
%  Output:   ---------
%
%
% Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date   :  17-Jun-2015 15:56:07
% Updated:  <>
%



% if exist('parula','file'),
if using_hg2(self.HandleFigure),
    colormap(self.HandleFigure,parula);
else
    % different implementation if MATLAB version < R2014b
    colormap(self.HandleFigure,paruly);
end





% End of file: parula.m
