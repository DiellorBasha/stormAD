%% T2 refinement of pial surface

function fs_T2_pial_refinement(sourceSubject)
    % Log file for the current subject
subjectsDir = '/export02/export01/data/toolboxes/freesurfer/subjects';

targetSubject = sprintf([sourceSubject 'a']);
targetDirectory  = fullfile (targetSubject, 'pet', 'coreg');

 log_file = fullfile(subjectsDir, targetSubject, 'recon_T2_refinement_log.txt');

    diary(log_file);

    anat_folder = fullfile (subjectsDir, sourceSubject, 'mri', 'orig'); % Path to anat folder
    
    % List all files in the anat folder
    anat_files = dir(fullfile(anat_folder, '*.nii.gz'));


    T2_files = {};
    for j = 1:length(anat_files)
        if contains(anat_files(j).name, '_T2star')
            T2_files{end+1} = anat_files(j).name;
        end
    end

    T2file = fullfile(anat_folder,T2_files{1});

    cmd = ['recon-all -s ' targetSubject ' -T2 ' T2file ' -T2pial -autorecon3 -threads 15'];
    full_cmd = sprintf('export FREESURFER_HOME=%s; source $FREESURFER_HOME/SetUpFreeSurfer.sh; %s', ...
                            getenv('FREESURFER_HOME'), cmd);

    system(full_cmd);
[status, cmdout] = system(full_cmd);

% if status ~= 0
%     error('Error in refining the cortical surface: %s', cmdout);
% end
     disp(['Processing completed for ', sourceSubject])
     diary off
end
