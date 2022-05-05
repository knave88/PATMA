function [objects] = findEmpties2 (objects, refRadii)

myTable = updateTable(objects);
[nRow, nCol] = size(myTable);

%empties = zeros(size(myTable));
%empties(2:end,:) = (myTable(2:end,:) == 0);
empties = (myTable == 0);


list_empties = find(empties);

objects_empties = struct('Area', [], 'BoundingBox', [], 'Centroid', [], 'Eccentricity', [], 'row', [], 'col', []);

for i = 1:sum(empties(:))
    [y,x] = ind2sub(size(myTable), list_empties(i));
    
    flag = findNeighbour (myTable, x,y);
    
    if flag == 1
        bb_left = objects(myTable(y, x-1)).BoundingBox;
        start_point_x = (bb_left(1)+bb_left(3));
        
        bb_top = objects(myTable(y-1, x)).BoundingBox;
        start_point_y = bb_top(2) + bb_top(4);
        
        bb_right = objects(myTable(y, x+1)).BoundingBox;
        x_width = bb_right(1) - (bb_left(1)+bb_left(3));
        
        bb_bottom = objects(myTable(y+1, x)).BoundingBox;
        y_width = bb_bottom(2) - start_point_y;
        
        %imrect(gca, [start_point_x, start_point_y, x_width, y_width]);
    end
    
    if flag == 2
        c_1 = objects(myTable(y-1, x)).Centroid;
        c_2 = objects(myTable(y+1, x)).Centroid;
        c_srch = [ round((c_1(1)+c_2(1))/2) round((c_1(2)+c_2(2))/2)];
        
        start_point_x = restrain_bb(c_srch(1) - refRadii);
        start_point_y = restrain_bb(c_srch(2) - refRadii);
        %imrect(gca, [start_point_x, start_point_y, radii*2, radii*2]);
    end
    
    if flag == 3
        c_1 = objects(myTable(y, x+1)).Centroid;
        c_2 = objects(myTable(y, x-1)).Centroid;
        c_srch = [ round((c_1(1)+c_2(1))/2) round((c_1(2)+c_2(2))/2)];
        
        start_point_x = restrain_bb(c_srch(1) - refRadii);
        start_point_y = restrain_bb(c_srch(2) - refRadii);
        %imrect(gca, [start_point_x, start_point_y, radii*2, radii*2]);
    end
    
    if flag == 4
        c_1 = myTable(y,:);
        c_1 = c_1(c_1~=0);
        c_Row = vertcat(objects( c_1 ).Centroid);
        if isequal(size(c_Row),[0,0])
            meanRow = 0;
        else
            meanRow = mean(c_Row(:,2));
        end
        
        c_2 = myTable(:,x);
        c_2 = c_2(c_2~=0);
        c_Col = vertcat(objects( c_2 ).Centroid);
        if isequal(size(c_Col),[0,0])
            meanCol = 0;
        else
            meanCol = mean(c_Col(:,1));
        end
        
        c_srch = [meanCol, meanRow];
        
        start_point_x = restrain_bb(meanCol - refRadii);
        start_point_y = restrain_bb(meanRow - refRadii);
        %imrect(gca, [start_point_x, start_point_y, refRadii*2, refRadii*2]);
    end
    
    if flag == 1
        objects_empties(i,1).BoundingBox = [start_point_x, start_point_y, x_width, y_width];
        objects_empties(i,1).Centroid = [start_point_x+x_width/2 start_point_y+y_width/2];
        %imrect(gca, [start_point_x, start_point_y, x_width, y_width]);
        
    else
        objects_empties(i,1).BoundingBox = [start_point_x, start_point_y, refRadii*2, refRadii*2];
        objects_empties(i,1).Centroid = c_srch;
        %imrect(gca, [start_point_x, start_point_y, refRadii*2, refRadii*2]);
    end
    objects_empties(i,1).Area = 0;
    %objects_empties(i).BoundingBox = 0;
    %objects_empties(i).Centroid = 0;
    %objects_empties(i).Eccentricity = 0;
    objects_empties(i,1).row = y;
    objects_empties(i,1).col = x;
    %objects_empties(i,1).punchNum = 0;
end

objects = vertcat(objects,objects_empties);


function flag = findNeighbour (myTable, x,y)

try
    neigh_left = myTable(y, x-1);
catch
    neigh_left = 0;
end
try
    neigh_top = myTable(y-1, x);
catch
    neigh_top = 0;
end
try
    neigh_right = myTable(y, x+1);
catch
    neigh_right = 0;
end
try
    neigh_bottom = myTable(y+1, x);
catch
    neigh_bottom = 0;
end

if neigh_left ~= 0 && neigh_top ~= 0 && neigh_right ~= 0 && neigh_bottom ~= 0
    flag = 1; % all four neighbours
elseif neigh_top ~= 0 && neigh_bottom ~= 0
    flag = 2; % top-bottom
elseif neigh_left ~= 0 && neigh_right ~= 0
    flag = 3; % left-right
else
    flag = 4; % wyznaczyc ze srednih kolumny i rzedu centroid jako punkt wyjscia
end

function out = restrain_bb (in)

if in<1
    out = 1;
else
    out = in;
end


