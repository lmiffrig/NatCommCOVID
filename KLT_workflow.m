[frames70500,pts_tracked70500,pt_vel70500,binned_vels70500]=KLT_track(20,70/5,1/4);
[heat_map70500,heat_map_mean70500]=cellfun(@(x) binbin(frames70500,x,70,5),pt_vel70500,'UniformOutput',false);
pt_diff70500=cellfun(@near_neighbor,heat_map_mean70500,'UniformOutput',false);

[frames70250,pts_tracked70250,pt_vel70250,binned_vels70250]=KLT_track(20,70/5,1/4);
[heat_map70250,heat_map_mean70250]=cellfun(@(x) binbin(frames70250,x,70,5),pt_vel70250,'UniformOutput',false);
pt_diff70250=cellfun(@near_neighbor,heat_map_mean70250,'UniformOutput',false);

[frames45500,pts_tracked45500,pt_vel45500,binned_vels45500]=KLT_track(20,45/5,1/4);
[heat_map45500,heat_map_mean45500]=cellfun(@(x) binbin(frames45500,x,45,5),pt_vel45500,'UniformOutput',false);
pt_diff45500=cellfun(@near_neighbor,heat_map_mean45500,'UniformOutput',false);

[frames45250,pts_tracked45250,pt_vel45250,binned_vels45250]=KLT_track(20,45/5,1/4);
[heat_map45250,heat_map_mean45250]=cellfun(@(x) binbin(frames45250,x,45,5),pt_vel45250,'UniformOutput',false);
pt_diff45250=cellfun(@near_neighbor,heat_map_mean45250,'UniformOutput',false);

[frames30500,pts_tracked30500,pt_vel30500,binned_vels30500]=KLT_track(20,30/5,1/4);
[heat_map30500,heat_map_mean30500]=cellfun(@(x) binbin(frames30500,x,30,5),pt_vel30500,'UniformOutput',false);
pt_diff30500=cellfun(@near_neighbor,heat_map_mean30500,'UniformOutput',false);

[frames30250,pts_tracked30250,pt_vel30250,binned_vels30250]=KLT_track(20,30/5,1/4);
[heat_map30250,heat_map_mean30250]=cellfun(@(x) binbin(frames30250,x,30,5),pt_vel30250,'UniformOutput',false);
pt_diff30250=cellfun(@near_neighbor,heat_map_mean30250,'UniformOutput',false);

[frames20500,pts_tracked20500,pt_vel20500,binned_vels20500]=KLT_track(20,20/5,1/4);
[heat_map20500,heat_map_mean20500]=cellfun(@(x) binbin(frames20500,x,20,5),pt_vel20500,'UniformOutput',false);
pt_diff20500=cellfun(@near_neighbor,heat_map_mean20500,'UniformOutput',false);

[frames20250,pts_tracked20250,pt_vel20250,binned_vels20250]=KLT_track(20,20/5,1/4);
[heat_map20250,heat_map_mean20250]=cellfun(@(x) binbin(frames20250,x,20,5),pt_vel20250,'UniformOutput',false);
pt_diff20250=cellfun(@near_neighbor,heat_map_mean20250,'UniformOutput',false);