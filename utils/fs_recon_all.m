function fs_recon_all (sourceSubject)

      % Log file for the current subject
    log_file = fullfile(sourceSubject, 'recon_processing_log.txt');
    
    diary(log_file); 
    anat_folder = fullfile (sourceSubject, 'mri', 'orig'); % Path to anat folder
    output_dir = ''; % Output directory
    
    % List all files in the anat folder
    anat_files = dir(fullfile(anat_folder, '*.nii.gz'));
    
    % Check for multiple T1-weighted runs
    T1w_files = {};
    for j = 1:length(anat_files)
        if contains(anat_files(j).name, '_T1w')
            T1w_files{end+1} = anat_files(j).name;
        end
    end

 
    % Run recon-all with the single T1-weighted scan
        cmd = ['recon-all -s ' sourceSubject 'a' ' -i ' '$SUBJECTS_DIR/' fullfile(anat_folder, T1w_files{1}) ' -all -threads 15'];
        full_cmd = sprintf('export FREESURFER_HOME=%s; source $FREESURFER_HOME/SetUpFreeSurfer.sh; %s', ...
                            getenv('FREESURFER_HOME'), cmd);
        system(full_cmd);
    % end
    
    disp(['Processing completed for ', subject_name]);
    diary off


end