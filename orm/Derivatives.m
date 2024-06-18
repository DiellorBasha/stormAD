classdef Derivatives < StormNet
    properties
        derivatives_id
        modality_id
        name
    end
    
    methods
        function obj = Derivatives(graphconn, derivatives_id, modality_id, name)
            obj@StormNet(graphconn);
            obj.derivatives_id = derivatives_id;
            obj.modality_id = modality_id;
            obj.name = name;
        end
        
        function create(obj)
            properties = struct('id', obj.derivatives_id, 'modalityId', obj.modality_id, 'name', obj.name);
            if ~nodeExists(obj, 'Derivatives', properties)
                createNode(obj, 'Derivatives', properties);
            else
                warning('Derivatives with ID %s already exists.', obj.derivatives_id);
            end
        end
        
        function derivatives = read(obj, id)
            derivatives = readNode(obj, 'Derivatives', id);
        end
        
        function update(obj, id, properties)
            updateNode(obj, 'Derivatives', id, properties);
        end
        
        function delete(obj, id)
            deleteNode(obj, 'Derivatives', id);
        end
    end
end
