function generateCypherQueries(vertices, edges, outputFilePath)
    % Open the file for writing
    fileID = fopen(outputFilePath, 'w');
    
    % Check if the file opened successfully
    if fileID == -1
        error('Could not open file for writing.');
    end
    
    % Write vertices to the file
    fprintf(fileID, 'Creating vertices...\n');
    for i = 1:size(vertices, 1)
        fprintf(fileID, 'CREATE (v%d:Vertex {vertex_id: %d, x: %.4f, y: %.4f, z: %.4f});\n', ...
                i, i, vertices(i, 1), vertices(i, 2), vertices(i, 3));
    end
    
    % Write edges to the file
    fprintf(fileID, 'Creating edges...\n');
    for i = 1:size(edges, 1)
        v1 = edges(i, 1);
        v2 = edges(i, 2);
        fprintf(fileID, 'MATCH (v%d:Vertex {vertex_id: %d}), (v%d:Vertex {vertex_id: %d})\n', ...
                v1, v1, v2, v2);
        fprintf(fileID, 'CREATE (v%d)-[:CONNECTED_TO]->(v%d);\n', v1, v2);
    end
    
    % Close the file
    fclose(fileID);
    
    fprintf('Cypher queries have been written to %s\n', outputFilePath);
end
