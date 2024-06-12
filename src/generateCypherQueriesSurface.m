function generateCypherQueriesSurface(surface, edges)
    vertices = surface.Vertices;
    
    % Generate Cypher queries for Neo4j
    disp('Creating Cypher queries...');
    
    % Create vertices
    for i = 1:size(vertices, 1)
        fprintf('CREATE (v%d:Vertex {vertex_id: %d, x: %.4f, y: %.4f, z: %.4f});\n', ...
                i, i, vertices(i, 1), vertices(i, 2), vertices(i, 3));
    end
    
    % Create edges
    for i = 1:size(edges, 1)
        v1 = edges(i, 1);
        v2 = edges(i, 2);
        fprintf('MATCH (v%d:Vertex {vertex_id: %d}), (v%d:Vertex {vertex_id: %d})\n', ...
                v1, v1, v2, v2);
        fprintf('CREATE (v%d)-[:CONNECTED_TO]->(v%d);\n', v1, v2);
    end
end
