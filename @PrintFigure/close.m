function [] = close(self)
%Closes the figure
% -------------------------------------------------------------------------
%
% Usage: [] = close(self)
%
%   Input:   ---------
%
%  Output:   ---------
%
%
% Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date   :  17-Jun-2015 16:07:02
% Updated:  <>
%


if isgraphics(self.HandleFigure,'figure'),
    delete(self.HandleFigure);
end




% End of file: close.m
