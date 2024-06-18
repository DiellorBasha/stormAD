fproj = matlab.project.rootProject;

 % Read database configuration from a text file
    dbconfig = read_dbconfig('dbconfig.txt');

    % Establish a connection to the Neo4j database
    graphconn = neo4j(dbconfig.NEO4J_URL, dbconfig.NEO4J_USERNAME, dbconfig.NEO4J_PASSWORD);

    % Check if the connection was successful
    if ~isempty(neo4jconn.Message)
        error('Connection failed: %s', neo4jconn.Message);
    end

    % Add Brainstorm to search path
    addpath(genpath('C:\Users\diell\Documents\brainstorm3'));
    
    fprintf('Connected to Neo4j database at %s\n', dbconfig.NEO4J_URL);
    clear dbconfig; 