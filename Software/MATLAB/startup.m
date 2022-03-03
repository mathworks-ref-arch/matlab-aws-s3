function startup(varargin)
%% STARTUP - Script to add my paths to MATLAB path
% This script will add the paths below the root directory into the MATLAB
% path. It will omit the SVN and other crud.  Modify undesired path
% filters as desired.

% Copyright 2018-2021 The MathWorks, Inc.

% Don't run the startup file if executed from within a deployed function (CTF)
if ~isdeployed()

    %% Check where this tooling exists and compute paths
    % Get the root path for this repo - you will need to modify this if you
    % move this startup file w.r.t. its location in the repo.
    here = fileparts(fileparts(fileparts(mfilename('fullpath'))));

    %% Add a banner to the top
    iDisplayBanner('MATLAB Interface for Amazon S3');

    %% Check if the dependencies are in place
    iDisplayBanner('Checking if dependencies are met');
    iCheckDependencies(here);

    %% Update MATLAB paths
    iDisplayBanner('Adding MATLAB Paths');

    %% Add the common utilities to the path
    iAddCommonUtilities(here);

    %% Add the S3 interface to the path
    iAddS3(here);

    %% Update the Java class paths
    iAddJar(here);

    %% Create logger singleton
    iCreateLoggerSingleton();
end

end

function iCheckDependencies(rootDir)

% Check if the common utilities exist otherwise raise and error and stop
commonDir = fullfile(fileparts(rootDir),'matlab-aws-common');

if ~exist(commonDir, 'dir')
    % Cannot find the dependencies
    error('AWS:S3',['Could not locate common utilities at: ',commonDir]);
end

% Check if the JAR file exists
commonJarPath = fullfile(commonDir,'Software','MATLAB','lib','jar','aws-sdk-0.1.0.jar');
jarPath = fullfile(rootDir,'Software','MATLAB','lib','jar','aws-sdk-0.1.0.jar');
if ~exist(commonJarPath,'file') && ~exist(jarPath,'file')
    error('AWS:S3','Could not locate jar file at: %s or %s',jarPath, commonJarPath);
end


end


function iAddCommonUtilities(rootDir)

% Check if the common utilities exist otherwise raise and error and stop
commonDir = fullfile(fileparts(rootDir),'matlab-aws-common');
startUpFile = fullfile(commonDir,'Software','MATLAB','startup.m');

run(startUpFile);
end


function iAddS3(rootDir)
iDisplayBanner('Adding MATLAB interface for Amazon S3 Paths');

s3Dir = fullfile(rootDir,'Software','MATLAB');
rootDirs={fullfile(s3Dir,'app'),true;...
    fullfile(s3Dir,'lib'),false;...
    fullfile(s3Dir,'sys','modules'),true;...
    fullfile(s3Dir,'public'),true;...
    };

%% Add the tooling to the path
iAddFilteredFolders(rootDirs);

end

%% Add the JAR to the MATLAB path
function iAddJar(rootDir)

disp('Updating the Java classpath:');
jarPath = fullfile(rootDir,'Software','MATLAB','lib','jar');
tmp = fullfile(jarPath,'aws-sdk-0.1.0.jar');
jarFiles = dir(tmp);

for jCount = 1:numel(jarFiles)
    iSafeAddToJavaPath(fullfile(jarPath,jarFiles(jCount).name));
end

end

%% iAddFilteredFolders Helper function to add all folders to the path
function iAddFilteredFolders(rootDirs)
% Loop through the paths and add the necessary subfolders to the MATLAB path
for pCount = 1:size(rootDirs,1)

    rootDir=rootDirs{pCount,1};
    if rootDirs{pCount,2}
        % recursively add all paths
        rawPath=genpath(rootDir);

        if ~isempty(rawPath)
            rawPathCell=textscan(rawPath,'%s','delimiter',pathsep);
            rawPathCell=rawPathCell{1};
        end

    else
        % Add only that particular directory
        rawPath = rootDir;
        rawPathCell = {rawPath};
    end

    % if rawPath is empty then we have an entry in rootDir that does not
    % exist on the path so we should not try to add an entry for them
    if ~isempty(rawPath)

        % remove undesired paths
        svnFilteredPath=strfind(rawPathCell,'.svn');
        gitFilteredPath=strfind(rawPathCell,'.git');
        slprjFilteredPath=strfind(rawPathCell,'slprj');
        sfprjFilteredPath=strfind(rawPathCell,'sfprj');
        rtwFilteredPath=strfind(rawPathCell,'_ert_rtw');

        % loop through path and remove all the .svn entries
        if ~isempty(svnFilteredPath)
            for pCount=1:length(svnFilteredPath) %#ok<FXSET>
                filterCheck=[svnFilteredPath{pCount},...
                    gitFilteredPath{pCount},...
                    slprjFilteredPath{pCount},...
                    sfprjFilteredPath{pCount},...
                    rtwFilteredPath{pCount}];
                if isempty(filterCheck)
                    iSafeAddToPath(rawPathCell{pCount});
                else
                    % ignore
                end
            end
        else
            iSafeAddToPath(rawPathCell{pCount});
        end
    end
end

end

%% Helper function to add to MATLAB path.
function iSafeAddToPath(pathStr)

% Add to path if the file exists
if exist(pathStr,'dir')
    disp(['Adding ',pathStr]);
    addpath(pathStr);
else
    disp(['Skipping ',pathStr]);
end

end

%% Helper function to add to the Dynamic Java classpath
function iSafeAddToJavaPath(pathStr)

% Check the current java path
jPaths = javaclasspath('-dynamic');

% Add to path if the file exists
if exist(pathStr,'dir')||exist(pathStr,'file')
    jarFound = any(strcmpi(pathStr, jPaths));
    if isempty(jarFound)
        jarFound = false;
    end

    if ~jarFound
        disp(['Adding ',pathStr]);
        javaaddpath(pathStr);
    else
        disp(['Skipping: ',pathStr]);
    end
else
    disp(['Skipping ',pathStr]);
end

end

%% HELPER function to create a banner
function iDisplayBanner(appStr)
    disp(appStr);
    disp(repmat('-',1,numel(appStr)));
end

function iCreateLoggerSingleton()

%% Create the logger
% Get the logger object - a singleton (one logger per MATLAB session)
logObj = Logger.getLogger;
% Adjust the log levels
logObj.LogFileLevel = 'warning';
logObj.DisplayLevel = 'debug';

end
