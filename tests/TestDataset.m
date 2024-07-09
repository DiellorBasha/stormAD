classdef TestDataset < TestBase
    properties (TestParameter)
        datasetName = {'Brain Health Study 1', 'Brain Health Study 2', 'Brain Health Study 3'};
        updatedName = {'Updated Study 1', 'Updated Study 2', 'Updated Study 3'};
    end
    
    properties (MethodSetupParameter)
        datasetId = {'dataset_id_test1', 'dataset_id_test2', 'dataset_id_test3'};
    end

    methods(TestMethodSetup)
        function setup(testCase, datasetId)
            % Ensure the node does not exist before each test
            executeCypher(testCase.graphconn, sprintf('MATCH (d:Dataset {id: "%s"}) DETACH DELETE d', datasetId));
        end
    end
    
    methods(Test)
        function testCreateDataset(testCase, datasetId, datasetName)
            dataset = Dataset(testCase.graphconn, datasetId, datasetName);
            dataset.create();
            result = executeCypher(testCase.graphconn, sprintf('MATCH (d:Dataset {id: "%s"}) RETURN d', datasetId));
            testCase.verifyNotEmpty(result, 'Dataset node was not created.');
        end
        
        function testReadDataset(testCase, datasetId, datasetName)
            dataset = Dataset(testCase.graphconn, datasetId, datasetName);
            dataset.create();
            datasetNode = dataset.read(datasetId);
            testCase.verifyEqual(datasetNode.n.name, datasetName, 'Dataset name does not match.');
        end
        
        function testUpdateDataset(testCase, datasetId, datasetName, updatedName)
            dataset = Dataset(testCase.graphconn, datasetId, datasetName);
            dataset.create();
            dataset.update(datasetId, struct('name', updatedName));
            datasetNode = dataset.read(datasetId);
            testCase.verifyEqual(datasetNode.n.name, updatedName, 'Dataset name was not updated.');
        end
        
        function testDeleteDataset(testCase, datasetId, datasetName)
            dataset = Dataset(testCase.graphconn, datasetId, datasetName);
            dataset.create();
            dataset.delete(datasetId);
            result = executeCypher(testCase.graphconn, sprintf('MATCH (d:Dataset {id: "%s"}) RETURN d', datasetId));
            testCase.verifyEmpty(result, 'Dataset node was not deleted.');
        end
    end
end
