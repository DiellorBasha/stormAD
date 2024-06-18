classdef StormBase
    properties
        id
        graphconn
    end
    
    methods
        function obj = StormBase(graphconn)
            obj.graphconn = graphconn;
        end
        
        function createNode(obj, label, properties)
            props = StormBase.constructProps(properties);
            query = sprintf('CREATE (n:%s %s)', label, props);
            executeCypher(obj.graphconn, query);
        end
        
        function node = readNode(obj, label, id)
            query = sprintf('MATCH (n:%s {id: "%s"}) RETURN n', label, id);
            result = executeCypher(obj.graphconn, query);
            if isempty(result)
                error('No node found with id: %s', id);
            end
            node = table2struct(result);
        end
        
        function updateNode(obj, label, id, properties)
            setClause = '';
            fields = fieldnames(properties);
            for i = 1:numel(fields)
                if i > 1
                    setClause = [setClause, ', '];
                end
                setClause = [setClause, sprintf('n.%s = "%s"', fields{i}, properties.(fields{i}))];
            end
            query = sprintf('MATCH (n:%s {id: "%s"}) SET %s', label, id, setClause);
            executeCypher(obj.graphconn, query);
        end
        
        function deleteNode(obj, label, id)
            query = sprintf('MATCH (n:%s {id: "%s"}) DETACH DELETE n', label, id);
            executeCypher(obj.graphconn, query);
        end
        
        function exists = nodeExists(obj, label, properties)
            matchClause = '';
            fields = fieldnames(properties);
            for i = 1:numel(fields)
                if i > 1
                    matchClause = [matchClause, ' AND '];
                end
                matchClause = [matchClause, sprintf('n.%s = "%s"', fields{i}, properties.(fields{i}))];
            end
            query = sprintf('MATCH (n:%s) WHERE %s RETURN n', label, matchClause);
            result = executeCypher(obj.graphconn, query);
            exists = ~isempty(result);
        end
        
        % Relationship CRUD operations
        function createRelationship(obj, fromLabel, fromId, relType, toLabel, toId, relProperties)
            if nargin < 7
                relProperties = struct();
            end
            relProps = StormBase.constructProps(relProperties);
            query = sprintf('MATCH (a:%s {id: "%s"}), (b:%s {id: "%s"}) CREATE (a)-[r:%s %s]->(b)', fromLabel, fromId, toLabel, toId, relType, relProps);
            executeCypher(obj.graphconn, query);
        end
        
        function relationship = readRelationship(obj, fromLabel, fromId, relType, toLabel, toId)
            query = sprintf('MATCH (a:%s {id: "%s"})-[r:%s]->(b:%s {id: "%s"}) RETURN r', fromLabel, fromId, relType, toLabel, toId);
            result = executeCypher(obj.graphconn, query);
            if isempty(result)
                error('No relationship found between %s and %s', fromId, toId);
            end
            relationship = table2struct(result);
        end
        
        function updateRelationship(obj, fromLabel, fromId, relType, toLabel, toId, relProperties)
            setClause = '';
            fields = fieldnames(relProperties);
            for i = 1:numel(fields)
                if i > 1
                    setClause = [setClause, ', '];
                end
                setClause = [setClause, sprintf('r.%s = "%s"', fields{i}, relProperties.(fields{i}))];
            end
            query = sprintf('MATCH (a:%s {id: "%s"})-[r:%s]->(b:%s {id: "%s"}) SET %s', fromLabel, fromId, relType, toLabel, toId, setClause);
            executeCypher(obj.graphconn, query);
        end
        
        function deleteRelationship(obj, fromLabel, fromId, relType, toLabel, toId)
            query = sprintf('MATCH (a:%s {id: "%s"})-[r:%s]->(b:%s {id: "%s"}) DELETE r', fromLabel, fromId, relType, toLabel, toId);
            executeCypher(obj.graphconn, query);
        end
    end
    
    methods(Static)
        function props = constructProps(properties)
            fields = fieldnames(properties);
            props = '{';
            for i = 1:numel(fields)
                if i > 1
                    props = [props, ', '];
                end
                value = properties.(fields{i});
                if ischar(value)
                    value = sprintf('"%s"', value); % Add quotes around string values
                elseif isnumeric(value)
                    value = num2str(value); % Convert numeric values to string
                end
                props = [props, sprintf('%s: %s', fields{i}, value)];
            end
            props = [props, '}'];
        end
    end
end
