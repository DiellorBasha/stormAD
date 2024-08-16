classdef Multimodal < StormBase
    properties
        multimodal_id
        multimodal_name
    end
    
    methods
        function obj = Multimodal(graphconn, path, multimodal_id, multimodal_name)
            obj@StormBase(graphconn, path);
            obj.multimodal_id = multimodal_id;
            obj.multimodal_name = multimodal_name;
        end
        
        function create(obj)
            properties = struct('id', obj.multimodal_id, 'multimodal_name', obj.multimodal_name);
            if ~obj.nodeExists('Multimodal', properties)
                obj.createNode('Multimodal', properties);
            else
                error('Multimodal with id %s already exists.', obj.multimodal_id);
            end
        end
        
        function node = read(obj, id)
            node = obj.readNode('Multimodal', id);
        end
        
        function update(obj, id, properties)
            obj.updateNode('Multimodal', id, properties);
        end
        
        function delete(obj, id)
            obj.deleteNode('Multimodal', id);
        end
        
        % Function to read contents of the multimodal directory
        function contents = readMultimodalContents(obj)
            contents = obj.readContents();
        end
        
        % Function to create datasets from the multimodal directory contents
        function datasets = createFromContents(obj)
            % Read the contents of the multimodal directory
            datasetDirs = obj.readContents();
            datasetDirs = datasetDirs([datasetDirs.isdir]); % Keep only directories
            datasetDirs = datasetDirs(~ismember({datasetDirs.name}, {'.', '..'})); % Remove . and ..
            
            % Initialize cell array to store Dataset instances
            datasets = cell(1, length(datasetDirs));
            
            % Iterate over each directory and create a Dataset instance
            for i = 1:length(datasetDirs)
                datasetName = datasetDirs(i).name;
                datasetId = ['dataset_id_', num2str(i)]; % Generate a unique dataset ID
                
                % Create an instance of the Dataset class
                dataset = Dataset(obj, datasetId, datasetName);
                
                % Try to create the dataset node in the graph
                try
                    dataset.create();
                    disp(['Dataset "', datasetName, '" created successfully.']);
                    % Store the dataset instance in the cell array
                    datasets{i} = dataset;
                catch ME
                    disp(['Failed to create dataset "', datasetName, '": ', ME.message]);
                end
            end
        end
    end
end
