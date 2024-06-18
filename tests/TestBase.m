classdef TestBase < matlab.unittest.TestCase
    properties
        graphconn
    end
    
    methods(TestMethodSetup)
        function createConnection(testCase)
            % Read database configuration from a text file
            dbconfig = read_dbconfig('dbconfig.txt');
            
            % Establish a connection to the Neo4j database
            testCase.graphconn = neo4j(dbconfig.NEO4J_URL, dbconfig.NEO4J_USERNAME, dbconfig.NEO4J_PASSWORD);
            
            % Check connection status
            if ~isempty(testCase.graphconn.Message)
                error('Failed to connect to Neo4j: %s', testCase.graphconn.Message);
            end
        end
    end
    
    methods(TestMethodTeardown)
        function closeConnection(testCase)
            close(testCase.graphconn);
        end
    end
end
