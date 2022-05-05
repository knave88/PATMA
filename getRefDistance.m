function refDistance = getRefDistance (objects)

selection = false(length(objects),1);
for i = 1 : length(objects)
    if objects(i).Eccentricity < 0.9
        selection(i) = true;
    end
end
objects_sel = objects(selection);

findEcc = vertcat(objects_sel.Eccentricity);
[objMinEcc, objMinEccNum] = min(findEcc(:));
objMinEccBB = objects(objMinEccNum).BoundingBox;
objMinEccWidth = objMinEccBB(3);
objMinEccHeight = objMinEccBB(4);
refDistance = (round((objMinEccWidth + objMinEccHeight) / 2)) /2;
