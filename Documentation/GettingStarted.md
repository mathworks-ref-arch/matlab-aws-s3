# Getting Started

Once this package is installed and authentication is in place one can begin working with S3™ and looking at simple workflows. The [Basic Usage](BasicUsage.md) document provides greater details on the functions being used in this first example. In this case, create and delete a bucket on S3. This example assumes that the bucket does not already exist.
```
% Create the client called s3 and initialize it to not use encryption when storing data
s3 = aws.s3.Client();
s3.useCredentialsProviderChain = false;
s3.initialize();

% create a bucket, note AWS provides naming guidelines
bucketName = 'com-myorg-mybucket';
s3.createBucket(bucketName);

% get a list of the buckets and see that com-myorg-mybucket appears
s3.listBuckets()

% cleanup by deleting the bucket and shutting down the client
s3.deleteBucket(bucketName);
s3.shutdown;
```

This should produce output similar to the following:
```
s3 = aws.s3.Client();
Creating Client

s3.initialize();
Initializing S3 client
Setting EncryptionScheme
Not using encryption

bucketName = 'com-myorg-my-test-bucket';
s3.createBucket(bucketName);
Creating bucket com-myorg-my-test-bucket

s3.listBuckets()

Listing buckets
         CreationDate                      Name                  Owner            OwnerId
 ______________________________  __________________________  _______________  _____________
 'Thu Mar 02 02:13:19 GMT 2017'  'com-example-testbucket'    'aws_test_dept'  '[REDACTED]'
 'Thu Jun 08 18:46:37 BST 2017'  'com-myorg-my-test-bucket'  'aws_test_dept'  '[REDACTED]'

s3.deleteBucket(bucketName);
Deleting bucket com-myorg-my-test-bucket

s3.shutdown;
Shutting down S3 client
```

## Logging
When getting started or debugging it can be helpful to get more feedback. Once the Client has been created one can set the logging level to verbose as follows:
```
logObj = Logger.getLogger();
logObj.DisplayLevel = 'verbose';
```
See: [Logging](Logging.md) for more details.


## Configuring an alternative endpoint
The endpoint determines the location of the system the SDK will attempt to communicate with. Ordinarily this will be an AWS system and there is no need to set a specific endpoint. However, it can be set if required, for example if connection to an on-premise S3 service, e.g. [NetApp® StorageGRID®](https://www.netapp.com/us/products/data-management-software/object-storage-grid-sds.aspx) or [MINIO®](https://min.io/), or an alternate cloud based S3 service such as the S3 interface to [Google™ Cloud Storage](https://cloud.google.com/storage/).

The following shows to configure the endpoint prior to calling ```initialize()``` to point the Google interoperability service:
```
s3 = aws.s3.Client();
s3.endpointURI = matlab.net.URI('https://storage.googleapis.com');
s3.initialize();
```
Path elements on the endpoint URI are removed by default to avoid bucket names being erroneously included. If using an non AWS system you may also need to force the use of Path Style Access.


## Path Style Access
In some cases e.g. for certain non AWS S3 services it may be necessary to configures the client to use path-style access for all requests. AWS's S3 service supports virtual-hosted-style and path-style access in all Regions. The path-style syntax, however, requires that you use the region-specific endpoint when attempting to access a bucket. Note, AWS are in the process of deprecating the use of Path Style Access. The default behavior is to detect which access style to use based on the configured endpoint (an IP will result in path-style access) and the bucket being accessed (some buckets are not valid DNS names). However with non AWS endpoints it is often necessary to explicitly enable the use of Path Style Access, e.g. when connecting to a NetApp StorageGRID or MINIO systems. Setting ```pathStyleAccessEnabled``` client property to true will result in path-style access being used for all requests. It should be set prior to calling ```initialize()```.
```
s3 = aws.s3.Client();
s3.endpointURI = matlab.net.URI('https://mycustomendpoint.example.com');
s3.pathStyleAccessEnabled = true;
s3.initialize();
```


## Network proxy configuration

Many corporate networks require Internet access to take place via a proxy server. This includes the traffic between a MATLAB® session and Amazon.

Within the MATLAB environment it is possible to specify the proxy settings using the web section of the preferences panel as shown:   
![Preferences_Panel](Images/prefspanel.png)   
Often a username and password are not required.

In Windows it is also possible to specify the proxy settings in Control Panel / Internet Options / Connections tab.

Other operating systems have similar network preference controls. Depending on the network environment the proxy settings may also be configured automatically. However, by default the Client will only use a proxy server once configured to do so. Furthermore a complex proxy environment may use different proxies for different traffic types and destinations.

A proxy is configured using the a ClientConfiguration object which is a property of the client. When the client is create if a proxy is configured in the MATLAB proxy configuration preferences then these values will be used and applied when the client is initialized. On Windows, were these not provided in the MATLAB preferences the Windows proxy settings would be used instead. Thus no intervention is required. However it is possible to override the preferences and set proxy related values or reload values based on updated preferences to use a specific proxy and port as follows. Note, this does not alter the settings in the MATLAB preferences panel.
```
client.clientConfiguration.setProxyHost('proxyHost','myproxy.example.com');
client.clientConfiguration.setProxyPort(8080);
```
The client is now configured to use the proxy settings given rather than those in the MATLAB preferences panel. In this case a username and password are not provided. They are normally not required for proxy access.

Specify an automatic configuration URL as follows:
```
client.clientConfiguration.setProxyHost('autoURL','https://myexampleurl.amazonaws.com');
client.clientConfiguration.setProxyPort('https://myexampleurl.amazonaws.com');
```
This instructs the client to request a proxy port and host based on traffic to
https://myexampleurl.amazonaws.com. Note, this is not the URL of the proxy itself. Different proxies may be in place to cover traffic to different addresses, so it should be a valid Amazon URL and may need to correspond to the service being used. By default https://s3.amazonaws.com is used.

To use the username and password from the MATLAB preferences call:
```
client.clientConfiguration.setProxyUsername();
client.clientConfiguration.setProxyPassword();
```
Or to specify a username and password directly call:
```
client.clientConfiguration.setProxyUsername('myProxyUsername');
client.clientConfiguration.setProxyPassword('myProxyPassword');
```

If a proxy server is being used, then the proxy values need to be configured as shown, this should be done before the client is initialized.


[//]: #  (Copyright 2018-2019 The MathWorks, Inc.)
