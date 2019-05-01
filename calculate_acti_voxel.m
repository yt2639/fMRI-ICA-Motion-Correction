%%
visual=load_nii('/Volumes/Others/Final_project/2nd_visual/con_0001.nii');
visual=visual.img;
%% 没什么用 画个图看了一下
[X,Y,Z]=meshgrid(1:91,1:109,1:91);
figure
scatter3(X(:),Y(:),Z(:),91,visual(:))

%% Atlas不会用？？？？


%% 转binary图像 求和

BW = imbinarize(visual,0);
sum(BW(:))





