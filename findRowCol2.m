function objects = findRowCol2 (objects)

refDistance = getRefDistance (objects);
selection = vertcat(objects(:).Eccentricity)<0.9;


%% columns

col_current = find_punch_inCol (objects, selection, refDistance);
select_new = (selection&~col_current); %added line
objects_left = sum(select_new);

col_counter = 1;
col_split(col_counter,:) = col_current;
col_counter = col_counter+1;
while objects_left > 0
    
    col_current = find_punch_inCol (objects, select_new, refDistance);
    col_split(col_counter,:) = col_current;
    col_counter = col_counter+1;
    
    select_new = (select_new&~col_current);
    objects_left = sum(select_new&~col_current);
    
    if col_counter == 50
        break;
    end
end

%% rows

first_col = find(col_split(1,:));

row_current = find_punch_inRow (objects, selection, refDistance);

select_new = (selection & ~row_current); %added line
objects_left = sum(select_new);

row_counter = 1;
row_split(row_counter,:) = row_current;
row_counter = row_counter+1;
while objects_left > 0
    
    row_current = find_punch_inRow (objects, select_new, refDistance);
    row_split(row_counter,:) = row_current;
    row_counter = row_counter+1;
    
    select_new = (select_new&~row_current);
    objects_left = sum(select_new&~row_current);
    
    if row_counter == 50
        break;
    end
end

%% add to struct
for i = 1 : length(objects)
    objects(i).row = find(row_split(:,i));
    objects(i).col = find(col_split(:,i));
end



function [this_col] = find_punch_inCol (objects_in, valids, refDistance)

findEcc = vertcat(objects_in.Eccentricity)<0.8; % 0.5
validObj = valids &findEcc;

findXY = vertcat(objects_in( validObj ).Centroid);

if ~isempty(findXY)
    objMinX = min(findXY(:,1));

    this_col = false(length(objects_in),1);
    
    for i = 1 : length(objects_in)
        if objects_in(i).Centroid(1) < objMinX+refDistance && objects_in(i).Centroid(1) > objMinX-refDistance && validObj(i) == true
            this_col(i) = true;
        end
    end

else
    this_col = false(length(objects_in),1);
end

function [this_row] = find_punch_inRow (objects_in, valids, refDistance)

%findEcc = vertcat(objects_in.Eccentricity)<0.5;
validObj = valids; %&findEcc;

findXY = vertcat(objects_in( validObj ).Centroid);

if ~isempty(findXY)
    
    %findXY = vertcat(objects_in( vertcat(objects_in.Eccentricity)<0.5 ).Centroid);
    objMinY = min(findXY(:,2));
    
    this_row = false(length(objects_in),1);
    
    for i = 1 : length(objects_in)
        
        if objects_in(i).Centroid(2) < objMinY+refDistance && objects_in(i).Centroid(2) > objMinY-refDistance && validObj(i) == true
            this_row(i) = true;
%             temp_centr = vertcat(objects_in(this_row).Centroid);
%             plot([temp_centr(:,1);objects_in(i).Centroid(1)], repmat(objMinY, length(temp_centr(:,1))+1, 1), 'g-');
%             plot([temp_centr(:,1);objects_in(i).Centroid(1)], repmat(objMinY+refDistance, length(temp_centr(:,1))+1, 1), 'g--');
%             plot([temp_centr(:,1);objects_in(i).Centroid(1)], repmat(objMinY-refDistance, length(temp_centr(:,1))+1, 1), 'g--');
            
        elseif (chceck_curveRow(objects_in, i, this_row, refDistance) && validObj(i)) == true
            this_row(i) = true;
        end
    end
    
else
    this_row = false(length(objects_in),1);
end


function out = chceck_curveRow(objects_in, i, this_row, refDistance)
out = false;
polydegree = 2;

if length(find(this_row)) >= 3
    temp_centroids = vertcat(objects_in(this_row).Centroid);
    
    p = polyfit(temp_centroids(:,1), temp_centroids(:,2), polydegree);
    newP = polyval(p, objects_in(i).Centroid(1));
    
    if objects_in(i).Centroid(2) < newP+refDistance && objects_in(i).Centroid(2) > newP-refDistance
        out = true;
    end
    
%     plot([temp_centroids(:,1);objects_in(i).Centroid(1)], [temp_centroids(:,2);newP], 'r');
end

