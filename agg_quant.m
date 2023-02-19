function [cluster_sz_m,clus_num,agg_vels_mean_m,heat_map_re,vel_idx,pt_vel_cum]=agg_quant(pt_vel,ch_sz,bin_sz);
tic
%% INPUTS
% pt_vel : cell array of instantaneous velocity field as a t cell array with image
%   coordinate x,y as columns 1&2, velocicty as column 3
% ch_sz : size of channel in microns;

acqs=numel(pt_vel);

for i=1:acqs;
pt_vel{i}=pt_vel{i}(~cellfun('isempty',pt_vel{i}));
end

for i=1:acqs;
    v=1:40:numel(pt_vel{i});
    s=cellfun(@(x) size(x,1),pt_vel{i});
    pt=find(s(1:end-1)~=s(2:end));
    v=[0 pt.' numel(pt_vel{i})];
    for j=1:(length(v)-1)
        test=cat(3,pt_vel{i}{(v(j)+1):v(j+1)});
        mean_vel=mean(test(:,3),3);
        pt_vel_cum{i}{j}=[pt_vel{i}{v(j)+1}(:,1) pt_vel{i}{v(j)+1}(:,2) mean_vel];
    end
end
    
clear i v j test mean_vel 

bin_vel=cellfun(@(x) near_wall(2.57*bin_sz,2.57*ch_sz,bin_sz*2.57,x),pt_vel_cum,'UniformOutput',false);

for i=1:acqs
    idx{i}=cellfun(@(x) sub2ind([max(x(:,2)),max(x(:,1))],x(:,2),x(:,1)),bin_vel{i},'UniformOutput',false);
    heat_map{i}=cellfun(@(x) zeros(max(x(:,2)),max(x(:,1))),bin_vel{i},'UniformOutput',false);
end

for i=1:acqs
    for j=1:numel(bin_vel{i})
        heat_map{i}{j}(idx{i}{j})=bin_vel{i}{j}(:,3);
    end
end

clear i j bin_vel70

% quantify differences between adjacent boxes normalized to the mean velocity of the set of images
for i=1:acqs
    pt_diff{i}=cellfun(@(x) near_neighbor(x),heat_map{i},'UniformOutput',false);
end

clear i

for i=1:acqs
    for j=1:numel(pt_diff{i})
        pt_diff_2{i}{j}=[pt_diff{i}{j}(:,1)*2 pt_diff{i}{j}(:,2)*2 pt_diff{i}{j}(:,3)];
    end
end

clear pt_diff

% bin the differential velocity maps into heat map
for i=1:acqs
    idx_2{i}=cellfun(@(x) sub2ind([max(x(:,2)),max(x(:,1))],x(:,2),x(:,1)),pt_diff_2{i},'UniformOutput',false);
end

for i=1:acqs
    heat_map_2{i}=cellfun(@(x) zeros(max(x(:,2)),max(x(:,1))),pt_diff_2{i},'UniformOutput',false);
end

for i=1:acqs
    for j=1:numel(pt_diff_2{i})
        heat_map_2{i}{j}(idx_2{i}{j})=pt_diff_2{i}{j}(:,3);
    end
end

clear pt_diff_2 idx idx_2 i j

% for a cell array of heat_map matrices 
    % set threshold for difference detection
    t=0.05;

for j=1:acqs
    C=heat_map_2{j};

    C_cr=cellfun(@(x) x(2:end,:),C,'UniformOutput',false);
    BW=cellfun(@(x) zeros(size(x)),C_cr,'UniformOutput',false);

    idx=cellfun(@(x) find(x<t),C_cr,'UniformOutput',false);
    for i=1:numel(BW);
        BW{i}(idx{i})=1;
    end

    % find connectivity of thresholded velocity differential field
    cc=cellfun(@bwconncomp,BW,'UniformOutput',false);

    % pixels for each of the identified clusters
    p{j}=cellfun(@(x) x.PixelIdxList,cc,'UniformOutput',false);

    % size in pixels for each of the clusters, where 1 pixel is equivalent to
    % 2.5 microns
    for i=1:numel(p{j});
        sz{j}{i}=cellfun(@(x) size(x,1),p{j}{i});
    end

    % set threshold (in pixels) for size of clusters 
    t2= 28/(bin_sz^2)*15; % threshold is roughly 15 red cells 
    idx2{j}=cellfun(@(x) find(x>t2),sz{j},'UniformOutput',false); % indexed location within p for each of the included clusters
    cluster_sz{j}=cellfun(@(x,y) x(y),sz{j},idx2{j},'UniformOutput',false);
    j
end

cluster_sz_m=cellfun(@(x) cell2mat(x),cluster_sz,'UniformOutput',false);
clus_num=cellfun(@(y) size(y,2),cluster_sz_m);

for i=1:acqs
    for j=1:numel(p{i})
        vel_idx{i}{j}=p{i}{j}(idx2{i}{j});
    end
end

for i=1:acqs
    heat_map_re{i}=cellfun(@(x) imresize(x,2),heat_map{i},'UniformOutput',false);
    for j=1:numel(heat_map_re{i})
        agg_vels{i}{j}=cellfun(@(x) heat_map_re{i}{j}(x),vel_idx{i}{j},'UniformOutput',false);
        agg_vels_mean{i}{j}=cellfun(@mean,agg_vels{i}{j});
    end
    agg_vels_mean_m{i}=cell2mat(agg_vels_mean{i});
end


toc
end