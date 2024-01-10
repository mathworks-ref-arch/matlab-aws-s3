function setPartNumber(obj, partNumber)
    % setPartNumber Sets the part number
    %
    % Describes this part's position relative to the other parts in the multipart upload.
    %
    % See: aws.s3.transfer.TransferManager for a high-level alternative.

    % Copyright 2023 The MathWorks, Inc.

    if ~isa(partNumber, 'int32')
        logObj = Logger.getLogger();
        write(logObj,'error','Expected partNumber to be of type int32');
    else
        obj.Handle.setPartNumber(partNumber);
    end
end