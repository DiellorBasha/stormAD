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
            if ~nodeExists(obj, 'Session', properties)
                createNode(obj, 'Session', properties);
            else
                warning('Session with ID %s already exists.', obj.session_id);
            end
        end
        
        function session = read(obj, id)
            session = readNode(obj, 'Session', id);
        end
        
        function update(obj, id, properties)
            updateNode(obj, 'Session', id, properties);
        end
        
        function delete(obj, id)
            deleteNode(obj, 'Session', id);
        end
    end
end
