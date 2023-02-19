function [frames,pts_tracked,pt_vel,pt_theta]=KLT_track2(tr_time)
%INPUTS:
% dialogue window will open up and a video is selected for analysis
%
% user identifies the axis of rotation by selecting symmetric points at the 
% edge of the image and then defines the relevant area of interest using
% the crop tool
% 
%
%     the length of time in seconds that a point needs to be tracked across
%     to be considered valid

% extract area of interest
[frames,frameRate]=CropRot;

% number of frames per set to track points
framesTr=round(frameRate*tr_time);

% array defining the 
vec=1:framesTr:size(frames,3);

pts_tracked=cell(length(vec)-1,1);
pt_vel=cell(size(frames,3),1);
pt_theta=cell(size(frames,3),1);


for t=1:(length(vec)-1)
    tic
    % create frame set from video
    vidKLT=frames(:,:,vec(t):vec(t+1));
    frame_num=vec(t):vec(t+1);

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
        for nframe=2:size(vidKLT,3);
             trackedFrame=vidKLT(:,:,nframe);
             [points(:,:,nframe),validity{t}(:,nframe)]=step(pointTracker,trackedFrame);
        end
    
    % store all tracked points who have at least framesTr valid tracked frames
    pts_tracked{t}=points((sum(validity{t},2)==size(vidKLT,3)),:,:);
    x=pts_tracked{t};
    ins_vel=squeeze(((x(:,1,2:end)-x(:,1,1:(end-1))).^2+(x(:,2,2:end)-x(:,2,1:(end-1))).^2).^0.5/2.57*frameRate);
    ins_theta=squeeze(atan((x(:,2,2:end)-x(:,2,1:(end-1)))./(x(:,1,2:end)-x(:,1,1:(end-1)))));
    for i=1:(size(vidKLT,3)-1)
        pt_vel{frame_num(i)}=[x(:,:,i) ins_vel(:,i)];
        pt_theta{frame_num(i)}=[x(:,:,i) ins_theta(:,i)];
    end
    % reset all variables
    clearvars vidKLT initialFrame trackedPoints pts idx points pointTracker validity x ins_vel
    toc
end


end