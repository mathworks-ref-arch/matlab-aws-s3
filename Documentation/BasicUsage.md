# Basic Usage

## Initializing a client

The first step is to create a client to connect to Amazon S3™.

```matlab
s3 = aws.s3.Client();
```

Once created, certain properties of the client can be set. As an example, a local JSON credentials file is used, to avoid use of the AWS™ credentials provider chain and to search the path for a file called ```credentials.json```.

```matlab
s3.useCredentialsProviderChain = false;
```

Initialize the MATLAB® environment to work with Amazon S3.

```matlab
s3.initialize();
```

This sets up the current MATLAB context to connect to the Amazon S3 service by authenticating as discussed in [Authentication](Authentication.md) and initializing a client. In this case by default setting the client to not use encryption. Other encryption options are discussed in more detail in [Encryption Support](EncryptionSupport.md). If desired the client can be initialized with an alternate JSON credentials file. This can be useful if the default location cannot be used or if one needs to connect multiple clients with different credentials at the same time.

By default the package will provide minimal feedback however one can increase the level of feedback by altering the logging level to 'verbose', see [Logging](Logging.md) for more details.

## Creating a bucket

To a limited degree S3 buckets can be thought of as being similar to a directory in a traditional file system. However there are some important differences, e.g.:

* S3 bucket names are globally unique, so once a bucket name has been taken by any user, another bucket with that same name cannot be created.
* By default each account is limited to 100 buckets.
* Bucket names cannot contain UPPERCASE characters and other restrictions.

The API does not attempt to sanitize the inputs using `matlab.lang.makeValidName()`.
So it is designed to fail in the case of invalid input. Amazon recommends that all bucket names comply with DNS naming conventions.

For more details please see: <http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html>

Create an S3 bucket by calling the `createBucket()` method as follows:

```matlab
s3.createBucket('com-myorg-testbucket');
```

A `CreateBucketRequest()` object can be used to create a bucket with certain specific properties, for example enabling the use of ACLs, see: [Access Controls](AccessControls.md).

```matlab
cbr = aws.s3.model.CreateBucketRequest(`com-myorg-testbucket`);
cbr.setObjectOwnership('BucketOwnerPreferred');
s3.createBucket(cbr);
```

Where *com-myorg-testbucket* is the requested name of the bucket.

To determine if a bucket already exists one can list the existing buckets using the `listBuckets()` method or the `doesBucketExist()` method to check for a specific bucket.

## Listing existing buckets

`listBuckets()` returns a table with a list of buckets and certain
metadata details.. An example is as follows:

```matlab
bucketList = s3.listBuckets();

         CreationDate                     Name                 Owner         OwnerId
 ______________________________  __________________________  __________  ________________

 'Mon Feb 06 16:30:09 PST 2017'  'com-example-mybucket'    'joe.blog'  'ab[REDACTED]75'
 'Mon Feb 06 16:34:19 PST 2017'  'com-example-demo'        'joe.blog'  'ab[REDACTED]75'
 'Tue Feb 07 09:49:05 PST 2017'  'com.example.mybucket.2'  'joe.blog'  'ab[REDACTED]75'
 'Tue Feb 07 09:18:03 PST 2017'  'com.example.mybucket.1'  'joe.blog'  'ab[REDACTED]75'
```

## Storing data as an S3 object

Once a bucket has been created one can store data in it assuming one has write permission for the bucket in question. The API supports storing generic files containing arbitrary data or mat files. The following example shows a .mat file (holding 10000 random numbers) can be uploaded to an S3 bucket. The object "key" is the unique name by which the object is known within the bucket. The `putObject()` method which applies a canned access control policy to the new object.

```matlab
% create and initialize the client
s3 = aws.s3.Client();
s3.initialize();

% create some random data
x = rand(100,100);

% save the data to a file
uploadfile = [tempname,'.mat'];
save(uploadfile, 'x');

% create a bucket to hold the object
s3.createBucket('mys3bucket');

% put the .MAT file into an S3 object called 'myobjectkey' in the bucket
s3.putObject('mys3bucket',uploadfile,'myobjectkey');
```

### Note

* When uploading a file the client automatically computes a checksum of the file. Amazon S3 uses checksums to validate the data in each file.
* The specified bucket must already exist and the caller must have `Permission.Write` permission to the bucket to upload an object.
* Versioning of objects is not currently supported by this package.
* For greater control over large data transfers see: [Multipart.md](Multipart.md).

## Listing objects in a bucket

Just as buckets were listed object can also be listed. The `listObjects()` method returns a table with the object names and other metadata. If the table contains no objects an empty table is returned. All objects in a bucket can be queried using the `listObjects()` method.

```matlab
s3.listObjects('com-example-mybucket');

 ObjectKey       ObjectSize             LastModified         StorageClass    Owner
 ______________  __________  ______________________________  ____________  __________

 'DataFile.mat'  [7566157]   'Tue Feb 07 23:28:24 PST 2017'  'STANDARD'    'joe.blog'
 'Sample.jpg'    [ 345334]   'Tue Feb 07 23:44:01 PST 2017'  'STANDARD'    'joe.blog'
```

To determine if a specific object exists one can also call:

```matlab
tf = s3.doesObjectExist('mys3bucket','myobjectkey');
```

## Retrieving data from s3

Retrieving data from S3 using the API is straightforward. The following example shows how a previously uploaded file named *myobjectkey* can be downloaded to a local file called *output.mat*. If the filename is not provided the object key is used.

```matlab
s3.getObject('mybucketname','myobjectkey','output.mat');
```

If the method will result in a file being overwritten a warning is produced and the operation proceeds. If a directory is to be overwritten an error is produced.

For greater control over large data transfers see: [Multipart.md](Multipart.md).

## Deleting an object

Removes the specified object from the specified S3 bucket. Unless versioning has been turned on for the bucket, there is no way to undelete an object, so use caution when deleting objects.

```matlab
s3.deleteObject('mys3bucket','myobjectkey');
```

## Deleting a bucket

Buckets cannot be deleted if they are not empty. An empty bucket can be deleted using:

```matlab
s3.deleteBucket('com-myorg-mybucket');
```

A bucket must first be empty of objects in order to delete it.

**CAUTION** - since bucket names are globally unique, you may not be able to recreate a bucket of the same name immediately. It might take some time before the name can be reused.

## Using MATLAB save/load semantics

This package consciously uses semantics that largely mirror those of the Amazon S3 Java SDK. This recognizes the scale of S3 ecosystem and the fact that many S3 users interact with the service using a variety of tools. However, a MATLAB approach for the core functionality via *load* and *save* commands is also available. These commands support most of the functionality of the load and save commands but in the context of S3.

As an example:

```matlab
% Create a client for S3
s3 = aws.s3.Client();
s3.initialize();

% Setup some random data
x1 = rand(3);
x2 = rand(3);

% Use the client's save method to save the file to S3, with a key
% name of 'myfile_keyname.mat'
bucketname = 'com-example-my-test-bucket';
s3.save(bucketname, 'myfile_keyname.mat', 'x1', 'x2');

% Retrieve the data from S3 using load rather than getObject as before
% this call will load the x1 and x2 variables directly into the structure myVars.
myVars = s3.load(bucketname,'myfile_keyname.mat');

% Compare x1, x2 and myVars.x1, myVars.x2
isequal(x1, myVars.x1);
isequal(x2, myvars.x2);

% cleanup
s3.deleteObject(bucketname,'myfile_keyname.mat');
s3.deleteBucket(bucketname);
s3.shutdown;
```

## Disabling SSL Certificate checking

Ordinarily disabling SSL certificate checking is strongly discouraged. However, there is a specific use case where this can be useful. If using an on-premise S3 implementation, e.g. a NetApp® StorageGRID® system, which has been configured with a self-signed certificate on a network without Internet connectivity, then an SSL connection to the server is used however the certificate cannot be externally validated. This will cause an error in the underlying Java security libraries that validate the connection. the following line of code can be used in MATLAB to disable the certificate check for the AWS SDK. This should be called prior to client initialization. It should not be used in any scenario where the validity of the certificate is outside of the user's direct control, e.g. accessing an S3 service, AWS or otherwise, via the Internet.

```matlab
java.lang.System.setProperty(com.amazonaws.SDKGlobalConfiguration.DISABLE_CERT_CHECKING_SYSTEM_PROPERTY, "false");
```

The following code can be used to check the status of this setting, a logical is returned:

```matlab
sdkGlobalConfiguration = com.amazonaws.SDKGlobalConfiguration;
certCheckStatus = sdkGlobalConfiguration.isCertCheckingDisabled;
```

[//]: # (Copyright 2018-2023 The MathWorks, Inc.)
