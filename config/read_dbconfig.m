function dbconfig = read_dbconfig(filename)
    % Read database configuration from a text file
    fid = fopen(filename, 'r');
    if fid == -1
        error('Cannot open the file %s', filename);
    end
    
    dbconfig = struct();
    while ~feof(fid)
        line = fgetl(fid);
        if startsWith(line, '#') || isempty(line)
            continue;
        end
        tokens = split(line, '=');
        if numel(tokens) == 2
            key = strtrim(tokens{1});
            value = strtrim(tokens{2});
            dbconfig.(key) = value;
        end
    end
    
    fclose(fid);
end