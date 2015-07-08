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

set(self.HandleFigure,...
    'PaperUnits',self.FigureProperties.PaperUnits,...
    'PaperPosition',self.FigureProperties.PaperPosition,...
    'PaperPositionMode','manual',...
    'PaperSize',self.FigureProperties.PaperSize...
    );

set(self.AxesHandles,...
    'FontSize',self.FigureProperties.AxesFontSize,...
    'FontName',self.FigureProperties.AxesFontName,...
    'LineWidth',self.FigureProperties.AxisLineWidth,...
    'TickDir',self.FigureProperties.TickDir,...
    'TickLength',self.FigureProperties.TickLength,...
    'Box',self.FigureProperties.Box,...
    'XGrid',self.FigureProperties.XGrid,...
    'YGrid',self.FigureProperties.YGrid,...
    'XColor',self.FigureProperties.XColor,...
    'YColor',self.FigureProperties.YColor,...
    'TickLabelInterpreter',self.FigureProperties.TickLabelInterpreter);

for aaHandle = 1:length(self.PlotHandles),
    if ~strcmpi(get(self.PlotHandles(aaHandle),'Type'),self.caszBadPlotTypes),
        set(self.PlotHandles(aaHandle),...
            'LineWidth',self.FigureProperties.PlotLineWidth,...
            'MarkerSize',self.FigureProperties.MarkerSize);
    end
end

set(self.LabelHandles,...
    'FontName',self.FigureProperties.LabelFontName,...
    'FontSize',self.FigureProperties.LabelFontSize,...
    'Interpreter',self.FigureProperties.Interpreter);
set(self.TitleHandles,...
    'FontName',self.FigureProperties.LabelFontName,...
    'FontSize',self.FigureProperties.LabelFontSize,...
    'Interpreter',self.FigureProperties.Interpreter);

set(self.LegendHandles,...
    'FontSize',self.FigureProperties.LabelFontSize,...
    'EdgeColor',self.FigureProperties.LegendEdgeColor,...
    'Interpreter',self.FigureProperties.Interpreter);

% seems awkward, but wait a bit to let all properties have effect.
% Some times, the papersize doesn't get applied when printed
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
