classdef TestSession < TestBase
    properties (TestParameter)
        sessionName = {'Baseline', 'Initial', 'First'};
        updatedSessionName = {'Follow-up', 'Second', 'Final'};
    end
    
    properties (MethodSetupParameter)
        sessionId = {'session_id_test1', 'session_id_test2', 'session_id_test3'};
        participantId = {'participant_id_test1', 'participant_id_test2', 'participant_id_test3'};
    end

    methods(TestMethodSetup)
        function setup(testCase, sessionId, participantId)
            % Ensure the node does not exist before each test
            executeCypher(testCase.graphconn, sprintf('MATCH (s:Session {id: "%s"}) DETACH DELETE s', sessionId));
            executeCypher(testCase.graphconn, sprintf('MATCH (p:Participant {id: "%s"}) DETACH DELETE p', participantId));
            
            % Create a participant node for testing
            participant = Participant(testCase.graphconn, participantId, 'modality_id_test', 'derivatives_id_test', 'John Doe');
            participant.create();
        end
    end
    
    methods(Test)
        function testCreateSession(testCase, sessionId, participantId, sessionName)
            session = Session(testCase.graphconn, sessionId, participantId, sessionName);
            session.create();
            result = executeCypher(testCase.graphconn, sprintf('MATCH (s:Session {id: "%s"}) RETURN s', sessionId));
            testCase.verifyNotEmpty(result.s, 'Session node was not created.');
        end

        function testReadSession(testCase, sessionId, participantId, sessionName)
            session = Session(testCase.graphconn, sessionId, participantId, sessionName);
            session.create();
            sessionNode = session.read(sessionId);
            testCase.verifyEqual(sessionNode.n.name, sessionName, 'Session name does not match.');
        end

        function testUpdateSession(testCase, sessionId, participantId, sessionName, updatedSessionName)
            session = Session(testCase.graphconn, sessionId, participantId, sessionName);
            session.create();
            session.update(sessionId, struct('name', updatedSessionName));
            sessionNode = session.read(sessionId);
            testCase.verifyEqual(sessionNode.n.name, updatedSessionName, 'Session name was not updated.');
        end

        function testDeleteSession(testCase, sessionId, participantId, sessionName)
            session = Session(testCase.graphconn, sessionId, participantId, sessionName);
            session.create();
            session.delete(sessionId);
            result = executeCypher(testCase.graphconn, sprintf('MATCH (s:Session {id: "%s"}) RETURN s', sessionId));
            testCase.verifyEmpty(result.s, 'Session node was not deleted.');
        end
    end
end
