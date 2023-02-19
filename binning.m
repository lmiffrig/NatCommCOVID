function binned_vels=binning(pt_vel,n,tot_bins)

%INPUTS
%   pts_tracked: cell array of t tracked vectors of variable lengthh of
%   matrix nx2xt_fr for tracked frames;

% define bins across the channel width 


binned_vels=cell(tot_bins,1);

if class(pt_vel)=='cell'
pt_vel=cell2mat(pt_vel.');
end


for i=1:(length(bins)-1)
binned_vels{i}=pt_vel((pt_vel(:,n)<bins(i+1) & pt_vel(:,n)>bins(i)),:);
end

end