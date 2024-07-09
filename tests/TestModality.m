classdef TestModality < TestBase
    properties (TestParameter)
        modalityName = {'MRI', 'fMRI', 'PET'};
        updatedModalityName = {'Updated MRI', 'Updated fMRI', 'Updated PET'};
    end
    
    properties (MethodSetupParameter)
        modalityId = {'modality_id_test1', 'modality_id_test2', 'modality_id_test3'};
        datasetId = {'dataset_id_test1', 'dataset_id_test2', 'dataset_id_test3'};
    end

    methods(TestMethodSetup)
        function setup(testCase, datasetId, modalityId)
            % Ensure the node does not exist before each test
            executeCypher(testCase.graphconn, sprintf('MATCH (m:Modality {id: "%s"}) DETACH DELETE m', modalityId));
            executeCypher(testCase.graphconn, sprintf('MATCH (d:Dataset {id: "%s"}) DETACH DELETE d', datasetId));
            
            % Create a dataset node for testing
            dataset = Dataset(testCase.graphconn, datasetId, 'Brain Health Study');
            dataset.create();
        end
    end
    
    methods(Test)
        function testCreateModality(testCase, modalityId, datasetId, modalityName)
            modality = Modality(testCase.graphconn, modalityId, datasetId, modalityName);
            modality.create();
            result = executeCypher(testCase.graphconn, sprintf('MATCH (m:Modality {id: "%s"}) RETURN m', modalityId));
            testCase.verifyNotEmpty(result.m, 'Modality node was not created.');
        end
        
        function testReadModality(testCase, modalityId, datasetId, modalityName)
            modality = Modality(testCase.graphconn, modalityId, datasetId, modalityName);
            modality.create();
            modalityNode = modality.read(modalityId);
            testCase.verifyEqual(modalityNode.n.name, modalityName, 'Modality name does not match.');
        end
        
        function testUpdateModality(testCase, modalityId, datasetId, modalityName, updatedModalityName)
            modality = Modality(testCase.graphconn, modalityId, datasetId, modalityName);
            modality.create();
            modality.update(modalityId, struct('name', updatedModalityName));
            modalityNode = modality.read(modalityId);
            testCase.verifyEqual(modalityNode.n.name, updatedModalityName, 'Modality name was not updated.');
        end
        
        function testDeleteModality(testCase, modalityId, datasetId, modalityName)
            modality = Modality(testCase.graphconn, modalityId, datasetId, modalityName);
            modality.create();
            modality.delete(modalityId);
            result = executeCypher(testCase.graphconn, sprintf('MATCH (m:Modality {id: "%s"}) RETURN m', modalityId));
            testCase.verifyEmpty(result.m, 'Modality node was not deleted.');
        end
    end
end
