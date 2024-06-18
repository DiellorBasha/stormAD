classdef TestDerivatives < TestBase
    methods(TestMethodSetup)
        function setup(testCase)
            % Ensure the nodes do not exist before each test
            executeCypher(testCase.graphconn, 'MATCH (d:Derivatives {id: "derivatives_id_test"}) DETACH DELETE d');
            executeCypher(testCase.graphconn, 'MATCH (m:Modality {id: "modality_id_test"}) DETACH DELETE m');
            
            % Create a modality node for testing
            modality = Modality(testCase.graphconn, 'modality_id_test', 'dataset_id_test', 'MRI');
            modality.create();
        end
    end
    
    methods(Test)
        function testCreateDerivatives(testCase)
            derivatives = Derivatives(testCase.graphconn, 'derivatives_id_test', 'modality_id_test', 'Analysis 1');
            derivatives.create();
            result = executeCypher(testCase.graphconn, 'MATCH (d:Derivatives {id: "derivatives_id_test"}) RETURN d');
            testCase.verifyNotEmpty(result.d, 'Derivatives node was not created.');
        end
        
        function testReadDerivatives(testCase)
            derivatives = Derivatives(testCase.graphconn, 'derivatives_id_test', 'modality_id_test', 'Analysis 1');
            derivatives.create();
            derivativesNode = derivatives.read('derivatives_id_test');
            testCase.verifyEqual(derivativesNode.n.name, 'Analysis 1', 'Derivatives name does not match.');
        end
        
        function testUpdateDerivatives(testCase)
            derivatives = Derivatives(testCase.graphconn, 'derivatives_id_test', 'modality_id_test', 'Analysis 1');
            derivatives.create();
            derivatives.update('derivatives_id_test', struct('name', 'Updated Analysis'));
            derivativesNode = derivatives.read('derivatives_id_test');
            testCase.verifyEqual(derivativesNode.n.name, 'Updated Analysis', 'Derivatives name was not updated.');
        end
        
        function testDeleteDerivatives(testCase)
            derivatives = Derivatives(testCase.graphconn, 'derivatives_id_test', 'modality_id_test', 'Analysis 1');
            derivatives.create();
            derivatives.delete('derivatives_id_test');
            result = executeCypher(testCase.graphconn, 'MATCH (d:Derivatives {id: "derivatives_id_test"}) RETURN d');
            testCase.verifyEmpty(result.d, 'Derivatives node was not deleted.');
        end
    end
end
