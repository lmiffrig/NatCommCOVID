function [pt_diff]=near_neighbor(mat)
% mat=heat_map_mean70500{1};
sz=size(mat);
idx=sz(1)*sz(2);

vec=[1:idx].';

%% maybe needs to be re-written in subscript form
vec_near=real([vec vec-sz(1)-1 vec-1 vec+sz(1)-1 vec+sz(1) vec+sz(1)+1 vec+1 vec-sz(1)+1 vec-sz(1)]); 
[r,c]=ind2sub(sz,vec);
near_r=[r r-1 r-1 r-1 r r+1 r+1 r+1 r];
near_c=[c c-1 c c+1 c+1 c+1 c c-1 c-1];

near=[near_r(:) near_c(:)];
v_idx=find(near(:,1)<1 | near(:,1)>sz(1) | near(:,2)<1 | near(:,2)>sz(2));

near(v_idx,:)=NaN;

neighbor_val=zeros(size(near,1),1);

[neighbor_idx,xx]=find(~isnan(near));
neighbor_idx=unique(neighbor_idx);

neighbor_val(neighbor_idx)=mat(vec_near(neighbor_idx));

neighbor_val=reshape(neighbor_val,size(vec_near));

near_r=reshape(near(:,1),size(near_r));
near_c=reshape(near(:,2),size(near_c));

X_mean=(repmat(near_c(:,1),1,8)+near_c(:,2:end))./2;
Y_mean=(repmat(near_r(:,1),1,8)+near_r(:,2:end))./2;

neighbor_diff=repmat(neighbor_val(:,1),1,8)-neighbor_val(:,2:end);
pt_diff=unique([X_mean(:) Y_mean(:) abs(neighbor_diff(:))],'rows');
pt_diff=unique(pt_diff,'rows');
[r2,c2]=find(isnan(pt_diff));
idx=unique(r2);
pt_diff(idx,:)=[];
pt_diff(:,3)=pt_diff(:,3)./mean(mat(mat>0));
pt_diff=[pt_diff; c r zeros(size(c,1),1)];

end