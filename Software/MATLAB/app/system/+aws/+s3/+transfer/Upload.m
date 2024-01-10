classdef Upload < aws.s3.transfer.Transfer
    % UPLOAD Represents an asynchronous upload to Amazon S3
    %
    % Example:
    %   tmb = aws.s3.transfer.TransferManagerBuilder();
    %   tmb.setS3Client(testCase.s3);
    %   tm = tmb.build();
    %   upload = tm.upload(testCase.bucketName, keyName, localPath);
    %   result = upload.waitForUploadResult();
    
    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = Upload(varargin)
            if nargin == 1
                if isa(varargin{1}, 'com.amazonaws.services.s3.transfer.TransferManager.Upload') || ....
                   isa(varargin{1}, 'com.amazonaws.services.s3.transfer.internal.UploadImpl')
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


        function abort(obj)
            % ABORT Abort the current upload operation
            obj.Handle.abort();
        end


        function persistableUpload = pause(obj)
            % PAUSE Pause the current upload operation and returns the information that can be used to resume the upload          
            persistableUploadJ = obj.Handle.pause();
            persistableUpload = aws.s3.transfer.PersistableUpload(persistableUploadJ);
        end


        function uploadResult = waitForUploadResult(obj)
            % WAITFORUPLOADRESULT Waits for this upload to complete and returns the result of this upload
            % This is a blocking call. Be prepared to handle errors when calling this method.
            % Any errors that occurred during the asynchronous transfer will be re-thrown through this method
            try
                uploadResultJ = obj.Handle.waitForUploadResult();
                uploadResult = aws.s3.transfer.model.UploadResult(uploadResultJ);
            catch ME
                logObj = Logger.getLogger();
                write(logObj,'warning','Upload error, attempting to cleanup');
                if ~obj.isDone
                    obj.abort();
                end
                rethrow(ME)
            end
        end
    end
end

