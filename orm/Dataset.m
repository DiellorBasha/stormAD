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
            if ~nodeExists(obj, 'Dataset', properties)
                createNode(obj, 'Dataset', properties);
            else
                warning('Dataset with ID %s already exists.', obj.dataset_id);
            end
        end
        
        function dataset = read(obj, id)
            dataset = readNode(obj, 'Dataset', id);
        end
        
        function update(obj, id, properties)
            updateNode(obj, 'Dataset', id, properties);
        end
        
        function delete(obj, id)
            deleteNode(obj, 'Dataset', id);
        end
    end
end
