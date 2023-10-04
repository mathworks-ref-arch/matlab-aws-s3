classdef ObjectMetadata < aws.Object
    % ObjectMetadata Represents the object metadata that is stored with S3
    % This includes custom user-supplied metadata, as well as the standard HTTP
    % headers that Amazon S3 sends and receives (Content-Length, ETag,
    % Content-MD5, etc.).
    %
    % Example
    %   s3 = aws.s3.Client();
    %   s3.useCredentialsProviderChain = false;
    %   s3.initialize();
    %
    %   myBucket = 'mb-testbucket-deleteme';
    %   myKey = 'myobjectkey';
    %   s3.createBucket('mb-testbucket-deleteme');
    %   SampleData = rand(100);
    %   save SampleData SampleData;
    %
    %   myMetadata = aws.s3.ObjectMetadata();
    %   myMetadata.addUserMetadata('myMDKey1', 'myMDValue1');
    %   myMetadata.addUserMetadata('myMDKey2', 'myMDValue2');
    %   myMetadata.addUserMetadata('myMDKey3', 'myMDValue3');
    %
    %   s3.putObject(myBucket, 'SampleData.mat', myKey, myMetadata);
    %   myDownloadedMetadata = s3.getObjectMetadata(myBucket, myKey);
    %   myMap = myDownloadedMetadata.getUserMetadata();
    %   % note keys are returned in lower case
    %   myMap('mymdkey1')
    %   ans =
    %        'myMDValue1'
    %   keys(myMap)
    %   ans =
    %     1x4 cell array
    %       {'com-mathworks-matlabobject'}    {'mymdkey1'}    {'mymdkey2'}    {'mymdkey3'}
    %   values(myMap)
    %   ans =
    %     1x4 cell array
    %       {'file'}    {'myMDValue1'}    {'myMDValue2'}    {'myMDValue3'}
    %
    
    % Copyright 2018-2023 The MathWorks, Inc.

    methods
        function obj = ObjectMetadata(varargin)            
            if nargin == 0
                obj.Handle = com.amazonaws.services.s3.model.ObjectMetadata();
            elseif nargin == 1 && isa(varargin{1}, 'com.amazonaws.services.s3.model.ObjectMetadata')
                obj.Handle = varargin{1};
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid arguments');
            end
        end %function
    end %methods
end %class
