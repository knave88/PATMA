function objects = treatNotinTable1(objects, refDistance, treatNum)

myTable = updateTable(objects);
euclidDistance = @(P1,P2) round( sqrt( sum((P2(1)-P1(1)).^2) + sum((P2(2)-P1(2)).^2) ) );

myCentroid = objects(treatNum).Centroid;
myDistances = zeros(length(objects),1);

for i = 1:length(objects)
    checkCentroid = objects(i).Centroid;
    myDistances(i,1) = euclidDistance(checkCentroid, myCentroid);
end

myDistList = sort(myDistances);

for i= 1:length(myDistList)
    if myDistList(i) ~= 0
        myDistListSorted(i,1) = find( myDistances == myDistList(i) ,1);
    end
end
ctoNum = myDistListSorted(find(myDistListSorted, 1));

% combine objects ( Bounding Boxes ) or assign to new one
%check if the closest has assigned row and col
%if true, check surrounding for empties and full spaces
%if not, search new closest object

%okreslenie orientacji
ctoCentroid = objects(ctoNum).Centroid;
if (myCentroid(1) < ctoCentroid(1)) && (myCentroid(2) < ctoCentroid(2))
    treatOrient = 'TL'; %treated object is located top-left of closest
    
     if myDistances(ctoNum) > 2*refDistance &&  abs(myCentroid(1) - ctoCentroid(1)) > refDistance && hasRC(objects(ctoNum))
        objects(treatNum).row = objects(ctoNum).row;
        objects(treatNum).col = objects(ctoNum).col-1;
    elseif myDistances(ctoNum) > 2*refDistance &&  abs(myCentroid(2) - ctoCentroid(2)) > refDistance && hasRC(objects(ctoNum))
        objects(treatNum).row = objects(ctoNum).row-1;
        objects(treatNum).col = objects(ctoNum).col;
    elseif hasRC(objects(ctoNum)) == false
        objects = assign_RnC_mean(objects, treatNum);
    else
        objects = merge_objects (objects, treatNum, ctoNum);
    end
    

    
elseif (myCentroid(1) > ctoCentroid(1)) && (myCentroid(2) < ctoCentroid(2))
    treatOrient = 'TR'; %treated object is located top-right of closest
    
    if myDistances(ctoNum) > 2*refDistance &&  abs(myCentroid(1) - ctoCentroid(1)) > refDistance && hasRC(objects(ctoNum))
        %assign to new row/col
        objects(treatNum).row = objects(ctoNum).row;
        objects(treatNum).col = objects(ctoNum).col+1;
    elseif myDistances(ctoNum) > 2*refDistance &&  abs(myCentroid(2) - ctoCentroid(2)) > refDistance && hasRC(objects(ctoNum))
        objects(treatNum).row = objects(ctoNum).row-1;
        objects(treatNum).col = objects(ctoNum).col;
    elseif hasRC(objects(ctoNum)) == false
        objects = assign_RnC_mean(objects, treatNum);
    else
        objects = merge_objects (objects, treatNum, ctoNum);
    end
    
    
elseif (myCentroid(1) < ctoCentroid(1)) && (myCentroid(2) > ctoCentroid(2))
    treatOrient = 'BL'; %treated object is located bottom-left of closest
    
    if myDistances(ctoNum) > 2*refDistance &&  abs(myCentroid(1) - ctoCentroid(1)) > refDistance && hasRC(objects(ctoNum))
        objects(treatNum).row = objects(ctoNum).row;
        objects(treatNum).col = objects(ctoNum).col-1;
    elseif myDistances(ctoNum) > 2*refDistance &&  abs(myCentroid(2) - ctoCentroid(2)) > refDistance && hasRC(objects(ctoNum))
        objects(treatNum).row = objects(ctoNum).row+1;
        objects(treatNum).col = objects(ctoNum).col;
    elseif hasRC(objects(ctoNum)) == false
        objects = assign_RnC_mean(objects, treatNum);
    else
        objects = merge_objects (objects, treatNum, ctoNum);
    end
    
    
    
elseif (myCentroid(1) > ctoCentroid(1)) && (myCentroid(2) > ctoCentroid(2))
    treatOrient = 'BR'; %treated object is located bottom-right of closest
    
    if myDistances(ctoNum) > 2*refDistance &&  abs(myCentroid(1) - ctoCentroid(1)) > refDistance && hasRC(objects(ctoNum))
        objects(treatNum).row = objects(ctoNum).row;
        objects(treatNum).col = objects(ctoNum).col+1;
    elseif myDistances(ctoNum) > 2*refDistance &&  abs(myCentroid(2) - ctoCentroid(2)) > refDistance && hasRC(objects(ctoNum))
        objects(treatNum).row = objects(ctoNum).row+1;
        objects(treatNum).col = objects(ctoNum).col;
    elseif hasRC(objects(ctoNum)) == false
        objects = assign_RnC_mean(objects, treatNum);
    else
        %objects = merge_objects (objects, treatNum, ctoNum);
        objects = merge_objects (objects, ctoNum, treatNum);
    end
        
end

% merging with the closest object
%objects = merge_objects (objects, treatNum, ctoNum);

objects = treatAlignTable1 (objects);


function objects = merge_objects (objects, obj1, obj2)

bb_treat = objects(obj1).BoundingBox;
bb_closest = objects(obj2).BoundingBox;

bb_new1 = min(bb_treat(1),bb_closest(1));
bb_new2 = min(bb_treat(2),bb_closest(2));

bb_new3 = (max(round( bb_treat(1) + bb_treat(3) ), round( bb_closest(1) + bb_closest(3) ))) - bb_new1;
bb_new4 = (max(round( bb_treat(2) + bb_treat(4) ), round( bb_closest(2) + bb_closest(4) ))) - bb_new2;
new_bb = [bb_new1, bb_new2, bb_new3, bb_new4];

new_Area = objects(obj1).Area + objects(obj2).Area;

if isempty(objects(obj1).row) %|| ~isempty(objects(obj1).col)
    new_row = objects(obj2).row;
    %new_col = objects(obj2).col;
elseif isempty(objects(obj2).col)
    new_row = objects(obj1).row;
    %new_col = objects(obj2).col;
else
    new_row = objects(obj1).row;
    %new_col = objects(obj1).col;
end

if isempty(objects(obj1).col) 
    new_col = objects(obj2).col;
elseif isempty(objects(obj2).col)
    new_col = objects(obj1).col;
else
    new_col = objects(obj1).col;
end


new_Centroid =  [(round(new_bb(1) + (new_bb(3)/2))), (round(new_bb(2) + (new_bb(4)/2)))];

new_Ecc = 0;

objects(obj1).Area = new_Area;
objects(obj1).Centroid = new_Centroid;
objects(obj1).BoundingBox = new_bb;
objects(obj1).Eccentricity = new_Ecc;
objects(obj1).row = new_row;
objects(obj1).col = new_col;

objects(obj2) = [];



function objects = treatAlignTable1 (objects)

allRows = {objects(:).row};
zeroRows = false(1, numel(allRows));
% for k = 1:numel(allRows)
%     if ~isempty(allRows{k})
%         zeroRows(k) = (allRows{k} == 0);
%     end
% end

if ~isempty(find(zeroRows, 1))
    for i = 1:length(objects)
        objects(i).row = objects(i).row + 1;
    end
end



allCols = {objects(:).col};
zeroCols = false(1, numel(allCols));
for k = 1:numel(allCols)
    if ~isempty(allCols{k})
        zeroCols(k) = (allCols{k} == 0);
    end
end

if ~isempty(find(zeroCols, 1))
    for i = 1:length(objects)
        objects(i).col = objects(i).col + 1;
    end
end


function objects = assign_RnC_mean(objects, treatNum)

myTable = updateTable(objects);

[m,n] = size(myTable);

%get means of rows&cols
meanRows = zeros(1,m);
meanCols = zeros(1,n);
for y = 1:m
    c_1 = myTable(y,:);
    c_1 = c_1(c_1~=0);
    c_Row = vertcat(objects( c_1 ).Centroid);
    try
        meanRows(y) = mean(c_Row(:,2));
    catch ME
        %disp([ME.message,' -> there is an empty row.']);
        meanRows(y) = 0;
    end
end

for x = 1:n
    c_2 = myTable(:,x);
    c_2 = c_2(c_2~=0);
    c_Col = vertcat(objects( c_2 ).Centroid);
    try
        meanCols(x) = mean(c_Col(:,1));
    catch ME
        %disp([ME.message,' -> there is an empty column.']);
        meanCols(x) = 0;
    end
end

%assign to closest row&col by mean
myCentroid = objects(treatNum).Centroid;

%assign column
distCols = abs( meanCols - myCentroid(1) );
newY = find( distCols == min( distCols ) );
if length(newY) > 1
    newY = newY(1);
end

%assign row
distRows = abs( meanRows - myCentroid(2) );
newX = find( distRows == min( distRows ) );
if length(newX) > 1
    newX = newX(1);
end

objects(treatNum).row = newX;
objects(treatNum).col = newY;



function out = hasRC(obj)
out = true;
if isempty(obj.row) || isempty(obj.col)
    out = false;
end
