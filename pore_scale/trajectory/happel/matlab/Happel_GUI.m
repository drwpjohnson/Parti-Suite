function varargout = Happel_GUI(varargin)
% HAPPEL_GUI MATLAB code for Happel_GUI.fig
%      HAPPEL_GUI, by itself, creates a new HAPPEL_GUI or raises the existing
%      singleton*.
%
%      H = HAPPEL_GUI returns the handle to a new HAPPEL_GUI or the handle to
%      the existing singleton*.
%
%      HAPPEL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HAPPEL_GUI.M with the given input arguments.
%
%      HAPPEL_GUI('Property','Value',...) creates a new HAPPEL_GUI or raises
%      the existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Happel_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Happel_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Happel_GUI

% Last Modified by GUIDE v2.5 13-Apr-2021 13:30:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Happel_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Happel_GUI_OutputFcn, ...
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

% --------------------------------------------------------------------
function initialize_gui(fig_handle, handles, isreset)
% If the metricdata field is present and the reset flag is false, it means
% we are we are just re-initializing a GUI by calling it from the cmd line
% while it is up. So, bail out as we dont want to reset the data.
% if isfield(handles, 'metricdata') && ~isreset
%     return;
% end



% Update handles structure
guidata(handles.figure1,handles);

% --- Executes just before Happel_GUI is made visible.
function Happel_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Happel_GUI (see VARARGIN)

% Choose default command line output for Happel_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

initialize_gui(hObject, handles, false);

% UIWAIT makes Happel_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Happel_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function npartHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to npartHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function npartHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to npartHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of npartHGUI as text
%        str2double(get(hObject,'String')) returns contents of npartHGUI as a double
 
npartHGUI = str2double(get(hObject, 'String'));
if isnan(npartHGUI)
    set(hObject, 'String', 0);
    errordlg('Input must be a number','Error');
    npartHGUI=1;
end

if npartHGUI<=0||floor(npartHGUI)~=npartHGUI
    set(hObject, 'String', 0);
    errordlg('Input must be a positive integer','Error');
    npartHGUI=1;
end
npartHGUI=round(npartHGUI);
set(hObject, 'String', npartHGUI);
set(handles.npartHGUI, 'String', npartHGUI);


% Save the new npartHGUI value
% handles.metricdata.density = npartHGUI;
guidata(hObject,handles)



% --- Executes on button press in calculate.
% function calculate_Callback(hObject, eventdata, handles)
% % hObject    handle to calculate (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% mass = handles.metricdata.density * handles.metricdata.volume;
% set(handles.mass, 'String', mass);



function attmodeHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to attmodeHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of attmodeHGUI as text
%        str2double(get(hObject,'String')) returns contents of attmodeHGUI as a double
% string1 = 0;
% set(handles.attmodeHGUI, 'String', string1);

attmodeHGUI = str2double(get(hObject, 'String'));
if isnan(attmodeHGUI)
    set(hObject, 'String', 0);
    errordlg('Input must be 0 or 1','Error');
end
attmodeHGUI=round(attmodeHGUI);
if attmodeHGUI~=1&&attmodeHGUI~=0
    set(hObject, 'String', 0);
    errordlg('Input must be 0 or 1','Error');
end
set(hObject, 'String', attmodeHGUI);
set(handles.attmodeHGUI, 'String', attmodeHGUI);
% disable and set deformation parameters to zero
if attmodeHGUI==0
    set(handles.kintHGUI,'Enable','off');
    set(handles.w132HGUI,'Enable','off');
    set(handles.betaHGUI,'Enable','off');
%     set(handles.kintHGUI,'String',0);
%     set(handles.w132HGUI,'String',0);
%     set(handles.betaHGUI,'String',0);
else
    set(handles.kintHGUI,'Enable','on');
    set(handles.w132HGUI,'Enable','on');
    set(handles.betaHGUI,'Enable','on');    
    % check if fields have actual values if not change to defaults
    kintHGUI = str2double(get(handles.kintHGUI, 'String'));
    if kintHGUI==0
        set(handles.kintHGUI,'String',4.36e9);
    end
    w132HGUI = str2double(get(handles.w132HGUI, 'String'));
    if w132HGUI==0
        set(handles.w132HGUI,'String',-2.9e-2);
    end    
    betaHGUI = str2double(get(handles.betaHGUI, 'String'));
    if betaHGUI==0
        set(handles.betaHGUI,'String',0.5);
    end       
end

% --- Executes during object creation, after setting all properties.
function attmodeHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to attmodeHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function clusterHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to clusterHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of clusterHGUI as text
%        str2double(get(hObject,'String')) returns contents of clusterHGUI as a double
clusterHGUI = str2double(get(hObject, 'String'));
% if isnan(clusterHGUI)
%     set(hObject, 'String', 0);
%     errordlg('Input must be 0 or 1','Error');
% end
clusterHGUI=round(clusterHGUI);
if clusterHGUI~=0||isnan(clusterHGUI)
    set(hObject, 'String', 0);
    errordlg('Input must be 0, parallel computing not supported yet in MATLAB version','Error');
end
set(hObject, 'String', clusterHGUI);
set(handles.clusterHGUI, 'String', clusterHGUI);

% --- Executes during object creation, after setting all properties.
function clusterHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clusterHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function vjetHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to vjetHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vjetHGUI as text
%        str2double(get(hObject,'String')) returns contents of vjetHGUI as a double
vjetHGUI = str2double(get(hObject, 'String'));
set(hObject, 'String', vjetHGUI);
set(handles.vjetHGUI, 'String', vjetHGUI);


% --- Executes during object creation, after setting all properties.
function vjetHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vjetHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rlimHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to rlimHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rlimHGUI as text
%        str2double(get(hObject,'String')) returns contents of rlimHGUI as a double
rlimHGUI = str2double(get(hObject, 'String'));
set(hObject, 'String', rlimHGUI);
set(handles.rlimHGUI, 'String', rlimHGUI);
%% compare with FLUID SHELL RADIUS
% warndlg
% extract grain radius and porosity from fields
ag = str2double(get(handles.agHGUI,'String'));
por = str2double(get(handles.porosityHGUI,'String'));
rlimHGUI = str2double(get(handles.rlimHGUI, 'String'));
rbcheck= ag/((1-por)^(1.0/3.0));
if rlimHGUI>rbcheck||rlimHGUI<1.0e-9
    if rlimHGUI>rbcheck
        rlimHGUI=rbcheck;
    end
    if rlimHGUI<1.0e-9
        rlimHGUI=1.0e-9;
    end
    % change rlim value to rb
    set(handles.rlimHGUI, 'String', num2str(rlimHGUI));
    % warn the user
     w3=warndlg('Not valid RLIM, value should be RHAP > RLIM > 1 nm','RLIM Warning');
     waitfor(w3);
end



% --- Executes during object creation, after setting all properties.
function rlimHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rlimHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function porosityHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to porosityHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of porosityHGUI as text
%        str2double(get(hObject,'String')) returns contents of porosityHGUI as a double
porosityHGUI = str2double(get(hObject, 'String'));
set(hObject, 'String', porosityHGUI);
set(handles.porosityHGUI, 'String', porosityHGUI);
%% compare with FLUID SHELL RADIUS
% warndlg
% extract grain radius and porosity from fields
ag = str2double(get(handles.agHGUI,'String'));
por = str2double(get(handles.porosityHGUI,'String'));
rlimHGUI = str2double(get(handles.rlimHGUI, 'String'));
rbcheck= ag/((1-por)^(1.0/3.0));
if rlimHGUI>rbcheck||rlimHGUI<1.0e-6
    % change rlim value to rb
    if rlimHGUI>rbcheck
        rlimHGUI=rbcheck;
    end
    if rlimHGUI<1.0e-6
        rlimHGUI=1.0e-6;
    end
    set(handles.rlimHGUI, 'String', num2str(rlimHGUI));
    % warn the user
     w3=warndlg('Not valid RLIM, value should be RHAP > RLIM > 1 µm','RLIM Warning');
     waitfor(w3);
end

% --- Executes during object creation, after setting all properties.
function porosityHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to porosityHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function agHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to agHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of agHGUI as text
%        str2double(get(hObject,'String')) returns contents of agHGUI as a double
agHGUI = str2double(get(hObject, 'String'));
set(hObject, 'String', agHGUI);
set(handles.agHGUI, 'String', agHGUI);
%% compare with FLUID SHELL RADIUS
% warndlg
% extract grain radius and porosity from fields
ag = str2double(get(handles.agHGUI,'String'));
por = str2double(get(handles.porosityHGUI,'String'));
rlimHGUI = str2double(get(handles.rlimHGUI, 'String'));
rbcheck= ag/((1-por)^(1.0/3.0));
if rlimHGUI>rbcheck||rlimHGUI<1.0e-6
    if rlimHGUI>rbcheck
        rlimHGUI=rbcheck;
    end
    if rlimHGUI<1.0e-6
        rlimHGUI=1.0e-6;
    end
    % change rlim value to rb
    set(handles.rlimHGUI, 'String', num2str(rlimHGUI));
    % warn the user
     w3=warndlg('Not valid RLIM, value should be RHAP > RLIM > 1 µm','RLIM Warning');
     waitfor(w3);
end



% --- Executes during object creation, after setting all properties.
function agHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to agHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rexitHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to rexitHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rexitHGUI as text
%        str2double(get(hObject,'String')) returns contents of rexitHGUI as a double
rexitHGUI = str2double(get(hObject, 'String'));
set(hObject, 'String', rexitHGUI);
set(handles.rexitHGUI, 'String', rexitHGUI);

% --- Executes during object creation, after setting all properties.
function rexitHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rexitHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ttimeHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to ttimeHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ttimeHGUI as text
%        str2double(get(hObject,'String')) returns contents of ttimeHGUI as a double
ttimeHGUI = str2double(get(hObject, 'String'));
set(hObject, 'String', ttimeHGUI);
set(handles.ttimeHGUI, 'String', ttimeHGUI);

% --- Executes during object creation, after setting all properties.
function ttimeHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ttimeHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function tHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to tHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tHGUI as text
%        str2double(get(hObject,'String')) returns contents of tHGUI as a double
tHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',tHGUI); 
set(handles.tHGUI,'String',tHGUI); 

% --- Executes during object creation, after setting all properties.
function tHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function erHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to erHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of erHGUI as text
%        str2double(get(hObject,'String')) returns contents of erHGUI as a double
erHGUI = str2double(get(hObject, 'String'));
set(hObject, 'String', erHGUI);
set(handles.erHGUI, 'String', erHGUI);

% --- Executes during object creation, after setting all properties.
function erHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to erHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function viscHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to viscHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of viscHGUI as text
%        str2double(get(hObject,'String')) returns contents of viscHGUI as a double
viscHGUI = str2double(get(hObject, 'String'));
set(hObject, 'String', viscHGUI);
set(handles.viscHGUI, 'String', viscHGUI);

% --- Executes during object creation, after setting all properties.
function viscHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to viscHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhowHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to rhowHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhowHGUI as text
%        str2double(get(hObject,'String')) returns contents of rhowHGUI as a double
rhowHGUI = str2double(get(hObject, 'String'));
set(hObject, 'String', rhowHGUI);
set(handles.rhowHGUI, 'String', rhowHGUI);

% --- Executes during object creation, after setting all properties.
function rhowHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhowHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhopHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to rhopHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhopHGUI as text
%        str2double(get(hObject,'String')) returns contents of rhopHGUI as a double
rhopHGUI = str2double(get(hObject, 'String'));
set(hObject, 'String', rhopHGUI);
set(handles.rhopHGUI, 'String', rhopHGUI);

% --- Executes during object creation, after setting all properties.
function rhopHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhopHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function apHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to apHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of apHGUI as text
%        str2double(get(hObject,'String')) returns contents of apHGUI as a double
apHGUI = str2double(get(hObject, 'String'));
set(hObject, 'String', apHGUI);
set(handles.apHGUI, 'String', apHGUI);
% warn the user ot colloid size small limit (breaking continuum representation)
if apHGUI<2.0e-8
    %warn user
    m=warndlg('Colloid radius < 20nm approach limits of continuum representations, and have not been validated','Warning');
end
%% TESTING
hetmodepHGUI = str2double(get(handles.hetmodepHGUI, 'String'));
%maximum allowed RHETP and miminum allowed SCOVP for uniform distribution
apHGUI = str2double(get(handles.apHGUI, 'String'));
rhetp0HGUI = str2double(get(handles.rhetp0HGUI, 'String'));
rhetp1HGUI = str2double(get(handles.rhetp1HGUI, 'String'));
scovpHGUI = str2double(get(handles.scovpHGUI, 'String'));

%calculate maximum RHETP0 for uniform distribution based on AP
rhetp0_max = 36.415*(2*apHGUI*1e6)^(0.5333);
rhetp0_max = rhetp0_max*1e-9; %meters
if rhetp0HGUI>rhetp0_max
    m_rhetp_max = 'The colloid heterodomain radius exceeds the limit that allows neglect of colloid rotation, see Ron & Johnson for more information. Upper limit of heterodomain radius used as default';
    warndlg(m_rhetp_max);
    set(handles.rhetp0HGUI, 'String', num2str(rhetp0_max));
end
if scovpHGUI>0
    %calculate minimum SCOVP for uniform distribution based on RHETP and AP
    if hetmodepHGUI == 1
        %value bounds set by Ron and Johnson 2020, the equation of the plane
        %was obtained via fitting to data presented in Figure 1c
        scovp0_min = 10^((1.963*log10(rhetp0HGUI*1e9) - 3.292 - log10(2*apHGUI*1e6))/0.8844);
        if scovpHGUI<scovp0_min
            m_scovp_min = 'The combination of colloid heterodomain radius and surface coverage lie outside the limits that allow neglecting colloid rotation, see Ron & Johnson for more information. Upper heterodomain radius limit and corresponding lower surface coverage limit used as default values';
            warndlg(m_scovp_min);
            set(handles.scovpHGUI, 'String', num2str(scovp0_min));
        end
    else
        rhetp_eqv = sqrt((rhetp0HGUI*1e9)^2.0 + (rhetp1HGUI*1e9)^2.0); 
        scovp0_min = 10^((1.963*log10(rhetp_eqv) - 3.292 - log10(2*apHGUI*1e6))/0.8844);
        if scovpHGUI<scovp0_min
            m_scovp_min = 'The combination of colloid heterodomain radius and surface coverage lie outside the limits that allow neglecting colloid rotation, see Ron & Johnson for more information. Upper heterodomain radius limit and corresponding lower surface coverage limit used as default values';
            warndlg(m_scovp_min);
            set(handles.scovpHGUI, 'String', num2str(scovp0_min));
        end
    end
end

%%
% set output interval factor value (noutHGUI) depending on colloid radius
%using a continuos function log(factor) = -log(ap)-3.301\
% e.g.
% 2 um radius colloid 250
% 200 nm radius colloid 2500
% 20 nm radius colloid 25000
noutHGUI = ceil(10^(-log10(apHGUI)-3.301));
% populate field
set(handles.noutHGUI,'String',num2str(noutHGUI))




% --- Executes during object creation, after setting all properties.
function apHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to apHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







function isHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to isHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of isHGUI as text
%        str2double(get(hObject,'String')) returns contents of isHGUI as a double
isHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',isHGUI); 
set(handles.isHGUI,'String',isHGUI); 

% --- Executes during object creation, after setting all properties.
function isHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to isHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ziHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to ziHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ziHGUI as text
%        str2double(get(hObject,'String')) returns contents of ziHGUI as a double
ziHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',ziHGUI); 
set(handles.ziHGUI,'String',ziHGUI); 
 


% --- Executes during object creation, after setting all properties.
function ziHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ziHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zetapstHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to zetapstHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zetapstHGUI as text
%        str2double(get(hObject,'String')) returns contents of zetapstHGUI as a double
zetapstHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',zetapstHGUI); 
set(handles.zetapstHGUI,'String',zetapstHGUI); 


% --- Executes during object creation, after setting all properties.
function zetapstHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zetapstHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zetacstHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to zetacstHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zetacstHGUI as text
%        str2double(get(hObject,'String')) returns contents of zetacstHGUI as a double
zetacstHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',zetacstHGUI); 
set(handles.zetacstHGUI,'String',zetacstHGUI); 


% --- Executes during object creation, after setting all properties.
function zetacstHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zetacstHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function zetahetHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to zetahetHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zetahetHGUI as text
%        str2double(get(hObject,'String')) returns contents of zetahetHGUI as a double

zetahetHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',zetahetHGUI);
set(handles.zetahetHGUI,'String',zetahetHGUI); 

% --- Executes during object creation, after setting all properties.
function zetahetHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zetahetHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hetmodeHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to hetmodeHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hetmodeHGUI as text
%        str2double(get(hObject,'String')) returns contents of hetmodeHGUI as a double
hetmodeHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',hetmodeHGUI);

hetmodeHGUI = str2double(get(handles.hetmodeHGUI, 'String'));
if or(hetmodeHGUI==5,hetmodeHGUI==9)
    set(handles.rhet0HGUI,'Enable','on');
    set(handles.rhet1HGUI,'Enable','on');
    set(handles.rhet2HGUI,'Enable','off');
    set(handles.scovHGUI,'Enable','on');
    set(handles.zetahetHGUI,'Enable','on');
    
elseif hetmodeHGUI==73
    set(handles.rhet0HGUI,'Enable','on');
    set(handles.rhet1HGUI,'Enable','on');
    set(handles.rhet2HGUI,'Enable','on');
    set(handles.scovHGUI,'Enable','on');
    set(handles.zetahetHGUI,'Enable','on');
    
elseif hetmodeHGUI==1
    set(handles.rhet0HGUI,'Enable','on');
    set(handles.rhet1HGUI,'Enable','off');
    set(handles.rhet2HGUI,'Enable','off');
    set(handles.scovHGUI,'Enable','on');
    set(handles.zetahetHGUI,'Enable','on');
    
else
    set(handles.rhet0HGUI,'Enable','on');
    set(handles.rhet1HGUI,'Enable','off');
    set(handles.rhet2HGUI,'Enable','off');
    set(handles.scovHGUI,'Enable','on');
    set(handles.zetahetHGUI,'Enable','on');
    set(handles.hetmodeHGUI,'String',1.0)
end
 


% --- Executes during object creation, after setting all properties.
function hetmodeHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hetmodeHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhet0HGUI_Callback(hObject, eventdata, handles)
% hObject    handle to rhet0HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet0HGUI as text
%        str2double(get(hObject,'String')) returns contents of rhet0HGUI as a double
rhet0HGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',rhet0HGUI); 

%enable fields if rhet0HGUI is non-zero
rhet0HGUI  = str2double(get(handles.rhet0HGUI, 'String'));
if rhet0HGUI>0
    set(handles.zetahetHGUI,'Enable','on');
    set(handles.hetmodeHGUI,'Enable','on');
    set(handles.scovHGUI,'Enable','on');
    set(handles.scovHGUI,'String',0.0)
    warndlg('Changing heterodomain size impacts surface coverage, please input new Fractional surface coverage value','Warning')
    % change scov field color
    set(handles.scovHGUI,'BackgroundColor','g')
end

%enable fields if rhet0HGUI is non-zero
rhet0HGUI  = str2double(get(handles.rhet0HGUI, 'String'));
if rhet0HGUI==0
    set(handles.zetahetHGUI,'Enable','off');
    set(handles.hetmodeHGUI,'Enable','off');
    set(handles.rhet1HGUI,'Enable','off');
    set(handles.rhet2HGUI,'Enable','off');
    set(handles.scovHGUI,'Enable','off');
    set(handles.scovHGUI,'String',0.0)
end

set(handles.scovHGUI,'String',0.0)

set(handles.rhet0HGUI,'String',rhet0HGUI); 


 

% --- Executes during object creation, after setting all properties.
function rhet0HGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet0HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhet1HGUI_Callback(hObject, eventdata, handles)
% hObject    handle to rhet1HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet1HGUI as text
%        str2double(get(hObject,'String')) returns contents of rhet1HGUI as a double
rhet1HGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',rhet1HGUI); 
set(handles.rhet1HGUI,'String',rhet1HGUI); 


% --- Executes during object creation, after setting all properties.
function rhet1HGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet1HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scovHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to scovHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scovHGUI as text
%        str2double(get(hObject,'String')) returns contents of scovHGUI as a double
global SCOV
SCOV = str2double(get(hObject,'String' )); 
set(handles.scovHGUI, 'String', num2str(SCOV));

if SCOV <= 0.0||isnan(SCOV)||SCOV>1.0
    SCOV = 0.0;
    set(handles.scovHGUI, 'String', num2str(0.0));
else    
    set(handles.zetahetHGUI, 'Enable', 'on');
    set(handles.hetmodeHGUI, 'Enable', 'on');
    set(handles.rhet0HGUI, 'Enable', 'on');
    HAP_hetdomain_info()

end
if SCOV==0.0     
    set(handles.zetahetHGUI, 'Enable', 'off');
    set(handles.hetmodeHGUI, 'Enable', 'off');
    set(handles.rhet0HGUI, 'Enable', 'off');
    set(handles.rhet1HGUI, 'Enable', 'off');
    set(handles.rhet2HGUI, 'Enable', 'off');
end
set(handles.scovHGUI,'BackgroundColor','w')


%not allow fractional SCOV larger than 1
scovHGUI = str2double(get(handles.scovHGUI, 'String'));
if scovHGUI>1
    set(handles.scovHGUI, 'String', num2str(0.0));
    m_scov_max = 'Surface coverage cannot exceed unity';
    warndlg(m_scov_max);
end 




% --- Executes during object creation, after setting all properties.
function scovHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scovHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function edit94_Callback(hObject, eventdata, handles)
% hObject    handle to edit94 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit94 as text
%        str2double(get(hObject,'String')) returns contents of edit94 as a double


% --- Executes during object creation, after setting all properties.
function edit94_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit94 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit93_Callback(hObject, eventdata, handles)
% hObject    handle to edit93 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit93 as text
%        str2double(get(hObject,'String')) returns contents of edit93 as a double


% --- Executes during object creation, after setting all properties.
function edit93_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit93 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vdwmodeHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to vdwmodeHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vdwmodeHGUI as text
%        str2double(get(hObject,'String')) returns contents of vdwmodeHGUI as a double
vdwmodeHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',vdwmodeHGUI); 
set(handles.vdwmodeHGUI,'String',vdwmodeHGUI); 

% get rmode value
rmodeHGUI = str2double(get(handles.rmodeHGUI,'String')); 
if vdwmodeHGUI>1&&rmodeHGUI>0
    % warning message
    f = warndlg('Roughness not accounted for in layered van der Waals. Roughness is accounted for in the other interactions','Warning'); 
end
% non-layered surfaces
if vdwmodeHGUI==1
    set(handles.a11HGUI,'Enable','off')
    set(handles.ac1c1HGUI,'Enable','off')
    set(handles.a22HGUI,'Enable','off')
    set(handles.ac2c2HGUI,'Enable','off')
    set(handles.a33HGUI,'Enable','off')
    set(handles.t1HGUI,'Enable','off')
    set(handles.t2HGUI,'Enable','off') 
%
    set(handles.a11HGUI,'String',0.0)
    set(handles.ac1c1HGUI,'String',0.0)
    set(handles.a22HGUI,'String',0.0)
    set(handles.ac2c2HGUI,'String',0.0)
    set(handles.a33HGUI,'String',0.0)
    set(handles.t1HGUI,'String',0.0)
    set(handles.t2HGUI,'String',0.0)   
end
% both surfaces layered
if vdwmodeHGUI==2
    set(handles.a11HGUI,'Enable','on')
    set(handles.ac1c1HGUI,'Enable','on')
    set(handles.a22HGUI,'Enable','on')
    set(handles.ac2c2HGUI,'Enable','on')
    set(handles.a33HGUI,'Enable','on')
    set(handles.t1HGUI,'Enable','on')
    set(handles.t2HGUI,'Enable','on')
end
% only collector surface layered
if vdwmodeHGUI==3
    set(handles.a11HGUI,'Enable','on')
    set(handles.ac1c1HGUI,'Enable','off')
    set(handles.a22HGUI,'Enable','on')
    set(handles.ac2c2HGUI,'Enable','on')
    set(handles.a33HGUI,'Enable','on')
    set(handles.t1HGUI,'Enable','off')
    set(handles.t2HGUI,'Enable','on') 
%
    %set(handles.a11HGUI,'String',0.0)
    set(handles.ac1c1HGUI,'String',0.0)
    %set(handles.a22HGUI,'String',0.0)
    %set(handles.ac2c2HGUI,'String',0.0)
    %set(handles.a33HGUI,'String',0.0)
    set(handles.t1HGUI,'String',0.0)
    %set(handles.t2HGUI,'String',0.0)       
end
% only colloid surface layered
if vdwmodeHGUI==4
    set(handles.a11HGUI,'Enable','on')
    set(handles.ac1c1HGUI,'Enable','on')
    set(handles.a22HGUI,'Enable','on')
    set(handles.ac2c2HGUI,'Enable','off')
    set(handles.a33HGUI,'Enable','on')
    set(handles.t1HGUI,'Enable','on')
    set(handles.t2HGUI,'Enable','off') 
%
    %set(handles.a11HGUI,'String',0.0)
    %set(handles.ac1c1HGUI,'String',0.0)
    %set(handles.a22HGUI,'String',0.0)
    set(handles.ac2c2HGUI,'String',0.0)
    %set(handles.a33HGUI,'String',0.0)
    %set(handles.t1HGUI,'String',0.0)
    set(handles.t2HGUI,'String',0.0)     
end


% --- Executes during object creation, after setting all properties.
function vdwmodeHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vdwmodeHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lambdavdwHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to lambdavdwHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambdavdwHGUI as text
%        str2double(get(hObject,'String')) returns contents of lambdavdwHGUI as a double
lambdavdwHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',lambdavdwHGUI); 
set(handles.lambdavdwHGUI,'String',lambdavdwHGUI); 
 

% --- Executes during object creation, after setting all properties.
function lambdavdwHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambdavdwHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a132HGUI_Callback(hObject, eventdata, handles)
% hObject    handle to a132HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a132HGUI as text
%        str2double(get(hObject,'String')) returns contents of a132HGUI as a double
a132HGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',a132HGUI); 
set(handles.a132HGUI,'String',a132HGUI); 


% --- Executes during object creation, after setting all properties.
function a132HGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a132HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a11HGUI_Callback(hObject, eventdata, handles)
% hObject    handle to a11HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a11HGUI as text
%        str2double(get(hObject,'String')) returns contents of a11HGUI as a double
a11HGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',a11HGUI); 
set(handles.a11HGUI,'String',a11HGUI); 


% --- Executes during object creation, after setting all properties.
function a11HGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a11HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ac1c1HGUI_Callback(hObject, eventdata, handles)
% hObject    handle to ac1c1HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ac1c1HGUI as text
%        str2double(get(hObject,'String')) returns contents of ac1c1HGUI as a double
ac1c1HGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',ac1c1HGUI); 
set(handles.ac1c1HGUI,'String',ac1c1HGUI); 
 

% --- Executes during object creation, after setting all properties.
function ac1c1HGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ac1c1HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit111_Callback(hObject, eventdata, handles)
% hObject    handle to edit111 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit111 as text
%        str2double(get(hObject,'String')) returns contents of edit111 as a double


% --- Executes during object creation, after setting all properties.
function edit111_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit111 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a22HGUI_Callback(hObject, eventdata, handles)
% hObject    handle to a22HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a22HGUI as text
%        str2double(get(hObject,'String')) returns contents of a22HGUI as a double
a22HGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',a22HGUI); 
set(handles.a22HGUI,'String',a22HGUI); 
 


% --- Executes during object creation, after setting all properties.
function a22HGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a22HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ac2c2HGUI_Callback(hObject, eventdata, handles)
% hObject    handle to ac2c2HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ac2c2HGUI as text
%        str2double(get(hObject,'String')) returns contents of ac2c2HGUI as a double
ac2c2HGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',ac2c2HGUI); 
set(handles.ac2c2HGUI,'String',ac2c2HGUI); 
 

% --- Executes during object creation, after setting all properties.
function ac2c2HGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ac2c2HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a33HGUI_Callback(hObject, eventdata, handles)
% hObject    handle to a33HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a33HGUI as text
%        str2double(get(hObject,'String')) returns contents of a33HGUI as a double
a33HGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',a33HGUI); 
set(handles.a33HGUI,'String',a33HGUI); 
 

% --- Executes during object creation, after setting all properties.
function a33HGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a33HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function t1HGUI_Callback(hObject, eventdata, handles)
% hObject    handle to t1HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t1HGUI as text
%        str2double(get(hObject,'String')) returns contents of t1HGUI as a double
t1HGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',t1HGUI); 
set(handles.t1HGUI,'String',t1HGUI); 
 


% --- Executes during object creation, after setting all properties.
function t1HGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t1HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function t2HGUI_Callback(hObject, eventdata, handles)
% hObject    handle to t2HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of t2HGUI as text
%        str2double(get(hObject,'String')) returns contents of t2HGUI as a double
t2HGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',t2HGUI); 
set(handles.t2HGUI,'String',t2HGUI); 
 


% --- Executes during object creation, after setting all properties.
function t2HGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to t2HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function bHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to bHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bHGUI as text
%        str2double(get(hObject,'String')) returns contents of bHGUI as a double
bHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',bHGUI); 
set(handles.bHGUI,'String',bHGUI); 
 


% --- Executes during object creation, after setting all properties.
function bHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function gamma0abHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to gamma0abHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gamma0abHGUI as text
%        str2double(get(hObject,'String')) returns contents of gamma0abHGUI as a double
gamma0abHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',gamma0abHGUI); 
set(handles.gamma0abHGUI,'String',gamma0abHGUI); 
 


% --- Executes during object creation, after setting all properties.
function gamma0abHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma0abHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lambdaabHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to lambdaabHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambdaabHGUI as text
%        str2double(get(hObject,'String')) returns contents of lambdaabHGUI as a double
lambdaabHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',lambdaabHGUI); 
set(handles.lambdaabHGUI,'String',lambdaabHGUI); 
 


% --- Executes during object creation, after setting all properties.
function lambdaabHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambdaabHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gamma0steHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to gamma0steHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gamma0steHGUI as text
%        str2double(get(hObject,'String')) returns contents of gamma0steHGUI as a double
gamma0steHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',gamma0steHGUI); 
set(handles.gamma0steHGUI,'String',gamma0steHGUI); 
 

% --- Executes during object creation, after setting all properties.
function gamma0steHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gamma0steHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lambdasteHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to lambdasteHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambdasteHGUI as text
%        str2double(get(hObject,'String')) returns contents of lambdasteHGUI as a double
lambdasteHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',lambdasteHGUI); 
set(handles.lambdasteHGUI,'String',lambdasteHGUI); 


% --- Executes during object creation, after setting all properties.
function lambdasteHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambdasteHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit133_Callback(hObject, eventdata, handles)
% hObject    handle to edit133 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit133 as text
%        str2double(get(hObject,'String')) returns contents of edit133 as a double


% --- Executes during object creation, after setting all properties.
function edit133_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit133 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit134_Callback(hObject, eventdata, handles)
% hObject    handle to edit134 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit134 as text
%        str2double(get(hObject,'String')) returns contents of edit134 as a double


% --- Executes during object creation, after setting all properties.
function edit134_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit134 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit135_Callback(hObject, eventdata, handles)
% hObject    handle to edit135 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit135 as text
%        str2double(get(hObject,'String')) returns contents of edit135 as a double


% --- Executes during object creation, after setting all properties.
function edit135_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit135 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function kintHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to kintHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kintHGUI as text
%        str2double(get(hObject,'String')) returns contents of kintHGUI as a double
kintHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',kintHGUI); 
set(handles.kintHGUI,'String',kintHGUI); 
 

% --- Executes during object creation, after setting all properties.
function kintHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kintHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function w132HGUI_Callback(hObject, eventdata, handles)
% hObject    handle to w132HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w132HGUI as text
%        str2double(get(hObject,'String')) returns contents of w132HGUI as a double
w132HGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',w132HGUI); 
set(handles.w132HGUI,'String',w132HGUI); 


% --- Executes during object creation, after setting all properties.
function w132HGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to w132HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function betaHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to betaHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of betaHGUI as text
%        str2double(get(hObject,'String')) returns contents of betaHGUI as a double
betaHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',betaHGUI); 
set(handles.betaHGUI,'String',betaHGUI); 


% --- Executes during object creation, after setting all properties.
function betaHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to betaHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit139_Callback(hObject, eventdata, handles)
% hObject    handle to edit139 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit139 as text
%        str2double(get(hObject,'String')) returns contents of edit139 as a double


% --- Executes during object creation, after setting all properties.
function edit139_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit139 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function diffscaleHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to diffscaleHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diffscaleHGUI as text
%        str2double(get(hObject,'String')) returns contents of diffscaleHGUI as a double
diffscaleHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',diffscaleHGUI); 
set(handles.diffscaleHGUI,'String',diffscaleHGUI); 
 


% --- Executes during object creation, after setting all properties.
function diffscaleHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diffscaleHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gravfactHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to gravfactHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gravfactHGUI as text
%        str2double(get(hObject,'String')) returns contents of gravfactHGUI as a double
gravfactHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',gravfactHGUI); 
set(handles.gravfactHGUI,'String',gravfactHGUI); 


% --- Executes during object creation, after setting all properties.
function gravfactHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gravfactHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function multbHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to multbHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of multbHGUI as text
%        str2double(get(hObject,'String')) returns contents of multbHGUI as a double
multbHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',multbHGUI); 
set(handles.multbHGUI,'String',multbHGUI); 
 


% --- Executes during object creation, after setting all properties.
function multbHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multbHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function multnsHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to multnsHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of multnsHGUI as text
%        str2double(get(hObject,'String')) returns contents of multnsHGUI as a double
multnsHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',multnsHGUI); 
set(handles.multnsHGUI,'String',multnsHGUI); 
 


% --- Executes during object creation, after setting all properties.
function multnsHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multnsHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function multcHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to multcHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of multcHGUI as text
%        str2double(get(hObject,'String')) returns contents of multcHGUI as a double
multcHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',multcHGUI); 
set(handles.multcHGUI,'String',multcHGUI); 
 

% --- Executes during object creation, after setting all properties.
function multcHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to multcHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dfactnsHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to dfactnsHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dfactnsHGUI as text
%        str2double(get(hObject,'String')) returns contents of dfactnsHGUI as a double
dfactnsHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',dfactnsHGUI); 
set(handles.dfactnsHGUI,'String',dfactnsHGUI); 
 


% --- Executes during object creation, after setting all properties.
function dfactnsHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dfactnsHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dfactcHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to dfactcHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dfactcHGUI as text
%        str2double(get(hObject,'String')) returns contents of dfactcHGUI as a double
dfactcHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',dfactcHGUI); 
set(handles.dfactcHGUI,'String',dfactcHGUI); 
 


% --- Executes during object creation, after setting all properties.
function dfactcHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dfactcHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% function inputnameHGUI_Callback(hObject, eventdata, handles)
% % hObject    handle to inputnameHGUI (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of inputnameHGUI as text
% %        str2double(get(hObject,'String')) returns contents of inputnameHGUI as a double
% inputnameHGUI = get(hObject,'String'); 
% set(hObject,'String',inputnameHGUI); 
% set(handles.inputnameHGUI,'String',inputnameHGUI); 


% --- Executes during object creation, after setting all properties.
% function inputnameHGUI_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to inputnameHGUI (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end



function outdirHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to outdirHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outdirHGUI as text
%        str2double(get(hObject,'String')) returns contents of outdirHGUI as a double
outdirHGUI = get(hObject,'String'); 
set(hObject,'String',outdirHGUI); 
set(handles.outdirHGUI,'String',outdirHGUI); 
 


% --- Executes during object creation, after setting all properties.
function outdirHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outdirHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function noutHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to noutHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noutHGUI as text
%        str2double(get(hObject,'String')) returns contents of noutHGUI as a double
noutHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',noutHGUI); 
set(handles.noutHGUI,'String',noutHGUI); 





    

 
% --- Executes during object creation, after setting all properties.
function noutHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noutHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function printmaxHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to printmaxHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of printmaxHGUI as text
%        str2double(get(hObject,'String')) returns contents of printmaxHGUI as a double
printmaxHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',printmaxHGUI); 
set(handles.printmaxHGUI,'String',printmaxHGUI); 
 

% --- Executes during object creation, after setting all properties.
function printmaxHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to printmaxHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in runHAP.
function runHAP_Callback(hObject, eventdata, handles)
% hObject    handle to runHAP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% % witing message
% wait_msg1_HGUI
% w = waitforbuttonpress;
%% disable simplotCHECK
set(handles.simplotCHECK,'Enable','off')
%% reset interface aspect
% change font color to indicate normal mode of values
hEditBoxes = findobj('Type','uicontrol','Style','edit');
set(hEditBoxes,'Foregroundcolor','k');
% disable buttons
set(handles.loadATT,'Enable','off');
set(handles.loadATT,'Backgroundcolor',[0.8 0.8 0.8]);
set(handles.loadREM,'Enable','off');
set(handles.loadREM,'Backgroundcolor',[0.8 0.8 0.8]);
set(handles.runPERT,'Enable','off');
set(handles.runPERT,'Backgroundcolor',[0.8 0.8 0.8])
%% change buttom color while model is running 
set(gcbo,'Backgroundcolor','y');
%% declare global variables for etas
global eta2 eta4 eta5 eta6 RB
% reset rhap and eta values
set(handles.RHAPtext,'String','calculate')
set(handles.eta2text,'String','calculate')
set(handles.eta4text,'String','calculate')
set(handles.eta5text,'String','calculate')
set(handles.eta6text,'String','calculate')
set(handles.eta6text,'String','calculate')
set(handles.etatottext,'String','calculate')
%% declare global variables from fields
 global NPART ATTMODE CLUSTER 
 NPART= get(handles.npartHGUI,'String'); NPART=str2double(NPART);
 ATTMODE= get(handles.attmodeHGUI,'String'); ATTMODE=str2double(ATTMODE);
 CLUSTER= get(handles.clusterHGUI,'String'); CLUSTER=str2double(CLUSTER);
 global VJET RLIM POROSITY AG  TTIME VSUP%REXIT
 VJET= get(handles.vjetHGUI,'String'); VJET=str2double(VJET);
 VSUP = VJET;
 RLIM= get(handles.rlimHGUI,'String'); RLIM=str2double(RLIM);
% check values and warn user RLIM ATTMODE
if RLIM<=0.0
    w2=warndlg('Not valid RLIM, use positive non-zero values, set to 1 µm by default','RLIM Warning');
    waitfor(w2);
    RLIM = 1e-6;
end
 POROSITY= get(handles.porosityHGUI,'String'); POROSITY=str2double(POROSITY);
 AG= get(handles.agHGUI,'String'); AG=str2double(AG);
%  REXIT= get(handles.rexitHGUI,'String'); REXIT=str2double(REXIT);
 TTIME= get(handles.ttimeHGUI,'String'); TTIME=str2double(TTIME);
 global AP RHOP RHOW VISC ER T
 AP= get(handles.apHGUI,'String'); AP=str2double(AP);
 RHOP= get(handles.rhopHGUI,'String'); RHOP=str2double(RHOP);
 RHOW= get(handles.rhowHGUI,'String'); RHOW=str2double(RHOW);
 VISC= get(handles.viscHGUI,'String'); VISC=str2double(VISC);
 ER= get(handles.erHGUI,'String'); ER=str2double(ER);
 T=get(handles.tHGUI,'String');T=str2double(T);
 global IS ZI ZETAPST ZETACST
 IS=get(handles.isHGUI,'String');IS=str2double(IS);
 ZI=get(handles.ziHGUI,'String');ZI=str2double(ZI);
 ZETAPST=get(handles.zetapstHGUI,'String');ZETAPST=str2double(ZETAPST);
 ZETACST=get(handles.zetacstHGUI,'String');ZETACST=str2double(ZETACST);
 global ZETAHET HETMODE RHET0 RHET1 RHET2 SCOV
 ZETAHET=get(handles.zetahetHGUI,'String');ZETAHET=str2double(ZETAHET);
 HETMODE=get(handles.hetmodeHGUI,'String');HETMODE=str2double(HETMODE);
 RHET0=get(handles.rhet0HGUI,'String');RHET0=str2double(RHET0);
 RHET1=get(handles.rhet1HGUI,'String');RHET1=str2double(RHET1);
 RHET2=get(handles.rhet2HGUI,'String');RHET2=str2double(RHET2);
 SCOV=get(handles.scovHGUI,'String');SCOV=str2double(SCOV);
 global ZETAHETP HETMODEP RHETP0 RHETP1 SCOVP
 ZETAHETP=get(handles.zetahetpHGUI,'String');ZETAHETP=str2double(ZETAHETP);
 HETMODEP=get(handles.hetmodepHGUI,'String');HETMODEP=str2double(HETMODEP);
 RHETP0=get(handles.rhetp0HGUI,'String');RHETP0=str2double(RHETP0);
 RHETP1=get(handles.rhetp1HGUI,'String');RHETP1=str2double(RHETP1);
 SCOVP=get(handles.scovpHGUI,'String');SCOVP=str2double(SCOVP); 
 global A132 LAMBDAVDW VDWMODE
 A132=get(handles.a132HGUI,'String');A132=str2double(A132);
 LAMBDAVDW=get(handles.lambdavdwHGUI,'String');LAMBDAVDW=str2double(LAMBDAVDW);
 VDWMODE=get(handles.vdwmodeHGUI,'String');VDWMODE=str2double(VDWMODE);
 global A11 AC1C1 A22 AC2C2 A33 T1 T2
 A11=get(handles.a11HGUI,'String');A11=str2double(A11);
 AC1C1=get(handles.ac1c1HGUI,'String');AC1C1=str2double(AC1C1);
 A22=get(handles.a22HGUI,'String');A22=str2double(A22);
 AC2C2=get(handles.ac2c2HGUI,'String');AC2C2=str2double(AC2C2);
 A33=get(handles.a33HGUI,'String');A33=str2double(A33);
 T1=get(handles.t1HGUI,'String');T1=str2double(T1);
 T2=get(handles.t2HGUI,'String');T2=str2double(T2);
 global GAMMA0AB LAMBDAAB GAMMA0STE LAMBDASTE B RMODE ASP
 GAMMA0AB=get(handles.gamma0abHGUI,'String');GAMMA0AB=str2double(GAMMA0AB);
 LAMBDAAB=get(handles.lambdaabHGUI,'String');LAMBDAAB=str2double(LAMBDAAB);
 GAMMA0STE=get(handles.gamma0steHGUI,'String');GAMMA0STE=str2double(GAMMA0STE);
 LAMBDASTE=get(handles.lambdasteHGUI,'String');LAMBDASTE=str2double(LAMBDASTE);
 B=get(handles.bHGUI,'String');B=str2double(B);
 RMODE=get(handles.rmodeHGUI,'String');RMODE=str2double(RMODE);
 ASP=get(handles.aspHGUI,'String');ASP=str2double(ASP);
 global KINT W132 BETA DIFFSCALE GRAVFACT
 KINT=get(handles.kintHGUI,'String');KINT=str2double(KINT);
 W132=get(handles.w132HGUI,'String');W132=str2double(W132); 
 BETA=get(handles.betaHGUI,'String');BETA=str2double(BETA);
 DIFFSCALE=get(handles.diffscaleHGUI,'String');DIFFSCALE=str2double(DIFFSCALE);
 GRAVFACT=get(handles.gravfactHGUI,'String');GRAVFACT=str2double(GRAVFACT);
 global MULTB MULTNS MULTC DFACTNS DFACTC
 MULTB=get(handles.multbHGUI,'String');MULTB=str2double(MULTB);
 MULTNS=get(handles.multnsHGUI,'String');MULTNS=str2double(MULTNS);
 MULTC=get(handles.multcHGUI,'String');MULTC=str2double(MULTC);
 DFACTNS=get(handles.dfactnsHGUI,'String');DFACTNS=str2double(DFACTNS); 
 DFACTC=get(handles.dfactcHGUI,'String');DFACTC=str2double(DFACTC);
 global NOUT PRINTMAX
 NOUT=get(handles.noutHGUI,'String');NOUT=str2double(NOUT);
 PRINTMAX=get(handles.printmaxHGUI,'String');PRINTMAX=str2double(PRINTMAX);
 global INPUTNAME OUTDIR 
 OUTDIR=get(handles.outdirHGUI,'String');
 INPUTNAME= strcat('.input.',OUTDIR);
 global mainworkdir workdir finput
 global oldATTMODE simplot detplot saveSIMPLOT
 %reset attmode field in case perturbation was ran before
 if ATTMODE == -1 % pertubation mode set this automatically
    set(handles.attmodeHGUI,'Enable','on');
    set(handles.attmodeHGUI,'String',num2str(oldATTMODE,'%d'));
    ATTMODE =oldATTMODE;
 end
 % get savesimplot value
 saveSIMPLOT=get(handles.saveSIMPLOT,'Value');
 % get gravity alignment checkboxes values
 global cbPZ cbMZ cbPX cbMX
 cbPZ=get(handles.cbPZ,'value');
 cbMZ=get(handles.cbMZ,'value');
 cbPX=get(handles.cbPX,'value');
 cbMX=get(handles.cbMX,'value');
 % get detailed plot checkboxes values
 global simplotCHECK detplotCHECK
 simplotCHECK=get(handles.simplotCHECK,'value');
 detplotCHECK=get(handles.detplotCHECK,'value');
 
 %indicate busy GUI
 set(handles.figure1, 'pointer', 'watch') 
drawnow;
% 
%% create directory to locate  input and output files
%  create string from output directory  
outs = strcat('\',OUTDIR,'\');
% set working directory        
% if ~isdeployed
%     % MATLAB environment
%     workdir = strrep(mfilename('fullpath'),'\Happel_GUI','\');
%     mkdir(workdir,OUTDIR);
%     workdir = strrep(mfilename('fullpath'),'\Happel_GUI',outs);
% else
%     %deployed application
%     workdir=pwd;
%     mkdir(workdir,OUTDIR);
%     workdir=strcat(workdir,outs);
% end
mkdir(mainworkdir,OUTDIR);
workdir = strcat(mainworkdir,'\',OUTDIR,'\')

%% create input file with parameters from Happel_GUI
fin =strcat(INPUTNAME,'.txt'); 
finput = strcat(workdir,fin);

%% get simplot & detplot value
simplot=get(handles.simplotCHECK,'value');
detplot=get(handles.detplotCHECK,'value');
%% run simulation
Hap_GUI_shell()
 set(handles.figure1, 'pointer', 'arrow')
 %% change buttom color while model is running 
set(gcbo,'Backgroundcolor','g');
%indicate completed sim GUI
done_msg1_HGUI()
w = waitforbuttonpress;
%write output path to command window

output = workdir
% enable buttons
set(handles.loadATT,'Enable','on');
set(handles.loadATT,'Backgroundcolor','g');
set(handles.runHAP,'Enable','on');
set(handles.runHAP,'Backgroundcolor','g')
%% enable simplotCHECK
set(handles.simplotCHECK,'Enable','on')
%% update eta values and RHAP
etatot =  eta2+eta4+eta5+eta6;
set(handles.RHAPtext,'String',num2str(RB))
set(handles.eta2text,'String',num2str(eta2))
set(handles.eta4text,'String',num2str(eta4))
set(handles.eta5text,'String',num2str(eta5))
set(handles.eta6text,'String',num2str(eta6))
set(handles.eta6text,'String',num2str(eta6))
set(handles.etatottext,'String',num2str(etatot))

 
function rmodeHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to rmodeHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rmodeHGUI as text
%        str2double(get(hObject,'String')) returns contents of rmodeHGUI as a double
rmodeHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',rmodeHGUI); 
set(handles.rmodeHGUI,'String',rmodeHGUI); 
% get vdwmode value
vdwmodeHGUI = str2double(get(handles.vdwmodeHGUI,'String')); 
if vdwmodeHGUI>1&&rmodeHGUI>0
    % warning message
    f = warndlg('Roughness not accounted for in layered van der Waals. Roughness is accounted for in the other interactions','Warning'); 
end
% enable asperity height and slip length values depending of roughness mode
if rmodeHGUI==0
    set(handles.aspHGUI,'Enable','off');
    set(handles.aspHGUI,'String',0);
    set(handles.bHGUI,'Enable','off');
    set(handles.bHGUI,'String',0);
else
    set(handles.aspHGUI,'Enable','on'); 
    set(handles.bHGUI,'Enable','on'); 
end

 

% --- Executes during object creation, after setting all properties.
function rmodeHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rmodeHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function aspHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to aspHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aspHGUI as text
%        str2double(get(hObject,'String')) returns contents of aspHGUI as a double
aspHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',aspHGUI); 
set(handles.aspHGUI,'String',aspHGUI); 

% --- Executes during object creation, after setting all properties.
function aspHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aspHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonDrawHetdom.
function buttonDrawHetdom_Callback(hObject, eventdata, handles)
% hObject    handle to buttonDrawHetdom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get parameters from fields
global AG AP ASP HETMODE RMODE HETMODEP RHET0 RHET1 RHET2 RHETP0 RHETP1 SCOV SCOVP
global ER IS ZI T BETA W132 KINT
global ZETAPST ZETACST ZETAHET ZETAHETP
AG= get(handles.agHGUI,'String'); AG=str2double(AG);
AP= get(handles.apHGUI,'String'); AP=str2double(AP);
ASP= get(handles.aspHGUI,'String'); ASP=str2double(ASP);
RMODE=get(handles.rmodeHGUI,'String');RMODE=str2double(RMODE);
HETMODE=get(handles.hetmodeHGUI,'String');HETMODE=str2double(HETMODE);
HETMODEP=get(handles.hetmodepHGUI,'String');HETMODEP=str2double(HETMODEP);
RHET0=get(handles.rhet0HGUI,'String');RHET0=str2double(RHET0);
RHET1=get(handles.rhet1HGUI,'String');RHET1=str2double(RHET1);
RHET2=get(handles.rhet2HGUI,'String');RHET2=str2double(RHET2);
RHETP0=get(handles.rhetp0HGUI,'String');RHETP0=str2double(RHETP0);
RHETP1=get(handles.rhetp1HGUI,'String');RHETP1=str2double(RHETP1);
ZETACST=get(handles.zetacstHGUI,'String');ZETACST=str2double(ZETACST);
ZETAPST=get(handles.zetapstHGUI,'String');ZETAPST=str2double(ZETAPST);
ZETAHET=get(handles.zetahetHGUI,'String');ZETAHET=str2double(ZETAHET);
ZETAHETP=get(handles.zetahetpHGUI,'String');ZETAHETP=str2double(ZETAHETP);
SCOV=get(handles.scovHGUI,'String');SCOV=str2double(SCOV);
SCOVP=get(handles.scovpHGUI,'String');SCOVP=str2double(SCOVP);
ER=get(handles.erHGUI,'String');ER=str2double(ER);
IS=get(handles.isHGUI,'String');IS=str2double(IS); 
ZI=get(handles.ziHGUI,'String');ZI=str2double(ZI); 
T=get(handles.tHGUI,'String');T=str2double(T); 
BETA=get(handles.betaHGUI,'String');BETA=str2double(BETA); 
W132=get(handles.w132HGUI,'String');W132=str2double(W132); 
KINT=get(handles.kintHGUI,'String');KINT=str2double(KINT);
%% calculate RZOI
%     CALCULATE KAPPA NOTE: IS FOR 1:1 ELECTROLYTE ONLY
PI=3.14159265359;         %PIE (CHERRY,STRAWBERRY RHUBARB, ETC.)
E0=8.85418781762E-12;     %VACUUM PERMITTIVITY (C^2/N M^2)
ECHG=1.602176621E-19;     %ELEMENTARY CHARGE (C)
KB=1.3806485E-23;         %BOLTZMANN CONSTANT (J/K)
ERE0 = ER*E0;            %ABSOLUTE PERMITTIVITY
NIO = IS*2*6.02214086E23;
KAPPA = ((ECHG^2.0)*NIO*(ZI^2.0)/(ERE0*KB*T))^0.5;
%   CALCULATE RZOIBULK: RADIUS OF ZONE OF INFLUENCE WITHOUT DEFORMATION
RZOIBULK = 2.0*((1/KAPPA)*AP)^0.5;
%% figure name detailed near surface figure
Dnearfig = 'Near_Surface_Geometry';
% set figure number
finitNear = 100;
figure(finitNear);
set(gcf,'name',Dnearfig,'NumberTitle','off'); 
%% define scaling of figure
% scale near surface plot based on colloid size
nang=500;% resolution angular grid points for collector sphere cap array
fsurf = 3; % factor of sphere cap (as amultiple of the arc of length AP)
% set factor to axis limits around center of plot (as a factor of AP)
axsc = 1.3*fsurf/2;
nsplotH = 2.0e-7; % default near surface visualization distance
if axsc*AP<2.0e-7
    nsplotH = axsc*AP;
end
% estimate sphere cap grid resolution
res = fsurf*AP*2/nang;
% set location vectors
Xvect = [0.0+1e-10, 0.0];
Yvect = [0.0+1e-10, AG+2*ASP+AP];
Zvect = [AG+2*ASP+AP, 0.0];
% set subplot titles
ltitle = {'Pole Normal','Equator Normal'};
rtitle = {'Pole Perspective','Equator Perspective'};
% set collector color based on charge sign
if ZETACST<0.0
    collecolor = 'r';
else
    collecolor = 'g';
end
% set colloid color based on charge sign
if ZETAPST<0.0
    colcolor = [0.9290 0.6940 0.1250];
else
    colcolor = 'b';
end



for i=1:2
    %% define colloid location and collector location for pole location
    % se collector center
    Xm0 = 0.0; Ym0=0.0; Zm0=0.0;
    % colloid center (at equator)
    X=Xvect(i); Y=Yvect(i); Z =Zvect(i);  
    % CALCULATE RADIAL DISTANCE
    R = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0)+(Z-Zm0)*(Z-Zm0))^0.5;
    H = R-AG-AP;
    %% plot geometry NEAR SURFACE      
    % draw roughness only if its scale exceeds a factor of res TBD
    [xcap,ycap,zcap,xs,ys,zs,thetap,phip,rxys,unitx,unity,unitz]=sphere_cap(X,Y,Z,AP,AG,fsurf,nang,res);
    % Generate dummy collector hetdomains center and radii for diagnostics
    %[xhetv,yhetv,zhetv,rhetv] = dummyhetcap(xcap,ycap,zcap,nhet0,nhet1,nhet2,rhet0,rhet1,rhet2);
    % Generate dummy colloid hetdomains center and radii for diagnostics
    %[xhetvcol,yhetvcol,zhetvcol,rhetvcol] = dummyhetsphere(X,Y,Z,AP,nhetp0,nhetp1,rhetp0,rhetp1);
    % calculate center of plot
    xpl = unitx*(AG+AP);
    ypl = unity*(AG+AP);
    zpl = unitz*(AG+AP);
    %% calculate POV angles (elevation and azimuth) for near surface plot
    % perspective POV
    azoff = -25;
    azpers = (phip/2/pi*360+90)+90+azoff;
    elpers = 10.0;
    %normal
    aznorm = phip/2/pi*360+90;
    if Z>0.0
        elnorm = (-thetap+pi/2)/2/pi*360;
    else
        elnorm = (-thetap+pi/2)/2/pi*360;
    end
    %   CALCULATE UNIT VECTORS
    ENX = (X-Xm0)/R;
    ENY = (Y-Ym0)/R;
    ENZ = (Z-Zm0)/R ;
    %   CALCULATE PROJECTION OF COLLOID CENTER ON HAPPEL SPHERE
    XG = Xm0+ENX*AG;
    YG = Ym0+ENY*AG;
    ZG = Zm0+ENZ*AG;
    %   CALCULATE COLLOID RADIAL POSITION - SPHERICAL COORDINATES AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
    RO = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0)+(Z-Zm0)*(Z-Zm0))^0.5;
    %   CALCULATE COLLOID THETA ANGLE - SPHERICAL COORDINATES AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
    THETA = acos((Z-Zm0)/RO);
            %   CALCULATE PROJECTION OF COLLOID POSITION ON XY PLANE
    ROXY = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0))^0.5;
    %   CALCULATE COLLOID PHI ANGLE - SPHERICAL COORDINATES AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
    if (ROXY==0.0)
        PHI = 0.0;
    else
        if ((Y-Ym0)>=0.0)
            PHI = acos((X-Xm0)/ROXY);
        else
            PHI = 2.0*pi-acos((X-Xm0)/ROXY);
        end
    end
    %% obtain hetdomain locations
    %   HETEROGENEITY ON COLLOID (HETP) SUBROUTINE TO DETERMINE HETERODOMAIN PROJECTIONS
    %   HETP PROJECTIONS WILL BE GENERATED ASSUMING THAT THE COLLOID CENTER COINCIDES WITH THE HAPPEL SPHERE CENTER
    %   MHETP CONTAINS HETP COORDINATES AND RADII(FORMAT: [XHETP YHETP ZHET RHETP])
    %   MPRO CONTAINS HETP PROJECTION COORDINATES AND RADII(FORMAT: [XPRO YPRO ZPRO RPRO])
    [MHETP, MPRO]=HAPHETTRACKP(Xm0,Ym0,Zm0,H,RZOIBULK,AP,HETMODEP,SCOVP,RHETP0,RHETP1);
    %   HETP WILL BE TRANSLATED TO THE COLLECTOR FRAME OF REFERENCE AND
    %   ROTATED BASED ON COLLOID SPHERICAL COORDINATES, FOR FRONT-END PLOTTING
    %   HETP PROJECTIONS WILL BE TRANSLATED AND ROTATED TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING 
    %   THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER, TO CALCULATE AFRACT  
    [MHETP_PLOT,MPRO_AF] = HETP_TRANSFORM(X,Y,Z,XG,YG,ZG,THETA,PHI,MHETP,MPRO);

    %% plot
    % plot geometry
    figure(finitNear)
    subplot(2,2,1+(i-1)*2)
    plot3(xpl,ypl,zpl,'ob')
    title(cell2mat(ltitle(i)))
    axis([-axsc*AP+xpl axsc*AP+xpl -axsc*AP+ypl axsc*AP+ypl -axsc*AP+zpl axsc*AP+zpl])
    axis square
    view(aznorm,elnorm)
    hold on
    xlabel('X'); ylabel('Y'); zlabel('Z');
    % plot sphere cap surface on collector
    surf(xcap,ycap,zcap,'FaceColor',collecolor,'EdgeColor','none')
    subp=[2,2,1+(i-1)*2];
    [XHET,YHET,ZHET,RHET]=HAPHETTRACK(X,Y,Z,Xm0,Ym0,Zm0,AG,HETMODE,SCOV,RHET0,RHET1,RHET2,1);
    % paint hetdomains on collector cap
    if SCOV>0
        hetpaint(finitNear,subp,xcap,ycap,zcap,XHET,YHET,ZHET,RHET)
    end
    % draw hetdomains on colloid surface
    if SCOVP>0
        colloidHetPaint(finitNear,subp,MHETP_PLOT(:,1),MHETP_PLOT(:,2),MHETP_PLOT(:,3),MHETP_PLOT(:,4),X,Y,Z,AP)
    end
    %% generate colloid ring and zoi to visualizae colloid border and zoi
    [xcirc,ycirc,zcirc,xzoi,yzoi,zzoi]=colloid_circle(X,Y,Z,AP,AG,RZOIBULK);
    figure(finitNear)
    subplot(2,2,1+(i-1)*2)
    plot3(xcirc,ycirc,zcirc,'.','MarkerEdgeColor','k')
    plot3(xzoi,yzoi,zzoi,'.','MarkerEdgeColor',colcolor)
    %%
    figure(finitNear)
    subplot(2,2,2+(i-1)*2)
    plot3(xpl,ypl,zpl,'ob')
    title(cell2mat(rtitle(i)))
    axis([-axsc*AP+xpl axsc*AP+xpl -axsc*AP+ypl axsc*AP+ypl -axsc*AP+zpl axsc*AP+zpl])
    axis square
    view(azpers,elpers)
    hold on
    xlabel('X'); ylabel('Y'); zlabel('Z');
    % plot sphere cap surface on collector
    surf(xcap,ycap,zcap,'FaceColor',collecolor,'EdgeColor','none')
    subp=[2,2,2+(i-1)*2];
    % paint hetdomains on collector cap
    if SCOV>0
        hetpaint(finitNear,subp,xcap,ycap,zcap,XHET,YHET,ZHET,RHET)
    end
    % draw hetdomains on colloid surface
    if SCOVP>0
        colloidHetPaint(finitNear,subp,MHETP_PLOT(:,1),MHETP_PLOT(:,2),MHETP_PLOT(:,3),MHETP_PLOT(:,4),X,Y,Z,AP)
    end
    %% generate colloid ring and zoi to visualizae colloid border and zoi
    figure(finitNear)
    subplot(2,2,2+(i-1)*2)
    plot3(xcirc,ycirc,zcirc,'.','MarkerEdgeColor','k')
    plot3(xzoi,yzoi,zzoi,'.','MarkerEdgeColor',colcolor)
    %%
    % plot center of cap from angles
    z1=cos(thetap)*AG;
    x1=cos(phip)*rxys;
    y1=sin(phip)*rxys;
    % hold off figure
    figure(finitNear)
    subplot(2,2,1+(i-1)*2)
    hold off
    figure(finitNear)
    subplot(2,2,2+(i-1)*2)
    hold off

end
%% contact figure geometry
% set figure number
Dcontactfig =  strcat('Contact_Geometry');
fDcontact=200;
figure(fDcontact)
set(gcf,'name',Dcontactfig,'NumberTitle','off'); 
% set location vectors
Xvect = [0.0+1e-10; 0.0];
Yvect = [0.0+1e-10, AG+2*ASP+AP];
Zvect = [AG+2*ASP+AP, 0.0];
% set subplot titles
% ltitle = {'Pole Normal','Equator Normal'};
% rtitle = {'Pole Perspective','Equator Perspective'};
for i=1:2  
    %% define colloid location and collector location for pole location
    % se collector center
    Xm0 = 0.0; Ym0=0.0; Zm0=0.0;
    % colloid center (at equator)
    X=Xvect(i); Y=Yvect(i); Z =Zvect(i);  
    % CALCULATE RADIAL DISTANCE
    R = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0)+(Z-Zm0)*(Z-Zm0))^0.5;    
    H = R-AG-AP;
    % adjust resolution based on smallest roughness respresented
    minasp = 3.3333e-09/2; %minimum asperity size represented in visualization
    if ASP <  minasp
        res = 2*minasp;
    else
        res = 2*ASP;
    end
    % compare ACONTMAX vs. RLEV to determine the largest area to render
    % surfaces in the zoom-in visualization.
    % calculate the number of asperities that match area to render
    %         if ACONTMAX>=RLEV
    %             if 40*res>=ACONTMAX
    %                 numasp=40;
    %             elseif ceil(ACONTMAX/res)>80
    %                 numasp=80;
    %             else
    %                 numasp=ceil(ACONTMAX/res);
    %             end
    %         else
    %             if 5*res>=RLEV
    %                 numasp=5;
    %             elseif ceil(RLEV/res)>10
    %                 numasp=10;
    %             else
    %                 numasp=ceil(RLEV/res);
    %             end
    %         end
    % set sphere cap number of nodes as a factor of asperity height
    % (3.3333e-09 m, minimum ASP)
    % set surface domain size as a fractio of AP
    fsurf = 0.35;
    % calculate number of asperities in surface domain
    numasp = ceil(fsurf*AP/res);
    if numasp<10
        numasp=10;
        fsurf = numasp*res/(AP);
        if fsurf>=1
            fsurf = 0.9;
            numasp = ceil(fsurf*AP/res);
        end
    end
    % assing surface element resolution depending on RMODE
    if RMODE==0  % RMODE = 0: Smooth collector and colloid
        numaspAP = 100;
        numaspAG = 100;
    end
    if RMODE==1  % RMODE = 1: Smooth collector rough colloid
        numaspAP = numasp;
        numaspAG = 100;
    end
    if RMODE==2  % RMODE = 2: Smooth colloid rough collector
        numaspAP = 100;
        numaspAG = numasp;
    end
    if RMODE==3  % RMODE = 3: Rough collector and colloid
        numaspAP = numasp;
        numaspAG = numasp;
    end
    %% plot geometry
    % draw wire sphere for colloid as reference
    [xw,yw,zw]=sphere(200);
    xw=xw*AP+X; yw=yw*AP+Y; zw=zw*AP+Z;
    % draw roughness only if its scale exceeds a factor of res TBD
    [xcap,ycap,zcap,xs,ys,zs,thetap,phip,rxys,unitx,unity,unitz]=sphere_cap(X,Y,Z,AP,AG,fsurf,numaspAG,res);
    %  Generate dummy collector hetdomains center and radii for diagnostics
    %[xhetv,yhetv,zhetv,rhetv] = dummyhetcap(xcap,ycap,zcap,nhet0,nhet1,nhet2,rhet0,rhet1,rhet2);
    % create colloid and collector
    [xc,yc,zc]= sphere;
    % scale spheres and translate
    xc=AG*xc; yc=AG*yc; zc=AG*zc;
    % calculate center of plot
    xpl = unitx*(AG+H/2);
    ypl = unity*(AG+H/2);
    zpl = unitz*(AG+H/2);
    % set factor to axis limits around center of plot (as a factor of AP)
    axsc = fsurf/3;
    % zoom in figure
    azoff = -5;
    az1 = (phip/2/pi*360+90)+90+azoff;
    el1 = 0.0;
    %% generate roughness on the colloid
    % use same sphere cap function to generate cap on colloid surface.
    % note that AP and AG order are swap to accomplish this objective
    [xcapcol,ycapcol,zcapcol,xscol,yscol,zscol,thetapcol,phipcol,rxyscol,unitxcol,unitycol,unitzcol]=sphere_cap(-X,-Y,-Z,AG,AP,fsurf,numaspAP,res);
    % translate cap relative to colloid center.
    xcapcol=xcapcol+X;
    ycapcol=ycapcol+Y;
    zcapcol=zcapcol+Z;
    %% generate hetdomains on colloid
    % Generate dummy colloid hetdomains center and radii for diagnostics
    %[xhetvcol,yhetvcol,zhetvcol,rhetvcol] = dummyhetcap(xcapcol,ycapcol,zcapcol,nhet0,nhet1,0.0,rhet0,rhet1,rhet2);
    %% plot
    % plot geometry
    figure(fDcontact)
    subplot(2,2,1+(i-1)*2)
    plot3(xpl,ypl,zpl,'ob')
    title ('Rendering contact figure...')
    drawnow
    axis([-axsc*AP+xpl axsc*AP+xpl -axsc*AP+ypl axsc*AP+ypl -axsc*AP+zpl axsc*AP+zpl])
    axis square
    view(az1,el1)
    hold on
    if RMODE==1||RMODE==3
        % draw wired sphere to represent smooth colloid surface if 
        % roughness is present on colloid
        surf(xw,yw,zw,'FaceColor','none','EdgeColor',colcolor) 
    end
    xlabel('X'); ylabel('Y'); zlabel('Z');
    subp=[2,2,1+(i-1)*2];
    % generate heterogeneity in the colloid the attachment region
    if SCOVP>0.0
        %   HETEROGENEITY ON COLLOID (HETP) SUBROUTINE TO DETERMINE HETERODOMAIN PROJECTIONS
        %   HETP PROJECTIONS WILL BE GENERATED ASSUMING THAT THE COLLOID CENTER COINCIDES WITH THE HAPPEL SPHERE CENTER
        %   MHETP CONTAINS HETP COORDINATES AND RADII(FORMAT: [XHETP YHETP ZHET RHETP])
        %   MPRO CONTAINS HETP PROJECTION COORDINATES AND RADII(FORMAT: [XPRO YPRO ZPRO RPRO])
        [MHETP, MPRO]=HAPHETTRACKP(Xm0,Ym0,Zm0,H,RZOIBULK,AP,HETMODEP,SCOVP,RHETP0,RHETP1);
        %   HETP WILL BE TRANSLATED TO THE COLLECTOR FRAME OF REFERENCE AND
        %   ROTATED BASED ON COLLOID SPHERICAL COORDINATES, FOR FRONT-END PLOTTING
        %   HETP PROJECTIONS WILL BE TRANSLATED AND ROTATED TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING
        %   THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER, TO CALCULATE AFRACT
        [MHETP_PLOT,MPRO_AF] = HETP_TRANSFORM(X,Y,Z,XG,YG,ZG,THETA,PHI,MHETP,MPRO);
    else
        MHETP_PLOT(:,1) = 0.0;
        MHETP_PLOT(:,2) = 0.0;
        MHETP_PLOT(:,3) = 0.0;
        MHETP_PLOT(:,4) = 0.0;
    end
    % paint hetdomains on collextor
    %% drawn roughness hemispheres on collector (colflag=1)
    colflag = 1;
    % if no heterogeneity present in the collector
    if SCOV==0
        XHET = 0.0; YHET = 0.0; ZHET = 0.0; RHET = 0.0;
    else
       [XHET,YHET,ZHET,RHET]=HAPHETTRACK(X,Y,Z,Xm0,Ym0,Zm0,AG,HETMODE,SCOV,RHET0,RHET1,RHET2,1);

    end
    roughspheresHet(@hetpaint,@colloidHetPaint,fDcontact,subp,xcap,ycap,zcap,XHET,YHET,ZHET,RHET,xs,ys,zs,X,Y,Z,AG,AP,res,numaspAG,colflag,RMODE)
    %roughspheresHet(fD,subp,xcap,ycap,zcap,XHET,YHET,ZHET,RHET,xs,ys,zs,X,Y,Z,AG,AP,res,numasp,colflag,RMODE)
    %% drawn roughness hemispheres on colloid (colflag=2)
    colflag = 2;
    roughspheresHet(@hetpaint,@colloidHetPaint,fDcontact,subp,xcapcol,ycapcol,zcapcol,MHETP_PLOT(:,1),MHETP_PLOT(:,2),MHETP_PLOT(:,3),MHETP_PLOT(:,4),xscol,yscol,abs(zscol),X,Y,Z,AG,AP,res,numaspAP,colflag,RMODE)
    %           roughspheresHet(fD,subp,xcapcol,ycapcol,zcapcol,XHETP,YHETP,ZHETP,RHETP,xs,ys,zs,X,Y,Z,AG,AP,res,numasp,colflag,RMODE)
    %%
    % plot center of cap from angles
    z1=cos(thetap)*AG;
    x1=cos(phip)*rxys;
    y1=sin(phip)*rxys;
    %%
    subplot(2,2,2+(i-1)*2) 
    surf(xc,yc,zc,'FaceColor','none')
    drawnow
    hold on
    plot3(X,Y,Z,'ok','MarkerFaceColor',colcolor,'MarkerSize',10)
    axis ([-1.5*AG 1.5*AG -1.5*AG 1.5*AG -1.5*AG 1.5*AG])
    axis square
    %% generate colloid ring and zoi to visualizae colloid border and zoi
    [xcirc,ycirc,zcirc,xzoi,yzoi,zzoi]=colloid_circle(X,Y,Z,AP,AG,RZOIBULK);
    figure(fDcontact)
    subplot(2,2,1+(i-1)*2)
    %         plot3(xcirc,ycirc,zcirc,'.','MarkerEdgeColor',colcolor)
    plot3(xzoi,yzoi,zzoi,'.','MarkerEdgeColor',colcolor,'MarkerSize',10)
    %% hold off plots
    figure(fDcontact)
    title (' ')
    drawnow
    subplot(2,2,1+(i-1)*2)
    hold off
    subplot(2,2,2+(i-1)*2)
    hold off
    %%
end



%% message
%hetdraw_msg1_HGUI


% --- Executes on button press in loadATT.
function loadATT_Callback(hObject, eventdata, handles)
% hObject    handle to loadATT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set globals for header
global NPART ATTMODE CLUSTER VSUP RLIM POROSITY AG  TTIME...
AP RHOP RHOW VISC ER T IS ZI ZETAPST ZETACST ZETAHET HETMODE RHET0...
RHET1 SCOV A132 LAMBDAVDW VDWMODE A11 AC1C1 A22 AC2C2 A33...
T1 T2 GAMMA0AB LAMBDAAB GAMMA0STE LAMBDASTE B RMODE ASP...
KINT W132 BETA DIFFSCALE GRAVFACT MULTB MULTNS MULTC DFACTNS DFACTC...
VJET
% set globals for data

% to chek if loading twice instead of remaining flux file
global ATTfluxinput 

% load non header globlas
global NOUT PRINTMAX oldATTMODE
oldATTMODE=get(handles.attmodeHGUI,'String');oldATTMODE=str2double(oldATTMODE);
NOUT=get(handles.noutHGUI,'String');NOUT=str2double(NOUT);
PRINTMAX=get(handles.printmaxHGUI,'String');PRINTMAX=str2double(PRINTMAX);
%% set working directory        
if ~isdeployed
    % MATLAB environment
    inputdir = strrep(mfilename('fullpath'),'\Happel_GUI','\');
else
    %deployed application
    inputdir=strcat(pwd,'\');   
end
test = strcat(inputdir,'*.OUT');
%  test = inputdir;
%% get upflux filename and path
[filename,filepath] = uigetfile(test,'Select the ATTACHMENT Flux Data file');
if isequal(filename,0)
   disp('User selected Cancel');
else
    % set full namewhit
    
    ATTfluxinput=strcat(filepath,filename);
    %% read file info
    %read headers
    HFUNCread_flux_header(ATTfluxinput)
    %% change font color of all edit fields to indicate values loaded
    hEditBoxes = findobj('Type','uicontrol','Style','edit');
    set(hEditBoxes,'Foregroundcolor',[0 0.5 0]);
    % keep color of non pertinent edit fields
    hlist = [handles.outdirHGUI handles.outdirPERT handles.noutHGUI handles.printmaxHGUI];
    set(hlist,'Foregroundcolor','k');
    %% enable remaining flux load button
    set(handles.loadREM,'Enable','on');
    set(handles.loadREM,'Backgroundcolor','g');
    %% update edit boxes with header parameters
    %sim parameters
    set(handles.npartHGUI,'String',num2str(NPART,'%d'));
    ATTMODE = -1; % pertubation mode set this automatically
    set(handles.attmodeHGUI,'Enable','off');
    %disable edit field
    set(handles.attmodeHGUI,'String',num2str(ATTMODE,'%d'));
    set(handles.clusterHGUI,'String',num2str(CLUSTER,'%d'));
    %flow and geometry
    VJET=VSUP; % compatibility with traj_happel function
    set(handles.vjetHGUI,'String',num2str(VJET,'%5.3e'));
    set(handles.rlimHGUI,'String',num2str(RLIM,'%5.3e'));
    set(handles.porosityHGUI,'String',num2str(POROSITY,'%5.3e'));
    set(handles.agHGUI,'String',num2str(AG,'%5.3e'));
    set(handles.ttimeHGUI,'String',num2str(TTIME,'%5.3e'));
    %colloid and fluid prop
    set(handles.apHGUI,'String',num2str(AP,'%5.3e'));
    set(handles.rhopHGUI,'String',num2str(RHOP,'%5.3e'));
    set(handles.rhowHGUI,'String',num2str(RHOW,'%5.3e'));
    set(handles.viscHGUI,'String',num2str(VISC,'%5.3e'));
    set(handles.erHGUI,'String',num2str(ER,'%5.3e'));
    set(handles.tHGUI,'String',num2str(T,'%5.3e'));
    %water chem and surf charge
    set(handles.isHGUI,'String',num2str(IS,'%5.3e'));
    set(handles.ziHGUI,'String',num2str(ZI,'%5.3e'));
    set(handles.zetapstHGUI,'String',num2str(ZETAPST,'%5.3e'));
    set(handles.zetacstHGUI,'String',num2str(ZETACST,'%5.3e'));
    % heterogeneity param
    set(handles.zetahetHGUI,'String',num2str(ZETAHET,'%5.3e'));
    set(handles.hetmodeHGUI,'String',num2str(HETMODE,'%d'));
    set(handles.rhet0HGUI,'String',num2str(RHET0,'%5.3e'));
    set(handles.rhet1HGUI,'String',num2str(RHET1,'%5.3e'));
    set(handles.scovHGUI,'String',num2str(SCOV,'%5.3e'));
    % van der Waals param
    set(handles.a132HGUI,'String',num2str(A132,'%5.3e'));
    set(handles.lambdavdwHGUI,'String',num2str(LAMBDAVDW,'%5.3e'));
    set(handles.vdwmodeHGUI,'String',num2str(VDWMODE,'%d'));
    % roughness param
    set(handles.bHGUI,'String',num2str(B,'%5.3e'));
    set(handles.rmodeHGUI,'String',num2str(RMODE,'%d'));
    set(handles.aspHGUI,'String',num2str(ASP,'%5.3e'));
    %van der Waals coated systems param
    set(handles.a11HGUI,'String',num2str(A11,'%5.3e'));
    set(handles.ac1c1HGUI,'String',num2str(AC1C1,'%5.3e'));
    set(handles.a22HGUI,'String',num2str(A22,'%5.3e'));
    set(handles.ac2c2HGUI,'String',num2str(AC2C2,'%5.3e'));
    set(handles.a33HGUI,'String',num2str(A33,'%5.3e'));
    set(handles.t1HGUI,'String',num2str(T1,'%5.3e'));
    set(handles.t2HGUI,'String',num2str(T2,'%5.3e'));
    %Lewis acid-base and steric hydration force parameters
    set(handles.gamma0abHGUI,'String',num2str(GAMMA0AB,'%5.3e'));
    set(handles.lambdaabHGUI,'String',num2str(LAMBDAAB,'%5.3e'));
    set(handles.gamma0steHGUI,'String',num2str(GAMMA0STE,'%5.3e'));
    set(handles.lambdasteHGUI,'String',num2str(LAMBDASTE,'%5.3e'));
    %Deformation parameters
    set(handles.kintHGUI,'String',num2str(KINT,'%5.3e'));
    set(handles.w132HGUI,'String',num2str(W132,'%5.3e'));
    set(handles.betaHGUI,'String',num2str(BETA,'%5.3e'));
    %Diffusion and Gravity factors
    set(handles.diffscaleHGUI,'String',num2str(DIFFSCALE,'%5.3e'));
    set(handles.gravfactHGUI,'String',num2str(GRAVFACT,'%5.3e'));
    %Simulation time step and Slow motion parameters
    set(handles.multbHGUI,'String',num2str(MULTB,'%5.3e'));
    set(handles.multnsHGUI,'String',num2str(MULTNS,'%5.3e'));
    set(handles.multcHGUI,'String',num2str(MULTC,'%5.3e'));
    set(handles.dfactnsHGUI,'String',num2str(DFACTNS,'%5.3e'));
    set(handles.dfactcHGUI,'String',num2str(DFACTC,'%5.3e'));
    %% change contatc radius factor to 1
    set(handles.betaHGUI,'String','1')    
    %% change button color 
    set(handles.loadATT,'Backgroundcolor','g');
end





% --- Executes on button press in loadREM.
function loadREM_Callback(hObject, eventdata, handles)
% hObject    handle to loadREM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ATTfluxinput
% set globals to feed simulation
global NPARTPERT NPARTatt NPARTrem ATTACHKP XOUTP YOUTP ZOUTP ROUTP HOUTP
%% set working directory        
if ~isdeployed
    % MATLAB environment
    inputdir = strrep(mfilename('fullpath'),'\Happel_GUI','\');
else
    %deployed application
    inputdir=strcat(pwd,'\');   
end
test = strcat(inputdir,'*.OUT');
%  test = inputdir;
%% get upflux filename and path
[filename,filepath] = uigetfile(test,'Select the REMAINING Flux Data file');
% set full name
REMfluxinput=strcat(filepath,filename);
%warn user if reloading attachment flux file
if length(ATTfluxinput)==length(REMfluxinput)
    if ATTfluxinput==REMfluxinput
        m=warndlg('Loading same flux file for ATTACHMENT and REMAINING','Warning');
        waitfor(m);
    end
end
%% read flux data and prepare arrays for trajectory function
HFUNCread_flux_data(ATTfluxinput,REMfluxinput)

%% change button color 
set(handles.loadREM,'Backgroundcolor','g');
%% enable simulation button only if NPARTPERT >0
if NPARTPERT>0
    % enable set output directory pb
    set(handles.pb_setdirPERT,'Enable','on')
%     set(handles.npartHGUI,'String'); NPARTPERT=str2double(NPARTPERT);
else
    disp('*************************************************');
    disp('Warning: no ATTACHK=2 colloids in load flux files');
    disp('*************************************************');
end



% --- Executes on button press in runPERT.
function runPERT_Callback(hObject, eventdata, handles)
% hObject    handle to runHAP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% % witing message
% wait_msg1_HGUI
% w = waitforbuttonpress;
%% disable simplotCHECK
set(handles.simplotCHECK,'Enable','off')
%% reset interface aspect
% disable buttons
set(handles.loadATT,'Enable','off');
set(handles.loadATT,'Backgroundcolor',[0.8 0.8 0.8]);
set(handles.loadREM,'Enable','off');
set(handles.loadREM,'Backgroundcolor',[0.8 0.8 0.8]);
set(handles.runHAP,'Enable','off');
set(handles.runHAP,'Backgroundcolor',[0.8 0.8 0.8])
%% change buttom color while model is running 
set(gcbo,'Backgroundcolor','y');
%% declare global variables from fields
 global NPART ATTMODE CLUSTER 
 NPART= get(handles.npartHGUI,'String'); NPART=str2double(NPART);
 ATTMODE= get(handles.attmodeHGUI,'String'); ATTMODE=str2double(ATTMODE);
 CLUSTER= get(handles.clusterHGUI,'String'); CLUSTER=str2double(CLUSTER);
 global VJET RLIM POROSITY AG  TTIME %REXIT
 VJET= get(handles.vjetHGUI,'String'); VJET=str2double(VJET);
 RLIM= get(handles.rlimHGUI,'String'); RLIM=str2double(RLIM);
 POROSITY= get(handles.porosityHGUI,'String'); POROSITY=str2double(POROSITY);
 AG= get(handles.agHGUI,'String'); AG=str2double(AG);
%  REXIT= get(handles.rexitHGUI,'String'); REXIT=str2double(REXIT);
 TTIME= get(handles.ttimeHGUI,'String'); TTIME=str2double(TTIME);
 global AP RHOP RHOW VISC ER T
 AP= get(handles.apHGUI,'String'); AP=str2double(AP);
 RHOP= get(handles.rhopHGUI,'String'); RHOP=str2double(RHOP);
 RHOW= get(handles.rhowHGUI,'String'); RHOW=str2double(RHOW);
 VISC= get(handles.viscHGUI,'String'); VISC=str2double(VISC);
 ER= get(handles.erHGUI,'String'); ER=str2double(ER);
 T=get(handles.tHGUI,'String');T=str2double(T);
 global IS ZI ZETAPST ZETACST
 IS=get(handles.isHGUI,'String');IS=str2double(IS);
 ZI=get(handles.ziHGUI,'String');ZI=str2double(ZI);
 ZETAPST=get(handles.zetapstHGUI,'String');ZETAPST=str2double(ZETAPST);
 ZETACST=get(handles.zetacstHGUI,'String');ZETACST=str2double(ZETACST);
 global ZETAHET HETMODE RHET0 RHET1 SCOV
 ZETAHET=get(handles.zetahetHGUI,'String');ZETAHET=str2double(ZETAHET);
 HETMODE=get(handles.hetmodeHGUI,'String');HETMODE=str2double(HETMODE);
 RHET0=get(handles.rhet0HGUI,'String');RHET0=str2double(RHET0);
 RHET1=get(handles.rhet1HGUI,'String');RHET1=str2double(RHET1);
 SCOV=get(handles.scovHGUI,'String');SCOV=str2double(SCOV);
 global A132 LAMBDAVDW VDWMODE
 A132=get(handles.a132HGUI,'String');A132=str2double(A132);
 LAMBDAVDW=get(handles.lambdavdwHGUI,'String');LAMBDAVDW=str2double(LAMBDAVDW);
 VDWMODE=get(handles.vdwmodeHGUI,'String');VDWMODE=str2double(VDWMODE);
 global A11 AC1C1 A22 AC2C2 A33 T1 T2
 A11=get(handles.a11HGUI,'String');A11=str2double(A11);
 AC1C1=get(handles.ac1c1HGUI,'String');AC1C1=str2double(AC1C1);
 A22=get(handles.a22HGUI,'String');A22=str2double(A22);
 AC2C2=get(handles.ac2c2HGUI,'String');AC2C2=str2double(AC2C2);
 A33=get(handles.a33HGUI,'String');A33=str2double(A33);
 T1=get(handles.t1HGUI,'String');T1=str2double(T1);
 T2=get(handles.t2HGUI,'String');T2=str2double(T2);
 global GAMMA0AB LAMBDAAB GAMMA0STE LAMBDASTE B RMODE ASP
 GAMMA0AB=get(handles.gamma0abHGUI,'String');GAMMA0AB=str2double(GAMMA0AB);
 LAMBDAAB=get(handles.lambdaabHGUI,'String');LAMBDAAB=str2double(LAMBDAAB);
 GAMMA0STE=get(handles.gamma0steHGUI,'String');GAMMA0STE=str2double(GAMMA0STE);
 LAMBDASTE=get(handles.lambdasteHGUI,'String');LAMBDASTE=str2double(LAMBDASTE);
 B=get(handles.bHGUI,'String');B=str2double(B);
 RMODE=get(handles.rmodeHGUI,'String');RMODE=str2double(RMODE);
 ASP=get(handles.aspHGUI,'String');ASP=str2double(ASP);
 global KINT W132 BETA DIFFSCALE GRAVFACT
 KINT=get(handles.kintHGUI,'String');KINT=str2double(KINT);
 W132=get(handles.w132HGUI,'String');W132=str2double(W132); 
 BETA=get(handles.betaHGUI,'String');BETA=str2double(BETA);
 DIFFSCALE=get(handles.diffscaleHGUI,'String');DIFFSCALE=str2double(DIFFSCALE);
 GRAVFACT=get(handles.gravfactHGUI,'String');GRAVFACT=str2double(GRAVFACT);
 global MULTB MULTNS MULTC DFACTNS DFACTC
 MULTB=get(handles.multbHGUI,'String');MULTB=str2double(MULTB);
 MULTNS=get(handles.multnsHGUI,'String');MULTNS=str2double(MULTNS);
 MULTC=get(handles.multcHGUI,'String');MULTC=str2double(MULTC);
 DFACTNS=get(handles.dfactnsHGUI,'String');DFACTNS=str2double(DFACTNS); 
 DFACTC=get(handles.dfactcHGUI,'String');DFACTC=str2double(DFACTC);
 global NOUT PRINTMAX
 NOUT=get(handles.noutHGUI,'String');NOUT=str2double(NOUT);
 PRINTMAX=get(handles.printmaxHGUI,'String');PRINTMAX=str2double(PRINTMAX);
 global INPUTNAME OUTDIR 
 OUTDIR=get(handles.outdirPERT,'String');
 INPUTNAME= strcat('.input.',OUTDIR);
 global mainworkdir workdir finput simplot detplot saveSIMPLOT
 %indicate busy GUI
 set(handles.figure1, 'pointer', 'watch') 
drawnow;
% 
%% create directory to locate  input and output files
%  create string from output directory  
% outs = strcat('\',OUTDIR,'\');
% set working directory        
% if ~isdeployed
%     % MATLAB environment
%     workdir = strrep(mfilename('fullpath'),'\Happel_GUI','\');
%     mkdir(workdir,OUTDIR);
%     workdir = strrep(mfilename('fullpath'),'\Happel_GUI',outs)
% else
%     %deployed application
%     workdir=pwd;
%     mkdir(workdir,OUTDIR);
%     workdir=strcat(workdir,outs)
% end
mkdir(mainworkdir,OUTDIR);
workdir = strcat(mainworkdir,'\',OUTDIR,'\')
%% create input file with parameters from Happel_GUI
fin =strcat(INPUTNAME,'.txt'); 
finput = strcat(workdir,fin);
% set globals from perturbation flux file data
global NPARTPERT NPARTatt NPARTrem ATTACHKP XOUTP YOUTP ZOUTP ROUTP HOUTP
%% get simplot & detplot value
simplot=get(handles.simplotCHECK,'value');
detplot=get(handles.detplotCHECK,'value');
% get savesimplot value
saveSIMPLOT=get(handles.saveSIMPLOT,'Value');
%% run simulation
Hap_GUI_shell()
 set(handles.figure1, 'pointer', 'arrow')
 %% change buttom color while model is running 
set(gcbo,'Backgroundcolor','g');
  %indicate completed sim GUI
 done_msg1_HGUI()
 w = waitforbuttonpress;
 % indicate output path
 output = workdir
 % enable buttons
set(handles.loadATT,'Enable','on');
set(handles.loadATT,'Backgroundcolor','g');
set(handles.runHAP,'Enable','on');
set(handles.runHAP,'Backgroundcolor','g')
%% enable simplotCHECK
set(handles.simplotCHECK,'Enable','on')


function outdirPERT_Callback(hObject, eventdata, handles)
% hObject    handle to outdirPERT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outdirPERT as text
%        str2double(get(hObject,'String')) returns contents of outdirPERT as a double


% --- Executes during object creation, after setting all properties.
function outdirPERT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outdirPERT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in loadParam.
function loadParam_Callback(hObject, eventdata, handles)
% hObject    handle to loadParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set globals for header
global NPART ATTMODE CLUSTER VSUP RLIM POROSITY AG  TTIME...
AP RHOP RHOW VISC ER T IS ZI ZETAPST ZETACST ZETAHET HETMODE RHET0...
RHET1 RHET2 SCOV ZETAHETP HETMODEP RHETP0 RHETP1 SCOVP ...
A132 LAMBDAVDW VDWMODE A11 AC1C1 A22 AC2C2 A33...
T1 T2 GAMMA0AB LAMBDAAB GAMMA0STE LAMBDASTE B RMODE ASP...
KINT W132 BETA DIFFSCALE GRAVFACT MULTB MULTNS MULTC DFACTNS DFACTC...
VJET cbPZ cbMZ cbPX cbMX simplotCHECK detplotCHECK
% set globals for data

% load non header globlas
global NOUT PRINTMAX oldATTMODE
oldATTMODE=get(handles.attmodeHGUI,'String');oldATTMODE=str2double(oldATTMODE);
NOUT=get(handles.noutHGUI,'String');NOUT=str2double(NOUT);
PRINTMAX=get(handles.printmaxHGUI,'String');PRINTMAX=str2double(PRINTMAX);
%% set working directory        
if ~isdeployed
    % MATLAB environment
    inputdir = strrep(mfilename('fullpath'),'\Happel_GUI','\');
else
    %deployed application
    inputdir=strcat(pwd,'\');   
end
test = strcat(inputdir,'*.OUT');
%  test = inputdir;
%% get upflux filename and path
[filename,filepath] = uigetfile(test,'Select the ATTACHMENT Flux Data file');
if isequal(filename,0)
   disp('User selected Cancel');
else
    % set full name
    paramfluxinput=strcat(filepath,filename);
    %% read file info
    %read headers
    HFUNCread_flux_header(paramfluxinput)
    %% change font color of all edit fields to indicate values loaded
    hEditBoxes = findobj('Type','uicontrol','Style','edit');
    set(hEditBoxes,'Foregroundcolor',[0.0 0.45 0.74]);
    % keep color of non pertinent edit fields
    hlist = [handles.outdirHGUI handles.outdirPERT handles.noutHGUI handles.printmaxHGUI];
    set(hlist,'Foregroundcolor','k');
    %% update edit boxes with header parameters
    %sim parameters
    set(handles.npartHGUI,'String',num2str(NPART,'%d'));
    % check if valid attmode
    if ATTMODE==-1
    % attmo
    w1=warndlg('Attachment mode loaded for perturbation (-1), value set to contact by default (1)','ATTMODE Warning') ;  
    waitfor(w1);
    %set to contact mode for loading sim
    ATTMODE =1;
    end
    set(handles.attmodeHGUI,'String',num2str(ATTMODE,'%d'));
    set(handles.clusterHGUI,'String',num2str(CLUSTER,'%d'));
    %flow and geometry
    VJET=VSUP; % compatibility with traj_happel function
    set(handles.vjetHGUI,'String',num2str(VJET,'%5.3e'));
    %check if rlim is valid for loading sim
    % check values and warn user RLIM ATTMODE
    if RLIM<=0.0
     w2=warndlg('Not valid RLIM, use positive non-zero values, set to 1 µm by default','RLIM Warning');
     waitfor(w2);
     RLIM = 1e-6;
    end
    set(handles.rlimHGUI,'String',num2str(RLIM,'%5.3e'));
    set(handles.porosityHGUI,'String',num2str(POROSITY,'%5.3e'));
    set(handles.agHGUI,'String',num2str(AG,'%5.3e'));
    set(handles.ttimeHGUI,'String',num2str(TTIME,'%5.3e'));
    %colloid and fluid prop
    set(handles.apHGUI,'String',num2str(AP,'%5.3e'));
    apHGUI = str2double(get(handles.apHGUI,'String'));
    % set output interval factor on colloid size
        % set output interval factor value (noutHGUI) depending on colloid radius
        %using a continuos function log(factor) = -log(ap)-3.301\
        % e.g.
        % 2 um radius colloid 250
        % 200 nm radius colloid 2500
        % 20 nm radius colloid 25000
        noutHGUI = ceil(10^(-log10(apHGUI)-3.301));
        % populate field
        set(handles.noutHGUI,'String',num2str(noutHGUI))
    %
    set(handles.rhopHGUI,'String',num2str(RHOP,'%5.3e'));
    set(handles.rhowHGUI,'String',num2str(RHOW,'%5.3e'));
    set(handles.viscHGUI,'String',num2str(VISC,'%5.3e'));
    set(handles.erHGUI,'String',num2str(ER,'%5.3e'));
    set(handles.tHGUI,'String',num2str(T,'%5.3e'));
    %water chem and surf charge
    set(handles.isHGUI,'String',num2str(IS,'%5.3e'));
    set(handles.ziHGUI,'String',num2str(ZI,'%5.3e'));
    set(handles.zetapstHGUI,'String',num2str(ZETAPST,'%5.3e'));
    set(handles.zetacstHGUI,'String',num2str(ZETACST,'%5.3e'));
    % collector heterogeneity parameters
    set(handles.zetahetHGUI,'String',num2str(ZETAHET,'%5.3e'));
    set(handles.hetmodeHGUI,'String',num2str(HETMODE,'%d'));
    set(handles.rhet0HGUI,'String',num2str(RHET0,'%5.3e'));
    set(handles.rhet1HGUI,'String',num2str(RHET1,'%5.3e'));
    set(handles.rhet2HGUI,'String',num2str(RHET2,'%5.3e'));
    set(handles.scovHGUI,'String',num2str(SCOV,'%5.3e'));
    % colloid heterogeneity parameters
    set(handles.zetahetpHGUI,'String',num2str(ZETAHETP,'%5.3e'));
    set(handles.hetmodepHGUI,'String',num2str(HETMODEP,'%d'));
    set(handles.rhetp0HGUI,'String',num2str(RHETP0,'%5.3e'));
    set(handles.rhetp1HGUI,'String',num2str(RHETP1,'%5.3e'));
    set(handles.scovpHGUI,'String',num2str(SCOVP,'%5.3e'));    
    % van der Waals param
    set(handles.a132HGUI,'String',num2str(A132,'%5.3e'));
    set(handles.lambdavdwHGUI,'String',num2str(LAMBDAVDW,'%5.3e'));
    set(handles.vdwmodeHGUI,'String',num2str(VDWMODE,'%d'));
    % roughness param
    set(handles.bHGUI,'String',num2str(B,'%5.3e'));
    set(handles.rmodeHGUI,'String',num2str(RMODE,'%d'));
    set(handles.aspHGUI,'String',num2str(ASP,'%5.3e'));
    %van der Waals coated systems param
    set(handles.a11HGUI,'String',num2str(A11,'%5.3e'));
    set(handles.ac1c1HGUI,'String',num2str(AC1C1,'%5.3e'));
    set(handles.a22HGUI,'String',num2str(A22,'%5.3e'));
    set(handles.ac2c2HGUI,'String',num2str(AC2C2,'%5.3e'));
    set(handles.a33HGUI,'String',num2str(A33,'%5.3e'));
    set(handles.t1HGUI,'String',num2str(T1,'%5.3e'));
    set(handles.t2HGUI,'String',num2str(T2,'%5.3e'));
    %Lewis acid-base and steric hydration force parameters
    set(handles.gamma0abHGUI,'String',num2str(GAMMA0AB,'%5.3e'));
    set(handles.lambdaabHGUI,'String',num2str(LAMBDAAB,'%5.3e'));
    set(handles.gamma0steHGUI,'String',num2str(GAMMA0STE,'%5.3e'));
    set(handles.lambdasteHGUI,'String',num2str(LAMBDASTE,'%5.3e'));
    %Deformation parameters
    set(handles.kintHGUI,'String',num2str(KINT,'%5.3e'));
    set(handles.w132HGUI,'String',num2str(W132,'%5.3e'));
    set(handles.betaHGUI,'String',num2str(BETA,'%5.3e'));
    %Diffusion and Gravity factors
    set(handles.diffscaleHGUI,'String',num2str(DIFFSCALE,'%5.3e'));
    set(handles.gravfactHGUI,'String',num2str(GRAVFACT,'%5.3e'));
    %Simulation time step and Slow motion parameters
    set(handles.multbHGUI,'String',num2str(MULTB,'%5.3e'));
    set(handles.multnsHGUI,'String',num2str(MULTNS,'%5.3e'));
    set(handles.multcHGUI,'String',num2str(MULTC,'%5.3e'));
    set(handles.dfactnsHGUI,'String',num2str(DFACTNS,'%5.3e'));
    set(handles.dfactcHGUI,'String',num2str(DFACTC,'%5.3e'));
    % load Gravity checkboxes values
    set(handles.cbPZ,'Value',cbPZ);
    set(handles.cbMZ,'Value',cbMZ);
    set(handles.cbPX,'Value',cbPX);
    set(handles.cbMX,'Value',cbMX);
    % load Detailed plots checkboxes values
    set(handles.simplotCHECK,'Value',simplotCHECK);
    set(handles.detplotCHECK,'Value',detplotCHECK);   
    % change button color 
    set(handles.loadParam,'Backgroundcolor',[0.0 0.45 0.74]);
end



% --- Executes on button press in simplotCHECK.
function simplotCHECK_Callback(hObject, eventdata, handles)
% hObject    handle to simplotCHECK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of simplotCHECK
global simplot detplot
simplot=get(handles.simplotCHECK,'value');
detplot=get(handles.detplotCHECK,'value'); 
if simplot||detplot
    set(handles.saveSIMPLOT,'value',1)
else
    set(handles.saveSIMPLOT,'value',0)
end


% --- Executes during object creation, after setting all properties.
function loadParam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loadParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in saveSIMPLOT.
function saveSIMPLOT_Callback(hObject, eventdata, handles)
% hObject    handle to saveSIMPLOT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of saveSIMPLOT
global saveSIMPLOT
saveSIMPLOT=get(handles.saveSIMPLOT,'value');
if saveSIMPLOT
    set(handles.simplotCHECK,'value',1)
end

% --- Executes on button press in openfigure.
function openfigure_Callback(hObject, eventdata, handles)
% hObject    handle to openfigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global figtemp
%% set working directory        
if ~isdeployed
    % MATLAB environment
    inputdir = strrep(mfilename('fullpath'),'\Happel_GUI','\');
else
    %deployed application
    inputdir=strcat(pwd,'\');   
end
test = strcat(inputdir,'*.fig');
%  test = inputdir;
%% get upflux filename and path
[filename,filepath] = uigetfile(test,'Open figure file');
if isequal(filename,0)
   disp('User selected Cancel');
else
    % set full name
    figurefile=strcat(filepath,filename);
    figtemp=openfig(figurefile); 
end



function zetahetpHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to zetahetpHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zetahetpHGUI as text
%        str2double(get(hObject,'String')) returns contents of zetahetpHGUI as a double
zetahetpHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',zetahetpHGUI); 
set(handles.zetahetpHGUI,'String',zetahetpHGUI); 

% --- Executes during object creation, after setting all properties.
function zetahetpHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zetahetpHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hetmodepHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to hetmodepHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hetmodepHGUI as text
%        str2double(get(hObject,'String')) returns contents of hetmodepHGUI as a double
hetmodepHGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',hetmodepHGUI); 

hetmodepHGUI = str2double(get(handles.hetmodepHGUI, 'String'));
if hetmodepHGUI==5
    set(handles.rhetp0HGUI,'Enable','on');
    set(handles.rhetp1HGUI,'Enable','on');
    set(handles.scovpHGUI,'Enable','on');
    set(handles.zetahetpHGUI,'Enable','on');
    
elseif hetmodepHGUI==1
    set(handles.rhetp0HGUI,'Enable','on');
    set(handles.rhetp1HGUI,'Enable','off');
    set(handles.scovpHGUI,'Enable','on');
    set(handles.zetahetpHGUI,'Enable','on');
    
else
    set(handles.rhetp0HGUI,'Enable','on')
    set(handles.rhetp1HGUI,'Enable','off');
    set(handles.scovpHGUI,'Enable','on');
    set(handles.zetahetpHGUI,'Enable','on');
    set(handles.hetmodepHGUI,'String',1.0)
end
set(handles.hetmodepHGUI,'String',hetmodepHGUI); 

% --- Executes during object creation, after setting all properties.
function hetmodepHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hetmodepHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhetp0HGUI_Callback(hObject, eventdata, handles)
% hObject    handle to rhetp0HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhetp0HGUI as text
%        str2double(get(hObject,'String')) returns contents of rhetp0HGUI as a double
rhetp0HGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',rhetp0HGUI);

%enable fields if rhet0HGUI is non-zero
rhetp0HGUI  = str2double(get(handles.rhetp0HGUI, 'String'));
hetmodepHGUI = str2double(get(handles.hetmodepHGUI, 'String'));
if rhetp0HGUI>0
    set(handles.zetahetpHGUI,'Enable','on');
    set(handles.hetmodepHGUI,'Enable','on');
    set(handles.scovpHGUI,'Enable','on');
    set(handles.scovpHGUI,'String',0.0)
end

%enable fields if rhet0HGUI is non-zero
rhetp0HGUI  = str2double(get(handles.rhetp0HGUI, 'String'));
if rhetp0HGUI==0
    set(handles.zetahetpHGUI,'Enable','off');
    set(handles.hetmodepHGUI,'Enable','off');
    set(handles.rhetp1HGUI,'Enable','off');
    set(handles.scovpHGUI,'Enable','off');
    set(handles.scovpHGUI,'String',0.0);
end

%maximum allowed RHETP and miminum allowed SCOVP for uniform distribution
apHGUI = str2double(get(handles.apHGUI, 'String'));
rhetp0HGUI = str2double(get(handles.rhetp0HGUI, 'String'));
rhetp1HGUI = str2double(get(handles.rhetp1HGUI, 'String'));
scovpHGUI = str2double(get(handles.scovpHGUI, 'String'));

%calculate maximum RHETP0 for uniform distribution based on AP
rhetp0_max = 36.415*(2*apHGUI*1e6)^(0.5333);
rhetp0_max = rhetp0_max*1e-9; %meters
if rhetp0HGUI>rhetp0_max
    m_rhetp_max = 'The colloid heterodomain radius exceeds the limit that allows neglect of colloid rotation, see Ron & Johnson for more information. Upper limit of heterodomain radius used as default';
    warndlg(m_rhetp_max);
    set(handles.rhetp0HGUI, 'String', num2str(rhetp0_max));
end
if scovpHGUI>0
    %calculate minimum SCOVP for uniform distribution based on RHETP and AP
    if hetmodepHGUI == 1
        %value bounds set by Ron and Johnson 2020, the equation of the plane
        %was obtained via fitting to data presented in Figure 1c
        scovp0_min = 10^((1.963*log10(rhetp0HGUI*1e9) - 3.292 - log10(2*apHGUI*1e6))/0.8844);
        if scovpHGUI<scovp0_min
            m_scovp_min = 'The combination of colloid heterodomain radius and surface coverage lie outside the limits that allow neglecting colloid rotation, see Ron & Johnson for more information. Upper heterodomain radius limit and corresponding lower surface coverage limit used as default values';
            warndlg(m_scovp_min);
            set(handles.scovpHGUI, 'String', num2str(scovp0_min));
        end
    else
        rhetp_eqv = sqrt((rhetp0HGUI*1e9)^2.0 + (rhetp1HGUI*1e9)^2.0); 
        scovp0_min = 10^((1.963*log10(rhetp_eqv) - 3.292 - log10(2*apHGUI*1e6))/0.8844);
        if scovpHGUI<scovp0_min
            m_scovp_min = 'The combination of colloid heterodomain radius and surface coverage lie outside the limits that allow neglecting colloid rotation, see Ron & Johnson for more information. Upper heterodomain radius limit and corresponding lower surface coverage limit used as default values';
            warndlg(m_scovp_min);
            set(handles.scovpHGUI, 'String', num2str(scovp0_min));
        end
    end
end



% --- Executes during object creation, after setting all properties.
function rhetp0HGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhetp0HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhetp1HGUI_Callback(hObject, eventdata, handles)
% hObject    handle to rhetp1HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhetp1HGUI as text
%        str2double(get(hObject,'String')) returns contents of rhetp1HGUI as a double
rhetp1HGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',rhetp1HGUI);

%maximum allowed RHETP and miminum allowed SCOVP for uniform distribution
apHGUI = str2double(get(handles.apHGUI, 'String'));
rhetp0HGUI = str2double(get(handles.rhetp0HGUI, 'String'));
rhetp1HGUI = str2double(get(handles.rhetp1HGUI, 'String'));
scovpHGUI = str2double(get(handles.scovpHGUI, 'String'));
hetmodepHGUI = str2double(get(handles.hetmodepHGUI, 'String'));


%calculate maximum RHETP1 for uniform distribution based on RHETP0 and AP
if hetmodepHGUI == 5
    %calculate maximum RHETP0 for uniform distribution based on AP
    rhetp0_max = 36.415*(2*apHGUI*1e6)^(0.5333);
    rhetp0_max = rhetp0_max*1e-9; %nm to m
    rhetp_dif = (rhetp0_max)^2.0-(rhetp0HGUI)^2.0;
    if rhetp_dif<=0
        rhetp_dif = 0;
        rhetp1_max = 0;
    else
        rhetp1_max = (rhetp_dif)^0.5;%in m
    end
    if rhetp1HGUI>rhetp1_max
        m_rhetp1_max = 'The colloid combined heterodomain radii exceed the limit that allows neglect of colloid rotation, see Ron & Johnson for more information. Upper limit of small heterodomain radius used as default and surface coverage set to 0.';
        warndlg(m_rhetp1_max);
        set(handles.rhetp1HGUI, 'String', num2str(rhetp1_max));
        set(handles.scovpHGUI,'String',0.0)
    end
end

set(handles.scovpHGUI,'String',0.0); 



% --- Executes during object creation, after setting all properties.
function rhetp1HGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhetp1HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function scovpHGUI_Callback(hObject, eventdata, handles)
% hObject    handle to scovpHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of scovpHGUI as text
%        str2double(get(hObject,'String')) returns contents of scovpHGUI as a double
%%
global SCOVP
SCOVP = str2double(get(hObject,'String' )); 
scovpHGUI = SCOVP;
set(handles.scovpHGUI, 'String', num2str(SCOVP));
%%
if SCOVP <= 0.0||isnan(SCOVP)||SCOVP>1.0
    SCOVP = 0.0;
    set(handles.scovpHGUI, 'String', num2str(0.0));
else    
    set(handles.zetahetpHGUI, 'Enable', 'on');
    set(handles.hetmodepHGUI, 'Enable', 'on');
    set(handles.rhetp0HGUI, 'Enable', 'on');
    HAP_hetdomain_infop()

end
if SCOVP==0.0     
    set(handles.zetahetpHGUI, 'Enable', 'off');
    set(handles.hetmodepHGUI, 'Enable', 'off');
    set(handles.rhetp0HGUI, 'Enable', 'off');
    set(handles.rhetp1HGUI, 'Enable', 'off');
end
%%
%maximum allowed RHETP and miminum allowed SCOVP for uniform distribution
apHGUI = str2double(get(handles.apHGUI, 'String'));
rhetp0HGUI = str2double(get(handles.rhetp0HGUI, 'String'));
rhetp1HGUI = str2double(get(handles.rhetp1HGUI, 'String'));
hetmodepHGUI = str2double(get(handles.hetmodepHGUI, 'String'));

%calculate minimum SCOVP for uniform distribution based on RHETP and AP
if hetmodepHGUI == 1
    %value bounds set by Ron and Johnson 2020, the equation of the plane
    %was obtained via fitting to data presented in Figure 1c
    scovp0_min = 10^((1.963*log10(rhetp0HGUI*1e9) - 3.292 - log10(2*apHGUI*1e6))/0.8844);
    if scovpHGUI<scovp0_min
        m_scovp_min = 'The combination of colloid heterodomain radius and surface coverage lie outside the limits that allow neglecting colloid rotation, see Ron & Johnson for more information. Upper heterodomain radius limit and corresponding lower surface coverage limit used as default values';
        warndlg(m_scovp_min);
        set(handles.scovpHGUI, 'String', num2str(scovp0_min));
    end
else
    rhetp_eqv = sqrt((rhetp0HGUI*1e9)^2.0 + (rhetp1HGUI*1e9)^2.0); 
    scovp0_min = 10^((1.963*log10(rhetp_eqv) - 3.292 - log10(2*apHGUI*1e6))/0.8844);
    if scovpHGUI<scovp0_min
        m_scovp_min = 'The combination of colloid heterodomain radius and surface coverage lie outside the limits that allow neglecting colloid rotation, see Ron & Johnson for more information. Upper heterodomain radius limit and corresponding lower surface coverage limit used as default values';
        warndlg(m_scovp_min);
        set(handles.scovpHGUI, 'String', num2str(scovp0_min));
    end
end




% --- Executes during object creation, after setting all properties.
function scovpHGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scovpHGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhet2HGUI_Callback(hObject, eventdata, handles)
% hObject    handle to rhet2HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet2HGUI as text
%        str2double(get(hObject,'String')) returns contents of rhet2HGUI as a double
rhet2HGUI = str2double(get(hObject,'String' )); 
set(hObject,'String',rhet2HGUI); 
set(handles.rhet2HGUI,'String',rhet2HGUI); 

% --- Executes during object creation, after setting all properties.
function rhet2HGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet2HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when uipanel31 is resized.
function uipanel31_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to uipanel31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uipanel14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uipanel31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uipanel36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uipanel16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uipanel39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function asp2HGUI_Callback(hObject, eventdata, handles)
% hObject    handle to asp2HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of asp2HGUI as text
%        str2double(get(hObject,'String')) returns contents of asp2HGUI as a double


% --- Executes during object creation, after setting all properties.
function asp2HGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to asp2HGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in detplotCHECK.
function detplotCHECK_Callback(hObject, eventdata, handles)
% hObject    handle to detplotCHECK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of detplotCHECK
global simplot detplot
simplot=get(handles.simplotCHECK,'value');
detplot=get(handles.detplotCHECK,'value'); 
if simplot||detplot
    set(handles.saveSIMPLOT,'value',1)
else
    set(handles.saveSIMPLOT,'value',0)
end


% --- Executes on button press in pb_setdir.
function pb_setdir_Callback(hObject, eventdata, handles)
% hObject    handle to pb_setdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mainworkdir
%% SET OUTPUT directory to write output profile, and sim parameters 
% % set working directory        
if ~isdeployed
    % MATLAB environment
    mname = mfilename('fullpath');
    outputpath = strrep(mname,'\Happel_GUI','\')
else
   %deployed application
    outputpath=pwd
end
mainworkdir = uigetdir(outputpath,'Select Output Directory');
%
if mainworkdir==0
    warndlg('Please Select Output Directory')
else
    % enable buttons
    set(handles.outdirHGUI,'Enable','on')
    set(handles.loadParam,'Enable','on')
    set(handles.runHAP,'Enable','on')
end


% --- Executes on button press in pb_setdirPERT.
function pb_setdirPERT_Callback(hObject, eventdata, handles)
% hObject    handle to pb_setdirPERT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global mainworkdir
%% SET OUTPUT directory to write output profile, and sim parameters 
% % set working directory        
if ~isdeployed
    % MATLAB environment
    mname = mfilename('fullpath');
    outputpath = strrep(mname,'\Happel_GUI','\')
else
   %deployed application
    outputpath=pwd
end
mainworkdir = uigetdir(outputpath,'Select Output Directory');
%
if mainworkdir==0
    warndlg('Please Select Output Directory')
else
    % enable buttons
    set(handles.outdirPERT,'Enable','on')
    set(handles.runPERT,'Enable','on')
    set(handles.runPERT,'Backgroundcolor','g');
end


% --- Executes on button press in cbPZ.
function cbPZ_Callback(hObject, eventdata, handles)
% hObject    handle to cbPZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cbPZ cbMZ cbPX cbMX
% Hint: get(hObject,'Value') returns toggle state of cbPZ
cbPZ=get(handles.cbPZ,'value');
if cbPZ
    set(handles.cbPZ,'value',1)
    set(handles.cbMZ,'Value',0);
    set(handles.cbPX,'Value',0);
    set(handles.cbMX,'Value',0);
    cbPZ  =1;
    cbMZ  =0;
    cbPX  =0;
    cbMX  =0;
else
    set(handles.cbPZ,'value',0)
    set(handles.cbMZ,'Value',1);
    set(handles.cbPX,'Value',0);
    set(handles.cbMX,'Value',0);
    cbPZ  =0;
    cbMZ  =1;
    cbPX  =0;
    cbMX  =0;   
end




% --- Executes on button press in cbMZ.
function cbMZ_Callback(hObject, eventdata, handles)
% hObject    handle to cbMZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cbPZ cbMZ cbPX cbMX
% Hint: get(hObject,'Value') returns toggle state of cbMZ
cbMZ=get(handles.cbPZ,'value');
if cbMZ
    set(handles.cbPZ,'value',0)
    set(handles.cbMZ,'Value',1);
    set(handles.cbPX,'Value',0);
    set(handles.cbMX,'Value',0);
    cbPZ  =0;
    cbPX  =0;
    cbMX  =0;
else
    set(handles.cbPZ,'value',1)
    set(handles.cbMZ,'Value',0);
    set(handles.cbPX,'Value',0);
    set(handles.cbMX,'Value',0);
    cbPZ  =1;
    cbMZ  =0;
    cbPX  =0;
    cbMX  =0;   
end



% --- Executes on button press in cbPX.
function cbPX_Callback(hObject, eventdata, handles)
% hObject    handle to cbPX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cbPZ cbMZ cbPX cbMX
% Hint: get(hObject,'Value') returns toggle state of cbPX
cbPX=get(handles.cbPX,'value');
if cbPX
    set(handles.cbPZ,'value',0)
    set(handles.cbMZ,'Value',0);
    set(handles.cbPX,'Value',1);
    set(handles.cbMX,'Value',0);
    cbPZ  =0;
    cbMZ  =0;
    cbMX  =0;
else
    set(handles.cbPZ,'value',0)
    set(handles.cbMZ,'Value',1);
    set(handles.cbPX,'Value',0);
    set(handles.cbMX,'Value',0);
    cbPZ  =0;
    cbMZ  =1;
    cbPX  =0;
    cbMX  =0;       
end

% --- Executes on button press in cbMX.
function cbMX_Callback(hObject, eventdata, handles)
% hObject    handle to cbMX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cbPZ cbMZ cbPX cbMX
% Hint: get(hObject,'Value') returns toggle state of cbMX
cbMX=get(handles.cbMX,'value');
if cbMX
    set(handles.cbPZ,'value',0)
    set(handles.cbMZ,'Value',0);
    set(handles.cbPX,'Value',0);
    set(handles.cbMX,'Value',1);
    cbPZ  =0;
    cbMZ  =0;
    cbPX  =0;
else
    set(handles.cbPZ,'value',0)
    set(handles.cbMZ,'Value',1);
    set(handles.cbPX,'Value',0);
    set(handles.cbMX,'Value',0);
    cbPZ  =0;
    cbMZ  =1;
    cbPX  =0;
    cbMX  =0;      
end
