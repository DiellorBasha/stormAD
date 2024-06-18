classdef Modality < StormBase
    properties
        modality_id
        dataset_id
        name
    end
    
    methods
        function obj = Modality(graphconn, modality_id, dataset_id, name)
            obj@StormBase(graphconn);
            obj.modality_id = modality_id;
            obj.dataset_id = dataset_id;
            obj.name = name;
        end
        
        function create(obj)
            properties = struct('id', obj.modality_id, 'datasetId', obj.dataset_id, 'name', obj.name);
            if ~obj.nodeExists('Modality', properties)
                obj.createNode('Modality', properties);
                obj.createRelationship('Dataset', obj.dataset_id, 'HAS_MODALITY', 'Modality', obj.modality_id, struct());
            else
                error('Modality with ID %s already exists.', obj.modality_id);
            end
        end
        
        function modality = read(obj, id)
            modality = obj.readNode('Modality', id);
        end
        
        function update(obj, id, properties)
            obj.updateNode('Modality', id, properties);
        end
        
        function delete(obj, id)
            obj.deleteRelationship('Dataset', obj.dataset_id, 'HAS_MODALITY', 'Modality', id);
            obj.deleteNode('Modality', id);
        end
    end
end
