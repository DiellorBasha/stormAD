function inputVolume = findInputVolume (sourceFolder, sourceSubject, sourceSession, volumeType)
% This is a helper function to locate the nifti volumes to be used
% for the freesurfer processing stream
%  - inputs are the subject name and the BIDS ending 
% examples findInputVolume ('sub-MTL0002', 'T1w');

anat_folder = fullfile(sourceFolder, sourceSubject, sourceSession, 'anat');  

if strcmp (volumeType, 'suvr')
  anat_folder = fullfile(sourceFolder, sourceSubject, sourceSession);  
elseif strcmp(volumeType, 'pet')
  anat_folder = fullfile(sourceFolder, sourceSubject, sourceSession, 'pet');  
end
% List all files in the anat folder
anat_files = dir(fullfile(anat_folder, '*.nii.gz'));
volumeTypeIn = strcat('_', volumeType);
    
    % Check for multiple T1-weighted runs
    T1w_files = {}; T1w_filepaths = {};
    for j = 1:length(anat_files)
        if contains(anat_files(j).name, volumeTypeIn)
            T1w_files{end+1} = anat_files(j).name;
            T1w_filepaths{end+1} =  fullfile(anat_files(j).folder, anat_files(j).name);
        end
    end

inputVolume = T1w_filepaths; 
end