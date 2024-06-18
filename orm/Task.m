classdef Task < StormBase
    properties
        task_id
        data_id
        name
    end
    
    methods
        function obj = Task(graphconn, task_id, data_id, name)
            obj@StormBase(graphconn);
            obj.task_id = task_id;
            obj.data_id = data_id;
            obj.name = name;
        end
        
        function create(obj)
            properties = struct('id', obj.task_id, 'dataId', obj.data_id, 'name', obj.name);
            if ~nodeExists(obj, 'Task', properties)
                createNode(obj, 'Task', properties);
            else
                warning('Task with ID %s already exists.', obj.task_id);
            end
        end
        
        function task = read(obj, id)
            task = readNode(obj, 'Task', id);
        end
        
        function update(obj, id, properties)
            updateNode(obj, 'Task', id, properties);
        end
        
        function delete(obj, id)
            deleteNode(obj, 'Task', id);
        end
    end
end
