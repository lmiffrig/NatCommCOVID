function Cells_loc=ChanInt(FramesCrop);

tic
% determine the boundaries by selecting the top of the first channel
figure
imshow(FramesCrop(:,:,1))
title('Select multiple points along the upper boundary of the top channel');
[~,y]=ginput; 
yInlet=[y y+[35.9690721649486,76.4342783505156,113.902061855670,152.868556701031,190.336340206186,226.305412371134,266.770618556701,307.235824742268,340.207474226804,377.675257731959,416.641752577320,454.109536082474,496.073453608248,532.042525773196,572.507731958763,609.975515463918,645.944587628866,681.913659793815,723.877577319588,758.347938144330,798.813144329897,834.782216494845,872.250000000000,912.715206185567,953.180412371134,990.648195876289,1025.11855670103,1065.58376288660,1103.05154639175]];
hold on
scatter(repmat(mean(size(FramesCrop,2)),[length(yInlet) 1]),yInlet,'r','filled')

% create series of evenly spaced boxes to detect passing cell along length
% of channel

% define vector for the LH x position (column index) for each nox to check for cell passing throug 
Lchan=size(FramesCrop,2);
boxsize=11;

numbox=floor(Lchan/15);

yInlet=round(yInlet);

%define indices included in each box for the first channel

[XX,YY]=meshgrid(1:boxsize,1:boxsize);
col = reshape(XX,[1 boxsize^2]);
sz= [size(FramesCrop,1), size(FramesCrop,2)];

% define indices for the remainder of the boxes, row position (yInlet)
% remains the same (defined in the for loop), but column position (x coordinate) should move by the
% box size 

col=repmat(col,numbox,1);
vec=([(1:numbox)-1]*boxsize).';
col= col + repmat(vec,1,size(col,2));

meanInt=zeros(length(yInlet),numbox,size(FramesCrop,3));
cellTrack={}

pts=[];
for i=1:length(yInlet);
row = repmat(yInlet(i):(yInlet(i)+(boxsize-1)),numbox,boxsize);
boxInd=reshape(sub2ind(sz,row(:),col(:)),size(col));
    for j=1:numbox
        for t=1:size(FramesCrop,3);
            frame=FramesCrop(:,:,t);
            meanInt(i,j,t)=mean(frame(boxInd(j,:)));
        end
        pts=squeeze(meanInt(i,j,:));
        pts(pts>(mean(pts)-3*std(pts)))=mean(pts);
        Cells_loc(i,j,:)=islocalmin(pts);
    end  
end

toc

end
