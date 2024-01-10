classdef InitiateMultipartUploadRequest < aws.Object
    % InitiateMultipartUploadRequest 
    %
    % See: aws.s3.transfer.TransferManager for a high-level alternative.

    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = InitiateMultipartUploadRequest(bucketName, key)

            logObj = Logger.getLogger();
            
            if nargin < 2
                write(logObj,'error','Invalid number of arguments');
            elseif ischar(bucketName) && ischar(key)
                obj.Handle = com.amazonaws.services.s3.model.InitiateMultipartUploadRequest(bucketName, key);
            else
                write(logObj,'error', 'Invalid arguments');
            end
        end
    end
end