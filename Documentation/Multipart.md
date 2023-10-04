# Multipart Transfers

When working with larger files (> 100MB) Amazon recommends using mutltipart transfers rather than `putObject` and `getObject` calls, see: [https://docs.aws.amazon.com/AmazonS3/latest/userguide/mpuoverview.html](https://docs.aws.amazon.com/AmazonS3/latest/userguide/mpuoverview.html).

This package will automatically use multipart for large transfers when using `putObject` and `getObject`. However, the `aws.s3.transfer.TransferManager` class and associated classes and methods can also be used for transfers directly, affording greater control.

Use the `TransferManagerBuilder` class to create an object with which an S3 client object can be associated, then complete the build step as follows:

```matlab
tmb = aws.s3.transfer.TransferManagerBuilder();
tmb.setS3Client(testCase.s3);
tm = tmb.build();
```

> Use the `doc`, `help`, and `methods` functions to explore these classes and their methods in greater detail.

See also: [https://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/index.html?com/amazonaws/services/s3/transfer/TransferManager.html](https://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/index.html?com/amazonaws/services/s3/transfer/TransferManager.html)

Working with multipart uploads generally requires `s3:PutObject`, `s3:AbortMultipartUpload`, `s3:ListMultipartUploadParts`, `s3:GetObject`, `s3:ListMultipartUploadParts` permissions, in addition KMS permissions will be required if using KMS.

Multipart Transfers are normally non blocking and the associated *wait* methods must be called to ensure that a call completes before the required context is destroyed. `isDone` can be used to check if a transfer is complete or not.

## Downloads

The following example shows how an object in a given bucket can be downloaded using `TransferManager`, `aws.s3.Client.getObject` will use this method for file sizes greater than or equal to 100MB:

```matlab
tmb = aws.s3.transfer.TransferManagerBuilder();
tmb.setS3Client(s3);
tm = tmb.build();
download = tm.download(bucketName, keyName, localPath);
download.waitForCompletion();
```

```matlab
% Download can also be called using a aws.s3.model.GetObjectRequest
download = tm.download(getObjectRequest, localPath);
download.waitForCompletion();
```

If you wish to interrupt a download the `download.abort` method should be called.
`TransferManager.download` is an asynchronous method, permitting other activities that do not disturb the download's context to be carried out while waiting for the download to complete. The `waitForCompletion` call is blocking.

To download all objects in the virtual directory designated by the given keyPrefix to the destination directory:

```matlab
multipleFileDownload = tm.downloadDirectory(testCase.bucketName, virtualDirectoryKeyPrefix, tDownloadDir);
multipleFileDownload.waitForCompletion();
```

## Uploads

% Upload a file to a local S3 object, `aws.s3.Client.putObject` will use this method for file sizes greater than or equal to 100MB:

```matlab
upload = tm.upload(bucketName, keyName, localPath);
result = upload.waitForUploadResult();
```

To cancel prior multipart uploads to a given bucket use:

```matlab
tmb = aws.s3.transfer.TransferManagerBuilder();
tmb.setS3Client(s3);
tm = tmb.build();
tm.abortMultipartUploads(bucketName, datetime('now'));
```

To Upload all files in the directory to a named bucket:

```matlab
multipleFileUpload = tm.uploadDirectory(bucketName, virtualDirectoryKeyPrefix, directory, includeSubdirectories);
multipleFileUpload.waitForCompletion();
```

## Copy

To copy a file from one S3 object to another generally one would wish to avoid and download followed by an upload.
A copy allows the transfer to happen directly in S3. Note in this case the transfer monitoring updates are not a reliable indication of progress.
`aws.s3.Client.CopyObject` will use this method for file sizes greater than or equal to 100MB.

```matlab
copy = tm.copy(sourceBucketName, sourceKeyName, destinationBucketName, destinationKeyName);
copyResult = copy.waitForCopyResult();
```

## Monitoring

When making large transfers interactively it can be useful to have some indication of progress. The `aws.s3.transfer.TransferProgress` and `aws.s3.transfer.TransferState` classes can be used to actively examine progress. However, a visual indication is often preferable, the `aws.s3.mathworks.s3.transferMonitor` function provides this in terms of a scrolling or static, percentage or bytes measure of progress. It is a blocking call that will wait until the transfer completes. It is invoked as follows:

```matlab
upload = tm.upload(testCase.bucketName, keyName, localPath);
aws.s3.mathworks.s3.transferMonitor(upload);
```

```matlab
aws.s3.mathworks.s3.transferMonitor(download, 'mode', 'bytes', 'display', 'static', 'delay', 1);
```

## Shutdown

The `shutdownNow` method forcefully shuts down a `TransferManager`` instance. Currently executing transfers will not be allowed to finish. This should use this method when either:

* One has already verified that their transfers have completed by checking each transfer's state
* One needs to exit quickly and don't mind stopping transfers before they complete.

Uploaded parts from an interrupted upload may not always be automatically cleaned up.
The `abortMultipartUploads` method can be used to clean up any upload parts.

A logical `shutDownS3Client` argument indicates whether to shut down the underlying Amazon S3 client or not.

```matlab
tm.shutDownNow(true);(true);
```

[//]: #  (Copyright 2023 The MathWorks, Inc.)
