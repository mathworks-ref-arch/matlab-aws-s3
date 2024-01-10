function setLastPart(obj, isLastPart)
    % SETLASTPART Marks this part as the last part being uploaded in a multipart upload
    %
    % See: aws.s3.transfer.TransferManager for a high-level alternative.

    % Copyright 2023 The MathWorks, Inc.

    if ~islogical(isLastPart)
        logObj = Logger.getLogger();
        write(logObj,'error','Expected key to be of type logical');
    else
        obj.Handle.setLastPart(key);
    end
end