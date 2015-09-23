function [] = tightFigure(self)
%TIGHTFIGURE
% -------------------------------------------------------------------------
% 
% Usage: [] = tightFigure(self)
% 
%   Input:   ---------
% 
%  Output:   ---------
% 
% 
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  23-Sep-2015 22:14:32
% Updated:  <>
% 

% dirty hack!
% first check if axes labels are set. If not set empty ones
for aaHandle = 1:numel(self.LabelHandles),
    if isempty(get(self.LabelHandles(aaHandle), 'String')),
        set(self.LabelHandles(aaHandle),'String',' ');
        set(self.LabelHandles(aaHandle),'FontSize',1);
    end
end


% This code is adapted from
% http://www.mathworks.com/matlabcentral/fileexchange/34024-get-rid-of-the-white-margin-in-saveas-output/content/saveTightFigure.m

set(self.HandleFigure,'Units','centimeter');

vOrigBottomLeft = get(self.HandleFigure,'Position');
vOrigBottomLeft = vOrigBottomLeft(1:2);

% resize the figure window 
set(self.HandleFigure,'Position',get(self.HandleFigure,'PaperPosition'));

% figure position
boxFigure = get(self.HandleFigure,'position');

x      = 1;
y      = 2;
width  = 3;
height = 4;
xmax   = 3;
ymax   = 4;

% compute the tightest box that includes all axes
boxTightest = [Inf Inf -Inf -Inf]; % left bottom right top
for aaHandle = 1:numel(self.AxesHandles),
    set(self.AxesHandles(aaHandle), 'units', 'centimeters');
    
    boxAxes  = get(self.AxesHandles(aaHandle), 'position');
    boxTight = get(self.AxesHandles(aaHandle), 'tightinset');
    
    % get position and convert to left, bottom, right, top
    boxAxesFixed = ...
        [boxAxes(x), boxAxes(y), boxAxes(x)+boxAxes(width), boxAxes(y)+boxAxes(height)] ...
        + boxTight.*[-1 -1 1 1];
    
    boxTightest(x)    = min(boxTightest(x),    boxAxesFixed(x));
    boxTightest(y)    = min(boxTightest(y),    boxAxesFixed(y));
    boxTightest(xmax) = max(boxTightest(xmax), boxAxesFixed(xmax));
    boxTightest(ymax) = max(boxTightest(ymax), boxAxesFixed(ymax));
end

% convert back to left, bottom, width, height
boxTightest = [...
    boxTightest(x),                   boxTightest(y), ...
    boxTightest(xmax)-boxTightest(x), boxTightest(ymax)-boxTightest(y)];

% move all axes to bottom left
for aaHandle = 1:numel(self.AxesHandles),
    boxAxes = get(self.AxesHandles(aaHandle), 'position');
    
    % this is where the magic happens
    % move to bottom left and adapt the width and height accordingly to
    % prevent the axes to be cropped
    set(self.AxesHandles(aaHandle), 'position', ...
        [
        boxAxes(x) - boxTightest(x), ...
        boxAxes(y) - boxTightest(y), ...
        boxAxes(width)  + boxFigure(width)  - boxTightest(width), ...
        boxAxes(height) + boxFigure(height) - boxTightest(height) ...
        ]);
    
%     set(self.AxesHandles(aaHandle),'ActivePositionProperty','Position');
end

vFigPosition = get(self.HandleFigure,'Position');
set(self.HandleFigure,'Position',[vOrigBottomLeft, vFigPosition(3:4)])





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
%
%	2. Redistributions in binary form must reproduce the above copyright
%	   notice, this list of conditions and the following disclaimer in
%	   the documentation and/or other materials provided with the
%	   distribution.
%
%	3. Neither the name of the copyright holder nor the names of its
%	   contributors may be used to endorse or promote products derived
%	   from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
% TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
% HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
% TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% End of file: tightFigure.m
