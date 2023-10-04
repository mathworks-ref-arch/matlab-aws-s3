# MATLAB Interface *for Amazon S3*

## API Reference

Documentation generation settings:

* Including class level help text
* Omitting constructor help text
* Excluding inherited methods
* Excluding default MATLAB classes


## Package  *aws*


### Classes

* [aws.ClientConfiguration](#awsclientconfiguration)
* [aws.Object](#awsobject)

### Subpackage  *aws.s3*


### Classes

* [aws.s3.CanonicalGrantee](#awss3canonicalgrantee)
* [aws.s3.EncryptionScheme](#awss3encryptionscheme)
* [aws.s3.Permission](#awss3permission)
* [aws.s3.CannedAccessControlList](#awss3cannedaccesscontrollist)
* [aws.s3.EmailAddressGrantee](#awss3emailaddressgrantee)
* [aws.s3.ObjectMetadata](#awss3objectmetadata)
* [aws.s3.Client](#awss3client)
* [aws.s3.Grant](#awss3grant)
* [aws.s3.GroupGrantee](#awss3groupgrantee)
* [aws.s3.AccessControlList](#awss3accesscontrollist)
* [aws.s3.Owner](#awss3owner)

### Subpackage  *aws.s3.transfer*


### Classes

* [aws.s3.transfer.AbortableTransfer](#awss3transferabortabletransfer)
* [aws.s3.transfer.Copy](#awss3transfercopy)
* [aws.s3.transfer.Download](#awss3transferdownload)
* [aws.s3.transfer.MultipleFileDownload](#awss3transfermultiplefiledownload)
* [aws.s3.transfer.MultipleFileUpload](#awss3transfermultiplefileupload)
* [aws.s3.transfer.PauseResult](#awss3transferpauseresult)
* [aws.s3.transfer.PresignedUrlDownload](#awss3transferpresignedurldownload)
* [aws.s3.transfer.Transfer](#awss3transfertransfer)
* [aws.s3.transfer.TransferManager](#awss3transfertransfermanager)
* [aws.s3.transfer.TransferManagerBuilder](#awss3transfertransfermanagerbuilder)
* [aws.s3.transfer.TransferProgress](#awss3transfertransferprogress)
* [aws.s3.transfer.TransferState](#awss3transfertransferstate)
* [aws.s3.transfer.Upload](#awss3transferupload)

### Subpackage  *aws.s3.transfer.model*


### Classes

* [aws.s3.transfer.model.CopyResult](#awss3transfermodelcopyresult)
* [aws.s3.transfer.model.PersistableTransfer](#awss3transfermodelpersistabletransfer)
* [aws.s3.transfer.model.UploadResult](#awss3transfermodeluploadresult)

### Subpackage  *aws.s3.model*


### Classes

* [aws.s3.model.GetObjectRequest](#awss3modelgetobjectrequest)
* [aws.s3.model.PutObjectRequest](#awss3modelputobjectrequest)
* [aws.s3.model.CompleteMultipartUploadRequest](#awss3modelcompletemultipartuploadrequest)
* [aws.s3.model.CreateBucketRequest](#awss3modelcreatebucketrequest)
* [aws.s3.model.CopyObjectResult](#awss3modelcopyobjectresult)
* [aws.s3.model.UploadPartRequest](#awss3modeluploadpartrequest)
* [aws.s3.model.InitiateMultipartUploadRequest](#awss3modelinitiatemultipartuploadrequest)
* [aws.s3.model.UploadPartResult](#awss3modeluploadpartresult)
* [aws.s3.model.InitiateMultipartUploadResult](#awss3modelinitiatemultipartuploadresult)
* [aws.s3.model.CompleteMultipartUploadResult](#awss3modelcompletemultipartuploadresult)

### Subpackage  *aws.s3.mathworks.internal*

### Functions

* [aws.s3.mathworks.internal.int64FnHandler](#awss3mathworksinternalint64fnhandler)


### Subpackage  *aws.s3.mathworks.s3*

### Functions

* [aws.s3.mathworks.s3.transferMonitor](#awss3mathworkss3transfermonitor)



### Standalone Functions

* [splitName](#splitname)


------

## API Help


#### aws.ClientConfiguration

```notalanguage
  CLIENTCONFIGURATION creates a client network configuration object
  This class can be used to control client behavior such as:
   * Connect to the Internet through proxy
   * Change HTTP transport settings, such as connection timeout and request retries
   * Specify TCP socket buffer size hints
  (Only limited proxy related methods are currently available)
 
  Example, in this case using an s3 client:
    s3 = aws.s3.Client();
    s3.clientConfiguration.setProxyHost('proxyHost','myproxy.example.com');
    s3.clientConfiguration.setProxyPort(8080);
    s3.initialize();

```

*aws.ClientConfiguration.getNonProxyHosts*

```notalanguage
  GETNONPROXYHOSTS Sets optional hosts accessed without going through the proxy
  Returns either the nonProxyHosts set on this object, or if not provided,
  returns the value of the Java system property http.nonProxyHosts.
  Result is returned as a character vector.
 
  Note the following caveat from the Amazon DynamoDB documentation:
 
  We still honor this property even when getProtocol() is https, see
  http://docs.oracle.com/javase/7/docs/api/java/net/doc-files/net-properties.html
  This property is expected to be set as a pipe separated list. If neither are
  set, returns the value of the environment variable NO_PROXY/no_proxy.
  This environment variable is expected to be set as a comma separated list.

```

*aws.ClientConfiguration.setNonProxyHosts*

```notalanguage
  SETNONPROXYHOSTS Sets optional hosts accessed without going through the proxy
  Hosts should be specified as a character vector.

```

*aws.ClientConfiguration.setProxyHost*

```notalanguage
  SETPROXYHOST Sets the optional proxy host the client will connect through
  This is based on the setting in the MATLAB preferences panel. If the host
  is not set there on Windows then the Windows system preferences will be
  used. Though it is not normally the case proxy settings may vary based on the
  destination URL, if this is the case a URL should be provided for a specific
  service. If a URL is not provided then https://s3.amazonaws.com is used as
  a default and is likely to match the relevant proxy selection rules for AWS
  traffic.
 
  Examples:
 
    To have the proxy host automatically set based on the MATLAB preferences
    panel using the default URL of 'https://s3.amazonaws.com:'
        clientConfiguration.setProxyHost();
 
    To have the proxy host automatically set based on the given URL:
        clientConfiguration.setProxyHost('autoURL','https://examplebucket.amazonaws.com');
 
    To force the value of the proxy host to a given value, e.g. myproxy.example.com:
        clientConfiguration.setProxyHost('proxyHost','myproxy.example.com');
    Note this does not overwrite the value set in the preferences panel.
 
  The client initialization call will invoke setProxyHost() to set a value based
  on the MATLAB preference if the proxyHost value is not to an empty value.

```

*aws.ClientConfiguration.setProxyPassword*

```notalanguage
  SETPROXYPASSWORD Sets the optional proxy password
  This is based on the setting in the MATLAB preferences panel. If the password
  is not set there on Windows then the Windows system preferences will be
  used.
 
  Examples:
 
    To set the password to a given value:
        clientConfig.setProxyPassword('myProxyPassword');
    Note this does not overwrite the value set in the preferences panel.
 
    To set the password automatically based on provided preferences:
        clientConfig.setProxyPassword();
 
  The client initialization call will invoke setProxyPassword() to set
  a value based on the MATLAB preference if the proxy password value is set.
 
  Note, it is bad practice to store credentials in code, ideally this value
  should be read from a permission controlled file or other secure source
  as required.

```

*aws.ClientConfiguration.setProxyPort*

```notalanguage
  SETPROXYPORT Sets the optional proxy port the client will connect through
  This is normally based on the setting in the MATLAB preferences panel. If the
  port is not set there on Windows then the Windows system preferences will be
  used. Though it is not normally the case proxy settings may vary based on the
  destination URL, if this is the case a URL should be provided for a specific
  service. If a URL is not provided then https://s3.amazonaws.com is used as
  a default and is likely to match the relevant proxy selection rules for AWS
  traffic.
 
  Examples:
 
    To have the port automatically set based on the default URL of
    https://s3.amazonaws.com:
        clientConfiguration.setProxyPort();
 
    To have the port automatically set based on the given URL:
        clientConfiguration.setProxyPort('https://examplebucket.amazonaws.com');
 
    To force the value of the port to a given value, e.g. 8080:
        clientConfiguration.setProxyPort(8080);
    Note this does not alter the value held set in the preferences panel.
 
  The client initialization call will invoke setProxyPort() to set a value based
  on the MATLAB preference if the proxy port value is not an empty value.

```

*aws.ClientConfiguration.setProxyUsername*

```notalanguage
  SETPROXYUSERNAME Sets the optional proxy username
  This is based on the setting in the MATLAB preferences panel. If the username
  is not set there on Windows then the Windows system preferences will be
  used.
 
  Examples:
 
     To set the username to a given value:
         clientConfig.setProxyUsername('myProxyUsername');
     Note this does not overwrite the value set in the preferences panel.
 
     To set the password automatically based on provided preferences:
         clientConfig.setProxyUsername();
 
  The client initialization call will invoke setProxyUsername();
  to set preference based on the MATLAB preference if the proxyUsername value is
  not an empty value.
 
  Note it is bad practice to store credentials in code, ideally this value
  should be read from a permission controlled file or other secure source
  as required.

```


#### aws.Object

```notalanguage
  OBJECT Root object for all the AWS SDK objects

```


#### aws.s3.CanonicalGrantee

```notalanguage
  CANONICALGRANTEE defines a Canonical identifier address based grantee
  Returns a Java CanonicalGrantee object for S3 ACLs.
  It creates a canonical identifier string based object that can be used
  when creating Access Control Lists.
 
  Here it is used to grant a permission to an ACL along with a permission
  assuming an existing aws.s3 object
 
  Example:
    canonicalgrantee = aws.s3.CanonicalGrantee('d25639fbe9c19cd30a4c0f43fbf00e2d3f96400a9aa8dabfbbebe1906Example');
    my_perm = aws.s3.Permission('read');
    my_acl = aws.s3.AccessControlList();
 	my_acl.grantPermission(canonicalgrantee, my_perm);

```


#### aws.s3.EncryptionScheme

```notalanguage
 ENCRYPTIONSCHEME defines the various supported S3 encryption schemes
 
    NOENCRYPTION  : do not use encryption
    CSESMK    : client side with a symmetric master key
    CSEAMK    : client side with a asymmetric master key
    KMSCMK    : Key Management Service managed customer master key
    SSEC      : sever side encryption with a customer supplied key
    SSEKMS    : server side encryption using the Key Management Service
    SSES3     : server side encryption using S3 managed encryption keys

```


```notalanguage
Enumeration:
  NOENCRYPTION
  CSESMK
  CSEAMK
  KMSCMK
  SSEC
  SSEKMS
  SSES3
```


#### aws.s3.Permission

```notalanguage
  Class to define a Permission object for S3 Access Control Lists
  The permission can take one of five enumeration values reflecting various
  rights.
 
  Grant permission permitted values are documented as:
  	READ, WRITE, READ_ACP, WRITE_ACP and FULL_CONTROL
  However the Java SDK enum values are:
    Read, Write, ReadAcp, WriteAcp and FullControl
  As this is can easily lead to errors this constructor will accept either
  and is case insensitive
 
  Thus these mixed case names are used as the calling convention. Inputs
  are converted to upper case prior to evaluation to reduce typo errors.
  Underscores are not allowed for.
 
  The following sets my_perm to READ and uses it to create an ACL.
  A grantee is also required, in this case based on an email address.
 
    s3 = aws.s3.Client();
    s3.initialize();
    my_perm = aws.s3.Permission('READ');
    email_addr_grantee = aws.s3.EmailAddressGrantee('joe.blog@example.com');
    my_acl.grantPermission(email_addr_grantee, my_perm);
 
  When granted on a bucket ACL permissions correspond to the following
  S3 Access Policy permissions apply as per S3 documentation:
 
 	READ : Allows grantee to list the objects in the bucket.
 
 	WRITE : Allows grantee to create, overwrite, and delete any object in
            the bucket.
 
 	READ_ACP : Allows grantee to read the bucket ACL.
 
 	WRITE_ACP : Allows grantee to write the ACL for the applicable bucket.
 
 	FULL_CONTROL : Allows grantee the READ, WRITE, READ_ACP, and WRITE_ACP
                   permissions on the bucket. It is equivalent to granting
                   READ, WRITE, READ_ACP, and WRITE_ACP ACL permissions.
 
 
  When granted on an object ACL permissions correspond to the following
  S3 Access Policy permissions apply as per s3 documentation:
 
 	READ : Allows grantee to read the object data and its metadata.
 
 	WRITE : Not applicable.
 
 	READ_ACP : Allows grantee to read the object ACL
 
 	WRITE_ACP : Allows grantee to write the ACL for the applicable object.
 
 	FULL_CONTROL : Is equivalent to granting READ, READ_ACP, and WRITE_ACP
                   ACL permissions. Allows grantee the READ, READ_ACP, and
                   WRITE_ACP permissions on the object.

```


#### aws.s3.CannedAccessControlList

```notalanguage
  CANNEDACCESSCONTROLLIST class to define a canned ACL object
  Canned access control lists are commonly used ACLs
  that can be used as a shortcut when applying an ACL to Amazon S3
  buckets or objects. A few commonly used configurations are available
  as an alternative to manually creating a ACL.
 
  Example:
    myCannedACL = aws.s3.CannedAccessControlList('AuthenticatedRead')
 
  The following Canned ACLs are defined:
  AuthenticatedRead
  Specifies the owner is granted Permission.FullControl and the
  GroupGrantee.AuthenticatedUsers group grantee is granted
  Permission.Read access.
 
  AwsExecRead
  Specifies the owner is granted Permission.FullControl.
 
  BucketOwnerFullControl
  Specifies the owner of the bucket, but not necessarily the same as
  the owner of the object, is granted Permission.FullControl.
 
  BucketOwnerRead
  Specifies the owner of the bucket, but not necessarily the same as
  the owner of the object, is granted Permission.Read.
 
  LogDeliveryWrite
  Specifies the owner is granted Permission.FullControl and the
  GroupGrantee.LogDelivery group grantee is granted Permission.Write
  access so that access logs can be delivered.
 
  Private
  Specifies the owner is granted Permission.FullControl.
 
  PublicRead
  Specifies the owner is granted Permission.FullControl and the
  GroupGrantee.AllUsers group grantee is granted Permission.Read access.
 
  PublicReadWrite
  Specifies the owner is granted Permission.FullControl and the
  GroupGrantee.AllUsers group grantee is granted Permission.Read and
  Permission.Write access.

```


#### aws.s3.EmailAddressGrantee

```notalanguage
  Class to define an email address based grantee
  EMAILADDRESSGRANTEE Method returns a Java EmailAddressGrantee object for S3 ACLs
  It creates an EmailAddressGrantee object based on an email address
  string that can be used when creating Access Control Lists.
 
  Here it is used to grant a permission to an ACL along with a permission
  Example:
    emailaddrgrantee = aws.s3.EmailAddressGrantee('joe.blog@example.com');
    my_perm = s3.Permission('read');
    my_acl.grantPermission(emailaddrgrantee, my_perm);

```


#### aws.s3.ObjectMetadata

```notalanguage
  ObjectMetadata Represents the object metadata that is stored with S3
  This includes custom user-supplied metadata, as well as the standard HTTP
  headers that Amazon S3 sends and receives (Content-Length, ETag,
  Content-MD5, etc.).
 
  Example
    s3 = aws.s3.Client();
    s3.useCredentialsProviderChain = false;
    s3.initialize();
 
    myBucket = 'mb-testbucket-deleteme';
    myKey = 'myobjectkey';
    s3.createBucket('mb-testbucket-deleteme');
    SampleData = rand(100);
    save SampleData SampleData;
 
    myMetadata = aws.s3.ObjectMetadata();
    myMetadata.addUserMetadata('myMDKey1', 'myMDValue1');
    myMetadata.addUserMetadata('myMDKey2', 'myMDValue2');
    myMetadata.addUserMetadata('myMDKey3', 'myMDValue3');
 
    s3.putObject(myBucket, 'SampleData.mat', myKey, myMetadata);
    myDownloadedMetadata = s3.getObjectMetadata(myBucket, myKey);
    myMap = myDownloadedMetadata.getUserMetadata();
    % note keys are returned in lower case
    myMap('mymdkey1')
    ans =
         'myMDValue1'
    keys(myMap)
    ans =
      1x4 cell array
        {'com-mathworks-matlabobject'}    {'mymdkey1'}    {'mymdkey2'}    {'mymdkey3'}
    values(myMap)
    ans =
      1x4 cell array
        {'file'}    {'myMDValue1'}    {'myMDValue2'}    {'myMDValue3'}

```

*aws.s3.ObjectMetadata.addUserMetadata*

```notalanguage
  ADDUSERMETADATA Adds key value pair of custom metadata for an object
  Note that user-metadata for an object is limited by the HTTP request
  header limit. All HTTP headers included in a request (including user
  metadata headers and other standard HTTP headers) must be less than 8KB.
  User-metadata keys are case insensitive and will be returned as lowercase
  strings, even if they were originally specified with uppercase strings.
 
  Example:
    save myData x;
    myMetadata = aws.s3.ObjectMetadata();
    myMetadata.addUserMetadata('myKey', 'myValue');
    s3.putObject('com-mathworks-mytestbucket', 'myData.mat', myMetadata);

```

*aws.s3.ObjectMetadata.getContentLength*

```notalanguage
  GETCONTENTLENGTH Gets the length of the object in bytes
  Gets the Content-Length HTTP header indicating the size of the associated
  object in bytes.
  An int64 is returned.

```

*aws.s3.ObjectMetadata.getSSEAlgorithm*

```notalanguage
  GETSSEALGORITHM Returns algorithm when encrypting an object using managed keys

```

*aws.s3.ObjectMetadata.getSSEAwsKmsKeyId*

```notalanguage
  GETSSEAWSKMSKEYID Returns KMS key id for server side encryption of an object

```

*aws.s3.ObjectMetadata.getSSECustomerAlgorithm*

```notalanguage
  GETSSECUSTOMERALGORITHM Returns algorithm used with customer-provided keys
  Returns the server-side encryption algorithm if the object is encrypted using
  customer-provided keys.

```

*aws.s3.ObjectMetadata.getSSECustomerKeyMd5*

```notalanguage
  GETSSECUSTOMERKEYMD Returns the MD5 digest of the encryption key
  Returns the base64-encoded MD5 digest of the encryption key for server-side
  encryption, if the object is encrypted using customer-provided keys.

```

*aws.s3.ObjectMetadata.getUserMetadata*

```notalanguage
  GETUSERMETADATA Gets the custom user-metadata for the associated object
  A containers.Map of the metadata keys and values is returned. If there is
  no metadata an empty containers.Map is returned.
 
  Example:
    myDownloadedMetadata = s3.getObjectMetadata(myBucket, myObjectKey);
    myMap = myDownloadedMetadata.getUserMetaData();
    myMetadataValue = myMap(lower('myMetadataKey'));

```

*aws.s3.ObjectMetadata.getUserMetaDataOf*

```notalanguage
  GETUSERMETADATAOF Returns the value of the specified user meta datum

```


#### aws.s3.Client

```notalanguage
  CLIENT Amazon S3 Client
 
  Amazon Simple Storage Service (Amazon S3) is storage for the Internet.
  Amazon S3 can be used to store and retrieve any amount of data at any
  time, from anywhere on the web: https://aws.amazon.com/documentation/s3/
 
   Encryption Schemes:
 
  The encryption scheme to be used is defined as a property. The supported
  encryption scheme are as follows:
    'NOENCRYPTION'  : do not use encryption (default)
    'CSESMK'        : client side with a symmetric master key
    'CSEAMK'        : client side with an asymmetric master key
    'SSEC'          : server side encryption with a customer supplied key
    'KMSCMK'        : Key Management Service managed customer master key
    'SSEKMS'        : server side encryption using the Key Management Service
    'SSES3'         : server side encryption using S3 managed encryption keys
  A scheme is selected as follows:
        s3 = aws.s3.Client();
        s3.encryptionScheme = 'SSES3';
        s3.initialize();
 
  If using 'NOENCRYPTIION' data will NOT be encrypted at rest on S3.
 
  If using 'CSEAMK' then a Client-side Asymmetric Master Key argument of
  type java.security.KeyPair is also required e.g.
        s3 = aws.s3.Client();
        s3.encryptionScheme = 'CSEAMK';
        s3.CSEAMKKeyPair = s3.generateCSEAsymmetricMasterKey(1024);
        s3.initialize();
 
  If using 'CSESMK' then a Client-side Symmetric Master Key argument of type
  javax.crypto.spec.SecretKeySpec is also required, e.g:
        s3 = aws.s3.Client();
        s3.encryptionScheme = 'CSESMK';
        s3.CSESMKKey = s3.generateCSESymmetricMasterKey('AES', 256);
        s3.initialize();
 
  If using 'SSEC' a key of type com.amazonaws.services.s3.model.SSECustomerKey
  is required as an argument to put and get calls but is not used at client
  initialization.
 
  If using 'KMSCMK' a KMS managed Customer Master Key ID is required as an
  additional client property, e.g:
        s3 = aws.s3.Client();
        s3.KMSCMKKeyID = 'c6123457-cea5-476a-abb9-a0a4f678e8e';
        s3.initialize();
 
  If using 'SSEKMS' an argument of type
  com.amazonaws.services.s3.model.SSEAwsKeyManagementParams is required for
  put calls but not gets as the key is known and the decryption is
  performed on the server side.
 
  If using 'SSES3' S3 will manage the encryption keys, this is used as the
  AWS default server side encryption scheme.
 
 
   Authentication Credentials
 
  By default the AWS Credentials Provider Chain will be used, this means
  the client will attempt to Authenticate using credentials in the following
  order:
   * Environment variables: AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
   * Java system properties: aws.accessKeyId and aws.secretKey.
   * The default credential profiles file: typically located at
     ~/.aws/credentials (location can vary per platform), and shared by many
     of the AWS SDKs and by the AWS CLI. A credentials file can be created
     by using the aws configure command provided by the AWS CLI, or
     create it by editing the file with a text editor. For information about
     the credentials file format, see:
     https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html#credentials-file-format
   * Amazon ECS container credentials: loaded from the Amazon ECS if the
     environment variable AWS_CONTAINER_CREDENTIALS_RELATIVE_URI is set.
   * Instance profile credentials: used on EC2 instances, and delivered
     through the Amazon EC2 metadata service. Instance profile credentials
     are used only if AWS_CONTAINER_CREDENTIALS_RELATIVE_URI is not set.
   * For more information see:
     https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html
 
  Set the client property useCredentialsProviderChain to false to skip the use
  of the provider chain. In this case, the client will then expect to
  find a file called "credentials.json" on the MATLAB path. A template for
  this file can be found in the config folder.
 
  An alternative filename and path can be used if specified as follows:
 
        s3 = aws.s3.Client();
        s3.useCredentialsProviderChain = false;
        % using a Unix style path in this case
        s3.credentialsFilePath= '/home/myusername/creddir/mycredentials.file'
        s3.initialize();
 
  The contents of this file contains a JSON formatted snippet that contains
  the access and secret keys. An alternate filename can be provided as an
  argument.
 
  Example:
  {
      "aws_access_key_id" : "YOUR_ACCESS_KEY_GOES_HERE",
      "secret_access_key" : "YOUR_SECRET_ACCESS_KEY_GOES_HERE",
      "region" : "us-west-1"
  }
 
  Use this configuration to specify the region as shown above.
 
  Short term session tokens are also supported using an additional entry
  like:
      "session_token" : "FQoDYX<REDACTED>KL7kw88F"
 
  Please see the authentication section of the documentation for more details.
 
   Proxy Support:
 
  If a proxy is required to reach the S3 service this is configured using a
  ClientConfiguration, a simple example of which is as follows:
        s3 = aws.s3.Client();
        s3.clientConfiguration.setProxyHost('proxyHost','myproxy.example.com');
        s3.clientConfiguration.setProxyPort(8080);
        s3.initialize();
  If the proxy details are configured in the MATLAB preferences they
  will be used automatically.
 
   Alternate endpointURI:
 
  If an alternative endpoint is required, e.g. if using an non-Amazon S3
  service one can specified it as follows:
        s3 = aws.s3.Client();
        s3.endpointURI = 'https//mylocals3.example.com';
        s3.initialize();

```

*aws.s3.Client.copyObject*

```notalanguage
  COPYOBJECT Copies a source object to a new destination in Amazon S3
  All object metadata for the source object except server-side-encryption,
  storage-class and website-redirect-location are copied to the new destination
  object.
  The Amazon S3 Access Control List (ACL) is not copied to the new object.
  The new object will have the default Amazon S3 ACL.
 
  For files less than 100MB the underlying API call used is
  com.amazonaws.services.s3.AmazonS3Client.copyObject and the returned result
  is a com.amazonaws.services.s3.model.CopyObjectResult wrapped as
  aws.s3.model.CopyObjectResult.
 
  For larger files the underlying API call used is
  com.amazonaws.services.s3.transfer.copy and
  a com.amazonaws.services.s3.transfer.model.CopyResult is returned wrapped
  as a aws.s3.transfer.model.CopyResult.
  
  % Example;
     s3 = aws.s3.Client();
     s3.initialize();
     result = s3.copyObject('mysourcebucket','mysourckey','mydestinationbucket', 'mydestinationkey');

```

*aws.s3.Client.createBucket*

```notalanguage
  CREATEBUCKET Method to create a bucket on the Amazon S3 service
  Create a bucket on the S3 service
 
    s3 = aws.s3.Client();
    s3.initialize();
    s3.createBucket('com-example-testbucket-jblog');
 
  Amazon S3 bucket names are globally unique, so once a bucket name has
  been taken by any user, it cannot be used to create another bucket with the same
  name and it takes a while for the name to become available for reuse.
 
  Bucket names cannot contain UPPERCASE characters so all inputs are
  converted to lowercase.
 
  Amazon recommends that all bucket names comply with DNS naming conventions.
 
  Please see:
  http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html
 
  If an invalid name is passed createBucket will attempt to minimally alter it
  to comply with the rules. If the name has been altered the altered flag will
  be returned as true. The nameUsed return value returns the name that is passed
  to S3.

```

*aws.s3.Client.deleteBucket*

```notalanguage
  DELETEBUCKET Method to delete an Amazon S3 bucket
  Delete a bucket on the S3 service. For example:
 
    s3 = aws.s3.Client();
    s3.initialize();
    s3.deleteBucket('com-mathworks-testbucket');
 
  The deletion of the bucket destroys this bucket (and all its contents)
  irreversibly.

```

*aws.s3.Client.deleteObject*

```notalanguage
  DELETEOBJECTS Method to delete an object
  Removes the specified object from the specified S3 bucket.
  Unless versioning has been turned on for the bucket.
  There is no way to undelete an object, so use caution when deleting objects.
 
    s3.deleteObject(bucketName, key);

```

*aws.s3.Client.doesBucketExist*

```notalanguage
  DOESBUCKETEXIST Method to check if a bucket exists on S3
 
    s3 = aws.s3.Client();
    s3.initialize();
    s3.doesBucketExist('com-mathworks-testbucket-jblog');
 
  Amazon S3 bucket names are globally unique, so once a bucket name has
  been taken by any user, another bucket with that same name cannot be created
  for a while.
 
  For a listing of buckets see listBuckets()
 
  Amazon recommends that all bucket names comply with DNS naming conventions.
 
  Please see:
  http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html

```

*aws.s3.Client.doesObjectExist*

```notalanguage
  DOESOBJECTEXIST Method to check if an object exists in an S3 bucket
 
    s3 = aws.s3.Client();
    s3.initialize();
    s3.doesObjectExist('com-mathworks-testbucket-jblog', 'myobject');

```

*aws.s3.Client.generateCSEAsymmetricMasterKey*

```notalanguage
  GENERATECSEASYMMETRICMASTERKEY Method to generate a client-side key pair
  The returned key pair can be used for asymmetric client side encryption
  DiffieHellman, DSA and RSA keys can be generated by the underlying libraries
  however AWS support is only provided for RSA. RSA keys of a minimum
  length of 512 bits are required.
 
  Example:
    myKeyPair = s3.generateCSEAsymmetricKey(512);
    By default an RSA key of 1024 bit will be generated
    myKeyPair = s3.generateCSEAsymmetricKey();
 
  The individual keys can be extracted from a keypair as follows:
    privateKey = keyPair.getPrivate();
    publicKey = keyPair.getPublic();

```

*aws.s3.Client.generateCSESymmetricMasterKey*

```notalanguage
  GENERATECSESYMMETRICMASTERKEY Method to generate a client-side S3 key
  The returned key can be used for client side encryption using a symmetric
  key that is 256 bits in length. 128 and 196 bit keys can also be used.
  The AES algorithm is used. With keys of this length this method should
  NOT be considered secure.
 
  Example:
    myKey = s3.generateCSESymmetricKey('AES',256);
    By default a 256 bit AES keys will be generated
    myKey = s3.generateCSESymmetricKey();

```

*aws.s3.Client.generatePresignedUrl*

```notalanguage
  GENERATEPRESIGNEDPUT generates a pre-signed HTTP Put or Get URL
  Returns a pre-signed URL (as a char vector) for upload using a HTTP Put
  request or downloading using a Get request. The URL is valid for one hour
  for the named object and bucket.
  Other URL HTTP request types are not supported at this point.
 
  Example;
     s3 = aws.s3.Client();
     s3.initialize();
     ingestUrl = s3.generatePresignedUrl('myuploadbucket','myobject.mp4','put');

```

*aws.s3.Client.generateSSECKey*

```notalanguage
  GENERATESECRETKEY Method to generate a secret key for use with Amazon S3
  The method generates a key that is suitable for use with server side
  encryption using a client side provided and managed key. Only AES 256 bit
  encryption is supported.
 
  Example:
    mykey = s3.generateSSECKey();

```

*aws.s3.Client.getBucketAcl*

```notalanguage
  GETBUCKETACL Method to get the ACL of an existing Amazon S3 bucket
  Get the ACL for a bucket, the ACL can then be inspected or applied to
  another bucket. Depending on the permissions of the bucket it is possible
  that an empty ACL with no properties will be returned, e.g. if the bucket
  is owned by a 3rd party.
 
    s3.getBucketAcl(bucketName);

```

*aws.s3.Client.getObject*

```notalanguage
  GETOBJECT Method to retrieve a file object from Amazon S3
  Download an object from a given bucket with a given key name. If
  downloading a file it will be saved using keyName as the filename
  or optionally a specified filename.
 
  When an object is downloaded, all of the object's metadata and
  a stream from which to read the contents, become available.
  It is important to read the contents of the stream as quickly as
  possibly since the data is streamed directly from Amazon S3 and the
  network connection will remain open until all the data has been read or
  the input stream is closed.
 
  Example:
  In the simplest case one simply specifies a bucket name and key name as
  character arrays.
 
    s3 = aws.s3.Client();
    s3.initialize();
    s3.getObject('com-mathworks-testbucket','MyData.mat');
 
  Optionally a filename can be provided, in which case if the object is a
  file it will be written to the filename otherwise the key value will be
  used as the filename.
 
    s3.getObject(bucketName, keyName, fileName);
 
  If the method will result in a file being overwritten a
  warning is produced and the operation proceeds. If a directory is to be
  overwritten an error is produced.
 
  If using SSEC encryption then a customer provided and managed key must
  also be provided. An optional filename can still be provided as the
  final argument in the argument list.
 
    s3.getObject(bucketName, keyName, SSECustomerKey);
 
  For files of 100MB and greater a aws.s3.transfer.TransferManager based
  download will be used this can call be used with smaller files by using
  TransferManager directly.
 
  See also: aws.s3.transfer.TransferManager

```

*aws.s3.Client.getObjectAcl*

```notalanguage
  GETOBJECTACL Method to get the ACL of an existing Amazon S3 object
  Get the ACL for the object, the ACL can then be inspected or applied to
  another object
 
    s3.getObjectAcl(bucketName, keyName);

```

*aws.s3.Client.getObjectMetadata*

```notalanguage
  GETOBJECTMETADATA Method to retrieve an Amazon S3 object's metadata
  Download an object's metadata without downloading the object itself
 
  Examples:

```

*aws.s3.Client.getS3AccountOwner*

```notalanguage
  GETS3ACCOUNTOWNER returns owner of the AWS account making the request

```

*aws.s3.Client.initialize*

```notalanguage
  INITIALIZE Configure the MATLAB session to connect to S3
  Once a client has been configured, initialize is used to validate the
  client configuration and initiate the connection to S3
 
  Example:
        s3 = aws.s3.Client();
        s3.encryptionScheme = 'SSES3';
        s3.initialize();

```

*aws.s3.Client.listBuckets*

```notalanguage
  LISTBUCKETS Method to list the buckets available to the user
  The list of buckets names are returned as a table to the user.
 
    s3 = aws.s3.Client()
    s3.initialize();
    s3.listBuckets();

```

*aws.s3.Client.listObjects*

```notalanguage
  LISTOBJECTS Method to list the objects in an S3 bucket
  Objects in a particular bucket can be listed using:
 
    s3.listObjects(bucketName);
 
  For example:
    s3.listObjects('com-mathworks-mybucket');
 
  The results of the query are returned in as a MATLAB table.
  If the bucket is empty an empty table is returned.
 
  To retrieve only objects below a certain level,
   e.g. from s3://com-mathworks-mybucket/my/path, use the path as an input.
 
    s3.listObjects('com-mathworks-mybucket', 'my/path');
 
 
  When listing and fetching data in other account owned buckets, depending
  on the ACL configuration, the user may not be able to retrieve the owner
  information. In such cases the owner for the object will be set to an
  empty string.

```

*aws.s3.Client.load*

```notalanguage
  LOAD, Method to load data from Amazon S3 into the workspace
  This method behaves similarly to the standard MATLAB load command in its
  functional form. It reads back from a specific object in a given bucket.It
  returns the results in a structure with the given variable names.
  Optionally a server side client provider and managed encryption key can
  be provided.
 
  Example:
    % load a named variable from the file using an SSEC key
    s3.load(bucketname, objectname, SSECustomerKey, 'my_variable_name');
 
    % load regardless of file extension
    s3.load(bucketname, NonMAT_objectname, 'my_variable_name', '-mat');
 
    % load entire file
    s3.load(bucketname, objectname, 'my_variable_name');
 
  Using load to load a subset of a file will not improve access time as the
  complete file is downloaded.

```

*aws.s3.Client.putObject*

```notalanguage
  PUTOBJECT uploads an object to an Amazon S3 bucket
  Uploads a file as an object to the specified Amazon S3 bucket.
 
  Examples:
    s3 = aws.s3.Client();
    s3.initialize();
    % Create a sample dataset
    x = rand(1000,1000); % Approx 7MB
    save myData x;
    s3.putObject('com-mathworks-mytestbucket', 'myData.mat');
 
  Optionally, a key name for the object can be specified, the object will then
  be referenced using the key name rather than the filename value.
 
    s3.putObject('com-mathworks-mytestbucket', 'myFile.mat', 'myFileObjectName');
 
  If an absolute path is not provided, the MATLAB path will be searched for the
  names file.
 
  If using SSEC or SSEKMS encryption a key or parameter argument respectively
  must be provided. An optional object name can still be provided as the
  final entry in the argument list:
 
    s3.putObject('myBucketName', 'myObject.mat', 'mySSECKey');
    s3.putObject('myBucketName', 'myObject.csv', 'mySSEKeyManagementParams');
 
  When uploading a file the client automatically computes a checksum of the
  file. Amazon S3 uses checksums to validate the data in each file.
  Using the file extension, Amazon S3 attempts to determine the correct
  content type and content disposition to use for the object.
 
  The specified bucket must already exist and the caller must have
  "Permission.Write" permission to the bucket to upload an object.
 
  Amazon S3 is a distributed system. If Amazon S3 receives multiple write
  requests for the same object nearly simultaneously, all of the objects
  might be stored. However, only one object will obtain the key.
 
  Amazon S3 never stores partial objects; if during this call an exception
  wasn't thrown, the entire object was stored.
 
  An ObjectMetadata object can be uploaded along with and object, it can be used
  to specify custom metadata for that object. This metadata can later be
  downloaded without downloading the entire object.
  .mat file objects are uploaded with a user metadata key and value pair of
  'com-mathworks-matlabobject' and 'file' respectively.
 
   s3.putObject('myBucket', 'myObject.mat', 'myObjectName.mat',myObjectMetadata);
 
  For files of 100MB and greater a aws.s3.transfer.TransferManager based
  upload will be used this can call be used with smaller files by using
  TransferManager directly.
 
  See also: aws.s3.transfer.TransferManager

```

*aws.s3.Client.save*

```notalanguage
  SAVE Method to save files or variables to an Amazon S3 bucket
  A higher level method that uses the built in save syntax to save data to an
  S3 bucket. Save can be used very much like the functional form of the built-in
  save command with two exceptions:
    1) The '-append' option is not supported.
    2) An entire workspace cannot be saved e.g.
    s3.save('my_work_space.mat');
  The workspace variables should be listed explicitly to overcome this or first
  save the workspace to a local file and then save the resulting file to S3.

```

*aws.s3.Client.setBucketAcl*

```notalanguage
  SETBUCKETACL Method to set an ACL on an existing object S3 Bucket
  Sets an ACL on a bucket on the S3 service.
 
    s3.setBucketAcl('com-example-testbucket',myACL);
 
  This can be used along with getBucketAcl() to get and reuse an existing
  ACL. Alternately a preconfigured "canned" ACL can be used e.g.:
 
  myCannedACL = aws.s3.CannedAccessControlList('AuthenticatedRead')
  s3.setBucketAcl('com-example-testbucket',myCannedACL)
 
  See Amazon S3 JDK SDK for a complete list of canned ACLs.

```

*aws.s3.Client.setObjectAcl*

```notalanguage
  SETOBJECTACL Method to set an ACL on an existing object S3 object
  Sets an ACL on an object on the S3 service, the ACL is provided as
  an argument along with a bucket and keyname.
 
    s3.setObjectAcl('com-mathworks-testbucket','mykeyname',myacl);
 
  This can be used along with getObjectAcl() to get and reuse an existing
  ACL. Alternately a preconfigured "canned" ACL can be used e.g.:
 
  myCannedACL = aws.s3.CannedAccessControlList('AuthenticatedRead')
  s3.setObjectAcl('com-mathworks-testbucket','MyData.mat',myCannedACL)
 
  See Amazon S3 JDK SDK for a complete list of canned ACLs.

```

*aws.s3.Client.setSSEAwsKeyManagementParams*

```notalanguage
  SETSSEAWSKEYMANAGMENTPARAMS Method to set property to request KMS
  This method is used to setup a parameter property that is used with the
  putObject() method to server side encrypt the data at rest.
  If the key ID value is not provided then s3 uses the master default
  key, otherwise a user created key can be requested and used by giving
  the desired key ID.
 
  Example:
    params = s3.setSSEAwsKeyManagementParams();
 
    params = s3.setSSEAwsKeyManagementParams('c1234567-cba2-456a-ade9-a1a3f84c9a8a');

```

*aws.s3.Client.shutdown*

```notalanguage
  SHUTDOWN Method to shutdown an Amazon s3 client and release resources
  This method should be called to cleanup a client which is no longer
  required.
 
  Example:  s3.shutdown()

```


#### aws.s3.Grant

```notalanguage
  GRANT Specifies a grant, consisting of one grantee and one permission
  A Grant object can be created using either a grantee and a permission or
  using a Java Grant object. If using a grantee and permission they may be
  either Java com.amazonaws.services.s3.model.<Grantee Type> or MATLAB
  aws.s3.<Grantee Type>. CanonicalGrantee, EmailAddressGrantee and
  GroupGrantee types are supported.
 
  Examples:
     myGrant = aws.s3.Grant(myGrantee, myPermission);
     % or
     myGrant = aws.s3.Grant(myJavaGranteeObject);

```

*aws.s3.Grant.getGrantee*

```notalanguage
  GRANTEE Gets the grantee being granted a permission by this grant
  An object of type CanonicalGrantee, EmailAddressGrantee or GroupGrantee is
  returned.
 
  Example:
    grants = myAcl.getGrantsAsList();
     grantee = grants{1}.getGrantee();
     % show the identifier of the first grantee
     grantee.Identifier

```

*aws.s3.Grant.getPermission*

```notalanguage
  GETPERMISSION Gets the permission being granted to the grantee by this grant
  An aws.s3.Permission object is returned.

```


#### aws.s3.GroupGrantee

```notalanguage
  GROUPGRANTEE Defines group based grantee, returns Java GroupGrantee object
  Permitted values are: AllUsers, AuthenticatedUsers, Logdelivery
 
  Here it is used to grant a permission to an ACL along with a permission:
 
  Example:
    my_group_grantee = aws.s3.GroupGrantee('AllUsers');
    my_perm = aws.s3.Permission('read');
    my_acl = aws.s3.AccessControlList();
    my_acl.grantPermission(my_group_grantee, my_perm);
 
  In practice values map to URLs that define them, e.g.
  AllUsers maps to http://acs.amazonaws.com/groups/global/AllUsers

```


#### aws.s3.AccessControlList

```notalanguage
  ACCESSCONTROLLIST class to define a S3 ACL object
  The AccessControlList method calls the constructor for the AWS Java SDK
  ACL object
 
  Example:
    s3 = aws.s3.Client();
    s3.initialize();
    my_acl = aws.s3.AccessControlList();
    my_perm = aws.s3.Permission('read');
    email_addr_grantee = aws.s3.EmailAddressGrantee('joe.blog@example.com');
    my_acl.grantPermission(email_addr_grantee, my_perm);

```

*aws.s3.AccessControlList.getGrantsAsList*

```notalanguage
  GETGRANTSASLIST Method to return a list of grants associated with an ACL
  The list is returned as a MATLAB cell array.
  Each grant consists of a grantee and a permission.
  An empty cell array is returned if there are no grants.
 
  Example:
   s3 = aws.s3.Client();
   s3.initialize();
   acl = s3.getObjectAcl(bucketname,keyname);
   grantlist = acl.getGrantsAsList();

```

*aws.s3.AccessControlList.grantPermission*

```notalanguage
  GRANTPERMISSION Method to add a permission grant to an existing S3 ACL
 
  Example:
    my_acl = aws.s3.AccessControlList();
    my_perm = aws.s3.Permission('read');
    email_addr_grantee = aws.s3.EmailAddressGrantee('joe.blog@example.com');
    my_acl.grantPermission(email_addr_grantee, my_perm);

```

*aws.s3.AccessControlList.setOwner*

```notalanguage
  SETOWNER Method to set the owner of an ACL
 
  Example:
    acl = aws.s3.AccessControlList();
    owner = aws.s3.createOwner();
    owner.setDisplayName('my_display_name');
    owner.setId('aba123456a64f60b91c7736971a81116fb2a07fff2331499c04a967c243b7576');
    acl.setOwner(owner);

```


#### aws.s3.Owner

```notalanguage
  CREATEOWNER Creates an owner object for an ACL
 
  Example:
    s3 = aws.s3.Client();
    s3.initialize();
    acl = aws.s3.AccessControlList();
    owner = aws.s3.Owner();
    owner.setDisplayName('my_disp_name');
    owner.setId('1234567890abcdef');

```

*aws.s3.Owner.setDisplayName*

```notalanguage
  SETOWNERDISPLAYNAME Method to set the DisplayName of an owner of an ACL
 
  Example:
    s3 = aws.s3.Client();
    s3.initialize();
    acl = aws.s3.AccessControllist();
    owner = aws.s3.Owner();
    owner.setDisplayName('my_display_name');
    owner.setId('aba123456a64f60b91c7736971a81116fb2a07fff2331499c04a967c243b7576');
    acl.setOwner(owner);

```

*aws.s3.Owner.setId*

```notalanguage
  SETID Method to set the Id of an Owner of an ACL
 
  Example:
    s3 = aws.s3.Client();
    s3.initialize();
    acl = aws.s3.AccessControlList();
    owner = aws.s3.Owner();
    owner.setDisplayName('my_display_name');
    owner.setId('aba123456a64f60b91c7736971a81116fb2a07fff2331499c04a967c243b7576');
    acl.setOwner(owner);

```


#### aws.s3.transfer.AbortableTransfer

```notalanguage
  ABORTABLETRANSFER Represents an asynchronous transfer that can be aborted

```

*aws.s3.transfer.AbortableTransfer.abort*

```notalanguage
aws.s3.transfer.AbortableTransfer/abort is a function.
    abort(obj)

```


#### aws.s3.transfer.Copy

```notalanguage
  CopyRepresents an asynchronous copy request from one Amazon S3 location another
  See TransferManager for more information about creating transfers.
  Please note that when copying data between s3 buckets there is no progress
  updates whilst data is in transit. This means that the 
  TransferProgress.getBytesTransferred() will not be accurate until the copy
  is complete.
 
  Example:
    tmb = aws.s3.transfer.TransferManagerBuilder();
    tmb.setS3Client(s3);
    tm = tmb.build();
    copy = tm.copy(sourceBucketName, sourceKeyName, destinationBucketName, destinationKeyName);
    copyResult = copy.waitForCopyResult();

```

*aws.s3.transfer.Copy.waitForCopyResult*

```notalanguage
  WAITFORCOPYRESULT Waits for the copy request to complete and returns the result of this request

```


#### aws.s3.transfer.Download

```notalanguage
  DOWNLOAD Represents an asynchronous download from Amazon S3
  A aws.s3.transfer.Download is returned created using a
  aws.s3.transfer.TransferManager.download call.
 
  Example:
    tmb = aws.s3.transfer.TransferManagerBuilder();
    tmb.setS3Client(s3);
    tm = tmb.build();
    download = tm.download(bucketName, keyName, localPath);
    download.waitForCompletion();
 
    % Download can also be called using a aws.s3.model.GetObjectRequest
    download = tm.download(getObjectRequest, localPath);
    download.waitForCompletion();

```

*aws.s3.transfer.Download.pause*

```notalanguage
  PAUSE Pause the current download operation
  Returns the information that can be used to resume the download at a later time.

```

*aws.s3.transfer.Download.getObjectMetadata*

```notalanguage
  GETOBJECTMETADATA Returns the ObjectMetadata for the object being downloaded

```

*aws.s3.transfer.Download.getKey*

```notalanguage
  GETKEY The key under which this object

```

*aws.s3.transfer.Download.getBucketName*

```notalanguage
  GETBUCKETNAME The name of the bucket where the object is being downloaded from

```

*aws.s3.transfer.Download.delete*

```notalanguage
 DELETE   Delete a handle object.
    DELETE(H) deletes all handle objects in array H. After the delete 
    function call, H is an array of invalid objects.
 
    See also AWS.S3.TRANSFER.DOWNLOAD, AWS.S3.TRANSFER.DOWNLOAD/ISVALID, CLEAR

Help for aws.s3.transfer.Download/delete is inherited from superclass handle

```


#### aws.s3.transfer.MultipleFileDownload

```notalanguage
  MULTIPLEFILEDOWNLOAD Multiple file download of an entire virtual directory
 
  Example:
    tmb = aws.s3.transfer.TransferManagerBuilder();
    tmb.setS3Client(testCase.s3);
    tm = tmb.build();
    multipleFileDownload = tm.downloadDirectory(bucketName, virtualDirectoryKeyPrefix, downloadDirectory);
    multipleFileDownload.waitForCompletion();

```

*aws.s3.transfer.MultipleFileDownload.getKeyPrefix*

```notalanguage
  GETKEYPREFIX Returns the key prefix of the virtual directory being downloaded

```

*aws.s3.transfer.MultipleFileDownload.getBucketName*

```notalanguage
  GETBUCKETNAME Returns the name of the bucket from which files are downloaded

```


#### aws.s3.transfer.MultipleFileUpload

```notalanguage
  MULTIPLEFILEUPLOAD Multiple file upload of an entire virtual directory
 
  Example:
    tmb = aws.s3.transfer.TransferManagerBuilder();
    tmb.setS3Client(testCase.s3);
    tm = tmb.build();
    multipleFileUpload = tm.uploadDirectory(bucketName, virtualDirectoryKeyPrefix, directory, includeSubdirectories);
    multipleFileUpload.waitForCompletion();

```

*aws.s3.transfer.MultipleFileUpload.getKeyPrefix*

```notalanguage
  GETKEYPREFIX Returns the key prefix of the virtual directory being uploaded

```

*aws.s3.transfer.MultipleFileUpload.getBucketName*

```notalanguage
  GETBUCKETNAME Returns the name of the bucket to which files are uploaded

```


#### aws.s3.transfer.PauseResult

```notalanguage
  PAUSERESULT Information that can be used to resume the paused operation; can be null if the pause failed

```

*aws.s3.transfer.PauseResult.getPauseStatus*

```notalanguage
  PAUSESTATUS Returns information about whether the pause was successful or not; and if not why

```


#### aws.s3.transfer.PresignedUrlDownload

```notalanguage
  PRESIGNEDURLDOWNLOAD Represent the output for the asynchronous download operation using presigned url

```

*aws.s3.transfer.PresignedUrlDownload.getPresignedUrl*

```notalanguage
  GETPRESIGNEDURL The presigned url from which the object is being downloaded

```


#### aws.s3.transfer.Transfer

```notalanguage
 TRANSFER Represents an asynchronous upload to or download from Amazon S3
  Use this class to check a transfer's progress,
  add listeners for progress events, check the state of a transfer,
  or wait for the transfer to complete.

```

*aws.s3.transfer.Transfer.waitForCompletion*

```notalanguage
  WAITFORCOMPLETION Waits for this transfer to complete

```

*aws.s3.transfer.Transfer.isDone*

```notalanguage
  ISDONE Returns whether or not the transfer is finished
  (i.e. completed successfully, failed, or was canceled)
  A logical is returned.

```

*aws.s3.transfer.Transfer.getState*

```notalanguage
  GETSTATE Returns the current state of this transfer

```

*aws.s3.transfer.Transfer.getProgress*

```notalanguage
  GETPROGRESS Returns progress information about this transfer

```

*aws.s3.transfer.Transfer.getDescription*

```notalanguage
  GETDESCRIPTION Returns a human-readable description of this transfer

```


#### aws.s3.transfer.TransferManager

```notalanguage
  TransferManager High level utility for managing transfers to Amazon S3
 
  Examples:
    % Create a TransferManager object
    tmb = aws.s3.transfer.TransferManagerBuilder();
    tmb.setS3Client(s3);
    tm = tmb.build();
 
    % Download an object to a local file
    download = tm.download(bucketName, keyName, localPath);
    download.waitForCompletion();
 
    % Abort previous in-flight uploads to a given bucket
    tm.abortMultipartUploads(bucketName, datetime('now'));
 
    % Copy an object to another object
    copy = tm.copy(sourceBucketName, sourceKeyName, destinationBucketName, destinationKeyName);
    copyResult = copy.waitForCopyResult();
 
    % Aborts any multipart uploads that were initiated before the specified date
    tm.abortMultipartUploads(bucketName, datetime('now'));
 
    % Downloads all objects in the virtual directory designated by the given keyPrefix to the destination directory
    multipleFileDownload = tm.downloadDirectory(testCase.bucketName, virtualDirectoryKeyPrefix, tDownloadDir);
    multipleFileDownload.waitForCompletion();
 
    % Uploads all files in the directory to a named bucket
    multipleFileUpload = tm.uploadDirectory(bucketName, virtualDirectoryKeyPrefix, directory, includeSubdirectories);
    multipleFileUpload.waitForCompletion();
 
    % Upload a file to a local S3 object
    upload = tm.upload(bucketName, keyName, localPath);
    result = upload.waitForUploadResult();
 
    % Shut down a TransferManger when transfers have completed
    % shutDownS3Client, a logical whether to shut down the underlying Amazon S3 client.
    tm.shutdownNow(shutDownS3Client)

```

*aws.s3.transfer.TransferManager.shutdownNow*

```notalanguage
  SHUTDOWNNOW Forcefully shuts down this TransferManager instance
  Currently executing transfers will not be allowed to finish.
  Callers should use this method when they either:
  * have already verified that their transfers have completed by checking each transfer's state
  * need to exit quickly and don't mind stopping transfers before they complete. 
  Callers should also remember that uploaded parts from an interrupted upload
  may not always be automatically cleaned up, but callers can use
  abortMultipartUploads(datetime) to clean up any upload parts.
  shutDownS3Client, Logical whether to shut down the underlying Amazon S3 client.

```

*aws.s3.transfer.TransferManager.upload*

```notalanguage
  UPLOAD Initiates and upload and returns an aws.s3.transfer.Upload object
 
  Example:
    upload = tm.upload(bucketName, keyName, localPath);
    result = upload.waitForUploadResult();

```

*aws.s3.transfer.TransferManager.uploadFileList*

```notalanguage
  UPLOADFILELIST Uploads all specified files to the named bucket named
  constructing relative keys depending on the commonParentDirectory given
  S3 will overwrite any existing objects that happen to have the same key,
  just as when uploading individual files, so use with caution.
 
  Note:
    There appears to be an issue with the underlying AWS function
    pending further investigation see the alternative upload methods.
 
  bucketName - The name of the bucket to upload objects to.
  bucketName should be of type char or a scalar string.
 
  virtualDirectoryKeyPrefix - The key prefix of the virtual directory to
  upload to. Use an empty string to upload files to the root of the bucket.
  virtualDirectoryKeyPrefix should be of type char or a scalar string.
 
  directory - The common parent directory of files to upload.
  The keys of the files in the list of files are constructed relative to
  this directory and the virtualDirectoryKeyPrefix.
  directory should be of type char or a scalar string.
 
  files - A list of files to upload. The keys of the files are calculated
  relative to the common parent directory and the virtualDirectoryKeyPrefix.
  Files should be of type string or string array.
 
  An aws.s3.transfer.MultipleFileUpload is returned.

```

*aws.s3.transfer.TransferManager.uploadDirectory*

```notalanguage
  UPLOADDIRECTORY Uploads all files in the directory to a named bucket
  Optionally recursing for all subdirectories
  S3 will overwrite any existing objects that happen to have the same key,
  just as when uploading individual files.
 
  bucketName should be of type char or a scalar string.
  virtualDirectoryKeyPrefix should be of type char or a scalar string.
  directory should be of type char or a scalar string.
  includeSubdirectories should be of type logical.
  An aws.s3.transfer.MultipleFileUpload is returned.
 
  Example:
     multipleFileUpload = tm.uploadDirectory(bucketName, virtualDirectoryKeyPrefix, directory, includeSubdirectories);
     multipleFileUpload.waitForCompletion();

```

*aws.s3.transfer.TransferManager.downloadDirectory*

```notalanguage
  DOWNLOADDIRECTORY Downloads all objects in the virtual directory designated by the given keyPrefix to the destination directory
  All virtual subdirectories will be downloaded recursively.
  An aws.s3.transfer.MultipleFileDownload is returned.
 
  Example:
    multipleFileDownload = tm.downloadDirectory(testCase.bucketName, virtualDirectoryKeyPrefix, tDownloadDir);
    multipleFileDownload.waitForCompletion();

```

*aws.s3.transfer.TransferManager.download*

```notalanguage
  DOWNLOAD Schedules a new transfer to download data from Amazon S3 and save it to the specified file
 
  Example:
    download = tm.download(bucketName, keyName, localPath);
    download.waitForCompletion();
 
    % Download can also be called using a aws.s3.model.GetObjectRequest
    download = tm.download(getObjectRequest, localPath);
    download.waitForCompletion();

```

*aws.s3.transfer.TransferManager.copy*

```notalanguage
  COPY Schedules a new transfer to copy data from one Amazon S3 location to another Amazon S3 location
 
  Example:
    copy = tm.copy(sourceBucketName, sourceKeyName, destinationBucketName, destinationKeyName);
    copyResult = copy.waitForCopyResult();

```

*aws.s3.transfer.TransferManager.abortMultipartUploads*

```notalanguage
  ABORTMULTIPARTUPLOADS Aborts any multipart uploads that were initiated before the specified date
  Uploaded parts from an interrupted upload may not always be automatically cleaned up
  abortMultipartUploads(datetime) can be used to clean up any upload parts.
 
  Example:
    tmb = aws.s3.transfer.TransferManagerBuilder();
    tmb.setS3Client(testCase.s3);
    tm = tmb.build();
    tm.abortMultipartUploads(testCase.bucketName, datetime('now'));

```

*aws.s3.transfer.TransferManager.delete*

```notalanguage
  Call shutdownNow on the TransferManager without shutting down the S3 client

```


#### aws.s3.transfer.TransferManagerBuilder

```notalanguage
  TransferManagerBuilder Use of the builder is preferred over constructors for TransferManager
 
  Example:
    tmb = aws.s3.transfer.TransferManagerBuilder();
    tmb.setS3Client(testCase.s3);
    tm = tmb.build();

```

*aws.s3.transfer.TransferManagerBuilder.withS3Client*

```notalanguage
  WITHS3CLIENT Sets the low level client used to make the service calls to Amazon S3

```

*aws.s3.transfer.TransferManagerBuilder.setShutDownThreadPools*

```notalanguage
  SETSHUTDOWNTHREADPOOLS By default, when the transfer manager is shut down, the underlying ExecutorService is also shut down

```

*aws.s3.transfer.TransferManagerBuilder.setS3Client*

```notalanguage
  SETS3CLIENT Sets the low level client used to make the service calls to Amazon S3.

```

*aws.s3.transfer.TransferManagerBuilder.setDisableParallelDownloads*

```notalanguage
  setDisableParallelDownloads Sets the option to disable parallel downloads

```

*aws.s3.transfer.TransferManagerBuilder.setAlwaysCalculateMultipartMd5*

```notalanguage
  SETALWAYSCALCULATEMULTIPARTMD5 Set to true if Transfer Manager should calculate MD5 for multipart uploads

```

*aws.s3.transfer.TransferManagerBuilder.isShutDownThreadPools*

```notalanguage
  ISSHUTDOWNTHREADPOOLS Returns a logical

```

*aws.s3.transfer.TransferManagerBuilder.isDisableParallelDownloads*

```notalanguage
  ISDISABLEPARALLELDOWNLOADS Returns if the parallel downloads are disabled or not

```

*aws.s3.transfer.TransferManagerBuilder.getMultipartCopyThreshold*

```notalanguage
  GETMULTIPARTCOPYTHRESHOLD The multipart copy threshold currently configured in the builder

```

*aws.s3.transfer.TransferManagerBuilder.getMultipartUploadThreshold*

```notalanguage
  GETMULTIPARTUPLOADTHRESHOLD The multipart upload threshold currently configured in the builder

```

*aws.s3.transfer.TransferManagerBuilder.getAlwaysCalculateMultipartMd5*

```notalanguage
  GETALWAYSCALCULATEMULTIPARTMD5 Returns true if Transfer Manager should calculate MD5 for multipart uploads

```

*aws.s3.transfer.TransferManagerBuilder.disableParallelDownloads*

```notalanguage
  disableParallelDownloads Disables parallel downloads
  See setDisableParallelDownloads

```

*aws.s3.transfer.TransferManagerBuilder.build*

```notalanguage
  BUILD Construct a TransferManager with the default ExecutorService

```

*aws.s3.transfer.TransferManagerBuilder.standard*

```notalanguage
  STANDARD Create new instance of builder with all defaults set

```

*aws.s3.transfer.TransferManagerBuilder.defaultTransferManager*

```notalanguage
  defaultTransferManager Construct a default TransferManager

```


#### aws.s3.transfer.TransferProgress

```notalanguage
  TRANSFERPROGRESS Describes the progress of a transfer
 
  Example:
    tmb = aws.s3.transfer.TransferManagerBuilder();
    tmb.setS3Client(testCase.s3);
    tm = tmb.build();
    multipleFileUpload = tm.uploadDirectory(bucketName, virtualDirectoryKeyPrefix, directory, includeSubdirectories);
    tp = multipleFileUpload.getProgress();
    a = tp.getBytesTransferred;
    b = tp.getPercentTransferred;
    c = tp.getTotalBytesToTransfer;
 
  See: https://docs.aws.amazon.com/AWSJavaSDK/latest/javadoc/index.html?com/amazonaws/services/s3/AmazonS3.html

```

*aws.s3.transfer.TransferProgress.setTotalBytesToTransfer*

```notalanguage
  SETTOTALBYTESTOTRANSFER

```

*aws.s3.transfer.TransferProgress.getTotalBytesToTransfer*

```notalanguage
  GETTOTALBYTESTOTRANSFER Returns the total size in bytes of the associated transfer, or -1 if the total size isn't known
  An int64 is returned

```

*aws.s3.transfer.TransferProgress.getPercentTransferred*

```notalanguage
  GETPERCENTTRANSFERRED Returns a percentage of the number of bytes transferred out of the total number of bytes to transfer
  A double is returned

```

*aws.s3.transfer.TransferProgress.getBytesTransferred*

```notalanguage
  GETDESCRIPTION Returns the number of bytes completed in the associated transfer
  An int64 is returned

```


#### aws.s3.transfer.TransferState

```notalanguage
  TRANSFERSTATE Enumeration of the possible transfer states
 
  Possible values are:
    The transfer was canceled and did not complete successfully
    Canceled,
    The transfer completed successfully
    Completed
    The transfer failed
    Failed
    The transfer is actively uploading or downloading and hasn't finished yet
    InProgress
    The transfer is waiting for resources to execute and has not started yet
    Waiting

```


```notalanguage
Enumeration:
  Canceled
  Completed
  Failed
  InProgress
  Waiting
```


#### aws.s3.transfer.Upload

```notalanguage
  UPLOAD Represents an asynchronous upload to Amazon S3
 
  Example:
    tmb = aws.s3.transfer.TransferManagerBuilder();
    tmb.setS3Client(testCase.s3);
    tm = tmb.build();
    upload = tm.upload(testCase.bucketName, keyName, localPath);
    result = upload.waitForUploadResult();

```

*aws.s3.transfer.Upload.waitForUploadResult*

```notalanguage
  WAITFORUPLOADRESULT Waits for this upload to complete and returns the result of this upload
  This is a blocking call. Be prepared to handle errors when calling this method.
  Any errors that occurred during the asynchronous transfer will be re-thrown through this method

```

*aws.s3.transfer.Upload.pause*

```notalanguage
  PAUSE Pause the current upload operation and returns the information that can be used to resume the upload

```

*aws.s3.transfer.Upload.abort*

```notalanguage
  ABORT Abort the current upload operation

```

*aws.s3.transfer.Upload.delete*

```notalanguage
 DELETE   Delete a handle object.
    DELETE(H) deletes all handle objects in array H. After the delete 
    function call, H is an array of invalid objects.
 
    See also AWS.S3.TRANSFER.UPLOAD, AWS.S3.TRANSFER.UPLOAD/ISVALID, CLEAR

Help for aws.s3.transfer.Upload/delete is inherited from superclass handle

```


#### aws.s3.transfer.model.CopyResult

```notalanguage
  COPYRESULT Contains information returned by Amazon S3 for a completed copy
 
  Example:
   tmb = aws.s3.transfer.TransferManagerBuilder();
   tmb.setS3Client(s3);
   tm = tmb.build();
   copy = tm.copy(sourceBucketName, sourceKeyName, destinationBucketName, destinationKeyName);
   copyResult = copy.waitForCopyResult();

```

*aws.s3.transfer.model.CopyResult.getVersionId*

```notalanguage
  GETVERSIONID Returns the version ID of the new object
  The version ID is only set if versioning has been enabled for the bucket.

```

*aws.s3.transfer.model.CopyResult.getSourceKey*

```notalanguage
  GETSOURCEKEY Gets the source bucket key under which the source object to be copied is stored

```

*aws.s3.transfer.model.CopyResult.getETag*

```notalanguage
  getETag Returns the entity tag identifying the new object

```

*aws.s3.transfer.model.CopyResult.getDestinationKey*

```notalanguage
  GETDESTINATIONKEY Gets the destination bucket key under which the new, copied object will be stored

```

*aws.s3.transfer.model.CopyResult.getDestinationBucketName*

```notalanguage
  GETDESTINATIONBUCKETNAME Gets the destination bucket name which will contain the new, copied object

```


#### aws.s3.transfer.model.PersistableTransfer

```notalanguage
  PersistableTransfer base class for the information of a pauseable upload or download
  Such information can be used to resume the upload or download later on,
  and can be serialized/deserialized for persistence purposes.

```

*aws.s3.transfer.model.PersistableTransfer.serialize*

```notalanguage
  SERIALIZE Returns the serialized representation of the paused transfer state

```


#### aws.s3.transfer.model.UploadResult

```notalanguage
  UploadResult Contains information returned by Amazon S3 for a completed upload
 
  Example:
    tmb = aws.s3.transfer.TransferManagerBuilder();
    tmb.setS3Client(s3);
    tm = tmb.build();
    upload = tm.upload(bucketName, keyName, localPath);
    uploadResult = upload.waitForUploadResult();

```

*aws.s3.transfer.model.UploadResult.getVersionId*

```notalanguage
  GETVERSIONID Returns the version ID of the new object

```

*aws.s3.transfer.model.UploadResult.getETag*

```notalanguage
  GETETAG Returns the entity tag identifying the new object

```

*aws.s3.transfer.model.UploadResult.getBucketName*

```notalanguage
  GETBUCKETNAME Returns the name of the bucket containing the uploaded object

```

*aws.s3.transfer.model.UploadResult.getKey*

```notalanguage
  GETKEY Returns the key by which the newly created object is stored

```


#### aws.s3.model.GetObjectRequest

```notalanguage
  GETOBJECTREQUEST Retrieves objects from Amazon S3
  To use GET, you must have READ access to the object.
 
  Example:
    getObjectRequest = aws.s3.model.GetObjectRequest(bucketName,keyName);

```

*aws.s3.model.GetObjectRequest.withSSECustomerKey*

```notalanguage
  WITHSSECUSTOMERKEY Sets the optional customer-provided server-side encryption key to use to decrypt this object
  Returns the updated GetObjectRequest.

```


#### aws.s3.model.PutObjectRequest

```notalanguage
  PUTOBJECTREQUEST Uploads a new object to the specified Amazon S3 bucket
 
  Example
    putObjectRequest = aws.s3.model.PutObjectRequest(bucketName, keyName, filePath);

```

*aws.s3.model.PutObjectRequest.withSSEAwsKeyManagementParams*

```notalanguage
  WITHSSEAWSKEYMANAGEMENTPARAMS Sets the Key Management System parameters used to encrypt the object on server side
  An updated PutObjectRequest is returned.

```

*aws.s3.model.PutObjectRequest.withSSECustomerKey*

```notalanguage
  WITHSSECUSTOMERKEY Sets the optional customer-provided server-side encryption key to encrypt the object
  An updated PutObjectRequest is returned.

```

*aws.s3.model.PutObjectRequest.withMetadata*

```notalanguage
  PUTOBJECTREQUEST Sets the optional metadata instructing Amazon S3 how to handle the uploaded data
  (e.g. custom user metadata, hooks for specifying content type, etc.).
  An updated PutObjectRequest is returned.

```


#### aws.s3.model.CompleteMultipartUploadRequest

```notalanguage
  COMPLETEMULTIPARTUPLOADREQUEST Results of initiating a multipart upload
 
   Contains the results of initiating a multipart upload, particularly
   the unique ID of the new multipart upload
 
  See: aws.s3.transfer.TransferManager for a high-level alternative.

```


#### aws.s3.model.CreateBucketRequest

```notalanguage
  CREATEBUCKETREQUEST Provides options for creating an Amazon S3 bucket
 
  Example;
     s3 = aws.s3.Client();
     s3.initialize();
     createBucketRequest = aws.s3.model.CreateBucketRequest('myBucketName');
     createBucketRequest.setCannedAcl(aws.s3.CannedAccessControlList('BucketOwnerFullControl'));
     s3.createBucket(createBucketRequest);

```

*aws.s3.model.CreateBucketRequest.setBucketName*

```notalanguage
  SETBUCKETNAME Sets the name of the Amazon S3 bucket to create

```

*aws.s3.model.CreateBucketRequest.setCannedAcl*

```notalanguage
  SETCANNEDACL Sets the optional Canned ACL to set for the new bucket

```

*aws.s3.model.CreateBucketRequest.setObjectOwnership*

```notalanguage
  SETOBJECTOWNERSHIP Sets the optional object ownership for the new bucket
 
  Valid string values are:
 
  BucketOwnerPreferred - Objects uploaded to the bucket change ownership to
                         the bucket owner if the objects are uploaded with
                         the bucket-owner-full-control canned ACL.
 
          ObjectWriter - The uploading account will own the object if the
                         object is uploaded with the bucket-owner-full-control
                         canned ACL.
 
   BucketOwnerEnforced - ACLs are disabled, and the bucket owner owns all the
                         objects in the bucket. Objects can only be uploaded
                         to the bucket if they have no ACL or the
                         bucket-owner-full-control canned ACL.

```


#### aws.s3.model.CopyObjectResult

```notalanguage
  COPYOBJECTRESULT Contains data returned by copyObject call
  This result may be ignored if not needed; otherwise, use this result
  to access information about the new object created from the copyObject
  call.
 
  Example;
     s3 = aws.s3.Client();
     s3.initialize();
     copyObjectResult = s3.copyObject('mysourcebucket','mysourcekey','mydestinationbucket', 'mydestinationkey');

```


#### aws.s3.model.UploadPartRequest

```notalanguage
  UPLOADPARTREQUEST Contains the parameters used for the UploadPart operation
 
  See: aws.s3.transfer.TransferManager for a high-level alternative.

```

*aws.s3.model.UploadPartRequest.setKey*

```notalanguage
  SETKEY Sets the size of this part, in bytes
 
  See: aws.s3.transfer.TransferManager for a high-level alternative.

```

*aws.s3.model.UploadPartRequest.setLastPart*

```notalanguage
  SETLASTPART Marks this part as the last part being uploaded in a multipart upload
 
  See: aws.s3.transfer.TransferManager for a high-level alternative.

```

*aws.s3.model.UploadPartRequest.setPartNumber*

```notalanguage
  setPartNumber Sets the part number
 
  Describes this part's position relative to the other parts in the multipart upload.
 
  See: aws.s3.transfer.TransferManager for a high-level alternative.

```

*aws.s3.model.UploadPartRequest.setPartSize*

```notalanguage
  SETPARTSIZE Sets the size of this part, in bytes
 
  See: aws.s3.transfer.TransferManager for a high-level alternative.

```


#### aws.s3.model.InitiateMultipartUploadRequest

```notalanguage
  InitiateMultipartUploadRequest 
 
  See: aws.s3.transfer.TransferManager for a high-level alternative.

```


#### aws.s3.model.UploadPartResult

```notalanguage
  UploadPartResult Contains the parameters used for the UploadPart operation
 
  See: aws.s3.transfer.TransferManager for a high-level alternative.

```


#### aws.s3.model.InitiateMultipartUploadResult

```notalanguage
  INITIATEMULTIPARTUPLOADRESULT Results of initiating a multipart upload
 
   Contains the results of initiating a multipart upload, particularly
   the unique ID of the new multipart upload
 
  See: aws.s3.transfer.TransferManager for a high-level alternative.

```

*aws.s3.model.InitiateMultipartUploadResult.getUploadId*

```notalanguage
  getUploadId Returns the initiated multipart upload ID
 
  See: aws.s3.transfer.TransferManager for a high-level alternative.

```


#### aws.s3.model.CompleteMultipartUploadResult

```notalanguage
  CompleteMultipartUploadResult The CompleteMultipartUploadResult contains all the information about the CompleteMultipartUpload method
 
  See: aws.s3.transfer.TransferManager for a high-level alternative.

```

##### aws.s3.mathworks.internal.int64FnHandler

```notalanguage
  int64FnHandler Invokes Java method to convert a Java long to a string and then an int64
  An int64 is returned.

```

##### aws.s3.mathworks.s3.transferMonitor

```notalanguage
  TRANSFERMONITOR Provides visual feedback for the progression of a transfer
 
  The following named parameters are accepted:
     delay : delay in seconds between updates, (default 10)
      mode : display a "percentage" value or a number of "bytes", (default percentage) 
   display : "scroll" provide updates on progressive console lines (default)
             "static" provide updates on a single console line
 
  Examples:
    upload = tm.upload(testCase.bucketName, keyName, localPath);
    aws.s3.mathworks.s3.transferMonitor(upload);
 
    aws.s3.mathworks.s3.transferMonitor(download, 'mode', 'bytes', 'display', 'static', 'delay', 1);

```

##### splitName

```notalanguage
  SPLITNAME Splits an s3 name into bucket and a list of names
 
  Splitting the name of an S3 object may be helpful when working with
  methods like putObject and getObject.
 
  Example:
    S = splitName('s3://mybucket/some/other/paths')
 
    S =
        struct with fields:
 
          protocol: 's3://'
            bucket: 'mybucket'
              rest: 'some/other/paths'
          elements: {'some'  'other'  'paths'}
               str: 's3://mybucket/some/other/paths'

```



------

##### Copyright 2017-2023, The MathWorks, Inc.
