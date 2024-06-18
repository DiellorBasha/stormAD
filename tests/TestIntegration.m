classdef TestIntegration < TestBase
    methods(TestMethodSetup)
        function setup(testCase)
            % Ensure the nodes do not exist before each test
            executeCypher(testCase.graphconn, 'MATCH (d:Dataset {id: "dataset_id_test"}) DETACH DELETE d');
            executeCypher(testCase.graphconn, 'MATCH (m:Modality {id: "modality_id_test"}) DETACH DELETE m');
            executeCypher(testCase.graphconn, 'MATCH (p:Participant {id: "participant_id_test"}) DETACH DELETE p');
            executeCypher(testCase.graphconn, 'MATCH (s:Session {id: "session_id_test"}) DETACH DELETE s');
            executeCypher(testCase.graphconn, 'MATCH (d:Data {id: "data_id_test"}) DETACH DELETE d');
            executeCypher(testCase.graphconn, 'MATCH (d:Derivatives {id: "derivatives_id_test"}) DETACH DELETE d');
            
            % Create necessary nodes for testing
            dataset = Dataset(testCase.graphconn, 'dataset_id_test', 'Brain Health Study');
            dataset.create();
            modality = Modality(testCase.graphconn, 'modality_id_test', 'dataset_id_test', 'MRI');
            modality.create();
        end
    end
    
    methods(Test)
        function testCreateAndLinkEntities(testCase)
            % Create and link Participant and Data nodes
            participant = Participant(testCase.graphconn, 'participant_id_test', 'modality_id_test', '', 'John Doe');
            participant.create();
            session = Session(testCase.graphconn, 'session_id_test', 'participant_id_test');
            session.create();
            data = Data(testCase.graphconn, 'data_id_test', 'session_id_test', 'Initial Session');
            data.create();
            
            % Verify linkage for Data node
            result = executeCypher(testCase.graphconn, 'MATCH (s:Session {id: "session_id_test"})-[:HAS_DATA]->(d:Data {id: "data_id_test"}) RETURN s, d');
            testCase.verifyNotEmpty(result.s, 'Session node was not linked to Data node.');
            testCase.verifyNotEmpty(result.d, 'Data node was not linked to Session node.');
        end
        
        function testCreateAndLinkDerivatives(testCase)
            % Create and link Derivatives node
            derivatives = Derivatives(testCase.graphconn, 'derivatives_id_test', 'modality_id_test', 'Analysis 1');
            derivatives.create();
            
            % Verify linkage for Derivatives node
            result = executeCypher(testCase.graphconn, 'MATCH (m:Modality {id: "modality_id_test"})-[:HAS_DERIVATIVES]->(d:Derivatives {id: "derivatives_id_test"}) RETURN m, d');
            testCase.verifyNotEmpty(result.m, 'Modality node was not linked to Derivatives node.');
            testCase.verifyNotEmpty(result.d, 'Derivatives node was not linked to Modality node.');
        end
    end
end
