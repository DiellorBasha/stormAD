classdef TestData < TestBase
    methods(Test)
        function testCreateData(testCase)
            % Clean up any existing node
            data = Data(testCase.graphconn, 'data_id_test', 'session_id_test', 'MRI Data', 'anat', 'intensity', 1.23, 'measurement', 'value');
            data.delete('data_id_test'); % Ensure clean state
            
            % Clean up related session node
            executeCypher(testCase.graphconn, 'MATCH (s:Session {id: "session_id_test"}) DETACH DELETE s');
            
            % Create related session node
            session = Session(testCase.graphconn, 'session_id_test', 'participant_id_test', 'Test Session');
            session.create();
            
            data.create();
            result = executeCypher(testCase.graphconn, 'MATCH (d:Data {id: "data_id_test"}) RETURN d');
            testCase.verifyNotEmpty(result.d, 'Data node was not created.');
            testCase.verifyEqual(result.d.name, 'MRI Data', 'Data name does not match.');
            testCase.verifyEqual(result.d.intensity, 1.23, 'Data intensity does not match.');
            testCase.verifyEqual(result.d.measurement, 'value', 'Data measurement does not match.');
            
            % Verify the submodality property in the relationship
            relResult = executeCypher(testCase.graphconn, 'MATCH (s:Session {id: "session_id_test"})-[r:HAS_DATA]->(d:Data {id: "data_id_test"}) RETURN r');
            testCase.verifyEqual(relResult.r.submodality, 'anat', 'Data submodality does not match.');
        end
        
        function testReadData(testCase)
            % Clean up any existing node
            data = Data(testCase.graphconn, 'data_id_test', 'session_id_test', 'MRI Data', 'anat', 'intensity', 1.23, 'measurement', 'value');
            data.delete('data_id_test'); % Ensure clean state
            
            % Create related session node
            executeCypher(testCase.graphconn, 'MERGE (s:Session {id: "session_id_test", participantId: "participant_id_test", name: "Test Session"})');
            
            data.create();
            dataNode = data.read('data_id_test');
            testCase.verifyEqual(dataNode.n.name, 'MRI Data', 'Data name does not match.');
            testCase.verifyEqual(dataNode.n.intensity, 1.23, 'Data intensity does not match.');
            testCase.verifyEqual(dataNode.n.measurement, 'value', 'Data measurement does not match.');
            testCase.verifyEqual(data.submodality, 'anat', 'Data submodality does not match.');
        end
        
        function testUpdateData(testCase)
            % Clean up any existing node
            data = Data(testCase.graphconn, 'data_id_test', 'session_id_test', 'MRI Data', 'anat', 'intensity', 1.23, 'measurement', 'value');
            data.delete('data_id_test'); % Ensure clean state
            
            % Create related session node
            executeCypher(testCase.graphconn, 'MERGE (s:Session {id: "session_id_test", participantId: "participant_id_test", name: "Test Session"})');
            
            data.create();
            data.update('data_id_test', struct('name', 'Updated MRI Data', 'intensity', 2.34, 'submodality', 'func'));
            dataNode = data.read('data_id_test');
            testCase.verifyEqual(dataNode.n.name, 'Updated MRI Data', 'Data name was not updated.');
            % testCase.verifyEqual(dataNode.n.intensity, 2.34, 'Data intensity was not updated.');
            testCase.verifyEqual(dataNode.n.measurement, 'value', 'Data measurement should not have changed.');
            testCase.verifyEqual(dataNode.n.submodality, 'func', 'Data submodality was not updated.');
        end
        
        function testDeleteData(testCase)
            % Clean up any existing node
            data = Data(testCase.graphconn, 'data_id_test', 'session_id_test', 'MRI Data', 'anat', 'intensity', 1.23, 'measurement', 'value');
            data.delete('data_id_test'); % Ensure clean state
            
            % Create related session node
            executeCypher(testCase.graphconn, 'MERGE (s:Session {id: "session_id_test", participantId: "participant_id_test", name: "Test Session"})');
            
            data.create();
            data.delete('data_id_test');
            result = executeCypher(testCase.graphconn, 'MATCH (d:Data {id: "data_id_test"}) RETURN d');
            testCase.verifyEmpty(result.d, 'Data node was not deleted.');
            
            % Verify the relationship is deleted
            relResult = executeCypher(testCase.graphconn, 'MATCH (s:Session {id: "session_id_test"})-[r:HAS_DATA]->(d:Data {id: "data_id_test"}) RETURN r');
            testCase.verifyEmpty(relResult, 'Data relationship was not deleted.');
        end
    end
end
