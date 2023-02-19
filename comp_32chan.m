function Isig=comp_32chan(msk);

[file,path] = uigetfile('*.tif');
t=Tiff([path,file]);
I=read(t);
[file,path] = uigetfile('*.tif');
t=Tiff([path,file]);
I2=read(t);

% Rotate I, I2
figure
imshow(I);
[x,y]=ginput;
theta=atan((y(2)-y(1))/(x(2)-x(1)))*180/pi;
Irot=imrotate(I,theta);
I2rot=imrotate(I2,theta);

% Identify horizontal boundary shift and then a vertical boundary shift matching points on BF images
figure
imshow(Irot);
[xi,yi]=ginput;

figure
imshow(msk)
[x,y]=ginput;


% shift Irot + Jrot to match mask 
shift_coord=[x-xi y-yi];
Irot_sh=imtranslate(Irot,shift_coord);
I2rot_sh=imtranslate(I2rot,shift_coord);

close all
figure
Ic=imfuse(Irot_sh,msk);
imshow(Ic);

cc=bwconncomp(msk);

segments=cc.PixelIdxList(2:47);
[seg_x,seg_y]=cellfun(@(x) ind2sub(size(msk),x),segments,'UniformOutput',false);
seg_pix=cellfun(@(x,y) sub2ind(size(I2rot_sh),y,x),seg_y,seg_x,'UniformOutput',false);
Isig=cellfun(@(x) I2rot_sh(x),seg_pix,'UniformOutput',false);


end