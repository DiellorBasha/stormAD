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
            properties = struct('id', obj.modality_id, 'name', obj.name, 'dataset_id', obj.dataset_id);
            if ~obj.nodeExists('Modality', properties)
                obj.createNode('Modality', properties);
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
            obj.deleteNode('Modality', id);
        end
    end
end
