function setBucketName(obj, bucketName)
    % SETBUCKETNAME Sets the name of the Amazon S3 bucket to create

    % Copyright 2023 The MathWorks, Inc.

    if ischar(bucketName)
        obj.Handle.setBucketName(bucketName);
    else
        logObj = Logger.getLogger();
        write(logObj,'error', 'Expected argument of type character vector');
    end

end