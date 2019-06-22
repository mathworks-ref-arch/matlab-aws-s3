# MATLAB® Interface *for AWS S3™*

This is a MATLAB® interface for the Amazon Web Services S3™ service. This is a low-level, general interface that can be customized if the higher-level interface as provided in MATLAB does not support your needs. see here https://www.mathworks.com/help/matlab/import_export/work-with-remote-data.html for more details on what is provided in MATLAB.

## Requirements
### MathWorks products
* Requires MATLAB release R2017a or later.
* AWS Common utilities found at https://github.com/mathworks-ref-arch/matlab-aws-common

### 3rd party products
* Amazon Web Services account   

To build a required JAR file:   
* [Maven](https://maven.apache.org/)
* JDK 7
* [AWS SDK for Java](https://aws.amazon.com/sdk-for-java/) (version 1.11.367 or later)

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

The interface supports a number of S3 features including credential-free authentication using IAM when running on EC2™. Please consult the documentation for more details.

## Supported Products:
1. [MATLAB](https://www.mathworks.com/products/matlab.html) (R2017a or later)
2. [MATLAB Compiler™](https://www.mathworks.com/products/compiler.html) and [MATLAB Compiler SDK™](https://www.mathworks.com/products/matlab-compiler-sdk.html) (R2017a or later)
3. [MATLAB Production Server™](https://www.mathworks.com/products/matlab-production-server.html) (R2017a or later)
4. [MATLAB Distributed Computing Server™](https://www.mathworks.com/products/distriben.html) (R2017a or later)

## License
The license for the MATLAB Interface *for AWS S3* is available in the [LICENSE.TXT](LICENSE.TXT) file in this GitHub repository. This package uses certain third-party content which is licensed under separate license agreements. See the [pom.xml](Software/Java/pom.xml) file for third-party software downloaded at build time.

## Enhancement Request
Provide suggestions for additional features or capabilities using the following link:   
https://www.mathworks.com/products/reference-architectures/request-new-reference-architectures.html

## Support
Email: `mwlab@mathworks.com` or please log an issue.    

[//]: #  (Copyright 2018 The MathWorks, Inc.)
