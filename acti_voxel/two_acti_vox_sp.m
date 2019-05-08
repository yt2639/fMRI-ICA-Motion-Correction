prefix='/Volumes/Others/2_temporal_ICA_output';

pri_vis_cortex_34=zeros(1,6);
vis_cortex_34=zeros(1,6);
out_vis_cortex_34=zeros(1,6);

pri_audio_cortex_34=zeros(1,6);
out_pri_audio_cortex_34=zeros(1,6);

pri_motor_cortex_34=zeros(1,6);
out_pri_motor_cortex_34=zeros(1,6);

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

visual=load_nii([prefix, '/2nd_visual/spmT_0001.nii']);
visual=visual.img;
audio=load_nii([prefix,'/2nd_audio/spmT_0001.nii']);
audio=audio.img;
motion=load_nii([prefix,'/2nd_motion/spmT_0001.nii']);
motion=motion.img;

for j=1:6
    t=T(j);
    
    pri_vis_cortex_bi = imbinarize(pri_vis_cortex.*visual,t);
    pri_vis_cortex_count=sum(pri_vis_cortex_bi(:));
    vis_cortex_bi = imbinarize(vis_cortex.*visual,t);
    vis_cortex_count=sum(vis_cortex_bi(:));
    out_vis_cortex_bi = imbinarize(out_vis_cortex.*visual,t);
    out_vis_cortex_count=sum(out_vis_cortex_bi(:));
    
    pri_audio_cortex_bi = imbinarize(pri_audio_cortex.*audio,t);
    pri_audio_cortex_count=sum(pri_audio_cortex_bi(:));
    out_pri_audio_cortex_bi = imbinarize(out_pri_audio_cortex.*audio,t);
    out_pri_audio_cortex_count=sum(out_pri_audio_cortex_bi(:));

    
    pri_motor_cortex_bi = imbinarize(pri_motor_cortex.*motion,t);
    pri_motor_cortex_count=sum(pri_motor_cortex_bi(:));
    out_pri_motor_cortex_bi = imbinarize(out_pri_motor_cortex.*motion,t);
    out_pri_motor_cortex_count=sum(out_pri_motor_cortex_bi(:));
    
    pri_vis_cortex_34(1,j)        = pri_vis_cortex_count;
    vis_cortex_34(1,j)            = vis_cortex_count;
    out_vis_cortex_34(1,j)        = out_vis_cortex_count;
    pri_audio_cortex_34(1,j)      = pri_audio_cortex_count;
    out_pri_audio_cortex_34(1,j)  = out_pri_audio_cortex_count;
    pri_motor_cortex_34(1,j)      = pri_motor_cortex_count;
    out_pri_motor_cortex_34(1,j)  = out_pri_motor_cortex_count;
    
end