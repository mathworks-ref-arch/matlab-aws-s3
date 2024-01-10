classdef PersistableTransfer < aws.Object
    % PersistableTransfer base class for the information of a pauseable upload or download
    % Such information can be used to resume the upload or download later on,
    % and can be serialized/deserialized for persistence purposes.

    % Copyright 2023 The MathWorks, Inc.

    methods
        function obj = PersistableTransfer(varargin)
        end


        function serial = serialize(obj)
            % SERIALIZE Returns the serialized representation of the paused transfer state
            serial = char(obj.Handle.serialize());
        end
    end
end
