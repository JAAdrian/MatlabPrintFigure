function [] = saveFigure(self,szFilename)
%Save the figure and the object in the current state to file
% -------------------------------------------------------------------------
%
% Usage: [] = saveFigure(self,szFilename)
%
%   Input:   ---------
%
%  Output:   ---------
%
%
% Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date   :  17-Jun-2015 15:57:30
% Updated:  <>
%


szFigName = [tempname,'.fig'];
savefig(self.HandleFigure,szFigName);

fid = fopen(szFigName);
self.SavedFigureFile = fread(fid,inf,'uint8',0,'l');
fclose(fid);

self.HandleFigure = [];

FigObj = self;
save(szFilename,'FigObj');
delete(FigObj);



% End of file: saveFigure.m
