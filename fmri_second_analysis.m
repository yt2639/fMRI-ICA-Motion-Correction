fileFolder=fullfile('/Volumes/Others/2_temporal_ICA_output/');
dir_pat=dir(fullfile(fileFolder,'P*'));

%%
for i = 1:length(dir_pat)
    subject_id=dir_pat(i).name;
    source=['/Volumes/Others/2step/tICA/',subject_id,'/results/con_0001.nii'];
    destination=['/Volumes/Others/2step/tICA/2nd_visual/',sprintf('%s_con_0001.nii',subject_id)];
    copyfile(source, destination);
end

%%
for i = 1:length(dir_pat)
    subject_id=dir_pat(i).name;
    source=['/Volumes/Others/2step/tICA/',subject_id,'/results/con_0002.nii'];
    destination=['/Volumes/Others/2step/tICA/2nd_audio/',sprintf('%s_con_0002.nii',subject_id)];
    copyfile(source, destination);
end

%%
for i = 1:length(dir_pat)
    subject_id=dir_pat(i).name;
    source=['/Volumes/Others/2step/tICA/',subject_id,'/results/con_0003.nii'];
    destination=['/Volumes/Others/2step/tICA/2nd_motion/',sprintf('%s_con_0003.nii',subject_id)];
    copyfile(source, destination);
end







%%
for i = 1:length(dir_pat)
    subject_id=dir_pat(i).name;
    source=['/Volumes/Others/HW/HW_1st_ana/',subject_id,'/con_0003.nii'];
    destination=['/Volumes/Others/HW/HW_2nd_ana/motion/',sprintf('%s_con_0003.nii',subject_id)];
    copyfile(source, destination);
end


