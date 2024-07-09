classdef TestParticipant < TestBase
    properties (TestParameter)
        modalityId = {'modality_id_test1', 'modality_id_test2', 'modality_id_test3'};
        derivativesId = {'derivatives_id_test1', 'derivatives_id_test2', 'derivatives_id_test3'};
        participantName = {'John Doe', 'Jane Doe', 'Alex Smith'};
        updatedParticipantName = {'Updated John Doe', 'Updated Jane Doe', 'Updated Alex Smith'};
    end
    
    properties (MethodSetupParameter)
        participantId = {'participant_id_test1', 'participant_id_test2', 'participant_id_test3'};
    end

    methods(TestMethodSetup)
        function setup(testCase, participantId)
            % Ensure the node does not exist before each test
            executeCypher(testCase.graphconn, sprintf('MATCH (p:Participant {id: "%s"}) DETACH DELETE p', participantId));
        end
    end
    
    methods(Test)
        function testCreateParticipant(testCase, participantId, modalityId, derivativesId, participantName)
            participant = Participant(testCase.graphconn, participantId, modalityId, derivativesId, participantName);
            participant.create();
            result = executeCypher(testCase.graphconn, sprintf('MATCH (p:Participant {id: "%s"}) RETURN p', participantId));
            testCase.verifyNotEmpty(result.p, 'Participant node was not created.');
        end
        
        function testReadParticipant(testCase, participantId, modalityId, derivativesId, participantName)
            participant = Participant(testCase.graphconn, participantId, modalityId, derivativesId, participantName);
            participant.create();
            participantNode = participant.read(participantId);
            testCase.verifyEqual(participantNode.n.name, participantName, 'Participant name does not match.');
        end
        
        function testUpdateParticipant(testCase, participantId, modalityId, derivativesId, participantName, updatedParticipantName)
            participant = Participant(testCase.graphconn, participantId, modalityId, derivativesId, participantName);
            participant.create();
            participant.update(participantId, struct('name', updatedParticipantName));
            participantNode = participant.read(participantId);
            testCase.verifyEqual(participantNode.n.name, updatedParticipantName, 'Participant name was not updated.');
        end
        
        function testDeleteParticipant(testCase, participantId, modalityId, derivativesId, participantName)
            participant = Participant(testCase.graphconn, participantId, modalityId, derivativesId, participantName);
            participant.create();
            participant.delete(participantId);
            result = executeCypher(testCase.graphconn, sprintf('MATCH (p:Participant {id: "%s"}) RETURN p', participantId));
            testCase.verifyEmpty(result.p, 'Participant node was not deleted.');
        end
    end
end
