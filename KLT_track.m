function [frames,pts_tracked,pt_vel,binned_vels]=KLT_track(mag,tot_bins,tr_time)
%INPUTS:
% dialogue window will open up and a video is selected for analysis
%
% user identifies the axis of rotation by selecting symmetric points at the 
% edge of the image and then defines the relevant area of interest
% 
%
% - mag 
%     microscope magnification factor
% - tot_bins
%     number of bins across the width of the channel to group 
% - tr_time
%     the length of time in seconds that a point needs to be tracked across
%     to be considered valid

[frames,frameRate]=CropRot;

framesTr=round(frameRate*tr_time);

vec=1:framesTr:size(frames,3);


for t=1:(length(vec)-1)
    tic
    % create frame set from video
    vidKLT=frames(:,:,vec(t):vec(t+1));

    % define initial frame via cropped region from above
    initialFrame=vidKLT(:,:,1);

    % points to be tracked on initial image
    trackedPoints=detectMinEigenFeatures(initialFrame);
    points=trackedPoints.Location;
      
    
    % initialize parameters for tracking with point tracker set to look
    % forwards and backwards with highest threshold for validity 
    pointTracker=vision.PointTracker('MaxBidirectionalError',3);

    validity{t}(:,1)=ones(size(points,1),1);

    initialize(pointTracker,points(:,:,1),initialFrame);
        % loop through frames and track point location and validity
        for nframe=2:framesTr
             trackedFrame=vidKLT(:,:,nframe);
             [points(:,:,nframe),validity{t}(:,nframe)]=step(pointTracker,trackedFrame);
        end
    
    % store all tracked points who have at least framesTr valid tracked frames
    pts_tracked{t}=points((sum(validity{t},2)==framesTr),:,:);    
    % reset all variables
    clearvars vidKLT initialFrame trackedPoints pts idx points pointTracker validity
    toc
end

disp=cellfun(@(x) ((x(:,1,end)-x(:,1,1)).^2+(x(:,2,end)-x(:,2,1)).^2).^0.5,pts_tracked,'UniformOutput',false); % displacement in pixels
if mag==4
    conv = 0.52; % pixels/um
elseif mag==10
    conv = 1.29;
elseif mag==20
    conv = 2.57;
elseif mag==40
    conv = 5.16;
end

vels=cellfun(@(x) x*frameRate/(conv*(framesTr-1)),disp,'UniformOutput',false); % in um/s
pt_vel=cellfun(@(x,y) [x(:,:,1) y],pts_tracked,vels,'UniformOutput',false);
    
binned_vels=binning(frames,pt_vel,2,tot_bins);

end