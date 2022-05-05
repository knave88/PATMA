function varargout = punchGUI(varargin)
% PATMA Ver 0.3
%
% <Software>
%The PATMA software is capable of automatically finding and extracting
%cores from archival images of the tissue microarrays. Tissue microarray
%slides are often scanned to perform computer-aided histopathological
%analysis of the tissue cores. For processing the image, splitting the
%whole virtual slide into images of individual cores is required. This
%software aids the scientists who want to perform further image processing
%on single cores.
%
% <Reference> 
% Lukasz Roszkowiak and Carlos Lopez "PATMA: Parser of archival
% tissue microarray", PeerJ 4 (2016): e2741.
% DOI: https://doi.org/10.7717/peerj.2741
%
%
%
% PUNCHGUI MATLAB code for punchGUI.fig
%      PUNCHGUI, by itself, creates a new PUNCHGUI or raises the existing
%      singleton*.
%
%      H = PUNCHGUI returns the handle to a new PUNCHGUI or the handle to
%      the existing singleton*.
%
%      PUNCHGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PUNCHGUI.M with the given input arguments.
%
%      PUNCHGUI('Property','Value',...) creates a new PUNCHGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before punchGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to punchGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help punchGUI

% Last Modified by GUIDE v2.5 20-Jul-2021 11:47:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @punchGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @punchGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before punchGUI is made visible.
function punchGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to punchGUI (see VARARGIN)

handles.gui_val.text_title = 'PATMA: Parser of archival TMA';
set(handles.text_title, 'String', handles.gui_val.text_title);
set(handles.text_title,'FontName','TimesNewRoman','FontSize',18);

handles.gui_val.text_copyright = [char(169),' Lukasz Roszkowiak and Carlos Lopez, 2015-2021'];
%handles.gui_val.text_copyright = [char(169),' Lukasz Roszkowiak and Carlos Lopez, 2015 (contact @ lroszkowiak@ibib.waw.pl)'];
set(handles.text_copyright, 'String', handles.gui_val.text_copyright);
%set(handles.text_copyright,'FontName','TimesNewRoman','FontSize',8);

handles.gui_val.img = [];
handles.gui_val.edit_thresh = 0;
handles.gui_val.edit_limit = 0;
handles.gui_val.edit_strel = 0;
handles.gui_val.edit_open_filename = 'C:\';
handles.gui_val.edit_margin = 0;
handles.gui_val.extract_lv0 = 1;
handles.gui_val.extract_lv4 = 1;

handles.gui_val.popup_rot = {'0','90','-90','180'};
handles.gui_val.popup_fileExt = {'TIF'};
handles.gui_val.export_fExt = '.tif';

set(handles.edit_open_filename, 'String', handles.gui_val.edit_open_filename);
set(handles.uipanel_open, 'SelectedObject', handles.radio_open_auto);

set(handles.checkbox_process, 'Value', false);
set(handles.push_preview, 'Enable', 'off');
set(handles.edit_thresh, 'Enable', 'off');
set(handles.edit_limit, 'Enable', 'off');
set(handles.edit_strel, 'Enable', 'off');
set(handles.popup_rot, 'Enable', 'off');

set(handles.edit_thresh, 'String', handles.gui_val.edit_thresh);
set(handles.edit_limit, 'String', handles.gui_val.edit_limit);
set(handles.edit_strel, 'String', handles.gui_val.edit_strel);
set(handles.edit_margin, 'String', handles.gui_val.edit_margin);

set(handles.popup_rot, 'String', handles.gui_val.popup_rot);
set(handles.popup_fileExt, 'String', handles.gui_val.popup_fileExt);

set(handles.checkbox2, 'Value', true);

axes(handles.axes_tma);
imshow(handles.gui_val.img);

% Choose default command line output for punchGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes punchGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = punchGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

% --- Executes during object creation, after setting all properties.
function edit_open_filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_open_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit_open_filename_Callback(hObject, eventdata, handles)
% hObject    handle to edit_open_filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_open_filename as text
%        str2double(get(hObject,'String')) returns contents of edit_open_filename as a double


% --- Executes when selected object is changed in uipanel_open.
function uipanel_open_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel_open 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

guidata(hObject, handles);

% --- Executes on button press in push_open.
function push_open_Callback(hObject, eventdata, handles)
% hObject    handle to push_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%load single file
% FilterSpec={'*.jpg;*.jpeg;*.bmp;*.tif;*.tiff;*.png','IMAGE Files (*.jpg,*.jpeg,*.bmp,*.tif,*.tiff,*.png)';
%     '*.jpg;*.jpeg',  'JPG images (*.jpg,*.jpeg)'; ...
%     '*.bmp','BMP images (*.bmp)'; ...
%     '*.tif;*.tiff',  'TIF images (*.tif,*.tiff)'; ...
%     '*.png','PNG images (*.png)'; ...
%     '*.*',  'All Files (*.*)'};
FilterSpec={'*.tif;*.tiff;*.jp2;*.mrxs;*.ndpi','IMAGE Files (*.tif,*.tiff,*.jp2,*.mrxs)';'*.tif;*.tiff',  'TIF images (*.tif,*.tiff)';'*.jp2',  'JPEG2000 (*.jp2)';'*.mrxs',  'MIRAX (*.mrxs)';'*.*',  'All Files (*.*)'};
[handles.gui_val.fileName,handles.gui_val.filePath] = uigetfile(FilterSpec,'File selector');

if handles.gui_val.fileName ~= 0
    handles.gui_val.edit_open_filename = [handles.gui_val.filePath, handles.gui_val.fileName];
    set(handles.edit_open_filename,'String',handles.gui_val.fileName);
    
    [~, handles.gui_val.fName,handles.gui_val.fExt] = fileparts(handles.gui_val.fileName);
    %[fName, fExt] = strtok(FileName,'.');
    
    
    img_info = imfinfo([handles.gui_val.filePath, handles.gui_val.fileName]);
    n_images = length(img_info);
    
    if (strcmpi(handles.gui_val.fExt,'.tif') || strcmpi(handles.gui_val.fExt,'.tiff')) && n_images == 1
        handles.gui_val.img = imread([handles.gui_val.filePath, handles.gui_val.fileName]);
        handles.gui_val.maxSizeRAW = 1;
        handles.gui_val.minSizeRAW = 1;
        handles.gui_val.rot = 0;
        contents_rot = cellstr(get(handles.popup_rot,'String'));
        set(handles.popup_rot, 'Value', find(strcmp(contents_rot, num2str(handles.gui_val.rot))));
        
    elseif strcmpi(handles.gui_val.fExt,'.tif') || strcmpi(handles.gui_val.fExt,'.tiff')
        unsorted = [];
        for i = 1: n_images
            if ~isempty(strfind(img_info(i).ImageDescription, 'RAW'))
                unsorted = [unsorted, i];
            end
        end
        allRAW = vertcat(img_info.Width); % or Height
        handles.gui_val.maxSizeRAW = find(allRAW == max(allRAW(unsorted)));
        handles.gui_val.minSizeRAW = find(allRAW == min(allRAW(unsorted)));
        handles.gui_val.rot = 0;
        contents_rot = cellstr(get(handles.popup_rot,'String'));
        set(handles.popup_rot, 'Value', find(strcmp(contents_rot, num2str(handles.gui_val.rot))));
        
        selOpen = get(handles.uipanel_open, 'SelectedObject');
        selOpenTag = get(selOpen, 'Tag');
        switch selOpenTag
            case 'radio_open_auto'
                handles.gui_val.img = imread([handles.gui_val.filePath, handles.gui_val.fileName], handles.gui_val.minSizeRAW);
            case 'radio_open_man'
                for i = 1:length(unsorted)
                    allRes{i} = [num2str(img_info(unsorted(i)).Width),' x ',num2str(img_info(unsorted(i)).Height)];
                end
                
                [sel,choice] = listdlg('PromptString','Select a resolution:',...
                    'SelectionMode','single','ListSize',[640 200],'ListString',allRes);
                if choice == true
                    handles.gui_val.img = imread([handles.gui_val.filePath, handles.gui_val.fileName], unsorted(sel));
                    handles.gui_val.minSizeRAW = unsorted(sel);
                else
                    set(handles.edit_open_filename,'String','resolution not selected');
                    handles.gui_val.img = [];
                    guidata(hObject, handles);
                    return;
                end
        end
    elseif strcmpi(handles.gui_val.fExt,'.jp2')
        handles.gui_val.maxSizeRAW = 0;
        handles.gui_val.minSizeRAW = round(img_info.WaveletDecompositionLevels/2);
        
        selOpen = get(handles.uipanel_open, 'SelectedObject');
        selOpenTag = get(selOpen, 'Tag');
        switch selOpenTag
            case 'radio_open_auto'
                handles.gui_val.img = imread([handles.gui_val.filePath, handles.gui_val.fileName],'ReductionLevel', handles.gui_val.minSizeRAW);
            case 'radio_open_man'
                allRes{1} = num2str(0);
                for i = 2:img_info.WaveletDecompositionLevels+1
                    allRes{i} = num2str(i-1);
                end
                %allRes = num2str(0:img_info.WaveletDecompositionLevels);
                
                [sel,choice] = listdlg('PromptString','Select a resolution:',...
                    'SelectionMode','single','ListSize',[640 200],'ListString',allRes);
                if choice == true
                    handles.gui_val.img = imread([handles.gui_val.filePath, handles.gui_val.fileName],'ReductionLevel', str2double(allRes(sel)));
                    handles.gui_val.minSizeRAW = str2double(allRes(sel));
                else
                    set(handles.edit_open_filename,'String','resolution not selected');
                    handles.gui_val.img = [];
                    guidata(hObject, handles);
                    return;
                end
        end
        
        handles.gui_val.rot = 90;
        handles.gui_val.img = imrotate(handles.gui_val.img,handles.gui_val.rot,'bicubic');
        contents_rot = cellstr(get(handles.popup_rot,'String'));
        set(handles.popup_rot, 'Value', find(strcmp(contents_rot, num2str(handles.gui_val.rot))));
     
    elseif strcmpi(handles.gui_val.fExt,'.mrxs') || strcmpi(handles.gui_val.fExt,'.ndpi')
        openslide_load_library();
        WSI = [handles.gui_val.filePath, handles.gui_val.fileName];
        %disp(['Vendor: ',openslide_detect_vendor(WSI)])
        
        % Open whole-slide image
        slidePtr = openslide_open(WSI);

        level_count = openslide_get_level_count(slidePtr);
        level_dims = zeros(level_count,2);
        level_strings = cell(level_count,1);
        for lc = 1:level_count
            [level_dims(lc,1),level_dims(lc,2)] = openslide_get_level_dimensions(slidePtr, lc-1);
            level_strings{lc} = [num2str(level_dims(lc,1)),' x ',num2str(level_dims(lc,2))];
        end
        
        [handles.gui_val.size_lv0(1),handles.gui_val.size_lv0(2)] = openslide_get_level0_dimensions(slidePtr);
        [handles.gui_val.size_img(1),handles.gui_val.size_img(2)] = size(handles.gui_val.img);
        
        handles.gui_val.maxSizeRAW = 0;
        handles.gui_val.minSizeRAW = level_count;
        

        selOpen = get(handles.uipanel_open, 'SelectedObject');
        selOpenTag = get(selOpen, 'Tag');
        switch selOpenTag
            case 'radio_open_auto'
                level_sel = level_count - 2;
                loaded_region = openslide_read_region(slidePtr, 0, 0, level_dims(level_sel,1), level_dims(level_sel,2), 'level', level_sel-1);
                handles.gui_val.img = loaded_region(:,:,2:4);
                
                
            case 'radio_open_man'
                
                [sel,choice] = listdlg('PromptString','Select a resolution:',...
                    'SelectionMode','single','ListSize',[640 200],'ListString',level_strings);
                if choice == true
                    level_sel = sel;
                    loaded_region = openslide_read_region(slidePtr, 0, 0, level_dims(level_sel,1), level_dims(level_sel,2), 'level', level_sel-1);
                    handles.gui_val.img = loaded_region(:,:,2:4);
                else
                    set(handles.edit_open_filename,'String','image not selected');
                    handles.gui_val.img = [];
                    guidata(hObject, handles);
                    return;
                end
        end
        
        [handles.gui_val.size_img(1),handles.gui_val.size_img(2),handles.gui_val.size_img(3)] = size(handles.gui_val.img);
        
        % Close whole-slide image, note that the slidePtr must be removed manually
        openslide_close(slidePtr)
        clear slidePtr
        % Unload library
        openslide_unload_library
        
    else
        handles.gui_val.img = 0;
        handles.gui_val.maxSizeRAW = 1;
        handles.gui_val.minSizeRAW = 1;
    end
else
    set(handles.edit_open_filename,'String','file not selected');
    handles.gui_val.img = [];
    guidata(hObject, handles);
    return;
end

%axes(handles.axes_tma);
%imshow(handles.gui_val.img);

if strcmpi(handles.gui_val.fExt,'.ndpi')
    
    handles = wsi_preprocessing (handles);
    
else
    handles = punch_preprocessing (handles);
    set(handles.edit_thresh, 'String', handles.gui_val.edit_thresh);
    set(handles.edit_limit, 'String', handles.gui_val.edit_limit);
    set(handles.edit_strel, 'String', handles.gui_val.edit_strel);

    handles = punch_objects (handles);
end

for i = 1:numel(handles.gui_val.objects)
    if (handles.gui_val.objects(i).Area == 0 && handles.gui_val.objects(i).BoundingBox(3) == handles.gui_val.refDistance*0.5 && handles.gui_val.objects(i).BoundingBox(4) == handles.gui_val.refDistance*0.5)
        handles.gui_val.objects(i).validTable = 0;
    else
        handles.gui_val.objects(i).validTable = 1;
    end
    handles.gui_val.objects(i).hText = [];
    handles.gui_val.objects(i).hRect = [];
end

axes(handles.axes_tma);
imshow(handles.gui_val.img);

handles = updateGuiTable (hObject,handles);
handles = updateRoi (hObject,handles);

guidata(hObject, handles);



%--------------------------------------------------------------------------

% --- Executes on button press in checkbox_process.
function checkbox_process_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_process

currentState = get(hObject,'Value');

if currentState == true
    set(handles.push_preview, 'Enable', 'on');
    set(handles.edit_thresh, 'Enable', 'on');
    set(handles.edit_limit, 'Enable', 'on');
    set(handles.edit_strel, 'Enable', 'on');
    set(handles.popup_rot, 'Enable', 'on');
else
    set(handles.push_preview, 'Enable', 'off');
    set(handles.edit_thresh, 'Enable', 'off');
    set(handles.edit_limit, 'Enable', 'off');
    set(handles.edit_strel, 'Enable', 'off');
    set(handles.popup_rot, 'Enable', 'off');
end

guidata(hObject, handles);

function edit_thresh_Callback(hObject, eventdata, handles)
% hObject    handle to edit_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_thresh as text
%        str2double(get(hObject,'String')) returns contents of edit_thresh as a double
handles.gui_val.edit_thresh = str2double(get(hObject,'String'));

if handles.gui_val.edit_thresh > 255
    handles.gui_val.edit_thresh = 255;
    set(handles.edit_thresh, 'String', handles.gui_val.edit_thresh);
elseif handles.gui_val.edit_thresh < 1
    handles.gui_val.edit_thresh = 1;
    set(handles.edit_thresh, 'String', handles.gui_val.edit_thresh);
elseif isnan(handles.gui_val.edit_thresh)
    handles.gui_val.edit_thresh = 1;
    set(handles.edit_thresh, 'String', handles.gui_val.edit_thresh);
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_thresh_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_thresh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_limit_Callback(hObject, eventdata, handles)
% hObject    handle to edit_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_limit as text
%        str2double(get(hObject,'String')) returns contents of edit_limit as a double
handles.gui_val.edit_limit = str2double(get(hObject,'String'));

if handles.gui_val.edit_limit < 1
    handles.gui_val.edit_limit = 1;
    set(handles.edit_limit, 'String', handles.gui_val.edit_limit);
% elseif handles.gui_val.edit_limit > 10^10
%     handles.gui_val.edit_limit = 10^10;
%     set(handles.edit_limit, 'String', handles.gui_val.edit_limit);
elseif isnan(handles.gui_val.edit_limit)
    handles.gui_val.edit_limit = 1;
    set(handles.edit_limit, 'String', handles.gui_val.edit_limit);
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_limit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_strel_Callback(hObject, eventdata, handles)
% hObject    handle to edit_strel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_strel as text
%        str2double(get(hObject,'String')) returns contents of edit_strel as a double
handles.gui_val.edit_strel = str2double(get(hObject,'String'));

if handles.gui_val.edit_strel < 1
    handles.gui_val.edit_strel = 1;
    set(handles.edit_strel, 'String', handles.gui_val.edit_strel);
% elseif handles.gui_val.edit_strel > 100
%     handles.gui_val.edit_strel = 100;
%     set(handles.edit_strel, 'String', handles.gui_val.edit_strel);
elseif isnan(handles.gui_val.edit_strel)
    handles.gui_val.edit_strel = 1;
    set(handles.edit_strel, 'String', handles.gui_val.edit_strel);
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_strel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_strel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_rot.
function popup_rot_Callback(hObject, eventdata, handles)
% hObject    handle to popup_rot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_rot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_rot
contents_rot = cellstr(get(hObject,'String'));
handles.gui_val.rot = str2double(contents_rot{get(hObject,'Value')});
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popup_rot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_rot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in popup_fileExt.
function popup_fileExt_Callback(hObject, eventdata, handles)
% hObject    handle to popup_fileExt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popup_fileExt contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_fileExt
contents_fExt = cellstr(get(hObject,'String'));
selection_fExt = contents_fExt{get(hObject,'Value')};

if strcmp(selection_fExt, 'TIF')
    handles.gui_val.export_fExt = '.tif';
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popup_fileExt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_fileExt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in push_preview.
function push_preview_Callback(hObject, eventdata, handles)
% hObject    handle to push_preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.gui_val.rot ~= 0
    handles.gui_val.img = imrotate(handles.gui_val.img,handles.gui_val.rot,'bicubic');
end

handles = punch_preprocessing (handles);
set(handles.edit_thresh, 'String', handles.gui_val.edit_thresh);
set(handles.edit_limit, 'String', handles.gui_val.edit_limit);
set(handles.edit_strel, 'String', handles.gui_val.edit_strel);

handles = punch_objects (handles);
for i = 1:numel(handles.gui_val.objects)
    if (handles.gui_val.objects(i).Area == 0 && handles.gui_val.objects(i).BoundingBox(3) == 200 && handles.gui_val.objects(i).BoundingBox(4) == 200)
        handles.gui_val.objects(i).validTable = 0;
    else
        handles.gui_val.objects(i).validTable = 1;
    end
    handles.gui_val.objects(i).hText = [];
    handles.gui_val.objects(i).hRect = [];
end

figure;
imshow(handles.gui_val.img3);


axes(handles.axes_tma);
imshow(handles.gui_val.img);

handles = updateGuiTable (hObject,handles);
handles = updateRoi (hObject,handles);

guidata(hObject, handles);



%--------------------------------------------------------------------------

% --- Executes on button press in push_add.
function push_add_Callback(hObject, eventdata, handles)
% hObject    handle to push_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = addPunch(hObject,handles);

handles = updateGuiTable (hObject,handles);
guidata(hObject, handles);


% --- Executes on button press in push_del.
function push_del_Callback(hObject, eventdata, handles)
% hObject    handle to push_del (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

try
    for i = 1:length(handles.gui_val.selection)
        delete(handles.gui_val.objects(handles.gui_val.selection(i)).hRect);
        delete(handles.gui_val.objects(handles.gui_val.selection(i)).hText);
    end
    
    handles.gui_val.objects(handles.gui_val.selection) = [];
    
catch ME
    %disp(ME.message);
end

%delete(handles.gui_val.objects(handles.gui_val.selection).hRect);
handles = updateGuiTable (hObject,handles);
guidata(hObject, handles);


% --- Executes on button press in push_update.
function push_update_Callback(hObject, eventdata, handles)
% hObject    handle to push_update (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%handles = updatePunchNumbering (handles);

handles = updateRoi (hObject,handles);

handles = updateGuiTable (hObject,handles);

handles = updatePunchNumbering (handles);

guidata(hObject, handles);





% --- Executes when selected cell(s) is changed in uitable_obj.
function uitable_obj_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable_obj (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(eventdata.Indices)
    selection = eventdata.Indices(:,1);
    selection = unique(selection);
    
    for i = 1:length(handles.gui_val.objects)
        if isa(handles.gui_val.objects(i).hText,'handle') && isvalid(handles.gui_val.objects(i).hText)
            set(handles.gui_val.objects(i).hText, 'color','r');
        end
        if isa(handles.gui_val.objects(i).hRect,'handle') && isvalid(handles.gui_val.objects(i).hRect)
            setColor(handles.gui_val.objects(i).hRect, [0 0 1]);
            setResizable(handles.gui_val.objects(i).hRect,false);
        end
    end
    for i = 1:length(selection)
    if isa(handles.gui_val.objects(selection(i)).hText,'handle') && isvalid(handles.gui_val.objects(selection(i)).hText)
        set(handles.gui_val.objects(selection(i)).hText, 'color','g');
    end
    if isa(handles.gui_val.objects(selection(i)).hRect,'handle') && isvalid(handles.gui_val.objects(selection(i)).hRect)
        setColor(handles.gui_val.objects(selection(i)).hRect, [0 1 0]);
        setResizable(handles.gui_val.objects(selection(i)).hRect,true);
    end
    end
    
    handles.gui_val.selection = selection;
end
guidata(hObject, handles);


% --- Executes when entered data in editable cell(s) in uitable_obj.
function uitable_obj_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable_obj (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.TABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
if ~isempty(eventdata.Indices)
    if eventdata.Indices(1,2) == 2 % change in validTable
        
        selection = eventdata.Indices(:,1);
        selection = unique(selection);
        
        if isa(handles.gui_val.objects(selection).hRect,'handle') && isvalid(handles.gui_val.objects(selection).hRect) && eventdata.NewData == 0
            %setPosition(handles.gui_val.objects(selection).hRect, [1 1 0 0]);
            delete(handles.gui_val.objects(handles.gui_val.selection).hRect);
        elseif eventdata.NewData == 1 % isa(handles.gui_val.objects(selection).hRect,'handle') &&      %isa(handles.gui_val.objects(selection).hRect,'handle') && isvalid(handles.gui_val.objects(selection).hRect) && eventdata.NewData == 1
            %setPosition(handles.gui_val.objects(selection).hRect, handles.gui_val.objects(selection).BoundingBox);
            fcn = makeConstrainToRectFcn('imrect',get(handles.axes_tma,'XLim'),get(handles.axes_tma,'YLim'));
            bb_increse = 0;
            handles.gui_val.objects(selection).hRect = imrect(gca, [handles.gui_val.objects(selection).BoundingBox(1)-bb_increse, handles.gui_val.objects(selection).BoundingBox(2)-bb_increse, handles.gui_val.objects(selection).BoundingBox(3)+2*bb_increse, handles.gui_val.objects(selection).BoundingBox(4)+2*bb_increse]);
            setPositionConstraintFcn(handles.gui_val.objects(selection).hRect,fcn);
            setColor(handles.gui_val.objects(selection).hRect, [0 1 0]);
            setResizable(handles.gui_val.objects(selection).hRect,true);
        end
        
        handles.gui_val.objects(selection).validTable = eventdata.NewData;
        %delete(handles.gui_val.objects(handles.gui_val.selection).hRect);
        
    elseif eventdata.Indices(1,2) == 1 %change punchNum
        selection = eventdata.Indices(:,1);
        selection = unique(selection);
        handles.gui_val.objects(selection).punchNum = eventdata.NewData;
        
        set(handles.gui_val.objects(selection).hText, 'String', handles.gui_val.objects(selection).punchNum);
    end
end
guidata(hObject, handles);

%--------------------------------------------------------------------------

function edit_margin_Callback(hObject, eventdata, handles)
% hObject    handle to edit_margin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_margin as text
%        str2double(get(hObject,'String')) returns contents of edit_margin as a double
handles.gui_val.edit_margin = str2double(get(hObject,'String'));

if handles.gui_val.edit_margin < 0
    handles.gui_val.edit_margin = 0;
    set(handles.edit_margin, 'String', handles.gui_val.edit_margin);
% elseif handles.gui_val.edit_strel > 100
%     handles.gui_val.edit_strel = 100;
%     set(handles.edit_strel, 'String', handles.gui_val.edit_strel);
elseif isnan(handles.gui_val.edit_margin)
    handles.gui_val.edit_margin = 0;
    set(handles.edit_margin, 'String', handles.gui_val.edit_margin);
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_margin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_margin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_extract_one.
function push_extract_one_Callback(hObject, eventdata, handles)
% hObject    handle to push_extract_one (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img_info = imfinfo([handles.gui_val.filePath, handles.gui_val.fileName]);

switch handles.gui_val.fExt
    case  {'.tif', '.tiff'}
        w_small = img_info(handles.gui_val.minSizeRAW).Width;
        h_small = img_info(handles.gui_val.minSizeRAW).Height;
        w_big = img_info(handles.gui_val.maxSizeRAW).Width;
        h_big = img_info(handles.gui_val.maxSizeRAW).Height;

        x_scale = floor(w_big/w_small);
        y_scale = floor(h_big/h_small);

        bb_increse = handles.gui_val.edit_margin;

        %bb2 = { [(round(objects(i).BoundingBox(2))*x_scale)-bb_increse, (round(objects(i).BoundingBox(2)+objects(i).BoundingBox(4))*x_scale)+bb_increse], [(round(objects(i).BoundingBox(1))*y_scale)-bb_increse, (round(objects(i).BoundingBox(1)+objects(i).BoundingBox(3))*y_scale)+bb_increse] } ;
        for i = 1:length(handles.gui_val.selection)
            selBB = round(handles.gui_val.objects(handles.gui_val.selection(i)).BoundingBox);
            pixRegion = { [(selBB(2)*x_scale)-bb_increse, ((selBB(2)+selBB(4))*x_scale)+bb_increse], [( (selBB(1))*y_scale)-bb_increse, ((selBB(1)+selBB(3))*y_scale)+bb_increse] } ;

            %newFileName = [handles.gui_val.filePath,handles.gui_val.fName,'_p',num2str(handles.gui_val.selection(i)),handles.gui_val.fExt];
            newFileName = [handles.gui_val.filePath,handles.gui_val.fName,'_p',num2str(handles.gui_val.objects(handles.gui_val.selection(i)).punchNum),handles.gui_val.fExt];
            imwrite(imread([handles.gui_val.filePath, handles.gui_val.fileName],handles.gui_val.maxSizeRAW,'PixelRegion', pixRegion),newFileName, 'Compression', 'none');
        end

    case '.jp2'
        %img_info.WaveletDecompositionLevels
        w_big = img_info.Width;
        h_big = img_info.Height;
        
        [h_small, w_small, l_small] = size(handles.gui_val.img);
        
        map_idx = reshape(1:h_small*w_small, [h_small, w_small]);
        x_scale = round(w_big/h_small);
        y_scale = round(h_big/w_small);
        
        %rotate the other way than imrotate in Open fcn
        if handles.gui_val.rot == -90
            map_idx_rot = flip(map_idx,2).';
        elseif handles.gui_val.rot == 90
            map_idx_rot = flip(permute(map_idx,[2 1]),2);
        else
            x_scale = round(w_big/w_small);
            y_scale = round(h_big/h_small);
        end
        
        bb_increse = handles.gui_val.edit_margin;
        
        for i = 1:length(handles.gui_val.selection)
            selBB_old = round(handles.gui_val.objects(handles.gui_val.selection(i)).BoundingBox);
            idx_small = map_idx(selBB_old(2),selBB_old(1));
            
            %rotate the other way than imrotate in Open fcn
            if handles.gui_val.rot == -90
                [r_new,c_new] = find(map_idx_rot==idx_small);
                selBB(1) = c_new;
                selBB(2) = r_new - selBB_old(3);
                selBB(3) = selBB_old(4);
                selBB(4) = selBB_old(3);
            elseif handles.gui_val.rot == 90
                [r_new,c_new] = find(map_idx_rot==idx_small);
                selBB(1) = c_new - selBB_old(4);
                selBB(2) = r_new;
                selBB(3) = selBB_old(4);
                selBB(4) = selBB_old(3);
            else
                selBB = selBB_old;
            end
            
%                %testing
%                 figure;imagesc(handles.gui_val.img_L);
%                 hRectTest1 = imrect(gca, [selBB_old(1), selBB_old(2), selBB_old(3), selBB_old(4)]);
%                 figure;imagesc(rot90(handles.gui_val.img_L,3));
%                 hRectTest2 = imrect(gca, [selBB(1), selBB(2), selBB(3), selBB(4)]);
            
            pixRegion = { [(selBB(2)*x_scale)-bb_increse, ((selBB(2)+selBB(4))*x_scale)+bb_increse], [( (selBB(1))*y_scale)-bb_increse, ((selBB(1)+selBB(3))*y_scale)+bb_increse] } ;
            
            newFileName = [handles.gui_val.filePath,handles.gui_val.fName,'_p',num2str(handles.gui_val.selection(i)),handles.gui_val.export_fExt];
            imwrite(imrotate(imread([handles.gui_val.filePath, handles.gui_val.fileName],'ReductionLevel', handles.gui_val.maxSizeRAW,'PixelRegion', pixRegion),handles.gui_val.rot,'bicubic'),newFileName, 'Compression', 'none');
        end

end

guidata(hObject, handles);


% --- Executes on button press in push_extract_all.
function push_extract_all_Callback(hObject, eventdata, handles)
% hObject    handle to push_extract_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img_info = imfinfo([handles.gui_val.filePath, handles.gui_val.fileName]);

switch handles.gui_val.fExt
    case  {'.tif', '.tiff'}
        
        w_small = img_info(handles.gui_val.minSizeRAW).Width;
        h_small = img_info(handles.gui_val.minSizeRAW).Height;
        w_big = img_info(handles.gui_val.maxSizeRAW).Width;
        h_big = img_info(handles.gui_val.maxSizeRAW).Height;
        
        x_scale = round(w_big/w_small);
        y_scale = round(h_big/h_small);
        
        bb_increse = handles.gui_val.edit_margin;
        
        for i = 1:length(handles.gui_val.objects)
            if handles.gui_val.objects(i).validTable
                selBB = round(handles.gui_val.objects(i).BoundingBox);
                pixRegion = { [(selBB(2)*x_scale)-bb_increse, ((selBB(2)+selBB(4))*x_scale)+bb_increse], [( (selBB(1))*y_scale)-bb_increse, ((selBB(1)+selBB(3))*y_scale)+bb_increse] } ;
                
                newFileName = [handles.gui_val.filePath,handles.gui_val.fName,'_p',num2str(handles.gui_val.objects(i).punchNum),handles.gui_val.fExt];
                imwrite(imread([handles.gui_val.filePath, handles.gui_val.fileName],handles.gui_val.maxSizeRAW,'PixelRegion', pixRegion),newFileName, 'Compression', 'none');
            end
        end
        
    case '.jp2'
        w_big = img_info.Width;
        h_big = img_info.Height;
        
        [h_small, w_small, l_small] = size(handles.gui_val.img);
        
        map_idx = reshape(1:h_small*w_small, [h_small, w_small]);
        x_scale = round(w_big/h_small);
        y_scale = round(h_big/w_small);
        
        %rotate the other way than imrotate in Open fcn
        if handles.gui_val.rot == -90
            map_idx_rot = flip(map_idx,2).';
        elseif handles.gui_val.rot == 90
            map_idx_rot = flip(permute(map_idx,[2 1]),2);
        else
            x_scale = round(w_big/w_small);
            y_scale = round(h_big/h_small);
        end
        
        bb_increse = handles.gui_val.edit_margin;
        
        for i = 1:length(handles.gui_val.objects)
            if handles.gui_val.objects(i).validTable
                
                selBB_old = round(handles.gui_val.objects(i).BoundingBox);
                idx_small = map_idx(selBB_old(2),selBB_old(1));

                %rotate the other way than imrotate in Open fcn
                if handles.gui_val.rot == -90
                    [r_new,c_new] = find(map_idx_rot==idx_small);
                    selBB(1) = c_new;
                    selBB(2) = r_new - selBB_old(3);
                    selBB(3) = selBB_old(4);
                    selBB(4) = selBB_old(3);
                elseif handles.gui_val.rot == 90
                    [r_new,c_new] = find(map_idx_rot==idx_small);
                    selBB(1) = c_new - selBB_old(4);
                    selBB(2) = r_new;
                    selBB(3) = selBB_old(4);
                    selBB(4) = selBB_old(3);
                else
                    selBB = selBB_old;
                end
                
                pixRegion = { [(selBB(2)*x_scale)-bb_increse, ((selBB(2)+selBB(4))*x_scale)+bb_increse], [( (selBB(1))*y_scale)-bb_increse, ((selBB(1)+selBB(3))*y_scale)+bb_increse] } ;
                
                newFileName = [handles.gui_val.filePath,handles.gui_val.fName,'_p',num2str(handles.gui_val.objects(i).punchNum),handles.gui_val.export_fExt];
                imwrite(imrotate(imread([handles.gui_val.filePath, handles.gui_val.fileName],'ReductionLevel', handles.gui_val.maxSizeRAW,'PixelRegion', pixRegion),handles.gui_val.rot,'bicubic'),newFileName, 'Compression', 'none');
                
            end
        end
    case {'.mrxs','.ndpi'}
            openslide_load_library();
            WSI = [handles.gui_val.filePath, handles.gui_val.fileName];
            slidePtr = openslide_open(WSI);

            [w_big, h_big] = openslide_get_level0_dimensions(slidePtr);
            
            [h_small, w_small, l_small] = size(handles.gui_val.img);

            %map_idx = reshape(1:h_small*w_small, [h_small, w_small]);
            x_scale = round(w_big/w_small);
            y_scale = round(h_big/h_small);
            
            level_mid = 4;
            [w_mid, h_mid] = openslide_get_level_dimensions(slidePtr, level_mid);
            x_scale_mid = round(w_mid/w_small);
            y_scale_mid = round(h_mid/h_small);
            
            
            bb_increse = handles.gui_val.edit_margin;
            
            textFileName = [handles.gui_val.filePath,handles.gui_val.fName,'_bblv0.txt'];
            textFileID = fopen(textFileName,'w');
            
            textFileName_mid = [handles.gui_val.filePath,handles.gui_val.fName,'_bblv4.txt'];
            textFileID_mid = fopen(textFileName_mid,'w');
            
            disp('Extract: begin...');
            
            for i = 1:length(handles.gui_val.objects)
                if handles.gui_val.objects(i).validTable
                    selBB = round(handles.gui_val.objects(i).BoundingBox);
                    pixRegion = { [(selBB(2)*x_scale)-bb_increse, ((selBB(2)+selBB(4))*x_scale)+bb_increse], [( (selBB(1))*y_scale)-bb_increse, ((selBB(1)+selBB(3))*y_scale)+bb_increse] } ;

                    
                    % process level  mid
                    newFileName_mid = [handles.gui_val.filePath,handles.gui_val.fName,'_mid',num2str(handles.gui_val.objects(i).punchNum),handles.gui_val.export_fExt];
                                        
                    pixStart1_mid = selBB(1)*x_scale;
                    pixStart2_mid = selBB(2)*y_scale;
                    
                    w_region_mid = selBB(3)*x_scale_mid;
                    h_region_mid = selBB(4)*y_scale_mid;
                    
                    %flag_mid = validateImgSize(w_region_mid*h_region_mid);
                    
                    fprintf(textFileID_mid,[handles.gui_val.fName,' ',num2str(i),' ', num2str(pixStart1_mid),' ', num2str(pixStart2_mid),' ', num2str(w_region_mid),' ', num2str(h_region_mid),' \n']);
                    
                    disp(['Extract: processing obj#',num2str(i),'...']);
                    
                    data = uint32(zeros(w_region_mid*h_region_mid,1));
                    region = libpointer('uint32Ptr',data);
                    clear data
                    
                    %[~, region] = calllib('libopenslide','openslide_read_region',slidePtr,region,int64(pixRegion{1}(1)),int64(pixRegion{2}(1)),int32(level),int64(w_region),int64(h_region));
                    [~, region] = calllib('libopenslide','openslide_read_region',slidePtr,region,int64(pixStart1_mid),int64(pixStart2_mid),int32(level_mid),int64(w_region_mid),int64(h_region_mid));
                    % Cast and reformat read data
                    RGBA = typecast(region,'uint8');
                    clear region
                    
                    RGB_region = uint8(zeros(w_region_mid,h_region_mid,3));
                    RGB_region(:,:,1) = reshape(RGBA(3:4:end),w_region_mid,h_region_mid);
                    RGB_region(:,:,2) = reshape(RGBA(2:4:end),w_region_mid,h_region_mid);
                    RGB_region(:,:,3) = reshape(RGBA(1:4:end),w_region_mid,h_region_mid);
                    clear RGBA
                    
                    % Permute image to make sure it is according to standard MATLAB format
                    RGB_region = permute(RGB_region,[2 1 3]);
                    
                    disp(['Extract: saving obj#',num2str(i),'...']);
                    % Write to file
                    imwrite(RGB_region, newFileName_mid, 'Compression', 'none');
                    clear RGB_region
                    disp(['Image saved at:', newFileName_mid]);
                    
                    
                    % process level0
                    if handles.gui_val.extract_lv0
                        level = 0;

                        newFileName = [handles.gui_val.filePath,handles.gui_val.fName,'_p',num2str(handles.gui_val.objects(i).punchNum),handles.gui_val.export_fExt];

                        pixStart1 = selBB(1)*x_scale;
                        pixStart2 = selBB(2)*y_scale;

                        w_region = selBB(3)*x_scale;
                        h_region = selBB(4)*y_scale;

                        fprintf(textFileID,[handles.gui_val.fName,' ',num2str(i),' ', num2str(pixStart1),' ', num2str(pixStart2),' ', num2str(w_region),' ', num2str(h_region),' \n']);

                        %working example
                        %ARGB2 = openslide_read_region(slidePtr,50,370,150,200,'level',7);

                        disp(['Extract: processing full obj#',num2str(i),'...']);
                        
                        %data = uint32(zeros(w_region*h_region,1));
                        %region = libpointer('uint32Ptr',data);
                        %clear data
                        region = libpointer('uint32Ptr',uint32(zeros(w_region*h_region,1)));

                        %[~, region] = calllib('libopenslide','openslide_read_region',slidePtr,region,int64(pixRegion{1}(1)),int64(pixRegion{2}(1)),int32(level),int64(w_region),int64(h_region));
                        [~, region] = calllib('libopenslide','openslide_read_region',slidePtr,region,int64(pixStart1),int64(pixStart2),int32(level),int64(w_region),int64(h_region));
                        % Cast and reformat read data
                        RGBA = typecast(region,'uint8');
                        clear region

                        RGB_region = uint8(zeros(w_region,h_region,3));
                        RGB_region(:,:,1) = reshape(RGBA(3:4:end),w_region,h_region);
                        RGB_region(:,:,2) = reshape(RGBA(2:4:end),w_region,h_region);
                        RGB_region(:,:,3) = reshape(RGBA(1:4:end),w_region,h_region);
                        clear RGBA

                        % Permute image to make sure it is according to standard MATLAB format
                        RGB_region = permute(RGB_region,[2 1 3]);

                        disp(['Extract: saving obj#',num2str(i),'...']);
                        % Write to file
                        try
                            imwrite(RGB_region, newFileName, 'Compression', 'none');
                        catch ME
                            disp(ME.message)
                        end
                        clear RGB_region
                        disp(['Image saved at:', newFileName]);
                    end
                end
            end
            
            fclose(textFileID);
            fclose(textFileID_mid);
            
            % Close whole-slide image, note that the slidePtr must be removed manually
            openslide_close(slidePtr)
            clear slidePtr

            % Unload library
            openslide_unload_library

            
end
guidata(hObject, handles);



% --- Executes on button press in pushbutton_about.
function pushbutton_about_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
helpstring = sprintf('PATMA software \n ver. 0.3 \n PATMA software is designed to extract punches from TMA scanned slides as separate images and it was created during 3 months study in Hospital Verge de la Cinta in Torosa, Spain \n Realted publication: \n Lukasz Roszkowiak and Carlos Lopez "PATMA: Parser of archival tissue microarray", PeerJ 4 (2016): e2741. \n DOI: https://doi.org/10.7717/peerj.2741 ');
dlgname = 'About PATMA';
handles.helpdlg = helpdlg(helpstring,dlgname);

guidata(hObject, handles);


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


function handles = updateGuiTable (hObject,handles)
[~,index] = sortrows([handles.gui_val.objects.punchNum].'); 
handles.gui_val.objects = handles.gui_val.objects(index); 
clear index

bb2str = @(bb) [ (num2str(round(bb(1)))) ,' ', (num2str(round(bb(2)))) ,' ', (num2str(round(bb(3)))) ,' ', (num2str(round(bb(4)))) ];
columnname = {'Punch Number','Valid','Position'};
columnformat = {'numeric','logical','numeric'};
columneditable = [true, true, false];
for i = 1: numel(handles.gui_val.objects)
    propertiesT{i,1} = handles.gui_val.objects(i).punchNum;

    if handles.gui_val.objects(i).validTable
        propertiesT{i,2} = true;
    else
        propertiesT{i,2} = false;
    end
    if validateImgSize(handles.gui_val.objects(i).BoundingBox, handles.gui_val.size_lv0, handles.gui_val.size_img)
        propertiesT{i,3} = bb2str(handles.gui_val.objects(i).BoundingBox);
    else
        propertiesT{i,3} = 'too big';
    end
end

set(handles.uitable_obj, 'ColumnName', columnname);
set(handles.uitable_obj, 'ColumnFormat', columnformat);
set(handles.uitable_obj, 'ColumnEdit', columneditable);
set(handles.uitable_obj, 'Data', propertiesT);

guidata(hObject, handles);


function handles = addPunch(hObject,handles)
myNum = horzcat(handles.gui_val.objects(:).punchNum);
idx = 1:max(myNum(:));

missingNum = [];
if length(myNum) ~= length(idx)
    for i = 1:length(idx)
        if isempty(find(myNum == idx(i),1))
            missingNum = [missingNum, idx(i)];
        end
    end
end

for j = 1: length(missingNum)
    addNum{j,1} = num2str(missingNum(j));
end
if isempty(missingNum)
    addNum{1,1} = [num2str(max(myNum(:))+1), ' (... new)'];
else
    addNum{j+1,1} = [num2str(max(myNum(:))+1), ' (... new)'];
end


[sel,choice] = listdlg('PromptString','Select punch number:',...
                'SelectionMode','single','ListSize',[100 200],'ListString',addNum);

fcn = makeConstrainToRectFcn('imrect',get(handles.axes_tma,'XLim'),get(handles.axes_tma,'YLim'));

if choice 
    ind = numel(handles.gui_val.objects)+1;
    if sel == length(addNum)
        handles.gui_val.objects(ind).punchNum = (max(myNum(:))+1);
    else
        handles.gui_val.objects(ind).punchNum = str2num(addNum{sel});
    end
    handles.gui_val.objects(ind).Area = 0;
    handles.gui_val.objects(ind).Centroid = [50 50];
    handles.gui_val.objects(ind).BoundingBox = [1 1 100 100];
    handles.gui_val.objects(ind).Eccentricity = 0;
    handles.gui_val.objects(ind).validTable = 1;
    handles.gui_val.objects(ind).hText = text(handles.gui_val.objects(ind).Centroid(1), handles.gui_val.objects(ind).Centroid(2), num2str(handles.gui_val.objects(ind).punchNum),'color','r','fontsize', 16);
    bb_increse = 0;
    handles.gui_val.objects(ind).hRect = imrect(gca, [handles.gui_val.objects(ind).BoundingBox(1)-bb_increse, handles.gui_val.objects(ind).BoundingBox(2)-bb_increse, handles.gui_val.objects(ind).BoundingBox(3)+2*bb_increse, handles.gui_val.objects(ind).BoundingBox(4)+2*bb_increse]);
    setResizable(handles.gui_val.objects(ind).hRect,false);
    setPositionConstraintFcn(handles.gui_val.objects(ind).hRect,fcn); 
    
    eventdata.Indices = ind;
    uitable_obj_CellSelectionCallback(hObject, eventdata, handles);
end


handles = updateGuiTable (hObject,handles);
guidata(hObject, handles);


function handles = updateRoi (hObject,handles)

fcn = makeConstrainToRectFcn('imrect',get(handles.axes_tma,'XLim'),get(handles.axes_tma,'YLim'));

for i = 1:length(handles.gui_val.objects)
    
    %rules for boundingbox
    if isa(handles.gui_val.objects(i).hRect,'handle') && isvalid(handles.gui_val.objects(i).hRect) %exist
        %update current position
        currentPosition = getPosition(handles.gui_val.objects(i).hRect);
        handles.gui_val.objects(i).oldPos = handles.gui_val.objects(i).BoundingBox;
        handles.gui_val.objects(i).BoundingBox = currentPosition;
        
        p1 = (currentPosition(1) + 0.5*currentPosition(3));
        p2 = (currentPosition(2) + 0.5*currentPosition(4));
        handles.gui_val.objects(i).oldCent = handles.gui_val.objects(i).Centroid;
        handles.gui_val.objects(i).Centroid = [p1 p2];
        
        if (handles.uitable_obj.Data{i,2}) %valid
            %do nothing
        else
            %deleteroi
            delete(handles.gui_val.objects(i).hRect);
        end
        
    else %nonexist
        if (handles.uitable_obj.Data{i,2}) %valid
            %create
            bb_increse = 0;
            handles.gui_val.objects(i).hRect = imrect(gca, [handles.gui_val.objects(i).BoundingBox(1)-bb_increse, handles.gui_val.objects(i).BoundingBox(2)-bb_increse, handles.gui_val.objects(i).BoundingBox(3)+2*bb_increse, handles.gui_val.objects(i).BoundingBox(4)+2*bb_increse]);
            setPositionConstraintFcn(handles.gui_val.objects(i).hRect,fcn); 
        else
            %do nothing
        end
        
    end
    
    %rules for number text
    if isa(handles.gui_val.objects(i).hText,'handle') && isvalid(handles.gui_val.objects(i).hText)
        set(handles.gui_val.objects(i).hText, 'Position', handles.gui_val.objects(i).Centroid);
        set(handles.gui_val.objects(i).hText, 'String', handles.gui_val.objects(i).punchNum);
        
    else
        handles.gui_val.objects(i).hText = text(handles.gui_val.objects(i).Centroid(1), handles.gui_val.objects(i).Centroid(2), num2str(handles.gui_val.objects(i).punchNum),'color','r','fontsize', 16);
    end
  
end
guidata(hObject, handles);


function handles = updatePunchNumbering (handles)

% for i = 1:numel(handles.gui_val.objects)
%     handles.gui_val.objects(i).punchNum = i;
% end
% [ handles.gui_val.objects ] = tempFun_punchNumberUpdate( handles.gui_val.objects );
[ handles.gui_val.objects ] = punchNumberUpdate( handles.gui_val.objects );


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2

currentState = get(hObject,'Value');

if currentState == true
    handles.gui_val.extract_lv0 = true;
else
    handles.gui_val.extract_lv0 = false;
end

guidata(hObject, handles);


function flag = validateImgSize(testedBB, size_lv0, size_img)

%     % How many bytes does each element occupy in memory?
%     switch (class(data))
%         case {'uint8', 'int8', 'logical'}
% 
%             elementSize = 1;
% 
%         case {'uint16', 'int16'}
% 
%             elementSize = 2;
% 
%         case {'uint32', 'int32', 'single'}
% 
%             elementSize = 4;
% 
%         case {'uint64', 'int64', 'double'}
% 
%             elementSize = 8;
% 
%     end

    x_scale = round(size_lv0(1)/size_img(1));
    y_scale = round(size_lv0(2)/size_img(2));
    x = testedBB(3) * x_scale;
    y = testedBB(4) * y_scale;
    data = x*y;

    elementSize = 1;

    % Validate that the dataset/image will fit within 32-bit offsets.
    max32 = double(intmax('uint32'));

    if ((data * 3 * elementSize) > max32)

        %error(message('MATLAB:imagesci:imwrite:tooMuchData'))
        flag = 0;
        
    else
        flag = 1;

    end
