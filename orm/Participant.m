classdef Participant < StormBase
    properties
        participant_id
        modality_id
        derivatives_id
        name
    end
    
    methods
        function obj = Participant(graphconn, participant_id, modality_id, derivatives_id, name)
            obj@StormBase(graphconn);
            obj.participant_id = participant_id;
            obj.modality_id = modality_id;
            obj.derivatives_id = derivatives_id;
            obj.name = name;
        end
        
        function create(obj)
            properties = struct('id', obj.participant_id, 'modalityId', obj.modality_id, 'derivativesId', obj.derivatives_id, 'name', obj.name);
            if ~nodeExists(obj, 'Participant', properties)
                createNode(obj, 'Participant', properties);
            else
                warning('Participant with ID %s already exists.', obj.participant_id);
            end
        end
        
        function participant = read(obj, id)
            participant = readNode(obj, 'Participant', id);
        end
        
        function update(obj, id, properties)
            updateNode(obj, 'Participant', id, properties);
        end
        
        function delete(obj, id)
            deleteNode(obj, 'Participant', id);
        end
        
        function bulkCreate(obj, participants)
            for i = 1:numel(participants)
                participant = participants(i);
                properties = struct('id', participant.participant_id, 'modalityId', participant.modality_id, 'derivativesId', participant.derivatives_id, 'name', participant.name);
                if ~nodeExists(obj, 'Participant', properties)
                    createNode(obj, 'Participant', properties);
                else
                    warning('Participant with ID %s already exists.', participant.participant_id);
                end
            end
        end
        
        function createSessionRelationship(obj, session)
            % Ensure the session exists
            sessionProps = struct('id', session.session_id, 'participantId', obj.participant_id, 'name', session.name);
            if ~nodeExists(session, 'Session', sessionProps)
                error('Session with ID %s does not exist.', session.session_id);
            end
            
            % Create the relationship with the session_id property
            query = sprintf('MATCH (p:Participant {id: "%s"}), (s:Session {id: "%s"}) CREATE (p)-[:HAS_SESSION {session_id: "%s"}]->(s)', ...
                            obj.participant_id, session.session_id, session.session_id);
            executeCypher(obj.graphconn, query);
        end
    end
end
