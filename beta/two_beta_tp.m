prefix='/Volumes/Others/2_temporal_ICA_output';

pri_vis_cortex_tp=zeros(1,6);
vis_cortex_tp=zeros(1,6);
out_vis_cortex_tp=zeros(1,6);

pri_audio_cortex_tp=zeros(1,6);
out_pri_audio_cortex_tp=zeros(1,6);

pri_motor_cortex_tp=zeros(1,6);
out_pri_motor_cortex_tp=zeros(1,6);

T=[1.97,2.34,2.60,2.84,3.14,3.35];
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

visual_T=load_nii([prefix, '/2nd_visual/spmT_0001.nii']);
visual_T=visual_T.img;
audio_T=load_nii([prefix,'/2nd_audio/spmT_0001.nii']);
audio_T=audio_T.img;
motion_T=load_nii([prefix,'/2nd_motion/spmT_0001.nii']);
motion_T=motion_T.img;

visual=load_nii([prefix, '/2nd_visual/beta_0001.nii']);
visual=visual.img;
visual(isnan(visual))=0;
audio=load_nii([prefix,'/2nd_audio/beta_0001.nii']);
audio=audio.img;
audio(isnan(audio))=0;
motion=load_nii([prefix,'/2nd_motion/beta_0001.nii']);
motion=motion.img;
motion(isnan(motion))=0;

for j=1:6
    t=T(j);
    
    pri_vis_cortex_mask = imbinarize(pri_vis_cortex.*visual_T,t);
    pri_vis_cortex_beta=pri_vis_cortex_mask.*visual;
%     pri_vis_cortex_beta=sum(pri_vis_cortex_beta(:))/length(find(pri_vis_cortex_mask~=0));
    pri_vis_cortex_beta=median(pri_vis_cortex_beta(pri_vis_cortex_beta~=0));%%%%%%%%
    
    vis_cortex_mask = imbinarize(vis_cortex.*visual_T,t);
    vis_cortex_beta=vis_cortex_mask.*visual;
    vis_cortex_beta=sum(vis_cortex_beta(:))/length(find(vis_cortex_mask~=0));
    
    out_vis_cortex_mask = imbinarize(out_vis_cortex.*visual_T,t);
    out_vis_cortex_beta=out_vis_cortex_mask.*visual;
    out_vis_cortex_beta=sum(out_vis_cortex_beta(:))/length(find(out_vis_cortex_mask~=0));
    
    
    pri_audio_cortex_mask = imbinarize(pri_audio_cortex.*audio_T,t);
    pri_audio_cortex_beta=pri_audio_cortex_mask.*audio;
%     pri_audio_cortex_beta=sum(pri_audio_cortex_beta(:))/length(find(pri_audio_cortex_mask~=0));
    pri_audio_cortex_beta=median(pri_audio_cortex_beta(pri_audio_cortex_beta~=0));%%%%%%%%
    
    out_pri_audio_cortex_mask = imbinarize(out_pri_audio_cortex.*audio_T,t);
    out_pri_audio_cortex_beta=out_pri_audio_cortex_mask.*audio;
    out_pri_audio_cortex_beta=sum(out_pri_audio_cortex_beta(:))/length(find(out_pri_audio_cortex_mask~=0));
    
    
    pri_motor_cortex_mask = imbinarize(pri_motor_cortex.*motion_T,t);
    pri_motor_cortex_beta=pri_motor_cortex_mask.*motion;
%     pri_motor_cortex_beta=sum(pri_motor_cortex_beta(:))/length(find(pri_motor_cortex_mask~=0));
    pri_motor_cortex_beta=median(pri_motor_cortex_beta(pri_motor_cortex_beta~=0));%%%%%%%%
    
    out_pri_motor_cortex_mask = imbinarize(out_pri_motor_cortex.*motion_T,t);
    out_pri_motor_cortex_beta=out_pri_motor_cortex_mask.*motion;
    out_pri_motor_cortex_beta=sum(out_pri_motor_cortex_beta(:))/length(find(out_pri_motor_cortex_mask~=0));
    
    pri_vis_cortex_tp(1,j)        = pri_vis_cortex_beta;
    vis_cortex_tp(1,j)            = vis_cortex_beta;
    out_vis_cortex_tp(1,j)        = out_vis_cortex_beta;
    pri_audio_cortex_tp(1,j)      = pri_audio_cortex_beta;
    out_pri_audio_cortex_tp(1,j)  = out_pri_audio_cortex_beta;
    pri_motor_cortex_tp(1,j)      = pri_motor_cortex_beta;
    out_pri_motor_cortex_tp(1,j)  = out_pri_motor_cortex_beta;
    
end