function [FramesCrop, frRate]=CropRot

[file,path] = uigetfile('*.avi');
vidObj = VideoReader([path, file]);
vidFrames = read(vidObj,[1 Inf]);
vidFrames = squeeze(vidFrames(:,:,1,:));

% rotate image, allow user to select two symmetric device points, first on
% the left and then on the right
figure
imshow(vidFrames(:,:,1));
title('Choose two symmetric points on the left and right sides of the device');
[x,y]=ginput;
theta=atan((y(2)-y(1))/(x(2)-x(1)))*180/pi;
FramesRot=imrotate(vidFrames,theta);

% allow user to crop to the center channels, ideally they would exclude the
% black padding from the image rotatoin and set the horizontal cropped
% image so that edges are touching the center channel bifurcations
figure
imshow(FramesRot(:,:,1))
title('Draw rectangle around central channels, double click when satisfied');
[~,rectout]=imcrop;

% crop images
FramesCrop=FramesRot(rectout(2):rectout(2)+rectout(4)-1, rectout(1):rectout(1)+rectout(3)-1, :);
FramesCrop=FramesCrop(:,round(0.05*size(FramesCrop,2)):round(0.95*size(FramesCrop,2)),:);

frRate=vidObj.FrameRate;


end