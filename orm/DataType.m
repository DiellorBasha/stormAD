classdef DataType < Session
    properties
        data_type_id
        data_type_name % Use data_type_name to avoid conflict with the inherited name property
    end
    
    methods
        function obj = DataType(session, data_type_id, data_type_name, path)
            if nargin < 4
                % If path is not provided, default to fullfile(Session.path, data_type_name)
                path = fullfile(session.path, data_type_name);
            end
            % Use the Session instance to set graphconn and path
            obj@Session(session.subject, session.session_id, session.session_name, session.path); % Call the parent constructor with Session properties
            obj.data_type_id = data_type_id;
            obj.data_type_name = data_type_name;
            obj.path = path; % Set the path property to the constructed path
        end
        
        function create(obj)
            properties = struct('id', obj.data_type_id, 'sessionId', obj.session_id, 'name', obj.data_type_name);
            if ~obj.nodeExists('DataType', properties)
                obj.createNode('DataType', properties);
                obj.createRelationship('Session', obj.session_id, 'HAS_DATA_TYPE', 'DataType', obj.data_type_id, struct());
            else
                error('DataType with id %s already exists.', obj.data_type_id);
            end
        end
        
        function node = read(obj, id)
            node = obj.readNode('DataType', id);
        end
        
        function update(obj, id, properties)
            obj.updateNode('DataType', id, properties);
        end
        
        function delete(obj, id)
            obj.deleteRelationship('Session', obj.session_id, 'HAS_DATA_TYPE', 'DataType', id);
            obj.deleteNode('DataType', id);
        end
    end
end
