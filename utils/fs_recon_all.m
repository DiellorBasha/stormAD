function fs_recon_all (T1w, T2, sourceSubject)

% Use fs_environment_config and findInputVolumes to get T1w and FLAIR paths

% Run recon-all with the T1-weighted scan
% + pial refinement with FLAIR

cmd = [...
    'recon-all -s ' sourceSubject ...
    ' -i ' T1w ...
    ' -FLAIR ' FLAIR ...
    ' -FLAIRpial -all -threads 15' ...
    ];
fs_execute (cmd);


full_cmd = sprintf('export FREESURFER_HOME=%s; source $FREESURFER_HOME/SetUpFreeSurfer.sh; %s', ...
    getenv('FREESURFER_HOME'), cmd);
system(full_cmd);
% end

disp(['Processing completed for ', sourceSubject]);
diary off


end