function fs_segmentation(sourceSubject)
   subjectsDir = '/export02/export01/data/toolboxes/freesurfer/subjects';
   targetSubject = sprintf([sourceSubject 'a']);
   log_file = fullfile(subjectsDir, targetSubject, 'fs_segmentation_log.txt');
  
    cmd = ['gtmseg --s ' targetSubject ' --threads 15'];
    full_cmd = sprintf('export FREESURFER_HOME=%s; source $FREESURFER_HOME/SetUpFreeSurfer.sh; %s', ...
                            getenv('FREESURFER_HOME'), cmd);

    system(full_cmd);
    % end

    disp(['Processing completed for ', sourceSubject])

    diary off
end