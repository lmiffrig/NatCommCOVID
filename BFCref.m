function [velref,DistTime] = BFCref
tic
[file,path] = uigetfile('*.avi');
vidObj = VideoReader([path, file]);
vidFrames = read(vidObj,[1 Inf]);
vidFrames = squeeze(vidFrames(:,:,1,:));

DistTime=[];
x=[];
y=[];
for i=1:size(vidFrames,3)
    figure
    imshow(vidFrames(:,:,i));
    [x,y]=ginput;
    if ~isempty(x) 
        DistTime=[DistTime; x y i];
    end
    clear x
    clear y
    close all
end
    
if rem(size(DistTime,1),2)==1;
    DistTime=DistTime(1:(end-1),:);
end

DispTime=[((DistTime(1:2:(end-1),1)-DistTime(2:2:end,1)).^2+(DistTime(1:2:(end-1),2)-DistTime(2:2:end,2)).^2).^0.5 DistTime(2:2:end,3)-DistTime(1:2:(end-1),3)];
velref=DispTime(:,1).*40*5.86./(20*DispTime(:,2));
toc
end