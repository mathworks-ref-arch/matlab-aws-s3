# MATLAB Interface *for Amazon S3*

Amazon™ Simple Storage Service, [Amazon S3™](https://aws.amazon.com/s3/), is an object storage service to store and retrieve any amount of data. It is designed to be highly reliable, and to scale beyond trillions of objects.

S3 is often used as primary storage for cloud-native applications. S3 stores data as objects within buckets. An object consists of a file and optionally metadata. Upload the file to a bucket to store an object in S3. The permissions on the uploaded object or metadata can be set as well.

Buckets are the containers for objects. Access to a bucket can be controlled. Additionally, access logs for the bucket and its objects can be viewed. Users can choose which region Amazon S3 will store the bucket's contents.

## Contents

* [Installation](Installation.md)
* [Authentication & IAM Roles](Authentication.md)
* [Getting Started](GettingStarted.md)
* [Basic Usage](BasicUsage.md)
* [Large data transfers](Multipart.md)
* [Logging](Logging.md)
* [Security](Security.md)
  * [Using Access Controls](AccessControls.md)
  * [Encryption Support](EncryptionSupport.md)
* [Environments](SupportedEnvironments.md)
  * [Running on MATLAB Desktop](MATLABDesktop.md)
  * [Running on MATLAB Production Server (Runtime)](MATLABProductionServer.md)
  * [Running on MATLAB Distributed Computing Server](MATLABDistributed.md)
* [References](References.md)
* Appendix
  * [Building the SDK](Rebuild.md)
  * [S3 API Documentation](awsS3ApiDoc.md)

[//]: #  (Copyright 2018-2023 The MathWorks, Inc.)
