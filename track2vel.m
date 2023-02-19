function [pt_vel,pt_theta]=track2vel(pts_tracked,frameRate)
ct=1;
for t=1:numel(pts_tracked)
    x=pts_tracked{t};
    ins_vel=squeeze(((x(:,1,2:end)-x(:,1,1:(end-1))).^2+(x(:,2,2:end)-x(:,2,1:(end-1))).^2).^0.5/2.57*frameRate);
    ins_theta=squeeze(atan((x(:,2,2:end)-x(:,2,1:(end-1)))./(x(:,1,2:end)-x(:,1,1:(end-1)))));
    for i=1:(size(pts_tracked{t},3)-1);
        pt_vel{ct}=[x(:,:,i) ins_vel(:,i)];
        pt_theta{ct}=[x(:,:,i) ins_theta(:,i)];
        ct=ct+1;
    end
    clear x ins_vel ins_theta
end
end

    