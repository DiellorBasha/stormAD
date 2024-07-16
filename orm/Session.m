classdef Session < Subject
    properties
        session_id
        session_name % Use session_name to avoid conflict with the inherited name property
        subject % An instance of the Subject class
    end
    
    methods
        function obj = Session(subject, session_id, session_name, path)
            if nargin < 4
                % If path is not provided, default to fullfile(Subject.path, session_name)
                path = fullfile(subject.path, session_name);
            end
            % Use the Subject instance to set graphconn and path
            obj@Subject(subject.datasets, subject.derivatives, subject.subject_id, subject.subject_name); % Call the parent constructor with Subject properties
            obj.session_id = session_id;
            obj.session_name = session_name;
            obj.subject = subject;
            obj.path = path; % Set the path property to the constructed path
        end
        
        function create(obj)
            properties = struct('id', obj.session_id, 'subjectId', obj.subject_id, 'name', obj.session_name);
            if ~obj.nodeExists('Session', properties)
                obj.createNode('Session', properties);
                obj.createRelationship('Subject', obj.subject_id, 'HAS_SESSION', 'Session', obj.session_id, struct());
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
            obj.deleteRelationship('Subject', obj.subject_id, 'HAS_SESSION', 'Session', id);
            obj.deleteNode('Session', id);
        end
    end
end
