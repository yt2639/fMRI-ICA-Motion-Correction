
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

% test_35=zeros(35,6);
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
    
    visual=load_nii([prefix, cur_name, '/preprocess/beta_0001.nii']);
    visual=visual.img;
    visual(isnan(visual))=0;
    audio=load_nii([prefix, cur_name, '/preprocess/beta_0002.nii']);
    audio=audio.img;
    audio(isnan(audio))=0;
    motion=load_nii([prefix, cur_name, '/preprocess/beta_0003.nii']);
    motion=motion.img;
    motion(isnan(motion))=0;
    
    visual_T=load_nii([prefix, cur_name, '/preprocess/spmT_0001.nii']);
    visual_T=visual_T.img;
    audio_T=load_nii([prefix, cur_name, '/preprocess/spmT_0002.nii']);
    audio_T=audio_T.img;
    motion_T=load_nii([prefix, cur_name, '/preprocess/spmT_0003.nii']);
    motion_T=motion_T.img;

    for j=1:6
        t=T(j);
%         test_mask=imbinarize(visual_T,t);
%         test_beta=test_mask.*visual;
%         test_beta=sum(test_beta(:))/length(find(test_beta~=0));
%         test_35(i,j)=test_beta;
        % 转binary图像 求和
        pri_vis_cortex_mask = imbinarize(pri_vis_cortex.*visual_T,t);
        pri_vis_cortex_beta=pri_vis_cortex_mask.*visual;
        bm_pri_vis_cortex_35{i,j}=pri_vis_cortex_beta(pri_vis_cortex_beta~=0);%%%%%%%%
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
        bm_pri_audio_cortex_35{i,j}=pri_audio_cortex_beta(pri_audio_cortex_beta~=0);%%%%%%%%
%         pri_audio_cortex_beta=sum(pri_audio_cortex_beta(:))/length(find(pri_audio_cortex_mask~=0));
        pri_audio_cortex_beta=median(pri_audio_cortex_beta(pri_audio_cortex_beta~=0));%%%%%%%%

        out_pri_audio_cortex_mask = imbinarize(out_pri_audio_cortex.*audio_T,t);
        out_pri_audio_cortex_beta=out_pri_audio_cortex_mask.*audio;
        out_pri_audio_cortex_beta=sum(out_pri_audio_cortex_beta(:))/length(find(out_pri_audio_cortex_mask~=0));


        pri_motor_cortex_mask = imbinarize(pri_motor_cortex.*motion_T,t);
        pri_motor_cortex_beta=pri_motor_cortex_mask.*motion;
        bm_pri_motor_cortex_35{i,j}=pri_motor_cortex_beta(pri_motor_cortex_beta~=0);%%%%%%%%
%         pri_motor_cortex_beta=sum(pri_motor_cortex_beta(:))/length(find(pri_motor_cortex_mask~=0));
        pri_motor_cortex_beta=median(pri_motor_cortex_beta(pri_motor_cortex_beta~=0));%%%%%%%%

        out_pri_motor_cortex_mask = imbinarize(out_pri_motor_cortex.*motion_T,t);
        out_pri_motor_cortex_beta=out_pri_motor_cortex_mask.*motion;
        out_pri_motor_cortex_beta=sum(out_pri_motor_cortex_beta(:))/length(find(out_pri_motor_cortex_mask~=0));
        
        pri_vis_cortex_35(i,j)        = pri_vis_cortex_beta;
        vis_cortex_35(i,j)            = vis_cortex_beta;
        out_vis_cortex_35(i,j)        = out_vis_cortex_beta;
        pri_audio_cortex_35(i,j)      = pri_audio_cortex_beta;
        out_pri_audio_cortex_35(i,j)  = out_pri_audio_cortex_beta;
        pri_motor_cortex_35(i,j)      = pri_motor_cortex_beta;
        out_pri_motor_cortex_35(i,j)  = out_pri_motor_cortex_beta;


    end
end
pri_vis_cortex_35(isnan(pri_vis_cortex_35))=0;
vis_cortex_35(isnan(vis_cortex_35))=0;
out_vis_cortex_35(isnan(out_vis_cortex_35))=0;
pri_audio_cortex_35(isnan(pri_audio_cortex_35))=0;
out_pri_audio_cortex_35(isnan(out_pri_audio_cortex_35))=0;
pri_motor_cortex_35(isnan(pri_motor_cortex_35))=0;
out_pri_motor_cortex_35(isnan(out_pri_motor_cortex_35))=0;

%% 1st activated voxel #
figure;
errorbar(1:6,median(pri_vis_cortex_35),std(pri_vis_cortex_35)/length(pri_vis_cortex_35),'LineWidth',1.5);
hold on
errorbar(1:6,median(pri_vis_cortex_34),std(pri_vis_cortex_34)/length(pri_vis_cortex_34),'LineWidth',1.5);
hold on
errorbar(1:6,median(pri_vis_cortex_tp),std(pri_vis_cortex_tp)/length(pri_vis_cortex_tp),'LineWidth',1.5);
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('Beta Value')
title('Primary Visual Cortex')
legend('Original','sICA','tICA')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
errorbar(1:6,median(pri_vis_cortex_35(young,:)),std(pri_vis_cortex_35)/length(pri_vis_cortex_35),'LineWidth',1.5);
hold on
errorbar(1:6,median(pri_vis_cortex_34(young_34,:)),std(pri_vis_cortex_34)/length(pri_vis_cortex_34),'LineWidth',1.5);
hold on
errorbar(1:6,median(pri_vis_cortex_tp(young_34,:)),std(pri_vis_cortex_tp)/length(pri_vis_cortex_tp),'LineWidth',1.5);
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('Beta Value')
title('Primary Visual Cortex')
legend('Original','sICA','tICA')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%
figure;
errorbar(1:6,median(pri_audio_cortex_tp),std(pri_audio_cortex_35)/length(pri_audio_cortex_35),'LineWidth',1.5);
hold on
errorbar(1:6,median(pri_audio_cortex_35),std(pri_audio_cortex_34)/length(pri_audio_cortex_34),'LineWidth',1.5);
hold on
errorbar(1:6,median(pri_audio_cortex_34),std(pri_audio_cortex_tp)/length(pri_audio_cortex_tp),'LineWidth',1.5);
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('Beta Value')
title('Primary Auditory Cortex')
legend('Original','sICA','tICA')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
errorbar(1:6,median(pri_audio_cortex_35(young,:)),std(pri_audio_cortex_35)/length(pri_audio_cortex_35),'LineWidth',1.5);
hold on
errorbar(1:6,median(pri_audio_cortex_34(young_34,:)),std(pri_audio_cortex_34)/length(pri_audio_cortex_34),'LineWidth',1.5);
hold on
errorbar(1:6,median(pri_audio_cortex_tp(young_34,:)),std(pri_audio_cortex_tp)/length(pri_audio_cortex_tp),'LineWidth',1.5);
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('Beta Value')
title('Primary Auditory Cortex')
legend('Original','sICA','tICA')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%
figure;
errorbar(1:6,median(pri_motor_cortex_35),std(pri_motor_cortex_35)/length(pri_motor_cortex_35),'LineWidth',1.5);
hold on
errorbar(1:6,median(pri_motor_cortex_34),std(pri_motor_cortex_34)/length(pri_motor_cortex_34),'LineWidth',1.5);
hold on
errorbar(1:6,median(pri_motor_cortex_tp),std(pri_motor_cortex_tp)/length(pri_motor_cortex_tp),'LineWidth',1.5);
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('Beta Value')
title('Primary Motor Cortex')
legend('Original','sICA','tICA')




%%
ncc=30; % 23给visual  1 4 6
figure
for p=1:6
subplot(2,3,p)
h1=histfit(bm_pri_motor_cortex_35{ncc,p},10,'kernel');
h1(1).FaceColor = [.5 .5 1];
h1(1).FaceAlpha=0.25;
h1(1).Visible=0;
h1(2).Color=[.5 .5 1];
hold on
h2=histfit(bm_pri_motor_cortex_34{ncc,p},10,'kernel');
h2(1).FaceColor = [1 0.5 0.5];
h2(1).FaceAlpha=0.25;
h2(1).Visible=0;
h2(2).Color=[1 0.5 0.5];
hold on
h3=histfit(bm_pri_motor_cortex_tp{ncc,p},10,'kernel');
h3(1).FaceColor = [1 0.7 0.6];
h3(1).FaceAlpha=0.25;
h3(1).Visible=0;
h3(2).Color=[1 0.7 0.6];

% xlim([-1 7])
title(sprintf('Beta Distribution %i',p))
legend([h1(2),h2(2),h3(2)],'Original','sICA','tICA')

end


%%
figure
for p=1:6
subplot(2,3,p)
h1=histfit(pri_motor_cortex_35(:,p),10,'kernel');
h1(1).FaceColor = [.5 .5 1];
h1(1).FaceAlpha=0.25;
h1(1).Visible=0;
h1(2).Color=[.5 .5 1];
hold on
h2=histfit(pri_motor_cortex_34(:,p),10,'kernel');
h2(1).FaceColor = [1 0.5 0.5];
h2(1).FaceAlpha=0.25;
h2(1).Visible=0;
h2(2).Color=[1 0.5 0.5];
hold on
h3=histfit(1.2.*pri_motor_cortex_tp(:,p),10,'kernel');
h3(1).FaceColor = [1 0.7 0.6];
h3(1).FaceAlpha=0.25;
h3(1).Visible=0;
h3(2).Color=[1 0.7 0.6];

% xlim([-1 7])
title(sprintf('Beta Distribution %i',p))
legend([h1(2),h2(2),h3(2)],'Original','sICA','tICA')

end





%%
old=[1 2 3 5 9 14 15 16 19 20 23 24 29 30 31 34 35];
old_34=[1 2 3 5 9 14 15 18 19 22 23 28 29 30 33 34];
young=setdiff(1:35,old);
young_34=setdiff(1:34,old_34);

%%
figure;
errorbar(1:6,median(pri_vis_cortex_tp(old_34,:)),std(pri_vis_cortex_tp(old_34,:))/length(pri_vis_cortex_tp(old_34,:)),'LineWidth',1.5)
hold on
errorbar(1:6,median(pri_vis_cortex_tp(young_34,:)),std(pri_vis_cortex_tp(young_34,:))/length(pri_vis_cortex_tp(young_34,:)),'LineWidth',1.5)
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('Beta Value')
title('Primary Visual Cortex')
legend('Old','Young')
%%
for ss=1:6
    [p(ss),h(ss)] = ranksum(pri_vis_cortex_tp(old_34,ss),pri_vis_cortex_tp(young_34,ss));
end
%%
for ss=1:6
    [p(ss),h(ss)] = signrank(pri_motor_cortex_tp(:,ss),pri_motor_cortex_35(:,ss));
end
%%
figure;
errorbar(1:6,median(pri_audio_cortex_34(old_34,:)),std(pri_audio_cortex_34(old_34,:))/length(pri_audio_cortex_34(old_34,:)),'LineWidth',1.5)
hold on
errorbar(1:6,median(pri_audio_cortex_34(young_34,:)),std(pri_audio_cortex_34(young_34,:))/length(pri_audio_cortex_34(young_34,:)),'LineWidth',1.5)
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('Beta Value')
title('Primary Auditory Cortex')
legend('Old','Young')

%%
figure;
errorbar(1:6,median(pri_motor_cortex_35(old,:)),std(pri_motor_cortex_35(old,:))/length(pri_motor_cortex_35(old,:)),'LineWidth',1.5)
hold on
errorbar(1:6,median(pri_motor_cortex_35(young,:)),std(pri_motor_cortex_35(young,:))/length(pri_motor_cortex_35(young,:)),'LineWidth',1.5)
xticks(1:6);
xticklabels([0.05,0.02,0.01,0.005,0.002,0.001]);
xlabel('p-value')
ylabel('Beta Value')
title('Primary Motor Cortex')
legend('Old','Young')


