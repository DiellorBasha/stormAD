classdef TestTask < TestBase
    properties (TestParameter)
        taskName = {'Test Task 1', 'Test Task 2', 'Test Task 3'};
        updatedTaskName = {'Updated Task 1', 'Updated Task 2', 'Updated Task 3'};
    end
    
    properties (MethodSetupParameter)
        taskId = {'task_id_test1', 'task_id_test2', 'task_id_test3'};
        dataId = {'data_id_test1', 'data_id_test2', 'data_id_test3'};
        sessionId = {'session_id_test1', 'session_id_test2', 'session_id_test3'};
    end

    methods(TestMethodSetup)
        function setup(testCase, taskId, dataId, sessionId)
            % Ensure the node does not exist before each test
            executeCypher(testCase.graphconn, sprintf('MATCH (t:Task {id: "%s"}) DETACH DELETE t', taskId));
            executeCypher(testCase.graphconn, sprintf('MATCH (d:Data {id: "%s"}) DETACH DELETE d', dataId));
            executeCypher(testCase.graphconn, sprintf('MATCH (s:Session {id: "%s"}) DETACH DELETE s', sessionId));
            
            % Create related session and data nodes for testing
            participantId = 'participant_id_test';
            participant = Participant(testCase.graphconn, participantId, 'modality_id_test', 'derivatives_id_test', 'John Doe');
            participant.create();
            session = Session(testCase.graphconn, sessionId, participantId, 'Test Session');
            session.create();
            data = Data(testCase.graphconn, dataId, sessionId, 'Test Data', 'anat', 'intensity', 1.23, 'measurement', 'value');
            data.create();
        end
    end
    
    methods(Test)
        function testCreateTask(testCase, taskId, dataId, taskName)
            task = Task(testCase.graphconn, taskId, dataId, taskName);
            task.create();
            result = executeCypher(testCase.graphconn, sprintf('MATCH (t:Task {id: "%s"}) RETURN t', taskId));
            testCase.verifyNotEmpty(result.t, 'Task node was not created.');
            testCase.verifyEqual(result.t.name, taskName, 'Task name does not match.');
            
            % Verify the HAS_TASK relationship
            relResult = executeCypher(testCase.graphconn, sprintf('MATCH (d:Data {id: "%s"})-[r:HAS_TASK]->(t:Task {id: "%s"}) RETURN r', dataId, taskId));
            testCase.verifyNotEmpty(relResult, 'HAS_TASK relationship was not created.');
        end
        
        function testReadTask(testCase, taskId, dataId, taskName)
            task = Task(testCase.graphconn, taskId, dataId, taskName);
            task.create();
            taskNode = task.read(taskId);
            testCase.verifyEqual(taskNode.n.name, taskName, 'Task name does not match.');
        end
        
        function testUpdateTask(testCase, taskId, dataId, taskName, updatedTaskName)
            task = Task(testCase.graphconn, taskId, dataId, taskName);
            task.create();
            task.update(taskId, struct('name', updatedTaskName));
            taskNode = task.read(taskId);
            testCase.verifyEqual(taskNode.n.name, updatedTaskName, 'Task name was not updated.');
        end
        
        function testDeleteTask(testCase, taskId, dataId, taskName)
            task = Task(testCase.graphconn, taskId, dataId, taskName);
            task.create();
            task.delete(taskId);
            result = executeCypher(testCase.graphconn, sprintf('MATCH (t:Task {id: "%s"}) RETURN t', taskId));
            testCase.verifyEmpty(result.t, 'Task node was not deleted.');
            
            % Verify the relationship is deleted
            relResult = executeCypher(testCase.graphconn, sprintf('MATCH (d:Data {id: "%s"})-[r:HAS_TASK]->(t:Task {id: "%s"}) RETURN r', dataId, taskId));
            testCase.verifyEmpty(relResult, 'HAS_TASK relationship was not deleted.');
        end
    end
end
