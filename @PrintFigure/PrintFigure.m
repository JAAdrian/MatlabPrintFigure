classdef PrintFigure < handle & matlab.System
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
    DefaultPaperUnits    = 'centimeters';
    DefaultPaperPosition = [0 0 21 13];
end

properties ( Transient, Hidden )
    FormatSet   = matlab.system.StringSet(returnFormatsForStringSet());
    RendererSet = matlab.system.StringSet({'opengl','painters'});
end

properties ( Access = private )
    AxesHandles;
    PlotHandles;
    TitleHandles;
    LabelHandles;
    LegendHandles;
    
    FigureProperties = struct();
    
    PathToProfile;
    bProfileSet = false;
    
    % variable in which the figure is saved if the object should be saved
    SavedFigureFile;
end

properties ( Access = private, Dependent, Transient )
    ClassFolder;
    VectorFormats;
    BitmapFormats;
end


properties ( SetAccess = private, GetAccess = public )
%HandleFigure Handle to the desired Figure
    % Handle to the figure which has either been passed to the constructor
    % or acquired by 'gcf'
    HandleFigure;
end


properties ( Access = public )
%Profile Profile of the Format Settings which are to be Applied to the Figure
    % String of the profile's filename (e.g. 'paper'). The profile must be
    % located in the 'profiles' directory in the class as a json file. See
    % README.md for further reading.
    Profile;
    
%Format File Format in which the Figure should be Saved
    % String containing the file format (without the dot!). Defaults to
    % 'pdf'. See README.md for further reading.
    Format = 'pdf';
    
%Resolution Resolution of the File if a Bitmap Graphic is Desired
    % Integer for the resolution of a bitmap graphic in dpi (dots per
    % inch). See README.md for further reading.
    Resolution = 200;
    
%Renderer Renderer of the Printing Engine
    Renderer;
    
%ExtraSpace Stretches axes positions to prevent or introduce white margins when printed
    ExtraSpace = [0, 0, 0, 0];
end




methods
    % class constructor
    function self = PrintFigure(hFigure)
        % PrintFigure Instantiate the object for the PrintFigure class
        
        if nargin,
            assert(length(hFigure) == 1, 'Pass only ONE figure handle!');
            assert(isgraphics(hFigure,'figure'),['Argument not recognized! ',...
                'Pass a valid handle to an existing figure']);
            
            self.HandleFigure = hFigure;
        else
            self.HandleFigure = gcf;
        end
        
        % lock the figure to prevent it from being closed
        lockFigure(self);
        
        % get the current renderer
        setRenderer(self);
        
        % get all handles
        getChildrenHandles(self)
    end
    
    parula(self);
    viridis(self);
    print(self,szFilename,szNoFix);
    saveFigure(self,szFilename);
    loadFigure(self);
    lockFigure(self);
    releaseFigure(self);
    close(self);
    
    % class destructor
    function delete(self)
        if isgraphics(self.HandleFigure,'figure'),
            set(self.HandleFigure,'CloseRequestFcn','closereq');
        end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% setter/getter methods %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [] = set.Profile(self,szProfile)
        [szPath,szProfile,szExt] = fileparts(szProfile);
        if isempty(szExt),
            szExt = '.json';
        end
        self.PathToProfile = szPath; %#ok<MCSUP>
        
        % if the profile is not in pwd, search in the class' profile folder
        if ~exist([self.PathToProfile,szProfile,szExt],'file') && ...
                exist(fullfile(self.ClassFolder, 'profiles',...
                [self.PathToProfile,szProfile,szExt]),'file'), %#ok<MCSUP>
            
            self.PathToProfile = fullfile(self.ClassFolder, 'profiles'); %#ok<MCSUP>
        end
        
        % assert that the file exists
        assert(logical(exist(fullfile(self.PathToProfile,[szProfile,szExt]),'file')),...
            sprintf(['%s.json not found! Make sure that the file exists ',...
            'and the path is correct'],szProfile)); %#ok<MCSUP>
        
        self.Profile = szProfile;
        
        update(self);
    end
    
    function [] = set.Format(self,szFormat)
        self.Format = lower(szFormat);
        
        setRenderer(self);
    end
    
    function [caszFormats] = get.BitmapFormats(self)
        [~,caszFormats] = readSupportedFormats(self);
    end
    
    function [caszFormats] = get.VectorFormats(self)
        [caszFormats] = readSupportedFormats(self);
    end
    
    function [] = set.Resolution(self, resolution)
        classes = {'numeric'};
        attributes = {'scalar', 'nonzero', 'nonnegative', 'integer'};
        validateattributes(resolution, classes, attributes);
        
        if resolution > 600,
            warning('Resolutions of >600 might lead to very large filesizes!');
        end
        
        self.Resolution = resolution;
    end
    
    function [] = set.ExtraSpace(self, extraSpaceIn)
        validateattributes(extraSpaceIn, {'numeric'}, {'vector', 'numel', 4});
        
        self.ExtraSpace = extraSpaceIn;
        handleExtraSpace(self);
    end
    
    
    function [szFolder] = get.ClassFolder(self) %#ok<MANU>
        szFolder = which(mfilename);
        szFolder = fileparts(szFolder);
    end
end

% These methods are mandatory to be able to save and load private/protected
% properties using the superclass matlab.System
methods (Access = protected)
    function s = saveObjectImpl(self)
        % Call the base class method
        s = saveObjectImpl@matlab.System(self);
        
        % Save the protected & private properties
        s.bProfileSet     = self.bProfileSet;
        s.SavedFigureFile = self.SavedFigureFile;
    end
    
    function loadObjectImpl(self,s,wasLocked)
        % Load protected and private properties
        self.bProfileSet     = s.bProfileSet;
        self.SavedFigureFile = s.SavedFigureFile;
        
        % Call base class method to load public properties
        loadObjectImpl@matlab.System(self,s,wasLocked);
    end
end





methods (Access = private)
    getChildrenHandles(self);
    setPropertyValues(self);
    fixPSlinestyle(varargin);
    
    stProps = parsejson(szJsonString);
    stFiles = listFiles(szCurDir,szFileMask,iRecursionDepth);
    map     = paruly(n);
    tf      = using_hg2(fig);
    
    [mOriginalPosition] = handleExtraSpace(self,mOriginalPosition);
    
    [caszVector,caszBitmap] = readSupportedFormats(self);
end

end





function [caszFormats] = returnFormatsForStringSet()
stFormats = parsejson(fileread('suppformats.json'));

caszFormats = [stFormats.Vector, stFormats.Bitmap].';
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
