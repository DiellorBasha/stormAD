classdef Derivatives < StormBase
    properties
        derivatives_id
        modality_id
        name
    end
    
    methods
        function obj = Derivatives(graphconn, derivatives_id, modality_id, name)
            obj@StormBase(graphconn);
            obj.derivatives_id = derivatives_id;
            obj.modality_id = modality_id;
            obj.name = name;
        end
        
        function create(obj)
            properties = struct('id', obj.derivatives_id, 'modalityId', obj.modality_id, 'name', obj.name);
            if ~obj.nodeExists('Derivatives', properties)
                obj.createNode('Derivatives', properties);
                obj.createRelationship('Modality', obj.modality_id, 'HAS_DERIVATIVES', 'Derivatives', obj.derivatives_id);
            else
                warning('Derivatives with ID %s already exists.', obj.derivatives_id);
            end
        end
        
        function derivatives = read(obj, id)
            derivatives = obj.readNode('Derivatives', id);
        end
        
        function update(obj, id, properties)
            obj.updateNode('Derivatives', id, properties);
        end
        
        function delete(obj, id)
            obj.deleteNode('Derivatives', id);
        end
    end
end
