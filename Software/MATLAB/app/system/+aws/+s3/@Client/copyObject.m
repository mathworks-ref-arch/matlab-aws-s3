function copyObjectResult = copyObject(obj, sourceBucketName, sourceKey, destinationBucketName, destinationKey)
    % COPYOBJECT Copies a source object to a new destination in Amazon S3
    % All object metadata for the source object except server-side-encryption,
    % storage-class and website-redirect-location are copied to the new destination
    % object.
    % The Amazon S3 Access Control List (ACL) is not copied to the new object.
    % The new object will have the default Amazon S3 ACL.
    %
    % For files less than 100MB the underlying API call used is
    % com.amazonaws.services.s3.AmazonS3Client.copyObject and the returned result
    % is a com.amazonaws.services.s3.model.CopyObjectResult wrapped as
    % aws.s3.model.CopyObjectResult.
    %
    % For larger files the underlying API call used is
    % com.amazonaws.services.s3.transfer.copy and
    % a com.amazonaws.services.s3.transfer.model.CopyResult is returned wrapped
    % as a aws.s3.transfer.model.CopyResult.
    % 
    % % Example;
    %    s3 = aws.s3.Client();
    %    s3.initialize();
    %    result = s3.copyObject('mysourcebucket','mysourckey','mydestinationbucket', 'mydestinationkey');

    % Copyright 2022-2023 The MathWorks, Inc.

    % Logging object
    logObj = Logger.getLogger();

    % Validate input
    if ~ischar(sourceBucketName)
        write(logObj,'error', 'Expected sourceBucketName to be a character vector');
    end
    if ~ischar(sourceKey)
        write(logObj,'error', 'Expected sourceKey to be a character vector');
    end
    if ~ischar(destinationBucketName)
        write(logObj,'error', 'Expected destinationBucketName to be a character vector');
    end
    if ~ischar(destinationKey)
        write(logObj,'error', 'Expected destinationKey to be a character vector');
    end

    % Get object's meta data to determine size
    if  obj.encryptionScheme == aws.s3.EncryptionScheme.SSEC
        metadata = obj.getObjectMetadata(sourceBucketName, sourceKey, ssecKey);
    else
        metadata = obj.getObjectMetadata(sourceBucketName, sourceKey);
    end
    objectLength = metadata.getContentLength();

    if objectLength < 104857600 %100MB
        copyObjectResultj = obj.Handle.copyObject(sourceBucketName, sourceKey, destinationBucketName, destinationKey);
        copyObjectResult = aws.s3.model.CopyObjectResult(copyObjectResultj);
    else
        tmb = aws.s3.transfer.TransferManagerBuilder();
        tmb = tmb.withS3Client(obj.Handle);
        tm = tmb.build();
        copy = tm.copy(sourceBucketName, sourceKey, destinationBucketName, destinationKey);
        copyResult = copy.waitForCopyResult();
        tm.shutdownNow(false);
        copyObjectResult = copyResult;
    end
end


