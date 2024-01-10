classdef MultipleFileUpload < aws.s3.transfer.Transfer
    % MULTIPLEFILEUPLOAD Multiple file upload of an entire virtual directory
    %
    % Example:
    %   tmb = aws.s3.transfer.TransferManagerBuilder();
    %   tmb.setS3Client(testCase.s3);
    %   tm = tmb.build();
    %   multipleFileUpload = tm.uploadDirectory(bucketName, virtualDirectoryKeyPrefix, directory, includeSubdirectories);
    %   multipleFileUpload.waitForCompletion();

    % Copyright 2023 The MathWorks, Inc.

    methods
       
        function obj = MultipleFileUpload(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.transfer.MultipleFileUpload') || isa(varargin{1}, 'com.amazonaws.services.s3.transfer.internal.MultipleFileUploadImpl')
                    obj.Handle = varargin{1};
                else
                    logObj = Logger.getLogger();
                    write(logObj,'error','Invalid argument type');
                end
            else
                logObj = Logger.getLogger();
                write(logObj,'error','Invalid number of arguments');
            end
        end


        function bucketName = getBucketName(obj)
            % GETBUCKETNAME Returns the name of the bucket to which files are uploaded
            bucketName = char(obj.Handle.getBucketName());
        end


        function keyPrefix = getKeyPrefix(obj)
            % GETKEYPREFIX Returns the key prefix of the virtual directory being uploaded
            keyPrefix = char(obj.Handle.getKeyPrefix());
        end
    end
end