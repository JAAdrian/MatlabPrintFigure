function [] = loadFigure(self)
%Load a figure in the state in which it was saved
% -------------------------------------------------------------------------
%
% Usage: [] = loadFigure(self)
%
%   Input:   ---------
%
%  Output:   ---------
%
%
% Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date   :  17-Jun-2015 15:58:15
% Updated:  <>
%


hf = gcf;
if isempty(get(hf,'Children')),
    delete(hf);
end

szFigName = [tempname, '.fig'];

fid = fopen(szFigName,'w');
fwrite(fid,self.SavedFigureFile,'uint8',0,'l');
fclose(fid);

self.HandleFigure = openfig(szFigName);

setRenderer(self);

getChildrenHandles(self);



% End of file: loadFigure.m
