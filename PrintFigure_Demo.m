% This is a demo file for the PrintFigure class
%
% Author :  J.-A. Adrian (JA) <jensalrik.adrian AT gmail.com>
% Date   :  06-Sep-2015 18:59:20
% Updated:  <>

clear;
close all;

hf = figure;
imagesc(peaks); hold on;
plot(peaks);
colorbar;
legend('hello');
xlabel('x label');
ylabel('y label');

obj = PrintFigure(hf);
% or
% obj = PrintFigure();





%% apply profile

obj.Profile = 'paper';
% obj.Profile = 'presentation';




%% apply different colormap

obj.viridis;
% obj.parula;  % <- for older MATLABs which do not come with this colormap
               %    an alternative implementation is used




%% set file format and print

szFilename = 'testfile';

% obj.Format = 'pdf';
obj.Format = 'png';

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




% End of file: PrintFigure_Demo.m
