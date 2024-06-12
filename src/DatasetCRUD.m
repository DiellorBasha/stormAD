
% CRUD operations for dataset
    % create DATASET --> MODALITY --> DATA --> BRAIN ---> VERTEX
        % createNode
    % DATASET label with 3 nodes: MEG, PET, MRI, 
   bidsjson = bidsJSONPAD; 
    
   % Initialize an empty array to store the indices of matching rows
 matchingIndices = [];

% Iterate through the bidsjson struct array to find matching filenames
for k = 1:length(bidsjson)
    if strcmp(bidsjson(k).modality, '18Fflortaucipir')
        matchingIndices(end+1) = k; 
    end
end

datasetDescriptionPAD = bidsjson(matchingIndices); 
bidsjson(matchingIndices) = [];

bidsjson1 = bidsjson(matchingIndices);

label = 'Dataset';
properties = datasetDescriptionPAD(3).files;
% Create the node in the Neo4j database
DatasetNode =  createNode(neo4jconn, 'Labels', label, 'Properties', properties);
    %% 
    
    MEGDataset = bidsjson(1).files;
        MEGDatasetNode = createNode(neo4jconn, 'Properties', MEGDataset);
            
    MEGParticipants = bidsjson(1).files;
        MEGParticipantNode = createNode(neo4jconn, 'Properties', MEGParticipants);
        
    MRIDataset_w1 = bidsjson(5).files;
        MRIDatasetNode = createNode(neo4jconn, 'Properties', MRIDataset_w1);
    MRIDataset_w2 = bidsjson(23).files;
        MRIDatasetNode = createNode(neo4jconn, 'Properties', MRIDataset_w2);

    PETDataset = datasetDescriptionPAD(3).files;
        PETDatasetNode = createNode(neo4jconn, 'Properties', PETDataset);
    
    PETDerivativesDataset = datasetDescriptionPAD(4).files;
    PETDerivativesGeneratedby = PETDerivativesDataset.GeneratedBy; 
    PETDerivativesProp = rmfield(PETDerivativesDataset, "GeneratedBy");

        PETDerivativestNode = createNode(neo4jconn, 'Properties', PETDerivativesProp);
        PETDerivativestGenBy = createNode(neo4jconn, 'Properties', PETDerivativesGeneratedby);
        createRelation(neo4jconn, PETDatasetNode, PETDerivativestNode, 'GENERATED_BY');
    
participants = participantsPET; 

%createRelation for PARTICIPANTS
participantNodes = createNode(neo4jconn, 'Labels', 'Participant', 'Properties', participants) ;
participantNodesObjArray = participantNodes.NodeObject;



for k = 1:length(participantNodesObjArray);
DataSetNodeObjArray(k,1) = DatasetNode;
end

createRelation(neo4jconn,DataSetNodeObjArray,participantNodesObjArray,'HAS_PARTICIPANT');


for k = 1:length(participantNodesObjArray) 
MEGModality(k) = struct('participant_id', participantNodesObjArray(k, 1).NodeData.participant_id , 'modality', 'MEG');
MRIModality(k) = struct('participant_id', participantNodesObjArray(k, 1).NodeData.participant_id , 'modality', 'MR');
PETModality(k) = struct('participant_id', participantNodesObjArray(k, 1).NodeData.participant_id , 'modality', 'PET');
CogModality(k) = struct('participant_id', participantNodesObjArray(k, 1).NodeData.participant_id , 'modality', 'Cognitive');
SensoModality(k) = struct('participant_id', participantNodesObjArray(k, 1).NodeData.participant_id , 'modality', 'Sensorimotor');
HistoModality(k) = struct('participant_id', participantNodesObjArray(k, 1).NodeData.participant_id , 'modality', 'Histological');
MedModality(k) = struct('participant_id', participantNodesObjArray(k, 1).NodeData.participant_id , 'modality', 'Medical');
DemModality(k) = struct('participant_id', participantNodesObjArray(k, 1).NodeData.participant_id , 'modality', 'Demographic');
GenModality(k) = struct('participant_id', participantNodesObjArray(k, 1).NodeData.participant_id , 'modality', 'Genetic');
end
 
MRIModalityNode = createNode (neo4jconn, 'Labels', 'Modality', 'Properties', MRIModality);  
MRIModalityNodeArray = MRIModalityNode.NodeObject;
createRelation(neo4jconn,participantNodesObjArray, MRIModalityNodeArray, 'HAS_MODALITY');

PETModalityNode = createNode (neo4jconn, 'Labels', 'Modality', 'Properties', PETModality);  
PETModalityNodeArray = PETModalityNode.NodeObject;
createRelation(neo4jconn,participantNodesObjArray, PETModalityNodeArray, 'HAS_MODALITY');

CogModalityNode = createNode (neo4jconn, 'Labels', 'Modality', 'Properties', CogModality);  
CogModalityNodeArray = CogModalityNode.NodeObject;
createRelation(neo4jconn,participantNodesObjArray, CogModalityNodeArray, 'HAS_MODALITY');

SensoModalityNode = createNode (neo4jconn, 'Labels', 'Modality', 'Properties', SensoModality);  
SensoModalityNodeArray = SensoModalityNode.NodeObject;
createRelation(neo4jconn,participantNodesObjArray, SensoModalityNodeArray, 'HAS_MODALITY');

GenModalityNode = createNode (neo4jconn, 'Labels', 'Modality', 'Properties', GenModality);  
GenModalityNodeArray = GenModalityNode.NodeObject;
createRelation(neo4jconn,participantNodesObjArray, GenModalityNodeArray, 'HAS_MODALITY');


%% 
 % here add filepath for the data starting from /dataset/participant/filename.nii.gz 
 % relations should have properties describing workflow for derivatives
    % for MEG BIDS derivative: data -[FILTERED]-> filtered 
        % FILTERED properties should contain filter propidx 

 dataJSON = bidsjson(k).files;
 for k = 1:length(jsonFilesPAD)
 relativePaths(k) = extractRelativePaths(jsonFilesPAD(k), 'data_release_7.0');
 end

datasetDescriptionPADPath = relativePaths(matchingIndices); 
relativePaths(matchingIndices) = [];

dataProps = struct('submodality', {}, 'type', {}, 'participant_id', {}, 'task', {}, 'run', {}, 'tracer', {},...
    'visit', {}, 'JSONFilePath', {}, 'dataFilePath', {}, 'modality', {});

for k = 1:length(bidsjson)
    % Create struct for each entry
    dataProps(k).submodality = bidsjson(k).submodality;
    dataProps(k).type = bidsjson(k).type
    dataProps(k).participant_id = bidsjson(k).participant_id
    dataProps(k).task = bidsjson(k).task
    dataProps(k).run = bidsjson(k).run
    dataProps(k).trc = bidsjson(k).trc
    dataProps(k).visit = bidsjson(k).visit
    
    % Set JSONFilePath
    dataProps(k).JSONFilePath = relativePaths{k};
    
    % Replace .json with .nii.gz and set DataFilePath
    niftiFilePath = strrep(relativePaths{k}, '.json', '.nii.gz');
    dataProps(k).dataFilePath = niftiFilePath;

    dataProps(k).modality = bidsjson(k).modality;
end
 
DataNode = createNode (neo4jconn, 'Labels', 'Data', 'Properties', dataProps);  
DataNodeArray = DataNode.NodeObject;

% to do 172; 
%% 

for k = 1:length(DataNodeArray)
% Define the variables
searchPart = DataNodeArray(k, 1).NodeData.participant_id;
searchMod = DataNodeArray(k, 1).NodeData.modality;

a =searchNode (neo4jconn, 'Modality', "PropertyKey", "participant_id", "PropertyValue", searchPart);
        %     matchingRows = [];
        %     % Iterate through the rows of a.NodeData
        %     for row = 1:size(a.NodeData, 1)
        %         % Check if the modality field is equal to "MR"
        %         if isfield(a.NodeData{row, 1}, 'modality') && strcmp(a.NodeData{row, 1}.modality, 'MR')
        %             % If it matches, add the row index to matchingRows
        %             matchingRows(end+1) = row; %#ok<AGROW>
        %         end
        %     end
        % 
        % modNode = a.NodeObject(matchingRows); 
MRNode = a; 
createRelation (neo4jconn, MRNode, DataNodeArray(k, 1), 'HAS_DATA');

dataJSON = bidsjson(k).files;
dataJSONNode = createNode (neo4jconn, 'Labels', 'BIDS_JSON', 'Properties', dataJSON);
createRelation (neo4jconn, DataNodeArray(k, 1), dataJSONNode, 'HAS_BIDS');
end


%% 
for k = 1:length(missingInPET)
searchPart = missingInPET(k)
ap= createNode(neo4jconn, 'Labels', 'Participant', 'Properties', struct("participant_id", searchPart));
          % connect to PAD
            createRelation (neo4jconn, DatasetNode, ap, 'HAS_PARTICIPANT');

          % create modality nodes
          modals(1).modality = "MR";
          modals(1).participant_id = searchPart;
          modals(2).modality = "PET";
          modals(2).participant_id = searchPart;
          modals(3).modality = "MEG";
          modals(3).participant_id = searchPart;
          modals(4).modality = "Cognitive";
          modals(4).participant_id = searchPart;
          modals(5).modality = "SensoriMotor";
          modals(5).participant_id = searchPart;
          modals(6).modality = "Demographic";
          modals(6).participant_id = searchPart;
          modals(7).modality = "Genetic";
          modals(7).participant_id = searchPart;
          modals(8).modality = "Histological";
          modals(8).participant_id = searchPart;
          modals(9).modality = "Medical";
          modals(9).participant_id = searchPart;

       bM= createNode(neo4jconn, 'Labels', 'Modality', 'Properties', modals);
       bMnode = bM.NodeObject;
       for jj = 1:length(modals)
           aps(1,jj) = ap; 
       end
       createRelation (neo4jconn, aps, bMnode, 'HAS_MODALITY');
  
(disp('Written'))
end
%% 




dataNode = createNode (neo4jconn, 'Labels', 'Data', 'Properties', dataProps); 
        % data node should include filepaths to JSON and raw data
     dataJSONNode = createNode (neo4jconn, 'Labels', 'BIDS_JSON', 'Properties', dataJSON);

     createRelation (neo4jconn, MRIModality, dataNode, 'HAS_DATA');
     createRelation (neo4jconn, dataNode, dataJSONNode, 'HAS_BIDS');

%

%% 
% Iterate through the bidsjson struct array to find matching filenames
matchingIndices = [];
for k = 1:length(bidsjson)
    if strcmp(bidsjson(k).modality, 'PET')
        matchingIndices(end+1) = k; 
    end
end


bidsjson1 = bidsjson(matchingIndices);
jsonFiles1 = jsonFilesPAD(matchingIndices);

tauidx = [];
for k = 1:length(bidsjson1)
    if strcmp(bidsjson1(k).trc, '18FNAV4694')
        bidsjson1(k).submodality = "Abeta-PET"; 
    end
end

bidsjson1(tauidx).submodality = "tau-PET";

for k = 1:length(bidsjson1)
   currentParticipant = bidsjson1(k).participant_id;

     Pnode = searchNode (neo4jconn, 'Participant', 'PropertyKey', 'participant_id', 'PropertyValue', currentParticipant);

   PETModalityStruct(k) = struct('participant_id', currentParticipant , 'modality', 'PET');
   PETModalityNode = createNode (neo4jconn, 'Labels', 'Modality', 'Properties', PETModalityStruct);

    createRelation(neo4jconn,pNode, PETModalityNode, 'HAS_MODALITY');
end


dataJSON = bidsjson1(k).files;
 for k = 1:length(jsonFiles1)
 relativePaths(k) = extractRelativePaths(jsonFiles1(k), 'data_release_7.0');
 end

 dataProps = struct('submodality', {}, 'type', {}, 'participant_id', {}, 'task', {}, 'run', {}, 'tracer', {},...
    'visit', {}, 'JSONFilePath', {}, 'dataFilePath', {}, 'modality', {});

for k = 1:length(bidsjson1)
    % Create struct for each entry
    dataProps(k).submodality = bidsjson1(k).submodality;
    dataProps(k).type = bidsjson1(k).type
    dataProps(k).participant_id = bidsjson1(k).participant_id
    dataProps(k).task = bidsjson1(k).task
    dataProps(k).run = bidsjson1(k).run
    dataProps(k).trc = bidsjson1(k).trc
    dataProps(k).visit = bidsjson1(k).visit
    
    % Set JSONFilePath
    dataProps(k).JSONFilePath = relativePaths{k};
    
    % Replace .json with .nii.gz and set DataFilePath
    niftiFilePath = strrep(relativePaths{k}, '.json', '.nii.gz');
    dataProps(k).dataFilePath = niftiFilePath;

    dataProps(k).modality = bidsjson1(k).modality;
end

for j= 2:length(dataProps)
toDel = searchNode (neo4jconn, 'Data', 'PropertyKey', 'dataFilePath', 'PropertyValue', dataProps(j).dataFilePath);
deleteNode(neo4jconn,toDel,'DeleteRelations', logical(1));
end

DataNode = createNode (neo4jconn, 'Labels', 'Data', 'Properties', dataProps);  
DataNodeArray = DataNode.NodeObject;

for k = 3:height(participantsPET)
   currentParticipant = participantsPET.participant_id(k);

     Pnode = searchNode (neo4jconn, 'Participant', 'PropertyKey', 'participant_id', 'PropertyValue', currentParticipant);

   PETModalityStruct(k) = struct('participant_id', currentParticipant , 'modality', 'PET');
   
   PETModalityNode(k) = createNode (neo4jconn, 'Labels', 'Modality', 'Properties', PETModalityStruct(k));

   createRelation(neo4jconn,Pnode, PETModalityNode (k), 'HAS_MODALITY');

end

for k = 1:length(DataNodeArray)
   currentParticipant = participantsPET.participant_id(k);
  
    PETModalityNode(1, 1).NodeData.participant_id  

   PETModalityNode(k) = createNode (neo4jconn, 'Labels', 'Modality', 'Properties', PETModalityStruct(k));

   createRelation(neo4jconn,Pnode, PETModalityNode (k), 'HAS_MODALITY');

end
PETModalityNode(1).NodeData.participant_id

for k = 1:length(bidsjson1)
dataJSON = bidsjson1(k).files;
dataJSONNode = createNode (neo4jconn, 'Labels', 'BIDS_JSON', 'Properties', dataJSON);
createRelation (neo4jconn, DataNodeArray(k, 1), dataJSONNode, 'HAS_BIDS');
end

%% 
% Iterate through the bidsjson struct array to find matching filenames
bidsjson = bidsJSONOmega; 
matchingIndices = [];
for k = 1:length(bidsjson)
    if strcmp(bidsjson(k).modality, 'MEG')
        matchingIndices(end+1) = k; 
    end
end

bidsjson1 = bidsjson(matchingIndices);
jsonFiles1 = jsonFilesOMEGA(matchingIndices);
%% 34 94 116 120

for k = 126:height(padkey)
   currentParticipant = strcat("sub-", padkey.old(k));
   currentParticipantMEG = padkey.new(k)

   idx = [];
for j = 1:length(bidsjson1)
    if strcmp(bidsjson1(j).participant_id, currentParticipantMEG)
        idx(end+1) = j; 
    end
end

dataJSON = struct();
currentbids = bidsjson1(idx);
    for jj = 1:length(currentbids); 
        currentbids(jj).participant_alias = currentbids(jj).participant_id;
        currentbids(jj).participant_id = currentParticipant; 
         dataJSON(jj).files =  currentbids(jj).files;
    end
 
currentjsonFiles = jsonFiles1(idx);
for hh = 1:length(currentjsonFiles)
 relativePaths(hh) = extractRelativePaths(currentjsonFiles(hh), 'Omega');
 end

currentbids = rmfield(currentbids, "files");

 dataProps = struct('submodality', {}, 'type', {}, 'participant_id', {}, 'task', {}, 'run', {}, 'tracer', {},...
    'visit', {}, 'JSONFilePath', {}, 'dataFilePath', {}, 'modality', {});

 MEGModalityStruct= struct('participant_id', currentParticipant , 'modality', 'MEG');
 MEGModalityNode = createNode (neo4jconn, 'Labels', 'Modality', 'Properties', MEGModalityStruct);

for mmd = 1:length(currentbids)
    % Create struct for each entry
    dataProps(mmd).submodality = currentbids(mmd).submodality;
    dataProps(mmd).type = currentbids(mmd).type
    dataProps(mmd).participant_id = currentbids(mmd).participant_id
    dataProps(mmd).task = currentbids(mmd).task
    dataProps(mmd).run = currentbids(mmd).run
    
    dataProps(mmd).visit = currentbids(mmd).visit
    
    % Set JSONFilePath
    dataProps(mmd).JSONFilePath = relativePaths{mmd};
    
    % Replace .json with .nii.gz and set DataFilePath
    niftiFilePath = strrep(relativePaths{mmd}, '.json', '.nii.gz');
    dataProps(mmd).dataFilePath = niftiFilePath;

    dataProps(mmd).modality = currentbids(mmd).modality;
end

 Pnode = searchNode (neo4jconn, 'Participant', 'PropertyKey', 'participant_id', 'PropertyValue', currentParticipant);

 createRelation(neo4jconn,Pnode, MEGModalityNode, 'HAS_MODALITY');
 DataNodes = createNode (neo4jconn, 'Labels', 'Data', 'Properties', dataProps);
   clear ModNodes
    for tt = 1:height(DataNodes);
        ModNodes(tt) = MEGModalityNode;
    end
 createRelation (neo4jconn, ModNodes, DataNodes.NodeObject, 'HAS_DATA');
 
end

%% 

    dataJSON = bidsjson1(k).files;
 for k = 1:length(jsonFiles1)
 relativePaths(k) = extractRelativePaths(jsonFiles1(k), 'data_release_7.0');
 end

 dataProps = struct('submodality', {}, 'type', {}, 'participant_id', {}, 'task', {}, 'run', {}, 'tracer', {},...
    'visit', {}, 'JSONFilePath', {}, 'dataFilePath', {}, 'modality', {});

for k = 1:length(bidsjson1)
    % Create struct for each entry
    dataProps(k).submodality = bidsjson1(k).submodality;
    dataProps(k).type = bidsjson1(k).type
    dataProps(k).participant_id = bidsjson1(k).participant_id
    dataProps(k).task = bidsjson1(k).task
    dataProps(k).run = bidsjson1(k).run
    dataProps(k).trc = bidsjson1(k).trc
    dataProps(k).visit = bidsjson1(k).visit
    
    % Set JSONFilePath
    dataProps(k).JSONFilePath = relativePaths{k};
    
    % Replace .json with .nii.gz and set DataFilePath
    niftiFilePath = strrep(relativePaths{k}, '.json', '.nii.gz');
    dataProps(k).dataFilePath = niftiFilePath;

    dataProps(k).modality = bidsjson1(k).modality;
end

for j= 2:length(dataProps)
toDel = searchNode (neo4jconn, 'Data', 'PropertyKey', 'dataFilePath', 'PropertyValue', dataProps(j).dataFilePath);
deleteNode(neo4jconn,toDel,'DeleteRelations', logical(1));
end

DataNode = createNode (neo4jconn, 'Labels', 'Data', 'Properties', dataProps);  
DataNodeArray = DataNode.NodeObject;
