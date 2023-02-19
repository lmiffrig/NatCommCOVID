function [disp,vels,pt_vel,bin_vels]=tot_vel(pts_tracked);

% pts_tracked{1}=pts_tracked20250;
% pts_tracked{2}=pts_tracked20500;
% pts_tracked{3}=pts_tracked30250;
% pts_tracked{4}=pts_tracked30500;
% pts_tracked{5}=pts_tracked45250;
% pts_tracked{6}=pts_tracked45500;
% pts_tracked{7}=pts_tracked70250;
% pts_tracked{8}=pts_tracked70500;

for i=1:8;
    disp{i}=cellfun(@(x) ((x(:,1,end)-x(:,1,1)).^2+(x(:,2,end)-x(:,2,1)).^2).^0.5,pts_tracked{i},'UniformOutput',false);
end

for i=1:8;
    vels{i}=cellfun(@(x,y) x*160/(2.57*(size(y,3)-1)),disp{i},pts_tracked{i},'UniformOutput',false);
end

for i=1:8;
    pt_vel{i}=cellfun(@(x,y) [x(:,:,1) y],pts_tracked{i},vels{i},'UniformOutput',false);
end

bin_vels{1}=binning2(pt_vel{1},20,1);
bin_vels{2}=binning2(pt_vel{2},20,1);
bin_vels{3}=binning2(pt_vel{3},30,1);
bin_vels{4}=binning2(pt_vel{4},30,1);
bin_vels{5}=binning2(pt_vel{5},45,1);
bin_vels{6}=binning2(pt_vel{6},45,1);
bin_vels{7}=binning2(pt_vel{7},70,1);
bin_vels{8}=binning2(pt_vel{8},70,1);

end

