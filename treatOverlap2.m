function objects = treatOverlap2 (objects)

listEmpty = find(horzcat(objects(:).Area) == 0);
listOther = find(horzcat(objects(:).Area) ~= 0);

listTodelete = [];
for i = 1: length(listEmpty)
    currentEmpty = objects(listEmpty(i));
    
    for j = 1:numel(listOther)
        currentNotassigned = objects(listOther(j));
        
        if isInside(currentNotassigned.Centroid, currentEmpty.BoundingBox);
            listTodelete = [listTodelete, listEmpty(i)];
        end
    end
    
    listEmpty2 = listEmpty;
    listEmpty2(i) =[];
    for j = 1:numel(listEmpty2)
        currentNotassigned = objects(listEmpty2(j));
        
        if isInside(currentNotassigned.Centroid, currentEmpty.BoundingBox);
            listTodelete = [listTodelete, listEmpty(i)];
        end
    end
    
end

%disp(listTodelete);
objects(listTodelete) = [];


function out = isInside(point, bb)
out = false;

start_point_x = round( bb(1) );
start_point_y = round( bb(2) );
end_point_x = round( bb(1) + bb(3) );
end_point_y = round( bb(2) + bb(4) );


if point(1) > start_point_x && point(1) < end_point_x && point(2) > start_point_y && point(2) < end_point_y
    out = true;
end
