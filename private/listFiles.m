%LISTFILES List all files of directory and its sub-directories.
%   LISTFILES('directory_name') lists the files in a directory and its
%   sub-directories up to a depth of four sub-directories. Pathnames
%   and wildcards may be used.
%   For example, LISTFILES('directory_name', '*.m') lists all the M-files
%   in the current directory and its sub-directories up to a depth of four
%   sub-directories.
%   LISTFILES('directory_name', '*.m', 6) lists the files of a directory
%   and its sub-directories up to a depth of six sub-directories. Whereas
%   LISTFILES('directory_name', '*.m',-1) lists the files of all existing
%   sub-directories with infinite recursion. The default recursion depth
%   is to list files of up to four sub-directories.
%
%   D = LISTFILES('directory_name') returns the results in an M-by-1
%   structure with the fields: 
%       name  -- filename (incl. the 'directory_name' path)
%       date  -- modification date
%       bytes -- number of bytes allocated to the file
%       isdir -- 1 if name is a directory and 0 if not
%
%   See also DIR.

% Auth: Sven Fischer
% Vers: v0.8
function [ stFileList ] = listFiles(szCurDir, szFileMask, iRecursionDepth)

%-------------------------------------------------------------------------%
% Check input arguments.
error(nargchk(0,3,nargin));
% Check output arguments.
error(nargoutchk(0,1,nargout));
%-------------------------------------------------------------------------%

%-------------------------------------------------------------------------%
% Check function arguments and set default values, if necessary.
%-------------------------------------------------------------------------%
if( (nargin<1) || (isempty(szCurDir       )) ), szCurDir        =  ''; end
if( (nargin<2) || (isempty(szFileMask     )) ), szFileMask      = '*'; end
if( (nargin<3) || (isempty(iRecursionDepth)) ), iRecursionDepth =   4; end
%-------------------------------------------------------------------------%

stFileList = dir( fullfile( szCurDir, szFileMask ) );
stFileList = stFileList( find( ~[stFileList.isdir] ) );
for( k = [ 1 : length(stFileList) ] )
  stFileList(k).name = fullfile( szCurDir, stFileList(k).name );
end

% If we have to process sub-directories recursively...
if( (iRecursionDepth > 0) || (iRecursionDepth == -1) )
    % Decrease recursion counter by one, if not set to infinite...
    if( iRecursionDepth > 0 ), iRecursionDepth = iRecursionDepth - 1; end

    % Get a list of all existing sub-directories (exclusive '.' and '..').
    stSubDirs = dir( szCurDir );
    stSubDirs = stSubDirs( find( [stSubDirs.isdir] ) );
    if( strcmp(stSubDirs(1).name,  '.') ), stSubDirs(1) = []; end
    if( strcmp(stSubDirs(1).name, '..') ), stSubDirs(1) = []; end
    
    % Process all subdirectories and append all each file list to the
    % list created above.
    for( k = [ 1 : length(stSubDirs) ] )
      szSubDir = fullfile( szCurDir, stSubDirs(k).name);
      stFileList = [ stFileList; ...
          listFiles( szSubDir, szFileMask, iRecursionDepth) ];
    end
end
