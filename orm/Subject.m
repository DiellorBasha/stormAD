classdef Subject < StormBase
    properties
        subject_id
        datasets % Cell array to store multiple Dataset instances
        derivatives % Cell array to store multiple Derivatives instances
        subject_name % Use subject_name to avoid conflict
    end
    
    methods
        function obj = Subject(datasets, derivatives, subject_id, subject_name)
            % Set the path based on the first dataset's path and the subject name
            if isempty(datasets)
                error('At least one Dataset instance must be provided.');
            end
            datasetPath = fullfile(datasets{1}.path, subject_name);
            
            % Use the first Dataset instance to set graphconn and path
            obj@StormBase(datasets{1}.graphconn, datasetPath);
            obj.subject_id = subject_id;
            obj.datasets = datasets;
            obj.derivatives = derivatives;
            obj.subject_name = subject_name;
        end
        
        function create(obj)
            properties = struct('id', obj.subject_id, 'name', obj.subject_name);
            if ~obj.nodeExists('Subject', properties)
                obj.createNode('Subject', properties);
                
                % Create relationships with all datasets
                for i = 1:numel(obj.datasets)
                    obj.createRelationship('Dataset', obj.datasets{i}.dataset_id, 'HAS_SUBJECT', 'Subject', obj.subject_id, struct());
                end
                
                % Create relationships with all derivatives
                for i = 1:numel(obj.derivatives)
                    obj.createRelationship('Derivatives', obj.derivatives{i}.derivatives_id, 'HAS_SUBJECT', 'Subject', obj.subject_id, struct());
                end
            else
                warning('Subject with ID %s already exists.', obj.subject_id);
            end
        end
        
        function subject = read(obj, id)
            subject = obj.readNode('Subject', id);
        end
        
        function update(obj, id, properties)
            obj.updateNode('Subject', id, properties);
        end
        
        function delete(obj, id)
            for i = 1:numel(obj.datasets)
                obj.deleteRelationship('Dataset', obj.datasets{i}.dataset_id, 'HAS_SUBJECT', 'Subject', id);
            end
            for i = 1:numel(obj.derivatives)
                obj.deleteRelationship('Derivatives', obj.derivatives{i}.derivatives_id, 'HAS_SUBJECT', 'Subject', id);
            end
            obj.deleteNode('Subject', id);
        end
    end
end
