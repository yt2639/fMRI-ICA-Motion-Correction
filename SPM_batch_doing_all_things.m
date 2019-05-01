%-----------------------------------------------------------------------
% Job saved on 06-Mar-2019 00:29:06 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7487)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
%%
fileFolder=fullfile('/Volumes/Others/DataForFmriClass');
dirOutput=dir(fullfile(fileFolder,'P*'));
dir_pre='/Volumes/Others/DataForFmriClass';

spm('defaults', 'FMRI');


for i = 1:35

    cur_name=dirOutput(i).name;
    disp(cur_name)
    
    newfolder=['/Users/shane/Documents/MATLAB/html', '/', cur_name];
    mkdir(newfolder)
    
    T1_path=[dir_pre, '/', cur_name, '/', sprintf('T1_%s_S0001.nii,1', cur_name)];
    Multi_cond=[dir_pre, '/', cur_name, '/', sprintf('SPM_%s_S0001.mat', cur_name)];
    
    slicetiming_input=cell(165,1);
    analysis_input=cell(165,1);
    for j=1:165
        st_inp=[dir_pre, '/', cur_name, '/', sprintf('HRF_%s_S0001.nii,%i', cur_name, j)];
        slicetiming_input{j}=st_inp;
        ana_inp=[dir_pre, '/', cur_name, '/', sprintf('sc2c1raHRF_%s_S0001.nii,%i', cur_name, j)];
        analysis_input{j}=ana_inp;
    end
    
    %%%我也不知
    spm_jobman('initcfg')
    
    matlabbatch{1}.spm.temporal.st.scans = {
        slicetiming_input
        }';%%%%%%%%%%%%%%%%%%%%%%%%
    
    matlabbatch{1}.spm.temporal.st.nslices = 41;
    matlabbatch{1}.spm.temporal.st.tr = 2;
    matlabbatch{1}.spm.temporal.st.ta = 1.95121951219512;
    matlabbatch{1}.spm.temporal.st.so = [1 7 13 19 25 31 37 2 8 14 20 26 32 38 3 9 15 21 27 33 39 4 10 16 22 28 34 40 5 11 17 23 29 35 41 6 12 18 24 30 36];
    matlabbatch{1}.spm.temporal.st.refslice = 1;
    matlabbatch{1}.spm.temporal.st.prefix = 'a';
    matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep('Slice Timing: Slice Timing Corr. Images (Sess 1)', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('()',{1}, '.','files'));
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.sep = 4;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.interp = 2;
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{2}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
    matlabbatch{3}.spm.spatial.coreg.estwrite.ref = {T1_path}; %%%%%%%%%%%%%%%%%%%%%%%%
    matlabbatch{3}.spm.spatial.coreg.estwrite.source(1) = cfg_dep('Realign: Estimate & Reslice: Mean Image', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rmean'));
    matlabbatch{3}.spm.spatial.coreg.estwrite.other(1) = cfg_dep('Realign: Estimate & Reslice: Resliced Images (Sess 1)', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','sess', '()',{1}, '.','rfiles'));
    matlabbatch{3}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{3}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{3}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{3}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{3}.spm.spatial.coreg.estwrite.roptions.interp = 4;
    matlabbatch{3}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{3}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{3}.spm.spatial.coreg.estwrite.roptions.prefix = 'c1';
    matlabbatch{4}.spm.spatial.coreg.estwrite.ref = {'/Users/shane/Documents/BMEN4840_fMRI/spm12/toolbox/OldNorm/T1.nii,1'};
    matlabbatch{4}.spm.spatial.coreg.estwrite.source = {T1_path};%%%%%%%%%%%%%%%%%%%%%%%%
    matlabbatch{4}.spm.spatial.coreg.estwrite.other(1) = cfg_dep('Coregister: Estimate & Reslice: Resliced Images', substruct('.','val', '{}',{3}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rfiles'));
    matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
    matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
    matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{4}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
    matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.interp = 4;
    matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.mask = 0;
    matlabbatch{4}.spm.spatial.coreg.estwrite.roptions.prefix = 'c2';
    matlabbatch{5}.spm.spatial.smooth.data(1) = cfg_dep('Coregister: Estimate & Reslice: Resliced Images', substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','rfiles'));
    matlabbatch{5}.spm.spatial.smooth.fwhm = [8 8 8];
    matlabbatch{5}.spm.spatial.smooth.dtype = 0;
    matlabbatch{5}.spm.spatial.smooth.im = 0;
    matlabbatch{5}.spm.spatial.smooth.prefix = 's';
    matlabbatch{6}.spm.stats.fmri_spec.dir = {newfolder};%%%%%%%%%%%%%%
    matlabbatch{6}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{6}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{6}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{6}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    %%
    matlabbatch{6}.spm.stats.fmri_spec.sess.scans = analysis_input;
    %%
    matlabbatch{6}.spm.stats.fmri_spec.sess.cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
    matlabbatch{6}.spm.stats.fmri_spec.sess.multi = {Multi_cond};%%%%%%%%%%%%%%
    matlabbatch{6}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{6}.spm.stats.fmri_spec.sess.multi_reg = {''};
    matlabbatch{6}.spm.stats.fmri_spec.sess.hpf = 128;
    matlabbatch{6}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{6}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{6}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{6}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{6}.spm.stats.fmri_spec.mthresh = 0.8;
    matlabbatch{6}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{6}.spm.stats.fmri_spec.cvi = 'AR(1)';
    matlabbatch{7}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{6}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{7}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{7}.spm.stats.fmri_est.method.Classical = 1;
    matlabbatch{8}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{7}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{8}.spm.stats.con.consess{1}.tcon.name = 'Visual';
    matlabbatch{8}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 0];
    matlabbatch{8}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{8}.spm.stats.con.consess{2}.tcon.name = 'Audio';
    matlabbatch{8}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 0];
    matlabbatch{8}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{8}.spm.stats.con.consess{3}.tcon.name = 'Motion';
    matlabbatch{8}.spm.stats.con.consess{3}.tcon.weights = [0 0 1 0];
    matlabbatch{8}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{8}.spm.stats.con.delete = 0;
    matlabbatch{9}.spm.stats.results.spmmat(1) = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{8}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{9}.spm.stats.results.conspec(1).titlestr = '';
    matlabbatch{9}.spm.stats.results.conspec(1).contrasts = 1;
    matlabbatch{9}.spm.stats.results.conspec(1).threshdesc = 'FWE';
    matlabbatch{9}.spm.stats.results.conspec(1).thresh = 0.05;
    matlabbatch{9}.spm.stats.results.conspec(1).extent = 0;
    matlabbatch{9}.spm.stats.results.conspec(1).conjunction = 1;
    matlabbatch{9}.spm.stats.results.conspec(1).mask.none = 1;
    matlabbatch{9}.spm.stats.results.conspec(2).titlestr = '';
    matlabbatch{9}.spm.stats.results.conspec(2).contrasts = 2;
    matlabbatch{9}.spm.stats.results.conspec(2).threshdesc = 'FWE';
    matlabbatch{9}.spm.stats.results.conspec(2).thresh = 0.05;
    matlabbatch{9}.spm.stats.results.conspec(2).extent = 0;
    matlabbatch{9}.spm.stats.results.conspec(2).conjunction = 1;
    matlabbatch{9}.spm.stats.results.conspec(2).mask.none = 1;
    matlabbatch{9}.spm.stats.results.units = 1;
    matlabbatch{9}.spm.stats.results.export{1}.ps = true;
    
    spm_jobman('run', matlabbatch);
    disp('pre_processing successful !');
    clear matlabbatch
    
end

%% 
for i =1:length(dirOutput)
cur_name=dirOutput(i).name;
movefile(sprintf('/Users/shane/Documents/MATLAB/html/%s/spm_2019Mar07.ps', cur_name), sprintf('/Users/shane/Documents/MATLAB/output/%s.ps',cur_name))

end

%%
for i =1:length(dirOutput)
cur_name=dirOutput(i).name;
movefile(sprintf('/Users/shane/Downloads/%s.pdf', cur_name), sprintf('/Users/shane/Documents/MATLAB/new/%s.pdf',cur_name))

end
%% 
for i=1:length(dirOutput)
figure;
pat=dirOutput(i).name;
text(0.3, 0.5, pat,'fontsize',30);
axis off;
filename=[pat,'_1.pdf'];
saveas(gcf,filename)

end

%% 移动preprocess出去
% for i =1:length(dirOutput)
% cur_name=dirOutput(i).name;
% % movefile(sprintf('/Users/shane/Downloads/%s.pdf', cur_name), sprintf('/Users/shane/Documents/MATLAB/new/%s.pdf',cur_name))
% % file=['/Volumes/Others/HW/HW_preprocess/',cur_name,sprintf('sc2c1meanaHRF_%s_S0001.nii',cur_name)];
% file=sprintf('/Volumes/Others/HW/HW_preprocess/%s/sc2c1raHRF_%s_S0001.nii',cur_name,cur_name);
% copyfile(file,'/Volumes/Others/1_preprocess_after_smooth')
% 
% end


