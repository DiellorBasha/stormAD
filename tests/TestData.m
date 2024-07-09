classdef TestData < TestBase
    properties (TestParameter)
        dataName = {'MRI Data', 'CT Data', 'EEG Data'};
        submodality = {'anat', 'func', 'spect'};
        intensity = {1.23, 2.34, 3.45};
        measurement = {'value1', 'value2', 'value3'};
        updatedDataName = {'Updated MRI Data', 'Updated CT Data', 'Updated EEG Data'};
        updatedIntensity = {4.56, 5.67, 6.78};
        updatedSubmodality = {'updated_anat', 'updated_func', 'updated_spect'};
    end
    
    properties (MethodSetupParameter)
        dataId = {'data_id_test1', 'data_id_test2', 'data_id_test3'};
        sessionId = {'session_id_test1', 'session_id_test2', 'session_id_test3'};
        participantId = {'participant_id_test1', 'participant_id_test2', 'participant_id_test3'};
    end

    methods(TestMethodSetup)
        function setup(testCase, dataId, sessionId, participantId)
            % Ensure the node does not exist before each test
            executeCypher(testCase.graphconn, sprintf('MATCH (d:Data {id: "%s"}) DETACH DELETE d', dataId));
            executeCypher(testCase.graphconn, sprintf('MATCH (s:Session {id: "%s"}) DETACH DELETE s', sessionId));
            executeCypher(testCase.graphconn, sprintf('MATCH (p:Participant {id: "%s"}) DETACH DELETE p', participantId));
            
            % Create related session and participant nodes for testing
            participant = Participant(testCase.graphconn, participantId, 'modality_id_test', 'derivatives_id_test', 'John Doe');
            participant.create();
            session = Session(testCase.graphconn, sessionId, participantId, 'Test Session');
            session.create();
        end
    end
    
    methods(Test)
        function testCreateData(testCase, dataId, sessionId, dataName, submodality, intensity, measurement)
            data = Data(testCase.graphconn, dataId, sessionId, dataName, submodality, 'intensity', intensity, 'measurement', measurement);
            data.create();
            result = executeCypher(testCase.graphconn, sprintf('MATCH (d:Data {id: "%s"}) RETURN d', dataId));
            testCase.verifyNotEmpty(result.d, 'Data node was not created.');
            testCase.verifyEqual(result.d.name, dataName, 'Data name does not match.');
            testCase.verifyEqual(result.d.intensity, intensity, 'Data intensity does not match.');
            testCase.verifyEqual(result.d.measurement, measurement, 'Data measurement does not match.');
            
            % Verify the submodality property in the relationship
            relResult = executeCypher(testCase.graphconn, sprintf('MATCH (s:Session {id: "%s"})-[r:HAS_DATA]->(d:Data {id: "%s"}) RETURN r', sessionId, dataId));
            testCase.verifyEqual(relResult.r.submodality, submodality, 'Data submodality does not match.');
        end
        
        function testReadData(testCase, dataId, sessionId, dataName, submodality, intensity, measurement)
            data = Data(testCase.graphconn, dataId, sessionId, dataName, submodality, 'intensity', intensity, 'measurement', measurement);
            data.create();
            dataNode = data.read(dataId);
            testCase.verifyEqual(dataNode.n.name, dataName, 'Data name does not match.');
            testCase.verifyEqual(dataNode.n.intensity, intensity, 'Data intensity does not match.');
            testCase.verifyEqual(dataNode.n.measurement, measurement, 'Data measurement does not match.');
            testCase.verifyEqual(data.submodality, submodality, 'Data submodality does not match.');
        end
        
        function testUpdateData(testCase, dataId, sessionId, dataName, submodality, intensity, measurement, updatedDataName, updatedIntensity, updatedSubmodality)
            data = Data(testCase.graphconn, dataId, sessionId, dataName, submodality, 'intensity', intensity, 'measurement', measurement);
            data.create();
            data.update(dataId, struct('name', updatedDataName, 'intensity', updatedIntensity, 'submodality', updatedSubmodality));
            dataNode = data.read(dataId);
            testCase.verifyEqual(dataNode.n.name, updatedDataName, 'Data name was not updated.');
            testCase.verifyEqual(dataNode.n.intensity, updatedIntensity, 'Data intensity was not updated.');
            testCase.verifyEqual(dataNode.n.measurement, measurement, 'Data measurement should not have changed.');
            testCase.verifyEqual(dataNode.n.submodality, updatedSubmodality, 'Data submodality was not updated.');
        end
        
        function testDeleteData(testCase, dataId, sessionId, dataName, submodality, intensity, measurement)
            data = Data(testCase.graphconn, dataId, sessionId, dataName, submodality, 'intensity', intensity, 'measurement', measurement);
            data.create();
            data.delete(dataId);
            result = executeCypher(testCase.graphconn, sprintf('MATCH (d:Data {id: "%s"}) RETURN d', dataId));
            testCase.verifyEmpty(result.d, 'Data node was not deleted.');
            
            % Verify the relationship is deleted
            relResult = executeCypher(testCase.graphconn, sprintf('MATCH (s:Session {id: "%s"})-[r:HAS_DATA]->(d:Data {id: "%s"}) RETURN r', sessionId, dataId));
            testCase.verifyEmpty(relResult, 'Data relationship was not deleted.');
        end
    end
end
