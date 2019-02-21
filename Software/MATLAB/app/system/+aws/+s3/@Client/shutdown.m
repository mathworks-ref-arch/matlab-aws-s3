function shutdown(obj)
% SHUTDOWN Method to shutdown an AWS s3 client and release resources
% This method should be called to cleanup a client which is no longer
% required.
%
% Example:  s3.shutdown()
%

% Copyright 2017 The MathWorks, Inc.

%% Imports
import com.amazonaws.services.s3.AmazonS3Client;

logObj = Logger.getLogger();
write(logObj,'verbose','Shutting down S3 client');
obj.Handle.shutdown();

end %function
