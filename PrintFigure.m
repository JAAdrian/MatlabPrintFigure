classdef PrintFigure < handle
%PrintFigure A Class for Easy and Reproducible Figure Formatting And Printing in MATLAB
% -------------------------------------------------------------------------
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
% Date   :  26-Jun-2015 17:54:58
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
    
    DefaultProfile = 'default';
    
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
%HandleFigure Handle to the desired Figure
    % Handle to the figure which has either been passed to the constructor
    % or acquired by 'gcf'
    HandleFigure;
end


properties (Access = public)
%Profile Profile of the Format Settings which are to be Applied to the Figure
    % String of the profile's filename (e.g. 'paper'). The profile must be
    % located in the 'profiles' directory in the class as a json file. See
    % README.md for further reading.
    Profile;
    
%Format File Format in which the Figure should be Saved
    % String containing the file format (without the dot!). Defaults to
    % 'pdf'. See README.md for further reading.
    Format     = 'pdf';
    
%Resolution Resolution of the File if a Bitmap Graphic is Desired
    % Integer for the resolution of a bitmap graphic in dpi (dots per
    % inch). See README.md for further reading.
    Resolution = 200;
end



methods
    function self = PrintFigure(hFigure)
        % PrintFigure Instantiate the object for the PrintFigure class
        
        if nargin,
            if isgraphics(hFigure,'figure'),
                self.HandleFigure = hFigure;
            else
                error(['Argument not recognized! Pass a valid handle to ',...
                    'an existing figure']);
            end
        else
            self.HandleFigure = gcf;
        end

        % lock the figure to prevent it from being closed
        lock(self);
        
        % get all handles
        getChildrenHandles(self)
        
        % apply default profile right away
        self.Profile = self.DefaultProfile;
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
        if isgraphics(self.HandleFigure,'figure'),
            set(self.HandleFigure,'CloseRequestFcn','closereq');
        end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% setter/getter methods %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [] = set.Profile(self,szProfile)
        stProfileFiles = listFiles(fullfile(self.ClassFolder,'profiles'),...
            '*.json',0); %#ok<MCSUP>
        caszProfileNames = {stProfileFiles.name};
        
        caszProfileNames = removeFileparts(caszProfileNames);
        
        if strcmpi(szProfile,'help') || isempty(szProfile),
            caIdx = strfind(caszProfileNames,self.DefaultProfile);
            idx   = find(~cellfun(@isempty,caIdx));
            caszProfileNames = [caszProfileNames(idx) caszProfileNames];
            caszProfileNames(idx+1) = [];
            
            printdefaults('Profile',caszProfileNames{:});
        else
            assert(ismember(szProfile,caszProfileNames),sprintf(['Make sure to use ',...
                'an available profile for formatting the figure!\n',...
                'See obj.Profile = ''help'' for a list of available profiles']));
            
            self.Profile = szProfile;
            
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
        assert(iResolution >0, 'Pass a value greater than zero for the resolution!');
        assert(rem(iResolution,1) == 0, 'Pass an integer value for the resolution!');
        
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
    fixPSlinestyle(varargin);
    
    stProps = parsejson(szJsonString);
    stFiles = listFiles(szCurDir,szFileMask,iRecursionDepth);
    map     = paruly(n);
end


end





function printdefaults(varargin)


szDefaultsString = sprintf('''%s'' Options:\n{''%s''} |',varargin{1},varargin{2});

for aaArg = 3:nargin,
    szDefaultsString = sprintf('%s ''%s'' |',szDefaultsString,varargin{aaArg});
    
    if ~mod(aaArg,9),
        szDefaultsString = sprintf('%s\n',szDefaultsString);
    end
end
szDefaultsString = [szDefaultsString(1:end-1), '\n'];

fprintf(szDefaultsString);

end


function [caszOutNames] = removeFileparts(caszInNames)

numNames = length(caszInNames);

caszOutNames = cell(size(caszInNames));
for aaName = 1:numNames,
    [dummy,szName] = fileparts(caszInNames{aaName});
    
    caszOutNames{aaName} = szName;
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
