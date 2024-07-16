classdef Dataset < Multimodal
    properties
        dataset_id
        dataset_name
        multimodal
        dataset_description % Property to store the contents of dataset_description.json
        subjects % Property to store the contents of participants.json or participants.tsv
    end
    
    methods
        function obj = Dataset(multimodal, dataset_id, dataset_name)
            obj@Multimodal(multimodal.graphconn, fullfile(multimodal.path, dataset_name), multimodal.multimodal_id, multimodal.multimodal_name); % Call the parent constructor with Multimodal properties
            obj.dataset_id = dataset_id;
            obj.dataset_name = dataset_name;
            obj.multimodal = multimodal;
            
            % Initialize dataset_description and subjects as empty structures
            obj.dataset_description = struct();
            obj.subjects = table();
        end
        
        function create(obj)
            properties = struct('id', obj.dataset_id, 'name', obj.dataset_name);
            if ~obj.nodeExists('Dataset', properties)
                obj.createNode('Dataset', properties);
                obj.createRelationship('Multimodal', obj.multimodal_id, 'HAS_DATASET', 'Dataset', obj.dataset_id, struct());
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
            obj.deleteRelationship('Multimodal', obj.multimodal_id, 'HAS_DATASET', 'Dataset', id);
            obj.deleteNode('Dataset', id);
        end
        
        % Function to read contents of the dataset directory
        function contents = readDatasetContents(obj)
            contents = obj.readContents();
        end
        
        % Function to read dataset description and participants files
        function readDatasetFiles(obj)
            % Check for dataset_description.json
            if isfile(fullfile(obj.path, 'dataset_description.json'))
                disp('Found dataset_description.json');
                % Read and store the contents of dataset_description.json
                obj.dataset_description = jsondecode(fileread(fullfile(obj.path, 'dataset_description.json')));
            end
            
            % Check for participants.json or participants.tsv
            if isfile(fullfile(obj.path, 'participants.json'))
                disp('Found participants.json');
                % Read and store the contents of participants.json
                obj.subjects = struct2table(jsondecode(fileread(fullfile(obj.path, 'participants.json'))));
            elseif isfile(fullfile(obj.path, 'participants.tsv'))
                disp('Found participants.tsv');
                % Read and store the contents of participants.tsv
                obj.subjects = readtable(fullfile(obj.path, 'participants.tsv'), 'FileType', 'text', 'Delimiter', '\t');
            end
        end
    end
end
z