
for k=1:25
  
  sourceSubject = sessionJoin.sub{k};
% sourceSubject = 'sub-MTL0005';
  subjectFF = fullfile(subjectsDir, sourceSubject);
  pial = freesurfer_read_subject(subject,{'pial', 'thickness','curv'});

  pial.lh.pial.faces = pial.lh.pial.faces(:,[1 3 2]);
  pial.rh.pial.faces = pial.rh.pial.faces(:,[1 3 2]);

 surf = freesurfer_surf_combine(pial.lh.pial, pial.rh.pial);
 surf.curv = [pial.lh.curv; pial.rh.curv];
 surf.thickness = [pial.lh.thickness; pial.rh.thickness];

 a = dir(fullfile(subjectsDir, sourceSubject, 'pet'));
    for jjj = 3:5
        selectedTemplateDir = fullfile(a(jjj).folder, a(jjj).name);
        fnameRight = fullfile(selectedTemplateDir, 'rh_suvr_paint.w');
        [wRight,vertRight] = freesurfer_read_wfile(fnameRight);
        fnameLeft = fullfile (selectedTemplateDir, 'lh_suvr_paint.w');
        [wLeft, vertLeft] = freesurfer_read_subject(fnameLeft);

        surfPET(k).subject = sourceSubject; 
        surfPET(k).suvr(jj) = wLeft;
       
  
surf.tau = [test_0002.tau.lh.suvr; test_0002.tau.rh.suvr];
surf.Ab_cerebellar_cortex = [test_0002.abetaCerebellarCortex.lh.suvr; test_0002.abetaCerebellarCortex.rh.suvr];
surf.Ab_whole_cerebellum = [test_0002.abetaWholeCerebellum.lh.suvr; test_0002.abetaWholeCerebellum.rh.suvr];

    
    end
end


thiD = '/export02/export01/data/toolboxes/freesurfer/subjects/sub-MTL0005/pet/18Fflortaucipir_pet_ref-infCerebellarGray_suvr';
fname = fullfile(thiD, 'rh_suvr_paint.w');
[w,vert] = freesurfer_read_wfile(fname);
test_0002.tau.rh.vertices = vert;
test_0002.tau.rh.suvr = w;
fname = fullfile(thiD, 'lh_suvr_paint.w');
[w,vert] = freesurfer_read_wfile(fname);
test_0002.tau.lh.vertices = vert;
test_0002.tau.lh.suvr = w;