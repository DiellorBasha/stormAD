classdef TestDataset < TestBase
    methods(Test)
        function testCreateDataset(testCase)
            dataset = Dataset(testCase.graphconn, 'dataset_id_test', 'Brain Health Study');
            dataset.create();
            result = fetch(testCase.graphconn, 'MATCH (d:Dataset {id: "dataset_id_test"}) RETURN d');
            testCase.verifyNotEmpty(result, 'Dataset node was not created.');
        end
        
        function testReadDataset(testCase)
            dataset = Dataset(testCase.graphconn, 'dataset_id_test', 'Brain Health Study');
            dataset.create();
            datasetNode = dataset.read('dataset_id_test');
            testCase.verifyEqual(datasetNode.name, 'Brain Health Study', 'Dataset name does not match.');
        end
        
        function testUpdateDataset(testCase)
            dataset = Dataset(testCase.graphconn, 'dataset_id_test', 'Brain Health Study');
            dataset.create();
            dataset.update('dataset_id_test', struct('name', 'Updated Study'));
            datasetNode = dataset.read('dataset_id_test');
            testCase.verifyEqual(datasetNode.name, 'Updated Study', 'Dataset name was not updated.');
        end
        
        function testDeleteDataset(testCase)
            dataset = Dataset(testCase.graphconn, 'dataset_id_test', 'Brain Health Study');
            dataset.create();
            dataset.delete('dataset_id_test');
            result = fetch(testCase.graphconn, 'MATCH (d:Dataset {id: "dataset_id_test"}) RETURN d');
            testCase.verifyEmpty(result, 'Dataset node was not deleted.');
        end
    end
end
