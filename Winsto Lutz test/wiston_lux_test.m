function varargout = wiston_lux_test(varargin)
% WISTON_LUX_TEST MATLAB code for wiston_lux_test.fig
%      WISTON_LUX_TEST, by itself, creates a new WISTON_LUX_TEST or raises the existing
%      singleton*.
%
%      H = WISTON_LUX_TEST returns the handle to a new WISTON_LUX_TEST or the handle to
%      the existing singleton*.
%
%      WISTON_LUX_TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WISTON_LUX_TEST.M with the given input arguments.
%
%      WISTON_LUX_TEST('Property','Value',...) creates a new WISTON_LUX_TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wiston_lux_test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wiston_lux_test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu_file.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wiston_lux_test

% Last Modified by GUIDE v2.5 10-Dec-2013 17:39:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wiston_lux_test_OpeningFcn, ...
                   'gui_OutputFcn',  @wiston_lux_test_OutputFcn, ...
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


% --- Executes just before wiston_lux_test is made visible.
function wiston_lux_test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wiston_lux_test (see VARARGIN)

% Choose default command line output for wiston_lux_test
handles.output = hObject;

%Initializing the handles
handles.image_folder = [];
handles.number_of_images = [];
handles.image = [];
handles.distance = [];
handles.small_circle_central_pixel_columns = [];
handles.small_circle_central_pixel_rows = [];
handles.big_circle_central_pixel_columns = [];
handles.big_circle_central_pixel_rows = [];
handles.critical_distance = [0.75,0.75,0.75,0.75,0.75,0.75,0.75, 0.75]; %this distance is in mm

%Zoom factor
handles.zoom_factor = 18;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wiston_lux_test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wiston_lux_test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_analyze.
function pushbutton_analyze_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_analyze (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%Finding the distance between both centers


for i=1:handles.number_of_images
    
%1. Finding the central pixel for the big circle
[rows_big_circle columns_big_circle] = find(handles.image(:,:,i) >= 2000 & handles.image(:,:,i) <= 2850 );
handles.big_circle_central_pixel_columns(i) = mean(columns_big_circle);
handles.big_circle_central_pixel_rows(i) = mean(rows_big_circle);


%2. Finding the central pixel for the small circle.

%-Finding the values within a margin (In this range we find pixels from the
%big circle and from the small circle
[rows_small_big_circle columns_small_big_circle] = find(handles.image(:,:,i) >= 2050 & handles.image(:,:,i) <= 2400 );
rows_small_big_circle = rows_small_big_circle';
columns_small_big_circle = columns_small_big_circle'; 

%-Filtering out the pixels from the big circle with similar values to the
%small circle. By Doing this is being assumed that the big circle starts
%with pixels of smaller value and towards the centers it moves to higher
%values before the small circle is reached.

%Finding an annulus in the big circle with high values. The pixels of the
%big circle with smaller values are outside this annulus.
[rows_image_values_within_range columns_image_values_within_range] = find(handles.image(:,:,i) >= 2800 & handles.image(:,:,i) <= 2830 );
rows_image_values_within_range = rows_image_values_within_range';
columns_image_values_within_range = columns_image_values_within_range';

%find the maximum values and minimum of the annulus. The pixels from the
%Big Circle with similar values to the one with smaller ones are outside.

maximum_rows_big_circle = max(rows_image_values_within_range) + zeros(1,length(rows_small_big_circle));
minimum_rows_big_circle = min(rows_image_values_within_range) + zeros(1,length(rows_small_big_circle));

maximum_columns_big_circle = max(columns_image_values_within_range) + zeros(1,length(rows_small_big_circle));
minimum_columns_big_circle = min(columns_image_values_within_range) + zeros(1,length(rows_small_big_circle));


%find the index of pixels where both columns comply with the range. This
%will filter out those elements that don't from the big circle.

small_circle_index = ( minimum_rows_big_circle < rows_small_big_circle & rows_small_big_circle < maximum_rows_big_circle  & minimum_columns_big_circle < columns_small_big_circle & columns_small_big_circle < maximum_columns_big_circle);


%finding the pixels that correspond to the small circle
columns_small_circle = columns_small_big_circle(small_circle_index);
rows_small_circle = rows_small_big_circle(small_circle_index);


%Calculating the central pixel for the small circle
handles.small_circle_central_pixel_columns(i) = mean(columns_small_circle);
handles.small_circle_central_pixel_rows(i) = mean(rows_small_circle);
handles.size_of_pixel_rows = handles.size_of_pixel(1,i);
handles.size_of_pixel_columns = handles.size_of_pixel(2,i);



%Calculating the distance between the centers    
handles.distance_between_centers(i) = sqrt(((handles.small_circle_central_pixel_rows(i) - handles.big_circle_central_pixel_rows(i)) .* handles.size_of_pixel_rows).^2 + ((handles.small_circle_central_pixel_columns(i) - handles.big_circle_central_pixel_columns(i)) .* handles.size_of_pixel_columns).^2);


end

guidata(hObject, handles);


%Displaying the results

%Display the results in the text box
comments(1) = {''};
comments(2) = {'Distance Between centers of both circles'};
comments(3) = {''};
for i=1:handles.number_of_images
comments(2*i+2) = {['(GA ' num2str(handles.gantry_angle(i)) '; CP ' num2str(handles.couch_angle(i)) '):        ' num2str(handles.distance_between_centers(i)) ' mm' ]};
comments(2*i+3) = {''};

end
set(handles.text_results,'string',comments);


%Display Pass or Fail
if handles.distance_between_centers < handles.critical_distance
set(handles.text_pass_fail,'string','PASS','ForegroundColor',[0 1 0]);
else
set(handles.text_pass_fail,'string','FAIL','ForegroundColor',[1 0 0]);
end
%Display the points in the axes
  
 
for i=1:handles.number_of_images
   
%Assigning the image to the right axes
eval(['axes(handles.axes_image' num2str(i) ')']);
hold on;
line([handles.small_circle_central_pixel_columns(i), handles.big_circle_central_pixel_columns(i)],[handles.small_circle_central_pixel_rows(i), handles.big_circle_central_pixel_rows(i)],'LineWidth',1.2,'Color','b');
plot(handles.small_circle_central_pixel_columns(i), handles.small_circle_central_pixel_rows(i),'LineWidth',2,'Color','r','Marker','x');
plot(handles.big_circle_central_pixel_columns(i), handles.big_circle_central_pixel_rows(i),'LineWidth',2,'Color','y','Marker','x');
hold off;
end
 
set(handles.text_date,'String', date);
guidata(hObject,handles); 

% --------------------------------------------------------------------
function submenu_close_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



%Cleaning the axes
for i=1:handles.number_of_images
   
%Assigning the image to the right axes
eval(['axes(handles.axes_image' num2str(i) ')']);
imagesc(zeros(786,1024)) %Make sure nothing is displayed at the beginning
colormap(gray);
zoom(handles.zoom_factor);

end

%Initializing the handles
handles.image_folder = [];
handles.number_of_images = [];
handles.image = [];
handles.distance = [];
handles.small_circle_central_pixel_columns = [];
handles.small_circle_central_pixel_rows = [];
handles.big_circle_central_pixel_columns = [];
handles.big_circle_central_pixel_rows = [];


set(handles.text_results,'string',{'';'';'...'});
set(handles.text_pass_fail,'string',{''});
set(handles.pushbutton_analyze,'Enable','off');

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function menu_file_Callback(hObject, eventdata, handles)
% hObject    handle to menu_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function submenu_open_Callback(hObject, eventdata, handles)
% hObject    handle to submenu_open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename_image, pathname] = uigetfile( ...
       {'*.dcm', 'IMAGES(*.dcm)'; ...
        '*.*','CT IMAGES NO EXT (*.*)'}, ...
        'Pick image  file');
if isequal(filename_image,0) || isequal(pathname,0)
    disp('User pressed cancel');
    return
else
    disp(['User selected ', fullfile(pathname, filename_image)]);
end

handles.image_folder = pathname;

%Reading the number of images
all_images_list = dir(handles.image_folder);
handles.number_of_images = length(all_images_list); 

%This step is needed because dir includes two points with name "." and ".."
%which do not correspond to any image.
all_images_list = all_images_list(3:handles.number_of_images);
handles.number_of_images = length(all_images_list); 

handles.image = zeros(768,1024,handles.number_of_images);

%Read all images and assign them to the axes
for i=1:handles.number_of_images
    
%Reading the image    
file_name = fullfile(handles.image_folder, all_images_list(i).name);
handles.image(:,:,i) = dicomread(file_name);
handles.info = dicominfo(file_name);
handles.size_of_pixel(:,i) = handles.info.ImagePlanePixelSpacing; 

handles.gantry_angle(i) = round(handles.info.GantryAngle); 
if handles.gantry_angle(i) == 360
    handles.gantry_angle(i) = 0;
end

handles.couch_angle(i) = round(handles.info.PatientSupportAngle);
if handles.couch_angle(i) == 360
    handles.couch_angle(i) = 0;
end

%Assigning the image to the right axes
eval(['axes(handles.axes_image' num2str(i) ')']);
imagesc(handles.image(:,:,i))
colormap(gray);
zoom(handles.zoom_factor);
axis square; 
axis off;


%Assigning the name of the Image to the string

text_name = ['handles.text_image' num2str(i)];
parameter_name = '''String'''; 
parameter_string_value = ' [ ''Gantry Angle:'' num2str(handles.gantry_angle(i))  ''; Couch Position:''  num2str(handles.couch_angle(i)) ]';
eval(['set(' text_name ',' parameter_name ','  parameter_string_value  ')']);

end


set(handles.pushbutton_analyze,'Enable','on');

guidata(hObject,handles); 


% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%print 'name.pdf'  -dpdf ;

%[pwd ']

fig2pdf(gcf,['Results/Winston_Lux_Results_' date '.pdf']);
