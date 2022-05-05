function [ obj_table ] = punchNumberUpdate( obj_table )
%based on centroid position

%--------------------------------------------------------------------------
% for i = 1:numel(handles.gui_val.objects)
%     handles.gui_val.objects(i).punchNum = i;
% end
% [ handles.gui_val.objects ] = tempFun_punchNumberUpdate( handles.gui_val.objects );
%--------------------------------------------------------------------------

for i = 1:numel(obj_table)
        all_x(i) = obj_table(i).Centroid(1);
        all_y(i) = obj_table(i).Centroid(2);
end


%nRow = max(horzcat(obj_table(:).row));
nCol = max(horzcat(obj_table(:).col));
lastRowNumel = mod(numel(obj_table),nCol);
nRow = (numel(obj_table)-lastRowNumel)/nCol +1;

myPunchNumbering_final = rot90( (reshape((1:nRow*nCol) ,[nCol, nRow])') ,2);
myPunchNumbering = flip(reshape((1:nRow*nCol) ,[nCol, nRow])',2);

[sortY,Iy] = sort(all_y,'descend');


for i = 1:nRow-1
    %start = (1+(nCol*(i-1)));
    %stop = (nCol+(nCol*(i-1)));
    this_row = Iy( (1+(nCol*(i-1))) : (nCol+(nCol*(i-1))) );
    
    all_x1 = vertcat(obj_table(this_row).Centroid);
    [sortX1,Ix1] = sort( all_x1(:,1)' );
    this_row_sorted = this_row(Ix1);
    
    for kk = 1:length(this_row_sorted)
        obj_table(this_row_sorted(kk)).punchNum = myPunchNumbering(i,kk);
    end

end




