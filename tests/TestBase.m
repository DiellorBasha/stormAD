classdef TestBase < matlab.unittest.TestCase
    properties
        graphconn
    end
    
    methods(TestMethodSetup)
        function createConnection(testCase)
            testCase.graphconn = neo4j('http://localhost:7474', 'username', 'password');
        end
    end
    
    methods(TestMethodTeardown)
        function closeConnection(testCase)
            close(testCase.graphconn);
        end
    end
end
