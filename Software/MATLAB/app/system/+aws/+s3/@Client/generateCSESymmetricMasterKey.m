function key = generateCSESymmetricMasterKey(~, varargin)
% GENERATECSESYMMETRICMASTERKEY Method to generate a client-side S3 key
% The returned key can be used for client side encryption using a symmetric
% key that is 256 bits in length. 128 and 196 bit keys can also be used.
% The AES algorithm is used. With keys of this length this method should
% NOT be considered secure.
%
% Example:
%   myKey = s3.generateCSESymmetricKey('AES',256);
%   By default a 256 bit AES keys will be generated
%   myKey = s3.generateCSESymmetricKey();
%

% Copyright 2017 The MathWorks, Inc.

%% Imports
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.SecretKeySpec

logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'generateCSESymmetricMasterKey';

defaultAlgorithm = 'AES';
validAlgorithms = {'AES'}; % conceivable that other algorithms may be supported later
checkAlgorithm = @(x) any(validatestring(x,validAlgorithms));

defaultBitLength = 256;
validBitLengths = [128, 192, 256];
checkBitLength = @(x) ismember(x,validBitLengths);

addOptional(p,'algorithm',defaultAlgorithm,checkAlgorithm);
addOptional(p,'bitLength',defaultBitLength,checkBitLength);

parse(p,varargin{:})

algorithm = p.Results.algorithm;
bitLength = p.Results.bitLength;

% Generate symmetric key, defaults: 256 bit AES
write(logObj,'verbose',['Generating symmetric key: ', algorithm, ' ', num2str(bitLength), ' bit']);
generator = KeyGenerator.getInstance(string(algorithm));
generator.init(bitLength);
key = generator.generateKey();

end %function
