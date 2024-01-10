classdef CopyResult < aws.Object
    % COPYRESULT Contains information returned by Amazon S3 for a completed copy
    %
    % Example:
    %  tmb = aws.s3.transfer.TransferManagerBuilder();
    %  tmb.setS3Client(s3);
    %  tm = tmb.build();
    %  copy = tm.copy(sourceBucketName, sourceKeyName, destinationBucketName, destinationKeyName);
    %  copyResult = copy.waitForCopyResult();

    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = CopyResult(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.transfer.model.CopyResult')
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


        function key = getDestinationBucketName(obj)
            % GETDESTINATIONBUCKETNAME Gets the destination bucket name which will contain the new, copied object
            key = char(obj.Handle.getDestinationBucketName());
        end


        function key = getDestinationKey(obj)
            % GETDESTINATIONKEY Gets the destination bucket key under which the new, copied object will be stored
            key = char(obj.Handle.getDestinationKey());
        end

       
        function etag = getETag(obj)
            % getETag Returns the entity tag identifying the new object
            etag = char(obj.Handle.getETag());
        end
        
        
        function key = getSourceKey(obj)
            % GETSOURCEKEY Gets the source bucket key under which the source object to be copied is stored
            key = char(obj.Handle.getSourceKey());
        end


        function versionId = getVersionId(obj)
            % GETVERSIONID Returns the version ID of the new object
            % The version ID is only set if versioning has been enabled for the bucket.
            versionId = char(obj.Handle.getVersionId());
        end

    end
end
