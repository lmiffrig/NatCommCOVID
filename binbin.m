function [mat,mat_mean]=binbin(frames,pt_vel,channel_width,binsz)

sz=size(frames);

row_bins=channel_width/binsz;
col_bins=round(sz(2)/(sz(1)/row_bins));

bin_row=round(linspace(1,sz(1),row_bins+1));
bin_col=round(linspace(1,sz(2),col_bins+1));

mat=cell(length(bin_row)-1,length(bin_col)-1);

for i=1:(length(bin_row)-1)
    for j=1:(length(bin_col)-1)
        idx_row=find(pt_vel(:,2)<bin_row(i+1) & pt_vel(:,2)>bin_row(i));
        idx_col=find(pt_vel(:,1)<bin_col(j+1) & pt_vel(:,1)>bin_col(j));
        idx=intersect(idx_row,idx_col);
        mat{i,j}=pt_vel(idx,:);
    end
end

mat_mean=cellfun(@(x) mean(x(:,3)),mat);

end

