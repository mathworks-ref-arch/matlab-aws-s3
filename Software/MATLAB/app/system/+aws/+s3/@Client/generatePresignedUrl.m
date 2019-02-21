function psURL = generatePresignedUrl(obj, bucketName, objectKey, urlType)
% GENERATEPRESIGNEDPUT generates a pre-signed HTTP PUT URL
% Returns a pre-signed URL (as a char vector) for upload using a HTTP Put
% request. The URL that is valid for one hour for the named object and bucket.
% Other URL http request types are not supported at this point.
% If a URL request type other than put is provided an empty char vector is
% returned.
%
% Example;
%    s3 = aws.s3.Client();
%    s3.initialize();
%    ingestUrl = s3.generatePresignedUrl('myuploadbucket','myobject.mp4','put');
%

% Copyright 2017 The MathWorks, Inc.

import java.io.IOException
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL

import com.amazonaws.AmazonClientException
import com.amazonaws.AmazonServiceException
import com.amazonaws.HttpMethod
import com.amazonaws.auth.profile.ProfileCredentialsProvider
import com.amazonaws.services.s3.AmazonS3
import com.amazonaws.services.s3.AmazonS3Client
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest

logObj = Logger.getLogger();

if contains(bucketName,'.')
    write(logObj,'warning',['Bucket name contains \".\"(s), this means the the URL returned by AWS is likely to fail browser based wildcard certificate matching: ',bucketName]);
end

if strcmpi(urlType, 'put')
    % get the current time in miliseconds and add one hour to this
    expiration = java.util.Date();
    msec = expiration.getTime();
    msec = msec + (1000 * 60 * 60);
    expiration.setTime(msec);

    % we want a URL for the object that works with HTTP PUT so set that method
    generatePresignedUrlRequest = GeneratePresignedUrlRequest(bucketName, objectKey);
    generatePresignedUrlRequest.setMethod(HttpMethod.PUT);
    generatePresignedUrlRequest.setExpiration(expiration);

    psURLObj = obj.Handle.generatePresignedUrl(generatePresignedUrlRequest);
    % return the URL as char vector
    psURL = char(psURLObj.toString);
else
    write(logObj,'error',['Unsupported URL request type: ',urlType]);
    psURL = '';
end

end % function
