function bin_vels=binning2(pt_vel,ch_size,bin_size)


bins=linspace(0,ch_size*2.57,ch_size/bin_size+1);

bin_vels=cell(ch_size/bin_size,1);

if class(pt_vel)=='cell'
pt_vel=cell2mat(pt_vel.');
end


for i=1:(length(bins)-1)
bin_vels{i}=pt_vel((pt_vel(:,2)<bins(i+1) & pt_vel(:,2)>bins(i)),:);
end

end


