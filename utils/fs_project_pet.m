function fs_project_pet(sourceSubject)

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

path2ctxgm = fullfile(path2fsPVCoutput, 'mgx.ctxgm.nii.gz');
pet_volume = path2ctxgm; 

path2bbpet = fullfile(path2fsPVCoutput, 'aux/bbpet2anat.lta');
registration_file = path2bbpet;

output_file = fullfile(path2outputFolder, 'lh.pvc_pet_projection.nii.gz');


log_file = fullfile(path2outputFolder, 'fs_pet_pvc_log.txt');

%right side
cmd = ['mri_vol2surf --mov ' pet_volume ' --reg ' registration_file ' --hemi lh --projfrac 0.5 --o ' output_file ' --cortex --trgsubject ' targetSubject];
full_cmd = sprintf('export FREESURFER_HOME=%s; source $FREESURFER_HOME/SetUpFreeSurfer.sh; %s', ...
                            getenv('FREESURFER_HOME'), cmd);
diary(log_file);
system(full_cmd);

%right side
output_file = fullfile(path2outputFolder, 'rh.pvc_pet_projection.nii.gz');


cmd = ['mri_vol2surf --mov ' pet_volume ' --reg ' registration_file ' --hemi rh --projfrac 0.5 --o ' output_file ' --cortex --trgsubject ' targetSubject];
full_cmd = sprintf('export FREESURFER_HOME=%s; source $FREESURFER_HOME/SetUpFreeSurfer.sh; %s', ...
                            getenv('FREESURFER_HOME'), cmd);

  system(full_cmd);
disp(['Processing completed for ', sourceSubject])

diary off

end