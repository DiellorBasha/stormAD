function dataNode = findDataNode(graphconn, modality_name, participant_id, session_name)
    % Define the query to traverse the graph and find the Data node
    query = sprintf(['MATCH (m:Modality {name: "%s"})-[:HAS_PARTICIPANT]->(p:Participant {id: "%s"})-[:HAS_SESSION]->(s:Session {name: "%s"})-[:HAS_DATA]->(d:Data) ' ...
                     'RETURN m, p, s, d'], modality_name, participant_id, session_name);
    
    % Execute the query
    result = fetch(graphconn, query);
    
    if isempty(result)
        error('No Data node found for participant_id: %s, session_name: %s, and modality_name: %s', participant_id, session_name, modality_name);
    end
    
    % Extract the returned nodes
    modalityNode = result(1).m;
    participantNode = result(1).p;
    sessionNode = result(1).s;
    dataNode = result(1).d;
    
    % Create instances of the classes
    modality = Modality(graphconn, modalityNode.id, modalityNode.datasetId, modalityNode.name);
    participant = Participant(graphconn, participantNode.id, modalityNode.id, participantNode.derivativesId, participantNode.name);
    session = Session(graphconn, sessionNode.id, participantNode.id, sessionNode.name);
    data = Scan(graphconn, dataNode.id, sessionNode.id, dataNode.type);
    
    % Return the Data node instance
    dataNode = data;
end
