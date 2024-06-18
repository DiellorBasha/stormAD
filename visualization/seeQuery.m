function seeQuery(graphconn, query)
    % Execute the query
    result = executeCypher(graphconn, query);

    % Check if result is not empty
    if isempty(result)
        disp('No results found for the given query.');
        return;
    end

    % Convert the Neo4j result to a MATLAB digraph
    G = neo4jStruct2Digraph(result);

    % Plot the graph
    figure;
    plot(G, 'Layout', 'force');
    title('Neo4j Query Results');
end
