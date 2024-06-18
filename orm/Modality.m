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
            if ~nodeExists(obj, 'Modality', properties)
                createNode(obj, 'Modality', properties);
            else
                warning('Modality with ID %s already exists.', obj.modality_id);
            end
        end
        
        function modality = read(obj, id)
            modality = readNode(obj, 'Modality', id);
        end
        
        function update(obj, id, properties)
            updateNode(obj, 'Modality', id, properties);
        end
        
        function delete(obj, id)
            deleteNode(obj, 'Modality', id);
        end
    end
end
