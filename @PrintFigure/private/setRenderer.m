function [] = setRenderer(self)
%SETRENDERER <purpose in one line!>
% -------------------------------------------------------------------------
% <Detailed description of the function>
%
% Usage: [y] = setRenderer(input)
%
%   Input:   ---------
%
%  Output:   ---------
%
%
% Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date   :  28-Jul-2015 13:38:41
% Updated:  <>
%


if ismember(self.Format,self.VectorFormats),
    self.Renderer = 'painters';
elseif ismember(self.Format,self.BitmapFormats),
    self.Renderer = 'opengl';
else
    error('An error occured setting the correct renderer');
end
