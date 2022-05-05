function handles = punch_preprocessing (handles)

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
img3 = imclearborder(img3);

handles.gui_val.img_L = img_L;
handles.gui_val.img3 = img3;
