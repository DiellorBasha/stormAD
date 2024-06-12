function updateVertexCoordinates(neo4jconn, vertices)
    % Loop through each vertex and update its coordinates in Neo4j
    for i = 1:size(vertices, 1)
        query = sprintf('MATCH (v:Vertex {vertex_id: %d}) SET v.x = %.4f, v.y = %.4f, v.z = %.4f', ...
                        i, vertices(i, 1), vertices(i, 2), vertices(i, 3));
        % Execute the query
        exec(neo4jconn, query);
    end
    disp('Vertex coordinates updated in Neo4j');
end

% Example usage:
% updateVertexCoordinates(neo4jconn, surface.Vertices);
