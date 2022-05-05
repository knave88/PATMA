function handles = punch_objects (handles)

objects = regionprops(handles.gui_val.img3, {'Area', 'BoundingBox', 'Centroid', 'Eccentricity'}); %'EulerNumber', 'Solidity'
handles.gui_val.refDistance = getRefDistance (objects);

objects = findRowCol2 (objects);

% konflikty - dwa lub wecej obiektow w jednym polu - clustering?
% mean shift clustering (?) o radii = 1.5*refDistance;
% # TODO
% %--------------------------------------------------------------------------
% [clustCent,point2cluster,clustMembsCell] = MeanShiftCluster((vertcat(objects(:).Centroid)'),radii);
% %--------------------------------------------------------------------------

%znalezienie pustych wg tabeli
objects = findEmpties2 (objects, round(1.5*handles.gui_val.refDistance));

%przypisanie rzedzu  kolumny do znalezionych
objects = treatOverlap2 (objects);

% ponowne przeszukanie empties czy jest tam jednak obiekt 
for i = 1 : length(objects)
    if (objects(i).Area ==0) 
        objects(i) = treatArea2(handles.gui_val.img_L, objects(i), handles.gui_val.refDistance);
    end
end

% problem - nie mogl przypisac do zadnej kolumny lub rzedu
try
    while length(vertcat(objects.row)) ~= length(objects) || length(vertcat(objects.col)) ~= length(objects)
        emptyRowCols = horzcat( find(cellfun(@isempty,{objects(:).row})), find(cellfun(@isempty,{objects(:).col})) );
        if isempty(emptyRowCols)
            break;
        end
        objects = treatNotinTable1 (objects, handles.gui_val.refDistance, emptyRowCols(1));
        %objects = treatAlignTable1 (objects);
    end
catch ME
    disp(ME.message)
end
    
%ograniczenie boundingBoxes do rozmiaru obrazu
objects = treatBB (objects, size(handles.gui_val.img_L));

% numerowanie punchy
objects = punch_numbering (objects);

% delete empty filds at the end of TMA
objects = treatFrontEmpties (objects);


handles.gui_val.objects = objects;




%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

function objects = treatBB (objects, imgSize)

maxH = imgSize(1);
maxW = imgSize(2);

for i = 1:length(objects)
    objBB = objects(i).BoundingBox;
    
    start_point_x = round( objBB(1) );
    start_point_y = round( objBB(2) );
    end_point_x = round( objBB(1) + objBB(3) );
    end_point_y = round( objBB(2) + objBB(4) );
    
    if start_point_x < 1
        %start_point_x = 1;
        objects(i).BoundingBox(1) = 1;
    end
    
    if start_point_y < 1
        %start_point_y = 1;
        objects(i).BoundingBox(2) = 1;
    end
    
    if end_point_x > maxW
        %end_point_x = maxW;
        objects(i).BoundingBox(3) = maxW;
    end
    
    if end_point_y > maxH
        %end_point_y = maxH;
        objects(i).BoundingBox(4) = maxH;
    end
    
end



function [objects] = punch_numbering (objects)
myTable = updateTable(objects);
[nRow, nCol] = size(myTable);

% basic -> bottom-right is first one
% B = reshape((1:nRow*nCol) ,[nCol, nRow])';
% C = rot90(B,2);
myPunchNumbering = rot90( (reshape((1:nRow*nCol) ,[nCol, nRow])') ,2);
% for i = 1 : nRow*nCol
%     if myTable(i) ~= 0
%         objects(myTable(i)).punchNum = myPunchNumbering(i);
%     end
% end

for i = 1:length(objects)
    objects(i).punchNum = myPunchNumbering(objects(i).row, objects(i).col);
end



function objects = treatFrontEmpties (objects)

refDistance = getRefDistance (objects);

allPunchNum = horzcat(objects(:).punchNum);

lastPunch = max(allPunchNum(:));
lastPunchObj = find(allPunchNum == lastPunch);
lastPunchObj = lastPunchObj(1);

while (objects(lastPunchObj).Area == 0 && objects(lastPunchObj).BoundingBox(3) == refDistance*0.5 && objects(lastPunchObj).BoundingBox(4) == refDistance*0.5) || isempty(find(objects(lastPunchObj).BoundingBox, 1))
    objects(lastPunchObj) = [];
    allPunchNum = horzcat(objects(:).punchNum);
    lastPunch = max(allPunchNum(:));
    lastPunchObj = find(allPunchNum == lastPunch);
end

