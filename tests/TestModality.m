classdef TestModality < TestBase
    methods(Test)
        function testCreateModality(testCase)
            modality = Modality(testCase.graphconn, 'modality_id_test', 'dataset_id_test', 'MRI');
            modality.create();
            result = fetch(testCase.graphconn, 'MATCH (m:Modality {id: "modality_id_test"}) RETURN m');
            testCase.verifyNotEmpty(result, 'Modality node was not created.');
        end
        
        function testReadModality(testCase)
            modality = Modality(testCase.graphconn, 'modality_id_test', 'dataset_id_test', 'MRI');
            modality.create();
            modalityNode = modality.read('modality_id_test');
            testCase.verifyEqual(modalityNode.name, 'MRI', 'Modality name does not match.');
        end
        
        function testUpdateModality(testCase)
            modality = Modality(testCase.graphconn, 'modality_id_test', 'dataset_id_test', 'MRI');
            modality.create();
            modality.update('modality_id_test', struct('name', 'Updated MRI'));
            modalityNode = modality.read('modality_id_test');
            testCase.verifyEqual(modalityNode.name, 'Updated MRI', 'Modality name was not updated.');
        end
        
        function testDeleteModality(testCase)
            modality = Modality(testCase.graphconn, 'modality_id_test', 'dataset_id_test', 'MRI');
            modality.create();
            modality.delete('modality_id_test');
            result = fetch(testCase.graphconn, 'MATCH (m:Modality {id: "modality_id_test"}) RETURN m');
            testCase.verifyEmpty(result, 'Modality node was not deleted.');
        end
    end
end
