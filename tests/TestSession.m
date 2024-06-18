classdef TestSession < TestBase
    methods(Test)
        function testCreateSession(testCase)
            session = Session(testCase.graphconn, 'session_id_test', 'participant_id_test', 'Baseline');
            session.create();
            result = fetch(testCase.graphconn, 'MATCH (s:Session {id: "session_id_test"}) RETURN s');
            testCase.verifyNotEmpty(result, 'Session node was not created.');
        end
        
        function testReadSession(testCase)
            session = Session(testCase.graphconn, 'session_id_test', 'participant_id_test', 'Baseline');
            session.create();
            sessionNode = session.read('session_id_test');
            testCase.verifyEqual(sessionNode.name, 'Baseline', 'Session name does not match.');
        end
        
        function testUpdateSession(testCase)
            session = Session(testCase.graphconn, 'session_id_test', 'participant_id_test', 'Baseline');
            session.create();
            session.update('session_id_test', struct('name', 'Follow-up'));
            sessionNode = session.read('session_id_test');
            testCase.verifyEqual(sessionNode.name, 'Follow-up', 'Session name was not updated.');
        end
        
        function testDeleteSession(testCase)
            session = Session(testCase.graphconn, 'session_id_test', 'participant_id_test', 'Baseline');
            session.create();
            session.delete('session_id_test');
            result = fetch(testCase.graphconn, 'MATCH (s:Session {id: "session_id_test"}) RETURN s');
            testCase.verifyEmpty(result, 'Session node was not deleted.');
        end
    end
end
