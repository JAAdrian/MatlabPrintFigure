function [caszVector,caszBitmap] = readSupportedFormats(self)
%READSUPPORTEDFORMATS <purpose in one line!>
% -------------------------------------------------------------------------
% <Detailed description of the function>
%
% Usage: [caszVector,caszBitmap] = readSupportedFormats(self)
%
%   Input:   ---------
%
%  Output:   ---------
%
%
% Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date   :  20-Sep-2015 22:31:27
% Updated:  <>
%


stFormats = parsejson(fileread(fullfile(self.ClassFolder,'suppformats.json')));

caszVector = stFormats.Vector.';
caszBitmap = stFormats.Bitmap.';



% End of file: readSupportedFormats.m
