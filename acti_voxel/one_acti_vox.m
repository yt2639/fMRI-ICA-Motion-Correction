
fileFolder=fullfile('/Volumes/Others/Final_project');
dirOutput=dir(fullfile(fileFolder,'P*'));
prefix='/Volumes/Others/Final_project/';
pri_vis_cortex_35=zeros(35,6);
vis_cortex_35=zeros(35,6);
out_vis_cortex_35=zeros(35,6);
pri_audio_cortex_35=zeros(35,6);
out_pri_audio_cortex_35=zeros(35,6);
pri_motor_cortex_35=zeros(35,6);
out_pri_motor_cortex_35=zeros(35,6);
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

%%
for i=1:35
    cur_name=dirOutput(i).name;
    
    visual=load_nii([prefix, cur_name, '/preprocess/spmT_0001.nii']);
    visual=visual.img;
    audio=load_nii([prefix, cur_name, '/preprocess/spmT_0002.nii']);
    audio=audio.img;
    motion=load_nii([prefix, cur_name, '/preprocess/spmT_0003.nii']);
    motion=motion.img;
    
    % %% 没什么用 画个图看了一下
    % [X,Y,Z]=meshgrid(1:91,1:109,1:91);
    % figure
    % scatter3(X(:),Y(:),Z(:),91,visual(:));colorbar
    
% t=1.97; % p<0.05
    for j=1:6
        t=T(j);
        % 转binary图像 求和
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
        
        pri_vis_cortex_35(i,j)        = pri_vis_cortex_count;
        vis_cortex_35(i,j)            = vis_cortex_count;
        out_vis_cortex_35(i,j)        = out_vis_cortex_count;
        pri_audio_cortex_35(i,j)      = pri_audio_cortex_count;
        out_pri_audio_cortex_35(i,j)  = out_pri_audio_cortex_count;
        pri_motor_cortex_35(i,j)      = pri_motor_cortex_count;
        out_pri_motor_cortex_35(i,j)  = out_pri_motor_cortex_count;


    end
end
%%%%%%%%%%
%%
pri_vis_cortex_35(3,:)=[];
pri_vis_cortex_34([3 33],:)=[];
pri_vis_cortex_tp([3 33],:)=[];

%%%%%%%%%%
%% 1st activated voxel #
figure;
errorbar(1:6,mean(pri_vis_cortex_35),std(pri_vis_cortex_35)/length(pri_vis_cortex_35),'LineWidth',1.5);
hold on
errorbar(1:6,mean(pri_vis_cortex_34),std(pri_vis_cortex_34)/length(pri_vis_cortex_34),'LineWidth',1.5);
hold on
errorbar(1:6,mean(pri_vis_cortex_tp),std(pri_vis_cortex_tp)/length(pri_vis_cortex_tp),'LineWidth',1.5);
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('# of activated voxels')
title('Primary Visual Cortex')
legend('Original','sICA','tICA')
%%
figure;
errorbar(1:6,mean(vis_cortex_35),std(vis_cortex_35)/length(vis_cortex_35),'LineWidth',1.5);
hold on
errorbar(1:6,mean(vis_cortex_34),std(vis_cortex_34)/length(vis_cortex_34),'LineWidth',1.5);
hold on
errorbar(1:6,mean(vis_cortex_tp),std(vis_cortex_tp)/length(vis_cortex_tp),'LineWidth',1.5);
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('# of activated voxels')
title('Visual Cortex')
legend('Original','sICA','tICA')
%%
figure;
errorbar(1:6,mean(out_vis_cortex_35),std(out_vis_cortex_35)/length(out_vis_cortex_35),'LineWidth',1.5);
hold on
errorbar(1:6,mean(out_vis_cortex_34),std(out_vis_cortex_34)/length(out_vis_cortex_34),'LineWidth',1.5);
hold on
errorbar(1:6,mean(out_vis_cortex_tp),std(out_vis_cortex_tp)/length(out_vis_cortex_tp),'LineWidth',1.5);
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('# of activated voxels')
title('Outside Visual Cortex')
legend('Original','sICA','tICA')



%%
figure;
errorbar(1:6,mean(pri_audio_cortex_35),std(pri_audio_cortex_35)/length(pri_audio_cortex_35),'LineWidth',1.5);
hold on
errorbar(1:6,mean(pri_audio_cortex_34),std(pri_audio_cortex_34)/length(pri_audio_cortex_34),'LineWidth',1.5);
hold on
errorbar(1:6,mean(pri_audio_cortex_tp),std(pri_audio_cortex_tp)/length(pri_audio_cortex_tp),'LineWidth',1.5);
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('# of activated voxels')
title('Primary Auditory Cortex')
legend('Original','sICA','tICA')
%%
figure;
errorbar(1:6,mean(out_pri_audio_cortex_35),std(out_pri_audio_cortex_35)/length(out_pri_audio_cortex_35),'LineWidth',1.5);
hold on
errorbar(1:6,mean(out_pri_audio_cortex_34),std(out_pri_audio_cortex_34)/length(out_pri_audio_cortex_34),'LineWidth',1.5);
hold on
errorbar(1:6,median(out_pri_audio_cortex_tp),std(out_pri_audio_cortex_tp)/length(out_pri_audio_cortex_tp),'LineWidth',1.5);
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('# of activated voxels')
title('Outside Primary Auditory Cortex')
legend('Original','sICA','tICA')



%%
figure;
errorbar(1:6,mean(pri_motor_cortex_35),std(pri_motor_cortex_35)/length(pri_motor_cortex_35),'LineWidth',1.5);
hold on
errorbar(1:6,mean(pri_motor_cortex_34),std(pri_motor_cortex_34)/length(pri_motor_cortex_34),'LineWidth',1.5);
hold on
errorbar(1:6,mean(pri_motor_cortex_tp),std(pri_motor_cortex_tp)/length(pri_motor_cortex_tp),'LineWidth',1.5);
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('# of activated voxels')
title('Primary Motor Cortex')
legend('Original','sICA','tICA')
%%
figure;
errorbar(1:6,median(out_pri_motor_cortex_35),std(out_pri_motor_cortex_35)/length(out_pri_motor_cortex_35),'LineWidth',1.5);
hold on
errorbar(1:6,median(out_pri_motor_cortex_34),std(out_pri_motor_cortex_34)/length(out_pri_motor_cortex_34),'LineWidth',1.5);
hold on
errorbar(1:6,median(out_pri_motor_cortex_tp),std(out_pri_motor_cortex_tp)/length(out_pri_motor_cortex_tp),'LineWidth',1.5);
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('# of activated voxels')
title('Outside Primary Motor Cortex')
legend('Original','sICA','tICA')





%%
old=[1 2 3 5 9 14 15 16 19 20 23 24 29 30 31 34 35];
old_34=[1 2 3 5 9 14 15 18 19 22 23 28 29 30 33 34];
young=setdiff(1:35,old);
young_34=setdiff(1:34,old_34);

%%
figure;
errorbar(1:6,mean(pri_vis_cortex_tp(old_34,:)),std(pri_vis_cortex_tp(old_34,:))/length(pri_vis_cortex_tp(old_34,:)),'LineWidth',1.5)
hold on
errorbar(1:6,mean(pri_vis_cortex_tp(young_34,:)),std(pri_vis_cortex_tp(young_34,:))/length(pri_vis_cortex_tp(young_34,:)),'LineWidth',1.5)
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('# of activated voxels')
title('Primary Visual Cortex')
legend('Old','Young')

%%
figure;
errorbar(1:6,mean(pri_audio_cortex_34(old_34,:)),std(pri_audio_cortex_34(old_34,:))/length(pri_audio_cortex_34(old_34,:)),'LineWidth',1.5)
hold on
errorbar(1:6,mean(pri_audio_cortex_34(young_34,:)),std(pri_audio_cortex_34(young_34,:))/length(pri_audio_cortex_34(young_34,:)),'LineWidth',1.5)
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('# of activated voxels')
title('Primary Auditory Cortex')
legend('Old','Young')

%%
figure;
errorbar(1:6,mean(pri_motor_cortex_35(old,:)),std(pri_motor_cortex_35(old,:))/length(pri_motor_cortex_35(old,:)),'LineWidth',1.5)
hold on
errorbar(1:6,mean(pri_motor_cortex_35(young,:)),std(pri_motor_cortex_35(young,:))/length(pri_motor_cortex_35(young,:)),'LineWidth',1.5)
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('# of activated voxels')
title('Primary Motor Cortex')
legend('Old','Young')


%%
for ss=1:6
    [p(ss),h(ss)] = ranksum(pri_motor_cortex_35(old,ss),pri_motor_cortex_35(young,ss));
end
%%
for ss=1:6
    [p(ss),h(ss)] = signrank(pri_motor_cortex_34(:,ss),pri_motor_cortex_35(:,ss));
end




