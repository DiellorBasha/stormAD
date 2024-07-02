classdef Data < StormBase
    properties
        data_id
        session_id
        name
        submodality
        attributes
    end
    
    methods
        function obj = Data(graphconn, data_id, session_id, name, submodality, varargin)
            obj@StormBase(graphconn);
            obj.data_id = data_id;
            obj.session_id = session_id;
            obj.name = name;
            obj.submodality = submodality;
            obj.attributes = struct(varargin{:});
        end
        
        function create(obj)
            properties = struct('id', obj.data_id, 'sessionId', obj.session_id, 'name', obj.name);
            properties = Data.catstruct(properties, obj.attributes); % Merge properties with attributes
            if ~obj.nodeExists('Data', struct('id', obj.data_id))
                obj.createNode('Data', properties);
                obj.createRelationship('Session', obj.session_id, 'HAS_DATA', 'Data', obj.data_id, struct('submodality', obj.submodality));
            else
                error('Data with ID %s already exists.', obj.data_id);
            end
        end
        
        function data = read(obj, id)
            data = obj.readNode('Data', id);
            % Read the submodality property from the relationship
            query = sprintf('MATCH (s:Session {id: "%s"})-[r:HAS_DATA]->(d:Data {id: "%s"}) RETURN r.submodality', obj.session_id, id);
            result = executeCypher(obj.graphconn, query);
            if ~isempty(result)
                obj.submodality = result.r_submodality{1};
            else
                warning('No submodality found for Data with ID %s', id);
            end
        end
        
        function update(obj, id, properties)
            obj.updateNode('Data', id, properties);
            % Update the submodality property of the relationship
            if isfield(properties, 'submodality')
                query = sprintf('MATCH (s:Session {id: "%s"})-[r:HAS_DATA]->(d:Data {id: "%s"}) SET r.submodality = "%s"', obj.session_id, id, properties.submodality);
                executeCypher(obj.graphconn, query);
                obj.submodality = properties.submodality;
            end
        end
        
        function delete(obj, id)
            obj.deleteRelationship('Session', obj.session_id, 'HAS_DATA', 'Data', id);
            obj.deleteNode('Data', id);
        end
    end
    
    methods(Static)
        function out = catstruct(varargin)
            %CATSTRUCT Concatenate or merge structures with different field names
            out = struct();
            for i = 1:nargin
                s = varargin{i};
                if ~isstruct(s)
                    error('Input argument must be a structure.');
                end
                f = fieldnames(s);
                for j = 1:length(f)
                    out.(f{j}) = s.(f{j});
                end
            end
        end
    end
end