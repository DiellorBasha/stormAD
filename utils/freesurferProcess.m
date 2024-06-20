
subjDirectory = '/export01/data/toolboxes/freesurfer/subjects';
cd(subjDirectory);

for k=1:height(sessionJoin)

mkdir (sessionJoin.sub {k});
end


for k=1:height(sessionJoin)

currentSubject = sessionJoin.sub{k};
currentDirectory  = fullfile (currentSubject, 'mri', 'orig');

% make mri/orig directory in subject folder for Freesurfer
mkdir (currentDirectory);

end
%12, 25, 26, 34,99,102
%% 

for k=103:height(sessionJoin)

currentSubject = sessionJoin.sub{k};
targetDirectory  = fullfile (currentSubject, 'mri', 'orig');

sourceDirectory = sessionJoin.mri_anat_folderpath {k};
copyfile(fullfile(sourceDirectory, '*'),targetDirectory);

end
%% 
setenv('FREESURFER_HOME', '/export01/data/toolboxes/freesurfer');
setenv('SUBJECTS_DIR', '/export01/data/toolboxes/freesurfer/subjects');
system('source $FREESURFER_HOME/SetUpFreeSurfer.sh');


%%
for k=1:height(sessionJoin)

currentSubject = sessionJoin.sub{k}
subject_name = currentSubject;
anat_folder  = fullfile (currentSubject, 'mri', 'orig'); % Path to anat folder from sessionJoin.mri_anat_folderpath
output_dir = subject_name;

% List all files in the anat folder
anat_files = dir(fullfile(anat_folder, '*.nii.gz'));

% Check for multiple T1-weighted runs
T1w_files = {};
for k = 1:length(anat_files)
    if contains(anat_files(k).name, '_T1w')
        T1w_files{end+1} = anat_files(k).name;
    end
end
% Run recon-all with the single T1-weighted scan
cmd = ['recon-all -s ' subject_name ' -i $SUBJECTS_DIR/' fullfile(anat_folder,T1w_files{1}) ' -all --threads 8'];
    system(cmd);
end


%% 



idx =[];
for k = 1:height(sessionJoin)

anatContents = dir(sessionJoin.mri_anat_folderpath{k});
    % Filter out non-folders and '.' and '..'
anatContents = anatContents(~ismember({anatContents.name}, {'.', '..'}));
 

for jj = 1:length(anatContents);
    anatContents(jj).splits = split(anatContents(jj).name, '_');
    anatContents(jj).third = anatContents(jj).splits(3);
    anatContents(jj).filetype = anatContents(jj).splits{end};

    if strcmp ('T1w.nii.gz', anatContents(jj).filetype)
    idx= [idx jj];
   %  anatContents(jj).T1FilePath = fullfile (anatContents(jj).folder, anatContents(jj).name);
  
    end
end

if length(idx)>1

  T1FilePath = fullfile (anatContents(idx(1)).folder, anatContents(idx(1)).name);
  T1FilePath2 = fullfile (anatContents(idx(2)).folder, anatContents(idx(2)).name);
    
    fsCommand = [sprintf('mri_robust_template --mov', ]

end
