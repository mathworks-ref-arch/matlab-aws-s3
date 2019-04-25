# Authentication

To access the AWS™ service it is necessary to authenticate with AWS. This can be accomplished in two ways:
1. Using the default AWS Credential Provider Chain, to iterate through the default AWS authentication methods. This is the default authentication mechanism.
2. Using a custom stored credentials file to define the credentials to be used by a client. To use this mechanism configure the client as follows: *<clientName>.useCredentialsProviderChain = false;*. This disables provider chain.

Particularly if using other AWS tools or services the first methods can be more convenient as one can have a common authentication process.

## Credential Provider Chain
When a client is initialized, by default, it attempts to find AWS credentials by using the default credential provider chain as implemented by the AWS SDK. This looks for credentials in this order:

1. Environment variables: *AWS_ACCESS_KEY_ID*, *AWS_REGION* and *AWS_SECRET_ACCESS_KEY*.
2. Java system properties: *aws.accessKeyId* and *aws.secretKey*.
3. The default credential profiles file, typically store in *~/.aws/credentials* (Linux) or *c:\\Users\\username\\.aws\\* (Windows) and shared by many of the AWS SDKs and by the AWS CLI. A credentials file can be created by using the aws configure command provided by the AWS CLI, or by editing the file with a text editor. For information about the credentials file format, see AWS Credentials File Format: <https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html#credentials-file-format>.
4. Amazon™ ECS™ container credentials are loaded from the Amazon ECS if the environment variable *AWS_CONTAINER_CREDENTIALS_RELATIVE_URI* is set.
5. Instance profile credentials as used on EC2™ instances, and delivered through the Amazon EC2 metadata service.

For more information on the credential provider chain see: <https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/credentials.html>

### Using Environment variables
The environment variables *AWS_ACCESS_KEY_ID*, *AWS_REGION* and *AWS_SECRET_ACCESS_KEY* must be set in the process context used to start MATLAB®, that is the must be set before MATLAB is started and cannot be set using the MATLAB *setenv* command as they must be set in the context of the MATLAB JVM. One can verify if they have been set correctly using the following command rather than the MATLAB *getenv* command:
```
java.lang.System.getenv('AWS_REGION')

ans =

us-west-1
```
If they have not been set, a Java exception is raised from the provider chain.

### Using IAM Role based access
When running on EC2 an EC2 instance may *not* have an IAM Role associated with it to allow access to a given S3 resource. If the EC2 instance IAM Role is not there or is improperly configured, an error is raised stating that the requested metadata is not found.

As an example of this IAM role error message:
```
bList = s3.listBuckets();

Listing buckets
Error using aws.s3.Client/listBuckets (line 15)
Java exception occurred:
com.amazonaws.SdkClientException: The requested metadata is
not found at
http://169.254.169.254/latest/meta-data/iam/security-credentials/
at com.amazonaws.internal.EC2CredentialsUtils.readResource(EC2CredentialsUtils.java:115)
at com.amazonaws.internal.EC2CredentialsUtils.readResource(EC2CredentialsUtils.java:77)
at com.amazonaws.auth.InstanceProfileCredentialsProvider$InstanceMetadataCredentialsEndpointProvider.getCredentialsEndpoint(InstanceProfileCredentialsProvider.java:156)
at com.amazonaws.auth.EC2CredentialsFetcher.fetchCredentials(EC2CredentialsFetcher.java:121)
at com.amazonaws.auth.EC2CredentialsFetcher.getCredentials(EC2CredentialsFetcher.java:82)
at com.amazonaws.auth.InstanceProfileCredentialsProvider.getCredentials(InstanceProfileCredentialsProvider.java:141)
at com.amazonaws.http.AmazonHttpClient$RequestExecutor.getCredentialsFromContext(AmazonHttpClient.java:1119)
at com.amazonaws.http.AmazonHttpClient$RequestExecutor.runBeforeRequestHandlers(AmazonHttpClient.java:759)
at com.amazonaws.http.AmazonHttpClient$RequestExecutor.doExecute(AmazonHttpClient.java:723)
at com.amazonaws.http.AmazonHttpClient$RequestExecutor.executeWithTimer(AmazonHttpClient.java:716)
at com.amazonaws.http.AmazonHttpClient$RequestExecutor.execute(AmazonHttpClient.java:699)
at com.amazonaws.http.AmazonHttpClient$RequestExecutor.access$500(AmazonHttpClient.java:667)
at com.amazonaws.http.AmazonHttpClient$RequestExecutionBuilderImpl.execute(AmazonHttpClient.java:649)
at com.amazonaws.http.AmazonHttpClient.execute(AmazonHttpClient.java:513)
at com.amazonaws.services.s3.AmazonS3Client.invoke(AmazonS3Client.java:4221)
at com.amazonaws.services.s3.AmazonS3Client.invoke(AmazonS3Client.java:4168)
at com.amazonaws.services.s3.AmazonS3Client.invoke(AmazonS3Client.java:4162)
at com.amazonaws.services.s3.AmazonS3Client.listBuckets(AmazonS3Client.java:914)
at com.amazonaws.services.s3.AmazonS3Client.listBuckets(AmazonS3Client.java:920)
```

To attach IAM Role to existing EC2 instance, please see: <https://aws.amazon.com/blogs/security/easily-replace-or-attach-an-iam-role-to-an-existing-ec2-instance-by-using-the-ec2-console/>

## Using a custom stored credentials file
Use an existing AWS access key or create one in the IAM console for the user:   

Download the key (**accessKey.csv**) and secure it (i.e. store it in a secure folder that is not going to be accidentally packaged with the MATLAB code for example).   

Create a client configuration using this information. This takes the form a file named *credentials.json* that
exists on the MATLAB path. The contents of this file need to be of the format:

```json
{
    "aws_access_key_id": "AK<REDACTED>GQ",
    "secret_access_key" : "dE<REDACTED>YEy",
    "region" : "us-west-1"
}
```
Once configured, this package is ready to connect to AWS S3. The order of the credential file entries is not significant.


## Using temporary security credentials

Both of the above approaches can use temporary security credentials. The AWS Security Token Service (AWS STS) can be used to create temporary security credentials to access to AWS resources. Temporary security credentials work almost identically to the long-term access key credentials:

1. Temporary security credentials are short-term and can be configured to last from a few minutes to several hours. After the credentials expire, AWS no longer recognizes access from API requests made with them.
2. Temporary security credentials are not held in advance by the user but are generated dynamically and provided to the user when required. The package assumes that a process is in place to generate and distribute these credentials securely within an organization.

To use temporary credentials a credentials.json file very similar to that used for long term credentials is used. It has an additional entry for a *session_token* as follows:
```json
{
    "aws_access_key_id": "AS<REDACTED>YA",
    "secret_access_key" : "J9<REDACTED>Ev",
    "region" : "us-west-1",
    "session_token" : "FQ<REDACTED>8F"
}
```

The AWS CLI is one method that can be used to generate these credentials. For example the following command uses multi factor authentication via Google's Authenticator™ App to generate the *token-code*, the corresponding *serial-number* is available from the AWS IAM console. The command then returns values required for the above credentials.json file. Note the *:mfa* form of the arn.
```
$ aws sts get-session-token --token-code 631446 --serial-number arn:aws:iam::7<REDACTED>2:mfa/joe.blog
{
    "Credentials": {
        "SecretAccessKey": "J9<REDACTED>Ev",
        "SessionToken": "FQ<REDACTED>8F",
        "Expiration": "2017-10-26T08:21:18Z",
        "AccessKeyId": "AS<REDACTED>UYA"
    }
}
```
For more information see: <https://docs.aws.amazon.com/cli/latest/reference/sts/get-session-token.html> By explicitly naming credentials files when initializing a client one can readily work with both long term and short term credentials or multiple accounts at the same time. By default session tokens are valid for 12 hours. Attempting to use expired tokens will result in a error similar to the following:

Expired key error message:
```
s3.createBucket('com-example-expiredsessiontest-bucket');

Creating bucket com-example-expiredsessiontest-bucket
Error using aws.s3.Client/createBucket (line 33)

Java exception occurred:
com.amazonaws.services.s3.model.AmazonS3Exception: The provided token has expired. (Service: Amazon S3;
Status Code: 400; Error Code: ExpiredToken; Request ID: C80DCAEFA359EBE6), S3 Extended Request ID:
nfFA8IGkfqk5LjWjOXkvxKVGxR9HTdcEEJKENeRKG97gmNuYestOlCY9JlH8Z2QbOudnhWEM0d0=
at com.amazonaws.http.AmazonHttpClient$RequestExecutor.handleErrorResponse(AmazonHttpClient.java:1588)
at com.amazonaws.http.AmazonHttpClient$RequestExecutor.executeOneRequest(AmazonHttpClient.java:1258)
at com.amazonaws.http.AmazonHttpClient$RequestExecutor.executeHelper(AmazonHttpClient.java:1030)
at com.amazonaws.http.AmazonHttpClient$RequestExecutor.doExecute(AmazonHttpClient.java:742)
at com.amazonaws.http.AmazonHttpClient$RequestExecutor.executeWithTimer(AmazonHttpClient.java:716)
at com.amazonaws.http.AmazonHttpClient$RequestExecutor.execute(AmazonHttpClient.java:699)
at com.amazonaws.http.AmazonHttpClient$RequestExecutor.access$500(AmazonHttpClient.java:667)
at com.amazonaws.http.AmazonHttpClient$RequestExecutionBuilderImpl.execute(AmazonHttpClient.java:649)
at com.amazonaws.http.AmazonHttpClient.execute(AmazonHttpClient.java:513)
at com.amazonaws.services.s3.AmazonS3Client.invoke(AmazonS3Client.java:4169)
at com.amazonaws.services.s3.AmazonS3Client.invoke(AmazonS3Client.java:4116)
at com.amazonaws.services.s3.AmazonS3Client.createBucket(AmazonS3Client.java:1001)
at com.amazonaws.services.s3.AmazonS3Client.createBucket(AmazonS3Client.java:939)
```


[//]: #  (Copyright 2018 The MathWorks, Inc.)
