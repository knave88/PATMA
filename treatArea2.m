function current_object = treatArea2(img_L, current_object, refDistance)

bb = current_object.BoundingBox;
start_point_x = round( bb(1) );
start_point_y = round( bb(2) );

[m,n] = size(img_L);
end_point_x = round( bb(1) + bb(3) );
if end_point_x > n
    end_point_x = n;
end

end_point_y = round( bb(2) + bb(4) );
if end_point_y > m
    end_point_y = m;
end


myCentroid = current_object.Centroid;

currentArea = img_L(start_point_y:end_point_y, start_point_x:end_point_x,:);

imgLhist = imhist(currentArea);
thresh = find(imgLhist == max(imgLhist(:))) - 5;
currentArea = ~im2bw(currentArea, thresh/255);

currentArea = imclearborder(currentArea);
currentArea = imfill(currentArea, 'holes');
currentArea = bwareaopen(currentArea, 50); % ? #moze: (1/10)*refDiameter
se = strel('disk',5); %10
currentArea = imclose(currentArea, se);

currentArea = imfill(currentArea, 'holes');
%currentArea = imclearborder(currentArea);
%figure;imshow(currentArea); title(['punch ',num2str(current_object.punchNum)]);

objects_new = regionprops(currentArea, {'Area','BoundingBox', 'Centroid'});

sumAreas = sum(vertcat(objects_new.Area));
if (current_object.row == 1) && (sumAreas < 0.01*((end_point_y-start_point_y)*(end_point_x-start_point_x)))
    %current_object.BoundingBox = zeros(1,4);
    current_object.BoundingBox = [(myCentroid(1) - refDistance*0.5), (myCentroid(2) - refDistance*0.5), refDistance*0.5, refDistance*0.5];
    return;
end

euclidDistance = @(P1,P2) round( sqrt( sum((P2(1)-P1(1)).^2) + sum((P2(2)-P1(2)).^2) ) );

if ~isempty(objects_new)
    myCentroid_currentArea = [ round(bb(3)/2) round(bb(4)/2) ];
    myDistances = zeros(length(objects_new),4);
    
    for newObjNum = 1:length(objects_new)
        %wyznaczm srodki boundingbox i odleglosc eklidesowa wczesniej
        %okreslonego centroidu nastepnie to jest promien teoretycznego puncza
        %plus pewna odleglosc graniczna dla bezpieczenstwa (np 1/10odleglosci)
        bb_new = objects_new(newObjNum).BoundingBox;
        
        bb_checkPoint1 = [ round( bb_new(1) + ( 0.5*bb_new(3) ) ), round(bb_new(2)) ];
        bb_checkPoint2 = [ round( bb_new(1) + ( 0.5*bb_new(3) ) ), round(bb_new(2)+bb_new(4)) ];
        bb_checkPoint3 = [ round(bb_new(1)), round( bb_new(2) + ( 0.5*bb_new(4) ) ) ];
        bb_checkPoint4 = [ round(bb_new(1)+bb_new(3)), round( bb_new(2) + ( 0.5*bb_new(4) ) ) ];
        
        myDistances(newObjNum,1) = euclidDistance(bb_checkPoint1, myCentroid_currentArea);
        myDistances(newObjNum,2) = euclidDistance(bb_checkPoint2, myCentroid_currentArea);
        myDistances(newObjNum,3) = euclidDistance(bb_checkPoint3, myCentroid_currentArea);
        myDistances(newObjNum,4) = euclidDistance(bb_checkPoint4, myCentroid_currentArea);
    end
    
    maxDistance = round(max(myDistances(:))); %  round(maxDistance+((1/10)*maxDistance));
    bb_toPaste = [(myCentroid(1) - maxDistance), (myCentroid(2) - maxDistance), maxDistance*2, maxDistance*2];
    
    current_object.BoundingBox = bb_toPaste;
    
else
    %current_object.BoundingBox = zeros(1,4);
    current_object.BoundingBox = [(myCentroid(1) - refDistance*0.5), (myCentroid(2) - refDistance*0.5), refDistance*0.5, refDistance*0.5];
end


