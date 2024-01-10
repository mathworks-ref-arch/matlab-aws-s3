classdef UploadResult < aws.Object
    % UploadResult Contains information returned by Amazon S3 for a completed upload
    %
    % Example:
    %   tmb = aws.s3.transfer.TransferManagerBuilder();
    %   tmb.setS3Client(s3);
    %   tm = tmb.build();
    %   upload = tm.upload(bucketName, keyName, localPath);
    %   uploadResult = upload.waitForUploadResult();

    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = UploadResult(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.transfer.model.UploadResult')
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

        function key = getKey(obj)
            % GETKEY Returns the key by which the newly created object is stored
            key = char(obj.Handle.getKey());
        end

        function bucketName = getBucketName(obj)
            % GETBUCKETNAME Returns the name of the bucket containing the uploaded object
            bucketName = char(obj.Handle.getBucketName());
        end

        function etag = getETag(obj)
            % GETETAG Returns the entity tag identifying the new object
            etag = char(obj.Handle.getETag());
        end

        function versionId = getVersionId(obj)
            % GETVERSIONID Returns the version ID of the new object
            versionId = char(obj.Handle.getVersionId());
        end
    end
end
