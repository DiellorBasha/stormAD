classdef Dataset < StormBase
    properties
        dataset_id
        name
    end
    
    methods
        function obj = Dataset(graphconn, dataset_id, name)
            obj@StormBase(graphconn);
            obj.dataset_id = dataset_id;
            obj.name = name;
        end
        
        function create(obj)
            properties = struct('id', obj.dataset_id, 'name', obj.name);
            if ~obj.nodeExists('Dataset', properties)
                obj.createNode('Dataset', properties);
            else
                error('Dataset with id %s already exists.', obj.dataset_id);
            end
        end
        
        function node = read(obj, id)
            node = obj.readNode('Dataset', id);
        end
        
        function update(obj, id, properties)
            obj.updateNode('Dataset', id, properties);
        end
        
        function delete(obj, id)
            obj.deleteNode('Dataset', id);
        end
    end
end
