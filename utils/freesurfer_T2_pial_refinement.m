%% T2 refinement of pial surface

for k = 1:height(sessionJoin)
    % Log file for the current subject
    log_file = fullfile(subject_name, 'recon_T2_refinement_log.txt');

    diary(log_file);

    subject_name = currentSubject;
    anat_folder = fullfile (currentSubject, 'mri', 'orig'); % Path to anat folder
    
    % List all files in the anat folder
    anat_files = dir(fullfile(anat_folder, '*.nii.gz'));


    T2_files = {};
    for j = 1:length(anat_files)
        if contains(anat_files(j).name, '_T2star')
            T2_files{end+1} = anat_files(j).name;
        end
    end

    T2file = fullfile(anat_folder,T2_files{1});

    cmd = ['recon-all -s ' subject_name 'a -T2 ' '$SUBJECTS_DIR/' T2file ' -T2pial -autorecon3 -threads 7'];
    full_cmd = sprintf(cmd);

    system(full_cmd);
    % end

    disp(['Processing completed for ', subject_name])

    diary off
end

