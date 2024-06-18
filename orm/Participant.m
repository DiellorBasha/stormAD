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
                obj.createRelationship('Modality', obj.modality_id, 'HAS_PARTICIPANT', 'Participant', obj.participant_id, struct());
                obj.createRelationship('Derivatives', obj.derivatives_id, 'HAS_PARTICIPANT', 'Participant', obj.participant_id, struct());
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
            deleteRelationship(obj, 'Modality', obj.modality_id, 'HAS_PARTICIPANT', 'Participant', id);
            deleteRelationship(obj, 'Derivatives', obj.derivatives_id, 'HAS_PARTICIPANT', 'Participant', id);
            deleteNode(obj, 'Participant', id);
        end
        
        function bulkCreate(obj, participants)
            for i = 1:numel(participants)
                participant = participants(i);
                properties = struct('id', participant.participant_id, 'modalityId', participant.modality_id, 'derivativesId', participant.derivatives_id, 'name', participant.name);
                if ~nodeExists(obj, 'Participant', properties)
                    createNode(obj, 'Participant', properties);
                    obj.createRelationship('Modality', participant.modality_id, 'HAS_PARTICIPANT', 'Participant', participant.participant_id, struct());
                    obj.createRelationship('Derivatives', participant.derivatives_id, 'HAS_PARTICIPANT', 'Participant', participant.participant_id, struct());
                else
                    warning('Participant with ID %s already exists.', participant.participant_id);
                end
            end
        end
    end
end
