classdef TestData < TestBase
    methods(Test)
        function testCreateData(testCase)
            data = Data(testCase.graphconn, 'data_id_test', 'session_id_test', 'Structural MRI');
            data.create();
            result = fetch(testCase.graphconn, 'MATCH (d:Data {id: "data_id_test"}) RETURN d');
            testCase.verifyNotEmpty(result, 'Data node was not created.');
        end
        
        function testReadData(testCase)
            data = Data(testCase.graphconn, 'data_id_test', 'session_id_test', 'Structural MRI');
            data.create();
            dataNode = data.read('data_id_test');
            testCase.verifyEqual(dataNode.type, 'Structural MRI', 'Data type does not match.');
        end
        
        function testUpdateData(testCase)
            data = Data(testCase.graphconn, 'data_id_test', 'session_id_test', 'Structural MRI');
            data.create();
            data.update('data_id_test', struct('type', 'Functional MRI'));
            dataNode = data.read('data_id_test');
            testCase.verifyEqual(dataNode.type, 'Functional MRI', 'Data type was not updated.');
        end
        
        function testDeleteData(testCase)
            data = Data(testCase.graphconn, 'data_id_test', 'session_id_test', 'Structural MRI');
            data.create();
            data.delete('data_id_test');
            result = fetch(testCase.graphconn, 'MATCH (d:Data {id: "data_id_test"}) RETURN d');
            testCase.verifyEmpty(result, 'Data node was not deleted.');
        end
    end
end
