function [] = setPropertyValues(self)
%SETPROPERTYVALUES read the properties and set defaults if they're not set
% -------------------------------------------------------------------------
%
% Usage: [] = setPropertyValues(self)
%
%   Input:   ---------
%
%  Output:   ---------
%
%
% Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date   :  17-Jun-2015 16:16:35
% Updated:  <>
%

self.FigureProperties = readProfile(fullfile(self.PathToProfile,[self.Profile, '.json']));

self.FigureProperties.figure.PaperSize = get(self.HandleFigure,'PaperSize');

if ~isfield(self.FigureProperties.figure,'PaperUnits'),
    self.FigureProperties.figure.PaperUnits = self.DefaultPaperUnits;
end

self.FigureProperties.figure.PaperPositionMode = 'manual';
if ~isfield(self.FigureProperties.figure,'PaperPosition'),
    self.FigureProperties.figure.PaperPosition = self.DefaultPaperPosition;
end

if strcmp(self.Format,'pdf'),
    self.FigureProperties.figure.PaperSize = self.FigureProperties.figure.PaperPosition([3,4]);
end



end


function [stProfile] = readProfile(szProfile)
stProfile = parsejson(fileread(szProfile));
end



% End of file: setPropertyValues.m
