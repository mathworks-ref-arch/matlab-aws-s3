# MATLAB Interface *for AWS S3* API documentation


## AWS S3 Interface Objects and Methods:
* @AccessControlList
* @CannedAccessControlList
* @CanonicalGrantee
* @Client
* @EmailAddressGrantee
* @EncryptionScheme
* @Grant
* @GroupGrantee
* @ObjectMetadata
* @Owner
* @Permission



------

## @AccessControlList

### @AccessControlList/AccessControlList.m
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
### @AccessControlList/getGrantsAsList.m
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
### @AccessControlList/grantPermission.m
```notalanguage
  GRANTPERMISSION Method to add a permission grant to an existing S3 ACL
 
  Example:
    my_acl = aws.s3.AccessControlList();
    my_perm = aws.s3.Permission('read');
    email_addr_grantee = aws.s3.EmailAddressGrantee('joe.blog@example.com');
    my_acl.grantPermission(email_addr_grantee, my_perm);



```
### @AccessControlList/setOwner.m
```notalanguage
  SETOWNER Method to set the owner of an ACL
 
  Example:
    acl = aws.s3.AccessControlList();
    owner = aws.s3.createOwner();
    owner.setDisplayName('my_display_name');
    owner.setId('aba123456a64f60b91c7736971a81116fb2a07fff2331499c04a967c243b7576');
    acl.setOwner(owner);



```

------


## @CannedAccessControlList

### @CannedAccessControlList/CannedAccessControlList.m
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

------


## @CanonicalGrantee

### @CanonicalGrantee/CanonicalGrantee.m
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

------


## @Client

### @Client/Client.m
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
        s3.intialize();
 
  If using 'NOENCRYPTIION' data will NOT be encrypted at rest on S3.
 
  If using 'CSEAMK' then a Client-side Asymmetric Master Key argument of
  type java.security.KeyPair is also required e.g.
        s3 = aws.s3.Client();
        s3.encryptionScheme = 'CSEAMK';
        s3.CSEAMKKeyPair = s3.generateCSEAsymmetricMasterKey(1024);
        s3.intialize();
 
  If using 'CSESMK' then a Client-side Symmetric Master Key argument of type
  javax.crypto.spec.SecretKeySpec is also required, e.g:
        s3 = aws.s3.Client();
        s3.encryptionScheme = 'CSESMK';
        s3.CSESMKKey = s3.generateCSESymmetricMasterKey('AES', 256);
        s3.intialize();
 
  If using 'SSEC' a key of type com.amazonaws.services.s3.model.SSECustomerKey
  is required as an argument to put and get calls but is not used at client
  initialization.
 
  If using 'KMSCMK' a KMS managed Customer Master Key ID is required as an
  additional client property, e.g:
        s3 = aws.s3.Client();
        s3.KMSCMKKeyID = 'c6123457-cea5-476a-abb9-a0a4f678e8e';
        s3.intialize();
 
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
        s3.intialize();
 
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
        s3.clientConfig.setProxyHost('proxyHost','myproxy.example.com');
        s3.clientConfig.setProxyPort(8080);
        s3.initialize();
  If the proxy details are configured in the MATLAB preferences they
  will be used automatically.
 
   Alternate endpointURI:
 
  If an alternative endpoint is required, e.g. if using an non-AWS S3
  service one can specified it as follows:
        s3 = aws.s3.Client();
        s3.endpointURI = 'https//mylocals3.example.com';
        s3.initialize();



```
### @Client/createBucket.m
```notalanguage
  CREATEBUCKET Method to create a bucket on the AWS S3 service
  Create a bucket on the S3 service
 
    s3 = aws.s3.Client();
    s3.initialize();
    s3.createBucket('com-mathworks-testbucket-jblog');
 
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
### @Client/deleteBucket.m
```notalanguage
  DELETEBUCKET Method to delete an AWS S3 bucket
  Delete a bucket on the S3 service. For example:
 
    s3 = aws.s3.Client();
    s3.initialize();
    s3.deleteBucket('com-mathworks-testbucket');
 
  The deletion of the bucket destroys this bucket (and all its contents)
  irreversibly.



```
### @Client/deleteObject.m
```notalanguage
  DELETEOBJECTS Method to delete an object
  Removes the specified object from the specified S3 bucket.
  Unless versioning has been turned on for the bucket.
  There is no way to undelete an object, so use caution when deleting objects.
 
    s3.deleteObject(bucketName, key);



```
### @Client/doesBucketExist.m
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
### @Client/doesObjectExist.m
```notalanguage
  DOESOBJECTEXIST Method to check if an object exists in an S3 bucket
 
    s3 = aws.s3.Client();
    s3.initialize();
    s3.doesObjectExist('com-mathworks-testbucket-jblog', 'myobject');



```
### @Client/generateCSEAsymmetricMasterKey.m
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
### @Client/generateCSESymmetricMasterKey.m
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
### @Client/generatePresignedUrl.m
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
### @Client/generateSSECKey.m
```notalanguage
  GENERATESECRETKEY Method to generate a secret key for use with AWS S3
  The method generates a key that is suitable for use with server side
  encryption using a client side provided and managed key. Only AES 256 bit
  encryption is supported.
 
  Example:
    mykey = s3.generateSSECKey();



```
### @Client/getBucketAcl.m
```notalanguage
  GETBUCKETACL Method to get the ACL of an existing AWS S3 bucket
  Get the ACL for a bucket, the ACL can then be inspected or applied to
  another bucket. Depending on the permissions of the bucket it is possible
  that an empty ACL with no properties will be returned, e.g. if the bucket
  is owned by a 3rd party.
 
    s3.getBucketAcl(bucketName);



```
### @Client/getObject.m
```notalanguage
  GETOBJECT Method to retrieve a file object from AWS S3
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



```
### @Client/getObjectAcl.m
```notalanguage
  GETOBJECTACL Method to get the ACL of an existing AWS S3 object
  Get the ACL for the object, the ACL can then be inspected or applied to
  another object
 
    s3.getObjectAcl(bucketName, keyName);



```
### @Client/getObjectMetadata.m
```notalanguage
  GETOBJECTMETADATA Method to retrieve an AWS S3 object's metadata
  Download an object's metadata without downloading the object itself
 
  Examples:



```
### @Client/getS3AccountOwner.m
```notalanguage
  GETS3ACCOUNTOWNER returns owner of the AWS account making the request



```
### @Client/initialize.m
```notalanguage
  INITIALIZE Configure the MATLAB session to connect to S3
  Once a client has been configured, initialize is used to validate the
  client configuration and initiate the connection to S3
 
  Example:
        s3 = aws.s3.Client();
        s3.encryptionScheme = 'SSES3';
        s3.intialize();



```
### @Client/listBuckets.m
```notalanguage
  LISTBUCKETS Method to list the buckets available to the user
  The list of buckets names are returned as a table to the user.
 
    s3 = aws.s3.Client()
    s3.initialize();
    s3.listBuckets();



```
### @Client/listObjects.m
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
### @Client/load.m
```notalanguage
  LOAD, Method to load data from AWS S3 into the workspace
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
### @Client/putObject.m
```notalanguage
  PUTOBJECT uploads an object to an AWS S3 bucket
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



```
### @Client/save.m
```notalanguage
  SAVE Method to save files or variables to an AWS S3 bucket
  A higher level method that uses the built in save syntax to save data to an
  S3 bucket. Save can be used very much like the functional form of the built-in
  save command with two exceptions:
    1) The '-append' option is not supported.
    2) An entire workspace cannot be saved e.g.
    s3.save('my_work_space.mat');
  The workspace variables should be listed explicitly to overcome this or first
  save the workspace to a local file and then save the resulting file to S3.



```
### @Client/setBucketAcl.m
```notalanguage
  SETBUCKETACL Method to set an ACL on an existing object S3 Bucket
  Sets an ACL on a bucket on the S3 service.
 
    s3.setBucketAcl('com-example-testbucket',myACL);
 
  This can be used along with getBucketAcl() to get and reuse an existing
  ACL. Alternately a preconfigured "canned" ACL can be used e.g.:
 
  myCannedACL = aws.s3.CannedAccessControlList('AuthenticatedRead')
  s3.setBucketAcl('com-example-testbucket',myCannedACL)
 
  See AWS S3 JDK SDK for a complete list of canned ACLs.



```
### @Client/setObjectAcl.m
```notalanguage
  SETOBJECTACL Method to set an ACL on an existing object S3 object
  Sets an ACL on an object on the S3 service, the ACL is provided as
  an argument along with a bucket and keyname.
 
    s3.setObjectAcl('com-mathworks-testbucket','mykeyname',myacl);
 
  This can be used along with getObjectAcl() to get and reuse an existing
  ACL. Alternately a preconfigured "canned" ACL can be used e.g.:
 
  myCannedACL = aws.s3.CannedAccessControlList('AuthenticatedRead')
  s3.setObjectAcl('com-mathworks-testbucket','MyData.mat',myCannedACL)
 
  See AWS S3 JDK SDK for a complete list of canned ACLs.



```
### @Client/setSSEAwsKeyManagementParams.m
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
### @Client/shutdown.m
```notalanguage
  SHUTDOWN Method to shutdown an AWS s3 client and release resources
  This method should be called to cleanup a client which is no longer
  required.
 
  Example:  s3.shutdown()



```

------


## @EmailAddressGrantee

### @EmailAddressGrantee/EmailAddressGrantee.m
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

------


## @EncryptionScheme

### @EncryptionScheme/EncryptionScheme.m
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

------


## @Grant

### @Grant/Grant.m
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
### @Grant/getGrantee.m
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
### @Grant/getPermission.m
```notalanguage
  GETPERMISSION Gets the permission being granted to the grantee by this grant
  An aws.s3.Permission object is returned.



```

------


## @GroupGrantee

### @GroupGrantee/GroupGrantee.m
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

------


## @ObjectMetadata

### @ObjectMetadata/ObjectMetadata.m
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
### @ObjectMetadata/addUserMetadata.m
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
### @ObjectMetadata/getContentLength.m
```notalanguage
  GETCONTENTLENGTH Gets the length of the object in bytes
  Gets the Content-Length HTTP header indicating the size of the associated
  object in bytes.



```
### @ObjectMetadata/getSSEAlgorithm.m
```notalanguage
  GETSSEALGORITHM Returns algorithm when encrypting an object using managed keys



```
### @ObjectMetadata/getSSEAwsKmsKeyId.m
```notalanguage
  GETSSEAWSKMSKEYID Returns KMS key id for server side encryption of an object



```
### @ObjectMetadata/getSSECustomerAlgorithm.m
```notalanguage
  GETSSECUSTOMERALGORITHM Returns algorithm used with customer-provided keys
  Returns the server-side encryption algorithm if the object is encrypted using
  customer-provided keys.



```
### @ObjectMetadata/getSSECustomerKeyMd5.m
```notalanguage
  GETSSECUSTOMERKEYMD Returns the MD5 digest of the encryption key
  Returns the base64-encoded MD5 digest of the encryption key for server-side
  encryption, if the object is encrypted using customer-provided keys.



```
### @ObjectMetadata/getUserMetadata.m
```notalanguage
  GETUSERMETADATA Gets the custom user-metadata for the associated object
  A containers.Map of the metadata keys and values is returned. If there is
  no metadata an empty containers.Map is returned.
 
  Example:
    myDownloadedMetadata = s3.getObjectMetadata(myBucket, myObjectKey);
    myMap = myDownloadedMetadata.getUserMetaData();
    myMetadataValue = myMap(lower('myMetadataKey'));



```

------


## @Owner

### @Owner/Owner.m
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
### @Owner/setDisplayName.m
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
### @Owner/setId.m
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

------


## @Permission

### @Permission/Permission.m
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

------

## AWS S3 Interface Related Functions:
### functions/splitName.m
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
## AWS Common Objects and Methods:
* @ClientConfiguration
* @Object



------

## @ClientConfiguration

### @ClientConfiguration/ClientConfiguration.m
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

    Reference page in Doc Center
       doc aws.ClientConfiguration




```
### @ClientConfiguration/setProxyHost.m
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
        clientConfig.setProxyHost();
 
    To have the proxy host automatically set based on the given URL:
        clientConfig.setProxyHost('autoURL','https://examplebucket.amazonaws.com');
 
    To force the value of the proxy host to a given value, e.g. myproxy.example.com:
        clientConfig.setProxyHost('proxyHost','myproxy.example.com');
    Note this does not overwrite the value set in the preferences panel.
 
  The client initialization call will invoke setProxyHost() to set a value based
  on the MATLAB preference if the proxyHost value is not to an empty value.



```
### @ClientConfiguration/setProxyPassword.m
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
### @ClientConfiguration/setProxyPort.m
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
        clientConfig.setProxyPort();
 
    To have the port automatically set based on the given URL:
        clientConfig.setProxyPort('https://examplebucket.amazonaws.com');
 
    To force the value of the port to a given value, e.g. 8080:
        clientConfig.setProxyPort(8080);
    Note this does not alter the value held set in the preferences panel.
 
  The client initialization call will invoke setProxyPort() to set a value based
  on the MATLAB preference if the proxy port value is not an empty value.



```
### @ClientConfiguration/setProxyUsername.m
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

------


## @Object

### @Object/Object.m
```notalanguage
  OBJECT Root object for all the AWS SDK objects

    Reference page in Doc Center
       doc aws.Object




```

------

## AWS Common Related Functions:
### functions/Logger.m
```notalanguage
  Logger - Object definition for Logger
  ---------------------------------------------------------------------
  Abstract: A logger object to encapsulate logging and debugging
            messages for a MATLAB application.
 
  Syntax:
            logObj = Logger.getLogger();
 
  Logger Properties:
 
      LogFileLevel - The level of log messages that will be saved to the
      log file
 
      DisplayLevel - The level of log messages that will be displayed
      in the command window
 
      LogFile - The file name or path to the log file. If empty,
      nothing will be logged to file.
 
      Messages - Structure array containing log messages
 
  Logger Methods:
 
      clearMessages(obj) - Clears the log messages currently stored in
      the Logger object
 
      clearLogFile(obj) - Clears the log messages currently stored in
      the log file
 
      write(obj,Level,MessageText) - Writes a message to the log
 
  Examples:
      logObj = Logger.getLogger();
      write(logObj,'warning','My warning message')
 



```
### functions/aws.m
```notalanguage
  AWS, a wrapper to the AWS CLI utility
 
  The function assumes AWS CLI is installed and configured with authentication
  details. This wrapper allows use of the AWS CLI within the
  MATLAB environment.
 
  Examples:
     aws('s3api list-buckets')
 
  Alternatively:
     aws s3api list-buckets
 
  If no output is specified, the command will echo this to the MATLAB
  command window. If the output variable is provided it will convert the
  output to a MATLAB object.
 
    [status, output] = aws('s3api','list-buckets');
 
      output =
 
        struct with fields:
 
            Owner: [1x1 struct]
          Buckets: [15x1 struct]
 
  By default a struct is produced from the JSON format output.
  If the --output [text|table] flag is set a char vector is produced.
 



```
### functions/homedir.m
```notalanguage
  HOMEDIR Function to return the home directory
  This function will return the users home directory.



```
### functions/isEC2.m
```notalanguage
  ISEC2 returns true if running on AWS EC2 otherwise returns false



```
### functions/loadKeyPair.m
```notalanguage
  LOADKEYPAIR2CERT Reads public and private key files and returns a key pair
  The key pair returned is of type java.security.KeyPair
  Algorithms supported by the underlying java.security.KeyFactory library
  are: DiffieHellman, DSA & RSA.
  However S3 only supports RSA at this point.
  If only the public key is a available e.g. the private key belongs to
  somebody else then we can still create a keypair to encrypt data only
  they can decrypt. To do this we replace the private key file argument
  with 'null'.
 
  Example:
   myKeyPair = loadKeyPair('c:\Temp\mypublickey.key', 'c:\Temp\myprivatekey.key')
 
   encryptOnlyPair = loadKeyPair('c:\Temp\mypublickey.key')
 
 



```
### functions/saveKeyPair.m
```notalanguage
  SAVEKEYPAIR Writes a key pair to two files for the public and private keys
  The key pair should be of type java.security.KeyPair
 
  Example:
    saveKeyPair(myKeyPair, 'c:\Temp\mypublickey.key', 'c:\Temp\myprivatekey.key')
 



```
### functions/unlimitedCryptography.m
```notalanguage
  UNLIMITEDCRYPTOGRAPHY Returns true if unlimited cryptography is installed
  Otherwise false is returned.
  Tests using the AES algorithm for greater than 128 bits if true then this
  indicates that the policy files have been changed to enabled unlimited
  strength cryptography.



```
### functions/writeSTSCredentialsFile.m
```notalanguage
  WRITESTSCREDENTIALSFILE write an STS based credentials file
 
  Write an STS based credential file
 
    tokenCode is the 2 factor authentication code of choice e.g. from Google
    authenticator. Note the command must be issued quickly as this value will
    expire in a number of seconds
 
    serialNumber is the AWS 'arn value' e.g. arn:aws:iam::741<REDACTED>02:mfa/joe.blog
    this can be obtained from the AWS IAM portal interface
 
    region is the AWS region of choice e.g. us-west-1
 
  The following AWS command line interface (CLI) command will return STS
  credentials in json format as follows, Note the required multi-factor (mfa)
  auth version of the arn:
 
  aws sts get-session-token --token-code 631446 --serial-number arn:aws:iam::741<REDACTED>02:mfa/joe.blog
 
  {
      "Credentials": {
          "SecretAccessKey": "J9Y<REDACTED>BaJXEv",
          "SessionToken": "FQoDYX<REDACTED>KL7kw88F",
          "Expiration": "2017-10-26T08:21:18Z",
          "AccessKeyId": "AS<REDACTED>UYA"
      }
  }
 
  This needs to be rewritten differently to match the expected format
  below:
 
  {
      "aws_access_key_id": "AS<REDACTED>UYA",
      "secret_access_key" : "J9Y<REDACTED>BaJXEv",
      "region" : "us-west-1",
      "session_token" : "FQoDYX<REDACTED>KL7kw88F"
  }



```



------------    

[//]: # (Copyright 2019 The MathWorks, Inc.)
