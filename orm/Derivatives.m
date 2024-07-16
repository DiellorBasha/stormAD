classdef Derivatives < Dataset
    properties
        derivatives_id
        pipeline
        derivatives_name % Use derivatives_name to avoid conflict with the inherited name property
    end
    
    methods
        function obj = Derivatives(dataset, derivatives_id, derivatives_name, pipeline, path)
            if nargin < 5
                % If path is not provided, default to fullfile(Dataset.path, 'derivatives', pipeline)
                path = fullfile(dataset.path, 'derivatives', pipeline);
            end
            % Use the Dataset instance to set graphconn and path
            obj@Dataset(dataset.multimodal, dataset.dataset_id, dataset.dataset_name); % Call the parent constructor with Dataset properties
            obj.derivatives_id = derivatives_id;
            obj.derivatives_name = derivatives_name;
            obj.pipeline = pipeline;
            obj.path = path; % Set the path property to the constructed path
        end
        
        function create(obj)
            properties = struct('id', obj.derivatives_id, 'datasetId', obj.dataset_id, 'name', obj.derivatives_name, 'pipeline', obj.pipeline);
            if ~obj.nodeExists('Derivatives', properties)
                obj.createNode('Derivatives', properties);
                obj.createRelationship('Dataset', obj.dataset_id, 'HAS_DERIVATIVES', 'Derivatives', obj.derivatives_id, struct());
            else
                warning('Derivatives with ID %s already exists.', obj.derivatives_id);
            end
        end
        
        function node = read(obj, id)
            node = obj.readNode('Derivatives', id);
        end
        
        function update(obj, id, properties)
            obj.updateNode('Derivatives', id, properties);
        end
        
        function delete(obj, id)
            obj.deleteRelationship('Dataset', obj.dataset_id, 'HAS_DERIVATIVES', 'Derivatives', id);
            obj.deleteNode('Derivatives', id);
        end
    end
end
