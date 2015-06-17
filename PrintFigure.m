classdef PrintFigure < handle
%PRINTFIGURE <purpose in one line!>
% -------------------------------------------------------------------------
% <Detailed description of the function>
% 
% PrintFigure Properties:
%	propA - <description>
%	propB - <description>
% 
% PrintFigure Methods:
%	doThis - <description>
%	doThat - <description>
% 
% Author :  J.-A. Adrian (JA) <jens-alrik.adrian AT jade-hs.de>
% Date   :  15-Jun-2015 17:54:58
% Updated:  <>
% 


properties (Constant, Hidden)
    caszPossibleFormatsBitmap = {...
        'jpeg',...
        'png',...
        'tiff',...
        'tiffn',...
        'bmpmono',...
        'bmp',...
        'bmp16m',...
        'bmp256',...
        'hdf',...
        'pbm',...
        'pbmraw',...
        'pcxmono',...
        'pcx24b',...
        'pcx256',...
        'pcx16',...
        'pgmraw',...
        'ppm',...
        'ppmraw',...
        };
    
    caszPossibleFormatsVector = {...
        'pdf',... <- must be at this position!
        'eps',...
        'epsc',...
        'eps2',...
        'epsc2',...
        'svg',...
        'ps',...
        'psc',...
        'ps2',...
        'psc2',...
        'meta',...
        };
    
    caszBadPlotTypes = {'histogram','image'};
    
    DefaultType = 'paper';
    
    DefaultPaperUnits    = 'centimeters';
    DefaultPaperPosition = [0 0 21 13];
end

properties (Access = private)
    AxesHandles;
    PlotHandles;
    TitleHandles;
    LabelHandles;
    LegendHandles;
    
    FigureProperties = struct();
    
    
    % variable in which the figure is saved if the object should be saved
    SavedFigureFile;
end

properties ( Access = private, Dependent)
    ClassFolder;
end


properties (SetAccess = private, GetAccess = public)
    HandleFigure;
end


properties (Access = public)
    Type;
    Format     = 'pdf';
    Resolution = 200;
end



methods
    function self = PrintFigure(hFigure)
        if nargin,
            if ishandle(hFigure),
                self.HandleFigure = hFigure;
            else
                error(['Argument not recognized! Pass a valid handle to ',...
                    'an existing figure']);
            end
        else
            self.HandleFigure = gcf;
        end

        lock(self);
        
        % get all handles
        getChildrenHandles(self)
        
        self.Type = self.DefaultType;
    end

    update(self);
    applyParulaMap(self);
    print(self,szFilename);
    saveFigure(self,szFilename);
    loadFigure(self);
    lock(self);
    release(self);
    close(self);
    
    function delete(self)
        if ishandle(self.HandleFigure),
            set(self.HandleFigure,'CloseRequestFcn','closereq');
        end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% setter/getter methods %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [] = set.Type(self,szType)
        stProfileFiles = listFiles(fullfile(self.ClassFolder,'profiles'),...
            '*.json',0); %#ok<MCSUP>
        caszProfileNames = {stProfileFiles.name};
        
        caszProfileNames = removeFileparts(caszProfileNames);
        
        if strcmpi(szType,'help') || isempty(szType),
            caIdx = strfind(caszProfileNames,self.DefaultType);
            idx   = find(~cellfun(@isempty,caIdx));
            caszProfileNames = [caszProfileNames(idx) caszProfileNames];
            caszProfileNames(idx+1) = [];
            
            printdefaults('Type',caszProfileNames{:});
        else
            assert(ismember(szType,caszProfileNames),sprintf(['Make sure to use ',...
                'an available type profile for formatting the figure!\n',...
                'See obj.Type = ''help''; for a list of available type profiles']));
            
            self.Type = szType;
            
            update(self);
        end
    end
    
    function [] = set.Format(self,szFormat)
        caszAllFormats = [self.caszPossibleFormatsVector, self.caszPossibleFormatsBitmap];
        
        if strcmpi(szFormat,'help') || isempty(szFormat),
            printdefaults('Format',caszAllFormats{:});
        else
            assert(ismember(szFormat,caszAllFormats),sprintf(['Make sure to use ',...
                'a supported format for printing!\n',...
                'See obj.Format = ''help'' for a list of supported formats']));
            
            self.Format = szFormat;
        end
        
    end
    
    function [] = set.Resolution(self,iResolution)
        if iResolution > 600,
            warning('Resolutions of >600 might lead to very large filesizes!');
        end
        assert(iResolution >=0, 'Pass a non-negative value for the resolution!');
        
        self.Resolution = iResolution;
    end
    
    function [szFolder] = get.ClassFolder(self) %#ok<MANU>
        szFolder = which(mfilename);
        szFolder = fileparts(szFolder);
    end
end





methods (Access = private)
    getChildrenHandles(self);
    setPropertyValues(self);
    CloseReqFun(self);
    fixPSlinestyle(varargin);
    
    stProps      = parsejson(szJsonString);
    stFiles      = listFiles(szCurDir,szFileMask,iRecursionDepth);
    Array        = cell2array(caCell);
    map          = paruly(n);
    caszOutNames = removeFileparts(caszInNames);
end


end






%-------------------- Licence ---------------------------------------------
% Copyright (c) 2015, J.-A. Adrian
% Institute for Hearing Technology and Audiology
% Jade University of Applied Sciences
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in the
%       documentation and/or other materials provided with the
%       distribution.
%     * Neither the name of the <organization> nor the
%       names of its contributors may be used to endorse or promote
%       products derived from this software without specific prior written
%       permission.
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

% End of file: PrintFigure.m