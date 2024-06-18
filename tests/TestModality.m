classdef TestModality < TestBase
    methods(TestMethodSetup)
        function setup(testCase)
            % Ensure the node does not exist before each test
            executeCypher(testCase.graphconn, 'MATCH (m:Modality {id: "modality_id_test"}) DETACH DELETE m');
            executeCypher(testCase.graphconn, 'MATCH (d:Dataset {id: "dataset_id_test"}) DETACH DELETE d');
            
            % Create a dataset node for testing
            dataset = Dataset(testCase.graphconn, 'dataset_id_test', 'Brain Health Study');
            dataset.create();
        end
    end
    
    methods(Test)
        function testCreateModality(testCase)
            modality = Modality(testCase.graphconn, 'modality_id_test', 'dataset_id_test', 'MRI');
            modality.create();
            result = executeCypher(testCase.graphconn, 'MATCH (m:Modality {id: "modality_id_test"}) RETURN m');
            testCase.verifyNotEmpty(result.m, 'Modality node was not created.');
        end
        
        function testReadModality(testCase)
            modality = Modality(testCase.graphconn, 'modality_id_test', 'dataset_id_test', 'MRI');
            modality.create();
            modalityNode = modality.read('modality_id_test');
            testCase.verifyEqual(modalityNode.n.name, 'MRI', 'Modality name does not match.');
        end
        
        function testUpdateModality(testCase)
            modality = Modality(testCase.graphconn, 'modality_id_test', 'dataset_id_test', 'MRI');
            modality.create();
            modality.update('modality_id_test', struct('name', 'Updated MRI'));
            modalityNode = modality.read('modality_id_test');
            testCase.verifyEqual(modalityNode.n.name, 'Updated MRI', 'Modality name was not updated.');
        end
        
        function testDeleteModality(testCase)
            modality = Modality(testCase.graphconn, 'modality_id_test', 'dataset_id_test', 'MRI');
            modality.create();
            modality.delete('modality_id_test');
            result = executeCypher(testCase.graphconn, 'MATCH (m:Modality {id: "modality_id_test"}) RETURN m');
            testCase.verifyEmpty(result.m, 'Modality node was not deleted.');
        end
    end
end
