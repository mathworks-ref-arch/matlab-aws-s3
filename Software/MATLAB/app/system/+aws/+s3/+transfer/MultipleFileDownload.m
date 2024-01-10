classdef MultipleFileDownload < aws.s3.transfer.Transfer
    % MULTIPLEFILEDOWNLOAD Multiple file download of an entire virtual directory
    %
    % Example:
    %   tmb = aws.s3.transfer.TransferManagerBuilder();
    %   tmb.setS3Client(testCase.s3);
    %   tm = tmb.build();
    %   multipleFileDownload = tm.downloadDirectory(bucketName, virtualDirectoryKeyPrefix, downloadDirectory);
    %   multipleFileDownload.waitForCompletion();

    % Copyright 2023 The MathWorks, Inc.

    methods
       
        function obj = MultipleFileDownload(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.transfer.MultipleFileDownload') || isa(varargin{1}, 'com.amazonaws.services.s3.transfer.internal.MultipleFileDownloadImpl')
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
            % GETBUCKETNAME Returns the name of the bucket from which files are downloaded
            bucketName = char(obj.Handle.getBucketName());
        end


        function keyPrefix = getKeyPrefix(obj)
            % GETKEYPREFIX Returns the key prefix of the virtual directory being downloaded
            keyPrefix = char(obj.Handle.getKeyPrefix());
        end
    end
end