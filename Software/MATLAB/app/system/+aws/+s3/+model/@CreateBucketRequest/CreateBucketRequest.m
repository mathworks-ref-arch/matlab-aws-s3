classdef CreateBucketRequest < aws.Object
    % CREATEBUCKETREQUEST Provides options for creating an Amazon S3 bucket
    %
    % Example;
    %    s3 = aws.s3.Client();
    %    s3.initialize();
    %    createBucketRequest = aws.s3.model.CreateBucketRequest('myBucketName');
    %    createBucketRequest.setCannedAcl(aws.s3.CannedAccessControlList('BucketOwnerFullControl'));
    %    s3.createBucket(createBucketRequest);

    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = CreateBucketRequest(varargin)

            logObj = Logger.getLogger();

            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.model.CreateBucketRequest')
                    obj.Handle = varargin{1};
                elseif ischar(varargin{1})
                    obj.Handle = com.amazonaws.services.s3.model.CreateBucketRequest(varargin{1});
                else
                    write(logObj,'error', 'Expected argument of type com.amazonaws.services.s3.model.CopyObjectResult or character vector');
                end
            elseif nargin == 2
                if ischar(varargin{1}) && ischar(varargin{2}) % bucket name and region 
                    obj.Handle = com.amazonaws.services.s3.model.CreateBucketRequest(varargin{1}, varargin{2});
                else
                    write(logObj,'error', 'Expected arguments of type character vector');
                end
            else
                write(logObj,'error','Invalid number of arguments');
            end
        end %function
    end %methods

end %class