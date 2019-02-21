function SSECustomerKeyMd5 = getSSECustomerKeyMd5(obj)
% GETSSECUSTOMERKEYMD Returns the MD5 digest of the encryption key
% Returns the base64-encoded MD5 digest of the encryption key for server-side
% encryption, if the object is encrypted using customer-provided keys.

% Copyright 2018 The MathWorks, Inc.

SSECustomerKeyMd5 = char(obj.Handle.getSSECustomerKeyMd5());

end
