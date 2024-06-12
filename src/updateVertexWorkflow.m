% Full workflow to connect to Neo4j and update vertex coordinates

% Step 1: Define connection function
function neo4jconn = connectToNeo4j(url, username, password)
    % Connect to the Neo4j database
    neo4jconn = neo4j(url, username, password);
    
    % Check the connection
    if isempty(neo4jconn.Message)
        disp('Connection to Neo4j successful');
    else
        error('Failed to connect to Neo4j: %s', neo4jconn.Message);
    end
end

% Step 2: Define update function
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
% Define Neo4j connection parameters
url = 'http://localhost:7474/db/data';
username = 'neo4j';
password = 'password';

% Connect to Neo4j
neo4jconn = connectToNeo4j(url, username, password);

% Load the surface structure
load('C:\Users\diell\OneDrive - McGill University\6.Code\StormNet\surface.mat');

% Update vertex coordinates in Neo4j
updateVertexCoordinates(neo4jconn, surface.Vertices);
