function fs_pet_PVC (sourceSubject)

subjectsDir = '/export02/export01/data/toolboxes/freesurfer/subjects';
sourceDirectory  = fullfile (sourceSubject, 'pet', 'derivatives', 'vlpp', 'ses-01');

targetSubject = sprintf([sourceSubject 'a']);
targetDirectory  = fullfile (targetSubject, 'pet', 'coreg');

  % List all files in the anat folder
    pet_files = dir(fullfile(subjectsDir, sourceDirectory, '*.nii.gz'));

     % Check for multiple T1-weighted runs
    suvr_files = {};
    for j = 1:length(pet_files)
        if contains(pet_files(j).name, '_suvr')
            suvr_files{end+1} = pet_files(j).name;
        end
    end


relativePaths = extractRelativePaths(suvr_files, 'trc-');

for jj=1:length(relativePaths)

path2petNifti = fullfile(sourceDirectory, suvr_files{jj});

[a,b,c] = fileparts(relativePaths{jj});
[a,outputDirectory,c] = fileparts(b);

path2outputFolder = fullfile(subjectsDir, targetDirectory, outputDirectory);
if ~exist(path2outputFolder)
mkdir(path2outputFolder)
end

path2fsoutput = fullfile(subjectsDir, targetDirectory, outputDirectory, 'template.reg.lta');

path2fsPVCoutput = fullfile(subjectsDir, targetDirectory, outputDirectory, 'gtmpvc');
if ~exist(path2fsPVCoutput)
mkdir(path2fsPVCoutput)
end

path2GTMseg = fullfile('/export01/data/toolboxes/freesurfer/subjects', targetSubject, 'mri/gtmseg.mgz')
 
log_file = fullfile(path2outputFolder, 'fs_pet_pvc_log.txt');

cmd = ['mri_gtmpvc --i ' '$SUBJECTS_DIR/' path2petNifti ' --reg ' path2fsoutput ' --psf 2.4 --seg ' path2GTMseg ' --default-seg-merge --auto-mask 1 .01 --mgx .01 --o  ' path2fsPVCoutput ' --threads 15'];
full_cmd = sprintf('export FREESURFER_HOME=%s; source $FREESURFER_HOME/SetUpFreeSurfer.sh; %s', ...
                            getenv('FREESURFER_HOME'), cmd);
 diary(log_file);
system(full_cmd);
  
disp(['Processing completed for ', sourceSubject])


diary off

end
end