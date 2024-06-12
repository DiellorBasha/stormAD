
jsonFiles = findAllJsonFiles('data');
for k=1:length(jsonFiles)
filetext = fileread(jsonFiles{k});
%[data json] = parse_json(filetext);
bidsjson(k).files = jsondecode(filetext);
[~,bidsjson(k).filename, bidsjson(k).filetype]  = fileparts(jsonFiles(k)); 
end

for k = 1:length(jsonFiles)
[~, name, ~] = fileparts(bidsjson(k).filename);
    if contains(name, 'sub')             
        parts = split(name, '_');
                
                % Update properties
                bidsjson(k).participant_id = parts{1};
                bidsjson(k).visit = parts{2};
                
                for i = 3:length(parts)
                    if contains(parts{i}, 'task')
                        bidsjson(k).task = extractAfter(parts{i}, 'task-');
                    elseif contains(parts{i}, 'run')
                        bidsjson(k).run = extractAfter(parts{i}, 'run-');
                    elseif contains(parts{i}, 'trc')
                        bidsjson(k).trc = extractAfter(parts{i}, 'trc-');
                    else
                        bidsjson(k).type = parts{i};
                    end
                end

                
    end
end

for k = 1:length(bidsjson)
 if isfield (bidsjson(k).files, 'Modality')
    bidsjson(k).modality = bidsjson(k).files.Modality;
 end
end

for k = 1:length(bidsjson)
 if isfield (bidsjson(k).files, 'Modality')
    bidsjson(k).modality = bidsjson(k).files.Modality;
    %bidsjson(k).submodality = bidsjson(k).files.Modality;
 end
end


for k = 1:length(bidsjson)
    if strcmp(bidsjson(k).type, 'meg')
        bidsjson(k).modality = 'MEG';
    end
end


for k = 1:length(bidsjson)
    if strcmp(bidsjson(k).type, 'T1w') | strcmp(bidsjson(k).type, 'T2star')| strcmp(bidsjson(k).type, 'T2w')...
            | strcmp(bidsjson(k).type, 'FLAIR')| strcmp(bidsjson(k).type, 'MP2RAGE') | strcmp(bidsjson(k).type, 'T1map')...
            | strcmp(bidsjson(k).type, 'UNIT1')
        bidsjson(k).submodality = 'anat'; 
    end
end

for k = 1:length(bidsjson)
    if strcmp(bidsjson(k).type, 'dwi') 
        bidsjson(k).submodality = 'dwi'; 
    end
end

for k = 1:length(bidsjson)
    if strcmp(bidsjson(k).type, 'asl') 
        bidsjson(k).submodality = 'asl'; 
    end
end



for k = 1:length(bidsjson)
    if strcmp(bidsjson(k).type, 'magnitude1') | strcmp(bidsjson(k).type, 'magnitude2')| strcmp(bidsjson(k).type, 'phasediff')...
        bidsjson(k).submodality = 'fmap'; 
    end
end


for k = 1:length(bidsjson)
    if strcmp(bidsjson(k).type, 'bold') 
        bidsjson(k).submodality = 'func'; 
    end
end


