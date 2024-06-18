classdef Session < StormBase
    properties
        session_id
        participant_id
        name
    end
    
    methods
        function obj = Session(graphconn, session_id, participant_id, name)
            obj@StormBase(graphconn);
            obj.session_id = session_id;
            obj.participant_id = participant_id;
            obj.name = name;
        end
        
        function create(obj)
            properties = struct('id', obj.session_id, 'participantId', obj.participant_id, 'name', obj.name);
            if ~obj.nodeExists('Session', properties)
                obj.createNode('Session', properties);
                obj.createRelationship('Participant', obj.participant_id, 'HAS_SESSION', 'Session', obj.session_id, struct());
            else
                error('Session with id %s already exists.', obj.session_id);
            end
        end
        
        function node = read(obj, id)
            node = obj.readNode('Session', id);
        end
        
        function update(obj, id, properties)
            obj.updateNode('Session', id, properties);
        end
        
        function delete(obj, id)
            obj.deleteRelationship('Participant', obj.participant_id, 'HAS_SESSION', 'Session', id);
            obj.deleteNode('Session', id);
        end
    end
end
