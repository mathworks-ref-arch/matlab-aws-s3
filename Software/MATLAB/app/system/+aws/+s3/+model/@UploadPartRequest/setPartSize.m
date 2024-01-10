function setPartSize(obj, partSize)
    % SETPARTSIZE Sets the size of this part, in bytes
    %
    % See: aws.s3.transfer.TransferManager for a high-level alternative.

    % Copyright 2023 The MathWorks, Inc.

    if ~isa(partSize, 'int64')
        logObj = Logger.getLogger();
        write(logObj,'error','Expected partSize to be of type int64');
    else
        obj.Handle.setPartSize(partSize);
    end
end