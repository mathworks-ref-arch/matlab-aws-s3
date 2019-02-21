function key = generateSSECKey(~, varargin)
% GENERATESECRETKEY Method to generate a secret key for use with AWS S3
% The method generates a key that is suitable for use with server side
% encryption using a client side provided and managed key. Only AES 256 bit
% encryption is supported.
%
% Example:
%   mykey = s3.generateSSECKey();
%

% Copyright 2017 The MathWorks, Inc.

%% Imports
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import java.security.SecureRandom
import com.amazonaws.services.s3.model.SSECustomerKey

logObj = Logger.getLogger();
write(logObj,'verbose','Generating SSECustomerKey: AES 256 bit');

generator = KeyGenerator.getInstance('AES');
sr = SecureRandom();
generator.init(256, sr);

% return a key of type javax.crypto.spec.SecretKeySpec
secretkey = generator.generateKey;

% return a key of type SSECustomerKey
key = SSECustomerKey(secretkey);

end %function
