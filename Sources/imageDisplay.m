%initialisation code
function varargout = imageDisplay(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @imageDisplay_OpeningFcn, ...
                   'gui_OutputFcn',  @imageDisplay_OutputFcn, ...
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


% --- Executes just before imageDisplay is made visible.
function imageDisplay_OpeningFcn(hObject, eventdata, handles, varargin)
	fprintf("please enter name.(file format) of file to show");
	fileName = input("-> ", 's');
	fileID = fopen(fileName); %-> opens the file and assigns it a file descriptor
	%the fscanf funciton will get all the contents of file onto a single array
	singleLineData = fscanf(fileID, '%f');
	numPoints = numel(singleLineData); %numPoints is the number of points defined by 3D object
	%the read lines function is similar to fscanf however it retrieves the
	%contents into a matrix where each element corresponds to a line in the
	%file
	fileAsLines = readlines(fileName);
	params.maxYDimension = numel(fileAsLines); %the number of elements in fileAsLines is the max y dimension of the 3D object
	params.maxXDimension = numPoints/params.maxYDimension; %this leaves the maximum x length to be this
	%-> these variables are put into a STRUCT in order to work with them
	%easier, for example, all dimensions/parameters of the object are in the
	%struct called params.xxx -> this is for useful information that can be
	%passed between files and functions
	%okay, now that we have the file, dimensions and coordinate information we must write
	%a function to input data into a 2D array where each element is a struct
	%containing a coordinate's x,y,z values.
	pntsArray = assignCoordinates(params, singleLineData); %function name is assignCoordinates and we must pass params in so the function know where the boundaries of the file are
	%TEST PNTS_ARRAY using driver function%
	%assignCoordinatesDriver(pntsArray, params); %assingCoordinates returns a correct 2D array for different files
	%these are initial settings that may be changed by the user using
	%callback functions
	view.zDilation = 400/max(singleLineData); %sets the z height appropriate to the max height
	view.xDilation = 1800/params.maxXDimension; %changed these so it is dependant on the image size, better initial starting
	view.yDilation = 1800/params.maxXDimension; %-> the view structure array is how we store variables to change our view ie transforming and dilating the object
	view.xTransform = 250; %tweaked starting position
	view.yTransform = 100;
	view.xRotate = 75;
	view.yRotate = 0;
	view.zRotate = 30;
	params.imageSizeX = 1920; %also can set to 1080 x 720
	params.imageSizeY = 1080;

	%to share data between callback functions must allocate what we need to
	%handles
	handles.view = view;
	handles.pntsArray = pntsArray;
	handles.params = params;
	handles.view.transformSensitivity = 20;

% Choose default command line output for imageDisplay
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes imageDisplay wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = imageDisplay_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in showImage. -> this function also
% calculates everything and displays it.
function showImage_Callback(hObject, eventdata, handles)

%now before projecting our 3D coordinates onto a 2D coordinate space we
%must calculate the rotation matrix needed. %-> function definition is in file
rotationMatrix = calculateRotationMatrix(handles.view.xRotate, handles.view.yRotate, handles.view.zRotate);
%now that we have our rotation matrix, we can use matrix multiplication on
	%all of the points. This will rotate the object by transforming its
	%coordinates to the desired position. All z's will then be turned to zeros
	%to "flatten" the object onto a 2 dimensional plane of x and y.

transformedPntsArray = calculateProjection(handles.pntsArray, rotationMatrix, handles.params, handles.view); %calculate projection will rotate and project the object onto a 2D plane
%running the driver function this can essentially be done with the same
%function as assignCoordinatesDriveer
%calculateProjectionDriver(handles.pntsArray, handles.params);
%it is hard to see whether everything is perfectly accurate because our
%output is just points right now. But all the z's are zeros so it looks
%promising. 
%we cannot simply go imshow(pntsArray), we have to make another 2D array
%that has 255 for each ith, jth element because that corresponds to a
%point. we can use a function for this:
imageArray = zeros(handles.params.imageSizeY, handles.params.imageSizeX) + 40; %changed colour to a lighter gray more aesthetically pleasing
imageArray = uint8(imageArray); %number format in imageArray must be uint8
imageArray = drawPoints(imageArray, transformedPntsArray, handles.params);
imageArray = drawLines(imageArray, transformedPntsArray, handles.params);
%at this stage we can disply imageArray on a figure using imshow() and see
%if the resulting points are accurate for out object.
imshow(imageArray);
%upon testing plat.fdf elem2.fdf 42.fdf and 10-70.fdf we see that it works
%as expected and throws no errors.

% --- Executes on button press in Up.
function Up_Callback(hObject, eventdata, handles)
handles.view.yTransform = handles.view.yTransform - handles.view.transformSensitivity;
showImage_Callback(hObject, eventdata, handles); %runs image function again with the different information in handles
guidata(hObject,handles) %does so that all functions in the future will recieve the same information
%same comments are applicable to all below:

% --- Executes on button press in left.
function left_Callback(hObject, eventdata, handles)
handles.view.xTransform = handles.view.xTransform - handles.view.transformSensitivity;
showImage_Callback(hObject, eventdata, handles);
guidata(hObject,handles)

% --- Executes on button press in down.
function down_Callback(hObject, eventdata, handles)
handles.view.yTransform = handles.view.yTransform + handles.view.transformSensitivity;
showImage_Callback(hObject, eventdata, handles);
guidata(hObject,handles)

% --- Executes on button press in right.
function right_Callback(hObject, eventdata, handles)
% hObject    handle to right (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.view.xTransform = handles.view.xTransform + handles.view.transformSensitivity;
showImage_Callback(hObject, eventdata, handles);
guidata(hObject,handles)


% --- Executes on button press in zoomIn.
function zoomIn_Callback(hObject, eventdata, handles)
handles.view.xDilation = handles.view.xDilation*1.2; %changed to multiplication because it would do weird things when changing with height factor
handles.view.yDilation = handles.view.yDilation*1.2;
handles.view.zDilation = handles.view.zDilation*1.2;
showImage_Callback(hObject, eventdata, handles);
guidata(hObject,handles)

% --- Executes on button press in zoomOut.
function zoomOut_Callback(hObject, eventdata, handles)
handles.view.xDilation = handles.view.xDilation*0.8;
handles.view.yDilation = handles.view.yDilation*0.8;
handles.view.zDilation = handles.view.zDilation*0.8;
showImage_Callback(hObject, eventdata, handles);
guidata(hObject,handles)

% --- Executes on button press in xAxisDecrease.
function xAxisDecrease_Callback(hObject, eventdata, handles)
handles.view.xRotate = handles.view.xRotate - 10;
showImage_Callback(hObject, eventdata, handles);
guidata(hObject,handles)

% --- Executes on button press in yAxisIncrease.
function yAxisIncrease_Callback(hObject, eventdata, handles)
handles.view.yRotate = handles.view.yRotate + 10;
showImage_Callback(hObject, eventdata, handles);
guidata(hObject,handles)

% --- Executes on button press in zAxisIncrease.
function zAxisIncrease_Callback(hObject, eventdata, handles)
handles.view.zRotate = handles.view.zRotate + 10;
showImage_Callback(hObject, eventdata, handles);
guidata(hObject,handles)

% --- Executes on button press in yAxisDecrease.
function yAxisDecrease_Callback(hObject, eventdata, handles)
handles.view.yRotate = handles.view.yRotate - 10;
showImage_Callback(hObject, eventdata, handles);
guidata(hObject,handles)

% --- Executes on button press in zAxisDecrease.
function zAxisDecrease_Callback(hObject, eventdata, handles)
handles.view.zRotate = handles.view.zRotate - 10;
showImage_Callback(hObject, eventdata, handles);
guidata(hObject,handles)


% --- Executes on button press in xAxisIncrease.
function xAxisIncrease_Callback(hObject, eventdata, handles)
handles.view.xRotate = handles.view.xRotate + 10;
showImage_Callback(hObject, eventdata, handles);
guidata(hObject,handles)


% --- Executes on button press in zFactorIncrease.
function zFactorIncrease_Callback(hObject, eventdata, handles)
handles.view.zDilation = handles.view.zDilation*1.2; %changed these to multiplication
showImage_Callback(hObject, eventdata, handles);
guidata(hObject,handles)

% --- Executes on button press in zFactorDecrease
function zFactorDecrease_Callback(hObject, eventdata, handles)
handles.view.zDilation = handles.view.zDilation * 0.8; %changed to multiplication so that it will never go negative
showImage_Callback(hObject, eventdata, handles);
guidata(hObject,handles)


% --- Executes on button press in transformSensivityIncrease.
function transformSensivityIncrease_Callback(hObject, eventdata, handles)
handles.view.transformSensitivity = handles.view.transformSensitivity + 20;
fprintf("transform sensitivity: %d\n", handles.view.transformSensitivity); %print out so user knows
guidata(hObject,handles)

% --- Executes on button press in transformSensivityDecrease.
function transformSensivityDecrease_Callback(hObject, eventdata, handles)
if handles.view.transformSensitivity >= 5 %should not go below zero other wise stuff would be inversed
	handles.view.transformSensitivity = handles.view.transformSensitivity - 20;
	fprintf("transform sensitivity: %d\n", handles.view.transformSensitivity); %print out so user knows
end
guidata(hObject,handles)
