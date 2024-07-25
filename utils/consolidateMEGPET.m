for k = 1:length (pad_info)
    pad_info(k).name = extractLastPart(pad_info(k).filename);
end

for k = 1:length(pad_info)

end

baseDir = '/meg/meg1/omega/oc-data/Omega/'

for k = 1:height(pad_keyjoin)
subjectName = pad_keyjoin.new{k}; 

 subjectFolderPath = findSubjectFolder(subjectName, baseDir);

 pad_keyjoin.omega_folderpath{k} = subjectFolderPath;
end

baseDir = '/export02/data/dbasha/PAD7'

for k = 1:height(pad_keyjoin)
subjectName = pad_keyjoin.new{k}; 

 subjectFolderPath = findSubjectFolder(subjectName, baseDir);

 pad_keyjoin.omega_folderpath{k} = subjectFolderPath;
end

wave1dir = '/export02/data/dbasha/PAD7/data_release_7.0/mri/wave1';
for k = 1:height(pad_keyjoin)
pad_keyjoin.sub(k) = strcat('sub-', pad_keyjoin.PSCID(k));
end


for k = 1:height(pad_keyjoin)
subjectName = pad_keyjoin.sub{k}; 

 subjectFolderPath = findSubjectFolder(subjectName, wave1dir);

 pad_keyjoin.pad_mri_folderpath{k} = subjectFolderPath;
end


for k = 1:height(pad_keyjoin)
visit = pad_keyjoin.Freesurfer_Visit_Label {k};
pad_keyjoin.visitLabel{k} = visit(4:end);
pad_keyjoin.studyLabel{k} = visit(1:3);
end

%% 

for k = 80:height(pad_keyjoin)
omegafolder = pad_keyjoin.omega_folderpath{k};
if ~isempty(omegafolder)
  if ~isempty (dir(fullfile(omegafolder, 'ses-02', '*.tsv')))
    
 scaninfopath =   dir(fullfile(omegafolder, 'ses-01', '*.tsv'));
 if ~isempty (scaninfopath.name)
 scaninfo = readtable(fullfile(scaninfopath.folder, scaninfopath.name), 'FileType','text','Delimiter','\t');
 end

 meginfopath =   dir(fullfile(omegafolder, 'ses-02', '*.tsv'));
 if ~isempty (meginfopath.name)

 meginfo = readtable(fullfile(meginfopath.folder, meginfopath.name), 'FileType','text','Delimiter','\t');
 end


 pad_keyjoin.Delay_Anat_Meg (k)  = between(scaninfo.acq_time(1), meginfo.acq_time(1),'days');
  end
end
end

%%

 sessioninfo = readtable('/meg/meg1/omega/oc-data/Omega/phenotype/sessions.tsv', 'FileType','text','Delimiter','\t');
 
 sessionJoin = innerjoin(pad_keyjoin, sessionInfo, "Keys", "new_participant_id");
 
 
 for k = 1:height(sessionJoin)
% ses-01 and ses-02 refers to the MEG session in the OMEGA session list
% if it is ses-02, it means it was taken after the MRI which is ses-01 and
% vice versa
     if strcmp(sessionJoin.session, 'ses-01')
  
     sessionJoin.age_at_MRI(k) = sessionJoin.ageMEG(k) + (split(sessionJoin.Delay_Anat_Meg(1), {'Days'}))/365
 
     else

      sessionJoin.age_at_MRI(k) = sessionJoin.ageMEG(k) - (split(sessionJoin.Delay_Anat_Meg(1), {'Days'}))/365;
     end

 end


 for k = 1:height(sessionJoin)
 pad_mri_session = strcat('ses-', sessionJoin.visitLabel(k), 'A');
 sessionJoin.mri_folderpath(k) = fullfile (sessionJoin.pad_mri_folderpath(k),pad_mri_session);
 sessionJoin.mri_anat_folderpath(k) = fullfile(sessionJoin.pad_mri_folderpath(k), pad_mri_session, 'anat');
 end



%% 

wave2dir = '/export02/data/dbasha/PAD7/data_release_7.0/mri/wave1';
petdir = '/export02/data/dbasha/PAD7/data_release_7.0/mri/wave1';
