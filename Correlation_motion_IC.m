
fileFolder=fullfile('/Volumes/Others/Final_project');
dirOutput=dir(fullfile(fileFolder,'P*'));

plot_index=1:35;

%% 看correlation
i=1;
cur_name=dirOutput(i).name;
patient_four_digit_id=extractAfter(cur_name,'P0000');

motion=load(sprintf('/Volumes/Others/Final_project/%s/rp_aHRF_%s_S0001.txt',cur_name,cur_name));
cfg.motionparam=motion;
cfg.prepro_suite='SPM';
cfg.radius=50;
fwd = framewise_displacement(cfg);
% fwd_self=fd_self_construct(motion);

ic=load(sprintf('/Volumes/Others/2_spatial_ICA_output/%s/%s_ica_c1-1.mat',cur_name,patient_four_digit_id));
ic_tc=ic.tc;

coef=zeros(35,1);
for i = 1:35
    temp=corrcoef(fwd,ic_tc(:,i));
    coef(i,1)=temp(1,2);
end
[coef_sort,index]=sort(coef);
figure;
plot(plot_index,coef_sort,'-bo');
xticks(plot_index);
xticklabels(index);


%% 得到motion txt
motion_col=[1 13 15];
ic_motion=ic_tc(:,motion_col);
mat2txt(sprintf('/Volumes/Others/2_spatial_ICA_output/%s/after_motion_correction/%s.txt',cur_name,[patient_four_digit_id,'motion']), ic_motion);

%% scra与motion做GLM
spm('defaults', 'FMRI');
spm_jobman('initcfg')

put_spm_path=['/Volumes/Others/2_spatial_ICA_output', '/', cur_name, '/', 'after_motion_correction/'];
analysis_input=cell(165,1);
for j=1:165
    ana_inp=['/Volumes/Others/Final_project', '/', cur_name, '/', sprintf('scraHRF_%s_S0001.nii,%i', cur_name, j)];
    analysis_input{j}=ana_inp;
end
motion_reg_path=sprintf('/Volumes/Others/2_spatial_ICA_output/%s/after_motion_correction/%s.txt',cur_name,[patient_four_digit_id,'motion']);


matlabbatch{1}.spm.stats.fmri_spec.dir = {put_spm_path};%%%%%%%%%%%%%%%%%%%%%%%%
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 41;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess.scans = analysis_input;%%%%%%%%%%%%%%%%%%%%%%%%

matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};%%%%%%%%%%%%%%%%%%%%%%%%
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {motion_reg_path};%%%%%%%%%%%%%%%%%%%%%%%%
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
        
spm_jobman('run', matlabbatch);
disp('motion regress SPM written successful !');
clear matlabbatch

%% 手动减掉Motion得到residual（clean data）信号
load([put_spm_path,'SPM.mat']);
design_matrix=SPM.xX.X;

beta1=load_nii([put_spm_path,'beta_0001.nii']);
beta1=beta1.img;

beta2=load_nii([put_spm_path,'beta_0002.nii']);
beta2=beta2.img;

beta3=load_nii([put_spm_path,'beta_0003.nii']);
beta3=beta3.img;

beta4=load_nii([put_spm_path,'beta_0004.nii']);
beta4=beta4.img;

ori=load_nii(sprintf('/Volumes/Others/Final_project/%s/scraHRF_%s_S0001.nii',cur_name,cur_name));
ori_data=ori.img;

[x,y,z,t]=size(ori_data);
residual=zeros(x,y,z,t);
for i=1:x
    for j=1:y
        for k=1:z
            residual(i,j,k,:)=squeeze(ori_data(i,j,k,:))-design_matrix*[beta1(i,j,k) beta2(i,j,k) beta3(i,j,k) beta4(i,j,k)]';
%             residual(i,j,k,:)=design_matrix*[beta1(i,j,k) beta2(i,j,k) beta3(i,j,k) beta4(i,j,k)]';


        end
    end
end

ori.img=residual;
save_nii(ori,[put_spm_path,'Residual_comput_matlab.nii']);

%% clean data与multiple condition

spm('defaults', 'FMRI');
spm_jobman('initcfg')

result_path=['/Volumes/Others/2_spatial_ICA_output', '/', cur_name, '/', 'after_motion_correction/results'];
multiple_condition_path=sprintf('/Volumes/Others/Final_project/%s/SPM_%s_S0001.mat',cur_name,cur_name);


matlabbatch{1}.spm.stats.fmri_spec.dir = {result_path};%%%%%%%%%%%%%%%%%%%%%%%%
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 41;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess.scans = analysis_input;%%%%%%%%%%%%%%%%%%%%%%%%

matlabbatch{1}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {multiple_condition_path};%%%%%%%%%%%%%%%%%%%%%%%%
matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg = {''};%%%%%%%%%%%%%%%%%%%%%%%%
matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Visual';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Audio';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 0];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Motion';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 0 1 0];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

matlabbatch{4}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{4}.spm.stats.results.conspec(1).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(1).contrasts = 1;
matlabbatch{4}.spm.stats.results.conspec(1).threshdesc = 'FWE';
matlabbatch{4}.spm.stats.results.conspec(1).thresh = 0.05;
matlabbatch{4}.spm.stats.results.conspec(1).extent = 0;
matlabbatch{4}.spm.stats.results.conspec(1).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(1).mask.none = 1;
matlabbatch{4}.spm.stats.results.conspec(2).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(2).contrasts = 2;
matlabbatch{4}.spm.stats.results.conspec(2).threshdesc = 'FWE';
matlabbatch{4}.spm.stats.results.conspec(2).thresh = 0.05;
matlabbatch{4}.spm.stats.results.conspec(2).extent = 0;
matlabbatch{4}.spm.stats.results.conspec(2).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(2).mask.none = 1;
matlabbatch{4}.spm.stats.results.conspec(3).titlestr = '';
matlabbatch{4}.spm.stats.results.conspec(3).contrasts = 3;
matlabbatch{4}.spm.stats.results.conspec(3).threshdesc = 'FWE';
matlabbatch{4}.spm.stats.results.conspec(3).thresh = 0.05;
matlabbatch{4}.spm.stats.results.conspec(3).extent = 0;
matlabbatch{4}.spm.stats.results.conspec(3).conjunction = 1;
matlabbatch{4}.spm.stats.results.conspec(3).mask.none = 1;

matlabbatch{4}.spm.stats.results.units = 1;
matlabbatch{4}.spm.stats.results.export{1}.pdf = true;
        
spm_jobman('run', matlabbatch);
disp('results written successful !');
clear matlabbatch






