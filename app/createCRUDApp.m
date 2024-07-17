function createCRUDApp(graphconn)
    fig = uifigure('Name', 'Graph Database CRUD App', 'Position', [100 100 600 500]);

    % Create input fields
    uilabel(fig, 'Position', [20 450 100 22], 'Text', 'Node Label:');
    labelField = uieditfield(fig, 'text', 'Position', [120 450 100 22]);

    uilabel(fig, 'Position', [20 420 100 22], 'Text', 'Node ID:');
    idField = uieditfield(fig, 'text', 'Position', [120 420 100 22]);

    uilabel(fig, 'Position', [20 390 100 22], 'Text', 'Node Name:');
    nameField = uieditfield(fig, 'text', 'Position', [120 390 100 22]);

    % Create buttons for CRUD operations
    uibutton(fig, 'Position', [20 350 100 22], 'Text', 'Create', 'ButtonPushedFcn', @(btn,event) createNode(labelField.Value, idField.Value, nameField.Value));
    uibutton(fig, 'Position', [130 350 100 22], 'Text', 'Read', 'ButtonPushedFcn', @(btn,event) readNode(labelField.Value, idField.Value, nameField.Value));
    uibutton(fig, 'Position', [240 350 100 22], 'Text', 'Update', 'ButtonPushedFcn', @(btn,event) updateNode(labelField.Value, idField.Value, nameField.Value));
    uibutton(fig, 'Position', [350 350 100 22], 'Text', 'Delete', 'ButtonPushedFcn', @(btn,event) deleteNode(labelField.Value, idField.Value));

    % Create text area for displaying results
    resultsArea = uitextarea(fig, 'Position', [20 50 560 280]);

    % Function to create a node
    function createNode(label, id, name)
        properties = struct('id', id, 'name', name);
        stormBase = StormBase(graphconn);
        stormBase.createNode(label, properties);
        resultsArea.Value = sprintf('Node with ID %s created.', id);
    end

    % Function to read a node
    function readNode(label, id, name)
        stormBase = StormBase(graphconn);
        if ~isempty(id)
            node = stormBase.readNode(label, id);
        elseif ~isempty(name)
            query = sprintf('MATCH (n:%s {name: "%s"}) RETURN n', label, name);
            result = executeCypher(graphconn, query);
            node = table2struct(result);
        else
            query = sprintf('MATCH (n:%s) RETURN n LIMIT 1', label);
            result = executeCypher(graphconn, query);
            node = table2struct(result);
        end
        if ~isempty(node)
            resultsArea.Value = sprintf('Node ID: %s\nName: %s', node.n.id, node.n.name);
        else
            resultsArea.Value = 'No node found.';
        end
    end

    % Function to update a node
    function updateNode(label, id, name)
        properties = struct('name', name);
        stormBase = StormBase(graphconn);
        stormBase.updateNode(label, id, properties);
        resultsArea.Value = sprintf('Node with ID %s updated.', id);
    end

    % Function to delete a node
    function deleteNode(label, id)
        stormBase = StormBase(graphconn);
        stormBase.deleteNode(label, id);
        resultsArea.Value = sprintf('Node with ID %s deleted.', id);
    end

    % Add a button to visualize the query
    uibutton(fig, 'Position', [20 10 100 22], 'Text', 'Visualize', 'ButtonPushedFcn', @(btn,event) visualizeQuery(labelField.Value, idField.Value, nameField.Value));

    % Function to visualize the query
    function visualizeQuery(label, id, name)
        stormBase = StormBase(graphconn);
        if ~isempty(id)
            query = sprintf('MATCH (n:%s {id: "%s"})-[r]->(m) RETURN n, r, m', label, id);
        elseif ~isempty(name)
            query = sprintf('MATCH (n:%s {name: "%s"})-[r]->(m) RETURN n, r, m', label, name);
        else
            query = sprintf('MATCH (n:%s)-[r]->(m) RETURN n, r, m LIMIT 100', label);
        end
        stormBase.seeQuery(query);
    end
end