# Using Access Controls

This section is a guide to using AWS™ S3™ Access Control Lists (ACLs) with this package.

## Contents

* [Getting started](#getting-started)
* [Reading the ACL of a bucket](#reading-the-acl-of-a-bucket)
* [Reading the ACL of an object](#reading-the-acl-of-an-object)
* [Setting an ACL on a bucket](#setting-an-acl-on-a-bucket)
* [Setting an ACL on an object](#setting-an-acl-on-an-object)
* [Using a canned ACL with a bucket](#using-a-canned-acl-with-a-bucket)

## CAUTION

Incorrectly setting permissions on S3 object or buckets presents a significant security risk. Before using ACLs please study Amazon's detailed security guidance and consult with the relevant IT team in your organization.

## Getting started

For more information see:

* [https://docs.aws.amazon.com/AmazonS3/latest/userguide/managing-acls.html](https://docs.aws.amazon.com/AmazonS3/latest/userguide/managing-acls.html)
* [https://docs.aws.amazon.com/AmazonS3/latest/userguide/create-bucket-overview.html](https://docs.aws.amazon.com/AmazonS3/latest/userguide/create-bucket-overview.html)
* [https://repost.aws/knowledge-center/s3-bucket-owner-full-control-acl](https://repost.aws/knowledge-center/s3-bucket-owner-full-control-acl)

S3 uses Policies and Access Control Lists or ACLs to control access to buckets and objects. This package supports ACL based controls.

If a bucket uses the bucket owner enforced setting for S3 Object Ownership, policies must be used to grant access to your bucket and the objects in it. With the bucket owner enforced setting enabled, requests to set access control lists (ACLs) or update ACLs fail and return the AccessControlListNotSupported error code. Requests to read ACLs are still supported.

The following code shows how a bucket can be created with the ownwership set to `BucketOwnerPreferred` to enable the use of ACLs.

```matlab
cbr = aws.s3.model.CreateBucketRequest('mybucketName');
cbr.setObjectOwnership('BucketOwnerPreferred');
s3.createBucket(cbr);
```

ACLs control which AWS accounts and groups are granted access and the level of that access. When a bucket or object is created a default ACL is created that grants the owner full access. Further to the owner's access additional levels of access can be granted to up to 100 grantees. A grantee may be either an individual or a predefined S3 group as defined by Amazon™. Grantees are specified by either email address, canonical user ID or as a Group. In the case of email address this is translated to canonical ID by Amazon, thus the resulting ACL will specify the canonical ID.

The S3 API defines a number of objects to represent the various aspects of ACLs and these are reflected in the package's MATLAB® objects. They are as follows:

| Objects | Meaning |
|-------------------|--------------------------------------------------------|
| AccessControlList | represents the ACL itself |
| Owner | represents the owner of an object or bucket |
| GroupGrantee | represents predefined AWS groups currently: AllUsers, AuthenticatedUsers,   LogDelivery |
| EmaillAddressGrantee | a grantee specified by email address |
| CanonicalGrantee | a grantee specified directly by canonical ID |
| Permission | an object to define permission level: i.e. READ, WRITE, READACP, WRITEACP or FULLCONTROL |

The following sets the *myPermission* object to *READ* and uses it to create an ACL. A grantee is also required, in this case based on an email address.

```matlab
s3 = aws.s3.Client();
s3.initialize();
myPermission = aws.s3.Permission('READ');
myEmailAddressGrantee = aws.s3.EmailAddressGrantee('john.smith@example.com');
myACL = aws.s3.AccessControlList();
myACL.grantPermission(myEmailAddressGrantee, myPermission);
```

When granted on a bucket ACL permissions correspond to the following 'canned' S3 Access Policy permissions apply as per S3 documentation:

| Permission | Effect |
|-------------|--------------------------------------------------------------|
| READ | Allows grantee to list the objects in the bucket. |
| WRITE | Allows grantee to create, overwrite, and delete any object in the bucket. |
| READ_ACP | Allows grantee to read the bucket ACL. |
| WRITE_ACP | Allows grantee to write the ACL for the applicable bucket. |
| FULL_CONTROL | Allows grantee the READ, WRITE, READ_ACP, and WRITE_ACP permissions on the bucket. It is equivalent to granting READ, WRITE, READ_ACP, and WRITE_ACP ACL permissions. |

When granted on an object ACL permissions correspond to the following S3 Access Policy permissions apply as per S3 documentation:

| Permission | Effect |
|-------------|--------------------------------------------------------------|
| READ | Allows grantee to read the object data and its metadata. |
| WRITE | Not applicable. |
| READ_ACP | Allows grantee to read the object ACL. |
| WRITE_ACP | Allows grantee to write the ACL for the applicable object. |
| FULL_CONTROL | Is equivalent to granting READ, READ_ACP, and WRITE_ACP ACL permissions. Allows grantee the READ, READ_ACP, and WRITE_ACP permissions on the object. |

For full details see the following Amazon guide: <http://docs.aws.amazon.com/AmazonS3/latest/dev/acl-overview.html>

To quote from this guide:

> Amazon S3 Access Control Lists (ACLs) enables management of access to buckets and objects. Each bucket and object has an ACL attached to it as a subresource. It defines which AWS accounts or groups are granted access and the type of access. When a request is received against a resource, Amazon S3 checks the corresponding ACL to verify the requester has the necessary access permissions. When a bucket or an object is created, Amazon S3 creates a default ACL that grants the resource owner full control over the resource.

## Reading the ACL of a bucket

The following example uploads an object and then examines its ACL, thus showing the default ACL that was applied:

```matlab
% initialize an S3 client
s3 = aws.s3.Client();
s3.initialize();

% create a bucket, assuming it does not already exist
myBucket = 'com-myorg-myacltestbucket';
s3.createBucket(myBucket);

% get the bucket's ACL and extract the grants from that
myACL = s3.getBucketAcl(myBucket);
myGrants = myACL.getGrantsAsList();
% use contents of myGrants as required

% cleanup
s3.deleteBucket(myBucket);
s3.shutdown;
```

From the above example returns a cell array of Grant objects. Each of these contains a Grantee and a Permission which can be returned by the relevant methods.

## Reading the ACL of an object

This example reads the ACL of an object, similar to the reading the bucket ACL in the previous example.

```matlab
% initialize an S3 client
s3 = aws.s3.Client();
s3.initialize();
x = rand(3);
tmpName = [tempname,'.mat'];
save(tmpName,'x');

% create a bucket, assuming it does not already exist
myBucket = 'com-myorg-myacltestbucket';
s3.createBucket(myBucket);
s3.putObject(myBucket,tmpName);

% get the ACL from the newly created object
myACL = s3.getObjectAcl(myBucket,tmpName);

% get the list of grants for the newly created object
myGrants = myACL.getGrantsAsList();

% cleanup
s3.deleteObject(myBucket,tmpName);
s3.deleteBucket(myBucket);
s3.shutdown;
```

Again one should see results that look very similar to the previous example, here the one and only entry in myGrants will be a grant containing a CanonicalGrantee and a Permission object set to FULL_CONTROL.

## Setting an ACL on a bucket

In this example, the ACL of a bucket is read, as created by default. Then a new ACL for the bucket is built and and applied. In this case, a canonical ID is used i.e. a long string of the form: 'aba982807a64f60b21f3786971d81106eb4c07cff0331199e04a867e253f7575' (this is not a valid ID) this can be obtained interactively from the AWS portal or programmatically by calling the *getS3AccountOwner()* method of the S3 client. This returns an Owner object whose *Identifier* property will be the canonical ID. In this case, the ID from an existing ACL Grantee's Identifier is retrieved.

```matlab
s3 = aws.s3.Client();
s3.useCredentialsProviderChain = false;
s3.initialize();
x = rand(100,100);
save MyData x;

% create bucket
myBucket = 'com-myorg-myacltestbucket';
s3.createBucket(myBucket);

% read the default ACL
myACL1 = s3.getBucketAcl(myBucket);
myGrants1 = myACL1.getGrantsAsList();
% get the canonical ID from the Grantee object
myGrantee1 = myGrants1{1}.getGrantee();
myIdentifier = myGrantee1.Identifier;
% examine the initial permission
initialPermission = myGrants1{1}.getPermission();
initialPermission.stringValue

% build up a new ACL
% first, set up the grantee using the canonical ID previously obtained
canonicalObj = aws.s3.CanonicalGrantee(myIdentifier);
% alternatively one could use an email ID
% emailAddrObj = aws.s3.EmailAddressGrantee('john.smith@example.com');
% or a predefined group ID e.g. AllUsers
% CAUTION granting permissions to Allusers will apply the permission to the public
% i.e. this bucket will be come readable to the wider Internet
% groupGranteeObj = aws.s3.GroupGrantee('AllUsers');

% second, set the permission
permissionEnum = aws.s3.Permission('read');

% third, configure an owner
% in this case use the over of the S3 client
myOwner = s3.getS3AccountOwner();
% however one could construct an Owner based on a display name and identifier:
% myOwner = aws.s3.Owner();
% set the display name and ID, in this case, using the same ID
% myOwner.setDisplayName('my_owner_display_name');
% myOwner.setId(myIdentifier);

% create an ACL and set the Grantee, Owner and Permission
myACL2 = aws.s3.AccessControlList();
myACL2.grantPermission(canonicalObj, permissionEnum);
% set the ACL owner
myACL2.setOwner(myOwner);

% now apply the ACL to the Bucket
s3.setBucketAcl(myBucket, myACL2);

% examine the ACL that was just created and applied
myACL3 = s3.getBucketAcl(myBucket);
myGrants2 = myACL3.getGrantsAsList();
returnedPermission = myGrants2{1}.getPermission();
returnedPermission.stringValue

% cleanup
s3.deleteBucket(myBucket);
s3.shutdown();
```

In the output, it can be seen that the *returnedPermission.stringValue* has been changed to *READ* from the *initialPermission.stringValue* value of *FULL_CONTROL*. Note, even though permission was changed to *READ* it can still be deleted. As the owner can always delete an object or bucket.

## Setting an ACL on an object

An important aspect of S3 is the ability to control access to data stored on S3. This is accomplished using Access Control Lists or ACLs. The following example illustrates some aspects of working with ACLs using this package.

```matlab
s3 = aws.s3.Client();
s3.useCredentialsProviderChain = false;
s3.initialize();
x = rand(100,100);
save MyData x;

% create bucket, in this case, check if it exists first, then upload an object
myBucket = 'com-myorg-mytestbucket';
if ~s3.doesBucketExist(myBucket)
    s3.createBucket(myBucket);
end
s3.putObject(myBucket,'MyData.mat')

% Get the ACL of the object that just uploaded
myACL1 = s3.getObjectAcl(myBucket,'MyData.mat');
myGrants1 = myACL1.getGrantsAsList();
% Look at element 1 of the cell array to see the details of the ACL grant
myGrants1{1}.getGrantee
myGrants1{1}.getPermission

% build up a grant to add
% first, set up the grantee using a predefined group ID e.g. AllUsers
% CAUTION granting permissions to Allusers will apply the permission to the public
% i.e. this object will be come readable to the wider Internet
groupGranteeObj = aws.s3.GroupGrantee('AllUsers');

% second, set the permission
permissionEnum = aws.s3.Permission('read');

% third, configure an owner in this case that of the S3 client
myOwner = s3.getS3AccountOwner();

% create an ACL object and apply the grantee, owner and permission to it
myACL2 = aws.s3.AccessControlList();
myACL2.grantPermission(groupGranteeObj, permissionEnum);
% set the ACL owner
myACL2.setOwner(myOwner);

% now apply the ACL to the object
s3.setObjectAcl(myBucket,'MyData.mat',myACL2);

% examine the ACL that was just created
% note the predefined group ID *AllUsers* in the output and the *READ* permissions
myGrants2 = myACL2.getGrantsAsList();
myGrants2{1}.getGrantee
myGrants2{1}.getPermission

% cleanup
delete('MyData.mat');
s3.deleteObject(myBucket,'MyData.mat');
s3.deleteBucket(myBucket);
s3.shutdown();
```

## Using a canned ACL with a bucket

This example shows how to apply a *Canned Access Control List* to a bucket.

The following canned ACLs are provided:

| ACL | Meaning |
|------------------|---------------------------------------------------------|
| AuthenticatedRead | Specifies the owner is granted Permission.FullControl and the GroupGrantee.AuthenticatedUsers group grantee is granted Permission.Read access. |
| AwsExecRead | Specifies the owner is granted Permission.FullControl. |
| BucketOwnerFullControl | Specifies the owner of the bucket, but not necessarily the same as the owner of the object, is granted Permission.FullControl. |
| BucketOwnerRead | Specifies the owner of the bucket, but not necessarily the same as the owner of the object, is granted Permission.Read. |
| LogDeliveryWrite | Specifies the owner is granted Permission.FullControl and the GroupGrantee.LogDelivery group grantee is granted Permission.Write access so that access logs can be delivered. |
| Private | Specifies the owner is granted Permission.FullControl. |
| PublicRead | Specifies the owner is granted Permission.FullControl and the GroupGrantee.AllUsers group grantee is granted Permission.Read access. |
| PublicReadWrite | Specifies the owner is granted Permission.FullControl and the GroupGrantee.AllUsers group grantee is granted Permission.Read and Permission.Write access. |

Similarly canned ACLs can be used with objects.

```
s3 = aws.s3.Client();
s3.useCredentialsProviderChain = false;
s3.initialize();

% create bucket assuming that it does not already exist
myBucket = 'com-myorg-mytestbucket';
s3.createBucket(myBucket);

% create a canned ACL object in this case AuthenticatedRead and apply it
% CAUTION granting permissions to AuthenticatedUsers will apply the permission
% anyone with an AWS account and so is effectively public
% i.e. this bucket will be come readable to the wider Internet
myCannedACL1 = aws.s3.CannedAccessControlList('AuthenticatedRead');
s3.setBucketAcl(myBucket,myCannedACL1);

myCannedACL2 = s3.getBucketAcl(myBucket);
% returns a 2 element cell array
myGrants = myCannedACL2.getGrantsAsList();

% examine resulting grants
myGrants{1}.getGrantee
myGrants{1}.getPermission
myGrants{2}.getGrantee
myGrants{2}.getPermission

% cleanup
s3.deleteBucket(myBucket);
s3.shutdown();
```

In the output it can be seen that the ```myGrants``` cell array has two Grantees, one canonical and a second a group, ```AUTHENTICATEDUSERS``` with ```READ``` access.

```matlab
myGrants{1}.getGrantee
Creating CanonicalGrantee
ans =
  CanonicalGrantee with properties:

    Identifier: 'aba982<REDACTED>253f7575'
myGrants{1}.getPermission
Creating permission: FULL_CONTROL
ans =
  Permission with properties:

    stringValue: 'FULL_CONTROL'
myGrants{2}.getGrantee
Setting GroupGrantee AUTHENTICATEDUSERS
ans =
  GroupGrantee with properties:

    Identifier: 'http://acs.amazonaws.com/groups/global/AuthenticatedUsers'
myGrants{2}.getPermission
Creating permission: READ
ans =
  Permission with properties:

    stringValue: 'READ'
```

[//]: #  (Copyright 2018-2023 The MathWorks, Inc.)
