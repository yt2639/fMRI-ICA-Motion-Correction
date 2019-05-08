
fileFolder=fullfile('/Volumes/Others/2_spatial_ICA_output');
dirOutput=dir(fullfile(fileFolder,'P*'));

% plot_index=1:35;
% for i=1:34
%    mkdir(['/Volumes/Others/2step/sICA/',dirOutput(i).name,'/results']) 
%    mkdir(['/Volumes/Others/2step/tICA/',dirOutput(i).name,'/results']) 
% end

%% 看correlation
i=1;
cur_name=dirOutput(i).name;
patient_four_digit_id=extractAfter(cur_name,'P0000');

% motion=load(sprintf('/Volumes/Others/Final_project/%s/rp_aHRF_%s_S0001.txt',cur_name,cur_name));
% cfg.motionparam=motion;
% cfg.prepro_suite='SPM';
% cfg.radius=50;
% fwd = framewise_displacement(cfg);
% % fwd_self=fd_self_construct(motion);
% 
ic=load(sprintf('/Volumes/Others/2_temporal_ICA_output/%s/%s_ica_c1-1.mat',cur_name,patient_four_digit_id));
ic_tc=ic.tc;
% 
% coef=zeros(35,1);
% for i = 1:35
%     temp=corrcoef(fwd,ic_tc(:,i));
%     coef(i,1)=temp(1,2);
% end
% [coef_sort,index]=sort(coef);
% figure;
% plot(plot_index,coef_sort,'-bo');
% xticks(plot_index);
% xticklabels(index);
% 
% a=readtable(sprintf('/Volumes/Others/2_spatial_ICA_output/%s/%s_temporal_correlation.txt',cur_name,patient_four_digit_id));
% a=table2array(a);
% corr_visual=strsplit(a{1});
% visual_corr=corr_visual(3:5);
% disp(visual_corr)
% %
% corr_audio=strsplit(a{5});
% audio_corr=corr_audio(3:5);
% disp(audio_corr)
% %
% corr_motion=strsplit(a{9});
% motion_corr=corr_motion(3:5);
% disp(motion_corr)


%% 得到motion txt
motion_col=[1 2 4 7 8	10 11 13	18 19 20	21 23 27	29 35];
ic_motion=ic_tc(:,motion_col);
mat2txt(sprintf('/Volumes/Others/2_temporal_ICA_output/%s/after_motion_correction/%s.txt',cur_name,[patient_four_digit_id,'motion']), ic_motion);


%% scra与motion做GLM
for pat=1:34

    cur_name=dirOutput(pat).name;
    patient_four_digit_id=extractAfter(cur_name,'P0000');
    
    analysis_input=cell(165,1);
    for j=1:165
        ana_inp=['/Volumes/Others/Final_project', '/', cur_name, '/', sprintf('scraHRF_%s_S0001.nii,%i', cur_name, j)];
        analysis_input{j}=ana_inp;
    end
    put_spm_path=['/Volumes/Others/2step/sICA/', cur_name];
    motion_reg_path=sprintf('/Volumes/Others/2_spatial_ICA_output/%s/after_motion_correction/%s.txt',cur_name,[patient_four_digit_id,'motion']);
    multiple_condition_path=sprintf('/Volumes/Others/Final_project/%s/SPM_%s_S0001.mat',cur_name,cur_name);

    spm('defaults', 'FMRI');
    spm_jobman('initcfg')
    
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
    load([put_spm_path,'/SPM.mat']);
    design_matrix=SPM.xX.X;
    ori=load_nii(sprintf('/Volumes/Others/Final_project/%s/scraHRF_%s_S0001.nii',cur_name,cur_name));
    [x,y,z,t]=size(ori.img);
    residual=zeros(x,y,z,t);

    fileFolders=fullfile(put_spm_path);
    betas=dir(fullfile(fileFolders,'beta_*'));
    beta_vec=single(zeros(length(betas),x,y,z));

    for i=1:(length(betas))
        beta_str=sprintf('beta_%04i.nii',i);
        eval(sprintf('beta%i=load_nii([put_spm_path,''/'',''%s'']);',i,beta_str))
        eval(sprintf('beta%i=beta%i.img;',i,i))
        eval(sprintf('beta_vec(%i,:,:,:)=beta%i;',i,i))
    end

    for i=1:x
        for j=1:y
            for k=1:z
                residual(i,j,k,:)=squeeze(ori.img(i,j,k,:))-design_matrix*beta_vec(:,i,j,k);
                % residual(i,j,k,:)=design_matrix*[beta1(i,j,k) beta2(i,j,k) beta3(i,j,k) beta4(i,j,k)]';
            end
        end
    end

    ori.img=residual;
    save_nii(ori,[put_spm_path,'/Residual_comput_matlab.nii']);
    clear SPM ori

%% 
    clean_data=cell(165,1);
    for j=1:165
        ana_inp=[put_spm_path, sprintf('/Residual_comput_matlab.nii,%i', j)];
        clean_data{j}=ana_inp;
    end
    new_put_spm_path=[put_spm_path,'/results'];
    
    spm('defaults', 'FMRI');
    spm_jobman('initcfg')
    
    matlabbatch{1}.spm.stats.fmri_spec.dir = {new_put_spm_path};%%%%%%%%%%%%%%%%%%%%%%%%
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 41;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = clean_data;%%%%%%%%%%%%%%%%%%%%%%%%
    
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
    
    spm_jobman('run', matlabbatch);
    disp('results written successful !');
    clear matlabbatch




end

