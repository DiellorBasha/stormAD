   
 properties = struct('participant_id', obj.participant_id, 'sex', 'F', 'weight', 70);
 participantNode = createNode(neo4jconn, 'Labels', 'Participant', 'Properties', properties);
  
 properties = struct('participant_id', obj.participant_id, 'modality', 'MRI');
 modalityNode = createNode(neo4jconn, 'Labels', 'Modality', 'Properties', properties);

 relationtype = 'HAS_MODALITY';
 createRelation(neo4jconn,participantNode, modalityNode, relationtype);

participantNode = searchNode(neo4jconn,'Participant', 'PropertyKey', 'participant_id', 'PropertyValue', obj.participant_id);

% if it is more than one node, it is a table of nodes
% relationObject: startNode - relation - endnode + relationdata; can map it
% to child>parent objects in MATLAB 


relinfo = searchRelation(neo4jconn,participantNode, 'out', 'RelationTypes', 'HAS_MODALITY');


 nodeinfo = searchNode(neo4jconn,nlabel,'PropertyKey','name', ...
    'PropertyValue','User2')
 
 relationtype = 'HAS_SCAN';
 createRelation(neo4jconn,startnode,endnode,relationtype)

graphinfo = searchGraph(neo4jconn,nlabel);