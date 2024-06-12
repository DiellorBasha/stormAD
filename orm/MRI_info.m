classdef MRI_info
    properties
        participant_id
        visit
        type
        subtype
        task
        run
        date
        filepath
        neo4jconn % Add the Neo4j connection as a property
    end
    
    methods
        function obj = MRI_info(participant_id, visit, type, subtype, task, run, date, filepath, neo4jconn)
            if nargin == 0
                % Allow empty initialization
                obj.participant_id = '';
                obj.visit = '';
                obj.type = '';
                obj.subtype = '';
                obj.task = '';
                obj.run = '';
                obj.date = '';
                obj.filepath = '';
                obj.neo4jconn = [];
            else
                obj.participant_id = participant_id;
                obj.visit = visit;
                obj.type = type;
                obj.subtype = subtype;
                obj.task = task;
                obj.run = run;
                obj.date = date;
                obj.filepath = filepath;
                obj.neo4jconn = neo4jconn;
            end
        end
        
function createNode(obj)
    % Define the node label and properties
    label = 'MRI_Info';
    properties = struct('participant_id', obj.participant_id, 'visit', obj.visit, ...
        'type', obj.type, 'subtype', obj.subtype, 'task', obj.task, ...
        'run', obj.run, 'date', obj.date, 'filepath', obj.filepath);
    
    % Create the node in the Neo4j database
    createNode(obj.neo4jconn, 'Labels', label, 'Properties', properties);
end

        
        function createRelationship(obj)
            query = sprintf(['MATCH (p:Participant {participant_id: "%s"}), (m:MRI_Info {participant_id: "%s", '...
                'visit: "%s", type: "%s", subtype: "%s", task: "%s", run: "%s"}) '...
                'CREATE (p)-[:HAS_MRI_INFO]->(m)'], ...
                obj.participant_id, obj.participant_id, obj.visit, obj.type, obj.subtype, obj.task, obj.run);
            executeCypher(obj.neo4jconn, query);
        end
        
        function obj = selectAndExtractFileInfo(obj)
            [file, path] = uigetfile('*.json', 'Select an MRI Info File');
            if isequal(file, 0)
                disp('User selected Cancel');
                return;
            else
                obj.filepath = fullfile(path, file);
                disp(['User selected ', obj.filepath]);
                
                % Extract information from the filename
                [~, name, ~] = fileparts(file);
                parts = split(name, '_');
                
                % Update properties
                obj.participant_id = parts{1};
                obj.visit = parts{2};
                
                for i = 3:length(parts)
                    if contains(parts{i}, 'task')
                        obj.task = extractAfter(parts{i}, 'task-');
                    elseif contains(parts{i}, 'run')
                        obj.run = extractAfter(parts{i}, 'run-');
                    else
                        obj.type = parts{i};
                    end
                end
            end
        end
    end
end
