% connect to neo4j 

% Read database configuration from a text file
    dbconfig = read_dbconfig('dbconfig.txt');

    % Establish a connection to the Neo4j database
    graphconn = neo4j(dbconfig.NEO4J_URL, dbconfig.NEO4J_USERNAME, dbconfig.NEO4J_PASSWORD);

    % Check if the connection was successful
    if ~isempty(graphconn.Message)
        error('Connection failed: %s', graphconn.Message);
    else
       fprintf('Connected to Neo4j database at %s\n', dbconfig.NEO4J_URL);
    end

 clear dbconfig; 
