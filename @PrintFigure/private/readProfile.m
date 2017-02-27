function [stProfile] = readProfile(szPath,szProfile)
%READPROFILE <purpose in one line!>
% -------------------------------------------------------------------------
% <Detailed description of the function>
%
% Usage: [y] = readProfile(input)
%
%   Input:   ---------
%
%  Output:   ---------
%
%
% Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date   :  23-Jun-2015 15:43:15
% Updated:  <>
%


szProfileFile = fullfile(szPath,'profiles',[szProfile, '.json']);

stProfile = parsejson(fileread(szProfileFile));
