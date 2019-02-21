function ContentLength = getContentLength(obj)
% GETCONTENTLENGTH Gets the length of the object in bytes
% Gets the Content-Length HTTP header indicating the size of the associated
% object in bytes.

% Copyright 2018 The MathWorks, Inc.

ContentLength = obj.Handle.getContentLength();

end
