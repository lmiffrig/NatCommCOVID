function vels=CellTrack(Cells_loc);
tic
Cells_loc_new=zeros(size(Cells_loc));

for n=1:size(Cells_loc,3);
    [r,c]=find(Cells_loc(:,:,n));
    pts=[c r];
    pts=sortrows(pts);
    [C,ia]=unique(pts(:,2),'last');
    pts_unique=pts(ia,:);
    frame=Cells_loc_new(:,:,n);
    idx=sub2ind(size(frame),pts_unique(:,2),pts_unique(:,1));
    frame(idx)=1;
    Cells_loc_new(:,:,n)=frame;
end

close all
vec=[1 100 200 300 400 500];

cell_count=1;
for i=1:size(Cells_loc,1)
    for n=(1:length(vec))
        temp=squeeze(Cells_loc(i,:,vec(n):(vec(n)+97)));
    figure
    imagesc(temp);
    [x,~]=ginput;
        for j=1:2:length(x)-1;
        [cellsVel{cell_count}(:,2),cellsVel{cell_count}(:,1)]=find(temp(:,round((x(j):x(j+1)))));
            if size(cellsVel{cell_count},1)<3
            cellsVel{cell_count}=[];
            end
        cell_count=cell_count+1;      
        end
    end
    close all
end

chk=~cellfun('isempty',cellsVel);
cellsVel=cellsVel(chk);

fits=cellfun(@(x) polyfit(x(:,1),x(:,2),1),cellsVel,'UniformOutput',false);
fits=cell2mat(fits);
vels=fits(1:2:end);
vels=vels*40*5.86/20*15; % adjust velocity from box/frame to microns per second; 40 fps; 5.86 um per pixel at 20x, 15 pixels per box

 toc
end
