% <purpose of this file>
%
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  06-Sep-2015 18:59:20
% Updated:  <>

clear;
close all;

hf = figure;
imagesc(peaks);
colorbar;


obj = PrintFigure(hf);
% or
% obj = PrintFigure();





%% apply profile

obj.Profile = 'paper';
% obj.Profile = 'presentation';







%% apply different colormap

obj.viridis;
% obj.parula;  % <- for older MATLABs



%% set file format and print

szFilename = 'testfile';

% obj.Format   = 'pdf';
% obj.Renderer = 'painters';

obj.Format   = 'png';
obj.Renderer = 'opengl';

obj.print(szFilename);




%% special case: eps fix for older MATLAB versions

% hp = get(get(hf,'children'),'children');
% set(hp(1:2:end),'linestyle',':');


% szFix = 'nofix';
%
% obj.Format = 'epsc';
%
% obj.print(szFilename);
% obj.print([szFilename,'_nofix'],szFix);
%
% system(['epstopdf ', [szFilename, '.eps']]);
% system(['epstopdf ', [szFilename, '_nofix.eps']]);





%% save the figure object incl. data and reload to previous state

obj.saveFigure('savedfigureobj');

clear;
close all;

load savedfigureobj;
FigObj.loadFigure;




%% print without profile

hf = figure;
plot(peaks);

obj = PrintFigure(hf);

% disp('Resize the figure...');
% pause;

obj.print('test_noprofile');


%% delete the objects
delete(obj);
delete(FigObj);




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

% End of file: PrintFigure_Demo.m
