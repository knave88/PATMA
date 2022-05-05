function handles = wsi_preprocessing (handles)

img = handles.gui_val.img;
%% L from Lab 
colorTransform = makecform('srgb2lab');
img_Lab = applycform(img, colorTransform);
img_L = img_Lab(:, :, 1);

imgLhist = imhist(img_L);
thresh = find(imgLhist == max(imgLhist(:))) - 5;
%level = thresh/255;

if get(handles.checkbox_process, 'Value')
    level = handles.gui_val.edit_thresh/255;
    
elseif thresh < 5 || thresh > 250
    img_mask = img_L>0;
    img_L(img_mask==0) = 255;
    imgLhist = imhist(img_L);
    thresh = otsuthresh(imgLhist);
    handles.gui_val.edit_thresh = thresh*255;
    level = thresh;
else
    handles.gui_val.edit_thresh = thresh;
    level = thresh/255;
end
img2 = ~im2bw(img_L, level);

%%
[objThresh, strelSize] = getProcOptions (size(img2));
% [m,n] = size(img2);
% if (m*n*10^(-5)) < 100
%     objThresh = 1000;
%     strelSize = 2;
% else
%     objThresh = 10000;
%     strelSize = 5;
% end

if get(handles.checkbox_process, 'Value')
    img3 = bwareaopen(img2, handles.gui_val.edit_limit); 
else
    handles.gui_val.edit_limit = objThresh;
    img3 = bwareaopen(img2, objThresh); 
end

%img3 = bwareaopen(img2, objThresh); %10000


if get(handles.checkbox_process, 'Value')
    se = strel('disk',handles.gui_val.edit_strel);
else
    handles.gui_val.edit_strel = strelSize;
    se = strel('disk',strelSize);
end
%se = strel('disk',strelSize); % 2 or 5

img3 = imclose(img3, se);
img3 = imfill(img3, 'holes');
%img3 = imclearborder(img3);

handles.gui_val.img_L = img_L;
handles.gui_val.img3 = img3;


%%

objects = regionprops(handles.gui_val.img3, {'Area', 'BoundingBox', 'Centroid', 'Eccentricity'}); %'EulerNumber', 'Solidity'

%ograniczenie boundingBoxes do rozmiaru obrazu
objects = treatBB (objects, size(handles.gui_val.img_L));

% numerowanie 
for i = 1:length(objects)
    objects(i).punchNum = i;
    objects(i).row = i;
    objects(i).col = 1;
end

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
