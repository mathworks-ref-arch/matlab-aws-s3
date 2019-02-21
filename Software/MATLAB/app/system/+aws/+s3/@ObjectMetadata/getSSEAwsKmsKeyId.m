function SSEAwsKmsKeyId = getSSEAwsKmsKeyId(obj)
% GETSSEAWSKMSKEYID Returns KMS key id for server side encryption of an object

% Copyright 2018 The MathWorks, Inc.

SSEAwsKmsKeyId = char(obj.Handle.getSSEAwsKmsKeyId());

end
