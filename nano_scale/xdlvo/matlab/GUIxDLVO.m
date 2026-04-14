function varargout = GUIxDLVO(varargin)
% GUIXDLVO MATLAB code for GUIxDLVO.fig
%      GUIXDLVO, by itself, creates a new GUIXDLVO or raises the existing
%      singleton*.
%
%      H = GUIXDLVO returns the handle to a new GUIXDLVO or the handle to
%      the existing singleton*.
%
%      GUIXDLVO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIXDLVO.M with the given input arguments.
%
%      GUIXDLVO('Property','Value',...) creates a new GUIXDLVO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUIxDLVO_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUIxDLVO_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUIxDLVO

% Last Modified by GUIDE v2.5 04-Dec-2023 21:53:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUIxDLVO_OpeningFcn, ...
    'gui_OutputFcn',  @GUIxDLVO_OutputFcn, ...
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


% --- Executes just before GUIxDLVO is made visible.
function GUIxDLVO_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUIxDLVO (see VARARGIN)

% Choose default command line output for GUIxDLVO
handles.output = hObject;
set(gcf, 'Units', 'normal')
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUIxDLVO wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUIxDLVO_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function a1_Callback(hObject, eventdata, handles)

% hObject    handle to a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a1 as text
%        str2double(get(hObject,'String')) returns contents of a1 as a double
global a1
a1 = str2double(get(hObject,'String' ));


% --- Executes during object creation, after setting all properties.
function a1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function a2_Callback(hObject, eventdata, handles)
% hObject    handle to a2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of a2 as text
%        str2double(get(hObject,'String')) returns contents of a2 as a double
global a2
a2 = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function a2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to a2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IS_Callback(hObject, eventdata, handles)
% hObject    handle to IS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of IS as text
%        str2double(get(hObject,'String')) returns contents of IS as a double
global IS
IS = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function IS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zetac_Callback(hObject, eventdata, handles)
% hObject    handle to zetac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zetac as text
%        str2double(get(hObject,'String')) returns contents of zetac as a double
global zetac
zetac = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function zetac_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zetac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% function zetap1_Callback(hObject, eventdata, handles)
% % hObject    handle to zetac (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
%
% % Hints: get(hObject,'String') returns contents of zetac as text
% %        str2double(get(hObject,'String')) returns contents of zetac as a double
% global zetap
% zetap = str2double(get(hObject,'String' ));
%
% % --- Executes during object creation, after setting all properties.
% function zetap1_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to zetac (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
%
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end



function Rmode_Callback(hObject, eventdata, handles)
% hObject    handle to Rmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rmode as text
%        str2double(get(hObject,'String')) returns contents of Rmode as a double
global Rmode
Rmode = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function Rmode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rmode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function aasp_Callback(hObject, eventdata, handles)
% hObject    handle to aasp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aasp as text
%        str2double(get(hObject,'String')) returns contents of aasp as a double

global aasp
aasp = str2double(get(hObject,'String' ));
if aasp <=0.0;
    aasp= 0.0;
    set(handles.aasp,'String',num2str(aasp))
    set(handles.cbRmode0,'Value',1)
    set(handles.cbRmode1,'Value',0)
    set(handles.cbRmode2,'Value',0)
    set(handles.cbRmode3,'Value',0)
else
    % check status of roughness and coated
    cbRmode0= get (handles.cbRmode0,'Value');
    cbRmode1= get (handles.cbRmode1,'Value');
    cbRmode2= get (handles.cbRmode2,'Value');
    cbRmode3= get (handles.cbRmode3,'Value');
    cbCOATED= get (handles.cbCOATED,'Value');
    if cbRmode0==1
        set(handles.cbRmode0,'Value',0)
    end
    if cbRmode1+cbRmode2+cbRmode3==0
        % by default select rough collector
        set (handles.cbRmode1,'Value',1)
        if cbCOATED
            msg_select_roughness_uncoat
        else
            % alert user to select a type of rough system
            msg_select_roughness
        end
    end
    if aasp<5.0e-9
        %reset to minimum
        aasp= 5.0e-9;
        set(handles.aasp,'String',num2str(aasp))
        msg_min_roughness
    end
    if aasp>1.0e-5
        % reset value to 10 um and alert user
        aasp = 1.0e-5;
        set(handles.aasp,'String',num2str(aasp))
        msg_select_roughness_large
    end
    %reset coated checkbox if needed
    if cbCOATED==1
        set(handles.cbCOATED,'Value',0)
    end
    
end
% --- Executes during object creation, after setting all properties.
function aasp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aasp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Nco_Callback(hObject, eventdata, handles)
% hObject    handle to Nco (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nco as text
%        str2double(get(hObject,'String')) returns contents of Nco as a double
global Nco
Nco = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function Nco_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nco (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sigmac_Callback(hObject, eventdata, handles)
% hObject    handle to sigmac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigmac as text
%        str2double(get(hObject,'String')) returns contents of sigmac as a double
global sigmac
sigmac = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function sigmac_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigmac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function h0_Callback(hObject, eventdata, handles)
% hObject    handle to h0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of h0 as text
%        str2double(get(hObject,'String')) returns contents of h0 as a double
global h0
h0 = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function h0_CreateFcn(hObject, eventdata, handles)
% hObject    handle to h0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T_Callback(hObject, eventdata, handles)
% hObject    handle to T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T as text
%        str2double(get(hObject,'String')) returns contents of T as a double
global T
T = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function T_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lambdaVDW_Callback(hObject, eventdata, handles)
% hObject    handle to lambdaVDW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambdaVDW as text
%        str2double(get(hObject,'String')) returns contents of lambdaVDW as a double
global lambdaVDW
lambdaVDW = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function lambdaVDW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambdaVDW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lambdaAB_Callback(hObject, eventdata, handles)
% hObject    handle to lambdaAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambdaAB as text
%        str2double(get(hObject,'String')) returns contents of lambdaAB as a double
global lambdaAB
lambdaAB = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function lambdaAB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambdaAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lambdaSTE_Callback(hObject, eventdata, handles)
% hObject    handle to lambdaSTE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lambdaSTE as text
%        str2double(get(hObject,'String')) returns contents of lambdaSTE as a double
global lambdaSTE
lambdaSTE = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function lambdaSTE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lambdaSTE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gammaSTE_Callback(hObject, eventdata, handles)
% hObject    handle to gammaSTE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gammaSTE as text
%        str2double(get(hObject,'String')) returns contents of gammaSTE as a double
global gammaSTE
gammaSTE = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function gammaSTE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammaSTE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function epsilonR_Callback(hObject, eventdata, handles)
% hObject    handle to epsilonR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of epsilonR as text
%        str2double(get(hObject,'String')) returns contents of epsilonR as a double
global epsilonR
epsilonR = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function epsilonR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epsilonR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_Callback(hObject, eventdata, handles)
% hObject    handle to z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z as text
%        str2double(get(hObject,'String')) returns contents of z as a double
global z
z = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function z_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function A132_Callback(hObject, eventdata, handles)
% hObject    handle to A132 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A132 as text
%        str2double(get(hObject,'String')) returns contents of A132 as a double
global A132
A132 = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function A132_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A132 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gammaAB_Callback(hObject, eventdata, handles)
% hObject    handle to gammaAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gammaAB as text
%        str2double(get(hObject,'String')) returns contents of gammaAB as a double
global gammaAB
gammaAB = str2double(get(hObject,'String' ));
set(handles.INDgammaAB,'String',num2str(gammaAB));

% --- Executes during object creation, after setting all properties.
function gammaAB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammaAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkboxSS.
function checkboxSS_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSS
global SS a2temp
SS = get(hObject,'Value');
if SS
    set(handles.checkboxSP,'Value',0);
    set(handles.a2,'Enable','on');
    set(handles.a2,'String',a2temp);
else
    set(handles.checkboxSP,'Value',1);
    set(handles.a2,'Enable','off');
    a2temp = get(handles.a2,'String');
    set(handles.a2,'String','N/A');
    
end


% --- Executes on button press in checkboxSP.
function checkboxSP_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSP
global SP a2temp
SP = get(hObject,'Value');
if SP
    set(handles.checkboxSS,'Value',0);
    set(handles.a2,'Enable','off');
    a2temp = get(handles.a2,'String');
    set(handles.a2,'String','N/A');
else
    set(handles.checkboxSS,'Value',1);
    set(handles.a2,'Enable','on');
    set(handles.a2,'String',a2temp);
end

function calculateButton_Callback(hObject, eventdata, handles)
% --- Executes on button press in calculateButton.
% hObject    handle to calculateButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% output parameters
global H Hnm EJ Ekt F H2 cbHETPLOTS rhetv cbHET cbHETUSER zetahet names
global afvector rZOI
% initialize hetdomain influence plots toggle as zero
cbHETPLOTS = 0;
%% input parameters
global  a1 a2 IS zetac zetap aasp sigmac T
global lambdaVDW lambdaAB lambdaSTE gammaSTE epsilonR z A132
global SP SS Rmode VDWmode
% global vdw from fundamentals
global ve e1 n1 e2 n2 e3 n3 A132calc
% global vdw coated systems
global T1 T2 A33 %coating thickness and fluid Hamaker
global A12  A12p A13  A1p2  A1p2p A1p3 A23 A2p3 %combined Hamaker
global A12c A12pc A13c A1p2c  A1p2pc A1p3c A23c A2p3c  %combined Hamaker calculated
global A11 A1p1p A22 A2p2p % single materials Hamaker
global s1A1p2p s1A12p s1A1p2 s1A12 s2A12p s2A12 s3A1p2 s3A12 % hamaker constributions
%acid-base energy fundamentals
global g1pos g1neg g2pos g2neg g3pos g3neg gammaABcalc gammaAB
%work of adhesion fundamentals
global g1LW g2LW g3LW INDgammaAB W132calc W132
%aconr for steric fundamentals
global E1 E2 v1 v2 INDW132  Kint acontCALC  acont
% aproximated Hamaker for Born in coated system case
global aproxA132
% checkboxes
global cbCOATED cbA132  cbgammaAB cbW132 cbacont
global cb1 cb2 cb3
global  cbRmode1 cbRmode2 cbRmode3
% global for plots
global limvekt limvf hmaxdef h21 h22 FhetT EhetT lw
%% read main parameters
%% Geometry
if (get(handles.checkboxSS,'Value'))
    SS = 1;
    SP = 0;
else
    SP = 1;
    SS = 0;
end
%% Roughness mode
if (get(handles.cbRmode0,'Value'))
    Rmode = 0;
end
if (get(handles.cbRmode1,'Value'))
    Rmode = 1;
end
if (get(handles.cbRmode2,'Value'))
    Rmode = 2;
end
if (get(handles.cbRmode3,'Value'))
    Rmode = 3;
end
%% over mean field surface or over heterodomain
cbHET = get(handles.cbHET,'Value');
cbHETUSER = get(handles.cbHETUSER,'Value');
% read heterodomain properties
if cbHET||cbHETUSER
    %rhet = str2double(get(handles.rhet,'String'));
    zetahet = str2double(get(handles.zetahet,'String'));
end
%% main DLVO
T = str2double(get(handles.T,'String' ));
IS = str2double(get(handles.IS,'String' ));
a1 = str2double(get(handles.a1,'String' ));
a2 = str2double(get(handles.a2,'String' ));
zetac = str2double(get(handles.zetac,'String' ));
zetap = str2double(get(handles.zetap,'String' ));
z = str2double(get(handles.z,'String' ));
epsilonR = str2double(get(handles.epsilonR,'String' ));
lambdaVDW = str2double(get(handles.lambdaVDW,'String' ));
sigmac = str2double(get(handles.sigmac,'String' ));
%% xDLVO parameters
lambdaAB = str2double(get(handles.lambdaAB,'String' ));
lambdaSTE = str2double(get(handles.lambdaSTE,'String' ));
gammaSTE = str2double(get(handles.gammaSTE,'String' ));
aasp = str2double(get(handles.aasp,'String' ));
%% vdW parameters
% initialize vdw fundamentals
ve = 'N/A'; e1 = 'N/A'; n1 = 'N/A'; e2 = 'N/A'; n2 = 'N/A';
e3 = 'N/A'; n3 = 'N/A'; A132calc = 'N/A';
%% initialize vdw coated system parameters
%coating thickness and Fluid Hamaker constant
T1 = 'N/A'; T2 = 'N/A'; A33 = 'N/A';
%combined Hamaker
A12 = 'N/A'; A12p = 'N/A';  A13 = 'N/A'; A1p2  = 'N/A';
A1p2p = 'N/A'; A1p3 = 'N/A'; A23 = 'N/A'; A2p3 = 'N/A';
%combined Hamaker calculated flag
A12c = 0; A12pc = 0; A13c = 0; A1p2c = 0;  A1p2pc = 0;
A1p3c = 0; A23c = 0; A2p3c = 0;
% single materials Hamaker
A11 = 'N/A'; A1p1p = 'N/A'; A22 = 'N/A';  A2p2p = 'N/A';
% hamaker constributions
s1A1p2p = 'N/A'; s1A12p = 'N/A'; s1A1p2 = 'N/A';  s1A12 = 'N/A';
s2A12p = 'N/A'; s2A12 = 'N/A'; s3A1p2 = 'N/A';  s3A12 = 'N/A';
%% initialize acid-base energy fundamentals
g1pos = 'N/A'; g1neg = 'N/A'; g2pos = 'N/A';
g2neg = 'N/A'; g3pos = 'N/A'; g3neg = 'N/A'; gammaABcalc = 'N/A';
%% initialize work of adhesion fundamentals
g1LW = 'N/A'; g2LW = 'N/A'; g3LW = 'N/A'; INDgammaAB = 'N/A'; W132calc= 'N/A';
%% initialize contact radius for steric interaction fundamentals
E1 = 'N/A'; E2 = 'N/A'; v1 = 'N/A'; v2 = 'N/A';
INDW132 = 'N/A';  Kint = 'N/A'; acontCALC = 'N/A';
%% check if coated system for vdw was active
cbCOATED=get(handles.cbCOATED,'Value');
cbA132=get(handles.cbA132,'Value');
if cbCOATED
    % set combined Hamnaker to N/A (not used in coated systems)
    A132 = 'N/A';
    % load values from used parameters
    %coating thickness and Fluid Hamaker constant
    T1 = str2double(get(handles.T1,'String'));
    T2 = str2double(get(handles.T2,'String'));
    A33 = str2double(get(handles.A33,'String'));
    %combined Hamaker
    A12 = str2double(get(handles.A12,'String'));
    A12p = str2double(get(handles.A12p,'String'));
    A13 = str2double(get(handles.A13,'String'));
    A1p2 = str2double(get(handles.A1p2,'String'));
    A1p2p = str2double(get(handles.A1p2p,'String'));
    A1p3 = str2double(get(handles.A1p3,'String'));
    A23 = str2double(get(handles.A23,'String'));
    A2p3 = str2double(get(handles.A2p3,'String'));
    %combined Hamaker calculated flag
    A12c = get(handles.cbA12,'Value');
    A12pc = get(handles.cbA12p,'Value');
    A13c = get(handles.cbA13,'Value');
    A1p2c = get(handles.cbA1p2,'Value');
    A1p2pc = get(handles.cbA1p2p,'Value');
    A1p3c = get(handles.cbA1p3,'Value');
    A23c = get(handles.cbA23,'Value');
    A2p3c = get(handles.cbA2p3,'Value');
    % single materials Hamaker
    A11 = str2double(get(handles.A11,'String'));
    A1p1p = str2double(get(handles.A1p1p,'String'));
    A22 = str2double(get(handles.A22,'String'));
    A2p2p = str2double(get(handles.A2p2p,'String'));
    % load corresponding hamaker contributions depending on type of coated
    % system
    cb1 = get(handles.cb1,'Value');
    if cb1
        VDWmode = 1;
        %get Hamaker contributions values
        s1A1p2p = str2double(get(handles.s1A1p2p,'String'));
        s1A12p = str2double(get(handles.s1A12p,'String'));
        s1A1p2 = str2double(get(handles.s1A1p2,'String'));
        s1A12 = str2double(get(handles.s1A12,'String'));
        %set corresponding combined Hamaker constant aproximated from
        %coating contributions
        aproxA132 = s1A1p2p;
    end
    cb2 = get(handles.cb2,'Value');
    if cb2
        VDWmode = 2;
        %get Hamaker contributions values
        s2A12p = str2double(get(handles.s2A12p,'String'));
        s2A12 = str2double(get(handles.s2A12,'String'));
        %set corresponding combined Hamaker constant aproximated from
        %coating contributions
        aproxA132 = s2A12p;
    end
    cb3 = get(handles.cb3,'Value');
    if cb3
        VDWmode = 3;
        %get Hamaker contributions values
        s3A1p2 = str2double(get(handles.s3A1p2,'String'));
        s3A12 = str2double(get(handles.s3A12,'String'));
        %set corresponding combined Hamaker constant aproximated from
        %coating contributions
        aproxA132 = s3A1p2;
    end
else
    VDWmode = 0;
    A132 = str2double(get(handles.A132,'String'));
    % get values if A132 calculated from fundamentals
    cbA132=get(handles.cbA132,'Value');
    if cbA132
        ve = str2double(get(handles.ve,'String'));
        e1 = str2double(get(handles.e1,'String'));
        n1 = str2double(get(handles.n1,'String'));
        e2 = str2double(get(handles.e2,'String'));
        n2 = str2double(get(handles.n2,'String'));
        e3 = str2double(get(handles.e3,'String'));
        n3 = str2double(get(handles.n3,'String'));
        A132calc = str2double(get(handles.A132calc,'String'));
    end
end
%% check if acid-base energy was calculated from fundamentals
gammaAB = str2double(get(handles.gammaAB,'String'));
cbgammaAB=get(handles.cbgammaAB,'Value');
if cbgammaAB
    g1pos = str2double(get(handles.g1pos,'String'));
    g1neg = str2double(get(handles.g1neg,'String'));
    g2pos = str2double(get(handles.g2pos,'String'));
    g2neg = str2double(get(handles.g2neg,'String'));
    g3pos = str2double(get(handles.g3pos,'String'));
    g3neg = str2double(get(handles.g3neg,'String'));
    gammaABcalc = str2double(get(handles.gammaABcalc,'String'));
end
%% check if work  of adhesion, was calculated from fundamentals
W132 = str2double(get(handles.W132,'String'));
cbW132 = get(handles.cbW132,'Value');
if cbW132
    g1LW = str2double(get(handles.g1LW,'String'));
    g2LW = str2double(get(handles.g2LW,'String'));
    g3LW = str2double(get(handles.g3LW,'String'));
    INDgammaAB = str2double(get(handles.INDgammaAB,'String'));
    W132calc = str2double(get(handles.W132calc,'String'));
end
%% check if contat radius was calculated from fundamentals
acont = str2double(get(handles.acont,'String'));
cbacont = get(handles.cbacont,'Value');
if cbacont
    E1 = str2double(get(handles.E1,'String'));
    E2 = str2double(get(handles.E2,'String'));
    v1 = str2double(get(handles.v1,'String'));
    v2 = str2double(get(handles.v2,'String'));
    INDW132 = str2double(get(handles.INDW132,'String'));
    Kint = str2double(get(handles.Kint,'String'));
    acontCALC = str2double(get(handles.acontCALC,'String'));
end
%%  CALCULATE PROFILES
% define constants
kB = 1.3806485e-23; %Boltzmann J/k
kt = kB*T; %(J)
hP = 6.62607004e-34 ;%Plank constant (J.s)
e_charge=1.602176621e-19; % elementry charge (C)
Na = 6.02214086e+23;%avogradro number (-)
epsilon0 = 8.85418781762e-12; % Vacuum permitivity (C2/(N.m2))
epsilonW = epsilon0*epsilonR;
% number of interactions per asperity
% Ranges from 1-4 for opposed and complimentary packed asperities, respectively.
% Recommended value is 2.5
Nco = 2.5;
% Minimum separation distance, generally accepted to be 1.58 amstrongs (in vacuum Israelachvili)
% ho = 1.58e-10;
% calculated parameters
%inverse Debye lenght
K = 1/(epsilonW*kB*T/2/Na/z^2/e_charge^2/IS)^0.5;
% radius of zone of influence (rZOI) for EDL
rZOI = 2*(a1*K^-1)^0.5;
% set rZOI field value
set(handles.rZOI,'Enable','on')
set(handles.rZOI,'String',num2str(rZOI))
% radius of zone of influence (rZOIAB) for Acid-base
rZOIAB = 2*(a1*lambdaAB)^0.5;
% populate rhetv values in GUI
if cbHET
    % calculate rhetvector corresponding to 0.2 0.4 0.6 and 0.8 ZOI
    afvector = [0.25 0.5 0.75 1.0]; % if changed change GUI respectively
    rhetv = (afvector*rZOI^2).^0.5;
    set(handles.rhet1,'String',num2str(rhetv(1)))
    set(handles.rhet1,'ForegroundColor','b')
    set(handles.rhet2,'String',num2str(rhetv(2)))
    set(handles.rhet2,'ForegroundColor','b')
    set(handles.rhet3,'String',num2str(rhetv(3)))
    set(handles.rhet3,'ForegroundColor','b')
    set(handles.rhet4,'String',num2str(rhetv(4)))
    set(handles.rhet4,'ForegroundColor','b')
end
if cbHETUSER
    % obtain rhetvector corresponding to user specified rhets
    rhetv(1) = str2double(get(handles.rhet1USER,'String'));
    rhetv(2) = str2double(get(handles.rhet2USER,'String'));
    rhetv(3) = str2double(get(handles.rhet3USER,'String'));
    rhetv(4) = str2double(get(handles.rhet4USER,'String'));
    % hetdomain area vector
    ahetv = rhetv.^2*pi;
    afvector = ahetv/(rZOI^2*pi);
    afvector(afvector>1)=1; % bound fractional area to maximum coverage
end


% set number of asperities in zone of influence EDL and vdw
asplim = 0.5*(pi^0.5)*rZOI;
if (aasp>=asplim)
    n = 1;
else
    n = rZOI^2/(aasp^2)*(pi/4);
end
% calculate number of asperities in zone of influence for AB
asplimAB = 0.5*(pi^0.5)*rZOIAB;
if (aasp>=asplimAB)
    nAB = 1;
else
    nAB = (rZOIAB^2)/(aasp^2)*(pi/4);
end

% smooth surface coverage for EDL
if Rmode>0&&aasp>0.0
    theta = 1.0-pi/4;
else
    theta = 1.0;
end
% radius of steric hydration contact
aSte=(acont^2+2*lambdaSTE*(a1+(a1^2-acont^2)^0.5))^0.5;
%% define separation distance vector
% step factor , hmax
sf = 0.01; hmax = 1.0e-6; hmin =  1.0E-10;
% generate vector
H(1) = hmin; i =1;
while H(i)<=hmax;
    H(i+1) = H(i)*(1+sf);
    i=i+1;
end
% separation distance for offset smooth surface (Rmode > 0)
if (Rmode==1)||(Rmode==2)
    Hoff = aasp; % complimentary offset surface distance
    H2 = H + Hoff;
elseif Rmode==3
    Hoff = 0.5*(2*aasp + sqrt(3)*aasp); % complimentary offset surface distance
    H2 = H + Hoff;
end
%% Sphere_sphere geometry
if SS==1
    %interactions independet of coating and roughness (assumed)
    % Born interaction
    if cbCOATED
        A132c = aproxA132;
    else
        A132c = A132;
    end
    Eborn=E_Born_SS(H,A132c,sigmac,a1);
    Fborn=F_Born_SS(H,A132c,sigmac,a1);
    % Steric interaction
    Este=E_Ste_SS(H,lambdaSTE,gammaSTE,aSte);
    Fste=F_Ste_SS(H,lambdaSTE,gammaSTE,aSte);
    % smooth surface
    if Rmode==0
        if cbCOATED
            %coated colloid-coated collector
            if VDWmode==1
                Evdw=E_vdW_SS_coated_systems(H,a1,a2,lambdaVDW,...
                    T1,T2,s1A1p2p,s1A12p,s1A1p2,s1A12,VDWmode);
                Fvdw=F_vdW_SS_coated_systems(H,a1,a2,lambdaVDW,...
                    T1,T2,s1A1p2p,s1A12p,s1A1p2,s1A12,VDWmode);
            end
            %colloid-coated collector
            if VDWmode==2
                Evdw=E_vdW_SS_coated_systems(H,a1,a2,lambdaVDW,...
                    T1,T2,0.0,s2A12p,0.0,s2A12,VDWmode);
                Fvdw=F_vdW_SS_coated_systems(H,a1,a2,lambdaVDW,...
                    T1,T2,0.0,s2A12p,0.0,s2A12,VDWmode);
            end
            %coated colloid-collector
            if VDWmode==3
                Evdw=E_vdW_SS_coated_systems(H,a1,a2,lambdaVDW,...
                    T1,T2,0.0,0.0,s3A1p2,s3A12,VDWmode);
                Fvdw=F_vdW_SS_coated_systems(H,a1,a2,lambdaVDW,...
                    T1,T2,0.0,0.0,s3A1p2,s3A12,VDWmode);
            end
        else %not coated smooth
            %Evdw
            Evdw=E_vdW_SS_colloid_plate(H,A132,a1,a2,lambdaVDW);
            Fvdw=F_vdW_SS_colloid_plate(H,A132,a1,a2,lambdaVDW);
        end
        %EDL smooth
        Eedl =E_EDL_SS_colloid_plate(H,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetac,a1,a2);
        Fedl =F_EDL_SS_colloid_plate(H,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetac,a1,a2);
        if cbHET||cbHETUSER
            Eedlhet =E_EDL_SS_colloid_plate(H,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetahet,a1,a2);
            Fedlhet =F_EDL_SS_colloid_plate(H,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetahet,a1,a2);
        end
        %acid base smooth
        % determine ho for minimum (Eborn+Evdw) Energy
        [Emin,imin]=min(Eborn+Evdw);
        % hardwired ho for negative Hamaker constant
        if A132>0.0
            ho = H(imin);
        else
            ho = 1.58e-10;
        end
        Eab =E_AB_SS_colloid_plate(H,lambdaAB,a1,gammaAB,ho,a2);
        Fab =F_AB_SS_colloid_collector(H,lambdaAB,a1,gammaAB,ho,a2);
    else
        % Rmode1 = Rough Colloid; rmode=2 Rough Collector; Rmode=3 Rough Colloid and Collector;
        Evdw =E_vdW_SS_colloid_plate(H2,A132,a1,a2,lambdaVDW)...
            + E_vdW_SS_RMODE(n,H,A132,aasp,a2,lambdaVDW,a1,Rmode,Nco);
        Fvdw =F_vdW_SS_colloid_plate(H2,A132,a1,a2,lambdaVDW)...
            + F_vdW_SS_RMODE(n,H,a2,A132,aasp,lambdaVDW,a1,Rmode,Nco);
        %EDL rough
        Eedl =theta*E_EDL_SS_colloid_plate(H2,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetac,a1,a2)...
            + E_EDL_SS_RMODE(H,a2,epsilonW,K,kB,T,z,zetap,e_charge,zetac,aasp,a1,Rmode,n,Nco);
        Fedl =theta*F_EDL_SS_colloid_plate(H2,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetac,a1,a2)...
            + F_EDL_SS_RMODE(H,a2,epsilonW,K,kB,T,z,zetap,e_charge,zetac,aasp,a1,Rmode,n,Nco);
        if cbHET||cbHETUSER
            Eedlhet =theta*E_EDL_SS_colloid_plate(H2,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetahet,a1,a2)...
                + E_EDL_SS_RMODE(H,a2,epsilonW,K,kB,T,z,zetap,e_charge,zetahet,aasp,a1,Rmode,n,Nco);
            Fedlhet =theta*F_EDL_SS_colloid_plate(H2,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetahet,a1,a2)...
                + F_EDL_SS_RMODE(H,a2,epsilonW,K,kB,T,z,zetap,e_charge,zetahet,aasp,a1,Rmode,n,Nco);
        end
        % determine ho for minimum (Eborn+Evdw) Energy
        [Emin,imin]=min(Eborn+Evdw);
        % hardwired ho for negative Hamaker constant
        if A132>0.0
            ho = H(imin);
        else
            ho = 1.58e-10;
        end
        Eab =E_AB_SS_RMODE(H,lambdaAB,aasp,nAB,gammaAB,ho,Rmode,a1,a2,Nco);
        Fab =F_AB_SS_RMODE(H,lambdaAB,aasp,nAB,gammaAB,ho,Rmode,a1,a2,Nco);
    end
end
if SP==1
    %interactions independet of coating and roughness (assumed)
    % Born interaction
    if cbCOATED
        A132c = aproxA132;
    else
        A132c = A132;
    end
    Eborn=E_Born_SP_colloid_plate(H,A132c,sigmac,a1);
    Fborn=F_Born_SP_colloid_plate(H,A132c,sigmac,a1);
    % Steric interaction
    Este=E_Ste_SP_colloid_plate(H,lambdaSTE,gammaSTE,aSte);
    Fste=F_Ste_SP_colloid_plate(H,lambdaSTE,gammaSTE,aSte);
    % smooth surface
    if Rmode==0
        if cbCOATED
            %coated colloid-coated collector
            if VDWmode==1
                Evdw=E_vdW_SP_coated_systems(H,a1,lambdaVDW,...
                    T1,T2,s1A1p2p,s1A12p,s1A1p2,s1A12,VDWmode);
                Fvdw=F_vdW_SP_coated_systems(H,a1,lambdaVDW,...
                    T1,T2,s1A1p2p,s1A12p,s1A1p2,s1A12,VDWmode);
            end
            %colloid-coated collector
            if VDWmode==2
                Evdw=E_vdW_SP_coated_systems(H,a1,lambdaVDW,...
                    T1,T2,0.0,s2A12p,0.0,s2A12,VDWmode);
                Fvdw=F_vdW_SP_coated_systems(H,a1,lambdaVDW,...
                    T1,T2,0.0,s2A12p,0.0,s2A12,VDWmode);
            end
            %coated colloid-collector
            if VDWmode==3
                Evdw=E_vdW_SP_coated_systems(H,a1,lambdaVDW,...
                    T1,T2,0.0,0.0,s3A1p2,s3A12,VDWmode);
                Fvdw=F_vdW_SP_coated_systems(H,a1,lambdaVDW,...
                    T1,T2,0.0,0.0,s3A1p2,s3A12,VDWmode);
            end
        else %not coated smooth
            %Evdw
            Evdw=E_vdW_SP_colloid_plate(H,A132,a1,lambdaVDW);
            Fvdw=F_vdW_SP_colloid_plate(H,A132,a1,lambdaVDW);
        end
        %EDL smooth
        Eedl =E_EDL_SP_colloid_plate(H,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetac,a1);
        Fedl =F_EDL_SP_colloid_plate(H,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetac,a1);
        if cbHET||cbHETUSER
            Eedlhet =E_EDL_SP_colloid_plate(H,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetahet,a1);
            Fedlhet =F_EDL_SP_colloid_plate(H,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetahet,a1);
        end
        %acid base smooth
        % determine ho for minimum (Eborn+Evdw) Energy
        [Emin,imin]=min(Eborn+Evdw);
        % hardwired ho for negative Hamaker constant
        if A132>0.0
            ho = H(imin);
        else
            ho = 1.58e-10;
        end
        Eab =E_AB_SP_colloid_plate(H,lambdaAB,a1,gammaAB,ho);
        Fab =F_AB_SP_colloid_plate(H,lambdaAB,a1,gammaAB,ho);
    else
        % Rmode1 = Rough Collector; rmode=2 Rough Colloid; Rmode=3 Rough Colloid and Collector;
        Evdw =E_vdW_SP_colloid_plate(H2,A132,a1,lambdaVDW)...
            + E_vdW_SP_RMODE(H,n,A132,aasp,a1,lambdaVDW,Rmode,Nco);
        Fvdw =F_vdW_SP_colloid_plate(H2,A132,a1,lambdaVDW)...
            + F_vdW_SP_RMODE(H,n,A132,aasp,a1,lambdaVDW,Rmode,Nco);
        % EDL rough
        Eedl =theta*E_EDL_SP_colloid_plate(H2,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetac,a1)...
            + E_EDL_SP_RMODE(H,n,epsilonW,K,kB,T,z,zetap,e_charge,zetac,aasp,a1,Rmode,Nco);
        Fedl =theta*F_EDL_SP_colloid_plate(H2,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetac,a1)...
            + F_EDL_SP_RMODE(H,n,epsilonW,K,kB,T,z,zetap,e_charge,zetac,aasp,a1,Rmode,Nco);
        if cbHET||cbHETUSER
            Eedlhet =theta*E_EDL_SP_colloid_plate(H2,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetahet,a1)...
                + E_EDL_SP_RMODE(H,n,epsilonW,K,kB,T,z,zetap,e_charge,zetahet,aasp,a1,Rmode,Nco);
            Fedlhet =theta*F_EDL_SP_colloid_plate(H2,1.0,epsilonW,K,kB,T,z,zetap,e_charge,zetahet,a1)...
                + F_EDL_SP_RMODE(H,n,epsilonW,K,kB,T,z,zetap,e_charge,zetahet,aasp,a1,Rmode,Nco);
        end
        % determine ho for minimum (Eborn+Evdw) Energy
        [Emin,imin]=min(Eborn+Evdw);
        % hardwired ho for negative Hamaker constant
        if A132>0.0
            ho = H(imin);
        else
            ho = 1.58e-10;
        end
        Eab =E_AB_SP_RMODE(H,lambdaAB,aasp,nAB,gammaAB,ho,Rmode,a1,Nco);
        Fab =F_AB_SP_RMODE(H,lambdaAB,aasp,nAB,gammaAB,ho,Rmode,a1,Nco);
    end
end
%% create dummy Eedlhet and Fedlhet vectors
if cbHET==0&&cbHETUSER==0
    Eedlhet = zeros(1,length(H));
    Fedlhet = zeros(1,length(H));
end
%% remove insignificant values (<abs(10e-30))
tol = 1e-30;
% Energy
Evdw(abs(Evdw)<tol)=0.0;
Eedl(abs(Eedl)<tol)=0.0;
Eedlhet(abs(Eedlhet)<tol)=0.0;
Eab(abs(Eab)<tol)=0.0;
Eborn(abs(Eborn)<tol)=0.0;
Este(abs(Este)<tol)=0.0;
% Force
Fvdw(abs(Fvdw)<tol)=0.0;
Fedl(abs(Fedl)<tol)=0.0;
Fedlhet(abs(Fedlhet)<tol)=0.0;
Fab(abs(Fab)<tol)=0.0;
Fborn(abs(Fborn)<tol)=0.0;
Fste(abs(Fste)<tol)=0.0;
%% calculate matrix for hetdomain influence
if cbHET||cbHETUSER
    for i=1:length(afvector)
        % calculate combined EDL energy and force
        EedlhetM(:,i) = (1-afvector(i))*Eedl+afvector(i)*Eedlhet;
        FedlhetM(:,i) = (1-afvector(i))*Fedl+afvector(i)*Fedlhet;
        EhetT(:,i) =  Evdw'+EedlhetM(:,i)+Eab'+Eborn'+Este';
        FhetT(:,i) =  Fvdw'+FedlhetM(:,i)+Fab'+Fborn'+Fste';
    end
    EhetT=EhetT*1/kt;
end




%% save to Energy matrix
EJ(:,1)=Evdw;
EJ(:,2)=Eedl;
EJ(:,3)=Eab;
EJ(:,4)=Eborn;
EJ(:,5)=Este;
% EJ(:,6)=Evdw+Eedl+Eab+Eborn+Este;
EJ(:,6)=Evdw+Eedl+Eab+Eborn+Este;
% calculate kt Energy matrix
Ekt=EJ*1/kt;
%% save to Force matrix
F(:,1)=Fvdw;
F(:,2)=Fedl;
F(:,3)=Fab;
F(:,4)=Fborn;
F(:,5)=Fste;
F(:,6)=Fvdw+Fedl+Fab+Fborn+Fste;
%% plot
% clear plot data
cla(handles.axesE)
cla(handles.axesF)
%make plot panel visible
set(handles.uipanelPLOTS,'Visible','on')
%set limits for y axis Ekt and force
limvekt= 1.5*abs(min(Ekt(:,6)));
limvf = 1.5*abs(min(F(:,6)));
% set max limit for x axis (nm)
hmaxdef = 100;
%set line width for axis
lw = 2;
%get separation distance in nm
Hnm = H/1.0e-9;

axes(handles.axesE);
plot (Hnm,Ekt(:,1),'-b','LineWidth',lw)
hold on;
plot (Hnm,Ekt(:,2),'-r','LineWidth',lw)
plot (Hnm,Ekt(:,3),'-g','LineWidth',lw)
plot (Hnm,Ekt(:,4),'-m','LineWidth',lw)
plot (Hnm,Ekt(:,5),'-','LineWidth',lw,'Color',[255/255 165/255 0])
plot (Hnm,Ekt(:,6),'--k','LineWidth',lw+0.5)
axis([0.0 hmaxdef -limvekt limvekt])
legend('van der Waals','EDL','Acid-Base','Born','Steric','Total')
xlabel('Separation Distance   (nm)');ylabel('Energy   (kT)');
set(axes,'Fontsize',40);
set(legend,'Fontsize',60);
hold off;
%
axes(handles.axesF);
plot (Hnm,F(:,1),'-b','LineWidth',lw)
hold on;
plot (Hnm,F(:,2),'-r','LineWidth',lw)
plot (Hnm,F(:,3),'-g','LineWidth',lw)
plot (Hnm,F(:,4),'-m','LineWidth',lw)
plot (Hnm,F(:,5),'-','LineWidth',lw,'Color',[255/255 165/255 0])
plot (Hnm,F(:,6),'--k','LineWidth',lw+0.5)
axis([0.0 hmaxdef/5 -limvf limvf])
legend('van der Waals','EDL','Acid-Base','Born','Steric','Total')
xlabel('Separation Distance   (nm)');ylabel('Force   (N)');
set(axes,'Fontsize',40);
set(legend,'Fontsize',60);
hold off;
%% set sliders properties (X axis)
%E
set(handles.sliderEx,'Min',1.0);
set(handles.sliderEx,'Max',max(Hnm));
set(handles.sliderEx,'Value',hmaxdef);
set(handles.Xemax,'String',num2str(hmaxdef));
%F
set(handles.sliderFx,'Min',1.0);
set(handles.sliderFx,'Max',max(Hnm));
set(handles.sliderFx,'Value',hmaxdef/5);
set(handles.Xfmax,'String',num2str(hmaxdef/5));
%% set Y axis values
set(handles.Yemax,'String',num2str(limvekt))
set(handles.Yemin,'String',num2str(-limvekt))
set(handles.Yfmax,'String',num2str(limvf))
set(handles.Yfmin,'String',num2str(-limvf))
%% plot hetdomain profiles if apply
if cbHET||cbHETUSER
    %     figure(2)
    %     h21=subplot(1,2,1);
    %     handles21 = guihandles(h21);
    %     guidata(h21,handles21);
    %     plot (Hnm,EhetT(:,1),'-r','LineWidth',lw)
    %     hold on;
    %     title('Heterodomain Afract')
    %     plot (Hnm,EhetT(:,2),'-m','LineWidth',lw)
    %     plot (Hnm,EhetT(:,3),'-','LineWidth',lw,'Color',[148/255 44/255 210/255])
    %     plot (Hnm,EhetT(:,4),'-b','LineWidth',lw)
    %     axis([0.0 hmaxdef -limvekt limvekt])
    %     legend('0.2 ZOI','0.4 ZOI','0.6 ZOI','0.8 ZOI')
    %     xlabel('Separation Distance   (nm)');ylabel('Energy   (kT)');
    %
    %     figure(2)
    %     h22=subplot(1,2,2);
    %     handles22 = guihandles(h22);
    %     guidata(h22,handles22);
    %     plot (Hnm,FhetT(:,1),'-r','LineWidth',lw)
    %     title('Rhet(nm)')
    %     hold on;
    %     plot (Hnm,FhetT(:,2),'-m','LineWidth',lw)
    %     plot (Hnm,FhetT(:,3),'-','LineWidth',lw,'Color',[148/255 44/255 210/255])
    %     plot (Hnm,FhetT(:,4),'-b','LineWidth',lw)
    %     axis([0.0 hmaxdef -limvf limvf])
    %     legend(num2str(rhetv(1)*1e9),num2str(rhetv(2)*1e9),num2str(rhetv(3)*1e9),num2str(rhetv(4)*1e9))
    %     xlabel('Separation Distance   (nm)');ylabel('Force   (N)');
    axes(handles.axesE);
    hold off
    plot (Hnm,EhetT(:,1),'-b','LineWidth',lw)
    hold on;
    plot (Hnm,EhetT(:,2),'-r','LineWidth',lw)
    plot (Hnm,EhetT(:,3),'-g','LineWidth',lw)
    plot (Hnm,EhetT(:,4),'-m','LineWidth',lw)
    plot (Hnm,Ekt(:,6),'--k','LineWidth',lw+0.5)
    axis([0.0 hmaxdef -limvekt limvekt])
    names = "rhet = " + string(rhetv) + " m   " + "AFRACT = " +string(afvector) + " ZOI" ;
    names = [names, "Mean Field"];
    legend(names)
    xlabel('Separation Distance   (nm)');ylabel('Total Energy   (kT)');
    set(axes,'Fontsize',40);
    set(legend,'Fontsize',60);
    hold off;
    %
    axes(handles.axesF);
    hold off
    plot (Hnm,FhetT(:,1),'-b','LineWidth',lw)
    hold on;
    plot (Hnm,FhetT(:,2),'-r','LineWidth',lw)
    plot (Hnm,FhetT(:,3),'-g','LineWidth',lw)
    plot (Hnm,FhetT(:,4),'-m','LineWidth',lw)
    plot (Hnm,F(:,6),'--k','LineWidth',lw+0.5)
    axis([0.0 hmaxdef/5 -limvf limvf])
    legend(names)
    xlabel('Separation Distance   (nm)');ylabel('Total Force   (N)');
    set(axes,'Fontsize',40);
    set(legend,'Fontsize',60);
    hold off;
    
    
end
%% enable set output directory button
Enable_pb_setdir = string(get(handles.pb_setdir,'Enable'));
if Enable_pb_setdir=="on"
    set(handles.savebutton,'Enable','on')
    set(handles.savebutton,'BackgroundColor',[0,1,1])
    set(handles.calculateButton,'BackgroundColor',[0,1,0])
else
    set(handles.pb_setdir,'Enable','on')
    set(handles.savebutton,'Enable','off')
end





function W132_Callback(hObject, eventdata, handles)
% hObject    handle to W132 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of W132 as text
%        str2double(get(hObject,'String')) returns contents of W132 as a double
global W132
W132 = str2double(get(hObject,'String' ));
set(handles.INDW132,'String',num2str(W132));


% --- Executes during object creation, after setting all properties.
function W132_CreateFcn(hObject, eventdata, handles)
% hObject    handle to W132 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ve_Callback(hObject, eventdata, handles)
% hObject    handle to ve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ve as text
%        str2double(get(hObject,'String')) returns contents of ve as a double
global ve
ve = str2double(get(hObject,'String' ));


% --- Executes during object creation, after setting all properties.
function ve_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e1_Callback(hObject, eventdata, handles)
% hObject    handle to e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e1 as text
%        str2double(get(hObject,'String')) returns contents of e1 as a double
global e1
e1 = str2double(get(hObject,'String' ));
% --- Executes during object creation, after setting all properties.

function e1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function n1_Callback(hObject, eventdata, handles)
% hObject    handle to n1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n1 as text
%        str2double(get(hObject,'String')) returns contents of n1 as a double
global n1
n1 = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function n1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    
end


function e2_Callback(hObject, eventdata, handles)
% hObject    handle to e2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e2 as text
%        str2double(get(hObject,'String')) returns contents of e2 as a double
global e2
e2 = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function e2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function n2_Callback(hObject, eventdata, handles)
% hObject    handle to n2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n2 as text
%        str2double(get(hObject,'String')) returns contents of n2 as a double
global n2
n2 = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function n2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function e3_Callback(hObject, eventdata, handles)
% hObject    handle to e3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of e3 as text
%        str2double(get(hObject,'String')) returns contents of e3 as a double
global e3
e3 = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function e3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function n3_Callback(hObject, eventdata, handles)
% hObject    handle to n3TEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n3TEXT as text
%        str2double(get(hObject,'String')) returns contents of n3TEXT as a double
global n3
n3 = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function n3TEXT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n3TEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




function A132calc_Callback(hObject, eventdata, handles)
% hObject    handle to A132calc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A132calc as text
%        str2double(get(hObject,'String')) returns contents of A132calc as a double
global A132calc
A132calc = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function A132calc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A132calc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calcA132.
function calcA132_Callback(hObject, eventdata, handles)

% hObject    handle to calcA132 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ve e1 n1 e2 n2 e3 n3 T kb hp
% Boltzmann constant J/K
kb =1.3806485E-23;
%Planck constant J.s
hp = 6.62607004E-34;
% get temperature value in Kelvin
T=str2double(get(handles.T,'String'))+273.15;
% get values from edit fields
ve=str2double(get(handles.ve,'String'));
e1=str2double(get(handles.e1,'String'));
n1=str2double(get(handles.n1,'String'));
e2=str2double(get(handles.e2,'String'));
n2=str2double(get(handles.n2,'String'));
e3=str2double(get(handles.e3,'String'));
n3=str2double(get(handles.n3,'String'));
% calculate Hamaker
cA132 = fcalcA132;
colh1 = [1  240/255 0];
% write value in calculated and main parameter field
set (handles.A132calc,'String',num2str(cA132));
set (handles.A132calc,'Enable','inactive');
set (handles.A132,'BackgroundColor',colh1);
set (handles.A132,'String',num2str(cA132));
set (handles.A132,'Enable','inactive');
%% enable/disable calculate profiles if all conditions apply
% initialize flag
calcFLAG = 1;
% get checkboxes values
cbCOATED = get(handles.cbCOATED,'Value');
cbA132 = get(handles.cbA132,'Value');
cbgammaAB = get(handles.cbgammaAB,'Value');
cbW132 = get(handles.cbW132,'Value');
cbacont = get(handles.cbacont,'Value');
% evaluate each checkbox
if cbCOATED+cbA132+cbgammaAB+cbW132+cbacont==0
    %enable
    calcFLAG =1;
else
    if cbA132==1
        if isnan(str2double(get(handles.A132calc,'String')))
            calcFLAG = 0;
        end
    end
    if cbgammaAB==1
        if isnan(str2double(get(handles.gammaABcalc,'String')))
            calcFLAG = 0;
        end
    end
    if cbW132==1
        if isnan(str2double(get(handles.W132calc,'String')))
            calcFLAG = 0;
        end
    end
    if cbacont==1
        if isnan(str2double(get(handles.acontCALC,'String')))
            calcFLAG = 0;
        end
    end
end
if calcFLAG ==1
    set(handles.calculateButton,'Enable','on')
else
    set(handles.calculateButton,'Enable','off')
end
%%

% --- Executes on button press in calcgammaAB.
function calcgammaAB_Callback(hObject, eventdata, handles)
% hObject    handle to calcgammaAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global g1pos g1neg g2pos g2neg g3pos g3neg
%get values
g1pos=str2double(get(handles.g1pos,'String'));
g1neg=str2double(get(handles.g1neg,'String'));
g2pos=str2double(get(handles.g2pos,'String'));
g2neg=str2double(get(handles.g2neg,'String'));
g3pos=str2double(get(handles.g3pos,'String'));
g3neg=str2double(get(handles.g3neg,'String'));
%calculate gammaAB
cgammaAB = fcalcgammaAB;
colh2 = [0.68 0.92 1];
% write value in calculated and main parameter field
set (handles.gammaABcalc,'String',num2str(cgammaAB));
set (handles.gammaABcalc,'Enable','inactive');
set (handles.gammaAB,'BackgroundColor',colh2);
set (handles.gammaAB,'String',num2str(cgammaAB));
set (handles.gammaAB,'Enable','inactive');
% set value to indicator field in W132 panel
set(handles.INDgammaAB,'String',num2str(cgammaAB));
set(handles.INDgammaAB,'Enable','inactive');
set (handles.INDgammaAB,'BackgroundColor',colh2);
%% enable/disable calculate profiles if all conditions apply
% initialize flag
calcFLAG = 1;
% get checkboxes values
cbCOATED = get(handles.cbCOATED,'Value');
cbA132 = get(handles.cbA132,'Value');
cbgammaAB = get(handles.cbgammaAB,'Value');
cbW132 = get(handles.cbW132,'Value');
cbacont = get(handles.cbacont,'Value');
% evaluate each checkbox
if cbCOATED+cbA132+cbgammaAB+cbW132+cbacont==0
    %enable
    calcFLAG =1;
else
    if cbA132==1
        if isnan(str2double(get(handles.A132calc,'String')))
            calcFLAG = 0;
        end
    end
    if cbgammaAB==1
        if isnan(str2double(get(handles.gammaABcalc,'String')))
            calcFLAG = 0;
        end
    end
    if cbW132==1
        if isnan(str2double(get(handles.W132calc,'String')))
            calcFLAG = 0;
        end
    end
    if cbacont==1
        if isnan(str2double(get(handles.acontCALC,'String')))
            calcFLAG = 0;
        end
    end
end
if calcFLAG ==1
    set(handles.calculateButton,'Enable','on')
else
    set(handles.calculateButton,'Enable','off')
end
%%

function gammaABcalc_Callback(hObject, eventdata, handles)
% hObject    handle to gammaABcalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function gammaABcalc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gammaABcalc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g3neg_Callback(hObject, eventdata, handles)
% hObject    handle to g3neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g3neg as text
%        str2double(get(hObject,'String')) returns contents of g3neg as a double
global g3neg
g3neg = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function g3neg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g3neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g3pos_Callback(hObject, eventdata, handles)
% hObject    handle to g3pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g3pos as text
%        str2double(get(hObject,'String')) returns contents of g3pos as a double
global g3pos
g3pos = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function g3pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g3pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g2neg_Callback(hObject, eventdata, handles)
% hObject    handle to g2neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g2neg as text
%        str2double(get(hObject,'String')) returns contents of g2neg as a double
global g2neg
g2neg = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function g2neg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g2neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g2pos_Callback(hObject, eventdata, handles)
% hObject    handle to g2pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g2pos as text
%        str2double(get(hObject,'String')) returns contents of g2pos as a double
global g2pos
g2pos = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function g2pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g2pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g1neg_Callback(hObject, eventdata, handles)
% hObject    handle to g1neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g1neg as text
%        str2double(get(hObject,'String')) returns contents of g1neg as a double
global g1neg
g1neg = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function g1neg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g1neg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g1pos_Callback(hObject, eventdata, handles)
% hObject    handle to g1pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g1pos as text
%        str2double(get(hObject,'String')) returns contents of g1pos as a double
global g1pos
g1pos = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function g1pos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g1pos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g1LW_Callback(hObject, eventdata, handles)
% hObject    handle to g1LW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g1LW as text
%        str2double(get(hObject,'String')) returns contents of g1LW as a double


% --- Executes during object creation, after setting all properties.
function g1LW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g1LW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g2LW_Callback(hObject, eventdata, handles)
% hObject    handle to g2LW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g2LW as text
%        str2double(get(hObject,'String')) returns contents of g2LW as a double


% --- Executes during object creation, after setting all properties.
function g2LW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g2LW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g3LW_Callback(hObject, eventdata, handles)
% hObject    handle to g3LW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g3LW as text
%        str2double(get(hObject,'String')) returns contents of g3LW as a double


% --- Executes during object creation, after setting all properties.
function g3LW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g3LW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function g0ab_Callback(hObject, eventdata, handles)
% hObject    handle to g0ab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of g0ab as text
%        str2double(get(hObject,'String')) returns contents of g0ab as a double


% --- Executes during object creation, after setting all properties.
function g0ab_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g0ab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit39_Callback(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit39 as text
%        str2double(get(hObject,'String')) returns contents of edit39 as a double


% --- Executes during object creation, after setting all properties.
function edit39_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit39 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit38_Callback(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit38 as text
%        str2double(get(hObject,'String')) returns contents of edit38 as a double


% --- Executes during object creation, after setting all properties.
function edit38_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function W132calc_Callback(hObject, eventdata, handles)
% hObject    handle to W132calc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of W132calc as text
%        str2double(get(hObject,'String')) returns contents of W132calc as a double


% --- Executes during object creation, after setting all properties.
function W132calc_CreateFcn(hObject, eventdata, handles)
% hObject    handle to W132calc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in calcW132.
function calcW132_Callback(hObject, eventdata, handles)
% hObject    handle to calcW132 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global g1LW g2LW g3LW gammaAB
%get values
g1LW=str2double(get(handles.g1LW,'String'));
g2LW=str2double(get(handles.g2LW,'String'));
g3LW=str2double(get(handles.g3LW,'String'));
gammaAB=str2double(get(handles.gammaAB,'String'));

%calculate W132
cW132 = fcalcW132;
colh3 = 1/255*[255 100 100];
% write value in calculated and main parameter field
set(handles.W132calc,'String',num2str(cW132));
set(handles.W132calc,'Enable','inactive');
set(handles.W132,'BackgroundColor',colh3);
set(handles.W132,'String',num2str(cW132));
set(handles.W132,'Enable','inactive');
% set value to indicator field in W132 panel
set(handles.INDW132,'String',num2str(cW132));
set(handles.INDW132,'BackgroundColor',colh3);
set(handles.INDW132,'Enable','inactive');
%% enable/disable calculate profiles if all conditions apply
% initialize flag
calcFLAG = 1;
% get checkboxes values
cbCOATED = get(handles.cbCOATED,'Value');
cbA132 = get(handles.cbA132,'Value');
cbgammaAB = get(handles.cbgammaAB,'Value');
cbW132 = get(handles.cbW132,'Value');
cbacont = get(handles.cbacont,'Value');
% evaluate each checkbox
if cbCOATED+cbA132+cbgammaAB+cbW132+cbacont==0
    %enable
    calcFLAG =1;
else
    if cbA132==1
        if isnan(str2double(get(handles.A132calc,'String')))
            calcFLAG = 0;
        end
    end
    if cbgammaAB==1
        if isnan(str2double(get(handles.gammaABcalc,'String')))
            calcFLAG = 0;
        end
    end
    if cbW132==1
        if isnan(str2double(get(handles.W132calc,'String')))
            calcFLAG = 0;
        end
    end
    if cbacont==1
        if isnan(str2double(get(handles.acontCALC,'String')))
            calcFLAG = 0;
        end
    end
end
if calcFLAG ==1
    set(handles.calculateButton,'Enable','on')
else
    set(handles.calculateButton,'Enable','off')
end
%%


function INDgammaAB_Callback(hObject, eventdata, handles)
% hObject    handle to INDgammaAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INDgammaAB as text
%        str2double(get(hObject,'String')) returns contents of INDgammaAB as a double


% --- Executes during object creation, after setting all properties.
function INDgammaAB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INDgammaAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pbCOATED.
function pbCOATED_Callback(hObject, eventdata, handles)
% hObject    handle to pbCOATED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% toggle coating system panel visibility
%% maybe useful code for later on
% x=get(handles.uipanelCOATED,'visible');
% if strcmp(x,'on')
%     set(handles.uipanelCOATED,'visible','off')
% %     set(handles.pbCOATED,'BackgroundColor','green')
% else
%     set(handles.uipanelCOATED,'visible','on')
% %     set(handles.pbCOATED,'BackgroundColor','red')
% end
%% open panel and deactivate itself
set(handles.uipanelCOATED,'visible','on')
set(handles.pbCOATED,'Enable','inactive')


% --- Executes during object creation, after setting all properties.
function uipanelCOATED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanelCOATED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in cbA132.
function cbA132_Callback(hObject, eventdata, handles)
% hObject    handle to cbA132 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbA132
cbA132=get(hObject,'Value');
% colh1 = [0.68 0.92 1];
colh1 = [1 240/255 0];
colr = [0.94 0.94 0.94];
if cbA132
    %disable calculate profiles
    set(handles.calculateButton,'Enable','off')
    % highlight panel
    set(handles.uipanelA132,'BackgroundColor',colh1')
    % enable edit text fields
    set(handles.ve,'Enable','on')
    set(handles.e1,'Enable','on')
    set(handles.n1,'Enable','on')
    set(handles.e2,'Enable','on')
    set(handles.n2,'Enable','on')
    set(handles.e3,'Enable','on')
    set(handles.n3,'Enable','on')
    % highlight static text
    set(handles.veTEXT,'BackgroundColor',colh1)
    set(handles.e1TEXT,'BackgroundColor',colh1)
    set(handles.n1TEXT,'BackgroundColor',colh1)
    set(handles.e2TEXT,'BackgroundColor',colh1)
    set(handles.n2TEXT,'BackgroundColor',colh1)
    set(handles.e3TEXT,'BackgroundColor',colh1)
    set(handles.n3TEXT,'BackgroundColor',colh1)
    set(handles.A132TEXT,'BackgroundColor',colh1)
    %enable calcA132 and pbCOATED buttons
    set(handles.calcA132,'Enable','on')
    set(handles.pbCOATED,'Enable','on')
    %deactivate manual input
    set (handles.A132,'Enable','inactive');
else
    
    % reset Hamaker from fundamentals panel
    set(handles.uipanelA132,'BackgroundColor',colr)
    % disable edit text fields
    set(handles.ve,'Enable','off')
    set(handles.e1,'Enable','off')
    set(handles.n1,'Enable','off')
    set(handles.e2,'Enable','off')
    set(handles.n2,'Enable','off')
    set(handles.e3,'Enable','off')
    set(handles.n3,'Enable','off')
    % reset static text
    set(handles.veTEXT,'BackgroundColor',colr)
    set(handles.e1TEXT,'BackgroundColor',colr)
    set(handles.n1TEXT,'BackgroundColor',colr)
    set(handles.e2TEXT,'BackgroundColor',colr)
    set(handles.n2TEXT,'BackgroundColor',colr)
    set(handles.e3TEXT,'BackgroundColor',colr)
    set(handles.n3TEXT,'BackgroundColor',colr)
    set(handles.A132TEXT,'BackgroundColor',colr)
    %disable calcA132 and pbCOATED buttons
    set(handles.calcA132,'Enable','off')
    set(handles.pbCOATED,'Enable','off')
    %activate manual input
    set (handles.A132,'Enable','on');
    set (handles.A132,'BackgroundColor','white');
    %deactivate calculated edit
    set (handles.A132calc,'Enable','off');
    set (handles.A132calc,'String','calculate');
    set (handles.A132,'BackgroundColor','white');
    %% enable/disable calculate profiles if all conditions apply
    % initialize flag
    calcFLAG = 1;
    % get checkboxes values
    cbCOATED = get(handles.cbCOATED,'Value');
    cbA132 = get(handles.cbA132,'Value');
    cbgammaAB = get(handles.cbgammaAB,'Value');
    cbW132 = get(handles.cbW132,'Value');
    cbacont = get(handles.cbacont,'Value');
    % evaluate each checkbox
    if cbCOATED+cbA132+cbgammaAB+cbW132+cbacont==0
        %enable
        calcFLAG =1;
    else
        if cbA132==1
            if isnan(str2double(get(handles.A132calc,'String')))
                calcFLAG = 0;
            end
        end
        if cbgammaAB==1
            if isnan(str2double(get(handles.gammaABcalc,'String')))
                calcFLAG = 0;
            end
        end
        if cbW132==1
            if isnan(str2double(get(handles.W132calc,'String')))
                calcFLAG = 0;
            end
        end
        if cbacont==1
            if isnan(str2double(get(handles.acontCALC,'String')))
                calcFLAG = 0;
            end
        end
    end
    if calcFLAG ==1
        set(handles.calculateButton,'Enable','on')
    else
        set(handles.calculateButton,'Enable','off')
    end
    %%
end

% --- Executes on button press in cbW132.
function cbW132_Callback(hObject, eventdata, handles)
% hObject    handle to cbW132 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbW132
cbW132=get(hObject,'Value');
colh3 = 1/255*[255 100 100];
colr = [0.94 0.94 0.94];
if cbW132
    %disable calculate profiles
    set(handles.calculateButton,'Enable','off')
    % highlight panel
    set(handles.uipanelW132,'BackgroundColor',colh3')
    % enable edit text fields
    set(handles.g1LW,'Enable','on')
    set(handles.g2LW,'Enable','on')
    set(handles.g3LW,'Enable','on')
    % highlight static text
    set(handles.g1LWTEXT,'BackgroundColor',colh3)
    set(handles.g2LWTEXT,'BackgroundColor',colh3)
    set(handles.g3LWTEXT,'BackgroundColor',colh3)
    set(handles.INDgammaABTEXT,'BackgroundColor',colh3)
    set(handles.W132calcTEXT,'BackgroundColor',colh3)
    %enable calcgammaAB button
    set(handles.calcW132,'Enable','on')
    %deactivate manual input
    set (handles.W132,'Enable','inactive');
else
    % reset panel
    set(handles.uipanelW132,'BackgroundColor',colr)
    % disable edit text fields
    set(handles.g1LW,'Enable','off')
    set(handles.g2LW,'Enable','off')
    set(handles.g3LW,'Enable','off')
    set(handles.INDgammaAB,'Enable','off')
    % resete static text
    set(handles.g1LWTEXT,'BackgroundColor',colr)
    set(handles.g2LWTEXT,'BackgroundColor',colr)
    set(handles.g3LWTEXT,'BackgroundColor',colr)
    set(handles.INDgammaABTEXT,'BackgroundColor',colr)
    set(handles.W132calcTEXT,'BackgroundColor',colr)
    set(handles.INDW132,'Enable','off')
    set(handles.INDW132,'BackgroundColor',colr)
    %disable calcgammaAB button
    set(handles.calcW132,'Enable','off')
    %activate manual input
    set (handles.W132,'Enable','on');
    set (handles.W132,'BackgroundColor','white');
    %deactivate calculated edit
    set (handles.W132calc,'Enable','off');
    set (handles.W132calc,'String','calculate');
    %enable calculate profiles
    set(handles.calculateButton,'Enable','on')
    %% enable/disable calculate profiles if all conditions apply
    % initialize flag
    calcFLAG = 1;
    % get checkboxes values
    cbCOATED = get(handles.cbCOATED,'Value');
    cbA132 = get(handles.cbA132,'Value');
    cbgammaAB = get(handles.cbgammaAB,'Value');
    cbW132 = get(handles.cbW132,'Value');
    cbacont = get(handles.cbacont,'Value');
    % evaluate each checkbox
    if cbCOATED+cbA132+cbgammaAB+cbW132+cbacont==0
        %enable
        calcFLAG =1;
    else
        if cbA132==1
            if isnan(str2double(get(handles.A132calc,'String')))
                calcFLAG = 0;
            end
        end
        if cbgammaAB==1
            if isnan(str2double(get(handles.gammaABcalc,'String')))
                calcFLAG = 0;
            end
        end
        if cbW132==1
            if isnan(str2double(get(handles.W132calc,'String')))
                calcFLAG = 0;
            end
        end
        if cbacont==1
            if isnan(str2double(get(handles.acontCALC,'String')))
                calcFLAG = 0;
            end
        end
    end
    if calcFLAG ==1
        set(handles.calculateButton,'Enable','on')
    else
        set(handles.calculateButton,'Enable','off')
    end
    %%
end

% --- Executes on button press in cbgammaAB.
function cbgammaAB_Callback(hObject, eventdata, handles)
% hObject    handle to cbgammaAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbgammaAB
cbgammaAB=get(hObject,'Value');
colh2 = [0.68 0.92 1];
colr = [0.94 0.94 0.94];
if cbgammaAB
    %disable calculate profiles
    set(handles.calculateButton,'Enable','off')
    % highlight panel
    set(handles.uipanelgammaAB,'BackgroundColor',colh2')
    % enable edit text fields
    set(handles.g1pos,'Enable','on')
    set(handles.g1neg,'Enable','on')
    set(handles.g2pos,'Enable','on')
    set(handles.g2neg,'Enable','on')
    set(handles.g3pos,'Enable','on')
    set(handles.g3neg,'Enable','on')
    % highlight static text
    set(handles.g1posTEXT,'BackgroundColor',colh2)
    set(handles.g1negTEXT,'BackgroundColor',colh2)
    set(handles.g2posTEXT,'BackgroundColor',colh2)
    set(handles.g2negTEXT,'BackgroundColor',colh2)
    set(handles.g3posTEXT,'BackgroundColor',colh2)
    set(handles.g3negTEXT,'BackgroundColor',colh2)
    set(handles.gammaABTEXT,'BackgroundColor',colh2)
    %enable calcgammaAB button
    set(handles.calcgammaAB,'Enable','on')
    %deactivate manual input
    set (handles.gammaAB,'Enable','inactive');
else
    % reset panel
    set(handles.uipanelgammaAB,'BackgroundColor',colr)
    % disable edit text fields
    set(handles.g1pos,'Enable','off')
    set(handles.g1neg,'Enable','off')
    set(handles.g2pos,'Enable','off')
    set(handles.g2neg,'Enable','off')
    set(handles.g3pos,'Enable','off')
    set(handles.g3neg,'Enable','off')
    set(handles.n3,'Enable','off')
    % reset static text
    set(handles.g1posTEXT,'BackgroundColor',colr)
    set(handles.g1negTEXT,'BackgroundColor',colr)
    set(handles.g2posTEXT,'BackgroundColor',colr)
    set(handles.g2negTEXT,'BackgroundColor',colr)
    set(handles.g3posTEXT,'BackgroundColor',colr)
    set(handles.g3negTEXT,'BackgroundColor',colr)
    set(handles.gammaABTEXT,'BackgroundColor',colr)
    %disable calcgammaAB button
    set(handles.calcgammaAB,'Enable','off')
    %activate manual input
    set (handles.gammaAB,'Enable','on');
    set (handles.gammaAB,'BackgroundColor','white');
    %deactivate calculated edit
    set (handles.gammaABcalc,'Enable','off');
    set (handles.gammaABcalc,'String','calculate');
    %deactivate indicator in W132 panel
    set(handles.INDgammaAB,'Enable','off');
    set (handles.INDgammaAB,'BackgroundColor','white');
    %enable calculate profiles
    set(handles.calculateButton,'Enable','on')
    %% enable/disable calculate profiles if all conditions apply
    % initialize flag
    calcFLAG = 1;
    % get checkboxes values
    cbCOATED = get(handles.cbCOATED,'Value');
    cbA132 = get(handles.cbA132,'Value');
    cbgammaAB = get(handles.cbgammaAB,'Value');
    cbW132 = get(handles.cbW132,'Value');
    cbacont = get(handles.cbacont,'Value');
    % evaluate each checkbox
    if cbCOATED+cbA132+cbgammaAB+cbW132+cbacont==0
        %enable
        calcFLAG =1;
    else
        if cbA132==1
            if isnan(str2double(get(handles.A132calc,'String')))
                calcFLAG = 0;
            end
        end
        if cbgammaAB==1
            if isnan(str2double(get(handles.gammaABcalc,'String')))
                calcFLAG = 0;
            end
        end
        if cbW132==1
            if isnan(str2double(get(handles.W132calc,'String')))
                calcFLAG = 0;
            end
        end
        if cbacont==1
            if isnan(str2double(get(handles.acontCALC,'String')))
                calcFLAG = 0;
            end
        end
    end
    if calcFLAG ==1
        set(handles.calculateButton,'Enable','on')
    else
        set(handles.calculateButton,'Enable','off')
    end
    %%
end

% --- Executes on button press in cbRmode0.
function cbRmode0_Callback(hObject, eventdata, handles)
global RMODE atemp
% hObject    handle to cbRmode0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colr =[0.94 0.94 0.94];
% Hint: get(hObject,'Value') returns toggle state of cbRmode0
cb=get(handles.cbRmode0,'Value');
if cb
    RMODE = 0;
    set (handles.cbRmode1,'Value',0)
    set (handles.cbRmode2,'Value',0)
    set (handles.cbRmode3,'Value',0)
    %reset color smooth surfaces (in case coating warning happened)
    set(handles.cbRmode1,'BackgroundColor',colr);
    set(handles.cbRmode2,'BackgroundColor',colr);
    set(handles.cbRmode3,'BackgroundColor',colr);
    % highlight to green
    set(handles.cbRmode0,'BackgroundColor','g');
    %reset asperty height value
    set(handles.aasp,'String','0.0');
else
    RMODE = 1;
    set (handles.cbRmode1,'Value',1)
    set (handles.cbRmode1,'BackgroundColor','g')
    %reset color smooth surfaces (in case coating warning happened)
    set(handles.cbRmode0,'BackgroundColor',colr);
    % save Hamaker if numerical value exist
    %% check coated system status
    %save hamaker value
    if isnan(str2double(get(handles.A132,'String')))
    else
        atemp = get(handles.A132,'String');
    end
    %check if coated system is selected, then reset to uncoated
    if get(handles.cbCOATED,'Value')
        % reset value coating
        set(handles.cbCOATED,'Value',0);
        set(handles.cbCOATED,'ForegroundColor','r');
        % reset Hamaker value and enable Hamaker checkbox from fundamentals
        set(handles.A132,'String',atemp);
        set(handles.cbA132,'Enable','on');
        % alert user with message
        msg_cancel_coating_roughness
    end
    %%
    %check if asperity height is zero, reset ro 15 nm
    aasp = str2double(get(handles.aasp,'String'));
    if aasp < 5.0e-9
        % reset value and alert user
        msg_set_asperity
        set(handles.aasp,'String','1.50e-8')
    end
    %%
end

% --- Executes on button press in cbRmode2.
function cbRmode2_Callback(hObject, eventdata, handles)
global RMODE atemp
% hObject    handle to cbRmode2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colr = [0.94 0.94 0.94];
% Hint: get(hObject,'Value') returns toggle state of cbRmode2
cb=get(hObject,'Value');
if cb
    RMODE = 2;
    set (handles.cbRmode0,'Value',0)
    set (handles.cbRmode1,'Value',0)
    set (handles.cbRmode3,'Value',0)
    %reset color smooth surfaces (in case coating warning happened)
    set(handles.cbRmode0,'BackgroundColor',colr);
    set(handles.cbRmode1,'BackgroundColor',colr);
    set(handles.cbRmode3,'BackgroundColor',colr);
    % highlight to green
    set(handles.cbRmode2,'BackgroundColor','g');
    %% check coated sytstem status
    %save hamaker value
    if isnan(str2double(get(handles.A132,'String')))
    else
        atemp = get(handles.A132,'String');
    end
    %check if coated system is selected, then reset to uncoated
    if get(handles.cbCOATED,'Value')
        % reset value coating
        set(handles.cbCOATED,'Value',0);
        set(handles.cbCOATED,'ForegroundColor','r');
        % reset Hamaker value and enable Hamaker checkbox from fundamentals
        set(handles.A132,'String',atemp);
        set(handles.cbA132,'Enable','on');
        % alert user with message
        msg_cancel_coating_roughness
    end
    %%
    %check if asperity height is zero, reset ro 10 nm
    aasp = str2double(get(handles.aasp,'String'));
    if aasp < 5.0e-9
        % reset value and alert user
        msg_set_asperity
        set(handles.aasp,'String','1.0e-8')
    end
    % hide coating panel
    set(handles.uipanelCOATED,'Visible','off')
    % activate profile calculation
    set(handles.calculateButton,'Enable','on')
else
    RMODE = 0;
    set (handles.cbRmode0,'Value',1)
    set(handles.cbRmode0,'BackgroundColor','g');
    %reset color smooth surfaces (in case coating warning happened)
    set(handles.cbRmode0,'ForegroundColor','k');
    set(handles.cbRmode2,'BackgroundColor',colr);
    %reset asperty height value
    set(handles.aasp,'String','0.0');
end

% --- Executes on button press in cbRmode1.
function cbRmode1_Callback(hObject, eventdata, handles)
global RMODE atemp
% hObject    handle to cbRmode0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colr =[0.94 0.94 0.94];
% Hint: get(hObject,'Value') returns toggle state of cbRmode0
cb=get(hObject,'Value');
if cb
    RMODE = 1;
    set (handles.cbRmode0,'Value',0)
    set (handles.cbRmode2,'Value',0)
    set (handles.cbRmode3,'Value',0)
    %reset color smooth surfaces (in case coating warning happened)
    set(handles.cbRmode0,'BackgroundColor',colr);
    set(handles.cbRmode2,'BackgroundColor',colr);
    set(handles.cbRmode3,'BackgroundColor',colr);
    % highlight to green
    set(handles.cbRmode1,'BackgroundColor','g');
    %% check coated system status
    %save hamaker value
    if isnan(str2double(get(handles.A132,'String')))
    else
        atemp = get(handles.A132,'String');
    end
    %check if coated system is selected, then reset to uncoated
    if get(handles.cbCOATED,'Value')
        % reset value coating
        set(handles.cbCOATED,'Value',0);
        set(handles.cbCOATED,'ForegroundColor','r');
        % reset Hamaker value and enable Hamaker checkbox from fundamentals
        set(handles.A132,'String',atemp);
        set(handles.cbA132,'Enable','on');
        % alert user with message
        msg_cancel_coating_roughness
    end
    %%
    %check if asperity height is zero, reset ro 10 nm
    aasp = str2double(get(handles.aasp,'String'));
    if aasp < 5.0e-9
        % reset value and alert user
        msg_set_asperity
        set(handles.aasp,'String','1.0e-8')
    end
    % hide coating panel
    set(handles.uipanelCOATED,'Visible','off')
    % activate profile calculation
    set(handles.calculateButton,'Enable','on')
else
    RMODE = 0;
    set (handles.cbRmode0,'Value',1)
    set(handles.cbRmode0,'BackgroundColor','g');
    %reset color smooth surfaces (in case coating warning happened)
    set(handles.cbRmode0,'ForegroundColor','k');
    set(handles.cbRmode1,'BackgroundColor',colr);
    %reset asperty height value
    set(handles.aasp,'String','0.0');
end



% --- Executes on button press in cbRmode3.
function cbRmode3_Callback(hObject, eventdata, handles)
global RMODE atemp
% hObject    handle to cbRmode0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colr = [0.94 0.94 0.94];
% Hint: get(hObject,'Value') returns toggle state of cbRmode0
cb=get(hObject,'Value');
if cb
    RMODE = 3;
    set (handles.cbRmode0,'Value',0)
    set (handles.cbRmode1,'Value',0)
    set (handles.cbRmode2,'Value',0)
    %reset color smooth surfaces (in case coating warning happened)
    set(handles.cbRmode0,'BackgroundColor',colr);
    set(handles.cbRmode1,'BackgroundColor',colr);
    set(handles.cbRmode2,'BackgroundColor',colr);
    % highlight to green
    set(handles.cbRmode3,'BackgroundColor','g');
    %% check coated sytstem status
    %save hamaker value
    if isnan(str2double(get(handles.A132,'String')))
    else
        atemp = get(handles.A132,'String');
    end
    %check if coated system is selected, then reset to uncoated
    if get(handles.cbCOATED,'Value')
        % reset value coating
        set(handles.cbCOATED,'Value',0);
        set(handles.cbCOATED,'ForegroundColor','r');
        % reset Hamaker value and enable Hamaker checkbox from fundamentals
        set(handles.A132,'String',atemp);
        set(handles.cbA132,'Enable','on');
        % alert user with message
        msg_cancel_coating_roughness
    end
    %%
    %check if asperity height is zero, reset ro 10 nm
    aasp = str2double(get(handles.aasp,'String'));
    if aasp < 5.0e-9
        % reset value and alert user
        msg_set_asperity
        set(handles.aasp,'String','1.0e-8')
    end
    % hide coating panel
    set(handles.uipanelCOATED,'Visible','off')
    % activate profile calculation
    set(handles.calculateButton,'Enable','on')
else
    RMODE = 0;
    set (handles.cbRmode0,'Value',1)
    set(handles.cbRmode0,'BackgroundColor','g');
    set(handles.cbRmode3,'BackgroundColor',colr);
    %reset asperty height value
    set(handles.aasp,'String','0.0');
end


% --- Executes during object creation, after setting all properties.
function n3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function veTEXT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to veTEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function e1TEXT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e1TEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function n1TEXT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n1TEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function e2TEXT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e2TEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function n2TEXT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n2TEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function e3TEXT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to e3TEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function INDgammaABTEXT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INDgammaABTEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function g3LWTEXT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g3LWTEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function W132calcTEXT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to W132calcTEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in CALCacont.
function CALCacont_Callback(hObject, eventdata, handles)
% hObject    handle to CALCacont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global E1 v1 E2 v2 W132 a1
%get values
E1=str2double(get(handles.E1,'String'));
v1=str2double(get(handles.v1,'String'));
E2=str2double(get(handles.E2,'String'));
v2=str2double(get(handles.v2,'String'));
W132=str2double(get(handles.W132,'String'));
a1=str2double(get(handles.a1,'String'));

%calculate acont
[cacont,Kint] = fcalcacont;
colh4 = 1/255*[200 250 200];
% write value in calculated and main parameter field
set (handles.acontCALC,'String',num2str(cacont));
set (handles.Kint,'String',num2str(Kint,'%5.2e\n'));
set (handles.acontCALC,'Enable','inactive');
set (handles.Kint,'Enable','inactive');
set (handles.acont,'BackgroundColor',colh4);
set (handles.acont,'String',num2str(cacont));
set (handles.W132,'Enable','inactive');
%% enable/disable calculate profiles if all conditions apply
% initialize flag
calcFLAG = 1;
% get checkboxes values
cbCOATED = get(handles.cbCOATED,'Value');
cbA132 = get(handles.cbA132,'Value');
cbgammaAB = get(handles.cbgammaAB,'Value');
cbW132 = get(handles.cbW132,'Value');
cbacont = get(handles.cbacont,'Value');
% evaluate each checkbox
if cbCOATED+cbA132+cbgammaAB+cbW132+cbacont==0
    %enable
    calcFLAG =1;
else
    if cbA132==1
        if isnan(str2double(get(handles.A132calc,'String')))
            calcFLAG = 0;
        end
    end
    if cbgammaAB==1
        if isnan(str2double(get(handles.gammaABcalc,'String')))
            calcFLAG = 0;
        end
    end
    if cbW132==1
        if isnan(str2double(get(handles.W132calc,'String')))
            calcFLAG = 0;
        end
    end
    if cbacont==1
        if isnan(str2double(get(handles.acontCALC,'String')))
            calcFLAG = 0;
        end
    end
end
if calcFLAG ==1
    set(handles.calculateButton,'Enable','on')
else
    set(handles.calculateButton,'Enable','off')
end
%%



function acontCALC_Callback(hObject, eventdata, handles)
% hObject    handle to acontCALC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of acontCALC as text
%        str2double(get(hObject,'String')) returns contents of acontCALC as a double


% --- Executes during object creation, after setting all properties.
function acontCALC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to acontCALC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Kint_Callback(hObject, eventdata, handles)
% hObject    handle to Kint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Kint as text
%        str2double(get(hObject,'String')) returns contents of Kint as a double


% --- Executes during object creation, after setting all properties.
function Kint_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Kint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit53_Callback(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit53 as text
%        str2double(get(hObject,'String')) returns contents of edit53 as a double


% --- Executes during object creation, after setting all properties.
function edit53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function INDW132_Callback(hObject, eventdata, handles)
% hObject    handle to INDW132 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of INDW132 as text
%        str2double(get(hObject,'String')) returns contents of INDW132 as a double


% --- Executes during object creation, after setting all properties.
function INDW132_CreateFcn(hObject, eventdata, handles)
% hObject    handle to INDW132 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function v2_Callback(hObject, eventdata, handles)
% hObject    handle to v2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v2 as text
%        str2double(get(hObject,'String')) returns contents of v2 as a double


% --- Executes during object creation, after setting all properties.
function v2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function E2_Callback(hObject, eventdata, handles)
% hObject    handle to E2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of E2 as text
%        str2double(get(hObject,'String')) returns contents of E2 as a double


% --- Executes during object creation, after setting all properties.
function E2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to E2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function v1_Callback(hObject, eventdata, handles)
% hObject    handle to v1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of v1 as text
%        str2double(get(hObject,'String')) returns contents of v1 as a double


% --- Executes during object creation, after setting all properties.
function v1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to v1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function E1_Callback(hObject, eventdata, handles)
% hObject    handle to E1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of E1 as text
%        str2double(get(hObject,'String')) returns contents of E1 as a double


% --- Executes during object creation, after setting all properties.
function E1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to E1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbacont.
function cbacont_Callback(hObject, eventdata, handles)
% hObject    handle to cbacont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbacont
cbacont=get(hObject,'Value');
colh4 = 1/255*[200 250 200];
colr = [0.94 0.94 0.94];
if cbacont
    %disable calculate profiles
    set(handles.calculateButton,'Enable','off')
    % highlight panel
    set(handles.uipanelacont,'BackgroundColor',colh4')
    % enable edit text fields
    set(handles.E1,'Enable','on')
    set(handles.v1,'Enable','on')
    set(handles.E2,'Enable','on')
    set(handles.v2,'Enable','on')
    %     set(handles.INDgammaAB,'Enable','inactive')
    % highlight static text
    set(handles.E1TEXT,'BackgroundColor',colh4)
    set(handles.v1TEXT,'BackgroundColor',colh4)
    set(handles.E2TEXT,'BackgroundColor',colh4)
    set(handles.v2TEXT,'BackgroundColor',colh4)
    set(handles.INDW132TEXT,'BackgroundColor',colh4)
    set(handles.KintTEXT,'BackgroundColor',colh4)
    set(handles.acontCALCTEXT,'BackgroundColor',colh4)
    %enable calcgammaAB button
    set(handles.CALCacont,'Enable','on')
    %deactivate manual input
    set (handles.acont,'Enable','inactive');
else
    % reset panel
    set(handles.uipanelacont,'BackgroundColor',colr)
    % disable edit text fields
    set(handles.E1,'Enable','of')
    set(handles.v1,'Enable','of')
    set(handles.E2,'Enable','of')
    set(handles.v2,'Enable','of')
    % resete static text
    set(handles.E1TEXT,'BackgroundColor',colr)
    set(handles.v1TEXT,'BackgroundColor',colr)
    set(handles.E2TEXT,'BackgroundColor',colr)
    set(handles.v2TEXT,'BackgroundColor',colr)
    set(handles.INDW132TEXT,'BackgroundColor',colr)
    set(handles.KintTEXT,'BackgroundColor',colr)
    set(handles.acontCALCTEXT,'BackgroundColor',colr)
    set(handles.INDW132,'Enable','off')
    %disable calcgammaAB button
    set(handles.CALCacont,'Enable','off')
    %activate manual input
    set (handles.acont,'Enable','on');
    set (handles.acont,'BackgroundColor','white');
    %deactivate calculated edit
    set (handles.Kint,'Enable','off');
    set (handles.Kint,'String','calculate');
    set (handles.acontCALC,'Enable','off');
    set (handles.acontCALC,'String','calculate');
    %enable calculate profiles
    set(handles.calculateButton,'Enable','on')
    %% enable/disable calculate profiles if all conditions apply
    % initialize flag
    calcFLAG = 1;
    % get checkboxes values
    cbCOATED = get(handles.cbCOATED,'Value');
    cbA132 = get(handles.cbA132,'Value');
    cbgammaAB = get(handles.cbgammaAB,'Value');
    cbW132 = get(handles.cbW132,'Value');
    cbacont = get(handles.cbacont,'Value');
    % evaluate each checkbox
    if cbCOATED+cbA132+cbgammaAB+cbW132+cbacont==0
        %enable
        calcFLAG =1;
    else
        if cbA132==1
            if isnan(str2double(get(handles.A132calc,'String')))
                calcFLAG = 0;
            end
        end
        if cbgammaAB==1
            if isnan(str2double(get(handles.gammaABcalc,'String')))
                calcFLAG = 0;
            end
        end
        if cbW132==1
            if isnan(str2double(get(handles.W132calc,'String')))
                calcFLAG = 0;
            end
        end
        if cbacont==1
            if isnan(str2double(get(handles.acontCALC,'String')))
                calcFLAG = 0;
            end
        end
    end
    if calcFLAG ==1
        set(handles.calculateButton,'Enable','on')
    else
        set(handles.calculateButton,'Enable','off')
    end
    %%
end


function acont_Callback(hObject, eventdata, handles)
% hObject    handle to acont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of acont as text
%        str2double(get(hObject,'String')) returns contents of acont as a double
global acont
acont = str2double(get(hObject,'String' ));
set(handles.INDW132,'String',num2str(acont));

% --- Executes during object creation, after setting all properties.
function acont_CreateFcn(hObject, eventdata, handles)
% hObject    handle to acont (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function KintTEXT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KintTEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkbox13.
function checkbox13_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox13


% --- Executes on button press in cb1.
function cb1_Callback(hObject, eventdata, handles)
% hObject    handle to cb1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cb1
colr =[0.94 0.94 0.94];
colhs = 1/255*[186 255 150];
cb1=get(hObject,'Value');
if cb1
    % enable single material fields
    set(handles.A1p1p,'Enable','on');
    set(handles.A2p2p,'Enable','on');
    %
    set(handles.cb2,'Value',0);
    set(handles.cb3,'Value',0);
    %activate corresponding edit fields coating thickness
    set(handles.T1,'Enable','on');
    set(handles.T2,'Enable','on');
    % activate corresponding edit texts combined Hamaker
    set(handles.A12,'Enable','on');
    set(handles.A12p,'Enable','on');
    set(handles.A13,'Enable','on');
    set(handles.A1p2,'Enable','on');
    set(handles.A1p2p,'Enable','on');
    set(handles.A1p3,'Enable','on');
    set(handles.A23,'Enable','on');
    set(handles.A2p3,'Enable','on');
    %reset values
    set(handles.A12,'String','0.0');
    set(handles.A12p,'String','0.0');
    set(handles.A13,'String','0.0');
    set(handles.A1p2,'String','0.0');
    set(handles.A1p2p,'String','0.0');
    set(handles.A1p3,'String','0.0');
    set(handles.A23,'String','0.0');
    set(handles.A2p3,'String','0.0');
    % activate corresponding check boxes combined Hamaker
    set(handles.cbA12,'Enable','on');
    set(handles.cbA12p,'Enable','on');
    set(handles.cbA13,'Enable','on');
    set(handles.cbA1p2,'Enable','on');
    set(handles.cbA1p2p,'Enable','on');
    set(handles.cbA1p3,'Enable','on');
    set(handles.cbA23,'Enable','on');
    set(handles.cbA2p3,'Enable','on');
    % reset corresponding check boxes combined Hamaker
    set(handles.cbA12,'Value',0);
    set(handles.cbA12p,'Value',0);
    set(handles.cbA13,'Value',0);
    set(handles.cbA1p2,'Value',0);
    set(handles.cbA1p2p,'Value',0);
    set(handles.cbA1p3,'Value',0);
    set(handles.cbA23,'Value',0);
    set(handles.cbA2p3,'Value',0);
    %reset edits color
    set(handles.A12,'BackgroundColor',colr);
    set(handles.A12p,'BackgroundColor',colr);
    set(handles.A13,'BackgroundColor',colr);
    set(handles.A1p2,'BackgroundColor',colr);
    set(handles.A1p2p,'BackgroundColor',colr);
    set(handles.A1p3,'BackgroundColor',colr);
    set(handles.A23,'BackgroundColor',colr);
    set(handles.A2p3,'BackgroundColor',colr);
    % highlight panel s1
    set(handles.cb1,'BackgroundColor',colhs);
    set(handles.uipanelS1,'BackgroundColor',colhs);
    set(handles.text1S1,'BackgroundColor',colhs);
    set(handles.text2S1,'BackgroundColor',colhs);
    set(handles.text3S1,'BackgroundColor',colhs);
    set(handles.text4S1,'BackgroundColor',colhs);
    % reset panel s2
    set(handles.cb2,'BackgroundColor',colr);
    set(handles.uipanelS2,'BackgroundColor',colr);
    set(handles.text1S2,'BackgroundColor',colr);
    set(handles.text2S2,'BackgroundColor',colr);
    % reset panel s3
    set(handles.cb3,'BackgroundColor',colr);
    set(handles.uipanelS3,'BackgroundColor',colr);
    set(handles.text1S3,'BackgroundColor',colr);
    set(handles.text2S3,'BackgroundColor',colr);
    %reset calculate fields in hamaker contributions
    set(handles.s1A1p2p,'String','calculate');
    set(handles.s1A12p,'String','calculate');
    set(handles.s1A1p2,'String','calculate');
    set(handles.s1A12,'String','calculate');
    set(handles.s2A12p,'String','calculate');
    set(handles.s2A12,'String','calculate');
    set(handles.s3A1p2,'String','calculate');
    set(handles.s3A12,'String','calculate');
    %reset panel
    set (handles.uipanelHam,'BackgroundColor',colr);
    set (handles.textA11,'BackgroundColor',colr);
    set (handles.textA1p1p,'BackgroundColor',colr);
    set (handles.textA22,'BackgroundColor',colr);
    set (handles.textA2p2p,'BackgroundColor',colr);
    set (handles.textA33,'BackgroundColor',colr);
    
else
    set(handles.cb2,'Value',1);
    set(handles.T1,'Enable','off');
    % disable single material fields
    set(handles.A1p1p,'Enable','off');
    % deactivate corresponding fields for s2
    set(handles.A1p2,'Enable','off');
    set(handles.A1p2p,'Enable','off');
    set(handles.A1p3,'Enable','off');
    set(handles.A1p2,'String','N/A');
    set(handles.A1p2p,'String','N/A');
    set(handles.A1p3,'String','N/A');
    %reset values
    set(handles.A12,'String','0.0');
    set(handles.A12p,'String','0.0');
    set(handles.A13,'String','0.0');
    set(handles.A23,'String','0.0');
    set(handles.A2p3,'String','0.0');
    % deactivate corresponding cb fields and reset values
    set(handles.cbA13,'Enable','off');
    set(handles.cbA1p2,'Enable','off');
    set(handles.cbA1p2p,'Enable','off');
    set(handles.cbA1p3,'Enable','off');
    set(handles.cbA13,'Value',0);
    set(handles.cbA1p2,'Value',0);
    set(handles.cbA1p2p,'Value',0);
    set(handles.cbA1p3,'Value',0);
    % check all combined hamaker checkboxes
    % get values of all other checkboxes
    cbA12=get(handles.cbA12,'Value');
    cbA12p=get(handles.cbA12p,'Value');
    cbA13=get(handles.cbA13,'Value');
    cbA1p2=get(handles.A1p2,'Value');
    cbA1p2p=get(handles.cbA1p2p,'Value');
    cbA1p3=get(handles.cbA1p3,'Value');
    cbA23=get(handles.cbA23,'Value');
    cbA2p3=get(handles.cbA2p3,'Value');
    %
    %     if (cbA12+cbA12p+cbA13+cbA1p2+cbA1p2p+cbA1p3+cbA23+cbA2p3)==0
    %
    %     end
    % activate corresponding edit texts combined Hamaker
    set(handles.A12,'Enable','on');
    set(handles.A12p,'Enable','on');
    set(handles.A13,'Enable','on');
    set(handles.A23,'Enable','on');
    set(handles.A2p3,'Enable','on');
    % activate corresponding check boxes combined Hamaker
    set(handles.cbA12,'Enable','on');
    set(handles.cbA12p,'Enable','on');
    set(handles.cbA13,'Enable','on');
    set(handles.cbA23,'Enable','on');
    set(handles.cbA2p3,'Enable','on');
    % reset panel s1
    set(handles.cb1,'BackgroundColor',colr);
    set(handles.uipanelS1,'BackgroundColor',colr);
    set(handles.text1S1,'BackgroundColor',colr);
    set(handles.text2S1,'BackgroundColor',colr);
    set(handles.text3S1,'BackgroundColor',colr);
    set(handles.text4S1,'BackgroundColor',colr);
    % highlight panel s2
    set(handles.cb2,'BackgroundColor',colhs);
    set(handles.uipanelS2,'BackgroundColor',colhs);
    set(handles.text1S2,'BackgroundColor',colhs);
    set(handles.text2S2,'BackgroundColor',colhs);
    %reset calculate fields in hamaker contributions
    set(handles.s1A1p2p,'String','calculate');
    set(handles.s1A12p,'String','calculate');
    set(handles.s1A1p2,'String','calculate');
    set(handles.s1A12,'String','calculate');
    set(handles.s2A12p,'String','calculate');
    set(handles.s2A12,'String','calculate');
    set(handles.s3A1p2,'String','calculate');
    set(handles.s3A12,'String','calculate');
    % reset corresponding check boxes combined Hamaker
    set(handles.cbA12,'Value',0);
    set(handles.cbA12p,'Value',0);
    set(handles.cbA13,'Value',0);
    set(handles.cbA1p2,'Value',0);
    set(handles.cbA1p2p,'Value',0);
    set(handles.cbA1p3,'Value',0);
    set(handles.cbA23,'Value',0);
    set(handles.cbA2p3,'Value',0);
    %reset edits color
    set(handles.A12,'BackgroundColor',colr);
    set(handles.A12p,'BackgroundColor',colr);
    set(handles.A13,'BackgroundColor',colr);
    set(handles.A1p2,'BackgroundColor',colr);
    set(handles.A1p2p,'BackgroundColor',colr);
    set(handles.A1p3,'BackgroundColor',colr);
    set(handles.A23,'BackgroundColor',colr);
    set(handles.A2p3,'BackgroundColor',colr);
    %reset panel
    set (handles.uipanelHam,'BackgroundColor',colr);
    set (handles.textA11,'BackgroundColor',colr);
    set (handles.textA1p1p,'BackgroundColor',colr);
    set (handles.textA22,'BackgroundColor',colr);
    set (handles.textA2p2p,'BackgroundColor',colr);
    set (handles.textA33,'BackgroundColor',colr);
end


% --- Executes on button press in cb2.
function cb2_Callback(hObject, eventdata, handles)
% hObject    handle to cb2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colr =[0.94 0.94 0.94];
colhs = 1/255*[186 255 150];
% Hint: get(hObject,'Value') returns toggle state of cb2
cb2=get(hObject,'Value');
if cb2
    set(handles.cb1,'Value',0);
    set(handles.cb3,'Value',0);
    set(handles.T1,'Enable','off');
    set(handles.T2,'Enable','on');
    % deactivate corresponding edits fields
    set(handles.A1p2,'BackgroundColor','white');
    set(handles.A1p2p,'BackgroundColor','white');
    set(handles.A1p3,'BackgroundColor','white');
    set(handles.A1p2,'Enable','off');
    set(handles.A1p2p,'Enable','off');
    set(handles.A1p3,'Enable','off');
    set(handles.A1p2,'String','N/A');
    set(handles.A1p2p,'String','N/A');
    set(handles.A1p3,'String','N/A');
    %reset values
    set(handles.A12,'String','0.0');
    set(handles.A12p,'String','0.0');
    set(handles.A13,'String','0.0');
    set(handles.A23,'String','0.0');
    set(handles.A2p3,'String','0.0');
    % deactivate corresponding cb fields and values
    set(handles.cbA1p2,'Enable','off');
    set(handles.cbA1p2p,'Enable','off');
    set(handles.cbA1p3,'Enable','off');
    set(handles.cbA1p2,'Value',0);
    set(handles.cbA1p2p,'Value',0);
    set(handles.cbA1p3,'Value',0);
    % check all combined hamaker checkboxes
    % get values of all other checkboxes
    cbA12=get(handles.cbA12,'Value');
    cbA12p=get(handles.cbA12p,'Value');
    cbA13=get(handles.cbA13,'Value');
    cbA1p2=get(handles.A1p2,'Value');
    cbA1p2p=get(handles.cbA1p2p,'Value');
    cbA1p3=get(handles.cbA1p3,'Value');
    cbA23=get(handles.cbA23,'Value');
    cbA2p3=get(handles.cbA2p3,'Value');
    %
    %reset panel
    set (handles.uipanelHam,'BackgroundColor',colr);
    set (handles.textA11,'BackgroundColor',colr);
    set (handles.textA1p1p,'BackgroundColor',colr);
    set (handles.textA22,'BackgroundColor',colr);
    set (handles.textA2p2p,'BackgroundColor',colr);
    set (handles.textA33,'BackgroundColor',colr);
    % activate corresponding edit texts combined Hamaker
    set(handles.A12,'Enable','on');
    set(handles.A12p,'Enable','on');
    set(handles.A13,'Enable','on');
    set(handles.A23,'Enable','on');
    set(handles.A2p3,'Enable','on');
    % activate corresponding check boxes combined Hamaker
    set(handles.cbA12,'Enable','on');
    set(handles.cbA12p,'Enable','on');
    set(handles.cbA13,'Enable','on');
    set(handles.cbA23,'Enable','on');
    set(handles.cbA2p3,'Enable','on');
    % highlight panel s2
    set(handles.cb2,'BackgroundColor',colhs);
    set(handles.uipanelS2,'BackgroundColor',colhs);
    set(handles.text1S2,'BackgroundColor',colhs);
    set(handles.text2S2,'BackgroundColor',colhs);
    % reset panel s1
    set(handles.cb1,'BackgroundColor',colr);
    set(handles.uipanelS1,'BackgroundColor',colr);
    set(handles.text1S1,'BackgroundColor',colr);
    set(handles.text2S1,'BackgroundColor',colr);
    set(handles.text3S1,'BackgroundColor',colr);
    set(handles.text4S1,'BackgroundColor',colr);
    % reset panel s3
    set(handles.cb3,'BackgroundColor',colr);
    set(handles.uipanelS3,'BackgroundColor',colr);
    set(handles.text1S3,'BackgroundColor',colr);
    set(handles.text2S3,'BackgroundColor',colr);
    %reset calculate fields in hamaker contributions
    set(handles.s1A1p2p,'String','calculate');
    set(handles.s1A12p,'String','calculate');
    set(handles.s1A1p2,'String','calculate');
    set(handles.s1A12,'String','calculate');
    set(handles.s2A12p,'String','calculate');
    set(handles.s2A12,'String','calculate');
    set(handles.s3A1p2,'String','calculate');
    set(handles.s3A12,'String','calculate');
    % reset corresponding check boxes combined Hamaker
    set(handles.cbA12,'Value',0);
    set(handles.cbA12p,'Value',0);
    set(handles.cbA13,'Value',0);
    set(handles.cbA1p2,'Value',0);
    set(handles.cbA1p2p,'Value',0);
    set(handles.cbA1p3,'Value',0);
    set(handles.cbA23,'Value',0);
    set(handles.cbA2p3,'Value',0);
    %reset edits color
    set(handles.A12,'BackgroundColor',colr);
    set(handles.A12p,'BackgroundColor',colr);
    set(handles.A13,'BackgroundColor',colr);
    set(handles.A1p2,'BackgroundColor',colr);
    set(handles.A1p2p,'BackgroundColor',colr);
    set(handles.A1p3,'BackgroundColor',colr);
    set(handles.A23,'BackgroundColor',colr);
    set(handles.A2p3,'BackgroundColor',colr);
    % disable corresponding single material
    set(handles.A1p1p,'Enable','off');
    % enable corresponding single material
    set(handles.A2p2p,'Enable','on');
else
    % enable corresponding single material
    set(handles.A1p1p,'Enable','on');
    %
    set(handles.cb1,'Value',1);
    set(handles.T1,'Enable','on');
    set(handles.T2,'Enable','on');
    % activate corresponding edit texts combined Hamaker
    set(handles.A12,'Enable','on');
    set(handles.A12p,'Enable','on');
    set(handles.A13,'Enable','on');
    set(handles.A1p2,'Enable','on');
    set(handles.A1p2p,'Enable','on');
    set(handles.A1p3,'Enable','on');
    set(handles.A23,'Enable','on');
    set(handles.A2p3,'Enable','on');
    %reset values
    set(handles.A12,'String','0.0');
    set(handles.A12p,'String','0.0');
    set(handles.A13,'String','0.0');
    set(handles.A1p2,'String','0.0');
    set(handles.A1p2p,'String','0.0');
    set(handles.A1p3,'String','0.0');
    set(handles.A23,'String','0.0');
    set(handles.A2p3,'String','0.0');
    % activate corresponding edit fields check boxes','on');
    set(handles.cbA12p,'Enable','on');
    set(handles.cbA13,'Enable','on');
    set(handles.cbA1p2,'Enable','on');
    set(handles.cbA1p2p,'Enable','on');
    set(handles.cbA1p3,'Enable','on');
    set(handles.cbA23,'Enable','on');
    set(handles.cbA2p3,'Enable','on');
    % reset panel s2
    set(handles.cb2,'BackgroundColor',colr);
    set(handles.uipanelS2,'BackgroundColor',colr);
    set(handles.text1S2,'BackgroundColor',colr);
    set(handles.text2S2,'BackgroundColor',colr);
    % highlight panel s1
    set(handles.cb1,'BackgroundColor',colhs);
    set(handles.uipanelS1,'BackgroundColor',colhs);
    set(handles.text1S1,'BackgroundColor',colhs);
    set(handles.text2S1,'BackgroundColor',colhs);
    set(handles.text3S1,'BackgroundColor',colhs);
    set(handles.text4S1,'BackgroundColor',colhs);
    %reset calculate fields in hamaker contributions
    set(handles.s1A1p2p,'String','calculate');
    set(handles.s1A12p,'String','calculate');
    set(handles.s1A1p2,'String','calculate');
    set(handles.s1A12,'String','calculate');
    set(handles.s2A12p,'String','calculate');
    set(handles.s2A12,'String','calculate');
    set(handles.s3A1p2,'String','calculate');
    set(handles.s3A12,'String','calculate');
    % reset corresponding check boxes combined Hamaker
    set(handles.cbA12,'Value',0);
    set(handles.cbA12p,'Value',0);
    set(handles.cbA13,'Value',0);
    set(handles.cbA1p2,'Value',0);
    set(handles.cbA1p2p,'Value',0);
    set(handles.cbA1p3,'Value',0);
    set(handles.cbA23,'Value',0);
    set(handles.cbA2p3,'Value',0);
    %reset edits color
    set(handles.A12,'BackgroundColor',colr);
    set(handles.A12p,'BackgroundColor',colr);
    set(handles.A13,'BackgroundColor',colr);
    set(handles.A1p2,'BackgroundColor',colr);
    set(handles.A1p2p,'BackgroundColor',colr);
    set(handles.A1p3,'BackgroundColor',colr);
    set(handles.A23,'BackgroundColor',colr);
    set(handles.A2p3,'BackgroundColor',colr);
    %reset panel
    set (handles.uipanelHam,'BackgroundColor',colr);
    set (handles.textA11,'BackgroundColor',colr);
    set (handles.textA1p1p,'BackgroundColor',colr);
    set (handles.textA22,'BackgroundColor',colr);
    set (handles.textA2p2p,'BackgroundColor',colr);
    set (handles.textA33,'BackgroundColor',colr);
end

% --- Executes on button press in cb3.
function cb3_Callback(hObject, eventdata, handles)
% hObject    handle to cb3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
colr =[0.94 0.94 0.94];
colhs = 1/255*[186 255 150];
% Hint: get(hObject,'Value') returns toggle state of cb3
cb3=get(hObject,'Value');
if cb3
    set(handles.cb1,'Value',0);
    set(handles.cb2,'Value',0);
    set(handles.T1,'Enable','on');
    set(handles.T2,'Enable','off');
    % activate corresponding edit texts combined Hamaker
    set(handles.A12,'Enable','on');
    set(handles.A13,'Enable','on');
    set(handles.A1p2,'Enable','on');
    set(handles.A1p3,'Enable','on');
    set(handles.A23,'Enable','on');
    set(handles.A12,'String','0.0');
    set(handles.A13,'String','0.0');
    set(handles.A1p2,'String','0.0');
    set(handles.A1p3,'String','0.0');
    set(handles.A23,'String','0.0');
    %deactivate corresponding edit texts and color combined Hamaker
    set(handles.A12p,'BackgroundColor','white');
    set(handles.A1p2p,'BackgroundColor','white');
    set(handles.A2p3,'BackgroundColor','white');
    set(handles.A12p,'Enable','off');
    set(handles.A1p2p,'Enable','off');
    set(handles.A2p3,'Enable','off');
    set(handles.A12p,'String','N/A');
    set(handles.A1p2p,'String','N/A');
    set(handles.A2p3,'String','N/A');
    % activate corresponding check boxes combined Hamaker
    set(handles.cbA12,'Enable','on');
    set(handles.cbA13,'Enable','on');
    set(handles.cbA1p2,'Enable','on');
    set(handles.cbA1p3,'Enable','on');
    set(handles.cbA23,'Enable','on');
    %deactivate corresponding check boxes combined Hamaker and values
    set(handles.cbA12p,'Enable','off');
    set(handles.cbA1p2p,'Enable','off');
    set(handles.cbA2p3,'Enable','off');
    set(handles.cbA12p,'Value',0);
    set(handles.cbA1p2p,'Value',0);
    set(handles.cbA2p3,'Value',0);
    % check all combined hamaker checkboxes
    % get values of all other checkboxes
    cbA12=get(handles.cbA12,'Value');
    cbA12p=get(handles.cbA12p,'Value');
    cbA13=get(handles.cbA13,'Value');
    cbA1p2=get(handles.A1p2,'Value');
    cbA1p2p=get(handles.cbA1p2p,'Value');
    cbA1p3=get(handles.cbA1p3,'Value');
    cbA23=get(handles.cbA23,'Value');
    cbA2p3=get(handles.cbA2p3,'Value');
    %
    %reset panel
    set (handles.uipanelHam,'BackgroundColor',colr);
    set (handles.textA11,'BackgroundColor',colr);
    set (handles.textA1p1p,'BackgroundColor',colr);
    set (handles.textA22,'BackgroundColor',colr);
    set (handles.textA2p2p,'BackgroundColor',colr);
    set (handles.textA33,'BackgroundColor',colr);
    % highlight panel s3
    set(handles.cb3,'BackgroundColor',colhs);
    set(handles.uipanelS3,'BackgroundColor',colhs);
    set(handles.text1S3,'BackgroundColor',colhs);
    set(handles.text2S3,'BackgroundColor',colhs);
    % reset panel s1
    set(handles.cb1,'BackgroundColor',colr);
    set(handles.uipanelS1,'BackgroundColor',colr);
    set(handles.text1S1,'BackgroundColor',colr);
    set(handles.text2S1,'BackgroundColor',colr);
    set(handles.text3S1,'BackgroundColor',colr);
    set(handles.text4S1,'BackgroundColor',colr);
    % reset panel s2
    set(handles.cb2,'BackgroundColor',colr);
    set(handles.uipanelS2,'BackgroundColor',colr);
    set(handles.text1S2,'BackgroundColor',colr);
    set(handles.text2S2,'BackgroundColor',colr);
    %reset calculate fields in hamaker contributions
    set(handles.s1A1p2p,'String','calculate');
    set(handles.s1A12p,'String','calculate');
    set(handles.s1A1p2,'String','calculate');
    set(handles.s1A12,'String','calculate');
    set(handles.s2A12p,'String','calculate');
    set(handles.s2A12,'String','calculate');
    set(handles.s3A1p2,'String','calculate');
    set(handles.s3A12,'String','calculate');
    % reset corresponding check boxes combined Hamaker
    set(handles.cbA12,'Value',0);
    set(handles.cbA12p,'Value',0);
    set(handles.cbA13,'Value',0);
    set(handles.cbA1p2,'Value',0);
    set(handles.cbA1p2p,'Value',0);
    set(handles.cbA1p3,'Value',0);
    set(handles.cbA23,'Value',0);
    set(handles.cbA2p3,'Value',0);
    %reset edits color
    set(handles.A12,'BackgroundColor',colr);
    set(handles.A12p,'BackgroundColor',colr);
    set(handles.A13,'BackgroundColor',colr);
    set(handles.A1p2,'BackgroundColor',colr);
    set(handles.A1p2p,'BackgroundColor',colr);
    set(handles.A1p3,'BackgroundColor',colr);
    set(handles.A23,'BackgroundColor',colr);
    set(handles.A2p3,'BackgroundColor',colr);
    % disable corresponding single material
    set(handles.A2p2p,'Enable','off');
    % enable corresponding single material
    set(handles.A1p1p,'Enable','on');
else
    % disable corresponding single material
    set(handles.A2p2p,'Enable','on');
    %
    set(handles.cb1,'Value',1);
    set(handles.T1,'Enable','on');
    set(handles.T2,'Enable','on');
    % activate corresponding edit texts combined Hamaker
    set(handles.A12,'Enable','on');
    set(handles.A12p,'Enable','on');
    set(handles.A13,'Enable','on');
    set(handles.A1p2,'Enable','on');
    set(handles.A1p2p,'Enable','on');
    set(handles.A1p3,'Enable','on');
    set(handles.A23,'Enable','on');
    set(handles.A2p3,'Enable','on');
    set(handles.A12,'String','0.0');
    set(handles.A12p,'String','0.0');
    set(handles.A13,'String','0.0');
    set(handles.A1p2,'String','0.0');
    set(handles.A1p2p,'String','0.0');
    set(handles.A1p3,'String','0.0');
    set(handles.A23,'String','0.0');
    set(handles.A2p3,'String','0.0');
    % activate corresponding check boxes combined Hamaker
    set(handles.cbA12,'Enable','on');
    set(handles.cbA12p,'Enable','on');
    set(handles.cbA13,'Enable','on');
    set(handles.cbA1p2,'Enable','on');
    set(handles.cbA1p2p,'Enable','on');
    set(handles.cbA1p3,'Enable','on');
    set(handles.cbA23,'Enable','on');
    set(handles.cbA2p3,'Enable','on');
    % reset panel s3
    set(handles.cb3,'BackgroundColor',colr);
    set(handles.uipanelS3,'BackgroundColor',colr);
    set(handles.text1S3,'BackgroundColor',colr);
    set(handles.text2S3,'BackgroundColor',colr);
    % highlight panel s1
    set(handles.cb1,'BackgroundColor',colhs);
    set(handles.uipanelS1,'BackgroundColor',colhs);
    set(handles.text1S1,'BackgroundColor',colhs);
    set(handles.text2S1,'BackgroundColor',colhs);
    set(handles.text3S1,'BackgroundColor',colhs);
    set(handles.text4S1,'BackgroundColor',colhs);
    %reset calculate fields in hamaker contributions
    set(handles.s1A1p2p,'String','calculate');
    set(handles.s1A12p,'String','calculate');
    set(handles.s1A1p2,'String','calculate');
    set(handles.s1A12,'String','calculate');
    set(handles.s2A12p,'String','calculate');
    set(handles.s2A12,'String','calculate');
    set(handles.s3A1p2,'String','calculate');
    set(handles.s3A12,'String','calculate');
    % reset corresponding check boxes combined Hamaker
    set(handles.cbA12,'Value',0);
    set(handles.cbA12p,'Value',0);
    set(handles.cbA13,'Value',0);
    set(handles.cbA1p2,'Value',0);
    set(handles.cbA1p2p,'Value',0);
    set(handles.cbA1p3,'Value',0);
    set(handles.cbA23,'Value',0);
    set(handles.cbA2p3,'Value',0);
    %reset edits color
    set(handles.A12,'BackgroundColor',colr);
    set(handles.A12p,'BackgroundColor',colr);
    set(handles.A13,'BackgroundColor',colr);
    set(handles.A1p2,'BackgroundColor',colr);
    set(handles.A1p2p,'BackgroundColor',colr);
    set(handles.A1p3,'BackgroundColor',colr);
    set(handles.A23,'BackgroundColor',colr);
    set(handles.A2p3,'BackgroundColor',colr);
    %reset panel
    set (handles.uipanelHam,'BackgroundColor',colr);
    set (handles.textA11,'BackgroundColor',colr);
    set (handles.textA1p1p,'BackgroundColor',colr);
    set (handles.textA22,'BackgroundColor',colr);
    set (handles.textA2p2p,'BackgroundColor',colr);
    set (handles.textA33,'BackgroundColor',colr);
end



function T1_Callback(hObject, eventdata, handles)
% hObject    handle to T1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T1 as text
%        str2double(get(hObject,'String')) returns contents of T1 as a double


% --- Executes during object creation, after setting all properties.
function T1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T2_Callback(hObject, eventdata, handles)
% hObject    handle to T2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of T2 as text
%        str2double(get(hObject,'String')) returns contents of T2 as a double


% --- Executes during object creation, after setting all properties.
function T2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to T2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A33_Callback(hObject, eventdata, handles)
% hObject    handle to A33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A33 as text
%        str2double(get(hObject,'String')) returns contents of A33 as a double


% --- Executes during object creation, after setting all properties.
function A33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A11_Callback(hObject, eventdata, handles)
% hObject    handle to A11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A11 as text
%        str2double(get(hObject,'String')) returns contents of A11 as a double


% --- Executes during object creation, after setting all properties.
function A11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A1p1p_Callback(hObject, eventdata, handles)
% hObject    handle to A1p1p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A1p1p as text
%        str2double(get(hObject,'String')) returns contents of A1p1p as a double


% --- Executes during object creation, after setting all properties.
function A1p1p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A1p1p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A22_Callback(hObject, eventdata, handles)
% hObject    handle to A22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A22 as text
%        str2double(get(hObject,'String')) returns contents of A22 as a double


% --- Executes during object creation, after setting all properties.
function A22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A2p2p_Callback(hObject, eventdata, handles)
% hObject    handle to A2p2p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A2p2p as text
%        str2double(get(hObject,'String')) returns contents of A2p2p as a double


% --- Executes during object creation, after setting all properties.
function A2p2p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A2p2p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A12_Callback(hObject, eventdata, handles)
% hObject    handle to A12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A12 as text
%        str2double(get(hObject,'String')) returns contents of A12 as a double


% --- Executes during object creation, after setting all properties.
function A12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A12p_Callback(hObject, eventdata, handles)
% hObject    handle to A12p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A12p as text
%        str2double(get(hObject,'String')) returns contents of A12p as a double


% --- Executes during object creation, after setting all properties.
function A12p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A12p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A13_Callback(hObject, eventdata, handles)
% hObject    handle to A13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A13 as text
%        str2double(get(hObject,'String')) returns contents of A13 as a double


% --- Executes during object creation, after setting all properties.
function A13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A1p2_Callback(hObject, eventdata, handles)
% hObject    handle to A1p2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A1p2 as text
%        str2double(get(hObject,'String')) returns contents of A1p2 as a double


% --- Executes during object creation, after setting all properties.
function A1p2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A1p2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A1p2p_Callback(hObject, eventdata, handles)
% hObject    handle to A1p2p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A1p2p as text
%        str2double(get(hObject,'String')) returns contents of A1p2p as a double


% --- Executes during object creation, after setting all properties.
function A1p2p_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A1p2p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A1p3_Callback(hObject, eventdata, handles)
% hObject    handle to A1p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A1p3 as text
%        str2double(get(hObject,'String')) returns contents of A1p3 as a double


% --- Executes during object creation, after setting all properties.
function A1p3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A1p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A23_Callback(hObject, eventdata, handles)
% hObject    handle to A23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A23 as text
%        str2double(get(hObject,'String')) returns contents of A23 as a double


% --- Executes during object creation, after setting all properties.
function A23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function A2p3_Callback(hObject, eventdata, handles)
% hObject    handle to A2p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of A2p3 as text
%        str2double(get(hObject,'String')) returns contents of A2p3 as a double


% --- Executes during object creation, after setting all properties.
function A2p3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A2p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbA12.
function cbA12_Callback(hObject, eventdata, handles)
% hObject    handle to cbA12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of cbA12
% highlight color
chHam = [0.68 0.92 1.0];
% reset color
colr = [0.94 0.94 0.94];
global oldA12
cbA12=get(hObject,'Value');
if cbA12
    %highlight text field
    set (handles.A12,'BackgroundColor',chHam);
    %highlight panel
    set (handles.uipanelHam,'BackgroundColor',chHam);
    set (handles.textA11,'BackgroundColor',chHam);
    set (handles.textA1p1p,'BackgroundColor',chHam);
    set (handles.textA22,'BackgroundColor',chHam);
    set (handles.textA2p2p,'BackgroundColor',chHam);
    
    % save older value
    oldA12 = str2double (get(handles.A12,'String'));
    % disable edid text
    set (handles.A12,'Enable','inactive')
    % calculate A12
    A11 = str2double (get(handles.A11,'String'));
    A22 = str2double (get(handles.A22,'String'));
    A12 = A11^0.5*A22^0.5;
    % set value
    set (handles.A12,'String',num2str(A12));
else
    % enable edid text
    set (handles.A12,'Enable','on')
    % load older value
    set (handles.A12,'String',num2str(oldA12));
    % reset color
    set (handles.A12,'BackgroundColor',colr);
    % get values of all other checkboxes
    cbA12=get(handles.cbA12,'Value');
    cbA12p=get(handles.cbA12p,'Value');
    cbA13=get(handles.cbA13,'Value');
    cbA1p2=get(handles.A1p2,'Value');
    cbA1p2p=get(handles.cbA1p2p,'Value');
    cbA1p3=get(handles.cbA1p3,'Value');
    cbA23=get(handles.cbA23,'Value');
    cbA2p3=get(handles.cbA2p3,'Value');
    if (cbA12+cbA12p+cbA13+cbA1p2+cbA1p2p+cbA1p3+cbA23+cbA2p3)==0
        %reset panel
        set (handles.uipanelHam,'BackgroundColor',colr);
        set (handles.textA11,'BackgroundColor',colr);
        set (handles.textA1p1p,'BackgroundColor',colr);
        set (handles.textA22,'BackgroundColor',colr);
        set (handles.textA2p2p,'BackgroundColor',colr);
        set (handles.textA33,'BackgroundColor',colr);
    end
    
end


% --- Executes on button press in cbA13.
function cbA13_Callback(hObject, eventdata, handles)
% hObject    handle to cbA13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbA13
% highlight color
chHam = [0.68 0.92 1.0];
% reset color
colr = [0.94 0.94 0.94];
global oldA13
cbA13=get(hObject,'Value');
if cbA13
    % save older value
    oldA13 = str2double (get(handles.A13,'String'));
    % disable edid text
    set (handles.A13,'Enable','inactive')
    % calculate A13
    A11 = str2double (get(handles.A11,'String'));
    A33 = str2double (get(handles.A33,'String'));
    A13 = A11^0.5*A33^0.5;
    % set value
    set (handles.A13,'String',num2str(A13));
    %highlight text field
    set (handles.A13,'BackgroundColor',chHam);
    %highlight panel
    set (handles.uipanelHam,'BackgroundColor',chHam);
    set (handles.textA11,'BackgroundColor',chHam);
    set (handles.textA1p1p,'BackgroundColor',chHam);
    set (handles.textA22,'BackgroundColor',chHam);
    set (handles.textA2p2p,'BackgroundColor',chHam);
    
else
    % enable edid text
    set (handles.A13,'Enable','on')
    % load older value
    set (handles.A13,'String',num2str(oldA13));
    % get values of all other checkboxes
    cbA12=get(handles.cbA12,'Value');
    cbA12p=get(handles.cbA12p,'Value');
    cbA13=get(handles.cbA13,'Value');
    cbA1p2=get(handles.A1p2,'Value');
    cbA1p2p=get(handles.cbA1p2p,'Value');
    cbA1p3=get(handles.cbA1p3,'Value');
    cbA23=get(handles.cbA23,'Value');
    cbA2p3=get(handles.cbA2p3,'Value');
    %reset edit field
    set (handles.A13,'BackgroundColor',colr) ;
    if (cbA12+cbA12p+cbA13+cbA1p2+cbA1p2p+cbA1p3+cbA23+cbA2p3)==0
        %reset panel
        set (handles.uipanelHam,'BackgroundColor',colr);
        set (handles.textA11,'BackgroundColor',colr);
        set (handles.textA1p1p,'BackgroundColor',colr);
        set (handles.textA22,'BackgroundColor',colr);
        set (handles.textA2p2p,'BackgroundColor',colr);
        set (handles.textA33,'BackgroundColor',colr);
    end
    
end


% --- Executes on button press in cbA1p2.
function cbA1p2_Callback(hObject, eventdata, handles)
% hObject    handle to cbA1p2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% highlight color
chHam = [0.68 0.92 1.0];
% reset color
colr = [0.94 0.94 0.94];
% Hint: get(hObject,'Value') returns toggle state of cbA1p2
global oldA1p2
cbA1p2=get(hObject,'Value');
if cbA1p2
    % save older value
    oldA1p2 = str2double (get(handles.A1p2,'String'));
    % disable edid text
    set (handles.A1p2,'Enable','inactive')
    % calculate A13
    A1p1p = str2double (get(handles.A1p1p,'String'));
    A22= str2double (get(handles.A22,'String'));
    A1p2 = A1p1p^0.5*A22^0.5;
    % set value
    set (handles.A1p2,'String',num2str(A1p2));
    %highlight text field
    set (handles.A1p2,'BackgroundColor',chHam);
    %highlight panel
    set (handles.uipanelHam,'BackgroundColor',chHam);
    set (handles.textA11,'BackgroundColor',chHam);
    set (handles.textA1p1p,'BackgroundColor',chHam);
    set (handles.textA22,'BackgroundColor',chHam);
    set (handles.textA2p2p,'BackgroundColor',chHam);
    
else
    % enable edid text
    set (handles.A1p2,'Enable','on')
    % load older value
    set (handles.A1p2,'String',num2str(oldA1p2));
    % get values of all other checkboxes
    cbA12=get(handles.cbA12,'Value');
    cbA12p=get(handles.cbA12p,'Value');
    cbA13=get(handles.cbA13,'Value');
    cbA1p2=get(handles.A1p2,'Value');
    cbA1p2p=get(handles.cbA1p2p,'Value');
    cbA1p3=get(handles.cbA1p3,'Value');
    cbA23=get(handles.cbA23,'Value');
    cbA2p3=get(handles.cbA2p3,'Value');
    %reset edit field
    set (handles.A1p2,'BackgroundColor',colr) ;
    if (cbA12+cbA12p+cbA13+cbA1p2+cbA1p2p+cbA1p3+cbA23+cbA2p3)==0
        %reset panel
        set (handles.uipanelHam,'BackgroundColor',colr);
        set (handles.textA11,'BackgroundColor',colr);
        set (handles.textA1p1p,'BackgroundColor',colr);
        set (handles.textA22,'BackgroundColor',colr);
        set (handles.textA2p2p,'BackgroundColor',colr);
        set (handles.textA33,'BackgroundColor',colr);
    end
end

% --- Executes on button press in cbA1p2p.
function cbA1p2p_Callback(hObject, eventdata, handles)
% hObject    handle to cbA1p2p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% highlight color
chHam = [0.68 0.92 1.0];
% reset color
colr = [0.94 0.94 0.94];
% Hint: get(hObject,'Value') returns toggle state of cbA1p2p
global oldA1p2p
cbA1p2p=get(hObject,'Value');
if cbA1p2p
    % save older value
    oldA1p2p = str2double (get(handles.A1p2p,'String'));
    % disable edid text
    set (handles.A1p2p,'Enable','inactive')
    % calculate A13
    A1p1p = str2double (get(handles.A1p1p,'String'));
    A2p2p= str2double (get(handles.A2p2p,'String'));
    A1p2p = A1p1p^0.5*A2p2p^0.5;
    % set value
    set (handles.A1p2p,'String',num2str(A1p2p));
    %highlight text field
    set (handles.A1p2p,'BackgroundColor',chHam);
    %highlight panel
    set (handles.uipanelHam,'BackgroundColor',chHam);
    set (handles.textA11,'BackgroundColor',chHam);
    set (handles.textA1p1p,'BackgroundColor',chHam);
    set (handles.textA22,'BackgroundColor',chHam);
    set (handles.textA2p2p,'BackgroundColor',chHam);
    
else
    % enable edid text
    set (handles.A1p2p,'Enable','on')
    % load older value
    set (handles.A1p2p,'String',num2str(oldA1p2p));
    % get values of all other checkboxes
    cbA12=get(handles.cbA12,'Value');
    cbA12p=get(handles.cbA12p,'Value');
    cbA13=get(handles.cbA13,'Value');
    cbA1p2=get(handles.A1p2,'Value');
    cbA1p2p=get(handles.cbA1p2p,'Value');
    cbA1p3=get(handles.cbA1p3,'Value');
    cbA23=get(handles.cbA23,'Value');
    cbA2p3=get(handles.cbA2p3,'Value');
    %reset edit field
    set (handles.A1p2p,'BackgroundColor',colr) ;
    if (cbA12+cbA12p+cbA13+cbA1p2+cbA1p2p+cbA1p3+cbA23+cbA2p3)==0
        %reset panel
        set (handles.uipanelHam,'BackgroundColor',colr);
        set (handles.textA11,'BackgroundColor',colr);
        set (handles.textA1p1p,'BackgroundColor',colr);
        set (handles.textA22,'BackgroundColor',colr);
        set (handles.textA2p2p,'BackgroundColor',colr);
        set (handles.textA33,'BackgroundColor',colr);
    end
end

% --- Executes on button press in cbA1p3.
function cbA1p3_Callback(hObject, eventdata, handles)
% hObject    handle to cbA1p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbA1p3
% highlight color
chHam = [0.68 0.92 1.0];
% reset color
colr = [0.94 0.94 0.94];
global oldA1p3
cbA1p3=get(hObject,'Value');
if cbA1p3
    % save older value
    oldA1p3 = str2double (get(handles.A1p3,'String'));
    % disable edid text
    set (handles.A1p3,'Enable','inactive')
    % calculate A1p3
    A1p1p = str2double (get(handles.A1p1p,'String'));
    A33= str2double (get(handles.A33,'String'));
    A1p3 = A1p1p^0.5*A33^0.5;
    % set value
    set (handles.A1p3,'String',num2str(A1p3));
    %highlight text field
    set (handles.A1p3,'BackgroundColor',chHam);
    %highlight panel
    set (handles.uipanelHam,'BackgroundColor',chHam);
    set (handles.textA11,'BackgroundColor',chHam);
    set (handles.textA1p1p,'BackgroundColor',chHam);
    set (handles.textA22,'BackgroundColor',chHam);
    set (handles.textA2p2p,'BackgroundColor',chHam);
    
else
    % enable edid text
    set (handles.A1p3,'Enable','on')
    % load older value
    set (handles.A1p3,'String',num2str(oldA1p3));
    % get values of all other checkboxes
    cbA12=get(handles.cbA12,'Value');
    cbA12p=get(handles.cbA12p,'Value');
    cbA13=get(handles.cbA13,'Value');
    cbA1p2=get(handles.A1p2,'Value');
    cbA1p2p=get(handles.cbA1p2p,'Value');
    cbA1p3=get(handles.cbA1p3,'Value');
    cbA23=get(handles.cbA23,'Value');
    cbA2p3=get(handles.cbA2p3,'Value');
    %reset edit field
    set (handles.A1p3,'BackgroundColor',colr) ;
    if (cbA12+cbA12p+cbA13+cbA1p2+cbA1p2p+cbA1p3+cbA23+cbA2p3)==0
        %reset panel
        set (handles.uipanelHam,'BackgroundColor',colr);
        set (handles.textA11,'BackgroundColor',colr);
        set (handles.textA1p1p,'BackgroundColor',colr);
        set (handles.textA22,'BackgroundColor',colr);
        set (handles.textA2p2p,'BackgroundColor',colr);
        set (handles.textA33,'BackgroundColor',colr);
    end
    
end

% --- Executes on button press in cbA23.
function cbA23_Callback(hObject, eventdata, handles)
% hObject    handle to cbA23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbA23
% highlight color
chHam = [0.68 0.92 1.0];
% reset color
colr = [0.94 0.94 0.94];
global oldA23
cbA23=get(hObject,'Value');
if cbA23
    % save older value
    oldA23 = str2double (get(handles.A23,'String'));
    % disable edid text
    set (handles.A23,'Enable','inactive')
    % calculate A1p3
    A22 = str2double (get(handles.A22,'String'));
    A33= str2double (get(handles.A33,'String'));
    A23 = A22^0.5*A33^0.5;
    % set value
    set (handles.A23,'String',num2str(A23));
    %highlight text field
    set (handles.A23,'BackgroundColor',chHam);
    %highlight panel
    set (handles.uipanelHam,'BackgroundColor',chHam);
    set (handles.textA11,'BackgroundColor',chHam);
    set (handles.textA1p1p,'BackgroundColor',chHam);
    set (handles.textA22,'BackgroundColor',chHam);
    set (handles.textA2p2p,'BackgroundColor',chHam);
    
else
    % enable edid text
    set (handles.A23,'Enable','on')
    % load older value
    set (handles.A23,'String',num2str(oldA23));
    % get values of all other checkboxes
    cbA12=get(handles.cbA12,'Value');
    cbA12p=get(handles.cbA12p,'Value');
    cbA13=get(handles.cbA13,'Value');
    cbA1p2=get(handles.A1p2,'Value');
    cbA1p2p=get(handles.cbA1p2p,'Value');
    cbA1p3=get(handles.cbA1p3,'Value');
    cbA23=get(handles.cbA23,'Value');
    cbA2p3=get(handles.cbA2p3,'Value');
    %reset edit field
    set (handles.A23,'BackgroundColor',colr) ;
    if (cbA12+cbA12p+cbA13+cbA1p2+cbA1p2p+cbA1p3+cbA23+cbA2p3)==0
        %reset panel
        set (handles.uipanelHam,'BackgroundColor',colr);
        set (handles.textA11,'BackgroundColor',colr);
        set (handles.textA1p1p,'BackgroundColor',colr);
        set (handles.textA22,'BackgroundColor',colr);
        set (handles.textA2p2p,'BackgroundColor',colr);
        set (handles.textA33,'BackgroundColor',colr);
    end
end

% --- Executes on button press in cbA12p.
function cbA12p_Callback(hObject, eventdata, handles)
% hObject    handle to cbA12p (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbA12p
% highlight color
chHam = [0.68 0.92 1.0];
% reset color
colr = [0.94 0.94 0.94];
global oldA12p
cbA12p=get(hObject,'Value');
if cbA12p
    % save older value
    oldA12p = str2double (get(handles.A12p,'String'));
    % disable edid text
    set (handles.A12p,'Enable','inactive')
    % calculate A12p
    A11 = str2double (get(handles.A11,'String'));
    A2p2p = str2double (get(handles.A2p2p,'String'));
    A12p = A11^0.5*A2p2p^0.5;
    % set value
    set (handles.A12p,'String',num2str(A12p));
    %highlight text field
    set (handles.A12p,'BackgroundColor',chHam);
    %highlight panel
    set (handles.uipanelHam,'BackgroundColor',chHam);
    set (handles.textA11,'BackgroundColor',chHam);
    set (handles.textA1p1p,'BackgroundColor',chHam);
    set (handles.textA22,'BackgroundColor',chHam);
    set (handles.textA2p2p,'BackgroundColor',chHam);
    
else
    % enable edid text
    set (handles.A12p,'Enable','on')
    % load older value
    set (handles.A12p,'String',num2str(oldA12p));
    %reset edit field
    set (handles.A12p,'BackgroundColor',colr) ;
    % get values of all other checkboxes
    cbA12=get(handles.cbA12,'Value');
    cbA12p=get(handles.cbA12p,'Value');
    cbA13=get(handles.cbA13,'Value');
    cbA1p2=get(handles.A1p2,'Value');
    cbA1p2p=get(handles.cbA1p2p,'Value');
    cbA1p3=get(handles.cbA1p3,'Value');
    cbA23=get(handles.cbA23,'Value');
    cbA2p3=get(handles.cbA2p3,'Value');
    if (cbA12+cbA12p+cbA13+cbA1p2+cbA1p2p+cbA1p3+cbA23+cbA2p3)==0
        %reset panel
        set (handles.uipanelHam,'BackgroundColor',colr);
        set (handles.textA11,'BackgroundColor',colr);
        set (handles.textA1p1p,'BackgroundColor',colr);
        set (handles.textA22,'BackgroundColor',colr);
        set (handles.textA2p2p,'BackgroundColor',colr);
        set (handles.textA33,'BackgroundColor',colr);
    end
end

% --- Executes on button press in cbA2p3.
function cbA2p3_Callback(hObject, eventdata, handles)
% hObject    handle to cbA2p3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbA2p3
% highlight color
chHam = [0.68 0.92 1.0];
% reset color
colr = [0.94 0.94 0.94];
global oldA2p3
cbA2p3=get(hObject,'Value');
if cbA2p3
    % save older value
    oldA2p3 = str2double (get(handles.A2p3,'String'));
    % disable edid text
    set (handles.A2p3,'Enable','inactive')
    % calculate A1p3
    A2p2p = str2double (get(handles.A2p2p ,'String'));
    A33= str2double (get(handles.A33,'String'));
    A2p3 = A2p2p^0.5*A33^0.5;
    % set value
    set (handles.A2p3,'String',num2str(A2p3));
    %highlight text field
    set (handles.A2p3,'BackgroundColor',chHam);
    %highlight panel
    set (handles.uipanelHam,'BackgroundColor',chHam);
    set (handles.textA11,'BackgroundColor',chHam);
    set (handles.textA1p1p,'BackgroundColor',chHam);
    set (handles.textA22,'BackgroundColor',chHam);
    set (handles.textA2p2p,'BackgroundColor',chHam);
    
else
    % enable edid text
    set (handles.A2p3,'Enable','on')
    % load older value
    set (handles.A2p3,'String',num2str(oldA2p3));
    % get values of all other checkboxes
    cbA12=get(handles.cbA12,'Value');
    cbA12p=get(handles.cbA12p,'Value');
    cbA13=get(handles.cbA13,'Value');
    cbA1p2=get(handles.A1p2,'Value');
    cbA1p2p=get(handles.cbA1p2p,'Value');
    cbA1p3=get(handles.cbA1p3,'Value');
    cbA23=get(handles.cbA23,'Value');
    cbA2p3=get(handles.cbA2p3,'Value');
    %reset edit field
    set (handles.A2p3,'BackgroundColor',colr) ;
    if (cbA12+cbA12p+cbA13+cbA1p2+cbA1p2p+cbA1p3+cbA23+cbA2p3)==0
        %reset panel
        set (handles.uipanelHam,'BackgroundColor',colr);
        set (handles.textA11,'BackgroundColor',colr);
        set (handles.textA1p1p,'BackgroundColor',colr);
        set (handles.textA22,'BackgroundColor',colr);
        set (handles.textA2p2p,'BackgroundColor',colr);
        set (handles.textA33,'BackgroundColor',colr);
    end
end

% --- Executes on button press in cbCOATED.
function cbCOATED_Callback(hObject, eventdata, handles)
% hObject    handle to cbCOATED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbCOATED
global atemp
cbCOATED=get(hObject,'Value');
colr = [0.94 0.94 0.94];
if cbCOATED
    %disable calculate profiles
    set(handles.calculateButton,'Enable','off')
    %reset aspect
    set (handles.cbCOATED,'BackgroundColor',colr)
    set (handles.cbCOATED,'ForegroundColor','k');
    %disable hamaker
    set(handles.A132,'Enable','off')
    %save hamaker value
    atemp = get(handles.A132,'String');
    set(handles.A132,'String','N/A')
    set(handles.cbA132,'Enable','off')
    set(handles.cbA132,'Value',0)
    set(handles.uipanelCOATED,'visible','on')
    % enable pbCOATED
    set(handles.pbCOATED,'Enable','on')
    
    % reset Hamaker from fundamentals panel
    set(handles.uipanelA132,'BackgroundColor',colr)
    % disable edit text fields
    set(handles.ve,'Enable','off')
    set(handles.e1,'Enable','off')
    set(handles.n1,'Enable','off')
    set(handles.e2,'Enable','off')
    set(handles.n2,'Enable','off')
    set(handles.e3,'Enable','off')
    set(handles.n3,'Enable','off')
    % reset static text
    set(handles.veTEXT,'BackgroundColor',colr)
    set(handles.e1TEXT,'BackgroundColor',colr)
    set(handles.n1TEXT,'BackgroundColor',colr)
    set(handles.e2TEXT,'BackgroundColor',colr)
    set(handles.n2TEXT,'BackgroundColor',colr)
    set(handles.e3TEXT,'BackgroundColor',colr)
    set(handles.n3TEXT,'BackgroundColor',colr)
    set(handles.A132TEXT,'BackgroundColor',colr)
    %disable calcA132 and pbCOATED buttons
    set(handles.calcA132,'Enable','off')
    set(handles.pbCOATED,'Enable','off')
    %activate manual input
    set (handles.A132,'Enable','on');
    set (handles.A132,'BackgroundColor','white');
    %deactivate calculated edit
    set (handles.A132calc,'Enable','off');
    set (handles.A132calc,'String','calculate');
    set (handles.A132,'BackgroundColor','white');
    %check if roughness mode is active
    cbRmode1 = get(handles.cbRmode1,'Value');
    cbRmode2 = get(handles.cbRmode2,'Value');
    cbRmode3 = get(handles.cbRmode3,'Value');
    if cbRmode1+cbRmode2+cbRmode3>0
        % reset value
        set(handles.cbRmode0,'Value',1);
        set(handles.cbRmode1,'Value',0);
        set(handles.cbRmode2,'Value',0);
        set(handles.cbRmode3,'Value',0);
        % indicate checkbox color change
        set(handles.cbRmode0,'ForegroundColor','r');
        % alert user with message
        msg_cancel_roughness
    end
    %reset asperity height value
    set(handles.aasp,'String','0.0');
else
    set(handles.A132,'Enable','on')
    set(handles.A132,'String',atemp)
    set(handles.cbA132,'Enable','on')
    %disable pbCOATED
    set(handles.pbCOATED,'Enable','off')
    set(handles.uipanelCOATED,'visible','off')
    %% enable/disable calculate profiles if all conditions apply
    % initialize flag
    calcFLAG = 1;
    % get checkboxes values
    cbCOATED = get(handles.cbCOATED,'Value');
    cbA132 = get(handles.cbA132,'Value');
    cbgammaAB = get(handles.cbgammaAB,'Value');
    cbW132 = get(handles.cbW132,'Value');
    cbacont = get(handles.cbacont,'Value');
    % evaluate each checkbox
    if cbCOATED+cbA132+cbgammaAB+cbW132+cbacont==0
        %enable
        calcFLAG =1;
    else
        if cbA132==1
            if isnan(str2double(get(handles.A132calc,'String')))
                calcFLAG = 0;
            end
        end
        if cbgammaAB==1
            if isnan(str2double(get(handles.gammaABcalc,'String')))
                calcFLAG = 0;
            end
        end
        if cbW132==1
            if isnan(str2double(get(handles.W132calc,'String')))
                calcFLAG = 0;
            end
        end
        if cbacont==1
            if isnan(str2double(get(handles.acontCALC,'String')))
                calcFLAG = 0;
            end
        end
    end
    if calcFLAG ==1
        set(handles.calculateButton,'Enable','on')
    else
        set(handles.calculateButton,'Enable','off')
    end
    %%
end


% --- Executes on button press in cbUNCOATED.
function cbUNCOATED_Callback(hObject, eventdata, handles)
% hObject    handle to cbUNCOATED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbUNCOATED
cbUNCOATED = get(hObject,'Value');
if cbUNCOATED
    set(handles.cbCOATED,'Value',0)
else
    set(handles.cbCOATED,'Value',1)
end

% --- Executes during object creation, after setting all properties.
function uipanelUNCOATED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanelUNCOATED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function g1LWTEXT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to g1LWTEXT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pbCLOSEcoated.
function pbCLOSEcoated_Callback(hObject, eventdata, handles)
% hObject    handle to pbCLOSEcoated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global atemp
% check if hamaker constant contrbutions were calculated, otherwise
% indicate user that coated system parameters will not be used and reset
% checkbox in main panel
% determine if coating system hamaker constant contributions were calulated
c1 = str2double(get(handles.s1A1p2p,'String'));
c2 = str2double(get(handles.s2A12p,'String'));
c3 = str2double(get(handles.s3A1p2,'String'));
%  let user know that calculate has to be pressed before accepting values
if isnan(c1)&&isnan(c2)&&isnan(c3)
    set(handles.uipanelCOATED,'visible','off');
    set (handles.cbCOATED,'Value',0);
    set (handles.cbCOATED,'ForegroundColor','r');
    msg_cancel_coating;
    set(handles.A132,'Enable','on');
    set(handles.A132,'String',atemp);
    set(handles.cbA132,'Enable','on');
else
    set(handles.uipanelCOATED,'visible','off')
    set(handles.calculateButton,'Enable','on')
end


% --- Executes during object creation, after setting all properties.
function uipanelS1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanelS1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uipanelS2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanelS2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uipanelS3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanels3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text2S3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2S3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text1S3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1S3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text1S2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1S2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text2S2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2S2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text1S1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1S1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text2S1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2S1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text3S1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3S1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text4S1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4S1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pbCalcCoated.
function pbCalcCoated_Callback(hObject, eventdata, handles)
% hObject    handle to pbCalcCoated (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global system
global T1 T2 A33
global A11 A1p1p A22 A2p2p
global A12 A12p A13 A1p2 A1p2p A1p3 A23 A2p3
global s1A1p2p s1A12p s1A1p2 s1A12
global s2A12p s2A12
global s3A1p2 s3A12
colr =[0.94 0.94 0.94];
colhs = 1/255*[186 255 150];
chHam = [0.68 0.92 1.0];
% get type of coating system
cb1=get(handles.cb1,'Value');
cb2=get(handles.cb2,'Value');
cb3=get(handles.cb3,'Value');
% layered colloid - layered collector
if cb1
    system =1;
end
% colloid - layered collector
if cb2
    system =2;
end
% layered colloid - collector
if cb3
    system =3;
end

%% get coating thickness and fluid hamaker
T1 = str2double(get(handles.T1,'String'));
T2 = str2double(get(handles.T2,'String'));
A33 = str2double(get(handles.A33,'String'));
%% recalculate combined Hamakers if needed otherwise load from edit texts
if get(handles.cbA12,'Value')
    A12 = (str2double(get(handles.A11,'String')))^0.5*...
        (str2double(get(handles.A22,'String')))^0.5;
    set (handles.A12,'BackgroundColor',chHam);
else
    A12 = str2double(get(handles.A12,'String'));
    set (handles.A12,'BackgroundColor','white');
end
if get(handles.cbA12p,'Value')
    A12p = (str2double(get(handles.A11,'String')))^0.5*...
        (str2double(get(handles.A2p2p,'String')))^0.5;
    set (handles.A12p,'BackgroundColor',chHam);
else
    A12p = str2double(get(handles.A12p,'String'));
    set (handles.A12p,'BackgroundColor','white');
end
if get(handles.cbA13,'Value')
    A13 = (str2double(get(handles.A11,'String')))^0.5*...
        (str2double(get(handles.A33,'String')))^0.5;
    set (handles.A13,'BackgroundColor',chHam);
else
    A13 = str2double(get(handles.A13,'String'));
    set (handles.A13,'BackgroundColor','white');
end
if get(handles.cbA1p2,'Value')
    A1p2 = (str2double(get(handles.A1p1p,'String')))^0.5*...
        (str2double(get(handles.A22,'String')))^0.5;
    set (handles.A1p2,'BackgroundColor',chHam);
else
    A1p2 = str2double(get(handles.A1p2,'String'));
    set (handles.A1p2,'BackgroundColor','white');
end
if get(handles.cbA1p2p,'Value')
    A1p2p = (str2double(get(handles.A1p1p,'String')))^0.5*...
        (str2double(get(handles.A2p2p,'String')))^0.5;
    set (handles.A1p2p,'BackgroundColor',chHam);
else
    A1p2p = str2double(get(handles.A1p2p,'String'));
    set (handles.A1p2p,'BackgroundColor','white');
end
if get(handles.cbA1p3,'Value')
    A1p3 = (str2double(get(handles.A1p1p,'String')))^0.5*...
        (str2double(get(handles.A33,'String')))^0.5;
    set (handles.A1p3,'BackgroundColor',chHam);
else
    A1p3 = str2double(get(handles.A1p3,'String'));
    set (handles.A1p3,'BackgroundColor','white');
end
if get(handles.cbA23,'Value')
    A23 = (str2double(get(handles.A22,'String')))^0.5*...
        (str2double(get(handles.A33,'String')))^0.5;
    set (handles.A23,'BackgroundColor',chHam);
else
    A23 = str2double(get(handles.A23,'String'));
    set (handles.A23,'BackgroundColor','white');
end
if get(handles.cbA2p3,'Value')
    A2p3 = (str2double(get(handles.A2p2p,'String')))^0.5*...
        (str2double(get(handles.A33,'String')))^0.5;
    set (handles.A2p3,'BackgroundColor',chHam);
else
    A2p3 = str2double(get(handles.A2p3,'String'));
    set (handles.A2p3,'BackgroundColor','white');
end
% A11 A1p1p A22 A2p2p A33
% A12 A12p A13 A1p2 A1p2p A1p3 A23 A2p3

%% for system 1
if system==1
    % calculate hamaker constant contributions
    s1A1p2p = A1p2p-A2p3-A1p3+A33;
    s1A12p = A12p-A1p2p-A13+A1p3;
    s1A1p2 = A1p2-A23-A1p2p+A2p3;
    s1A12 = A12-A1p2-A12p+A1p2p;
    %update fields
    set (handles.s1A1p2p,'String',num2str(s1A1p2p));
    set (handles.s1A12p,'String',num2str(s1A12p));
    set (handles.s1A1p2,'String',num2str(s1A1p2));
    set (handles.s1A12,'String',num2str(s1A12));
else
    set (handles.s1A1p2p,'String','calculate');
    set (handles.s1A12p,'String','calculate');
    set (handles.s1A1p2,'String','calculate');
    set (handles.s1A12,'String','calculate');
    
end
if system==2
    % calculate hamaker constant contributions
    s2A12p = A12p-A2p3-A13+A33;
    s2A12 = A12-A23-A12p+A33;
    %update fields
    set (handles.s2A12p,'String',num2str(s2A12p));
    set (handles.s2A12,'String',num2str(s2A12));
else
    set (handles.s2A12p,'String','calculate');
    set (handles.s2A12,'String','calculate');
end
if system==3
    % calculate hamaker constant contribution
    s3A1p2 = A1p2-A23-A1p3+A33;
    s3A12 = A12-A1p2-A13+A1p3;
    %update fields
    set (handles.s3A1p2,'String',num2str(s3A1p2));
    set (handles.s3A12,'String',num2str(s3A12));
else
    set (handles.s3A1p2,'String','calculate');
    set (handles.s3A12,'String','calculate');
end


% --- Executes on button press in pbOKcoating.
function pbOKcoating_Callback(hObject, eventdata, handles)
% hObject    handle to pbOKcoating (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% determine if coating system hamaker constant contributions were calulated
c1 = str2double(get(handles.s1A1p2p,'String'));
c2 = str2double(get(handles.s2A12p,'String'));
c3 = str2double(get(handles.s3A1p2,'String'));
%  let user know that calculate has to be pressed before accepting values
if isnan(c1)&&isnan(c2)&&isnan(c3)
    msg_not_calculated_values
else
    set(handles.uipanelCOATED,'visible','off')
    %enable calculate profiles
    set(handles.calculateButton,'Enable','on')
end




function outputname_Callback(hObject, eventdata, handles)
% hObject    handle to outputname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputname as text
%        str2double(get(hObject,'String')) returns contents of outputname as a double


% --- Executes during object creation, after setting all properties.
function outputname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in savebutton.
function savebutton_Callback(hObject, eventdata, handles)
% hObject    handle to savebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% start waitbar
h = waitbar(0,'Saving data to file');
% output parameters
global H EJ Ekt F dname
global cbHET cbHETUSER EhetT FhetT
%% input parameters
global  a1 a2 IS zetac zetap aasp sigmac T
global lambdaVDW lambdaAB lambdaSTE gammaSTE epsilonR z A132
global SP SS Rmode VDWmode
% global vdw from fundamentals
global ve e1 n1 e2 n2 e3 n3 A132calc
% global vdw coated systems
global T1 T2 A33 %coating thickness and fluid Hamaker
global A12  A12p A13  A1p2  A1p2p A1p3 A23 A2p3 %combined Hamaker
global A12c A12pc A13c A1p2c  A1p2pc A1p3c A23c A2p3c  %combined Hamaker calculated
global A11 A1p1p A22 A2p2p % single materials Hamaker
global s1A1p2p s1A12p s1A1p2 s1A12 s2A12p s2A12 s3A1p2 s3A12 % hamaker constributions
%acid-base energy fundamentals
global g1pos g1neg g2pos g2neg g3pos g3neg gammaABcalc gammaAB
%work of adhesion fundamentals
global g1LW g2LW g3LW INDgammaAB W132calc W132
%aconr for steric fundamentals
global E1 E2 v1 v2 INDW132  Kint acontCALC  acont
% checkboxes
global cbCOATED cbA132  cbgammaAB cbW132 cbacont
global cb1 cb2 cb3
% pass hetdomain radii and afract
global rhetv names  afvector rZOI

%% WRITE TO FILE
filecount = 1;
filename1 = strcat(dname,'\001_output_xDLVO.xls');
% delete previous output file
while exist(filename1, 'file')==2
    %   delete(filename1);
    filecount=filecount+1;
    strcount = strcat('00',num2str(filecount));
    filename1 = strcat(dname,'\',strcount,'_output_xDLVO.xls');
end
filename1
%headers for Energy and Force
col_headerE={'H(m)','E_van_der_Waals','E_EDL','E_AB','E_Born','E_Steric','E_total'};
col_headerF={'H(m)','F_van_der_Waals','F_EDL','F_AB','F_Born','F_Steric','F_total'}; %Row cell array (for column labels)
% col_headerEhet={'H(m)','AFRACT_0.25_ZOI','AFRACT_0.5_ZOI','AFRACT_0.75_ZOI','AFRACT_1.0_ZOI'};
% col_headerFhet={'H(m)','AFRACT_0.25_ZOI','AFRACT_0.5_ZOI','AFRACT_0.75_ZOI','AFRACT_1.0_ZOI'};
if cbHET||cbHETUSER
    % col_headerEhet = {"H(m)",names(1),names(2),names(3),names(4)};
    % col_headerFhet = {"H(m)",names(1),names(2),names(3),names(4)};
    col_headerEhet = {"RHET(m)",rhetv(1),rhetv(2),rhetv(3),rhetv(4)};
    col_headerFhet = {"RHET(m)",rhetv(1),rhetv(2),rhetv(3),rhetv(4)};
    col_headerEhet2 = {"AFRACT",afvector(1),afvector(2),afvector(3),afvector(4)};
    col_headerFhet2 = {"AFRACT",afvector(1),afvector(2),afvector(3),afvector(4)};
    hcell{1} = "H(m)";
end
%% parameter values
par_cell=fpar_out_xDLVO();
waitbar(0.1,h) % show saving progress

%%  write parameters

%% write data
xlswrite(filename1,par_cell,'Input_Parameters');     %Write data    %Column cell array (for row labels)
xlswrite(filename1,col_headerE,'Energy(J)','A1');     %Write column header
waitbar(0.25,h) % show saving progress
xlswrite(filename1,H','Energy(J)','A2');     %Write H,as a column
xlswrite(filename1,EJ,'Energy(J)','B2');     %Write Energy J
waitbar(0.50,h) % show saving progress
xlswrite(filename1,col_headerE,'Energy(kT)','A1');     %Write column header
xlswrite(filename1,H','Energy(kT)','A2');     %Write H,as a column
xlswrite(filename1,Ekt,'Energy(kT)','B2');     %Write Energy kt
waitbar(0.75,h) % show saving progress
xlswrite(filename1,col_headerF,'Force(N)','A1');     %Write column header
xlswrite(filename1,H','Force(N)','A2');     %Write H,as a column
xlswrite(filename1,F,'Force(N)','B2');     %Write Force N
if cbHET||cbHETUSER
    xlswrite(filename1,col_headerEhet,'HET_Energy(kT)','A1');     %Write column header2
    xlswrite(filename1,col_headerEhet2,'HET_Energy(kT)','A2');
    xlswrite(filename1,hcell,'HET_Energy(kT)','A3');
    xlswrite(filename1,H','HET_Energy(kT)','A4');     %Write H,as a column
    xlswrite(filename1,EhetT,'HET_Energy(kT)','B4');     %Write Energy kt
    waitbar(0.82,h) % show saving progress
    xlswrite(filename1,col_headerFhet,'HET_Force(N)','A1');     %Write column header2
    xlswrite(filename1,col_headerFhet2,'HET_Force(N)','A2');
    xlswrite(filename1,hcell,'HET_Force(N)','A3');
    xlswrite(filename1,H','HET_Force(N)','A4');     %Write H,as a column
    xlswrite(filename1,FhetT,'HET_Force(N)','B4');     %Write Force N
end
waitbar(1.0,h) % show saving progress
% xlswrite(filename1,row_header,'Energy','A2');      %Write row header
% A = {'Time','Temperature'; 12,98; 13,99; 14,97};
% sheet = 2;
% xlRange = 'E1';
% xlswrite(filename1,A,sheet,xlRange)
disp('Output Complete');
close(h)
set(handles.savebutton,'Enable','off')
% msg_readyBTC_PROF;
set(handles.calculateButton,'BackgroundColor',[0,1,1])
set(handles.savebutton,'BackgroundColor',[0,1,0])



% --- Executes on button press in ppClosePlots.
function ppClosePlots_Callback(hObject, eventdata, handles)
% hObject    handle to ppClosePlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanelPLOTS,'Visible','off')
aux = get(handles.cbHET,'Value');
if aux
    %     close (2)
end
% reset main panel backgorund color to avoid white background glitch
% set(handles.figure1,'BackgroundColor','r')
% set ( 0, 'DefaultFigureColor', [1 0 0] )
% set(handles.figure1,'BackgroundColor',[0.94 0.94 0.94])


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uipanelPLOTS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanelPLOTS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on slider movement.
function sliderEx_Callback(hObject, eventdata, handles)
% hObject    handle to sliderEx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
xl = get(handles.sliderEx,'Value');
set (handles.axesE,'Xlim',[0 xl])
set (handles.Xemax,'String',num2str(xl))



% --- Executes during object creation, after setting all properties.
function sliderEx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderEx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Xemax_Callback(hObject, eventdata, handles)
% hObject    handle to Xemax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hmaxdef
% Hints: get(hObject,'String') returns contents of Xemax as text
%        str2double(get(hObject,'String')) returns contents of Xemax as a double
xl=get(hObject,'String');
xl =str2double(xl);
%catch errors in user input
if isnan(xl)
    xl = hmaxdef;
else
    if xl<1
        xl=1;
    end
    if xl>1000
        xl = 1000;
    end
end
set(handles.sliderEx,'Value',xl)
set (handles.axesE,'Xlim',[0 xl])
set(hObject,'String',num2str(xl))


% --- Executes during object creation, after setting all properties.
function Xemax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xemax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function sliderFx_Callback(hObject, eventdata, handles)
% hObject    handle to sliderFx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
xl = get(handles.sliderFx,'Value');
set (handles.axesF,'Xlim',[0 xl])
set (handles.Xfmax,'String',num2str(xl))

% --- Executes during object creation, after setting all properties.
function sliderFx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderFx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function Xfmax_Callback(hObject, eventdata, handles)
% hObject    handle to Xfmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hmaxdef
% Hints: get(hObject,'String') returns contents of Xfmax as text
%        str2double(get(hObject,'String')) returns contents of Xfmax as a double
xl=get(hObject,'String');
xl =str2double(xl);
%catch errors in user input
if isnan(xl)
    xl = hmaxdef;
else
    if xl<1
        xl=1;
    end
    if xl>1000
        xl = 1000;
    end
end
set(handles.sliderFx,'Value',xl)
set (handles.axesF,'Xlim',[0 xl])
set(hObject,'String',num2str(xl))

% --- Executes during object creation, after setting all properties.
function Xfmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xfmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Yemax_Callback(hObject, eventdata, handles)
% hObject    handle to Yemax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global limvekt
% Hints: get(hObject,'String') returns contents of Yemax as text
%        str2double(get(hObject,'String')) returns contents of Yemax as a double
Yemax = str2double(get(handles.Yemax,'String'));
Yemin = str2double(get(handles.Yemin,'String'));
%check user input errors
if isnan(Yemax)||(Yemax==0&&Yemin==0)
    Yemax = limvekt;
    Yemin = -limvekt;
else
    if Yemax<=Yemin
        Yemax = abs(Yemax);
        Yemin = -Yemax;
    end
end
% set Yaxis
set(handles.axesE,'Ylim',[Yemin Yemax])
% set text values
set(handles.Yemax,'String',num2str(Yemax))
set(handles.Yemin,'String',num2str(Yemin))

% --- Executes during object creation, after setting all properties.
function Yemax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Yemax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Yemin_Callback(hObject, eventdata, handles)
% hObject    handle to Yemin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Yemin as text
%        str2double(get(hObject,'String')) returns contents of Yemin as a double
global limvekt
% Hints: get(hObject,'String') returns contents of Yemax as text
%        str2double(get(hObject,'String')) returns contents of Yemax as a double
Yemax = str2double(get(handles.Yemax,'String'));
Yemin = str2double(get(handles.Yemin,'String'));
%check user input errors
if isnan(Yemin)||(Yemax==0&&Yemin==0)
    Yemax = limvekt;
    Yemin = -limvekt;
else
    if Yemax<=Yemin
        Yemax = abs(Yemax);
        Yemin = -Yemax;
    end
end
% set Yaxis
set(handles.axesE,'Ylim',[Yemin Yemax])
% set text values
set(handles.Yemax,'String',num2str(Yemax))
set(handles.Yemin,'String',num2str(Yemin))

% --- Executes during object creation, after setting all properties.
function Yemin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Yemin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Yfmax_Callback(hObject, eventdata, handles)
% hObject    handle to Yfmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Yfmax as text
%        str2double(get(hObject,'String')) returns contents of Yfmax as a double
global limvf
% Hints: get(hObject,'String') returns contents of Yemax as text
%        str2double(get(hObject,'String')) returns contents of Yemax as a double
Yfmax = str2double(get(handles.Yfmax,'String'));
Yfmin = str2double(get(handles.Yfmin,'String'));
%check user input errors
if isnan(Yfmax)||(Yfmax==0&&Yfmin==0)
    Yfmax = limvf;
    Yfmin = -limvf;
else
    if Yfmax<=Yfmin
        Yfmax = abs(Yfmax);
        Yfmin = -Yfmax;
    end
end
% set Yaxis
set(handles.axesF,'Ylim',[Yfmin Yfmax])
% set text values
set(handles.Yfmax,'String',num2str(Yfmax))
set(handles.Yfmin,'String',num2str(Yfmin))

% --- Executes during object creation, after setting all properties.
function Yfmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Yfmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Yfmin_Callback(hObject, eventdata, handles)
% hObject    handle to Yfmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Yfmin as text
%        str2double(get(hObject,'String')) returns contents of Yfmin as a double
global limvf
% Hints: get(hObject,'String') returns contents of Yemax as text
%        str2double(get(hObject,'String')) returns contents of Yemax as a double
Yfmax = str2double(get(handles.Yfmax,'String'));
Yfmin = str2double(get(handles.Yfmin,'String'));
%check user input errors
if isnan(Yfmin)||(Yfmax==0&&Yfmin==0)
    Yfmax = limvf;
    Yfmin = -limvf;
else
    if Yfmax<=Yfmin
        Yfmax = abs(Yfmax);
        Yfmin = -Yfmax;
    end
end
% set Yaxis
set(handles.axesF,'Ylim',[Yfmin Yfmax])
% set text values
set(handles.Yfmax,'String',num2str(Yfmax))
set(handles.Yfmin,'String',num2str(Yfmin))

% --- Executes during object creation, after setting all properties.
function Yfmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Yfmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in gridE.
function gridE_Callback(hObject, eventdata, handles)
% hObject    handle to gridE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of gridE
g=get(hObject,'Value');
if g
    set(handles.axesE,'XGrid','on');
    set(handles.axesE,'YGrid','on');
else
    set(handles.axesE,'XGrid','off');
    set(handles.axesE,'YGrid','off');
end

% --- Executes on button press in gridF.
function gridF_Callback(hObject, eventdata, handles)
% hObject    handle to gridF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of gridF
g=get(hObject,'Value');
if g
    set(handles.axesF,'XGrid','on');
    set(handles.axesF,'YGrid','on');
else
    set(handles.axesF,'XGrid','off');
    set(handles.axesF,'YGrid','off');
end


% --- Executes on button press in cbHET.
function cbHET_Callback(hObject, eventdata, handles)
% hObject    handle to cbHET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbHET
global cbMEAN cbHET cbHETPLOTS cbHETUSER
% Hint: get(hObject,'Value') returns toggle state of cbMEAN
cbHET=get(hObject,'Value');
if cbHET
    set(handles.cbMEAN,'Value',0)
    set(handles.cbHETUSER,'Value',0)
    % enable fields
    set(handles.zetahet,'Enable','on')
    set(handles.rhet1,'ForegroundColor','r')
    set(handles.rhet2,'ForegroundColor','r')
    set(handles.rhet3,'ForegroundColor','r')
    set(handles.rhet4,'ForegroundColor','r')
    % disable user rhet fields
    set(handles.rhet1USER,'String','calculate')
    set(handles.rhet1USER,'ForegroundColor','k')
    set(handles.rhet2USER,'String','calculate')
    set(handles.rhet2USER,'ForegroundColor','k')
    set(handles.rhet3USER,'String','calculate')
    set(handles.rhet3USER,'ForegroundColor','k')
    set(handles.rhet4USER,'String','calculate')
    set(handles.rhet4USER,'ForegroundColor','k')
    set(handles.rhet1USER,'Enable','off')
    set(handles.rhet2USER,'Enable','off')
    set(handles.rhet3USER,'Enable','off')
    set(handles.rhet4USER,'Enable','off')
    % enable hetdomain plots checkbox
    set(handles.cbHETPLOTS,'Visible','on')
    set(handles.cbHETPLOTS,'Value',1)
else
    set(handles.cbMEAN,'Value',1)
    % disable fields for rhet ZOI areal fractions
    set(handles.zetahet,'Enable','off')
    set(handles.rhet1,'String','calculate')
    set(handles.rhet1,'ForegroundColor','k')
    set(handles.rhet2,'String','calculate')
    set(handles.rhet2,'ForegroundColor','k')
    set(handles.rhet3,'String','calculate')
    set(handles.rhet3,'ForegroundColor','k')
    set(handles.rhet4,'String','calculate')
    set(handles.rhet4,'ForegroundColor','k')
    % disable fields for user specified rhet
    set(handles.zetahet,'Enable','off')
    set(handles.rhet1USER,'String','calculate')
    set(handles.rhet1USER,'ForegroundColor','k')
    set(handles.rhet2USER,'String','calculate')
    set(handles.rhet2USER,'ForegroundColor','k')
    set(handles.rhet3USER,'String','calculate')
    set(handles.rhet3USER,'ForegroundColor','k')
    set(handles.rhet4USER,'String','calculate')
    set(handles.rhet4USER,'ForegroundColor','k')
    set(handles.rhet1USER,'Enable','off')
    set(handles.rhet2USER,'Enable','off')
    set(handles.rhet3USER,'Enable','off')
    set(handles.rhet4USER,'Enable','off')
    % disable hetdomain plots checkbox
    set(handles.cbHETPLOTS,'Visible','off')
    set(handles.cbHETPLOTS,'Value',0)
end

% --- Executes on button press in cbMEAN.
function cbMEAN_Callback(hObject, eventdata, handles)
% hObject    handle to cbMEAN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cbMEAN cbHET cbHETUSER
% Hint: get(hObject,'Value') returns toggle state of cbMEAN
cbMEAN=get(hObject,'Value');
if cbMEAN
    set(handles.cbHET,'Value',0)
    set(handles.cbHETUSER,'Value',0)
    % disable fields
    set(handles.zetahet,'Enable','off')
    % disable areal ZOI rhet
    set(handles.rhet1,'String','calculate')
    set(handles.rhet1,'ForegroundColor','k')
    set(handles.rhet2,'String','calculate')
    set(handles.rhet2,'ForegroundColor','k')
    set(handles.rhet3,'String','calculate')
    set(handles.rhet3,'ForegroundColor','k')
    set(handles.rhet4,'String','calculate')
    set(handles.rhet4,'ForegroundColor','k')
    % disable fields for user specified rhet
    set(handles.rhet1USER,'String','calculate')
    set(handles.rhet1USER,'ForegroundColor','k')
    set(handles.rhet2USER,'String','calculate')
    set(handles.rhet2USER,'ForegroundColor','k')
    set(handles.rhet3USER,'String','calculate')
    set(handles.rhet3USER,'ForegroundColor','k')
    set(handles.rhet4USER,'String','calculate')
    set(handles.rhet4USER,'ForegroundColor','k')
    set(handles.rhet1USER,'Enable','off')
    set(handles.rhet2USER,'Enable','off')
    set(handles.rhet3USER,'Enable','off')
    set(handles.rhet4USER,'Enable','off')
    % disable hetdomain plots checkbox
    set(handles.cbHETPLOTS,'Visible','off')
    set(handles.cbHETPLOTS,'Value',0)
else
    set(handles.cbHET,'Value',1)
    % enable fields
    set(handles.zetahet,'Enable','on')
    % enable fields
    set(handles.zetahet,'Enable','on')
    set(handles.rhet1,'ForegroundColor','r')
    set(handles.rhet2,'ForegroundColor','r')
    set(handles.rhet3,'ForegroundColor','r')
    set(handles.rhet4,'ForegroundColor','r')
    % enable hetdomain plots checkbox
    set(handles.cbHETPLOTS,'Visible','on')
    set(handles.cbHETPLOTS,'Value',1)
end




function zetahet_Callback(hObject, eventdata, handles)
% hObject    handle to zetahet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zetahet as text
%        str2double(get(hObject,'String')) returns contents of zetahet as a double


% --- Executes during object creation, after setting all properties.
function zetahet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zetahet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhet_Callback(hObject, eventdata, handles)
% hObject    handle to rhet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet as text
%        str2double(get(hObject,'String')) returns contents of rhet as a double


% --- Executes during object creation, after setting all properties.
function rhet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rZOI_Callback(hObject, eventdata, handles)
% hObject    handle to rZOI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rZOI as text
%        str2double(get(hObject,'String')) returns contents of rZOI as a double


% --- Executes during object creation, after setting all properties.
function rZOI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rZOI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axesE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axesE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axesE


% --- Executes on button press in pbRVIEW.
function pbRVIEW_Callback(hObject, eventdata, handles)
% hObject    handle to pbRVIEW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uipanelCOATED,'visible','off')
set(handles.uipanelPLOTS,'visible','off')
set(handles.BGpanel,'visible','on')

global atemp
% check if hamaker constant contrbutions were calculated, otherwise
% indicate user that coated system parameters will not be used and reset
% checkbox in main panel
cb = get(handles.cbCOATED,'Value');
if cb
    % determine if coating system hamaker constant contributions were calulated
    c1 = str2double(get(handles.s1A1p2p,'String'));
    c2 = str2double(get(handles.s2A12p,'String'));
    c3 = str2double(get(handles.s3A1p2,'String'));
    %  let user know that calculate has to be pressed before accepting values
    if isnan(c1)&&isnan(c2)&&isnan(c3)
        set(handles.uipanelCOATED,'visible','off');
        set (handles.cbCOATED,'Value',0);
        set (handles.cbCOATED,'ForegroundColor','r');
        msg_cancel_coating;
        set(handles.A132,'Enable','on');
        set(handles.A132,'String',atemp);
        set(handles.cbA132,'Enable','on');
    else
        set(handles.uipanelCOATED,'visible','off')
        set(handles.calculateButton,'Enable','on')
    end
end


% --- Executes on button press in pb_setdir.
function pb_setdir_Callback(hObject, eventdata, handles)
% hObject    handle to pb_setdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dname
%% Create OUTPUT directory to write output profile, and sim parameters
% %  create string from output directory
% OUTDIR=get(handles.outputname,'String');
OUTDIR='Output_xDLVO';
outs = strcat('\',OUTDIR,'\');
% % set working directory
if ~isdeployed
    % MATLAB environment
    mname = mfilename('fullpath');
    outputpath = strrep(mname,'\GUIxDLVO','\')
    %     mkdir(outputpath,OUTDIR);
    %     outputdir = strrep(mfilename('fullpath'),'\GUIxDLVO',outs);
else
    %deployed application
    outputpath=pwd
    %     mkdir(outputpath,OUTDIR);
    %     outputdir=strcat(outputpath,outs);
end
dname = uigetdir(outputpath,'Select Output Directory');
if dname==0
    dname= outputpath;
end
% %% enable save button
% set(handles.savebutton,'Enable','on')
% chasnge color calculate profile
set(handles.calculateButton,'BackgroundColor',[0,1,1])


function rhet02_Callback(hObject, eventdata, handles)
% hObject    handle to rhet02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet02 as text
%        str2double(get(hObject,'String')) returns contents of rhet02 as a double


% --- Executes during object creation, after setting all properties.
function rhet02_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet02 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhet04_Callback(hObject, eventdata, handles)
% hObject    handle to rhet04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet04 as text
%        str2double(get(hObject,'String')) returns contents of rhet04 as a double


% --- Executes during object creation, after setting all properties.
function rhet04_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet04 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhet06_Callback(hObject, eventdata, handles)
% hObject    handle to rhet06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet06 as text
%        str2double(get(hObject,'String')) returns contents of rhet06 as a double


% --- Executes during object creation, after setting all properties.
function rhet06_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet06 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhet08_Callback(hObject, eventdata, handles)
% hObject    handle to rhet08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet08 as text
%        str2double(get(hObject,'String')) returns contents of rhet08 as a double


% --- Executes during object creation, after setting all properties.
function rhet08_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet08 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbHETPLOTS.
function cbHETPLOTS_Callback(hObject, eventdata, handles)
% hObject    handle to cbHETPLOTS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbHETPLOTS
global EhetT FhetT Hnm Ekt F lw cbHETPLOTS names
% get toggle value
cbHETPLOTS =  get(handles.cbHETPLOTS,'Value');
% get grid values
gridE = get(handles.gridE,'Value');
gridF = get(handles.gridF,'Value');
% get limit values
Yemax =  str2double(get(handles.Yemax,'String'));
Yfmax =  str2double(get(handles.Yfmax,'String'));
Yemin =  str2double(get(handles.Yemin,'String'));
Yfmin =  str2double(get(handles.Yfmin,'String'));
Xemax =  str2double(get(handles.Xemax,'String'));
Xfmax =  str2double(get(handles.Xfmax,'String'));
% activate or deactivate hetdomain influence plots
if cbHETPLOTS
    % plot mean field and hetdomains profiles
    %% Energy plots
    axes(handles.axesE);
    hold off;
    plot (Hnm,EhetT(:,1),'-b','LineWidth',lw)
    hold on;
    plot (Hnm,EhetT(:,2),'-r','LineWidth',lw)
    plot (Hnm,EhetT(:,3),'-g','LineWidth',lw)
    plot (Hnm,EhetT(:,4),'-m','LineWidth',lw)
    plot (Hnm,Ekt(:,6),'--k','LineWidth',lw+0.5)
    axis([0.0 Xemax Yemin Yemax])
    legend(names)
    xlabel('Separation Distance   (nm)');ylabel('Total Energy   (kT)');
    set(axes,'Fontsize',40);
    set(legend,'Fontsize',60);
    % keep grid state
    if gridE
        set(handles.axesE,'XGrid','on');
        set(handles.axesE,'YGrid','on');
    else
        set(handles.axesE,'XGrid','off');
        set(handles.axesE,'YGrid','off');
    end
    hold off;
    %
    %% Force plot
    axes(handles.axesF);
    hold off
    plot (Hnm,FhetT(:,1),'-b','LineWidth',lw)
    hold on;
    plot (Hnm,FhetT(:,2),'-r','LineWidth',lw)
    plot (Hnm,FhetT(:,3),'-g','LineWidth',lw)
    plot (Hnm,FhetT(:,4),'-m','LineWidth',lw)
    plot (Hnm,F(:,6),'--k','LineWidth',lw+0.5)
    axis([0.0 Xfmax Yfmin Yfmax])
    legend(names)
    xlabel('Separation Distance   (nm)');ylabel('Total Force   (N)');
    set(axes,'Fontsize',40);
    set(legend,'Fontsize',60);
    % keep grid state
    if gridF
        set(handles.axesF,'XGrid','on');
        set(handles.axesF,'YGrid','on');
    else
        set(handles.axesF,'XGrid','off');
        set(handles.axesF,'YGrid','off');
    end
    hold off;
else
    % plot mean field only
    %% Energy plot
    axes(handles.axesE);
    hold off
    plot (Hnm,Ekt(:,1),'-b','LineWidth',lw)
    hold on;
    plot (Hnm,Ekt(:,2),'-r','LineWidth',lw)
    plot (Hnm,Ekt(:,3),'-g','LineWidth',lw)
    plot (Hnm,Ekt(:,4),'-m','LineWidth',lw)
    plot (Hnm,Ekt(:,5),'-','LineWidth',lw,'Color',[255/255 165/255 0])
    plot (Hnm,Ekt(:,6),'--k','LineWidth',lw+0.5)
    axis([0.0 Xemax Yemin Yemax])
    legend('van der Waals','EDL','Acid-Base','Born','Steric','Total')
    xlabel('Separation Distance   (nm)');ylabel('Energy   (kT)');
    set(axes,'Fontsize',40);
    set(legend,'Fontsize',60);
    % keep grid state
    if gridE
        set(handles.axesE,'XGrid','on');
        set(handles.axesE,'YGrid','on');
    else
        set(handles.axesE,'XGrid','off');
        set(handles.axesE,'YGrid','off');
    end
    hold off;
    %% Force plot
    %
    axes(handles.axesF);
    hold off
    plot (Hnm,F(:,1),'-b','LineWidth',lw)
    hold on;
    plot (Hnm,F(:,2),'-r','LineWidth',lw)
    plot (Hnm,F(:,3),'-g','LineWidth',lw)
    plot (Hnm,F(:,4),'-m','LineWidth',lw)
    plot (Hnm,F(:,5),'-','LineWidth',lw,'Color',[255/255 165/255 0])
    plot (Hnm,F(:,6),'--k','LineWidth',lw+0.5)
    axis([0.0 Xfmax Yfmin Yfmax])
    legend('van der Waals','EDL','Acid-Base','Born','Steric','Total')
    xlabel('Separation Distance   (nm)');ylabel('Force   (N)');
    set(axes,'Fontsize',40);
    set(legend,'Fontsize',60);
    % keep grid state
    if gridF
        set(handles.axesF,'XGrid','on');
        set(handles.axesF,'YGrid','on');
    else
        set(handles.axesF,'XGrid','off');
        set(handles.axesF,'YGrid','off');
    end
    hold off;
end


% --- Executes on button press in pbLOAD.
function pbLOAD_Callback(hObject, eventdata, handles)
% hObject    handle to pbLOAD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global inputPar
clear inputPar
% % set working directory
if ~isdeployed
    % MATLAB environment
    mname = mfilename('fullpath');
    inputpath = strrep(mname,'\GUIxDLVO','\')
    %     mkdir(outputpath,OUTDIR);
    %     outputdir = strrep(mfilename('fullpath'),'\GUIxDLVO',outs);
else
    %deployed application
    inputpath=pwd
    %     mkdir(outputpath,OUTDIR);
    %     outputdir=strcat(outputpath,outs);
end
inputpath1= strcat(inputpath,'\*.xls');

[FileName,PathName] =uigetfile(inputpath1,'Select existing output file');
% [FileName,PathName] =uigetfile('*.xls','Select existing output file');
% fname = uigetdir(outputpath,'Select Output Directory');
if isequal(FileName,0)
    disp('User selected Cancel');
else
    fullfname = strcat(PathName,FileName);
    inputPar = load_input_par(fullfname,'Input_Parameters','A1:D125');
    display('ok')
    %% populate GUI fields and checkboxes
    % define format for GUI fields
    prec = '%10.5e\n';
    %% geometry
    set(handles.checkboxSS,'Value',cell2mat(inputPar(2,2)))
    set(handles.checkboxSP,'Value',cell2mat(inputPar(3,2)))
    %% roughness mode
    cond =cell2mat(inputPar(5,2));
    if cond==0
        set(handles.cbRmode0,'Value',1)
    end
    if cond==1
        set(handles.cbRmode1,'Value',1)
    end
    if cond==2
        set(handles.cbRmode2,'Value',1)
    end
    if cond==3
        set(handles.cbRmode3,'Value',1)
    end
    %% Main_DLVO_Parameters
    set(handles.T,'String',num2str(cell2mat(inputPar(8,2)),prec))
    set(handles.IS,'String',num2str(cell2mat(inputPar(9,2)),prec))
    set(handles.a1,'String',num2str(cell2mat(inputPar(10,2)),prec))
    set(handles.a2,'String',num2str(cell2mat(inputPar(11,2)),prec))
    set(handles.zetac,'String',num2str(cell2mat(inputPar(12,2)),prec))
    set(handles.zetac,'String',num2str(cell2mat(inputPar(13,2)),prec))
    set(handles.z,'String',num2str(cell2mat(inputPar(14,2)),prec))
    set(handles.epsilonR,'String',num2str(cell2mat(inputPar(15,2)),prec))
    set(handles.lambdaVDW,'String',num2str(cell2mat(inputPar(16,2)),prec))
    set(handles.sigmac,'String',num2str(cell2mat(inputPar(17,2)),prec))
    %% Extended_DLVO_Parameters
    set(handles.lambdaAB,'String',num2str(cell2mat(inputPar(20,2)),prec))
    set(handles.lambdaSTE,'String',num2str(cell2mat(inputPar(21,2)),prec))
    set(handles.gammaSTE,'String',num2str(cell2mat(inputPar(22,2)),prec))
    set(handles.aasp,'String',num2str(cell2mat(inputPar(23,2)),prec))
    %% van_der_Waals
    set(handles.cbCOATED,'Value',cell2mat(inputPar(26,2)))
    set(handles.A132,'String',num2str(cell2mat(inputPar(27,2)),prec))
    set(handles.cbA132,'Value',cell2mat(inputPar(27,4)))
    cbA132 = get(handles.cbA132,'Value');
    if cbA132
        set(handles.ve,'String',num2str(cell2mat(inputPar(42,2)),prec))
        set(handles.e1,'String',num2str(cell2mat(inputPar(43,2)),prec))
        set(handles.n1,'String',num2str(cell2mat(inputPar(44,2)),prec))
        set(handles.e2,'String',num2str(cell2mat(inputPar(45,2)),prec))
        set(handles.n2,'String',num2str(cell2mat(inputPar(46,2)),prec))
        set(handles.e3,'String',num2str(cell2mat(inputPar(47,2)),prec))
        set(handles.n3,'String',num2str(cell2mat(inputPar(48,2)),prec))
        set(handles.A132calc,'String',num2str(cell2mat(inputPar(49,2)),prec))
    end
    %% acid_base
    set(handles.gammaAB,'String',num2str(cell2mat(inputPar(30,2)),prec))
    set(handles.cbgammaAB,'Value',cell2mat(inputPar(30,4)))
    cbgammaAB = get(handles.cbgammaAB,'Value');
    if cbgammaAB
        set(handles.g1pos,'String',num2str(cell2mat(inputPar(52,2)),prec))
        set(handles.g1neg,'String',num2str(cell2mat(inputPar(53,2)),prec))
        set(handles.g2pos,'String',num2str(cell2mat(inputPar(54,2)),prec))
        set(handles.g2neg,'String',num2str(cell2mat(inputPar(55,2)),prec))
        set(handles.g3pos,'String',num2str(cell2mat(inputPar(56,2)),prec))
        set(handles.g3neg,'String',num2str(cell2mat(inputPar(57,2)),prec))
        set(handles.gammaABcalc,'String',num2str(cell2mat(inputPar(58,2)),prec))
    end
    %% Work_of_adhesion
    set(handles.W132,'String',num2str(cell2mat(inputPar(33,2)),prec))
    set(handles.cbW132,'Value',cell2mat(inputPar(33,4)))
    cbW132 = get(handles.cbW132,'Value');
    if cbW132
        set(handles.g1LW,'String',num2str(cell2mat(inputPar(61,2)),prec))
        set(handles.g2LW,'String',num2str(cell2mat(inputPar(62,2)),prec))
        set(handles.g3LW,'String',num2str(cell2mat(inputPar(63,2)),prec))
        set(handles.INDgammaAB,'String',num2str(cell2mat(inputPar(64,2)),prec))
        set(handles.W132calc,'String',num2str(cell2mat(inputPar(65,2)),prec))
    end
    %% Contact_radius(for_steric_interaction)
    set(handles.acont,'String',num2str(cell2mat(inputPar(36,2)),prec))
    set(handles.cbacont,'Value',cell2mat(inputPar(36,4)))
    cbacont = get(handles.cbacont,'Value');
    if cbacont
        set(handles.E1,'String',num2str(cell2mat(inputPar(68,2)),prec))
        set(handles.E2,'String',num2str(cell2mat(inputPar(69,2)),prec))
        set(handles.v1,'String',num2str(cell2mat(inputPar(70,2)),prec))
        set(handles.v2,'String',num2str(cell2mat(inputPar(71,2)),prec))
        set(handles.INDW132,'String',num2str(cell2mat(inputPar(72,2)),prec))
        set(handles.Kint,'String',num2str(cell2mat(inputPar(73,2)),prec))
        set(handles.acontCALC,'String',num2str(cell2mat(inputPar(74,2)),prec))
    end
    %% COATED_SYSTEMS_van_der_Waals_PARAMETERS
    cbCOATED = get(handles.cbCOATED,'Value');
    if cbCOATED
        % Type_of_coated_system
        set(handles.cb1,'Value',cell2mat(inputPar(80,2)))
        set(handles.cb2,'Value',cell2mat(inputPar(81,2)))
        set(handles.cb3,'Value',cell2mat(inputPar(82,2)))
        %Coating_thickness_and_fluid_Hamaker_constant
        set(handles.T1,'String',num2str(cell2mat(inputPar(85,2)),prec))
        set(handles.T2,'String',num2str(cell2mat(inputPar(86,2)),prec))
        set(handles.A33,'String',num2str(cell2mat(inputPar(87,2)),prec))
        %Combined_Hamaker_constant_Coated_sytems
        set(handles.A12,'String',num2str(cell2mat(inputPar(90,2)),prec))
        set(handles.cbA12,'Value',cell2mat(inputPar(90,4)))
        set(handles.A12p,'String',num2str(cell2mat(inputPar(91,2)),prec))
        set(handles.cbA12p,'Value',cell2mat(inputPar(91,4)))
        set(handles.A13,'String',num2str(cell2mat(inputPar(92,2)),prec))
        set(handles.cbA13,'Value',cell2mat(inputPar(92,4)))
        set(handles.A1p2,'String',num2str(cell2mat(inputPar(93,2)),prec))
        set(handles.cbA1p2,'Value',cell2mat(inputPar(93,4)))
        set(handles.A1p2p,'String',num2str(cell2mat(inputPar(94,2)),prec))
        set(handles.cbA1p2p,'Value',cell2mat(inputPar(94,4)))
        set(handles.A1p3,'String',num2str(cell2mat(inputPar(95,2)),prec))
        set(handles.cbA1p3,'Value',cell2mat(inputPar(95,4)))
        set(handles.A23,'String',num2str(cell2mat(inputPar(96,2)),prec))
        set(handles.cbA23,'Value',cell2mat(inputPar(96,4)))
        set(handles.A2p3,'String',num2str(cell2mat(inputPar(97,2)),prec))
        set(handles.cbA2p3,'Value',cell2mat(inputPar(97,4)))
        %Hamaker_constants_Single_material_values
        set(handles.A11,'String',num2str(cell2mat(inputPar(100,2)),prec))
        set(handles.A1p1p,'String',num2str(cell2mat(inputPar(101,2)),prec))
        set(handles.A22,'String',num2str(cell2mat(inputPar(102,2)),prec))
        set(handles.A2p2p,'String',num2str(cell2mat(inputPar(103,2)),prec))
        %% Hamaker_constant_contributions
        %SYSTEM_Coated_colloid-Coated_collector
        set(handles.s1A1p2p,'String',num2str(cell2mat(inputPar(109,2)),prec))
        set(handles.s1A12p,'String',num2str(cell2mat(inputPar(110,2)),prec))
        set(handles.s1A1p2,'String',num2str(cell2mat(inputPar(111,2)),prec))
        set(handles.s1A12,'String',num2str(cell2mat(inputPar(112,2)),prec))
        %SYSTEM_Colloid-Coated_collector
        set(handles.s2A12p,'String',num2str(cell2mat(inputPar(115,2)),prec))
        set(handles.s2A12,'String',num2str(cell2mat(inputPar(116,2)),prec))
        %SYSTEM_Coated_colloid-Collector
        set(handles.s3A1p2,'String',num2str(cell2mat(inputPar(119,2)),prec))
        set(handles.s3A12,'String',num2str(cell2mat(inputPar(120,2)),prec))
    end
    %% SYSTEM_Heterodomain_influence
    set(handles.cbHET,'Value',cell2mat(inputPar(123,2)))
    set(handles.cbHETUSER,'Value',cell2mat(inputPar(124,2)))
    set(handles.zetahet,'String',num2str(cell2mat(inputPar(125,2)),prec))
    cbHET=get(handles.cbHET,'Value');
    cbHETUSER=get(handles.cbHETUSER,'Value');
    if cbHET==0&&cbHETUSER==0
       set(handles.cbMEAN,'Value',1)
    else
       set(handles.cbMEAN,'Value',0) 
    end
    %reset status depending on heterogeneity checkboxes
    if cbHETUSER
        set(handles.cbMEAN,'Value',0)
        set(handles.cbHET,'Value',0)
        set(handles.zetahet,'Enable','on')
        % disable ZOI areal fields
        set(handles.rhet1,'Enable','off')
        set(handles.rhet2,'Enable','off')
        set(handles.rhet3,'Enable','off')
        set(handles.rhet4,'Enable','off')
        % enable fields
        set(handles.rhet1USER,'Enable','on')
        set(handles.rhet2USER,'Enable','on')
        set(handles.rhet3USER,'Enable','on')
        set(handles.rhet4USER,'Enable','on')
        % enable hetdomain plots checkbox
        set(handles.cbHETPLOTS,'Visible','on')
        set(handles.cbHETPLOTS,'Value',1)
        % populate user rhet fields
        % read ap value
        ap = str2double(get(handles.a1,'String'));
        rhetvUSER = [0.015 0.03 0.06 0.12]*ap;
        set(handles.rhet1USER,'String',num2str(rhetvUSER(1)))
        set(handles.rhet2USER,'String',num2str(rhetvUSER(2)))
        set(handles.rhet3USER,'String',num2str(rhetvUSER(3)))
        set(handles.rhet4USER,'String',num2str(rhetvUSER(4)))
    end
       
    if cbHET
        set(handles.cbMEAN,'Value',0)
        set(handles.cbHETUSER,'Value',0)
        % enable fields
        set(handles.zetahet,'Enable','on')
        set(handles.rhet1,'ForegroundColor','r')
        set(handles.rhet2,'ForegroundColor','r')
        set(handles.rhet3,'ForegroundColor','r')
        set(handles.rhet4,'ForegroundColor','r')
        % disable user rhet fields
        set(handles.rhet1USER,'String','calculate')
        set(handles.rhet1USER,'ForegroundColor','k')
        set(handles.rhet2USER,'String','calculate')
        set(handles.rhet2USER,'ForegroundColor','k')
        set(handles.rhet3USER,'String','calculate')
        set(handles.rhet3USER,'ForegroundColor','k')
        set(handles.rhet4USER,'String','calculate')
        set(handles.rhet4USER,'ForegroundColor','k')
        set(handles.rhet1USER,'Enable','off')
        set(handles.rhet2USER,'Enable','off')
        set(handles.rhet3USER,'Enable','off')
        set(handles.rhet4USER,'Enable','off')
        % enable hetdomain plots checkbox
        set(handles.cbHETPLOTS,'Visible','on')
        set(handles.cbHETPLOTS,'Value',1)
    
    end
    
    
    
end



function rhet1_Callback(hObject, eventdata, handles)
% hObject    handle to rhet1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet1 as text
%        str2double(get(hObject,'String')) returns contents of rhet1 as a double


% --- Executes during object creation, after setting all properties.
function rhet1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhet2_Callback(hObject, eventdata, handles)
% hObject    handle to rhet2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet2 as text
%        str2double(get(hObject,'String')) returns contents of rhet2 as a double


% --- Executes during object creation, after setting all properties.
function rhet2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhet3_Callback(hObject, eventdata, handles)
% hObject    handle to rhet3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet3 as text
%        str2double(get(hObject,'String')) returns contents of rhet3 as a double


% --- Executes during object creation, after setting all properties.
function rhet3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhet4_Callback(hObject, eventdata, handles)
% hObject    handle to rhet4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet4 as text
%        str2double(get(hObject,'String')) returns contents of rhet4 as a double


% --- Executes during object creation, after setting all properties.
function rhet4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cbHETUSER.
function cbHETUSER_Callback(hObject, eventdata, handles)
% hObject    handle to cbHETUSER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global cbHET cbHETUSER
% Hint: get(hObject,'Value') returns toggle state of cbHETUSER
cbHETUSER=get(hObject,'Value');
if cbHETUSER
    set(handles.cbMEAN,'Value',0)
    set(handles.cbHET,'Value',0)
    set(handles.zetahet,'Enable','on')
    % disable ZOI areal fields
    set(handles.rhet1,'Enable','off')
    set(handles.rhet2,'Enable','off')
    set(handles.rhet3,'Enable','off')
    set(handles.rhet4,'Enable','off')
    % enable fields
    set(handles.rhet1USER,'Enable','on')
    set(handles.rhet2USER,'Enable','on')
    set(handles.rhet3USER,'Enable','on')
    set(handles.rhet4USER,'Enable','on')
    % enable hetdomain plots checkbox
    set(handles.cbHETPLOTS,'Visible','on')
    set(handles.cbHETPLOTS,'Value',1)
    % populate user rhet fields
    % read ap value
    ap = str2double(get(handles.a1,'String'));
    rhetvUSER = [0.015 0.03 0.06 0.12]*ap;
    set(handles.rhet1USER,'String',num2str(rhetvUSER(1)))
    set(handles.rhet2USER,'String',num2str(rhetvUSER(2)))
    set(handles.rhet3USER,'String',num2str(rhetvUSER(3)))
    set(handles.rhet4USER,'String',num2str(rhetvUSER(4)))
else
    set(handles.cbMEAN,'Value',1)
    set(handles.cbHET,'Value',0)
    set(handles.zetahet,'Enable','on')
    % disable ZOI areal fields
    set(handles.rhet1,'Enable','off')
    set(handles.rhet2,'Enable','off')
    set(handles.rhet3,'Enable','off')
    set(handles.rhet4,'Enable','off')
    % disable USER rhet fields
    set(handles.rhet1USER,'Enable','off')
    set(handles.rhet2USER,'Enable','off')
    set(handles.rhet3USER,'Enable','off')
    set(handles.rhet4USER,'Enable','off')
    % disable hetdomain plots checkbox
    set(handles.cbHETPLOTS,'Visible','off')
    set(handles.cbHETPLOTS,'Value',1)
end




function rhet1USER_Callback(hObject, eventdata, handles)
% hObject    handle to rhet1USER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet1USER as text
%        str2double(get(hObject,'String')) returns contents of rhet1USER as a double


% --- Executes during object creation, after setting all properties.
function rhet1USER_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet1USER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhet2USER_Callback(hObject, eventdata, handles)
% hObject    handle to rhet2USER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet2USER as text
%        str2double(get(hObject,'String')) returns contents of rhet2USER as a double


% --- Executes during object creation, after setting all properties.
function rhet2USER_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet2USER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhet3USER_Callback(hObject, eventdata, handles)
% hObject    handle to rhet3USER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet3USER as text
%        str2double(get(hObject,'String')) returns contents of rhet3USER as a double


% --- Executes during object creation, after setting all properties.
function rhet3USER_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet3USER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rhet4USER_Callback(hObject, eventdata, handles)
% hObject    handle to rhet4USER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rhet4USER as text
%        str2double(get(hObject,'String')) returns contents of rhet4USER as a double


% --- Executes during object creation, after setting all properties.
function rhet4USER_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rhet4USER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function cbHET_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cbHET (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function zetap_Callback(hObject, eventdata, handles)
% hObject    handle to zetac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zetac as text
%        str2double(get(hObject,'String')) returns contents of zetac as a double
global zetap
zetap = str2double(get(hObject,'String' ));

% --- Executes during object creation, after setting all properties.
function zetap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zetac (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
