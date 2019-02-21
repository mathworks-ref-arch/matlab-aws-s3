function SSECustomerAlgorithm = getSSECustomerAlgorithm(obj)
% GETSSECUSTOMERALGORITHM Returns algorithm used with customer-provided keys
% Returns the server-side encryption algorithm if the object is encrypted using
% customer-provided keys.

% Copyright 2018 The MathWorks, Inc.

SSECustomerAlgorithm = char(obj.Handle.getSSECustomerAlgorithm());

end
