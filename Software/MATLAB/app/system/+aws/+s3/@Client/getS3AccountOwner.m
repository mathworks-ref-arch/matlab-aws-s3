function owner = getS3AccountOwner(obj)
% GETS3ACCOUNTOWNER returns owner of the AWS account making the request

% Copyright 2019 The MathWorks, Inc.

ownerJ = obj.Handle.getS3AccountOwner();
id = ownerJ.getId();
displayName = ownerJ.getDisplayName();

owner = aws.s3.Owner();
owner.setId(char(id));
owner.setDisplayName(char(displayName));

end
