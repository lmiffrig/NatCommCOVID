function [ins_vel,ins_theta,cum_vel,cum_theta]=ins_vec(pts_tracked,frRate);
% 
% num_frame=cellfun(@(x) size(x,3),pts_tracked);
ins_disp=cellfun(@(x) ((x(:,1,2:end)-x(:,1,1:(end-1))).^2+(x(:,2,2:end)-x(:,2,1:(end-1))).^2).^0.5/2.57,pts_tracked,'UniformOutput',false); %in um assuming 20x mag on epi microscope
ins_disp=cellfun(@squeeze,ins_disp,'UniformOutput',false);

ins_vel=cellfun(@(x) x*frRate,ins_disp,'UniformOut',false);

ins_theta=cellfun(@(x) atan((x(:,2,2:end)-x(:,2,1:(end-1)))./(x(:,1,2:end)-x(:,1,1:(end-1)))),pts_tracked,'UniformOutput',false);
ins_theta=cellfun(@squeeze,ins_theta,'UniformOutput',false);

cum_disp=cellfun(@(x) ((x(:,1,end)-x(:,1,1)).^2+(x(:,2,end)-x(:,2,1)).^2).^0.5/2.57,pts_tracked,'UniformOutput',false);
cum_vel=cellfun(@(x,y) x*frRate/(size(y,3)-1),cum_disp,pts_tracked,'UniformOut',false);
cum_theta=cellfun(@(x) atan((x(:,2,end)-x(:,2,1))./(x(:,1,end)-x(:,1,1))),pts_tracked,'UniformOutput',false);

end
