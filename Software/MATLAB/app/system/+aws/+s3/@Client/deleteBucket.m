function deleteBucket(obj, bucketName)
% DELETEBUCKET Method to delete an Amazon S3 bucket
% Delete a bucket on the S3 service. For example:
%
%   s3 = aws.s3.Client();
%   s3.initialize();
%   s3.deleteBucket('com-mathworks-testbucket');
%
% The deletion of the bucket destroys this bucket (and all its contents)
% irreversibly.
%

% Copyright 2017-2021 The MathWorks, Inc.

logObj = Logger.getLogger();
write(logObj,'verbose',['Deleting bucket ',bucketName]);

%% Call the API to delete a bucket
obj.Handle.deleteBucket(bucketName);

end %function
