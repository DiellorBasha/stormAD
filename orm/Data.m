classdef Data < StormBase
    properties
        data_id
        session_id
        type
    end
    
    methods
        function obj = Data(graphconn, data_id, session_id, type)
            obj@StormBase(graphconn); % Initialize the superclass with only graphconn
            obj.data_id = data_id;
            obj.session_id = session_id;
            obj.type = type;
        end
        
        function create(obj)
            properties = struct('id', obj.data_id, 'sessionId', obj.session_id, 'type', obj.type);
            if ~nodeExists(obj, 'Data', properties)
                createNode(obj, 'Data', properties);
            else
                warning('Data with ID %s already exists.', obj.data_id);
            end
        end
        
        function data = read(obj, id)
            data = readNode(obj, 'Data', id);
        end
        
        function update(obj, id, properties)
            updateNode(obj, 'Data', id, properties);
        end
        
        function delete(obj, id)
            deleteNode(obj, 'Data', id);
        end
    end
end
