classdef TestIntegration < TestBase
    methods(Test)
        function testCreateAndLinkEntities(testCase)
            % Create Dataset
            dataset = Dataset(testCase.graphconn, 'dataset_id_test', 'Brain Health Study');
            dataset.create();
            
            % Create Modality
            modality = Modality(testCase.graphconn, 'modality_id_test', 'dataset_id_test', 'MRI');
            modality.create();
            
            % Create Participant
            participant = Participant(testCase.graphconn, 'participant_id_test', 'modality_id_test', '', 'John Doe');
            participant.create();
            
            % Create Session
            session = Session(testCase.graphconn, 'session_id_test', 'participant_id_test', 'Baseline');
            session.create();
            participant.createSessionRelationship(session);
            
            % Create Data
            data = Data(testCase.graphconn, 'data_id_test', 'session_id_test', 'Structural MRI');
            data.create();
            
            % Link Data to Session
            query = sprintf('MATCH (s:Session {id: "%s"}), (d:Data {id: "%s"}) CREATE (s)-[:HAS_DATA]->(d)', session.session_id, data.data_id);
            executeCypher(testCase.graphconn, query);
            
            % Verify the entire linkage
            query = ['MATCH (d:Dataset {id: "dataset_id_test"})-[:HAS_MODALITY]->(m:Modality {id: "modality_id_test"})-[:HAS_PARTICIPANT]->(p:Participant {id: "participant_id_test"})', ...
                     '-[:HAS_SESSION {session_id: "session_id_test"}]->(s:Session {id: "session_id_test"})-[:HAS_DATA]->(d:Data {id: "data_id_test"}) ', ...
                     'RETURN d, m, p, s, d'];
            result = fetch(testCase.graphconn, query);
            testCase.verifyNotEmpty(result, 'The linkage from Dataset to Data node was not created correctly.');
        end
    end
end
