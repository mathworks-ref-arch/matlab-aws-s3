function SSEAlgorithm = getSSEAlgorithm(obj)
% GETSSEALGORITHM Returns algorithm when encrypting an object using managed keys

% Copyright 2018 The MathWorks, Inc.

SSEAlgorithm = char(obj.Handle.getSSEAlgorithm());

end
