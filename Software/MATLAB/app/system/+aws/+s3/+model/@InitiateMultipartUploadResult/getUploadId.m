function uploadId = getUploadId(obj)
    % getUploadId Returns the initiated multipart upload ID
    %
    % See: aws.s3.transfer.TransferManager for a high-level alternative.

    % Copyright 2023 The MathWorks, Inc.

    uploadId = char(obj.Handle.getUploadId());
end