classdef TestParticipant < TestBase
    methods(Test)
        function testCreateParticipant(testCase)
            % Clean up any existing node
            participant = Participant(testCase.graphconn, 'participant_id_test', 'modality_id_test', 'derivatives_id_test', 'John Doe');
            participant.delete('participant_id_test'); % Ensure clean state
            
            participant.create();
            result = executeCypher(testCase.graphconn, 'MATCH (p:Participant {id: "participant_id_test"}) RETURN p');
            testCase.verifyNotEmpty(result.p, 'Participant node was not created.');
        end
        
        function testReadParticipant(testCase)
            % Clean up any existing node
            participant = Participant(testCase.graphconn, 'participant_id_test', 'modality_id_test', 'derivatives_id_test', 'John Doe');
            participant.delete('participant_id_test'); % Ensure clean state
            
            participant.create();
            participantNode = participant.read('participant_id_test');
            testCase.verifyEqual(participantNode.n.name, 'John Doe', 'Participant name does not match.');
        end
        
        function testUpdateParticipant(testCase)
            % Clean up any existing node
            participant = Participant(testCase.graphconn, 'participant_id_test', 'modality_id_test', 'derivatives_id_test', 'John Doe');
            participant.delete('participant_id_test'); % Ensure clean state
            
            participant.create();
            participant.update('participant_id_test', struct('name', 'Jane Doe'));
            participantNode = participant.read('participant_id_test');
            testCase.verifyEqual(participantNode.n.name, 'Jane Doe', 'Participant name was not updated.');
        end
        
        function testDeleteParticipant(testCase)
            % Clean up any existing node
            participant = Participant(testCase.graphconn, 'participant_id_test', 'modality_id_test', 'derivatives_id_test', 'John Doe');
            participant.delete('participant_id_test'); % Ensure clean state
            
            participant.create();
            participant.delete('participant_id_test');
            result = executeCypher(testCase.graphconn, 'MATCH (p:Participant {id: "participant_id_test"}) RETURN p');
            testCase.verifyEmpty(result.p, 'Participant node was not deleted.');
        end
        

    end
end