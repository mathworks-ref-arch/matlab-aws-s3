function setKey(obj, key)
    % SETKEY Sets the size of this part, in bytes
    %
    % See: aws.s3.transfer.TransferManager for a high-level alternative.

    % Copyright 2023 The MathWorks, Inc.

    if ~ischar(key)
        logObj = Logger.getLogger();
        write(logObj,'error','Expected key to be of type character vector');
    else
        obj.Handle.setKey(key);
    end
end