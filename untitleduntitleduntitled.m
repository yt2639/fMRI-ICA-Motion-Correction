fileFolder=fullfile('/Volumes/Others/Final_project');
dirOutput=dir(fullfile(fileFolder,'P*'));
dir_pre='/Volumes/Others/Final_project';

for i = 1:35
mkdir([dir_pre, '/', dirOutput(i).name, '/', 'preprocess'])
end

%%
fileFolder=fullfile('/Volumes/Others/Final_project');
dirOutput=dir(fullfile(fileFolder,'P*'));
dir_pre='/Volumes/Others/2_spatial_ICA_output';

for i = 1:35
mkdir([dir_pre, '/', dirOutput(i).name, '/', 'after_motion_correction/results'])
end

%%
var=cell(35,1);
for i=1:35
    var{i}=sprintf('s%i',i);
    
end
var=var';

%%
% textscan('/Volumes/Others/Final_project/P00001614/rp_aHRF_P00001614_S0001.txt','%s')

filename=fullfile('/Users/shane/Desktop/rp_aHRF_P00001614_S0001.txt');
fileID = fopen(filename);
C = textscan(fileID,'%f %f %f %f %f %f');
fclose(fileID);
motion=cell2mat(C);
cfg.motionparam=motion;
cfg.prepro_suite='SPM';
cfg.radius=50;

fwd = framewise_displacement(cfg);
fwd_self=fd_self_construct(motion);

%%
figure
plot(t,fwd)
hold on
plot(t,fwd_self,'LineWidth',1.5)
legend

%%
TR_value=2;
for i=1:35
    network_paths{i}=['/Volumes/Others/2_spatial_ICA_output/P00001614/1614_sub01_component_ica_s1_.nii,',sprintf('%i',i)];
end
for i=1:35
    timeseries_paths{i}=['/Volumes/Others/2_spatial_ICA_output/P00001614/1614_sub01_timecourses_ica_s1_.nii,',sprintf('%i',i)];
end

varargin={'yes','/Volumes/Others/Spatial_Map',0};

[features_norm, feature_labels] = noisecloud(TR_value, network_paths, timeseries_paths, varargin);


%%
load('/Volumes/Others/2_spatial_ICA_output/P00001614/after_motion_correction/SPM_scra_motion/SPM.mat');
design_matrix=SPM.xX.X;

beta1=load_nii('/Volumes/Others/2_spatial_ICA_output/P00001614/after_motion_correction/SPM_scra_motion/beta_0001.nii');
beta1=beta1.img;

beta2=load_nii('/Volumes/Others/2_spatial_ICA_output/P00001614/after_motion_correction/SPM_scra_motion/beta_0002.nii');
beta2=beta2.img;

beta3=load_nii('/Volumes/Others/2_spatial_ICA_output/P00001614/after_motion_correction/SPM_scra_motion/beta_0003.nii');
beta3=beta3.img;

beta4=load_nii('/Volumes/Others/2_spatial_ICA_output/P00001614/after_motion_correction/SPM_scra_motion/beta_0004.nii');
beta4=beta4.img;

ori_data=load_nii('/Volumes/Others/Final_project/P00001614/scraHRF_P00001614_S0001.nii');
ori_data=ori_data.img;

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

abc=load_nii('/Volumes/Others/Final_project/P00001614/scraHRF_P00001614_S0001.nii');
abc.img=residual;
save_nii(abc,'/Volumes/Others/2_spatial_ICA_output/P00001614/after_motion_correction/Residual_2.nii');

a=load_nii('/Volumes/Others/2_spatial_ICA_output/P00001614/after_motion_correction/Residual_2.nii');
