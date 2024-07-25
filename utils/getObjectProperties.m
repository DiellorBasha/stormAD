function outStruct = getObjectProperties(obj)
    % GETOBJECTPROPERTIES Converts an object's properties to a structure
    %
    % This function takes any object and returns a structure containing all
    % its properties. It handles nested objects, various data types including
    % strings, structures, and tables.
    %
    % Input:
    %   obj - Any MATLAB object
    %
    % Output:
    %   outStruct - A structure containing all properties of the input object

    outStruct = struct();
    props = properties(obj);
    
    for i = 1:length(props)
        propName = props{i};
        propValue = obj.(propName);
        
        if isobject(propValue)
            % Recursively handle nested objects
            outStruct.(propName) = getObjectProperties(propValue);
        elseif isstruct(propValue)
            % Handle structures
            outStruct.(propName) = propValue;
        elseif istable(propValue)
            % Convert tables to struct arrays
            outStruct.(propName) = table2struct(propValue);
        elseif iscell(propValue)
            % Handle cell arrays
            outStruct.(propName) = cellfun(@(x) convertToSerializable(x), propValue, 'UniformOutput', false);
        elseif ischar(propValue) || isstring(propValue) || isnumeric(propValue) || islogical(propValue)
            % Directly assign simple data types
            outStruct.(propName) = propValue;
        else
            % For any other data types, try to convert to string representation
            try
                outStruct.(propName) = string(propValue);
            catch
                outStruct.(propName) = 'Unconvertible data type';
            end
        end
    end
end

function out = convertToSerializable(in)
    % Helper function to convert complex types to serializable formats
    if isobject(in)
        out = getObjectProperties(in);
    elseif isstruct(in)
        out = in;
    elseif istable(in)
        out = table2struct(in);
    elseif iscell(in)
        out = cellfun(@(x) convertToSerializable(x), in, 'UniformOutput', false);
    elseif ischar(in) || isstring(in) || isnumeric(in) || islogical(in)
        out = in;
    else
        try
            out = string(in);
        catch
            out = 'Unconvertible data type';
        end
    end
end