function ag_thresh

frames=histeq(frames252);
pt_vel=pt_vel252;
for i=1:size(frames,3);
    T(:,:,i)= adaptthresh(frames(:,:,i),0.4,'ForegroundPolarity','dark');
    BW(:,:,i)=imbinarize(frames(:,:,i),T(:,:,i));
end

BW=abs(BW-1);

for i=1:size(frames,3);
    BW_fill(:,:,i)=imfill(BW(:,:,i),'holes');
end

pt_vel=pt_vel(~cellfun('isempty',pt_vel));

v=1:40:numel(pt_vel);
s=cellfun(@(x) size(x,1),pt_vel);
pt=find(s(1:end-1)~=s(2:end));
v=[0 pt.' numel(pt_vel)];
for j=1:(length(v)-1)
	test=cat(3,pt_vel{(v(j)+1):v(j+1)});
	mean_vel=mean(test(:,3),3);
	pt_vel_cum{j}=[pt_vel{v(j)+1}(:,1) pt_vel{v(j)+1}(:,2) mean_vel];
end    

pt_vel_round=cellfun(@(x) [round(x(:,1)) round(x(:,2)) x(:,3)],pt_vel_cum,'UniformOutput',false);
vels=zeros(size(BW_fill));

for i=1:size(vels,3);
    idx=sub2ind(size(vels,[1,2]),pt_vel_round{1}(:,2),pt_vel_round{1}(:,1));
    vel=zeros(size(vels,[1 2]));
    vel(idx)=pt_vel_round{1}(:,3);
    vels(:,:,i)=vel;
end




