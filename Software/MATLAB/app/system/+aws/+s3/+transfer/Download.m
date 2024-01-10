classdef Download < aws.s3.transfer.AbortableTransfer
    % DOWNLOAD Represents an asynchronous download from Amazon S3
    % A aws.s3.transfer.Download is returned created using a
    % aws.s3.transfer.TransferManager.download call.
    %
    % Example:
    %   tmb = aws.s3.transfer.TransferManagerBuilder();
    %   tmb.setS3Client(s3);
    %   tm = tmb.build();
    %   download = tm.download(bucketName, keyName, localPath);
    %   download.waitForCompletion();
    %
    %   % Download can also be called using a aws.s3.model.GetObjectRequest
    %   download = tm.download(getObjectRequest, localPath);
    %   download.waitForCompletion();

    
    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = Download(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.transfer.Download')
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


        function delete(obj)
            if ~obj.isDone
                obj.abort();
            end
        end
        

        function bucketName = getBucketName(obj)
            % GETBUCKETNAME The name of the bucket where the object is being downloaded from

            bucketName = char(obj.Handle.getBucketName);
        end


        function key = getKey(obj)
            % GETKEY The key under which this object

            key = char(obj.Handle.getKey);
        end


        function objectMetadata = getObjectMetadata(obj)
            % GETOBJECTMETADATA Returns the ObjectMetadata for the object being downloaded
            
            % TODO move s3.ObjectMetadata to s3.models.ObjectMetadata in a future release
            objectMetadata = aws.s3.ObjectMetadata(obj.Handle.getObjectMetadata);
        end


        function persistableDownload = pause(obj)
            % PAUSE Pause the current download operation
            % Returns the information that can be used to resume the download at a later time.

            persistableDownload = aws.s3.transfer.PersistableDownload(obj.Handle.Pause());
        end
    end
end