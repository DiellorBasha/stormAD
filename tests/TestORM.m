classdef TestORM < matlab.unittest.TestCase
    properties
        graphconn
        modality
        participant
        session
        data
    end
    
    methods(TestMethodSetup)
        function createConnection(testCase)
            testCase.graphconn = neo4j('http://localhost:7474', 'username', 'password');
            testCase.modality = Modality(testCase.graphconn, 'modality_id_test', 'dataset_id_test', 'PET');
            testCase.participant = Participant(testCase.graphconn, 'participant_id_test', 'modality_id_test', '', 'John Doe');
            testCase.session = Session(testCase.graphconn, 'session_id_test', 'participant_id_test', 'Baseline');
            testCase.data = Data(testCase.graphconn, 'data_id_test', 'session_id_test', 'DataType');
        end
    end
    
    methods(TestMethodTeardown)
        function closeConnection(testCase)
            close(testCase.graphconn);
        end
    end
    
    methods(Test)
        function testCreateAndLinkEntities(testCase)
            testCase.modality.create();
            testCase.participant.create();
            testCase.participant.createSessionRelationship(testCase.session);
            testCase.session.create();
            testCase.data.create();
            
            query = ['MATCH (m:Modality {id: "modality_id_test"})-[:HAS_PARTICIPANT]->(p:Participant {id: "participant_id_test"})', ...
                     '-[:HAS_SESSION {session_id: "session_id_test"}]->(s:Session {id: "session_id_test"})-[:HAS_DATA]->(d:Data {id: "data_id_test"}) ', ...
                     'RETURN m, p, s, d'];
            result = fetch(testCase.graphconn, query);
            
            testCase.verifyNotEmpty(result, 'Data node linkage through Modality, Participant, and Session was not created correctly.');
        end
    end
end