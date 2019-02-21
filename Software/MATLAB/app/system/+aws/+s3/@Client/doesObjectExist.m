function result = doesObjectExist(obj, bucketName, objectName)
% DOESOBJECTEXIST Method to check if an object exists in an S3 bucket
%
%   s3 = aws.s3.Client();
%   s3.initialize();
%   s3.doesObjectExist('com-mathworks-testbucket-jblog', 'myobject');
%
%

% Copyright 2017 The MathWorks, Inc.

logObj = Logger.getLogger();
write(logObj,'debug',['Checking for existence of an object: ',objectName,' in bucket:' , bucketName]);

% Call the API to create a bucket
result = obj.Handle.doesObjectExist(bucketName,objectName);

end %function
