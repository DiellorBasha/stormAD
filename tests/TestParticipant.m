classdef TestParticipant < TestBase
    methods(Test)
        function testCreateParticipant(testCase)
            participant = Participant(testCase.graphconn, 'participant_id_test', 'modality_id_test', '', 'John Doe');
            participant.create();
            result = executeCypher(testCase.graphconn, 'MATCH (p:Participant {id: "participant_id_test"}) RETURN p');
            testCase.verifyNotEmpty(result.p, 'Participant node was not created.');
        end
        
        function testReadParticipant(testCase)
            participant = Participant(testCase.graphconn, 'participant_id_test', 'modality_id_test', '', 'John Doe');
            participant.create();
            participantNode = participant.read('participant_id_test');
            testCase.verifyEqual(participantNode.n.name, 'John Doe', 'Participant name does not match.');
        end
        
        function testUpdateParticipant(testCase)
            participant = Participant(testCase.graphconn, 'participant_id_test', 'modality_id_test', '', 'John Doe');
            participant.create();
            participant.update('participant_id_test', struct('name', 'Jane Doe'));
            participantNode = participant.read('participant_id_test');
            testCase.verifyEqual(participantNode.n.name, 'Jane Doe', 'Participant name was not updated.');
        end
        
        function testDeleteParticipant(testCase)
            participant = Participant(testCase.graphconn, 'participant_id_test', 'modality_id_test', '', 'John Doe');
            participant.create();
            participant.delete('participant_id_test');
            result = executeCypher(testCase.graphconn, 'MATCH (p:Participant {id: "participant_id_test"}) RETURN p');
            testCase.verifyEmpty(result.p, 'Participant node was not deleted.');
        end
        
        function testCreateSessionRelationship(testCase)
            participant = Participant(testCase.graphconn, 'participant_id_test', 'modality_id_test', '', 'John Doe');
            participant.create();
            session = Session(testCase.graphconn, 'session_id_test', 'participant_id_test', 'Baseline');
            session.create();
            participant.createSessionRelationship(session);
            result = executeCypher(testCase.graphconn, 'MATCH (p:Participant {id: "participant_id_test"})-[:HAS_SESSION]->(s:Session {id: "session_id_test"}) RETURN s');
            testCase.verifyNotEmpty(result.s, 'Session relationship was not created.');
        end
    end
end
