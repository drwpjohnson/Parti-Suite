function varargout = CorrelationEqs_GUI(varargin)
% CORRELATIONEQS_GUI MATLAB code for CorrelationEqs_GUI.fig
%      CORRELATIONEQS_GUI, by itself, creates a new CORRELATIONEQS_GUI or raises the existing
%      singleton*.
%
%      H = CORRELATIONEQS_GUI returns the handle to a new CORRELATIONEQS_GUI or the handle to
%      the existing singleton*.
%
%      CORRELATIONEQS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CORRELATIONEQS_GUI.M with the given input arguments.
%
%      CORRELATIONEQS_GUI('Property','Value',...) creates a new CORRELATIONEQS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CorrelationEqs_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CorrelationEqs_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CorrelationEqs_GUI

% Last Modified by GUIDE v2.5 14-Oct-2020 18:27:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CorrelationEqs_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CorrelationEqs_GUI_OutputFcn, ...
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


% --- Executes just before CorrelationEqs_GUI is made visible.
function CorrelationEqs_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CorrelationEqs_GUI (see VARARGIN)

% Choose default command line output for CorrelationEqs_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CorrelationEqs_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CorrelationEqs_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function dci_Callback(hObject, eventdata, handles) 
global dci
% hObject    handle to dci (see GCBO)

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

get(hObject,'String')
dci = str2double(get(hObject,'String'));
maxVal = 10;
minVal = 0.01;

if dci<minVal
    m=warndlg('dci(mm) value recommended between 0.01 - 10','Warning');
    waitfor(m)
    set (handles.dci,'String',num2str(minVal,'%8.4e'))
    
end
if dci>maxVal
    m=warndlg('dci must be among 0.01 - 10','Warning');
    waitfor(m)
    set (handles.dci,'String',num2str(maxVal,'%8.4e'))
end

        


% --- Executes during object creation, after setting all properties.
function dci_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dci (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dpi_Callback(hObject, eventdata, handles)
global dpi
% hObject    handle to dpi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

get(hObject,'String') 
        dpi = str2double(get(hObject,'String'));
        maxVal = 50;
        minVal = 0.1;
        
        if dpi < minVal
            m=warndlg('dpi must be among 0.1 - 50','Warning');
            waitfor(m)
            set (handles.dpi,'String',num2str(minVal,'%8.4e'))
           
        else
            if dpi > maxVal
                m=warndlg('dpi must be among 0.1 - 50','Warning');
                waitfor(m)
                set (handles.dpi,'String',num2str(maxVal,'%8.4e'))
               
            end
        end

% --- Executes during object creation, after setting all properties.
function dpi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dpi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vi_Callback(hObject, eventdata, handles)
global vi
% hObject    handle to vi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

get(hObject,'String') 
        vi = str2double(get(hObject,'String'));
        maxVal = 20;
        minVal = 0.5;
        
        if vi<minVal
            m=warndlg('vi must be among 0.5 - 20','Warning');
            waitfor(m)
            set (handles.vi,'String',num2str(minVal,'%8.4e'))
           
        else
            if vi>maxVal
                m=warndlg('vi must be among 0.5 - 20','Warning');
                waitfor(m)
                set (handles.vi,'String',num2str(maxVal,'%8.4e'))
               
            end
        end

% --- Executes during object creation, after setting all properties.
function vi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function denp_Callback(hObject, eventdata, handles)
global denp
% hObject    handle to denp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

get(hObject,'String') 
        denp = str2double(get(hObject,'String'));
        maxVal = 20000;
        minVal = 1000;
        
        if denp<minVal
            m=warndlg('denp must be among 1000 - 20000','Warning');
            waitfor(m)
            set (handles.denp,'String',num2str(minVal,'%8.4e'))
           
        else
            if denp>maxVal
                m=warndlg('denp must be among 1000 - 20000','Warning');
                waitfor(m)
                set (handles.denp,'String',num2str(maxVal,'%8.4e'))
               
            end
        end


% --- Executes during object creation, after setting all properties.
function denp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to denp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function denf_Callback(hObject, eventdata, handles)
global denf
% hObject    handle to denf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

get(hObject,'String') 
        denf = str2double(get(hObject,'String'));
        maxVal = 1400;
        minVal = 600;
        
        if denf<minVal
            m=warndlg('denf must be among 600 - 1400','Warning');
            waitfor(m)
            set (handles.denf,'String',num2str(minVal,'%8.4e'))
           
        else
            if denf>maxVal
                m=warndlg('denf must be among 600 - 1400','Warning');
                waitfor(m)
                set (handles.denf,'String',num2str(maxVal,'%8.4e'))
               
            end
        end


% --- Executes during object creation, after setting all properties.
function denf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to denf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function visf_Callback(hObject, eventdata, handles)
global visf
% hObject    handle to visf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

get(hObject,'String') 
        visf = str2double(get(hObject,'String'));
        maxVal = 1E-3;
        minVal = 1E-4;
        
        if visf<minVal
            m=warndlg('visf must be among 1E-4 - 1E-3','Warning');
            waitfor(m)
            set (handles.visf,'String',num2str(minVal,'%8.4e'))
           
        else
            if visf>maxVal
                m=warndlg('visf must be among 1E-4 - 1E-3','Warning');
                waitfor(m)
                set (handles.visf,'String',num2str(maxVal,'%8.4e'))
               
            end
        end


% --- Executes during object creation, after setting all properties.
function visf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to visf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function T_Callback(hObject, eventdata, handles)
global T
% hObject    handle to T (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

get(hObject,'String') 
        T = str2double(get(hObject,'String'));
        maxVal = 333;
        minVal = 263;
        
        if T<minVal
            m=warndlg('T must be among 263 - 333','Warning');
            waitfor(m)
            set (handles.T,'String',num2str(minVal,'%8.4e'))
           
        else
            if T>maxVal
                m=warndlg('T must be among 263 - 333','Warning');
                waitfor(m)
                set (handles.T,'String',num2str(maxVal,'%8.4e'))
               
            end
        end

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



function A_Callback(hObject, eventdata, handles)
global A
% hObject    handle to A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

get(hObject,'String') 
        A = str2double(get(hObject,'String'));
        maxVal = 1E-20;
        minVal = 1E-21;
        
        if A<minVal
            m=warndlg('A must be among 1E-21 - 1E-20','Warning');
            waitfor(m)
            set (handles.A,'String',num2str(minVal,'%8.4e'))
           
        else
            if A>maxVal
                m=warndlg('A must be among 1E-21 - 1E-20','Warning');
                waitfor(m)
                set (handles.A,'String',num2str(maxVal,'%8.4e'))
               
            end
        end


% --- Executes during object creation, after setting all properties.
function A_CreateFcn(hObject, eventdata, handles)
% hObject    handle to A (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function f_Callback(hObject, eventdata, handles)
global f
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

get(hObject,'String') 
        f = str2double(get(hObject,'String'));
        maxVal = 0.8;
        minVal = 0.1;
        
        if f<minVal
            m=warndlg('A must be among 0.1 - 0.8','Warning');
            waitfor(m)
            set (handles.f,'String',num2str(minVal,'%8.4e'))
           
        else
            if f>maxVal
                m=warndlg('A must be among 0.1 - 0.8','Warning');
                waitfor(m)
                set (handles.f,'String',num2str(maxVal,'%8.4e'))
               
            end
        end
        


% --- Executes during object creation, after setting all properties.
function f_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Scf_Callback(hObject, eventdata, handles)
global Scf
% hObject    handle to Scf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

get(hObject,'String') 
        Scf = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Scf_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Scf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Ceff_Callback(hObject, eventdata, handles)
global Ceff
% hObject    handle to Ceff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

get(hObject,'String') 
        Ceff = str2double(get(hObject,'String'));


% --- Executes during object creation, after setting all properties.
function Ceff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ceff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global inputs
global dci dpi vi denp denf visf T A f Scf Ceff % assign global variables
% globalinputs for single eta
global dciSE dpiSE viSE denpSE denfSE visfSE TSE ASE fSE ScfSE CeffSE
% intermediate parameters and dimensionless numbers
global As Nr Nlo Nvdw Na Npe Ng Ngi g 
% intermediate parameters and dimensionless numbers for single eta
global  AsSE NrSE NloSe NvdwSE NaSE NpeSE NgSE NgiSE gSE
% rate coefficients single eta
global kfrSE kftSE kfmSE kflSE kfnSE
% set globals for correlation equations output single eta
global etadrSE etairSE etagrSE etarSE %Rajogapalan and Tien 1976
global etadtSE etaitSE etagtSE etatSE  %Tufenkji and Elimelech 2004
global etadmSE etaimSE etagmSE etamSE  %Ma, Jhonson 2015
global etadlSE etailSE etaglSE etalSE  %Long and Hilpert 2011
global etadnSE etainSE etagnSE etanSE  %Nelson and Ginn 2011
% set globals for correlation equations output eta RANGE
global etadr  etair  etagr etar kfr kfdr %Rajogapalan and Tien 1976
global etadt etait etagt etat kft kfdt %Tufenkji and Elimelech 2004
global etadm etaim etagm etam kfm kfdm %Ma, Jhonson 2015
global etadl etail etagl etal kfl kfdl %Long and Hilpert 2011
global etadn etain etagn etan kfn kfdn %Nelson and Ginn 2011
% set globals for retention profile (single eta only)
global  x Yr Yt Ym Yl Yn
% fighandles will close any figure windows that is not the gui
clc;
figHandles = findobj('type', 'figure', '-not', 'name', 'CorrelationEqs_GUI');
close(figHandles);
%% define figure names
% Profile figure
Rfig =  strcat('Retained_Profile_based_on_main_parameters');
Rf = figure(1);
set(Rf,'name',Rfig,'NumberTitle','off');
% Eta figure
Efig =  strcat('Collector_Efficiency_based_on_range');
Ef = figure(2); 
set(Ef,'name',Efig,'NumberTitle','off');
%%
%%Obtaining data from check boxes
dciCB = get(handles.dciCB,'Value');
dpiCB = get(handles.dpiCB,'Value');
viCB = get(handles.viCB,'Value');
denpCB = get(handles.denpCB,'Value');
denfCB = get(handles.denfCB,'Value'); 
visfCB = get(handles.visfCB,'Value');
TCB = get(handles.TCB,'Value');
ACB = get(handles.ACB,'Value');
fCB = get(handles.fCB,'Value');

%% plot retained profile figure only for main parameters

%%
dci=str2double(get(handles.dci,'String'));
dpi=str2double(get(handles.dpi,'String'));
vi=str2double(get(handles.vi,'String'));
denp=str2double(get(handles.denp,'String'));
denf=str2double(get(handles.denf,'String'));
visf=str2double(get(handles.visf,'String'));
T=str2double(get(handles.T,'String'));
A=str2double(get(handles.A,'String'));
f=str2double(get(handles.f,'String'));
Scf=str2double(get(handles.Scf,'String'));
Ceff=str2double(get(handles.Ceff,'String'));

    %% Transformations
dc = dci.*0.001;
%Particle size (m)
dp = dpi*0.000001;
%Pore water velocity (m/s)
v = vi/86400; %(m/s)
p = (1-f)^(1/3); w = 2-(3*p)+(3*(p^5))-(2*(p^6));
%Fluid approach velocity (m3/m2/day)
Ui = vi*f; U = Ui/86400;

%% Constants
%Boltzmann constant (j/kg)
B = 1.381E-23;

%% Dimensionless numbers
%DIffusion Coeficient (m2/s)
D = (B.*T)./(6.*pi.*visf.*(dp./2));
%Happel model parameter
As = (2.*(1-((1-f).^(5/3))))./((2-(3.*((1-f).^(1/3)))+(3.*((1-f).^(5/3)))-(2.*(1-f).^2)));
Nr = dp./dc; %Aspect ratio
Nlo = A./(9.*pi.*visf.*((dp./2).^2).*U); %London number
Nvdw = A./(B.*T); % van der waals number
Na = A./(12.*pi.*visf.*U.*((dc./2).^2)); %Attraction number
Npe = U.*dc./D; %Peclet number
Ng = (2.*((dp./2).^(2))*(denp-denf).*9.806)./(9.*visf.*U); %gravity number
Ngi = 1./(1+Ng);
g=(1-f).^(1/3);

%% Calculations of rate coeficients from different authors

[etadr, etair, etagr, etar, kfr, kfdr]=fRAGO(g, As, Npe, Nlo, Nr, Ng, f, v, dc, Ceff); %Rajogapalan and Tien 1976
[etadt, etait, etagt, etat, kft, kfdt]=fTUFEN(As, Nr, Npe, Nvdw, Na, Ng, f, v, dc, Ceff); %Tufenkji and Elimelech 2004
[etadm, etaim, etagm, etam, kfm, kfdm]=fMA(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Ma, Jhonson 2015
[etadl, etail, etagl, etal, kfl, kfdl]=fLONG(g, Npe, Nr, As, Na, Ng, Nvdw, f, v, dc, Ceff); %Long and Hilpert 2011
[etadn, etain, etagn, etan, kfn, kfdn]=fNEL(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Nelson and Ginn 2011
%%  assing calculated etas to text fields and change format
set (handles.text_etar, 'String', num2str(etar(1),'%4.2E'))
set (handles.text_etar, 'ForegroundColor', 'blue')
set (handles.text_etadr, 'String', num2str(etadr(1),'%4.2E'))
set (handles.text_etadr, 'ForegroundColor', 'blue')
set (handles.text_etair, 'String', num2str(etair(1),'%4.2E'))
set (handles.text_etair, 'ForegroundColor', 'blue')
set (handles.text_etagr, 'String', num2str(etagr(1),'%4.2E'))
set (handles.text_etagr, 'ForegroundColor', 'blue')
set (handles.text_kfr, 'String', num2str(kfr(1),'%4.2E'))
set (handles.text_kfr, 'ForegroundColor', 'blue')

set (handles.text_etat, 'String', num2str(etat(1),'%4.2E'))
set (handles.text_etat, 'ForegroundColor', 'blue')
set (handles.text_etadt, 'String', num2str(etadt(1),'%4.2E'))
set (handles.text_etadt, 'ForegroundColor', 'blue')
set (handles.text_etait, 'String', num2str(etait(1),'%4.2E'))
set (handles.text_etait, 'ForegroundColor', 'blue')
set (handles.text_etagt, 'String', num2str(etagt(1),'%4.2E'))
set (handles.text_etagt, 'ForegroundColor', 'blue')
set (handles.text_kft, 'String', num2str(kft(1),'%4.2E'))
set (handles.text_kft, 'ForegroundColor', 'blue')

set (handles.text_etam, 'String', num2str(etam(1),'%4.2E'))
set (handles.text_etam, 'ForegroundColor', 'blue')
set (handles.text_etadm, 'String', num2str(etadm(1),'%4.2E'))
set (handles.text_etadm, 'ForegroundColor', 'blue')
set (handles.text_etaim, 'String', num2str(etaim(1),'%4.2E'))
set (handles.text_etaim, 'ForegroundColor', 'blue')
set (handles.text_etagm, 'String', num2str(etagm(1),'%4.2E'))
set (handles.text_etagm, 'ForegroundColor', 'blue')
set (handles.text_kfm, 'String', num2str(kfm(1),'%4.2E'))
set (handles.text_kfm, 'ForegroundColor', 'blue')

set (handles.text_etal, 'String', num2str(etal(1),'%4.2E'))
set (handles.text_etal, 'ForegroundColor', 'blue')
set (handles.text_etadl, 'String', num2str(etadl(1),'%4.2E'))
set (handles.text_etadl, 'ForegroundColor', 'blue')
set (handles.text_etail, 'String', num2str(etail(1),'%4.2E'))
set (handles.text_etail, 'ForegroundColor', 'blue')
set (handles.text_etagl, 'String', num2str(etagl(1),'%4.2E'))
set (handles.text_etagl, 'ForegroundColor', 'blue')
set (handles.text_kfl, 'String', num2str(kfl(1),'%4.2E'))
set (handles.text_kfl, 'ForegroundColor', 'blue')

set (handles.text_etan, 'String', num2str(etan(1),'%4.2E'))
set (handles.text_etan, 'ForegroundColor', 'blue')
set (handles.text_etadn, 'String', num2str(etadn(1),'%4.2E'))
set (handles.text_etadn, 'ForegroundColor', 'blue')
set (handles.text_etain, 'String', num2str(etain(1),'%4.2E'))
set (handles.text_etain, 'ForegroundColor', 'blue')
set (handles.text_etagn, 'String', num2str(etagn(1),'%4.2E'))
set (handles.text_etagn, 'ForegroundColor', 'blue')
set (handles.text_kfn, 'String', num2str(kfn(1),'%4.2E'))
set (handles.text_kfn, 'ForegroundColor', 'blue')

set (handles.text_Nr, 'String', num2str(Nr(1),'%4.2E'))
set (handles.text_Nr, 'ForegroundColor', 'blue')
set (handles.text_Nlo, 'String', num2str(Nlo(1),'%4.2E'))
set (handles.text_Nlo, 'ForegroundColor', 'blue')
set (handles.text_Nvdw, 'String', num2str(Nvdw(1),'%4.2E'))
set (handles.text_Nvdw, 'ForegroundColor', 'blue')
set (handles.text_Na, 'String', num2str(Na(1),'%4.2E'))
set (handles.text_Na, 'ForegroundColor', 'blue')
set (handles.text_Npe, 'String', num2str(Npe(1),'%4.2E'))
set (handles.text_Npe, 'ForegroundColor', 'blue')
set (handles.text_Ng, 'String', num2str(Ng(1),'%4.2E'))
set (handles.text_Ng, 'ForegroundColor', 'blue')
set (handles.text_Ngi, 'String', num2str(Ngi(1),'%4.2E'))
set (handles.text_Ngi, 'ForegroundColor', 'blue')
%     set (handles.text_g, 'String', num2str(g(1)))
%     set (handles.text_g, 'ForegroundColor', 'blue')
%     set (handles.text_As, 'String', num2str(As(1)))
%     set (handles.text_As, 'ForegroundColor', 'blue')
%% Setting simulation parameters and getting outputs
x=NaN(1,108);
x(1)=0.001;
for i=2:108
    x(i)=(x(i-1))*(1+Scf);
end

Yr = exp(-kfdr*x/vi);
Yt = exp(-kfdt*x/vi);
Ym = exp(-kfdm*x/vi);
Yl = exp(-kfdl*x/vi);
Yn = exp(-kfdn*x/vi);

% plot retention profile
figure (1)
plot(x,Yr,'b','Linewidth',1.5)
hold on
plot(x,Yt,'r','Linewidth',1.5)
plot (x,Ym,'g','Linewidth',1.5)
plot (x,Yl,'k','Linewidth',1.5)
plot (x,Yn,'y','Linewidth',1.5)
legend('Rajogapalan and Tien, 1976','Tufenkji and Elimelech, 2004','Ma,Pedel,Fife,Johnson 2015','Long and Hilpert, 2011','Nelson and Ginn, 2011')
axis([0 0.6 0 1])
xlabel('Column length (m)'); ylabel('C/Co')
%% save parameters for single eta (5 authors)
dciSE = dci; dpiSE = dpi;  viSE = vi; denpSE=denp;  denfSE = denf; 
visfSE = visf;   TSE = T; ASE = A; fSE = f; ScfSE = Scf; CeffSE = Ceff; 
% intermediate parameters and dimensionless numbers for single eta
AsSE = As;  NrSE=Nr;    NloSe = Nlo;    NvdwSE = Nvdw;  NaSE=Na;  
NpeSE = Npe; NgSE=Ng;   NgiSE=Ngi;  gSE = g;
% kinetic rate coefficients single eta
kfrSE = kfr; kftSE = kft;  kfmSE = kfm; kflSE =  kfl; kfnSE= kfn;
% etas and eta components 
etadrSE=etadr; etairSE=etair; etagrSE=etagr; etarSE=etar; %Rajogapalan and Tien 1976
etadtSE=etadt; etaitSE=etait; etagtSE=etagt; etatSE=etat;  %Tufenkji and Elimelech 2004
etadmSE=etadm; etaimSE=etaim; etagmSE=etagm; etamSE=etam;  %Ma, Jhonson 2015
etadlSE=etadl; etailSE=etail; etaglSE=etagl; etalSE=etal;  %Long and Hilpert 2011
etadnSE=etadn; etainSE=etain; etagnSE=etagn; etanSE=etan;  %Nelson and Ginn 2011
%  
%% evaluate ranges
if dciCB>0
    %% Obtaining data from the guide edit boxes
    
    %dci=str2double(get(handles.dci,'String'));
    dpi=str2double(get(handles.dpi,'String'));
    vi=str2double(get(handles.vi,'String'));
    denp=str2double(get(handles.denp,'String'));
    denf=str2double(get(handles.denf,'String'));
    visf=str2double(get(handles.visf,'String'));
    T=str2double(get(handles.T,'String'));
    A=str2double(get(handles.A,'String'));
    f=str2double(get(handles.f,'String'));
    Scf=str2double(get(handles.Scf,'String'));
    Ceff=str2double(get(handles.Ceff,'String'));
    upperval=str2double(get(handles.upperval,'String'));
    lowval=str2double(get(handles.lowval,'String'));
    nsteps=str2double(get(handles.nsteps,'String'));
    
    %% Generating vector
    
    dci=linspace(lowval,upperval,nsteps);
    
    
    %% Transformations
    dc = dci.*0.001;
    %Particle size (m)
    dp = dpi*0.000001;
    %Pore water velocity (m/s)
    v = vi/86400; %(m/s)
    p = (1-f)^(1/3); w = 2-(3*p)+(3*(p^5))-(2*(p^6));
    %Fluid approach velocity (m3/m2/day)
    Ui = vi*f; U = Ui/86400;
    
    %% Constants
    %Boltzmann constant (j/kg)
    B = 1.381E-23;
    
    %% Dimensionless numbers
    %DIffusion Coeficient (m2/s)
    D = (B.*T)./(6.*pi.*visf.*(dp./2));
    %Happel model parameter
    As = (2.*(1-((1-f).^(5/3))))./((2-(3.*((1-f).^(1/3)))+(3.*((1-f).^(5/3)))-(2.*(1-f).^2)));
    Nr = dp./dc; %Aspect ratio
    Nlo = A./(9.*pi.*visf.*((dp./2).^2).*U); %London number
    Nvdw = A./(B.*T); % van der waals number
    Na = A./(12.*pi.*visf.*U.*((dc./2).^2)); %Attraction number
    Npe = U.*dc./D; %Peclet number
    Ng = (2.*((dp./2).^(2))*(denp-denf).*9.806)./(9.*visf.*U); %gravity number
    Ngi = 1./(1+Ng);
    g=(1-f).^(1/3);
    
    %% Calculations of rate coeficients from different authors
    
    [etadr, etair, etagr, etar, kfr, kfdr]=fRAGO(g, As, Npe, Nlo, Nr, Ng, f, v, dc, Ceff); %Rajogapalan and Tien 1976
    [etadt, etait, etagt, etat, kft, kfdt]=fTUFEN(As, Nr, Npe, Nvdw, Na, Ng, f, v, dc, Ceff); %Tufenkji and Elimelech 2004
    [etadm, etaim, etagm, etam, kfm, kfdm]=fMA(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Ma, Jhonson 2015
    [etadl, etail, etagl, etal, kfl, kfdl]=fLONG(g, Npe, Nr, As, Na, Ng, Nvdw, f, v, dc, Ceff); %Long and Hilpert 2011
    [etadn, etain, etagn, etan, kfn, kfdn]=fNEL(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Nelson and Ginn 2011
    %%  assing calculated etas to text fields and change format
    set (handles.text_etar, 'String', num2str(etar(1),'%4.2E'))
    set (handles.text_etar, 'ForegroundColor', 'blue')
    set (handles.text_etadr, 'String', num2str(etadr(1),'%4.2E'))
    set (handles.text_etadr, 'ForegroundColor', 'blue')
    set (handles.text_etair, 'String', num2str(etair(1),'%4.2E'))
    set (handles.text_etair, 'ForegroundColor', 'blue')
    set (handles.text_etagr, 'String', num2str(etagr(1),'%4.2E'))
    set (handles.text_etagr, 'ForegroundColor', 'blue')
    set (handles.text_kfr, 'String', num2str(kfr(1),'%4.2E'))
    set (handles.text_kfr, 'ForegroundColor', 'blue')
    
    set (handles.text_etat, 'String', num2str(etat(1),'%4.2E'))
    set (handles.text_etat, 'ForegroundColor', 'blue')
    set (handles.text_etadt, 'String', num2str(etadt(1),'%4.2E'))
    set (handles.text_etadt, 'ForegroundColor', 'blue')
    set (handles.text_etait, 'String', num2str(etait(1),'%4.2E'))
    set (handles.text_etait, 'ForegroundColor', 'blue')
    set (handles.text_etagt, 'String', num2str(etagt(1),'%4.2E'))
    set (handles.text_etagt, 'ForegroundColor', 'blue')
    set (handles.text_kft, 'String', num2str(kft(1),'%4.2E'))
    set (handles.text_kft, 'ForegroundColor', 'blue')
    
    set (handles.text_etam, 'String', num2str(etam(1),'%4.2E'))
    set (handles.text_etam, 'ForegroundColor', 'blue')
    set (handles.text_etadm, 'String', num2str(etadm(1),'%4.2E'))
    set (handles.text_etadm, 'ForegroundColor', 'blue')
    set (handles.text_etaim, 'String', num2str(etaim(1),'%4.2E'))
    set (handles.text_etaim, 'ForegroundColor', 'blue')
    set (handles.text_etagm, 'String', num2str(etagm(1),'%4.2E'))
    set (handles.text_etagm, 'ForegroundColor', 'blue')
    set (handles.text_kfm, 'String', num2str(kfm(1),'%4.2E'))
    set (handles.text_kfm, 'ForegroundColor', 'blue')
    
    set (handles.text_etal, 'String', num2str(etal(1),'%4.2E'))
    set (handles.text_etal, 'ForegroundColor', 'blue')
    set (handles.text_etadl, 'String', num2str(etadl(1),'%4.2E'))
    set (handles.text_etadl, 'ForegroundColor', 'blue')
    set (handles.text_etail, 'String', num2str(etail(1),'%4.2E'))
    set (handles.text_etail, 'ForegroundColor', 'blue')
    set (handles.text_etagl, 'String', num2str(etagl(1),'%4.2E'))
    set (handles.text_etagl, 'ForegroundColor', 'blue')
    set (handles.text_kfl, 'String', num2str(kfl(1),'%4.2E'))
    set (handles.text_kfl, 'ForegroundColor', 'blue')
    
    set (handles.text_etan, 'String', num2str(etan(1),'%4.2E'))
    set (handles.text_etan, 'ForegroundColor', 'blue')
    set (handles.text_etadn, 'String', num2str(etadn(1),'%4.2E'))
    set (handles.text_etadn, 'ForegroundColor', 'blue')
    set (handles.text_etain, 'String', num2str(etain(1),'%4.2E'))
    set (handles.text_etain, 'ForegroundColor', 'blue')
    set (handles.text_etagn, 'String', num2str(etagn(1),'%4.2E'))
    set (handles.text_etagn, 'ForegroundColor', 'blue')
    set (handles.text_kfn, 'String', num2str(kfn(1),'%4.2E'))
    set (handles.text_kfn, 'ForegroundColor', 'blue')
    
    set (handles.text_Nr, 'String', num2str(Nr(1),'%4.2E'))
    set (handles.text_Nr, 'ForegroundColor', 'blue')
    set (handles.text_Nlo, 'String', num2str(Nlo(1),'%4.2E'))
    set (handles.text_Nlo, 'ForegroundColor', 'blue')
    set (handles.text_Nvdw, 'String', num2str(Nvdw(1),'%4.2E'))
    set (handles.text_Nvdw, 'ForegroundColor', 'blue')
    set (handles.text_Na, 'String', num2str(Na(1),'%4.2E'))
    set (handles.text_Na, 'ForegroundColor', 'blue')
    set (handles.text_Npe, 'String', num2str(Npe(1),'%4.2E'))
    set (handles.text_Npe, 'ForegroundColor', 'blue')
    set (handles.text_Ng, 'String', num2str(Ng(1),'%4.2E'))
    set (handles.text_Ng, 'ForegroundColor', 'blue')
    set (handles.text_Ngi, 'String', num2str(Ngi(1),'%4.2E'))
    set (handles.text_Ngi, 'ForegroundColor', 'blue')
%     set (handles.text_g, 'String', num2str(g(1)))
%     set (handles.text_g, 'ForegroundColor', 'blue')
%     set (handles.text_As, 'String', num2str(As(1)))
%     set (handles.text_As, 'ForegroundColor', 'blue')
    %% Setting simulation parameters and getting outputs  
    %% Graphics    
%     figure (2);
    figure (2)
    plot(dci,etar,'b','Linewidth',1.5)
    hold on
    plot (dci,etat,'r','Linewidth',1.5)
    plot (dci,etam,'g','Linewidth',1.5)
    plot (dci,etal,'k','Linewidth',1.5)
    plot (dci,etan,'y','Linewidth',1.5)
    legend('Rajogapalan and Tien, 1976','Tufenkji and Elimelech, 2004','Ma,Pedel,Fife,Johnson 2015','Long and Hilpert, 2011','Nelson and Ginn, 2011')
    set(legend, 'Location', 'Northeast')
    xlabel('Collector diameter (mm)'); ylabel('eta')
    
end

if dpiCB>0
    %% Obtaining data from the guide edit boxes
    
    dci=str2double(get(handles.dci,'String'));
    %dpi=str2double(get(handles.dpi,'String'));
    vi=str2double(get(handles.vi,'String'));
    denp=str2double(get(handles.denp,'String'));
    denf=str2double(get(handles.denf,'String'));
    visf=str2double(get(handles.visf,'String'));
    T=str2double(get(handles.T,'String'));
    A=str2double(get(handles.A,'String'));
    f=str2double(get(handles.f,'String'));
    Scf=str2double(get(handles.Scf,'String'));
    Ceff=str2double(get(handles.Ceff,'String'));
    upperval=str2double(get(handles.upperval,'String'));
    lowval=str2double(get(handles.lowval,'String'));
    nsteps=str2double(get(handles.nsteps,'String'));
    
    %% Generating vector
    
    dpi=linspace(lowval,upperval,nsteps);
    
    
    %% Transformations
    dc = dci*0.001;
    %Particle size (m)
    dp = dpi.*0.000001;
    %Pore water velocity (m/s)
    v = vi/86400; %(m/s)
    p = (1-f)^(1/3); w = 2-(3*p)+(3*(p^5))-(2*(p^6));
    %Fluid approach velocity (m3/m2/day)
    Ui = vi*f; U = Ui/86400;
    
    %% Constants
    %Boltzmann constant (j/kg)
    B = 1.381E-23;
    
    %% Dimensionless numbers
    %DIffusion Coeficient (m2/s)
    D = (B.*T)./(6.*pi.*visf.*(dp./2));
    %Happel model parameter
    As = (2.*(1-((1-f).^(5/3))))./((2-(3.*((1-f).^(1/3)))+(3.*((1-f).^(5/3)))-(2.*(1-f).^2)));
    Nr = dp./dc; %Aspect ratio
    Nlo = A./(9.*pi.*visf.*((dp./2).^2).*U); %London number
    Nvdw = A./(B.*T); % van der waals number
    Na = A./(12.*pi.*visf.*U.*((dc./2).^2)); %Attraction number
    Npe = U.*dc./D; %Peclet number
    Ng = (2.*((dp./2).^(2))*(denp-denf).*9.806)./(9.*visf.*U); %gravity number
    Ngi = 1./(1+Ng);
    g=(1-f).^(1/3);
    
    %% Calculations of rate coeficients from different authors
    
    [etadr, etair, etagr, etar, kfr, kfdr]=fRAGO(g, As, Npe, Nlo, Nr, Ng, f, v, dc, Ceff); %Rajogapalan and Tien 1976
    [etadt, etait, etagt, etat, kft, kfdt]=fTUFEN(As, Nr, Npe, Nvdw, Na, Ng, f, v, dc, Ceff); %Tufenkji and Elimelech 2004
    [etadm, etaim, etagm, etam, kfm, kfdm]=fMA(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Ma, Jhonson 2015
    [etadl, etail, etagl, etal, kfl, kfdl]=fLONG(g, Npe, Nr, As, Na, Ng, Nvdw, f, v, dc, Ceff); %Long and Hilpert 2011
    [etadn, etain, etagn, etan, kfn, kfdn]=fNEL(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Nelson and Ginn 2011
    %%  assing calculated etas to text fields and change format
    set (handles.text_etar, 'String', num2str(etar(1),'%4.2E'))
    set (handles.text_etar, 'ForegroundColor', 'blue')
    set (handles.text_etadr, 'String', num2str(etadr(1),'%4.2E'))
    set (handles.text_etadr, 'ForegroundColor', 'blue')
    set (handles.text_etair, 'String', num2str(etair(1),'%4.2E'))
    set (handles.text_etair, 'ForegroundColor', 'blue')
    set (handles.text_etagr, 'String', num2str(etagr(1),'%4.2E'))
    set (handles.text_etagr, 'ForegroundColor', 'blue')
    set (handles.text_kfr, 'String', num2str(kfr(1),'%4.2E'))
    set (handles.text_kfr, 'ForegroundColor', 'blue')
    
    set (handles.text_etat, 'String', num2str(etat(1),'%4.2E'))
    set (handles.text_etat, 'ForegroundColor', 'blue')
    set (handles.text_etadt, 'String', num2str(etadt(1),'%4.2E'))
    set (handles.text_etadt, 'ForegroundColor', 'blue')
    set (handles.text_etait, 'String', num2str(etait(1),'%4.2E'))
    set (handles.text_etait, 'ForegroundColor', 'blue')
    set (handles.text_etagt, 'String', num2str(etagt(1),'%4.2E'))
    set (handles.text_etagt, 'ForegroundColor', 'blue')
    set (handles.text_kft, 'String', num2str(kft(1),'%4.2E'))
    set (handles.text_kft, 'ForegroundColor', 'blue')
    
    set (handles.text_etam, 'String', num2str(etam(1),'%4.2E'))
    set (handles.text_etam, 'ForegroundColor', 'blue')
    set (handles.text_etadm, 'String', num2str(etadm(1),'%4.2E'))
    set (handles.text_etadm, 'ForegroundColor', 'blue')
    set (handles.text_etaim, 'String', num2str(etaim(1),'%4.2E'))
    set (handles.text_etaim, 'ForegroundColor', 'blue')
    set (handles.text_etagm, 'String', num2str(etagm(1),'%4.2E'))
    set (handles.text_etagm, 'ForegroundColor', 'blue')
    set (handles.text_kfm, 'String', num2str(kfm(1),'%4.2E'))
    set (handles.text_kfm, 'ForegroundColor', 'blue')
    
    set (handles.text_etal, 'String', num2str(etal(1),'%4.2E'))
    set (handles.text_etal, 'ForegroundColor', 'blue')
    set (handles.text_etadl, 'String', num2str(etadl(1),'%4.2E'))
    set (handles.text_etadl, 'ForegroundColor', 'blue')
    set (handles.text_etail, 'String', num2str(etail(1),'%4.2E'))
    set (handles.text_etail, 'ForegroundColor', 'blue')
    set (handles.text_etagl, 'String', num2str(etagl(1),'%4.2E'))
    set (handles.text_etagl, 'ForegroundColor', 'blue')
    set (handles.text_kfl, 'String', num2str(kfl(1),'%4.2E'))
    set (handles.text_kfl, 'ForegroundColor', 'blue')
    
    set (handles.text_etan, 'String', num2str(etan(1),'%4.2E'))
    set (handles.text_etan, 'ForegroundColor', 'blue')
    set (handles.text_etadn, 'String', num2str(etadn(1),'%4.2E'))
    set (handles.text_etadn, 'ForegroundColor', 'blue')
    set (handles.text_etain, 'String', num2str(etain(1),'%4.2E'))
    set (handles.text_etain, 'ForegroundColor', 'blue')
    set (handles.text_etagn, 'String', num2str(etagn(1),'%4.2E'))
    set (handles.text_etagn, 'ForegroundColor', 'blue')
    set (handles.text_kfn, 'String', num2str(kfn(1),'%4.2E'))
    set (handles.text_kfn, 'ForegroundColor', 'blue')
    
    set (handles.text_Nr, 'String', num2str(Nr(1),'%4.2E'))
    set (handles.text_Nr, 'ForegroundColor', 'blue')
    set (handles.text_Nlo, 'String', num2str(Nlo(1),'%4.2E'))
    set (handles.text_Nlo, 'ForegroundColor', 'blue')
    set (handles.text_Nvdw, 'String', num2str(Nvdw(1),'%4.2E'))
    set (handles.text_Nvdw, 'ForegroundColor', 'blue')
    set (handles.text_Na, 'String', num2str(Na(1),'%4.2E'))
    set (handles.text_Na, 'ForegroundColor', 'blue')
    set (handles.text_Npe, 'String', num2str(Npe(1),'%4.2E'))
    set (handles.text_Npe, 'ForegroundColor', 'blue')
    set (handles.text_Ng, 'String', num2str(Ng(1),'%4.2E'))
    set (handles.text_Ng, 'ForegroundColor', 'blue')
    set (handles.text_Ngi, 'String', num2str(Ngi(1),'%4.2E'))
    set (handles.text_Ngi, 'ForegroundColor', 'blue')
%     set (handles.text_g, 'String', num2str(g(1)))
%     set (handles.text_g, 'ForegroundColor', 'blue')
%     set (handles.text_As, 'String', num2str(As(1)))
%     set (handles.text_As, 'ForegroundColor', 'blue')
    %% Setting simulation parameters and getting outputs
    %% Graphics   
    figure (2);
    plot(dpi,etar,'b','Linewidth',1.5)
    hold on
    plot (dpi,etat,'r','Linewidth',1.5)
    plot (dpi,etam,'g','Linewidth',1.5)
    plot (dpi,etal,'k','Linewidth',1.5)
    plot (dpi,etan,'y','Linewidth',1.5)
    legend('Rajogapalan and Tien, 1976','Tufenkji and Elimelech, 2004','Ma,Pedel,Fife,Johnson 2015','Long and Hilpert, 2011','Nelson and Ginn, 2011')
    set(legend, 'Location', 'Northeast')
    xlabel('Particle size (um)'); ylabel('eta')
    
end

if viCB>0
    %% Obtaining data from the guide edit boxes
    
    dci=str2double(get(handles.dci,'String'));
    dpi=str2double(get(handles.dpi,'String'));
    %vi=str2double(get(handles.vi,'String'));
    denp=str2double(get(handles.denp,'String'));
    denf=str2double(get(handles.denf,'String'));
    visf=str2double(get(handles.visf,'String'));
    T=str2double(get(handles.T,'String'));
    A=str2double(get(handles.A,'String'));
    f=str2double(get(handles.f,'String'));
    Scf=str2double(get(handles.Scf,'String'));
    Ceff=str2double(get(handles.Ceff,'String'));
    upperval=str2double(get(handles.upperval,'String'));
    lowval=str2double(get(handles.lowval,'String'));
    nsteps=str2double(get(handles.nsteps,'String'));
    
    %% Generating vector
    
    vi=linspace(lowval,upperval,nsteps);
    
    
    %% Transformations
    dc = dci.*0.001;
    %Particle size (m)
    dp = dpi.*0.000001;
    %Pore water velocity (m/s)
    v = vi./86400; %(m/s)
    p = (1-f).^(1/3); w = 2-(3*p)+(3*(p^5))-(2*(p^6));
    %Fluid approach velocity (m3/m2/day)
    Ui = vi.*f; U = Ui./86400;
    
    %% Constants
    %Boltzmann constant (j/kg)
    B = 1.381E-23;
    
    %% Dimensionless numbers
    %DIffusion Coeficient (m2/s)
    D = (B.*T)./(6.*pi.*visf.*(dp./2));
    %Happel model parameter
    As = (2.*(1-((1-f).^(5/3))))./((2-(3.*((1-f).^(1/3)))+(3.*((1-f).^(5/3)))-(2.*(1-f).^2)));
    Nr = dp./dc; %Aspect ratio
    Nlo = A./(9.*pi.*visf.*((dp./2).^2).*U); %London number
    Nvdw = A./(B.*T); % van der waals number
    Na = A./(12.*pi.*visf.*U.*((dc./2).^2)); %Attraction number
    Npe = U.*dc./D; %Peclet number
    Ng = (2.*((dp./2).^(2))*(denp-denf).*9.806)./(9.*visf.*U); %gravity number
    Ngi = 1./(1+Ng);
    g=(1-f).^(1/3);
    
    %% Calculations of rate coeficients from different authors
    
    [etadr, etair, etagr, etar, kfr, kfdr]=fRAGO(g, As, Npe, Nlo, Nr, Ng, f, v, dc, Ceff); %Rajogapalan and Tien 1976
    [etadt, etait, etagt, etat, kft, kfdt]=fTUFEN(As, Nr, Npe, Nvdw, Na, Ng, f, v, dc, Ceff); %Tufenkji and Elimelech 2004
    [etadm, etaim, etagm, etam, kfm, kfdm]=fMA(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Ma, Jhonson 2015
    [etadl, etail, etagl, etal, kfl, kfdl]=fLONG(g, Npe, Nr, As, Na, Ng, Nvdw, f, v, dc, Ceff); %Long and Hilpert 2011
    [etadn, etain, etagn, etan, kfn, kfdn]=fNEL(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Nelson and Ginn 2011
    %%  assing calculated etas to text fields and change format
    set (handles.text_etar, 'String', num2str(etar(1),'%4.2E'))
    set (handles.text_etar, 'ForegroundColor', 'blue')
    set (handles.text_etadr, 'String', num2str(etadr(1),'%4.2E'))
    set (handles.text_etadr, 'ForegroundColor', 'blue')
    set (handles.text_etair, 'String', num2str(etair(1),'%4.2E'))
    set (handles.text_etair, 'ForegroundColor', 'blue')
    set (handles.text_etagr, 'String', num2str(etagr(1),'%4.2E'))
    set (handles.text_etagr, 'ForegroundColor', 'blue')
    set (handles.text_kfr, 'String', num2str(kfr(1),'%4.2E'))
    set (handles.text_kfr, 'ForegroundColor', 'blue')
    
    set (handles.text_etat, 'String', num2str(etat(1),'%4.2E'))
    set (handles.text_etat, 'ForegroundColor', 'blue')
    set (handles.text_etadt, 'String', num2str(etadt(1),'%4.2E'))
    set (handles.text_etadt, 'ForegroundColor', 'blue')
    set (handles.text_etait, 'String', num2str(etait(1),'%4.2E'))
    set (handles.text_etait, 'ForegroundColor', 'blue')
    set (handles.text_etagt, 'String', num2str(etagt(1),'%4.2E'))
    set (handles.text_etagt, 'ForegroundColor', 'blue')
    set (handles.text_kft, 'String', num2str(kft(1),'%4.2E'))
    set (handles.text_kft, 'ForegroundColor', 'blue')
    
    set (handles.text_etam, 'String', num2str(etam(1),'%4.2E'))
    set (handles.text_etam, 'ForegroundColor', 'blue')
    set (handles.text_etadm, 'String', num2str(etadm(1),'%4.2E'))
    set (handles.text_etadm, 'ForegroundColor', 'blue')
    set (handles.text_etaim, 'String', num2str(etaim(1),'%4.2E'))
    set (handles.text_etaim, 'ForegroundColor', 'blue')
    set (handles.text_etagm, 'String', num2str(etagm(1),'%4.2E'))
    set (handles.text_etagm, 'ForegroundColor', 'blue')
    set (handles.text_kfm, 'String', num2str(kfm(1),'%4.2E'))
    set (handles.text_kfm, 'ForegroundColor', 'blue')
    
    set (handles.text_etal, 'String', num2str(etal(1),'%4.2E'))
    set (handles.text_etal, 'ForegroundColor', 'blue')
    set (handles.text_etadl, 'String', num2str(etadl(1),'%4.2E'))
    set (handles.text_etadl, 'ForegroundColor', 'blue')
    set (handles.text_etail, 'String', num2str(etail(1),'%4.2E'))
    set (handles.text_etail, 'ForegroundColor', 'blue')
    set (handles.text_etagl, 'String', num2str(etagl(1),'%4.2E'))
    set (handles.text_etagl, 'ForegroundColor', 'blue')
    set (handles.text_kfl, 'String', num2str(kfl(1),'%4.2E'))
    set (handles.text_kfl, 'ForegroundColor', 'blue')
    
    set (handles.text_etan, 'String', num2str(etan(1),'%4.2E'))
    set (handles.text_etan, 'ForegroundColor', 'blue')
    set (handles.text_etadn, 'String', num2str(etadn(1),'%4.2E'))
    set (handles.text_etadn, 'ForegroundColor', 'blue')
    set (handles.text_etain, 'String', num2str(etain(1),'%4.2E'))
    set (handles.text_etain, 'ForegroundColor', 'blue')
    set (handles.text_etagn, 'String', num2str(etagn(1),'%4.2E'))
    set (handles.text_etagn, 'ForegroundColor', 'blue')
    set (handles.text_kfn, 'String', num2str(kfn(1),'%4.2E'))
    set (handles.text_kfn, 'ForegroundColor', 'blue')
    
    set (handles.text_Nr, 'String', num2str(Nr(1),'%4.2E'))
    set (handles.text_Nr, 'ForegroundColor', 'blue')
    set (handles.text_Nlo, 'String', num2str(Nlo(1),'%4.2E'))
    set (handles.text_Nlo, 'ForegroundColor', 'blue')
    set (handles.text_Nvdw, 'String', num2str(Nvdw(1),'%4.2E'))
    set (handles.text_Nvdw, 'ForegroundColor', 'blue')
    set (handles.text_Na, 'String', num2str(Na(1),'%4.2E'))
    set (handles.text_Na, 'ForegroundColor', 'blue')
    set (handles.text_Npe, 'String', num2str(Npe(1),'%4.2E'))
    set (handles.text_Npe, 'ForegroundColor', 'blue')
    set (handles.text_Ng, 'String', num2str(Ng(1),'%4.2E'))
    set (handles.text_Ng, 'ForegroundColor', 'blue')
    set (handles.text_Ngi, 'String', num2str(Ngi(1),'%4.2E'))
    set (handles.text_Ngi, 'ForegroundColor', 'blue')
%     set (handles.text_g, 'String', num2str(g(1),'%4.2E'))
%     set (handles.text_g, 'ForegroundColor', 'blue')
%     set (handles.text_As, 'String', num2str(As(1),'%4.2E'))
%     set (handles.text_As, 'ForegroundColor', 'blue')
    %% Setting simulation parameters and getting outputs
    %% Graphics
    figure (2);
    plot(vi,etar,'b','Linewidth',1.5)
    hold on
    plot (vi,etat,'r','Linewidth',1.5)
    plot (vi,etam,'g','Linewidth',1.5)
    plot (vi,etal,'k','Linewidth',1.5)
    plot (vi,etan,'y','Linewidth',1.5)
    legend('Rajogapalan and Tien, 1976','Tufenkji and Elimelech, 2004','Ma,Pedel,Fife,Johnson 2015','Long and Hilpert, 2011','Nelson and Ginn, 2011')
    set(legend, 'Location', 'Northeast')
    xlabel('Pore water velocity (m/day)'); ylabel('eta')
    
end

if denpCB>0
    %% Obtaining data from the guide edit boxes
    
    dci=str2double(get(handles.dci,'String'));
    dpi=str2double(get(handles.dpi,'String'));
    vi=str2double(get(handles.vi,'String'));
    %denp=str2double(get(handles.denp,'String'));
    denf=str2double(get(handles.denf,'String'));
    visf=str2double(get(handles.visf,'String'));
    T=str2double(get(handles.T,'String'));
    A=str2double(get(handles.A,'String'));
    f=str2double(get(handles.f,'String'));
    Scf=str2double(get(handles.Scf,'String'));
    Ceff=str2double(get(handles.Ceff,'String'));
    upperval=str2double(get(handles.upperval,'String'));
    lowval=str2double(get(handles.lowval,'String'));
    nsteps=str2double(get(handles.nsteps,'String'));
    
    %% Generating vector
    
    denp=linspace(lowval,upperval,nsteps);
    
    
    %% Transformations
    dc = dci.*0.001;
    %Particle size (m)
    dp = dpi.*0.000001;
    %Pore water velocity (m/s)
    v = vi./86400; %(m/s)
    p = (1-f).^(1/3); w = 2-(3*p)+(3*(p^5))-(2*(p^6));
    %Fluid approach velocity (m3/m2/day)
    Ui = vi.*f; U = Ui./86400;
    
    %% Constants
    %Boltzmann constant (j/kg)
    B = 1.381E-23;
    
    %% Dimensionless numbers
    %DIffusion Coeficient (m2/s)
    D = (B.*T)./(6.*pi.*visf.*(dp./2));
    %Happel model parameter
    As = (2.*(1-((1-f).^(5/3))))./((2-(3.*((1-f).^(1/3)))+(3.*((1-f).^(5/3)))-(2.*(1-f).^2)));
    Nr = dp./dc; %Aspect ratio
    Nlo = A./(9.*pi.*visf.*((dp./2).^2).*U); %London number
    Nvdw = A./(B.*T); % van der waals number
    Na = A./(12.*pi.*visf.*U.*((dc./2).^2)); %Attraction number
    Npe = U.*dc./D; %Peclet number
    Ng = (2.*((dp./2).^(2))*(denp-denf).*9.806)./(9.*visf.*U); %gravity number
    Ngi = 1./(1+Ng);
    g=(1-f).^(1/3);
    
    %% Calculations of rate coeficients from different authors
    
    [etadr, etair, etagr, etar, kfr, kfdr]=fRAGO(g, As, Npe, Nlo, Nr, Ng, f, v, dc, Ceff); %Rajogapalan and Tien 1976
    [etadt, etait, etagt, etat, kft, kfdt]=fTUFEN(As, Nr, Npe, Nvdw, Na, Ng, f, v, dc, Ceff); %Tufenkji and Elimelech 2004
    [etadm, etaim, etagm, etam, kfm, kfdm]=fMA(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Ma, Jhonson 2015
    [etadl, etail, etagl, etal, kfl, kfdl]=fLONG(g, Npe, Nr, As, Na, Ng, Nvdw, f, v, dc, Ceff); %Long and Hilpert 2011
    [etadn, etain, etagn, etan, kfn, kfdn]=fNEL(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Nelson and Ginn 2011
    %%  assing calculated etas to text fields and change format
    set (handles.text_etar, 'String', num2str(etar(1),'%4.2E'))
    set (handles.text_etar, 'ForegroundColor', 'blue')
    set (handles.text_etadr, 'String', num2str(etadr(1),'%4.2E'))
    set (handles.text_etadr, 'ForegroundColor', 'blue')
    set (handles.text_etair, 'String', num2str(etair(1),'%4.2E'))
    set (handles.text_etair, 'ForegroundColor', 'blue')
    set (handles.text_etagr, 'String', num2str(etagr(1),'%4.2E'))
    set (handles.text_etagr, 'ForegroundColor', 'blue')
    set (handles.text_kfr, 'String', num2str(kfr(1),'%4.2E'))
    set (handles.text_kfr, 'ForegroundColor', 'blue')
    
    set (handles.text_etat, 'String', num2str(etat(1),'%4.2E'))
    set (handles.text_etat, 'ForegroundColor', 'blue')
    set (handles.text_etadt, 'String', num2str(etadt(1),'%4.2E'))
    set (handles.text_etadt, 'ForegroundColor', 'blue')
    set (handles.text_etait, 'String', num2str(etait(1),'%4.2E'))
    set (handles.text_etait, 'ForegroundColor', 'blue')
    set (handles.text_etagt, 'String', num2str(etagt(1),'%4.2E'))
    set (handles.text_etagt, 'ForegroundColor', 'blue')
    set (handles.text_kft, 'String', num2str(kft(1),'%4.2E'))
    set (handles.text_kft, 'ForegroundColor', 'blue')
    
    set (handles.text_etam, 'String', num2str(etam(1),'%4.2E'))
    set (handles.text_etam, 'ForegroundColor', 'blue')
    set (handles.text_etadm, 'String', num2str(etadm(1),'%4.2E'))
    set (handles.text_etadm, 'ForegroundColor', 'blue')
    set (handles.text_etaim, 'String', num2str(etaim(1),'%4.2E'))
    set (handles.text_etaim, 'ForegroundColor', 'blue')
    set (handles.text_etagm, 'String', num2str(etagm(1),'%4.2E'))
    set (handles.text_etagm, 'ForegroundColor', 'blue')
    set (handles.text_kfm, 'String', num2str(kfm(1),'%4.2E'))
    set (handles.text_kfm, 'ForegroundColor', 'blue')
    
    set (handles.text_etal, 'String', num2str(etal(1),'%4.2E'))
    set (handles.text_etal, 'ForegroundColor', 'blue')
    set (handles.text_etadl, 'String', num2str(etadl(1),'%4.2E'))
    set (handles.text_etadl, 'ForegroundColor', 'blue')
    set (handles.text_etail, 'String', num2str(etail(1),'%4.2E'))
    set (handles.text_etail, 'ForegroundColor', 'blue')
    set (handles.text_etagl, 'String', num2str(etagl(1),'%4.2E'))
    set (handles.text_etagl, 'ForegroundColor', 'blue')
    set (handles.text_kfl, 'String', num2str(kfl(1),'%4.2E'))
    set (handles.text_kfl, 'ForegroundColor', 'blue')
    
    set (handles.text_etan, 'String', num2str(etan(1),'%4.2E'))
    set (handles.text_etan, 'ForegroundColor', 'blue')
    set (handles.text_etadn, 'String', num2str(etadn(1),'%4.2E'))
    set (handles.text_etadn, 'ForegroundColor', 'blue')
    set (handles.text_etain, 'String', num2str(etain(1),'%4.2E'))
    set (handles.text_etain, 'ForegroundColor', 'blue')
    set (handles.text_etagn, 'String', num2str(etagn(1),'%4.2E'))
    set (handles.text_etagn, 'ForegroundColor', 'blue')
    set (handles.text_kfn, 'String', num2str(kfn(1),'%4.2E'))
    set (handles.text_kfn, 'ForegroundColor', 'blue')
    
    set (handles.text_Nr, 'String', num2str(Nr(1),'%4.2E'))
    set (handles.text_Nr, 'ForegroundColor', 'blue')
    set (handles.text_Nlo, 'String', num2str(Nlo(1),'%4.2E'))
    set (handles.text_Nlo, 'ForegroundColor', 'blue')
    set (handles.text_Nvdw, 'String', num2str(Nvdw(1),'%4.2E'))
    set (handles.text_Nvdw, 'ForegroundColor', 'blue')
    set (handles.text_Na, 'String', num2str(Na(1),'%4.2E'))
    set (handles.text_Na, 'ForegroundColor', 'blue')
    set (handles.text_Npe, 'String', num2str(Npe(1),'%4.2E'))
    set (handles.text_Npe, 'ForegroundColor', 'blue')
    set (handles.text_Ng, 'String', num2str(Ng(1),'%4.2E'))
    set (handles.text_Ng, 'ForegroundColor', 'blue')
    set (handles.text_Ngi, 'String', num2str(Ngi(1),'%4.2E'))
    set (handles.text_Ngi, 'ForegroundColor', 'blue')
%     set (handles.text_g, 'String', num2str(g(1),'%4.2E'))
%     set (handles.text_g, 'ForegroundColor', 'blue')
%     set (handles.text_As, 'String', num2str(As(1),'%4.2E'))
%     set (handles.text_As, 'ForegroundColor', 'blue')
    %% Setting simulation parameters and getting outputs
    %% Graphics
    figure (2);
    plot(denp,etar,'b','Linewidth',1.5)
    hold on
    plot (denp,etat,'r','Linewidth',1.5)
    plot (denp,etam,'g','Linewidth',1.5)
    plot (denp,etal,'k','Linewidth',1.5)
    plot (denp,etan,'y','Linewidth',1.5)
    legend('Rajogapalan and Tien, 1976','Tufenkji and Elimelech, 2004','Ma,Pedel,Fife,Johnson 2015','Long and Hilpert, 2011','Nelson and Ginn, 2011')
    set(legend, 'Location', 'Northwest')
    xlabel('Particle density (kg/m^3)'); ylabel('eta')
    
end

if denfCB>0
    %% Obtaining data from the guide edit boxes
    
    dci=str2double(get(handles.dci,'String'));
    dpi=str2double(get(handles.dpi,'String'));
    vi=str2double(get(handles.vi,'String'));
    denp=str2double(get(handles.denp,'String'));
    %denf=str2double(get(handles.denf,'String'));
    visf=str2double(get(handles.visf,'String'));
    T=str2double(get(handles.T,'String'));
    A=str2double(get(handles.A,'String'));
    f=str2double(get(handles.f,'String'));
    Scf=str2double(get(handles.Scf,'String'));
    Ceff=str2double(get(handles.Ceff,'String'));
    upperval=str2double(get(handles.upperval,'String'));
    lowval=str2double(get(handles.lowval,'String'));
    nsteps=str2double(get(handles.nsteps,'String'));
    
    %% Generating vector
    
    denf=linspace(lowval,upperval,nsteps);
    
    
    %% Transformations
    dc = dci.*0.001;
    %Particle size (m)
    dp = dpi.*0.000001;
    %Pore water velocity (m/s)
    v = vi./86400; %(m/s)
    p = (1-f).^(1/3); w = 2-(3*p)+(3*(p^5))-(2*(p^6));
    %Fluid approach velocity (m3/m2/day)
    Ui = vi.*f; U = Ui./86400;
    
    %% Constants
    %Boltzmann constant (j/kg)
    B = 1.381E-23;
    
    %% Dimensionless numbers
    %DIffusion Coeficient (m2/s)
    D = (B.*T)./(6.*pi.*visf.*(dp./2));
    %Happel model parameter
    As = (2.*(1-((1-f).^(5/3))))./((2-(3.*((1-f).^(1/3)))+(3.*((1-f).^(5/3)))-(2.*(1-f).^2)));
    Nr = dp./dc; %Aspect ratio
    Nlo = A./(9.*pi.*visf.*((dp./2).^2).*U); %London number
    Nvdw = A./(B.*T); % van der waals number
    Na = A./(12.*pi.*visf.*U.*((dc./2).^2)); %Attraction number
    Npe = U.*dc./D; %Peclet number
    Ng = (2.*((dp./2).^(2))*(denp-denf).*9.806)./(9.*visf.*U); %gravity number
    Ngi = 1./(1+Ng);
    g=(1-f).^(1/3);
    
    %% Calculations of rate coeficients from different authors
    
    [etadr, etair, etagr, etar, kfr, kfdr]=fRAGO(g, As, Npe, Nlo, Nr, Ng, f, v, dc, Ceff); %Rajogapalan and Tien 1976
    [etadt, etait, etagt, etat, kft, kfdt]=fTUFEN(As, Nr, Npe, Nvdw, Na, Ng, f, v, dc, Ceff); %Tufenkji and Elimelech 2004
    [etadm, etaim, etagm, etam, kfm, kfdm]=fMA(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Ma, Jhonson 2015
    [etadl, etail, etagl, etal, kfl, kfdl]=fLONG(g, Npe, Nr, As, Na, Ng, Nvdw, f, v, dc, Ceff); %Long and Hilpert 2011
    [etadn, etain, etagn, etan, kfn, kfdn]=fNEL(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Nelson and Ginn 2011
    %%  assing calculated etas to text fields and change format
    set (handles.text_etar, 'String', num2str(etar(1),'%4.2E'))
    set (handles.text_etar, 'ForegroundColor', 'blue')
    set (handles.text_etadr, 'String', num2str(etadr(1),'%4.2E'))
    set (handles.text_etadr, 'ForegroundColor', 'blue')
    set (handles.text_etair, 'String', num2str(etair(1),'%4.2E'))
    set (handles.text_etair, 'ForegroundColor', 'blue')
    set (handles.text_etagr, 'String', num2str(etagr(1),'%4.2E'))
    set (handles.text_etagr, 'ForegroundColor', 'blue')
    set (handles.text_kfr, 'String', num2str(kfr(1),'%4.2E'))
    set (handles.text_kfr, 'ForegroundColor', 'blue')
    
    set (handles.text_etat, 'String', num2str(etat(1),'%4.2E'))
    set (handles.text_etat, 'ForegroundColor', 'blue')
    set (handles.text_etadt, 'String', num2str(etadt(1),'%4.2E'))
    set (handles.text_etadt, 'ForegroundColor', 'blue')
    set (handles.text_etait, 'String', num2str(etait(1),'%4.2E'))
    set (handles.text_etait, 'ForegroundColor', 'blue')
    set (handles.text_etagt, 'String', num2str(etagt(1),'%4.2E'))
    set (handles.text_etagt, 'ForegroundColor', 'blue')
    set (handles.text_kft, 'String', num2str(kft(1),'%4.2E'))
    set (handles.text_kft, 'ForegroundColor', 'blue')
    
    set (handles.text_etam, 'String', num2str(etam(1),'%4.2E'))
    set (handles.text_etam, 'ForegroundColor', 'blue')
    set (handles.text_etadm, 'String', num2str(etadm(1),'%4.2E'))
    set (handles.text_etadm, 'ForegroundColor', 'blue')
    set (handles.text_etaim, 'String', num2str(etaim(1),'%4.2E'))
    set (handles.text_etaim, 'ForegroundColor', 'blue')
    set (handles.text_etagm, 'String', num2str(etagm(1),'%4.2E'))
    set (handles.text_etagm, 'ForegroundColor', 'blue')
    set (handles.text_kfm, 'String', num2str(kfm(1),'%4.2E'))
    set (handles.text_kfm, 'ForegroundColor', 'blue')
    
    set (handles.text_etal, 'String', num2str(etal(1),'%4.2E'))
    set (handles.text_etal, 'ForegroundColor', 'blue')
    set (handles.text_etadl, 'String', num2str(etadl(1),'%4.2E'))
    set (handles.text_etadl, 'ForegroundColor', 'blue')
    set (handles.text_etail, 'String', num2str(etail(1),'%4.2E'))
    set (handles.text_etail, 'ForegroundColor', 'blue')
    set (handles.text_etagl, 'String', num2str(etagl(1),'%4.2E'))
    set (handles.text_etagl, 'ForegroundColor', 'blue')
    set (handles.text_kfl, 'String', num2str(kfl(1),'%4.2E'))
    set (handles.text_kfl, 'ForegroundColor', 'blue')
    
    set (handles.text_etan, 'String', num2str(etan(1),'%4.2E'))
    set (handles.text_etan, 'ForegroundColor', 'blue')
    set (handles.text_etadn, 'String', num2str(etadn(1),'%4.2E'))
    set (handles.text_etadn, 'ForegroundColor', 'blue')
    set (handles.text_etain, 'String', num2str(etain(1),'%4.2E'))
    set (handles.text_etain, 'ForegroundColor', 'blue')
    set (handles.text_etagn, 'String', num2str(etagn(1),'%4.2E'))
    set (handles.text_etagn, 'ForegroundColor', 'blue')
    set (handles.text_kfn, 'String', num2str(kfn(1),'%4.2E'))
    set (handles.text_kfn, 'ForegroundColor', 'blue')
    
    set (handles.text_Nr, 'String', num2str(Nr(1),'%4.2E'))
    set (handles.text_Nr, 'ForegroundColor', 'blue')
    set (handles.text_Nlo, 'String', num2str(Nlo(1),'%4.2E'))
    set (handles.text_Nlo, 'ForegroundColor', 'blue')
    set (handles.text_Nvdw, 'String', num2str(Nvdw(1),'%4.2E'))
    set (handles.text_Nvdw, 'ForegroundColor', 'blue')
    set (handles.text_Na, 'String', num2str(Na(1),'%4.2E'))
    set (handles.text_Na, 'ForegroundColor', 'blue')
    set (handles.text_Npe, 'String', num2str(Npe(1),'%4.2E'))
    set (handles.text_Npe, 'ForegroundColor', 'blue')
    set (handles.text_Ng, 'String', num2str(Ng(1),'%4.2E'))
    set (handles.text_Ng, 'ForegroundColor', 'blue')
    set (handles.text_Ngi, 'String', num2str(Ngi(1),'%4.2E'))
    set (handles.text_Ngi, 'ForegroundColor', 'blue')
%     set (handles.text_g, 'String', num2str(g(1),'%4.2E'))
%     set (handles.text_g, 'ForegroundColor', 'blue')
%     set (handles.text_As, 'String', num2str(As(1),'%4.2E'))
%     set (handles.text_As, 'ForegroundColor', 'blue')
    %% Setting simulation parameters and getting outputs
    %% Graphics
    figure (2);
    plot(denf,etar,'b','Linewidth',1.5)
    hold on
    plot (denf,etat,'r','Linewidth',1.5)
    plot (denf,etam,'g','Linewidth',1.5)
    plot (denf,etal,'k','Linewidth',1.5)
    plot (denf,etan,'y','Linewidth',1.5)
    legend('Rajogapalan and Tien, 1976','Tufenkji and Elimelech, 2004','Ma,Pedel,Fife,Johnson 2015','Long and Hilpert, 2011','Nelson and Ginn, 2011')
    set(legend, 'Location', 'Northeast')
    xlabel('Fluid density (kg/m^3)'); ylabel('eta')
    
end



if visfCB>0
    %% Obtaining data from the guide edit boxes
    
    dci=str2double(get(handles.dci,'String'));
    dpi=str2double(get(handles.dpi,'String'));
    vi=str2double(get(handles.vi,'String'));
    denp=str2double(get(handles.denp,'String'));
    denf=str2double(get(handles.denf,'String'));
    %visf=str2double(get(handles.visf,'String'));
    T=str2double(get(handles.T,'String'));
    A=str2double(get(handles.A,'String'));
    f=str2double(get(handles.f,'String'));
    Scf=str2double(get(handles.Scf,'String'));
    Ceff=str2double(get(handles.Ceff,'String'));
    upperval=str2double(get(handles.upperval,'String'));
    lowval=str2double(get(handles.lowval,'String'));
    nsteps=str2double(get(handles.nsteps,'String'));
    
    %% Generating vector
    
    visf=linspace(lowval,upperval,nsteps);
    
    
    %% Transformations
    dc = dci.*0.001;
    %Particle size (m)
    dp = dpi.*0.000001;
    %Pore water velocity (m/s)
    v = vi./86400; %(m/s)
    p = (1-f).^(1/3); w = 2-(3*p)+(3*(p^5))-(2*(p^6));
    %Fluid approach velocity (m3/m2/day)
    Ui = vi.*f; U = Ui./86400;
    
    %% Constants
    %Boltzmann constant (j/kg)
    B = 1.381E-23;
    
    %% Dimensionless numbers
    %DIffusion Coeficient (m2/s)
    D = (B.*T)./(6.*pi.*visf.*(dp./2));
    %Happel model parameter
    As = (2.*(1-((1-f).^(5/3))))./((2-(3.*((1-f).^(1/3)))+(3.*((1-f).^(5/3)))-(2.*(1-f).^2)));
    Nr = dp./dc; %Aspect ratio
    Nlo = A./(9.*pi.*visf.*((dp./2).^2).*U); %London number
    Nvdw = A./(B.*T); % van der waals number
    Na = A./(12.*pi.*visf.*U.*((dc./2).^2)); %Attraction number
    Npe = U.*dc./D; %Peclet number
    Ng = (2.*((dp./2).^(2))*(denp-denf).*9.806)./(9.*visf.*U); %gravity number
    Ngi = 1./(1+Ng);
    g=(1-f).^(1/3);
    
    %% Calculations of rate coeficients from different authors
    
    [etadr, etair, etagr, etar, kfr, kfdr]=fRAGO(g, As, Npe, Nlo, Nr, Ng, f, v, dc, Ceff); %Rajogapalan and Tien 1976
    [etadt, etait, etagt, etat, kft, kfdt]=fTUFEN(As, Nr, Npe, Nvdw, Na, Ng, f, v, dc, Ceff); %Tufenkji and Elimelech 2004
    [etadm, etaim, etagm, etam, kfm, kfdm]=fMA(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Ma, Jhonson 2015
    [etadl, etail, etagl, etal, kfl, kfdl]=fLONG(g, Npe, Nr, As, Na, Ng, Nvdw, f, v, dc, Ceff); %Long and Hilpert 2011
    [etadn, etain, etagn, etan, kfn, kfdn]=fNEL(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Nelson and Ginn 2011
    %%  assing calculated etas to text fields and change format
    set (handles.text_etar, 'String', num2str(etar(1),'%4.2E'))
    set (handles.text_etar, 'ForegroundColor', 'blue')
    set (handles.text_etadr, 'String', num2str(etadr(1),'%4.2E'))
    set (handles.text_etadr, 'ForegroundColor', 'blue')
    set (handles.text_etair, 'String', num2str(etair(1),'%4.2E'))
    set (handles.text_etair, 'ForegroundColor', 'blue')
    set (handles.text_etagr, 'String', num2str(etagr(1),'%4.2E'))
    set (handles.text_etagr, 'ForegroundColor', 'blue')
    set (handles.text_kfr, 'String', num2str(kfr(1),'%4.2E'))
    set (handles.text_kfr, 'ForegroundColor', 'blue')
    
    set (handles.text_etat, 'String', num2str(etat(1),'%4.2E'))
    set (handles.text_etat, 'ForegroundColor', 'blue')
    set (handles.text_etadt, 'String', num2str(etadt(1),'%4.2E'))
    set (handles.text_etadt, 'ForegroundColor', 'blue')
    set (handles.text_etait, 'String', num2str(etait(1),'%4.2E'))
    set (handles.text_etait, 'ForegroundColor', 'blue')
    set (handles.text_etagt, 'String', num2str(etagt(1),'%4.2E'))
    set (handles.text_etagt, 'ForegroundColor', 'blue')
    set (handles.text_kft, 'String', num2str(kft(1),'%4.2E'))
    set (handles.text_kft, 'ForegroundColor', 'blue')
    
    set (handles.text_etam, 'String', num2str(etam(1),'%4.2E'))
    set (handles.text_etam, 'ForegroundColor', 'blue')
    set (handles.text_etadm, 'String', num2str(etadm(1),'%4.2E'))
    set (handles.text_etadm, 'ForegroundColor', 'blue')
    set (handles.text_etaim, 'String', num2str(etaim(1),'%4.2E'))
    set (handles.text_etaim, 'ForegroundColor', 'blue')
    set (handles.text_etagm, 'String', num2str(etagm(1),'%4.2E'))
    set (handles.text_etagm, 'ForegroundColor', 'blue')
    set (handles.text_kfm, 'String', num2str(kfm(1),'%4.2E'))
    set (handles.text_kfm, 'ForegroundColor', 'blue')
    
    set (handles.text_etal, 'String', num2str(etal(1),'%4.2E'))
    set (handles.text_etal, 'ForegroundColor', 'blue')
    set (handles.text_etadl, 'String', num2str(etadl(1),'%4.2E'))
    set (handles.text_etadl, 'ForegroundColor', 'blue')
    set (handles.text_etail, 'String', num2str(etail(1),'%4.2E'))
    set (handles.text_etail, 'ForegroundColor', 'blue')
    set (handles.text_etagl, 'String', num2str(etagl(1),'%4.2E'))
    set (handles.text_etagl, 'ForegroundColor', 'blue')
    set (handles.text_kfl, 'String', num2str(kfl(1),'%4.2E'))
    set (handles.text_kfl, 'ForegroundColor', 'blue')
    
    set (handles.text_etan, 'String', num2str(etan(1),'%4.2E'))
    set (handles.text_etan, 'ForegroundColor', 'blue')
    set (handles.text_etadn, 'String', num2str(etadn(1),'%4.2E'))
    set (handles.text_etadn, 'ForegroundColor', 'blue')
    set (handles.text_etain, 'String', num2str(etain(1),'%4.2E'))
    set (handles.text_etain, 'ForegroundColor', 'blue')
    set (handles.text_etagn, 'String', num2str(etagn(1),'%4.2E'))
    set (handles.text_etagn, 'ForegroundColor', 'blue')
    set (handles.text_kfn, 'String', num2str(kfn(1),'%4.2E'))
    set (handles.text_kfn, 'ForegroundColor', 'blue')
    
    set (handles.text_Nr, 'String', num2str(Nr(1),'%4.2E'))
    set (handles.text_Nr, 'ForegroundColor', 'blue')
    set (handles.text_Nlo, 'String', num2str(Nlo(1),'%4.2E'))
    set (handles.text_Nlo, 'ForegroundColor', 'blue')
    set (handles.text_Nvdw, 'String', num2str(Nvdw(1),'%4.2E'))
    set (handles.text_Nvdw, 'ForegroundColor', 'blue')
    set (handles.text_Na, 'String', num2str(Na(1),'%4.2E'))
    set (handles.text_Na, 'ForegroundColor', 'blue')
    set (handles.text_Npe, 'String', num2str(Npe(1),'%4.2E'))
    set (handles.text_Npe, 'ForegroundColor', 'blue')
    set (handles.text_Ng, 'String', num2str(Ng(1),'%4.2E'))
    set (handles.text_Ng, 'ForegroundColor', 'blue')
    set (handles.text_Ngi, 'String', num2str(Ngi(1),'%4.2E'))
    set (handles.text_Ngi, 'ForegroundColor', 'blue')
%     set (handles.text_g, 'String', num2str(g(1),'%4.2E'))
%     set (handles.text_g, 'ForegroundColor', 'blue')
%     set (handles.text_As, 'String', num2str(As(1),'%4.2E'))
%     set (handles.text_As, 'ForegroundColor', 'blue')
    %% Setting simulation parameters and getting outputs
    %% Graphics
    figure (2);
    plot(visf,etar,'b','Linewidth',1.5)
    hold on
    plot (visf,etat,'r','Linewidth',1.5)
    plot (visf,etam,'g','Linewidth',1.5)
    plot (visf,etal,'k','Linewidth',1.5)
    plot (visf,etan,'y','Linewidth',1.5)
    legend('Rajogapalan and Tien, 1976','Tufenkji and Elimelech, 2004','Ma,Pedel,Fife,Johnson 2015','Long and Hilpert, 2011','Nelson and Ginn, 2011')
    set(legend, 'Location', 'Northeast')
    xlabel('Fluid viscosity (kg/m*s)'); ylabel('eta')
    
end

if TCB>0
    %% Obtaining data from the guide edit boxes
    
    dci=str2double(get(handles.dci,'String'));
    dpi=str2double(get(handles.dpi,'String'));
    vi=str2double(get(handles.vi,'String'));
    denp=str2double(get(handles.denp,'String'));
    denf=str2double(get(handles.denf,'String'));
    visf=str2double(get(handles.visf,'String'));
    %T=str2double(get(handles.T,'String'));
    A=str2double(get(handles.A,'String'));
    f=str2double(get(handles.f,'String'));
    Scf=str2double(get(handles.Scf,'String'));
    Ceff=str2double(get(handles.Ceff,'String'));
    upperval=str2double(get(handles.upperval,'String'));
    lowval=str2double(get(handles.lowval,'String'));
    nsteps=str2double(get(handles.nsteps,'String'));
    
    %% Generating vector
    
    T=linspace(lowval,upperval,nsteps);
    
    
    %% Transformations
    dc = dci.*0.001;
    %Particle size (m)
    dp = dpi.*0.000001;
    %Pore water velocity (m/s)
    v = vi./86400; %(m/s)
    p = (1-f).^(1/3); w = 2-(3*p)+(3*(p^5))-(2*(p^6));
    %Fluid approach velocity (m3/m2/day)
    Ui = vi.*f; U = Ui./86400;
    
    %% Constants
    %Boltzmann constant (j/kg)
    B = 1.381E-23;
    
    %% Dimensionless numbers
    %DIffusion Coeficient (m2/s)
    D = (B.*T)./(6.*pi.*visf.*(dp./2));
    %Happel model parameter
    As = (2.*(1-((1-f).^(5/3))))./((2-(3.*((1-f).^(1/3)))+(3.*((1-f).^(5/3)))-(2.*(1-f).^2)));
    Nr = dp./dc; %Aspect ratio
    Nlo = A./(9.*pi.*visf.*((dp./2).^2).*U); %London number
    Nvdw = A./(B.*T); % van der waals number
    Na = A./(12.*pi.*visf.*U.*((dc./2).^2)); %Attraction number
    Npe = U.*dc./D; %Peclet number
    Ng = (2.*((dp./2).^(2))*(denp-denf).*9.806)./(9.*visf.*U); %gravity number
    Ngi = 1./(1+Ng);
    g=(1-f).^(1/3);
    
    %% Calculations of rate coeficients from different authors
    
    [etadr, etair, etagr, etar, kfr, kfdr]=fRAGO(g, As, Npe, Nlo, Nr, Ng, f, v, dc, Ceff); %Rajogapalan and Tien 1976
    [etadt, etait, etagt, etat, kft, kfdt]=fTUFEN(As, Nr, Npe, Nvdw, Na, Ng, f, v, dc, Ceff); %Tufenkji and Elimelech 2004
    [etadm, etaim, etagm, etam, kfm, kfdm]=fMA(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Ma, Jhonson 2015
    [etadl, etail, etagl, etal, kfl, kfdl]=fLONG(g, Npe, Nr, As, Na, Ng, Nvdw, f, v, dc, Ceff); %Long and Hilpert 2011
    [etadn, etain, etagn, etan, kfn, kfdn]=fNEL(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Nelson and Ginn 2011
    %%  assing calculated etas to text fields and change format
    set (handles.text_etar, 'String', num2str(etar(1),'%4.2E'))
    set (handles.text_etar, 'ForegroundColor', 'blue')
    set (handles.text_etadr, 'String', num2str(etadr(1),'%4.2E'))
    set (handles.text_etadr, 'ForegroundColor', 'blue')
    set (handles.text_etair, 'String', num2str(etair(1),'%4.2E'))
    set (handles.text_etair, 'ForegroundColor', 'blue')
    set (handles.text_etagr, 'String', num2str(etagr(1),'%4.2E'))
    set (handles.text_etagr, 'ForegroundColor', 'blue')
    set (handles.text_kfr, 'String', num2str(kfr(1),'%4.2E'))
    set (handles.text_kfr, 'ForegroundColor', 'blue')
    
    set (handles.text_etat, 'String', num2str(etat(1),'%4.2E'))
    set (handles.text_etat, 'ForegroundColor', 'blue')
    set (handles.text_etadt, 'String', num2str(etadt(1),'%4.2E'))
    set (handles.text_etadt, 'ForegroundColor', 'blue')
    set (handles.text_etait, 'String', num2str(etait(1),'%4.2E'))
    set (handles.text_etait, 'ForegroundColor', 'blue')
    set (handles.text_etagt, 'String', num2str(etagt(1),'%4.2E'))
    set (handles.text_etagt, 'ForegroundColor', 'blue')
    set (handles.text_kft, 'String', num2str(kft(1),'%4.2E'))
    set (handles.text_kft, 'ForegroundColor', 'blue')
    
    set (handles.text_etam, 'String', num2str(etam(1),'%4.2E'))
    set (handles.text_etam, 'ForegroundColor', 'blue')
    set (handles.text_etadm, 'String', num2str(etadm(1),'%4.2E'))
    set (handles.text_etadm, 'ForegroundColor', 'blue')
    set (handles.text_etaim, 'String', num2str(etaim(1),'%4.2E'))
    set (handles.text_etaim, 'ForegroundColor', 'blue')
    set (handles.text_etagm, 'String', num2str(etagm(1),'%4.2E'))
    set (handles.text_etagm, 'ForegroundColor', 'blue')
    set (handles.text_kfm, 'String', num2str(kfm(1),'%4.2E'))
    set (handles.text_kfm, 'ForegroundColor', 'blue')
    
    set (handles.text_etal, 'String', num2str(etal(1),'%4.2E'))
    set (handles.text_etal, 'ForegroundColor', 'blue')
    set (handles.text_etadl, 'String', num2str(etadl(1),'%4.2E'))
    set (handles.text_etadl, 'ForegroundColor', 'blue')
    set (handles.text_etail, 'String', num2str(etail(1),'%4.2E'))
    set (handles.text_etail, 'ForegroundColor', 'blue')
    set (handles.text_etagl, 'String', num2str(etagl(1),'%4.2E'))
    set (handles.text_etagl, 'ForegroundColor', 'blue')
    set (handles.text_kfl, 'String', num2str(kfl(1),'%4.2E'))
    set (handles.text_kfl, 'ForegroundColor', 'blue')
    
    set (handles.text_etan, 'String', num2str(etan(1),'%4.2E'))
    set (handles.text_etan, 'ForegroundColor', 'blue')
    set (handles.text_etadn, 'String', num2str(etadn(1),'%4.2E'))
    set (handles.text_etadn, 'ForegroundColor', 'blue')
    set (handles.text_etain, 'String', num2str(etain(1),'%4.2E'))
    set (handles.text_etain, 'ForegroundColor', 'blue')
    set (handles.text_etagn, 'String', num2str(etagn(1),'%4.2E'))
    set (handles.text_etagn, 'ForegroundColor', 'blue')
    set (handles.text_kfn, 'String', num2str(kfn(1),'%4.2E'))
    set (handles.text_kfn, 'ForegroundColor', 'blue')
    
    set (handles.text_Nr, 'String', num2str(Nr(1),'%4.2E'))
    set (handles.text_Nr, 'ForegroundColor', 'blue')
    set (handles.text_Nlo, 'String', num2str(Nlo(1),'%4.2E'))
    set (handles.text_Nlo, 'ForegroundColor', 'blue')
    set (handles.text_Nvdw, 'String', num2str(Nvdw(1),'%4.2E'))
    set (handles.text_Nvdw, 'ForegroundColor', 'blue')
    set (handles.text_Na, 'String', num2str(Na(1),'%4.2E'))
    set (handles.text_Na, 'ForegroundColor', 'blue')
    set (handles.text_Npe, 'String', num2str(Npe(1),'%4.2E'))
    set (handles.text_Npe, 'ForegroundColor', 'blue')
    set (handles.text_Ng, 'String', num2str(Ng(1),'%4.2E'))
    set (handles.text_Ng, 'ForegroundColor', 'blue')
    set (handles.text_Ngi, 'String', num2str(Ngi(1),'%4.2E'))
    set (handles.text_Ngi, 'ForegroundColor', 'blue')
%     set (handles.text_g, 'String', num2str(g(1),'%4.2E'))
%     set (handles.text_g, 'ForegroundColor', 'blue')
%     set (handles.text_As, 'String', num2str(As(1),'%4.2E'))
%     set (handles.text_As, 'ForegroundColor', 'blue')
    %% Setting simulation parameters and getting outputs
    %% Graphics
    figure (2);
    plot(T,etar,'b','Linewidth',1.5)
    hold on
    plot (T,etat,'r','Linewidth',1.5)
    plot (T,etam,'g','Linewidth',1.5)
    plot (T,etal,'k','Linewidth',1.5)
    plot (T,etan,'y','Linewidth',1.5)
    legend('Rajogapalan and Tien, 1976','Tufenkji and Elimelech, 2004','Ma,Pedel,Fife,Johnson 2015','Long and Hilpert, 2011','Nelson and Ginn, 2011')
    set(legend, 'Location', 'Northeast')
    xlabel('Temperature (ºK)'); ylabel('eta')
    
    
end

if ACB>0
    %% Obtaining data from the guide edit boxes
    
    dci=str2double(get(handles.dci,'String'));
    dpi=str2double(get(handles.dpi,'String'));
    vi=str2double(get(handles.vi,'String'));
    denp=str2double(get(handles.denp,'String'));
    denf=str2double(get(handles.denf,'String'));
    visf=str2double(get(handles.visf,'String'));
    T=str2double(get(handles.T,'String'));
    %A=str2double(get(handles.A,'String'));
    f=str2double(get(handles.f,'String'));
    Scf=str2double(get(handles.Scf,'String'));
    Ceff=str2double(get(handles.Ceff,'String'));
    upperval=str2double(get(handles.upperval,'String'));
    lowval=str2double(get(handles.lowval,'String'));
    nsteps=str2double(get(handles.nsteps,'String'));
    
    %% Generating vector
    
    A=linspace(lowval,upperval,nsteps);
    
    
    %% Transformations
    dc = dci.*0.001;
    %Particle size (m)
    dp = dpi.*0.000001;
    %Pore water velocity (m/s)
    v = vi./86400; %(m/s)
    p = (1-f).^(1/3); w = 2-(3*p)+(3*(p^5))-(2*(p^6));
    %Fluid approach velocity (m3/m2/day)
    Ui = vi.*f; U = Ui./86400;
    
    %% Constants
    %Boltzmann constant (j/kg)
    B = 1.381E-23;
    
    %% Dimensionless numbers
    %DIffusion Coeficient (m2/s)
    D = (B.*T)./(6.*pi.*visf.*(dp./2));
    %Happel model parameter
    As = (2.*(1-((1-f).^(5/3))))./((2-(3.*((1-f).^(1/3)))+(3.*((1-f).^(5/3)))-(2.*(1-f).^2)));
    Nr = dp./dc; %Aspect ratio
    Nlo = A./(9.*pi.*visf.*((dp./2).^2).*U); %London number
    Nvdw = A./(B.*T); % van der waals number
    Na = A./(12.*pi.*visf.*U.*((dc./2).^2)); %Attraction number
    Npe = U.*dc./D; %Peclet number
    Ng = (2.*((dp./2).^(2))*(denp-denf).*9.806)./(9.*visf.*U); %gravity number
    Ngi = 1./(1+Ng);
    g=(1-f).^(1/3);
    
    %% Calculations of rate coeficients from different authors
    
    [etadr, etair, etagr, etar, kfr, kfdr]=fRAGO(g, As, Npe, Nlo, Nr, Ng, f, v, dc, Ceff); %Rajogapalan and Tien 1976
    [etadt, etait, etagt, etat, kft, kfdt]=fTUFEN(As, Nr, Npe, Nvdw, Na, Ng, f, v, dc, Ceff); %Tufenkji and Elimelech 2004
    [etadm, etaim, etagm, etam, kfm, kfdm]=fMA(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Ma, Jhonson 2015
    [etadl, etail, etagl, etal, kfl, kfdl]=fLONG(g, Npe, Nr, As, Na, Ng, Nvdw, f, v, dc, Ceff); %Long and Hilpert 2011
    [etadn, etain, etagn, etan, kfn, kfdn]=fNEL(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Nelson and Ginn 2011
    %%  assing calculated etas to text fields and change format
    set (handles.text_etar, 'String', num2str(etar(1),'%4.2E'))
    set (handles.text_etar, 'ForegroundColor', 'blue')
    set (handles.text_etadr, 'String', num2str(etadr(1),'%4.2E'))
    set (handles.text_etadr, 'ForegroundColor', 'blue')
    set (handles.text_etair, 'String', num2str(etair(1),'%4.2E'))
    set (handles.text_etair, 'ForegroundColor', 'blue')
    set (handles.text_etagr, 'String', num2str(etagr(1),'%4.2E'))
    set (handles.text_etagr, 'ForegroundColor', 'blue')
    set (handles.text_kfr, 'String', num2str(kfr(1),'%4.2E'))
    set (handles.text_kfr, 'ForegroundColor', 'blue')
    
    set (handles.text_etat, 'String', num2str(etat(1),'%4.2E'))
    set (handles.text_etat, 'ForegroundColor', 'blue')
    set (handles.text_etadt, 'String', num2str(etadt(1),'%4.2E'))
    set (handles.text_etadt, 'ForegroundColor', 'blue')
    set (handles.text_etait, 'String', num2str(etait(1),'%4.2E'))
    set (handles.text_etait, 'ForegroundColor', 'blue')
    set (handles.text_etagt, 'String', num2str(etagt(1),'%4.2E'))
    set (handles.text_etagt, 'ForegroundColor', 'blue')
    set (handles.text_kft, 'String', num2str(kft(1),'%4.2E'))
    set (handles.text_kft, 'ForegroundColor', 'blue')
    
    set (handles.text_etam, 'String', num2str(etam(1),'%4.2E'))
    set (handles.text_etam, 'ForegroundColor', 'blue')
    set (handles.text_etadm, 'String', num2str(etadm(1),'%4.2E'))
    set (handles.text_etadm, 'ForegroundColor', 'blue')
    set (handles.text_etaim, 'String', num2str(etaim(1),'%4.2E'))
    set (handles.text_etaim, 'ForegroundColor', 'blue')
    set (handles.text_etagm, 'String', num2str(etagm(1),'%4.2E'))
    set (handles.text_etagm, 'ForegroundColor', 'blue')
    set (handles.text_kfm, 'String', num2str(kfm(1),'%4.2E'))
    set (handles.text_kfm, 'ForegroundColor', 'blue')
    
    set (handles.text_etal, 'String', num2str(etal(1),'%4.2E'))
    set (handles.text_etal, 'ForegroundColor', 'blue')
    set (handles.text_etadl, 'String', num2str(etadl(1),'%4.2E'))
    set (handles.text_etadl, 'ForegroundColor', 'blue')
    set (handles.text_etail, 'String', num2str(etail(1),'%4.2E'))
    set (handles.text_etail, 'ForegroundColor', 'blue')
    set (handles.text_etagl, 'String', num2str(etagl(1),'%4.2E'))
    set (handles.text_etagl, 'ForegroundColor', 'blue')
    set (handles.text_kfl, 'String', num2str(kfl(1),'%4.2E'))
    set (handles.text_kfl, 'ForegroundColor', 'blue')
    
    set (handles.text_etan, 'String', num2str(etan(1),'%4.2E'))
    set (handles.text_etan, 'ForegroundColor', 'blue')
    set (handles.text_etadn, 'String', num2str(etadn(1),'%4.2E'))
    set (handles.text_etadn, 'ForegroundColor', 'blue')
    set (handles.text_etain, 'String', num2str(etain(1),'%4.2E'))
    set (handles.text_etain, 'ForegroundColor', 'blue')
    set (handles.text_etagn, 'String', num2str(etagn(1),'%4.2E'))
    set (handles.text_etagn, 'ForegroundColor', 'blue')
    set (handles.text_kfn, 'String', num2str(kfn(1),'%4.2E'))
    set (handles.text_kfn, 'ForegroundColor', 'blue')
    
    set (handles.text_Nr, 'String', num2str(Nr(1),'%4.2E'))
    set (handles.text_Nr, 'ForegroundColor', 'blue')
    set (handles.text_Nlo, 'String', num2str(Nlo(1),'%4.2E'))
    set (handles.text_Nlo, 'ForegroundColor', 'blue')
    set (handles.text_Nvdw, 'String', num2str(Nvdw(1),'%4.2E'))
    set (handles.text_Nvdw, 'ForegroundColor', 'blue')
    set (handles.text_Na, 'String', num2str(Na(1),'%4.2E'))
    set (handles.text_Na, 'ForegroundColor', 'blue')
    set (handles.text_Npe, 'String', num2str(Npe(1),'%4.2E'))
    set (handles.text_Npe, 'ForegroundColor', 'blue')
    set (handles.text_Ng, 'String', num2str(Ng(1),'%4.2E'))
    set (handles.text_Ng, 'ForegroundColor', 'blue')
    set (handles.text_Ngi, 'String', num2str(Ngi(1),'%4.2E'))
    set (handles.text_Ngi, 'ForegroundColor', 'blue')
%     set (handles.text_g, 'String', num2str(g(1),'%4.2E'))
%     set (handles.text_g, 'ForegroundColor', 'blue')
%     set (handles.text_As, 'String', num2str(As(1),'%4.2E'))
%     set (handles.text_As, 'ForegroundColor', 'blue')
    %% Setting simulation parameters and getting outputs
    %% Graphics
    figure (2);
    plot(A,etar,'b','Linewidth',1.5)
    hold on
    plot (A,etat,'r','Linewidth',1.5)
    plot (A,etam,'g','Linewidth',1.5)
    plot (A,etal,'k','Linewidth',1.5)
    plot (A,etan,'y','Linewidth',1.5)
    legend('Rajogapalan and Tien, 1976','Tufenkji and Elimelech, 2004','Ma,Pedel,Fife,Johnson 2015','Long and Hilpert, 2011','Nelson and Ginn, 2011')
    set(legend, 'Location', 'Northeast')
    xlabel('Hamaker constant (J)'); ylabel('eta')
    
end

if fCB>0
    %% Obtaining data from the guide edit boxes
    
    dci=str2double(get(handles.dci,'String'));
    dpi=str2double(get(handles.dpi,'String'));
    vi=str2double(get(handles.vi,'String'));
    denp=str2double(get(handles.denp,'String'));
    denf=str2double(get(handles.denf,'String'));
    visf=str2double(get(handles.visf,'String'));
    T=str2double(get(handles.T,'String'));
    A=str2double(get(handles.A,'String'));
    %f=str2double(get(handles.f,'String'));
    Scf=str2double(get(handles.Scf,'String'));
    Ceff=str2double(get(handles.Ceff,'String'));
    upperval=str2double(get(handles.upperval,'String'));
    lowval=str2double(get(handles.lowval,'String'));
    nsteps=str2double(get(handles.nsteps,'String'));
    
    %% Generating vector
    
    f=linspace(lowval,upperval,nsteps);
    
    
    %% Transformations
    dc = dci.*0.001;
    %Particle size (m)
    dp = dpi.*0.000001;
    %Pore water velocity (m/s)
    v = vi./86400; %(m/s)
    p = (1-f).^(1/3); w = 2-(3.*p)+(3.*(p.^5))-(2.*(p.^6));
    %Fluid approach velocity (m3/m2/day)
    Ui = vi.*f; U = Ui./86400;
    
    %% Constants
    %Boltzmann constant (j/kg)
    B = 1.381E-23;
    
    %% Dimensionless numbers
    %DIffusion Coeficient (m2/s)
    D = (B.*T)./(6.*pi.*visf.*(dp./2));
    %Happel model parameter
    As = (2.*(1-((1-f).^(5/3))))./((2-(3.*((1-f).^(1/3)))+(3.*((1-f).^(5/3)))-(2.*(1-f).^2)));
    Nr = dp./dc; %Aspect ratio
    Nlo = A./(9.*pi.*visf.*((dp./2).^2).*U); %London number
    Nvdw = A./(B.*T); % van der waals number
    Na = A./(12.*pi.*visf.*U.*((dc./2).^2)); %Attraction number
    Npe = U.*dc./D; %Peclet number
    Ng = (2.*((dp./2).^(2))*(denp-denf).*9.806)./(9.*visf.*U); %gravity number
    Ngi = 1./(1+Ng);
    g=(1-f).^(1/3);
    
    %% Calculations of rate coeficients from different authors
    
    [etadr, etair, etagr, etar, kfr, kfdr]=fRAGO(g, As, Npe, Nlo, Nr, Ng, f, v, dc, Ceff); %Rajogapalan and Tien 1976
    [etadt, etait, etagt, etat, kft, kfdt]=fTUFEN(As, Nr, Npe, Nvdw, Na, Ng, f, v, dc, Ceff); %Tufenkji and Elimelech 2004
    [etadm, etaim, etagm, etam, kfm, kfdm]=fMA(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Ma, Jhonson 2015
    [etadl, etail, etagl, etal, kfl, kfdl]=fLONG(g, Npe, Nr, As, Na, Ng, Nvdw, f, v, dc, Ceff); %Long and Hilpert 2011
    [etadn, etain, etagn, etan, kfn, kfdn]=fNEL(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Nelson and Ginn 2011
    %%  assing calculated etas to text fields and change format
    set (handles.text_etar, 'String', num2str(etar(1),'%4.2E'))
    set (handles.text_etar, 'ForegroundColor', 'blue')
    set (handles.text_etadr, 'String', num2str(etadr(1),'%4.2E'))
    set (handles.text_etadr, 'ForegroundColor', 'blue')
    set (handles.text_etair, 'String', num2str(etair(1),'%4.2E'))
    set (handles.text_etair, 'ForegroundColor', 'blue')
    set (handles.text_etagr, 'String', num2str(etagr(1),'%4.2E'))
    set (handles.text_etagr, 'ForegroundColor', 'blue')
    set (handles.text_kfr, 'String', num2str(kfr(1),'%4.2E'))
    set (handles.text_kfr, 'ForegroundColor', 'blue')
    
    set (handles.text_etat, 'String', num2str(etat(1),'%4.2E'))
    set (handles.text_etat, 'ForegroundColor', 'blue')
    set (handles.text_etadt, 'String', num2str(etadt(1),'%4.2E'))
    set (handles.text_etadt, 'ForegroundColor', 'blue')
    set (handles.text_etait, 'String', num2str(etait(1),'%4.2E'))
    set (handles.text_etait, 'ForegroundColor', 'blue')
    set (handles.text_etagt, 'String', num2str(etagt(1),'%4.2E'))
    set (handles.text_etagt, 'ForegroundColor', 'blue')
    set (handles.text_kft, 'String', num2str(kft(1),'%4.2E'))
    set (handles.text_kft, 'ForegroundColor', 'blue')
    
    set (handles.text_etam, 'String', num2str(etam(1),'%4.2E'))
    set (handles.text_etam, 'ForegroundColor', 'blue')
    set (handles.text_etadm, 'String', num2str(etadm(1),'%4.2E'))
    set (handles.text_etadm, 'ForegroundColor', 'blue')
    set (handles.text_etaim, 'String', num2str(etaim(1),'%4.2E'))
    set (handles.text_etaim, 'ForegroundColor', 'blue')
    set (handles.text_etagm, 'String', num2str(etagm(1),'%4.2E'))
    set (handles.text_etagm, 'ForegroundColor', 'blue')
    set (handles.text_kfm, 'String', num2str(kfm(1),'%4.2E'))
    set (handles.text_kfm, 'ForegroundColor', 'blue')
    
    set (handles.text_etal, 'String', num2str(etal(1),'%4.2E'))
    set (handles.text_etal, 'ForegroundColor', 'blue')
    set (handles.text_etadl, 'String', num2str(etadl(1),'%4.2E'))
    set (handles.text_etadl, 'ForegroundColor', 'blue')
    set (handles.text_etail, 'String', num2str(etail(1),'%4.2E'))
    set (handles.text_etail, 'ForegroundColor', 'blue')
    set (handles.text_etagl, 'String', num2str(etagl(1),'%4.2E'))
    set (handles.text_etagl, 'ForegroundColor', 'blue')
    set (handles.text_kfl, 'String', num2str(kfl(1),'%4.2E'))
    set (handles.text_kfl, 'ForegroundColor', 'blue')
    
    set (handles.text_etan, 'String', num2str(etan(1),'%4.2E'))
    set (handles.text_etan, 'ForegroundColor', 'blue')
    set (handles.text_etadn, 'String', num2str(etadn(1),'%4.2E'))
    set (handles.text_etadn, 'ForegroundColor', 'blue')
    set (handles.text_etain, 'String', num2str(etain(1),'%4.2E'))
    set (handles.text_etain, 'ForegroundColor', 'blue')
    set (handles.text_etagn, 'String', num2str(etagn(1),'%4.2E'))
    set (handles.text_etagn, 'ForegroundColor', 'blue')
    set (handles.text_kfn, 'String', num2str(kfn(1),'%4.2E'))
    set (handles.text_kfn, 'ForegroundColor', 'blue')
    
    set (handles.text_Nr, 'String', num2str(Nr(1),'%4.2E'))
    set (handles.text_Nr, 'ForegroundColor', 'blue')
    set (handles.text_Nlo, 'String', num2str(Nlo(1),'%4.2E'))
    set (handles.text_Nlo, 'ForegroundColor', 'blue')
    set (handles.text_Nvdw, 'String', num2str(Nvdw(1),'%4.2E'))
    set (handles.text_Nvdw, 'ForegroundColor', 'blue')
    set (handles.text_Na, 'String', num2str(Na(1),'%4.2E'))
    set (handles.text_Na, 'ForegroundColor', 'blue')
    set (handles.text_Npe, 'String', num2str(Npe(1),'%4.2E'))
    set (handles.text_Npe, 'ForegroundColor', 'blue')
    set (handles.text_Ng, 'String', num2str(Ng(1),'%4.2E'))
    set (handles.text_Ng, 'ForegroundColor', 'blue')
    set (handles.text_Ngi, 'String', num2str(Ngi(1),'%4.2E'))
    set (handles.text_Ngi, 'ForegroundColor', 'blue')
%     set (handles.text_g, 'String', num2str(g(1),'%4.2E'))
%     set (handles.text_g, 'ForegroundColor', 'blue')
%     set (handles.text_As, 'String', num2str(As(1),'%4.2E'))
%     set (handles.text_As, 'ForegroundColor', 'blue')
    %% Setting simulation parameters and getting outputs
    %% Graphics
    figure (2);
    plot(f,etar,'b','Linewidth',1.5)
    hold on
    plot (f,etat,'r','Linewidth',1.5)
    plot (f,etam,'g','Linewidth',1.5)
    plot (f,etal,'k','Linewidth',1.5)
    plot (f,etan,'y','Linewidth',1.5)
    legend('Rajogapalan and Tien, 1976','Tufenkji and Elimelech, 2004','Ma,Pedel,Fife,Johnson 2015','Long and Hilpert, 2011','Nelson and Ginn, 2011')
    set(legend, 'Location', 'Northeast')
    xlabel('Porosity'); ylabel('eta')
    
end
% activate set directory output button
set(handles.pb_setdir,'Enable','on')

function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double


% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit25_Callback(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit25 as text
%        str2double(get(hObject,'String')) returns contents of edit25 as a double


% --- Executes during object creation, after setting all properties.
function edit25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit26_Callback(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit26 as text
%        str2double(get(hObject,'String')) returns contents of edit26 as a double


% --- Executes during object creation, after setting all properties.
function edit26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit27_Callback(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit27 as text
%        str2double(get(hObject,'String')) returns contents of edit27 as a double


% --- Executes during object creation, after setting all properties.
function edit27_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit28_Callback(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit28 as text
%        str2double(get(hObject,'String')) returns contents of edit28 as a double


% --- Executes during object creation, after setting all properties.
function edit28_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit29 as text
%        str2double(get(hObject,'String')) returns contents of edit29 as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit30_Callback(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit30 as text
%        str2double(get(hObject,'String')) returns contents of edit30 as a double


% --- Executes during object creation, after setting all properties.
function edit30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3



function edit31_Callback(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit31 as text
%        str2double(get(hObject,'String')) returns contents of edit31 as a double


% --- Executes during object creation, after setting all properties.
function edit31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit32_Callback(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit32 as text
%        str2double(get(hObject,'String')) returns contents of edit32 as a double


% --- Executes during object creation, after setting all properties.
function edit32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit33_Callback(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit33 as text
%        str2double(get(hObject,'String')) returns contents of edit33 as a double


% --- Executes during object creation, after setting all properties.
function edit33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit34_Callback(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit34 as text
%        str2double(get(hObject,'String')) returns contents of edit34 as a double


% --- Executes during object creation, after setting all properties.
function edit34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit35_Callback(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit35 as text
%        str2double(get(hObject,'String')) returns contents of edit35 as a double


% --- Executes during object creation, after setting all properties.
function edit35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5



function edit36_Callback(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit36 as text
%        str2double(get(hObject,'String')) returns contents of edit36 as a double


% --- Executes during object creation, after setting all properties.
function edit36_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox6.
function checkbox6_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox6


% --- Executes on button press in checkbox7.
function checkbox7_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox7


% --- Executes on button press in checkbox8.
function checkbox8_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox8


% --- Executes on button press in checkbox9.
function checkbox9_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox9


% --- Executes on button press in checkbox10.
function checkbox10_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox10



function edit37_Callback(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit37 as text
%        str2double(get(hObject,'String')) returns contents of edit37 as a double


% --- Executes during object creation, after setting all properties.
function edit37_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox11.
function checkbox11_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox11



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


% --- Executes on button press in checkbox12.
function checkbox12_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox12



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



function edit40_Callback(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit40 as text
%        str2double(get(hObject,'String')) returns contents of edit40 as a double


% --- Executes during object creation, after setting all properties.
function edit40_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit40 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function text_etar_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_etar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in dciCB.
function dciCB_Callback(hObject, eventdata, handles)
% hObject    handle to dciCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dciCB
val = get(hObject,'Value');
if val
    %remove all other checkboxes
    %set(handles.dciCB,'Value',0)
    set(handles.dpiCB,'Value',0)
    set(handles.viCB,'Value',0)
    set(handles.denpCB,'Value',0)
    set(handles.denfCB,'Value',0)
    set(handles.visfCB,'Value',0)
    set(handles.TCB,'Value',0)
    set(handles.ACB,'Value',0)
    set(handles.fCB,'Value',0) 
    %read parameter value
    dci=str2double(get(handles.dci,'String'));
    %activate range panel elements
    %set(handles.rangePanel,'Visible','on')
    set(handles.pbRVAL,'Enable','on')
    set(handles.lowval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.nsteps,'Enable','on')
    set(handles.nsteps,'String','10')
    set(handles.pbRVAL,'Enable','on')
    % show proper text on panel
    set(handles.partext,'String','Collector Diameter(mm)')
    %update range values
    minVAL=0.01;
    maxVAL=10;
    lowvaluser=dci*0.5; uppervaluser=dci*1.5;
     
    if lowvaluser<minVAL
        dciv=linspace(minVAL,uppervaluser,10);
        set(handles.lowval,'String',num2str(dciv(1),'%8.4e'));
        set(handles.upperval,'String',num2str(dciv(end),'%8.4e'));
        set(handles.step,'String',num2str(dciv(2)-dciv(1)));
    else
        if uppervaluser>maxVAL
        dciv=linspace(lowvaluser,maxVAL,10);
        set(handles.lowval,'String',num2str(dciv(1),'%8.4e'));
        set(handles.upperval,'String',num2str(dciv(end),'%8.4e'));
        set(handles.step,'String',num2str(dciv(2)-dciv(1),'%8.4e'));
        else
            dciv=linspace(lowvaluser,uppervaluser,10);
            set(handles.lowval,'String',num2str(dciv(1),'%8.4e'));
            set(handles.upperval,'String',num2str(dciv(end),'%8.4e'));
            set(handles.step,'String',num2str(dciv(2)-dciv(1),'%8.4e')); 
        end
    end 
 else
    %activate range panel
    %set(handles.rangePanel,'Visible','off')
    %deactivate range panel elements
    %set(handles.rangePanel,'Visible','on')
    set(handles.lowval,'String','enable range')
    set(handles.upperval,'String','enable range')
    set(handles.nsteps,'String','enable range')
    set(handles.step,'String','  ')
%
    set(handles.lowval,'Enable','off')
    set(handles.upperval,'Enable','off')
    set(handles.nsteps,'Enable','off')
    set(handles.pbRVAL,'Enable','off')
end



% --- Executes on button press in dpiCB.
function dpiCB_Callback(hObject, eventdata, handles)
% hObject    handle to dpiCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dpiCB
val = get(hObject,'Value');
if val
    %remove all other checkboxes
    set(handles.dciCB,'Value',0)
    %set(handles.dpiCB,'Value',0)
    set(handles.viCB,'Value',0)
    set(handles.denpCB,'Value',0)
    set(handles.denfCB,'Value',0)
    set(handles.visfCB,'Value',0)
    set(handles.TCB,'Value',0)
    set(handles.ACB,'Value',0)
    set(handles.fCB,'Value',0)   
    %read parameter value
    dpi=str2double(get(handles.dpi,'String'));
    %activate range panel
    set(handles.pbRVAL,'Enable','on')
    set(handles.lowval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.nsteps,'Enable','on')
    set(handles.nsteps,'String','10')
    set(handles.pbRVAL,'Enable','on')
    % show proper text on panel
    set(handles.partext,'String','Particle size(um)')
    %update range values
    minVAL=0.1;
    maxVAL=50;
    lowvaluser=dpi*0.5; uppervaluser=dpi*1.5;
     
    if lowvaluser<minVAL
        dpiv=linspace(minVAL,uppervaluser,10);
        set(handles.lowval,'String',num2str((dpiv(1))));
        set(handles.upperval,'String',num2str(dpiv(end)));
        set(handles.step,'String',num2str(dpiv(2)-dpiv(1)));
    else
        if uppervaluser>maxVAL
        dpiv=linspace(lowvaluser,maxVAL,10);
        set(handles.lowval,'String',num2str((dpiv(1))));
        set(handles.upperval,'String',num2str(dpiv(end)));
        set(handles.step,'String',num2str(dpiv(2)-dpiv(1)));
        else
            dpiv=linspace(lowvaluser,uppervaluser,10);
            set(handles.lowval,'String',num2str((dpiv(1))));
            set(handles.upperval,'String',num2str(dpiv(end)));
            set(handles.step,'String',num2str(dpiv(2)-dpiv(1))); 
        end
    end 
else
    %deactivate range panel elements
    %set(handles.rangePanel,'Visible','on')
    set(handles.lowval,'String','enable range')
    set(handles.upperval,'String','enable range')
    set(handles.nsteps,'String','enable range')
    set(handles.step,'String','  ')
%
    set(handles.lowval,'Enable','off')
    set(handles.upperval,'Enable','off')
    set(handles.nsteps,'Enable','off')
    set(handles.pbRVAL,'Enable','off')
end

% --- Executes on button press in viCB.
function viCB_Callback(hObject, eventdata, handles)
% hObject    handle to viCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of viCB
val = get(hObject,'Value');
if val
    %remove all other checkboxes
    set(handles.dciCB,'Value',0)
    set(handles.dpiCB,'Value',0)
    %set(handles.viCB,'Value',0)
    set(handles.denpCB,'Value',0)
    set(handles.denfCB,'Value',0)
    set(handles.visfCB,'Value',0)
    set(handles.TCB,'Value',0)
    set(handles.ACB,'Value',0)
    set(handles.fCB,'Value',0)  
   %read parameter value
    vi=str2double(get(handles.vi,'String'));
    %activate range panel
    set(handles.pbRVAL,'Enable','on')
    set(handles.lowval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.nsteps,'Enable','on')
    set(handles.nsteps,'String','10')
    set(handles.pbRVAL,'Enable','on')
    % show proper text on panel
    set(handles.partext,'String','Pore water velocity(m/day)')
    %update range values
    minVAL=0.5;
    maxVAL=20;
    lowvaluser=vi*0.5; uppervaluser=vi*1.5;
     
    if lowvaluser<minVAL
        viv=linspace(minVAL,uppervaluser,10);
        set(handles.lowval,'String',num2str((viv(1))));
        set(handles.upperval,'String',num2str(viv(end)));
        set(handles.step,'String',num2str(viv(2)-viv(1)));
    else
        if uppervaluser>maxVAL
        viv=linspace(lowvaluser,maxVAL,10);
        set(handles.lowval,'String',num2str((viv(1))));
        set(handles.upperval,'String',num2str(viv(end)));
        set(handles.step,'String',num2str(viv(2)-viv(1)));
        else
            viv=linspace(lowvaluser,uppervaluser,10);
            set(handles.lowval,'String',num2str((viv(1))));
            set(handles.upperval,'String',num2str(viv(end)));
            set(handles.step,'String',num2str(viv(2)-viv(1))); 
        end
    end 
else
    %deactivate range panel elements
    %set(handles.rangePanel,'Visible','on')
    set(handles.lowval,'String','enable range')
    set(handles.upperval,'String','enable range')
    set(handles.nsteps,'String','enable range')
    set(handles.step,'String','  ')
%
    set(handles.lowval,'Enable','off')
    set(handles.upperval,'Enable','off')
    set(handles.nsteps,'Enable','off')
    set(handles.pbRVAL,'Enable','off')
end

% --- Executes on button press in denpCB.
function denpCB_Callback(hObject, eventdata, handles)
% hObject    handle to denpCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of denpCB
val = get(hObject,'Value');
if val
    %remove all other checkboxes
    set(handles.dciCB,'Value',0)
    set(handles.dpiCB,'Value',0)
    set(handles.viCB,'Value',0)
    %set(handles.denpCB,'Value',0)
    set(handles.denfCB,'Value',0)
    set(handles.visfCB,'Value',0)
    set(handles.TCB,'Value',0)
    set(handles.ACB,'Value',0)
    set(handles.fCB,'Value',0)
    %read parameter value
    denp=str2double(get(handles.denp,'String'));
    %activate range panel
    set(handles.pbRVAL,'Enable','on')
    set(handles.lowval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.nsteps,'Enable','on')
    set(handles.nsteps,'String','10')
    set(handles.pbRVAL,'Enable','on')
    % show proper text on panel
    set(handles.partext,'String','Particle density(kg/m3)')
    %update range values
    minVAL=1000;
    maxVAL=20000;
    lowvaluser=denp*0.5; uppervaluser=denp*1.5;
     
    if lowvaluser<minVAL
        denpv=linspace(minVAL,uppervaluser,10);
        set(handles.lowval,'String',num2str((denpv(1))));
        set(handles.upperval,'String',num2str(denpv(end)));
        set(handles.step,'String',num2str(denpv(2)-denpv(1)));
    else
        if uppervaluser>maxVAL
        denpv=linspace(lowvaluser,maxVAL,10);
        set(handles.lowval,'String',num2str((denpv(1))));
        set(handles.upperval,'String',num2str(denpv(end)));
        set(handles.step,'String',num2str(denpv(2)-denpv(1)));
        else
            denpv=linspace(lowvaluser,uppervaluser,10);
            set(handles.lowval,'String',num2str((denpv(1))));
            set(handles.upperval,'String',num2str(denpv(end)));
            set(handles.step,'String',num2str(denpv(2)-denpv(1))); 
        end
    end 
else
    %deactivate range panel elements
    %set(handles.rangePanel,'Visible','on')
    set(handles.lowval,'String','enable range')
    set(handles.upperval,'String','enable range')
    set(handles.nsteps,'String','enable range')
    set(handles.step,'String','  ')
%
    set(handles.lowval,'Enable','off')
    set(handles.upperval,'Enable','off')
    set(handles.nsteps,'Enable','off')
    set(handles.pbRVAL,'Enable','off')
end

% --- Executes on button press in denfCB.
function denfCB_Callback(hObject, eventdata, handles)
% hObject    handle to denfCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of denfCB
val = get(hObject,'Value');
if val
    %remove all other checkboxes
    set(handles.dciCB,'Value',0)
    set(handles.dpiCB,'Value',0)
    set(handles.viCB,'Value',0)
    set(handles.denpCB,'Value',0)
    %set(handles.denfCB,'Value',0)
    set(handles.visfCB,'Value',0)
    set(handles.TCB,'Value',0)
    set(handles.ACB,'Value',0)
    set(handles.fCB,'Value',0) 
    %read parameter value
    denf=str2double(get(handles.denf,'String'));
    %activate range panel
    set(handles.pbRVAL,'Enable','on')
    set(handles.lowval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.nsteps,'Enable','on')
    set(handles.nsteps,'String','10')
    set(handles.pbRVAL,'Enable','on')
     % show proper text on panel
    set(handles.partext,'String','Fluid density(kg/m3)')
    %update range values
    minVAL=600;
    maxVAL=1400;
    lowvaluser=denf*0.8; uppervaluser=denf*1.2;
     
    if lowvaluser<minVAL
        denfv=linspace(minVAL,uppervaluser,10);
        set(handles.lowval,'String',num2str((denfv(1))));
        set(handles.upperval,'String',num2str(denfv(end)));
        set(handles.step,'String',num2str(denfv(2)-denfv(1)));
    else
        if uppervaluser>maxVAL
        denfv=linspace(lowvaluser,maxVAL,10);
        set(handles.lowval,'String',num2str((denfv(1))));
        set(handles.upperval,'String',num2str(denfv(end)));
        set(handles.step,'String',num2str(denfv(2)-denfv(1)));
        else
            denfv=linspace(lowvaluser,uppervaluser,10);
            set(handles.lowval,'String',num2str((denfv(1))));
            set(handles.upperval,'String',num2str(denfv(end)));
            set(handles.step,'String',num2str(denfv(2)-denfv(1))); 
        end
    end 
else
    %deactivate range panel elements
    %set(handles.rangePanel,'Visible','on')
    set(handles.lowval,'String','enable range')
    set(handles.upperval,'String','enable range')
    set(handles.nsteps,'String','enable range')
    set(handles.step,'String','  ')
%
    set(handles.lowval,'Enable','off')
    set(handles.upperval,'Enable','off')
    set(handles.nsteps,'Enable','off')
    set(handles.pbRVAL,'Enable','off')
end

% --- Executes on button press in visfCB.
function visfCB_Callback(hObject, eventdata, handles)
% hObject    handle to visfCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of visfCB
val = get(hObject,'Value');
if val
    %remove all other checkboxes
    set(handles.dciCB,'Value',0)
    set(handles.dpiCB,'Value',0)
    set(handles.viCB,'Value',0)
    set(handles.denpCB,'Value',0)
    set(handles.denfCB,'Value',0)
    %set(handles.visfCB,'Value',0)
    set(handles.TCB,'Value',0)
    set(handles.ACB,'Value',0)
    set(handles.fCB,'Value',0) 
    %read parameter value
    visf=str2double(get(handles.visf,'String'));
    %activate range panel
    set(handles.pbRVAL,'Enable','on')
    set(handles.lowval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.nsteps,'Enable','on')
    set(handles.nsteps,'String','10')
    set(handles.pbRVAL,'Enable','on')
        % show proper text on panel
    set(handles.partext,'String','Fluid viscosity(kg m/s)')
    %update range values
    minVAL=1E-4;
    maxVAL=1E-3;
    lowvaluser=visf*0.5; uppervaluser=visf*1.5;
     
    if lowvaluser<minVAL
        visfv=linspace(minVAL,uppervaluser,10);
        set(handles.lowval,'String',num2str((visfv(1))));
        set(handles.upperval,'String',num2str(visfv(end)));
        set(handles.step,'String',num2str(visfv(2)-visfv(1)));
    else
        if uppervaluser>maxVAL
        visfv=linspace(lowvaluser,maxVAL,10);
        set(handles.lowval,'String',num2str((visfv(1))));
        set(handles.upperval,'String',num2str(visfv(end)));
        set(handles.step,'String',num2str(visfv(2)-visfv(1)));
        else
            visfv=linspace(lowvaluser,uppervaluser,10);
            set(handles.lowval,'String',num2str((visfv(1))));
            set(handles.upperval,'String',num2str(visfv(end)));
            set(handles.step,'String',num2str(visfv(2)-visfv(1))); 
        end
    end 
else
    %deactivate range panel elements
    %set(handles.rangePanel,'Visible','on')
    set(handles.lowval,'String','enable range')
    set(handles.upperval,'String','enable range')
    set(handles.nsteps,'String','enable range')
    set(handles.step,'String','  ')
%
    set(handles.lowval,'Enable','off')
    set(handles.upperval,'Enable','off')
    set(handles.nsteps,'Enable','off')
    set(handles.pbRVAL,'Enable','off')
end

% --- Executes on button press in TCB.
function TCB_Callback(hObject, eventdata, handles)
% hObject    handle to TCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of TCB
val = get(hObject,'Value');
if val
    %remove all other checkboxes
    set(handles.dciCB,'Value',0)
    set(handles.dpiCB,'Value',0)
    set(handles.viCB,'Value',0)
    set(handles.denpCB,'Value',0)
    set(handles.denfCB,'Value',0)
    set(handles.visfCB,'Value',0)
    %set(handles.TCB,'Value',0)
    set(handles.ACB,'Value',0)
    set(handles.fCB,'Value',0)    
    %read parameter value
    T=str2double(get(handles.T,'String'));
    %activate range panel
    set(handles.pbRVAL,'Enable','on')
    set(handles.lowval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.nsteps,'Enable','on')
    set(handles.nsteps,'String','10')
    set(handles.pbRVAL,'Enable','on')
    % show proper text on panel
    set(handles.partext,'String','Temperature(K)')
    %update range values
    minVAL=263;
    maxVAL=333;
    lowvaluser=T*0.9; uppervaluser=T*1.1;
     
    if lowvaluser<minVAL
        Tv=linspace(minVAL,uppervaluser,10);
        set(handles.lowval,'String',num2str((Tv(1))));
        set(handles.upperval,'String',num2str(Tv(end)));
        set(handles.step,'String',num2str(Tv(2)-Tv(1)));
    else
        if uppervaluser>maxVAL
        Tv=linspace(lowvaluser,maxVAL,10);
        set(handles.lowval,'String',num2str((Tv(1))));
        set(handles.upperval,'String',num2str(Tv(end)));
        set(handles.step,'String',num2str(Tv(2)-Tv(1)));
        else
            Tv=linspace(lowvaluser,uppervaluser,10);
            set(handles.lowval,'String',num2str((Tv(1))));
            set(handles.upperval,'String',num2str(Tv(end)));
            set(handles.step,'String',num2str(Tv(2)-Tv(1))); 
        end
    end 
else
    %deactivate range panel elements
    %set(handles.rangePanel,'Visible','on')
    set(handles.lowval,'String','enable range')
    set(handles.upperval,'String','enable range')
    set(handles.nsteps,'String','enable range')
    set(handles.step,'String','  ')
%
    set(handles.lowval,'Enable','off')
    set(handles.upperval,'Enable','off')
    set(handles.nsteps,'Enable','off')
    set(handles.pbRVAL,'Enable','off')
end

% --- Executes on button press in ACB.
function ACB_Callback(hObject, eventdata, handles)
% hObject    handle to ACB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ACB
val = get(hObject,'Value');
if val
    %remove all other checkboxes
    set(handles.dciCB,'Value',0)
    set(handles.dpiCB,'Value',0)
    set(handles.viCB,'Value',0)
    set(handles.denpCB,'Value',0)
    set(handles.denfCB,'Value',0)
    set(handles.visfCB,'Value',0)
    set(handles.TCB,'Value',0)
    %set(handles.ACB,'Value',0)
    set(handles.fCB,'Value',0) 
    %read parameter value
    A=str2double(get(handles.A,'String'));
    %activate range panel
    set(handles.pbRVAL,'Enable','on')
    set(handles.lowval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.nsteps,'Enable','on')
    set(handles.nsteps,'String','10')
    set(handles.pbRVAL,'Enable','on')
    % show proper text on panel
    set(handles.partext,'String','Hamaker constant(J)')
    %update range values
    minVAL=1E-21;
    maxVAL=1E-20;
    lowvaluser=A*0.5; uppervaluser=A*1.5;
     
    if lowvaluser<minVAL
        Av=linspace(minVAL,uppervaluser,10);
        set(handles.lowval,'String',num2str((Av(1))));
        set(handles.upperval,'String',num2str(Av(end)));
        set(handles.step,'String',num2str(Av(2)-Av(1)));
    else
        if uppervaluser>maxVAL
        Av=linspace(lowvaluser,maxVAL,10);
        set(handles.lowval,'String',num2str((Av(1))));
        set(handles.upperval,'String',num2str(Av(end)));
        set(handles.step,'String',num2str(Av(2)-Av(1)));
        else
            Av=linspace(lowvaluser,uppervaluser,10);
            set(handles.lowval,'String',num2str((Av(1))));
            set(handles.upperval,'String',num2str(Av(end)));
            set(handles.step,'String',num2str(Av(2)-Av(1))); 
        end
    end 
else
    %deactivate range panel elements
    %set(handles.rangePanel,'Visible','on')
    set(handles.lowval,'String','enable range')
    set(handles.upperval,'String','enable range')
    set(handles.nsteps,'String','enable range')
    set(handles.step,'String','  ')
%
    set(handles.lowval,'Enable','off')
    set(handles.upperval,'Enable','off')
    set(handles.nsteps,'Enable','off')
    set(handles.pbRVAL,'Enable','off')
end

% --- Executes on button press in fCB.
function fCB_Callback(hObject, eventdata, handles)
% hObject    handle to fCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fCB
val = get(hObject,'Value');
if val
    %remove all other checkboxes
    set(handles.dciCB,'Value',0)
    set(handles.dpiCB,'Value',0)
    set(handles.viCB,'Value',0)
    set(handles.denpCB,'Value',0)
    set(handles.denfCB,'Value',0)
    set(handles.visfCB,'Value',0)
    set(handles.TCB,'Value',0)
    set(handles.ACB,'Value',0)
    %set(handles.fCB,'Value',0)  
    %read parameter value
    f=str2double(get(handles.f,'String'));
    %activate range panel
    set(handles.pbRVAL,'Enable','on')
    set(handles.lowval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.upperval,'Enable','on')
    set(handles.nsteps,'Enable','on')
    set(handles.nsteps,'String','10')
    set(handles.pbRVAL,'Enable','on')
    % show proper text on panel
    set(handles.partext,'String','Porosity')
    %update range values
    minVAL=0.1;
    maxVAL=0.8;
    lowvaluser=f*0.5; uppervaluser=f*1.5;
     
    if lowvaluser<minVAL
        fv=linspace(minVAL,uppervaluser,10);
        set(handles.lowval,'String',num2str((fv(1))));
        set(handles.upperval,'String',num2str(fv(end)));
        set(handles.step,'String',num2str(fv(2)-fv(1)));
    else
        if uppervaluser>maxVAL
        fv=linspace(lowvaluser,maxVAL,10);
        set(handles.lowval,'String',num2str((fv(1))));
        set(handles.upperval,'String',num2str(fv(end)));
        set(handles.step,'String',num2str(fv(2)-fv(1)));
        else
            fv=linspace(lowvaluser,uppervaluser,10);
            set(handles.lowval,'String',num2str((fv(1))));
            set(handles.upperval,'String',num2str(fv(end)));
            set(handles.step,'String',num2str(fv(2)-fv(1))); 
        end
    end 
else
    %deactivate range panel elements
    %set(handles.rangePanel,'Visible','on')
    set(handles.lowval,'String','enable range')
    set(handles.upperval,'String','enable range')
    set(handles.nsteps,'String','enable range')
    set(handles.step,'String','  ')
%
    set(handles.lowval,'Enable','off')
    set(handles.upperval,'Enable','off')
    set(handles.nsteps,'Enable','off')
    set(handles.pbRVAL,'Enable','off')
end



function lowval_Callback(hObject, eventdata, handles)
% hObject    handle to lowval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%read parameter value
    upperval=str2double(get(handles.upperval,'String'));
    nsteps=str2double(get(handles.nsteps,'String'));
    lowval=str2double(get(handles.lowval,'String'));
%calculate nsteps
    set(handles.step,'String',num2str((upperval-lowval)/nsteps));
    vector = linspace(upperval,lowval,nsteps);
    
% Hints: get(hObject,'String') returns contents of lowval as text
%        str2double(get(hObject,'String')) returns contents of lowval as a double


% --- Executes during object creation, after setting all properties.
function lowval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%read parameter value
    
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function step_Callback(hObject, eventdata, handles)
% hObject    handle to step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of step as text
%        str2double(get(hObject,'String')) returns contents of step as a double


% --- Executes during object creation, after setting all properties.
function step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function upperval_Callback(hObject, eventdata, handles)
% hObject    handle to upperval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upperval as text
%        str2double(get(hObject,'String')) returns contents of upperval as a double
    upperval=str2double(get(handles.upperval,'String'));
    nsteps=str2double(get(handles.nsteps,'String'));
    lowval=str2double(get(handles.lowval,'String'));
%calculate nsteps
    set(handles.step,'String',num2str((upperval-lowval)/nsteps));
    vector = linspace(upperval,lowval,nsteps);

% --- Executes during object creation, after setting all properties.
function upperval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upperval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function nsteps_Callback(hObject, eventdata, handles)
% hObject    handle to nsteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nsteps as text
%        str2double(get(hObject,'String')) returns contents of nsteps as a double
    upperval=str2double(get(handles.upperval,'String'));
    nsteps=str2double(get(handles.nsteps,'String'));
    lowval=str2double(get(handles.lowval,'String'));
%calculate nsteps
    set(handles.step,'String',num2str((upperval-lowval)/nsteps));
    

% --- Executes during object creation, after setting all properties.
function nsteps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nsteps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pbRVAL.
function pbRVAL_Callback(hObject, eventdata, handles)
% hObject    handle to pbRVAL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get checkbox value
dciCB = get(handles.dciCB,'Value');
dpiCB = get(handles.dpiCB,'Value');
viCB = get(handles.viCB,'Value');
denpCB = get(handles.denpCB,'Value');
denfCB = get(handles.denfCB,'Value'); 
visfCB = get(handles.visfCB,'Value');
TCB = get(handles.TCB,'Value');
ACB = get(handles.ACB,'Value');
fCB = get(handles.fCB,'Value');
upperval=str2double(get(handles.upperval,'String'));
lowval=str2double(get(handles.lowval,'String'));
nsteps=str2double(get(handles.nsteps,'String'));
% same for rest...
if dciCB>0
    minVAL=0.01;
    maxVAL=10; 

        if lowval >= upperval
            m=warndlg('RANGE ERROR','Warning');
            waitfor(m)  
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
        else
            if lowval<minVAL
            m=warndlg('RANGE must be between 0.01 - 10','Warning');
            waitfor(m)
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
            else
                if upperval>maxVAL
                m=warndlg('RANGE must be between 0.01 - 10','Warning');
                waitfor(m)
                 set(handles.lowval,'String',num2str(minVAL));
                 set(handles.upperval,'String',num2str(maxVAL));
                 set(handles.nsteps,'String',num2str(10));
                 set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                else
                    if nsteps <= 0
                    m=warndlg(' NUMBER OF STEPS MUST BE A POSITIVE NUMBER','Warning');
                    waitfor(m)
                    set(handles.lowval,'String',num2str(minVAL));
                    set(handles.upperval,'String',num2str(maxVAL));
                    set(handles.nsteps,'String',num2str(10));
                    set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                    else
                    evalnsteps = nsteps-fix(nsteps);
                        if evalnsteps>0
                            m=warndlg('NUMBER OF STEPS MUST BE AN INTEGER','Warning');
                            waitfor(m)
                            set(handles.lowval,'String',num2str(minVAL));
                            set(handles.upperval,'String',num2str(maxVAL));
                            set(handles.nsteps,'String',num2str(10));
                            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                        end    
                    end  
                end
            end
        end
% else        
end

if dpiCB>0
    minVAL=0.1;
    maxVAL=50; 

        if lowval >= upperval
            m=warndlg('RANGE ERROR','Warning');
            waitfor(m) 
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
        else
            if lowval<minVAL
            m=warndlg('RANGE must be between 0.1 - 50','Warning');
            waitfor(m)
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
            else
                if upperval>maxVAL
                m=warndlg('RANGE must be between 0.1 - 50','Warning');
                waitfor(m)
                set(handles.lowval,'String',num2str(minVAL));
                set(handles.upperval,'String',num2str(maxVAL));
                set(handles.nsteps,'String',num2str(10));
                set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                else
                    if nsteps <= 0
                    m=warndlg(' NUMBER OF STEPS MUST BE A POSITIVE NUMBER','Warning');
                    waitfor(m)
                    set(handles.lowval,'String',num2str(minVAL));
                    set(handles.upperval,'String',num2str(maxVAL));
                    set(handles.nsteps,'String',num2str(10));
                    set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                    else
                    evalnsteps = nsteps-fix(nsteps);
                        if evalnsteps>0
                            m=warndlg('NUMBER OF STEPS MUST BE AN INTEGER','Warning');
                            waitfor(m)
                            set(handles.lowval,'String',num2str(minVAL));
                            set(handles.upperval,'String',num2str(maxVAL));
                            set(handles.nsteps,'String',num2str(10));
                            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                        end    
                    end  
                end
            end
        end
% else        
end
if viCB>0
    minVAL=0.5;
    maxVAL=100; 

       if lowval >= upperval
            m=warndlg('RANGE ERROR','Warning');
            waitfor(m)
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
        else
            if lowval<minVAL
            m=warndlg('RANGE must be between 0.5 - 100','Warning');
            waitfor(m)
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
            else
                if upperval>maxVAL
                m=warndlg('RANGE must be between 0.5 - 100','Warning');
                waitfor(m)
                set(handles.lowval,'String',num2str(minVAL));
                set(handles.upperval,'String',num2str(maxVAL));
                set(handles.nsteps,'String',num2str(10));
                set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                else
                    if nsteps <= 0
                    m=warndlg(' NUMBER OF STEPS MUST BE A POSITIVE NUMBER','Warning');
                    waitfor(m)
                    set(handles.lowval,'String',num2str(minVAL));
                    set(handles.upperval,'String',num2str(maxVAL));
                    set(handles.nsteps,'String',num2str(10));
                    set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                    else
                    evalnsteps = nsteps-fix(nsteps);
                        if evalnsteps>0
                            m=warndlg('NUMBER OF STEPS MUST BE AN INTEGER','Warning');
                            waitfor(m)
                            set(handles.lowval,'String',num2str(minVAL));
                            set(handles.upperval,'String',num2str(maxVAL));
                            set(handles.nsteps,'String',num2str(10));
                            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                        end    
                    end  
                end
            end
        end
% else        
end

if denpCB>0
    minVAL=1000;
    maxVAL=20000; 

       if lowval >= upperval
            m=warndlg('RANGE ERROR','Warning');
            waitfor(m)
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
        else
            if lowval<minVAL
            m=warndlg('RANGE must be between 1000 - 20000','Warning');
            waitfor(m)
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
            else
                if upperval>maxVAL
                m=warndlg('RANGE must be between 1000 - 20000','Warning');
                waitfor(m)
                set(handles.lowval,'String',num2str(minVAL));
                set(handles.upperval,'String',num2str(maxVAL));
                set(handles.nsteps,'String',num2str(10));
                set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                else
                    if nsteps <= 0
                    m=warndlg(' NUMBER OF STEPS MUST BE A POSITIVE NUMBER','Warning');
                    waitfor(m)
                    set(handles.lowval,'String',num2str(minVAL));
                    set(handles.upperval,'String',num2str(maxVAL));
                    set(handles.nsteps,'String',num2str(10));
                    set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                    else
                    evalnsteps = nsteps-fix(nsteps);
                        if evalnsteps>0
                            m=warndlg('NUMBER OF STEPS MUST BE AN INTEGER','Warning');
                            waitfor(m)
                            set(handles.lowval,'String',num2str(minVAL));
                            set(handles.upperval,'String',num2str(maxVAL));
                            set(handles.nsteps,'String',num2str(10));
                            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                        end    
                    end  
                end
            end
        end
% else        
end
if denfCB>0
    minVAL=600;
    maxVAL=1400; 

       if lowval >= upperval
            m=warndlg('RANGE ERROR','Warning');
            waitfor(m)
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
        else
            if lowval<minVAL
            m=warndlg('RANGE must be between 600 - 1400','Warning');
            waitfor(m)
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
            else
                if upperval>maxVAL
                m=warndlg('RANGE must be between 600 - 1400','Warning');
                waitfor(m)
                set(handles.lowval,'String',num2str(minVAL));
                set(handles.upperval,'String',num2str(maxVAL));
                set(handles.nsteps,'String',num2str(10));
                set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                else
                    if nsteps <= 0
                    m=warndlg(' NUMBER OF STEPS MUST BE A POSITIVE NUMBER','Warning');
                    waitfor(m)
                    set(handles.lowval,'String',num2str(minVAL));
                    set(handles.upperval,'String',num2str(maxVAL));
                    set(handles.nsteps,'String',num2str(10));
                    set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                    else
                    evalnsteps = nsteps-fix(nsteps);
                        if evalnsteps>0
                            m=warndlg('NUMBER OF STEPS MUST BE AN INTEGER','Warning');
                            waitfor(m)
                            set(handles.lowval,'String',num2str(minVAL));
                            set(handles.upperval,'String',num2str(maxVAL));
                            set(handles.nsteps,'String',num2str(10));
                            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                        end    
                    end  
                end
            end
        end
% else        
end
if visfCB>0
    minVAL=1E-4;
    maxVAL=1E-3; 

        if lowval >= upperval
            m=warndlg('RANGE ERROR','Warning');
            waitfor(m)
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
        else
            if lowval<minVAL
            m=warndlg('RANGE must be between 0.0001 - 0.001','Warning');
            waitfor(m)
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
            else
                if upperval>maxVAL
                m=warndlg('RANGE must be between 0.0001 - 0.001','Warning');
                waitfor(m)
                set(handles.lowval,'String',num2str(minVAL));
                set(handles.upperval,'String',num2str(maxVAL));
                set(handles.nsteps,'String',num2str(10));
                set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                else
                    if nsteps <= 0
                    m=warndlg(' NUMBER OF STEPS MUST BE AN INTEGER','Warning');
                    waitfor(m)
                    set(handles.lowval,'String',num2str(minVAL));
                    set(handles.upperval,'String',num2str(maxVAL));
                    set(handles.nsteps,'String',num2str(10));
                    set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                    else
                    evalnsteps = nsteps-fix(nsteps);
                        if evalnsteps>0
                            m=warndlg('NUMBER OF STEPS MUST BE AN INTEGER','Warning');
                            waitfor(m)
                            set(handles.lowval,'String',num2str(minVAL));
                            set(handles.upperval,'String',num2str(maxVAL));
                            set(handles.nsteps,'String',num2str(10));
                            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                        end    
                    end  
                end
            end
        end
% else        
end
if TCB>0
    minVAL=263;
    maxVAL=333; 

         if lowval >= upperval
            m=warndlg('RANGE ERROR','Warning');
            waitfor(m)
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
        else
            if lowval<minVAL
            m=warndlg('RANGE must be between 263 - 333','Warning');
            waitfor(m)
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
            else
                if upperval>maxVAL
                m=warndlg('RANGE must be between 263 - 333','Warning');
                waitfor(m)
                set(handles.lowval,'String',num2str(minVAL));
                set(handles.upperval,'String',num2str(maxVAL));
                set(handles.nsteps,'String',num2str(10));
                set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                else
                    if nsteps <= 0
                    m=warndlg(' NUMBER OF STEPS MUST BE A POSITIVE NUMBER','Warning');
                    waitfor(m)
                    set(handles.lowval,'String',num2str(minVAL));
                    set(handles.upperval,'String',num2str(maxVAL));
                    set(handles.nsteps,'String',num2str(10));
                    set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                    else
                    evalnsteps = nsteps-fix(nsteps);
                        if evalnsteps>0
                            m=warndlg('NUMBER OF STEPS MUST BE AN INTEGER','Warning');
                            waitfor(m)
                            set(handles.lowval,'String',num2str(minVAL));
                            set(handles.upperval,'String',num2str(maxVAL));
                            set(handles.nsteps,'String',num2str(10));
                            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                        end    
                    end  
                end
            end
        end
% else        
end
if ACB>0
    minVAL=1E-21;
    maxVAL=1E-20; 

         if lowval >= upperval
            m=warndlg('RANGE ERROR','Warning');
            waitfor(m)  
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
        else
            if lowval<minVAL
            m=warndlg('RANGE must be between 1E-21 - 1E-20','Warning');
            waitfor(m)
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
            else
                if upperval>maxVAL
                m=warndlg('RANGE must be between 1E-21 - 1E-20','Warning');
                waitfor(m)
                set(handles.lowval,'String',num2str(minVAL));
                set(handles.upperval,'String',num2str(maxVAL));
                set(handles.nsteps,'String',num2str(10));
                set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                else
                    if nsteps <= 0
                    m=warndlg(' NUMBER OF STEPS MUST BE A POSITIVE NUMBER','Warning');
                    waitfor(m)
                    set(handles.lowval,'String',num2str(minVAL));
                    set(handles.upperval,'String',num2str(maxVAL));
                    set(handles.nsteps,'String',num2str(10));
                    set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                    else
                    evalnsteps = nsteps-fix(nsteps);
                        if evalnsteps>0
                            m=warndlg('NUMBER OF STEPS MUST BE AN INTEGER','Warning');
                            waitfor(m)
                            set(handles.lowval,'String',num2str(minVAL));
                            set(handles.upperval,'String',num2str(maxVAL));
                            set(handles.nsteps,'String',num2str(10));
                            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                        end    
                    end  
                end
            end
        end
% else        
end
if fCB>0
    minVAL=0.1;
    maxVAL=0.8; 

       if lowval >= upperval
            m=warndlg('RANGE ERROR','Warning');
            waitfor(m)
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
        else
            if lowval<minVAL
            m=warndlg('RANGE must be between 0.1 - 0.8','Warning');
            waitfor(m)
            set(handles.lowval,'String',num2str(minVAL));
            set(handles.upperval,'String',num2str(maxVAL));
            set(handles.nsteps,'String',num2str(10));
            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
            else
                if upperval>maxVAL
                m=warndlg('RANGE must be between 0.1 - 0.8','Warning');
                waitfor(m)
                set(handles.lowval,'String',num2str(minVAL));
                set(handles.upperval,'String',num2str(maxVAL));
                set(handles.nsteps,'String',num2str(10));
                set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                else
                    if nsteps <= 0
                    m=warndlg(' NUMBER OF STEPS MUST BE A POSITIVE NUMBER','Warning');
                    waitfor(m)
                    set(handles.lowval,'String',num2str(minVAL));
                    set(handles.upperval,'String',num2str(maxVAL));
                    set(handles.nsteps,'String',num2str(10));
                    set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                    else
                    evalnsteps = nsteps-fix(nsteps);
                        if evalnsteps>0
                            m=warndlg('NUMBER OF STEPS MUST BE AN INTEGER','Warning');
                            waitfor(m)
                            set(handles.lowval,'String',num2str(minVAL));
                            set(handles.upperval,'String',num2str(maxVAL));
                            set(handles.nsteps,'String',num2str(10));
                            set(handles.step,'String',num2str((maxVAL-minVAL)/10));
                        end    
                    end  
                end
            end
        end
% else        
end

% set(handles.rangePanel,'Visible','off')

set(handles.pbloadrange,'Enable','on')

% --- Executes on button press in pbloadrange.
function pbloadrange_Callback(hObject, eventdata, handles)
% hObject    handle to pbloadrange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dciCB = get(handles.dciCB,'Value');
dpiCB = get(handles.dpiCB,'Value');
viCB = get(handles.viCB,'Value');
denpCB = get(handles.denpCB,'Value');
denfCB = get(handles.denfCB,'Value'); 
visfCB = get(handles.visfCB,'Value');
TCB = get(handles.TCB,'Value');
ACB = get(handles.ACB,'Value');
fCB = get(handles.fCB,'Value');
upperval=str2double(get(handles.upperval,'String'));
lowval=str2double(get(handles.lowval,'String'));
nsteps=str2double(get(handles.nsteps,'String'));

if dciCB>0
    
    %% Obtaining data from the guide edit boxes

% dci=str2double(get(handles.dci,'String')); 
dpi=str2double(get(handles.dpi,'String'));
vi=str2double(get(handles.vi,'String'));
denp=str2double(get(handles.denp,'String'));
denf=str2double(get(handles.denf,'String'));
visf=str2double(get(handles.visf,'String'));
T=str2double(get(handles.T,'String'));
A=str2double(get(handles.A,'String'));
f=str2double(get(handles.f,'String'));
Scf=str2double(get(handles.Scf,'String'));
Ceff=str2double(get(handles.Ceff,'String'));

%% Obtaining vector

dci=linspace(lowval,upperval,nsteps);


%% Transformations
dc = dci.*0.001; 
%Particle size (m)
dp = dpi.*0.000001; 
%Pore water velocity (m/s) 
v = vi./86400; %(m/s)
p = (1-f).^(1/3); w = 2-(3.*p)+(3.*(p.^5))-(2.*(p.^6));
%Fluid approach velocity (m3/m2/day)
Ui = vi.*f; U = Ui./86400;

%% Constants
%Boltzmann constant (j/kg)
B = 1.381E-23;

%% Dimensionless numbers
%DIffusion Coeficient (m2/s)
D = (B.*T)./(6*pi.*visf.*(dp./2));
%Happel model parameter
 As = (2.*(1-((1-f).^(5/3))))./((2-(3.*((1-f).^(1/3)))+(3.*((1-f).^(5/3)))-(2.*(1-f).^2)));
 Nr = dp./dc; %Aspect ratio
 Nlo = A./(9*pi.*visf.*((dp./2).^2).*U); %London number
 Nvdw = A./(B.*T); % van der waals number
 Na = A./(12*pi*visf.*U.*((dc./2).^2)); %Attraction number
 Npe = U.*dc./D; %Peclet number
 Ng = (2.*((dp./2).^(2))*(denp-denf).*9.806)./(9*visf.*U); %gravity number
 Ngi = 1./(1+Ng);
 g=(1-f).^(1/3);
 
    
 %% Calculations of rate coeficients from different authors
 
 [etadr, etair, etagr, etar, kfr, kfdr]=fRAGO(g, As, Npe, Nlo, Nr, Ng, f, v, dc, Ceff); %Rajogapalan and Tien 1976
 [etadt, etait, etagt, etat, kft, kfdt]=fTUFEN(As, Nr, Npe, Nvdw, Na, Ng, f, v, dc, Ceff); %Tufenkji and Elimelech 2004
 [etadm, etaim, etagm, etam, kfm, kfdm]=fMA(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Ma, Jhonson 2015
 [etadl, etail, etagl, etal, kfl, kfdl]=fLONG(g, Npe, Nr, As, Na, Ng, Nvdw, f, v, dc, Ceff); %Long and Hilpert 2011
 [etadn, etain, etagn, etan, kfn, kfdn]=fNEL(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff); %Nelson and Ginn 2011   
    
 
 
 
 
 
 set(handles.rangePanel,'Visible','off')

    
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pb_save.
function pb_save_Callback(hObject, eventdata, handles)
% hObject    handle to pb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dname
global dci dpi vi denp denf visf T A f Scf Ceff % assign global variables
% globalinputs for single eta
global dciSE dpiSE viSE denpSE denfSE visfSE TSE ASE fSE ScfSE CeffSE
% intermediate parameters and dimensionless numbers
global As Nr Nlo Nvdw Na Npe Ng Ngi g 
% intermediate parameters and dimensionless numbers for single eta
global  AsSE NrSE NloSe NvdwSE NaSE NpeSE NgSE NgiSE gSE
% rate coefficients single eta
global kfrSE kftSE kfmSE kflSE kfnSE
% set globals for correlation equations output single eta
global etadrSE etairSE etagrSE etarSE %Rajogapalan and Tien 1976
global etadtSE etaitSE etagtSE etatSE  %Tufenkji and Elimelech 2004
global etadmSE etaimSE etagmSE etamSE  %Ma, Jhonson 2015
global etadlSE etailSE etaglSE etalSE  %Long and Hilpert 2011
global etadnSE etainSE etagnSE etanSE  %Nelson and Ginn 2011
% set globals for correlation equations output eta RANGE
global etadr etair etagr etar kfr kfdr %Rajogapalan and Tien 1976
global etadt etait etagt etat kft kfdt %Tufenkji and Elimelech 2004
global etadm etaim etagm etam kfm kfdm %Ma, Jhonson 2015
global etadl etail etagl etal kfl kfdl %Long and Hilpert 2011
global etadn etain etagn etan kfn kfdn %Nelson and Ginn 2011
% set globals for retention profile (single eta only)
global  x Yr Yt Ym Yl Yn
%% WRITE OUTPUT TO  XLS FILE
% start waitbar
h = waitbar(0,'Saving data to file');
filecount = 1;
filename1 = strcat(dname,'\001_output_CorrEqs.xls');
% delete previous output file
while exist(filename1, 'file')==2
%   delete(filename1);
    filecount=filecount+1;
    strcount = strcat('00',num2str(filecount));
    filename1 = strcat(dname,'\',strcount,'_output_CorrEqs.xls');
end
filename1
%% parameter values
[par_cell1,par_cell2,par_cell3,par_cell4]=fpar_out_CorrEqs();
waitbar(0.1,h) % show saving progress
%% write data
% write input parameters 
xlswrite(filename1,par_cell1,'Input_Parameters');  
waitbar(0.16,h) % show saving progress
% write dimensionless numbers
xlswrite(filename1,par_cell2,'Dimensionless_Numbers');  
waitbar(0.32,h) % show saving progress
% write dimensionless numbers
xlswrite(filename1,par_cell3,'Collector_Efficiency');  
waitbar(0.48,h) % show saving progress
% write dimensionless numbers
xlswrite(filename1,par_cell4,'Rate_Coefficients');  
waitbar(0.64,h) % show saving progress
% write retention profile
% headers for retention profile
col_headerPROF={'x(m)','Rajogapalan_and_Tien_1976','Tufenkji_and_Elimelech_2004',...
    'Ma,Pedel,Fife&Johnson_2015','Long_and_Hilpert_2011','Nelson_and_Ginn_2011'};  
xlswrite(filename1,col_headerPROF,'Number_Retained','A1');     %Write column header
xlswrite(filename1,x','Number_Retained','A2');     %Write as a column
xlswrite(filename1,Yr','Number_Retained','B2');     %Write as a column
xlswrite(filename1,Yt','Number_Retained','C2');     %Write as a column
xlswrite(filename1,Ym','Number_Retained','D2');     %Write as a column
xlswrite(filename1,Yl','Number_Retained','E2');     %Write as a column
xlswrite(filename1,Yn','Number_Retained','F2');     %Write as a column
waitbar(0.8,h) % show saving progress
%% write eta vs parameter range if it applies
pa = [length(dci),length(dpi),length(vi),length(denp),length(denf),...
      length(visf),length(T),length(A),length(f)];
% make array of parameters labels
ha = {'Collector_diameter(mm)','Colloid_diameter(um)',...
    'Pore_water_velocity(m/day)','Colloid_density(kg/m3)',...
    'Fluid_density(kg/m3)','Fluid_viscosity(kg-m/s)',...
    'Temperature(K)','Hamaker_constant(J)','Porosity(-)'};
% make array of parameters data
[maxpa,irange] = max(pa);
% output to file if range exists
if maxpa>1  
    % generate data array
    da = NaN(maxpa,length(pa));
    da(1:pa(1),1) = dci;
    da(1:pa(2),2) = dpi;
    da(1:pa(3),3) = vi;
    da(1:pa(4),4) = denp;
    da(1:pa(5),5) = denf;
    da(1:pa(6),6) = visf;
    da(1:pa(7),7) = T;
    da(1:pa(8),8) = A;
    da(1:pa(9),9) = f;
    % headers for eta vs range
    col_headerRANGE={ha{irange},'Rajogapalan_and_Tien_1976','Tufenkji_and_Elimelech_2004',...
        'Ma,Pedel,Fife&Johnson_2015','Long_and_Hilpert_2011','Nelson_and_Ginn_2011'};     
    xlswrite(filename1,col_headerRANGE,'Collector_Efficiency_vs_Range','A1');     %Write column header
    xlswrite(filename1,da(:,irange),'Collector_Efficiency_vs_Range','A2');     %Write as a column
    xlswrite(filename1,etar','Collector_Efficiency_vs_Range','B2');     %Write as a column
    xlswrite(filename1,etat','Collector_Efficiency_vs_Range','C2');     %Write as a column
    xlswrite(filename1,etam','Collector_Efficiency_vs_Range','D2');     %Write as a column
    xlswrite(filename1,etal','Collector_Efficiency_vs_Range','E2');     %Write as a column
    xlswrite(filename1,etan','Collector_Efficiency_vs_Range','F2');     %Write as a column       
end
%%
waitbar(1.0,h) % show saving progress
disp('Output Complete');
close(h)

% --- Executes on button press in pb_setdir.
function pb_setdir_Callback(hObject, eventdata, handles)
% hObject    handle to pb_setdir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dname
%% Create OUTPUT directory to write output profile, and sim parameters
% %  create string from output directory  
% OUTDIR=get(handles.outputname,'String');
OUTDIR='Output_CorrelationEqns';
outs = strcat('\',OUTDIR,'\');
% % set working directory        
if ~isdeployed
    % MATLAB environment
    mname = mfilename('fullpath');
    outputpath = strrep(mname,'\CorrelationEqs_GUI','\')
else
   %deployed application
    outputpath=pwd;
end
dname = uigetdir(outputpath,'Select Output Directory');
if dname==0
    dname = outputpath;
    msg = strcat('Default output directory:'," ",dname);
    warndlg(msg)
end
%% enable save button
set(handles.pb_save,'Enable','on')


% --- Executes during object creation, after setting all properties.
function uipanel26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
