function result = doesBucketExist(obj, bucketName)
% DOESBUCKETEXIST Method to check if a bucket exists on S3
%
%   s3 = aws.s3.Client();
%   s3.initialize();
%   s3.doesBucketExist('com-mathworks-testbucket-jblog');
%
% Amazon S3 bucket names are globally unique, so once a bucket name has
% been taken by any user, another bucket with that same name cannot be created
% for a while.
%
% For a listing of buckets see listBuckets()
%
% Amazon recommends that all bucket names comply with DNS naming conventions.
%
% Please see:
% http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html

% Copyright 2017 The MathWorks, Inc.

logObj = Logger.getLogger();
write(logObj,'verbose',['Checking for existence of bucket ',bucketName]);

% Call the API to create a bucket
result = obj.Handle.doesBucketExist(bucketName);

end %function
