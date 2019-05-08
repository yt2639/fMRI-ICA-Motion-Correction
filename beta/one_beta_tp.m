
fileFolder=fullfile('/Volumes/Others/2_temporal_ICA_output');
dirOutput=dir(fullfile(fileFolder,'P*'));
prefix='/Volumes/Others/2_temporal_ICA_output/';
pri_vis_cortex_tp=zeros(34,6);
vis_cortex_tp=zeros(34,6);
out_vis_cortex_tp=zeros(34,6);
pri_audio_cortex_tp=zeros(34,6);
out_pri_audio_cortex_tp=zeros(34,6);
pri_motor_cortex_tp=zeros(34,6);
out_pri_motor_cortex_tp=zeros(34,6);
T=[1.97,2.34,2.60,2.84,3.14,3.35];

% test_tp=zeros(34,6);
%%%% Atlas
pri_vis_cortex=load_nii('/Volumes/Others/brodmann/brodmann_17.nii');
pri_vis_cortex=single(pri_vis_cortex.img);
vis_cortex=load_nii('/Volumes/Others/brodmann/brodmann_17_18_19.nii');
vis_cortex=single(vis_cortex.img);
pri_audio_cortex=load_nii('/Volumes/Others/brodmann/brodmann_41_42.nii');
pri_audio_cortex=single(pri_audio_cortex.img);
pri_motor_cortex=load_nii('/Volumes/Others/brodmann/brodmann_4.nii');
pri_motor_cortex=single(pri_motor_cortex.img);

out_vis_cortex=single(not(vis_cortex));
out_pri_audio_cortex=single(not(pri_audio_cortex));
out_pri_motor_cortex=single(not(pri_motor_cortex));

%%
for i=1:34
    cur_name=dirOutput(i).name;
    
    visual=load_nii([prefix, cur_name, '/after_motion_correction/beta_0001.nii']);
    visual=visual.img;
    visual(isnan(visual))=0;
    audio=load_nii([prefix, cur_name, '/after_motion_correction/beta_0002.nii']);
    audio=audio.img;
    audio(isnan(audio))=0;
    motion=load_nii([prefix, cur_name, '/after_motion_correction/beta_0003.nii']);
    motion=motion.img;
    motion(isnan(motion))=0;
    
    visual_T=load_nii([prefix, cur_name, '/after_motion_correction/spmT_0001.nii']);
    visual_T=visual_T.img;
    audio_T=load_nii([prefix, cur_name, '/after_motion_correction/spmT_0002.nii']);
    audio_T=audio_T.img;
    motion_T=load_nii([prefix, cur_name, '/after_motion_correction/spmT_0003.nii']);
    motion_T=motion_T.img;

    for j=1:6
        t=T(j);
%         test_mask=imbinarize(visual_T,t);
%         test_beta=test_mask.*visual;
%         test_beta=sum(test_beta(:))/length(find(test_beta~=0));
%         test_tp(i,j)=test_beta;
        % 转binary图像 求和
        pri_vis_cortex_mask = imbinarize(pri_vis_cortex.*visual_T,t);
        pri_vis_cortex_beta=pri_vis_cortex_mask.*visual;
        bm_pri_vis_cortex_tp{i,j}=pri_vis_cortex_beta(pri_vis_cortex_beta~=0);%%%%%%%%
%         pri_vis_cortex_beta=sum(pri_vis_cortex_beta(:))/length(find(pri_vis_cortex_mask~=0));
        pri_vis_cortex_beta=median(pri_vis_cortex_beta(pri_vis_cortex_beta~=0));%%%%%%%%

        vis_cortex_mask = imbinarize(vis_cortex.*visual_T,t);
        vis_cortex_beta=vis_cortex_mask.*visual;
        vis_cortex_beta=sum(vis_cortex_beta(:))/length(find(vis_cortex_mask~=0));

        out_vis_cortex_mask = imbinarize(out_vis_cortex.*visual_T,t);
        out_vis_cortex_beta=out_vis_cortex_mask.*visual;
        out_vis_cortex_beta=sum(out_vis_cortex_beta(:))/length(find(out_vis_cortex_mask~=0));


        pri_audio_cortex_mask = imbinarize(pri_audio_cortex.*audio_T,t);
        pri_audio_cortex_beta=pri_audio_cortex_mask.*audio;
        bm_pri_audio_cortex_tp{i,j}=pri_audio_cortex_beta(pri_audio_cortex_beta~=0);%%%%%%%%
%         pri_audio_cortex_beta=sum(pri_audio_cortex_beta(:))/length(find(pri_audio_cortex_mask~=0));
        pri_audio_cortex_beta=median(pri_audio_cortex_beta(pri_audio_cortex_beta~=0));%%%%%%%%

        out_pri_audio_cortex_mask = imbinarize(out_pri_audio_cortex.*audio_T,t);
        out_pri_audio_cortex_beta=out_pri_audio_cortex_mask.*audio;
        out_pri_audio_cortex_beta=sum(out_pri_audio_cortex_beta(:))/length(find(out_pri_audio_cortex_mask~=0));


        pri_motor_cortex_mask = imbinarize(pri_motor_cortex.*motion_T,t);
        pri_motor_cortex_beta=pri_motor_cortex_mask.*motion;
        bm_pri_motor_cortex_tp{i,j}=pri_motor_cortex_beta(pri_motor_cortex_beta~=0);%%%%%%%%
        %         pri_motor_cortex_beta=sum(pri_motor_cortex_beta(:))/length(find(pri_motor_cortex_mask~=0));
        pri_motor_cortex_beta=median(pri_motor_cortex_beta(pri_motor_cortex_beta~=0));%%%%%%%%

        out_pri_motor_cortex_mask = imbinarize(out_pri_motor_cortex.*motion_T,t);
        out_pri_motor_cortex_beta=out_pri_motor_cortex_mask.*motion;
        out_pri_motor_cortex_beta=sum(out_pri_motor_cortex_beta(:))/length(find(out_pri_motor_cortex_mask~=0));
        
        pri_vis_cortex_tp(i,j)        = pri_vis_cortex_beta;
        vis_cortex_tp(i,j)            = vis_cortex_beta;
        out_vis_cortex_tp(i,j)        = out_vis_cortex_beta;
        pri_audio_cortex_tp(i,j)      = pri_audio_cortex_beta;
        out_pri_audio_cortex_tp(i,j)  = out_pri_audio_cortex_beta;
        pri_motor_cortex_tp(i,j)      = pri_motor_cortex_beta;
        out_pri_motor_cortex_tp(i,j)  = out_pri_motor_cortex_beta;


    end
end
pri_vis_cortex_tp(isnan(pri_vis_cortex_tp))=0;
vis_cortex_tp(isnan(vis_cortex_tp))=0;
out_vis_cortex_tp(isnan(out_vis_cortex_tp))=0;
pri_audio_cortex_tp(isnan(pri_audio_cortex_tp))=0;
out_pri_audio_cortex_tp(isnan(out_pri_audio_cortex_tp))=0;
pri_motor_cortex_tp(isnan(pri_motor_cortex_tp))=0;
out_pri_motor_cortex_tp(isnan(out_pri_motor_cortex_tp))=0;

%% 画图
figure;
errorbar(1:6,mean(pri_vis_cortex_tp),std(pri_vis_cortex_tp)/length(pri_vis_cortex_tp));








