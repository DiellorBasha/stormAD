function edges = convertConnectivityToEdges(VertConn)
    % Find the non-zero elements in the connectivity matrix
    [rows, cols] = find(VertConn);
    
    % Create an array of edges
    edges = [rows, cols];
    
    % Remove duplicate edges (since the matrix is symmetric)
    edges = unique(sort(edges, 2), 'rows');
end