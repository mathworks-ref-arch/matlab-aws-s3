# MATLAB® Interface *for Amazon S3™*

This is a MATLAB® interface for the Amazon S3™ service. This is a low-level interface. MATLAB IO operations increasingly support access to S3 via a higher-level interface, e.g. the ```dir``` command supports accessing remote data; [https://www.mathworks.com/help/matlab/ref/dir.html](https://www.mathworks.com/help/matlab/ref/dir.html), [https://www.mathworks.com/help/matlab/import_export/work-with-remote-data.html](https://www.mathworks.com/help/matlab/import_export/work-with-remote-data.html). Where MATLAB's higher-level interface supports the required operations it is recommended to use that.

## Requirements

### MathWorks products

* Requires MATLAB release R2017a or later.
* AWS Common utilities found at https://github.com/mathworks-ref-arch/matlab-aws-common

### 3rd party products

* Amazon Web Services account

To build a required JAR file:

* [Maven](https://maven.apache.org/)
* JDK 7 or later
* [AWS SDK for Java](https://aws.amazon.com/sdk-for-java/) (version 1.12.501 or later)

## Getting Started

Please refer to the [Documentation](Documentation/README.md) to get started.
The [Installation Instructions](Documentation/Installation.md) and [Getting Started](Documentation/GettingStarted.md) documents provide detailed instructions on setting up and using the interface. The easiest way to
fetch this repo and all required dependencies is to clone the top-level repository using:

```bash
git clone --recursive https://github.com/mathworks-ref-arch/mathworks-aws-support.git
```

### Build the AWS SDK for Java components

The MATLAB code uses the AWS SDK for Java and can be built using:

```bash
cd Software/Java
mvn clean package
```

By default the pom.xml file targets Java 1.7 as supported by MATLAB R2017a and later.
This can be updated to 1.8 as supported by MATLAB R2017b and later by updating:

```xml
    <source>1.8</source>
    <target>1.8</target>
```

prior to running the `mvn clean package` command, see: [Rebuild](Documentation/Rebuild.md).

Once built, use the ```/Software/MATLAB/startup.m``` function to initialize the interface which will use the
AWS Credentials Provider Chain to authenticate. Please see the [relevant documentation](Documentation/Authentication.md)
on how to specify the credentials.

### Create a bucket, list existing buckets, upload and download objects

```matlab
%% Create and initialize a client
s3 = aws.s3.Client();
s3.initialize();

%% Create a test bucket
bucketName = 'com-myorg-my-test-bucket';
s3.createBucket(bucketName);

%% List existing buckets
bucketList = s3.listBuckets()

%% Upload a file
% Create some random data
x = rand(100,100);

% Save the data to a file
uploadfile = [tempname,'.mat'];
save(uploadfile, 'x');

% Put the .MAT file into an S3 object called 'myobjectkey' in the bucket
s3.putObject(bucketName, uploadfile, 'myobjectkey');

% Download a file
s3.getObject(bucketName,'myobjectkey','download.mat');

% Delete a object and then the bucket
s3.deleteObject(bucketName,'myobjectkey');
s3.deleteBucket(bucketName);

% Delete the client
s3.shutdown;
```

The interface supports a number of Amazon S3 features including credential-free authentication using IAM when running on EC2™. Please consult the documentation for more details.

## Supported Products:

1. [MATLAB](https://www.mathworks.com/products/matlab.html) (R2017a or later)
2. [MATLAB Compiler™](https://www.mathworks.com/products/compiler.html) and [MATLAB Compiler SDK™](https://www.mathworks.com/products/matlab-compiler-sdk.html) (R2017a or later)
3. [MATLAB Production Server™](https://www.mathworks.com/products/matlab-production-server.html) (R2017a or later)
4. [MATLAB Distributed Computing Server™](https://www.mathworks.com/products/distriben.html) (R2017a or later)

## License

The license for the MATLAB Interface *for Amazon S3* is available in the [LICENSE.md](LICENSE.md) file in this GitHub repository. This package uses certain third-party content which is licensed under separate license agreements. See the [pom.xml](Software/Java/pom.xml) file for third-party software downloaded at build time.

## Enhancement Request

Provide suggestions for additional features or capabilities using the following link:
https://www.mathworks.com/products/reference-architectures/request-new-reference-architectures.html

## Support

Email: `mwlab@mathworks.com` or please log an issue.

[//]: #  (Copyright 2018-2023 The MathWorks, Inc.)
