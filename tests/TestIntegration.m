classdef TestIntegration < TestBase
    methods(Test)
        function testCreateAllEntities(testCase)
            % Ensure the nodes do not exist before each test
            executeCypher(testCase.graphconn, 'MATCH (d:Dataset {id: "dataset_id_test"}) DETACH DELETE d');
            executeCypher(testCase.graphconn, 'MATCH (m:Modality {id: "modality_id_test"}) DETACH DELETE m');
            executeCypher(testCase.graphconn, 'MATCH (p:Participant {id: "participant_id_test"}) DETACH DELETE p');
            executeCypher(testCase.graphconn, 'MATCH (s:Session {id: "session_id_test"}) DETACH DELETE s');
            executeCypher(testCase.graphconn, 'MATCH (d:Data {id: "data_id_test"}) DETACH DELETE d');
            executeCypher(testCase.graphconn, 'MATCH (d:Derivatives {id: "derivatives_id_test"}) DETACH DELETE d');
            executeCypher(testCase.graphconn, 'MATCH (t:Task {id: "task_id_test"}) DETACH DELETE t');
            
            % Create Dataset
            dataset = Dataset(testCase.graphconn, 'dataset_id_test', 'Test Dataset');
            dataset.create();
            result = executeCypher(testCase.graphconn, 'MATCH (d:Dataset {id: "dataset_id_test"}) RETURN d');
            testCase.verifyNotEmpty(result.d, 'Dataset node was not created.');
            
            % Create Modality
            modality = Modality(testCase.graphconn, 'modality_id_test', 'dataset_id_test', 'MEG');
            modality.create();
            result = executeCypher(testCase.graphconn, 'MATCH (m:Modality {id: "modality_id_test"}) RETURN m');
            testCase.verifyNotEmpty(result.m, 'Modality node was not created.');
            
            % Create Derivatives
            derivatives = Derivatives(testCase.graphconn, 'derivatives_id_test', 'modality_id_test', 'tau');
            derivatives.create();
            result = executeCypher(testCase.graphconn, 'MATCH (d:Derivatives {id: "derivatives_id_test"}) RETURN d');
            testCase.verifyNotEmpty(result.d, 'Derivatives node was not created.');
            
            % Create Participant
            participant = Participant(testCase.graphconn, 'participant_id_test', 'modality_id_test', 'derivatives_id_test', 'John Doe');
            participant.create();
            result = executeCypher(testCase.graphconn, 'MATCH (p:Participant {id: "participant_id_test"}) RETURN p');
            testCase.verifyNotEmpty(result.p, 'Participant node was not created.');
            
            % Create Session
            session = Session(testCase.graphconn, 'session_id_test', 'participant_id_test', 'Test Session');
            session.create();
            result = executeCypher(testCase.graphconn, 'MATCH (s:Session {id: "session_id_test"}) RETURN s');
            testCase.verifyNotEmpty(result.s, 'Session node was not created.');
            
            % Create Data
            data = Scan(testCase.graphconn, 'data_id_test', 'session_id_test', 'MRI Data', 'anat', 'intensity', 1.23, 'measurement', 'value');
            data.create();
            result = executeCypher(testCase.graphconn, 'MATCH (d:Data {id: "data_id_test"}) RETURN d');
            testCase.verifyNotEmpty(result.d, 'Data node was not created.');
            
            % Create Task
            task = Task(testCase.graphconn, 'task_id_test', 'data_id_test', 'Test Task');
            task.create();
            result = executeCypher(testCase.graphconn, 'MATCH (t:Task {id: "task_id_test"}) RETURN t');
            testCase.verifyNotEmpty(result.t, 'Task node was not created.');
            
            % Verify relationships
            relResult = executeCypher(testCase.graphconn, 'MATCH (ds:Dataset {id: "dataset_id_test"})-[:HAS_MODALITY]->(m:Modality {id: "modality_id_test"}) RETURN m');
            testCase.verifyNotEmpty(relResult.m, 'HAS_MODALITY relationship was not created.');
            
            relResult = executeCypher(testCase.graphconn, 'MATCH (m:Modality {id: "modality_id_test"})-[:HAS_DERIVATIVES]->(d:Derivatives {id: "derivatives_id_test"}) RETURN d');
            testCase.verifyNotEmpty(relResult.d, 'HAS_DERIVATIVES relationship was not created.');
            
            relResult = executeCypher(testCase.graphconn, 'MATCH (m:Modality {id: "modality_id_test"})-[:HAS_PARTICIPANT]->(p:Participant {id: "participant_id_test"}) RETURN p');
            testCase.verifyNotEmpty(relResult.p, 'HAS_PARTICIPANT relationship from Modality was not created.');
            
            relResult = executeCypher(testCase.graphconn, 'MATCH (d:Derivatives {id: "derivatives_id_test"})-[:HAS_PARTICIPANT]->(p:Participant {id: "participant_id_test"}) RETURN p');
            testCase.verifyNotEmpty(relResult.p, 'HAS_PARTICIPANT relationship from Derivatives was not created.');
            
            relResult = executeCypher(testCase.graphconn, 'MATCH (p:Participant {id: "participant_id_test"})-[:HAS_SESSION]->(s:Session {id: "session_id_test"}) RETURN s');
            testCase.verifyNotEmpty(relResult.s, 'HAS_SESSION relationship was not created.');
            
            relResult = executeCypher(testCase.graphconn, 'MATCH (s:Session {id: "session_id_test"})-[r:HAS_DATA]->(d:Data {id: "data_id_test"}) RETURN r.submodality');
            testCase.verifyEqual(relResult.r_submodality{1}, 'anat', 'HAS_DATA relationship with submodality was not created.');
            
            relResult = executeCypher(testCase.graphconn, 'MATCH (d:Data {id: "data_id_test"})-[:HAS_TASK]->(t:Task {id: "task_id_test"}) RETURN t');
            testCase.verifyNotEmpty(relResult.t, 'HAS_TASK relationship was not created.');
        end
    end
end
