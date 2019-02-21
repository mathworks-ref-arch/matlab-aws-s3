classdef EncryptionScheme < aws.Object
    %ENCRYPTIONSCHEME defines the various supported S3 encryption schemes
    %
    %   NOENCRYPTION  : do not use encryption
    %   CSESMK    : client side with a symmetric master key
    %   CSEAMK    : client side with a asymmetric master key
    %   KMSCMK    : Key Management Service managed customer master key
    %   SSEC      : sever side encryption with a customer supplied key
    %   SSEKMS    : server side encryption using the Key Management Service
    %   SSES3     : server side encryption using S3 managed encryption keys

    % Copyright 2017 The MathWorks, Inc.

    enumeration
        NOENCRYPTION
        CSESMK
        CSEAMK
        KMSCMK
        SSEC
        SSEKMS
        SSES3
    end

end %class
