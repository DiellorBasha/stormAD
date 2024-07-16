classdef Modality < Subject
    properties
        modality_id
        modality_name % Use modality_name to avoid conflict
        data_type % An instance of the DataType class
        session % An instance of the Session class
        modalityAttributes % A structure to store additional modality attributes
    end
    
    methods
        function obj = Modality(subject, modality_id, modality_name, data_type, session, modalityAttributes, path)
            if nargin < 7
                % If path is not provided, default to fullfile(Session.path, modality_name)
                path = fullfile(session.path, modality_name);
            end
            % Use the Subject instance to set graphconn and path
            obj@Subject(subject.datasets, subject.derivatives, subject.subject_id, subject.subject_name); % Call the parent constructor with Subject properties
            obj.modality_id = modality_id;
            obj.modality_name = modality_name;
            obj.data_type = data_type;
            obj.session = session;
            obj.modalityAttributes = modalityAttributes;
            obj.path = path; % Set the path property to the constructed path
        end
        
        function create(obj)
            properties = struct('id', obj.modality_id, 'sessionId', obj.session.session_id, 'name', obj.modality_name);
            if ~obj.nodeExists('Modality', properties)
                obj.createNode('Modality', properties);
                obj.createRelationship('Session', obj.session.session_id, 'HAS_MODALITY', 'Modality', obj.modality_id, struct());
                obj.createRelationship('DataType', obj.data_type.data_type_id, 'HAS_MODALITY', 'Modality', obj.modality_id, struct());
            else
                error('Modality with id %s already exists.', obj.modality_id);
            end
        end
        
        function node = read(obj, id)
            node = obj.readNode('Modality', id);
        end
        
        function update(obj, id, properties)
            obj.updateNode('Modality', id, properties);
        end
        
        function delete(obj, id)
            obj.deleteRelationship('Session', obj.session.session_id, 'HAS_MODALITY', 'Modality', id);
            obj.deleteRelationship('DataType', obj.data_type.data_type_id, 'HAS_MODALITY', 'Modality', id);
            obj.deleteNode('Modality', id);
        end
    end
end
