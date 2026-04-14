function varargout = Upscale_Continuum_GUI(varargin)
% UPSCALE_CONTINUUM_GUI MATLAB code for Upscale_Continuum_GUI.fig
%      UPSCALE_CONTINUUM_GUI, by itself, creates a new UPSCALE_CONTINUUM_GUI or raises the existing
%      singleton*.
%
%      H = UPSCALE_CONTINUUM_GUI returns the handle to a new UPSCALE_CONTINUUM_GUI or the handle to
%      the existing singleton*.
%
%      UPSCALE_CONTINUUM_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UPSCALE_CONTINUUM_GUI.M with the given input arguments.
%
%      UPSCALE_CONTINUUM_GUI('Property','Value',...) creates a new UPSCALE_CONTINUUM_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Upscale_Continuum_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Upscale_Continuum_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Upscale_Continuum_GUI

% Last Modified by GUIDE v2.5 16-May-2022 16:20:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Upscale_Continuum_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Upscale_Continuum_GUI_OutputFcn, ...
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


% --- Executes just before Upscale_Continuum_GUI is made visible.
function Upscale_Continuum_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Upscale_Continuum_GUI (see VARARGIN)
global restime
% initialize residen time output histograms flag
restime = 0;
% Choose default command line output for Upscale_Continuum_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Upscale_Continuum_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Upscale_Continuum_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbuttomIMPORT.
function pushbuttomIMPORT_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttomIMPORT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set globals to pass through values to other functions
global XOUTaf YOUTaf ZOUTaf TBULKaf TNEARaf TTOTALaf ATTACHKaf XINITaf YINITaf RINITaf ZINITaf NSVELaf
global XOUTef YOUTef ZOUTef TBULKef TNEARef TTOTALef ATTACHKef XINITef YINITef RINITef ZINITef NSVELef
global XOUTau YOUTau ZOUTau TBULKau TNEARau TTOTALau ATTACHKau XINITau YINITau RINITau ZINITau NSVELau
global XOUTeu YOUTeu ZOUTeu TBULKeu TNEAReu TTOTALeu ATTACHKeu XINITeu YINITeu RINITeu ZINITeu NSVELeu
global UPFLUX_header
global NSIND
global ap ag por rlim vpor asp asp2 rlimFAV

%% locate directory for flux data file read

% make model run in implicit as default
NSIND = 0;
% % set working directory        
if ~isdeployed
    % MATLAB environment
    inputdir = strrep(mfilename('fullpath'),'\Upscale_Continuum_GUI','\');
else
    %deployed application
    inputdir=strcat(pwd,'\');   
end
test = strcat(inputdir,'UPFLUX.xlsx');
%% get upflux filename and path
[filename,filepath] = uigetfile(test,'Select the Flux Data file');
if isequal(filename,0)
   disp('User selected Cancel');
else
    % set fullname
    fluxfile=strcat(filepath,filename);
    %% change buttom color while data is loaded 
    set(gcbo,'Backgroundcolor','y');
    %% import parameters from data header
    par = Upscale_read_flux_header(fluxfile, 'UNFATT', 'A1:AL4');
    % extract individual parameters
    %% get user input parameters as global 
    %vnsinput u2 alphaTransgg alphaTransbg vgm v2est eta_user
    ap=par(2,2); ag=par(1,10); por=par(1,8); rlim = par(1,6); 
    %Calculate velocity in m/hr
    vpor=par(1,4)/por*3600.0;
    asp=par(1,22); asp2=par(1,24);
    % get rlimFAV
    par = Upscale_read_flux_header(fluxfile, 'FAVATT', 'A1:AL4');
    rlimFAV = par(1,6); 
    % load values in static text fields
    set(handles.ap_st,'String',num2str(ap,'%5.4e'));
    set(handles.ag_st,'String',num2str(ag,'%5.4e'));
    set(handles.por_st,'String',num2str(por,'%5.4e'));
    set(handles.rlim_st,'String',num2str(rlim,'%5.4e'));
    set(handles.vpor_st,'String',num2str(vpor,'%5.4e'));
    set(handles.asp_st,'String',num2str(asp,'%5.4e'));
    set(handles.asp2_st,'String',num2str(asp2,'%5.4e'));
    set(handles.statvpor,'String',num2str(vpor,'%5.4e'));
    % make static text red
    set(handles.ap_st,'ForegroundColor','red');
    set(handles.ag_st,'ForegroundColor','red');
    set(handles.por_st,'ForegroundColor','red');
    set(handles.rlim_st,'ForegroundColor','red');
    set(handles.vpor_st,'ForegroundColor','red');
    set(handles.asp_st,'ForegroundColor','red');
    set(handles.asp2_st,'ForegroundColor','red');
    set(handles.ap_st,'ForegroundColor','red');
    set(handles.ap_st,'ForegroundColor','red');
    %% import data
    tic
    % start progress bar
    pbar = waitbar(0,'Please wait, reading flux files..');

    % set number of header rows
    nheader = 6;
    % set total number of rows to read
    endrow = 50000;
    % read file
    % import header
    UPFLUX_header = import_header_UPFLUX(fluxfile, "FAVATT", [1, 4]);
    waitbar(1 / 5)
    % import fluxes data
    [XOUTaf,YOUTaf,ZOUTaf,TBULKaf,TNEARaf,TTOTALaf,ATTACHKaf,XINITaf,YINITaf,RINITaf,ZINITaf,NSVELaf] = ...
        importUPFLUX(fluxfile,'FAVATT',nheader+1,endrow);
    waitbar(2 / 5)
    [XOUTef,YOUTef,ZOUTef,TBULKef,TNEARef,TTOTALef,ATTACHKef,XINITef,YINITef,RINITef,ZINITef,NSVELef] = ...
        importUPFLUX(fluxfile,'FAVEX',nheader+1,endrow);
    waitbar(3 / 5)
    [XOUTau,YOUTau,ZOUTau,TBULKau,TNEARau,TTOTALau,ATTACHKau,XINITau,YINITau,RINITau,ZINITau,NSVELau] = ...
        importUPFLUX(fluxfile,'UNFATT',nheader+1,endrow);
    waitbar(4 / 5)
    [XOUTeu,YOUTeu,ZOUTeu,TBULKeu,TNEAReu,TTOTALeu,ATTACHKeu,XINITeu,YINITeu,RINITeu,ZINITeu,NSVELeu] = ...
        importUPFLUX(fluxfile,'UNFEX',nheader+1,endrow);
    waitbar(5 / 5)
    close(pbar) 
    toc
    % teel user that data is loaded
    msg_readyIMPORT
    disp('Flux data loaded')
    % activate calculate efficiencies button
    set(handles.pushALPHA,'Enable','on')
    set(handles.pushALPHA,'BackgroundColor','g')
end
% %% create input file with parameters from hapGUI
% fin =strcat(INPUTNAME,'.txt'); 
% finput = strcat(workdir,fin);
% 
% %% run simulation
% Hap_GUI_shell()
%  set(handles.figure1, 'pointer', 'arrow')
%   %indicate completed sim GUI
%  done_msg1_HGUI()
%  w = waitforbuttonpress;


% --- Executes on button press in pushALPHA.
function pushALPHA_Callback(hObject, eventdata, handles)
% hObject    handle to pushALPHA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Alert user that all UNFATT colloids categorized as attached (ATTACHK 2,4) vs. RFSZ (ATTACHK 5)
m=warndlg({'Note to user:','UNFATT colloids categorized as attached (ATTACHK 2,4,6) vs. RFSZ (ATTACHK 5)',...
           'ATTACHK 2= arrested, ATTACHK 4= slow rolling, ATTACHK 6= crashed',... 
           'ATTACHK 5= remaining in near surface (RFSZ)','ATTACHK 1= exited', ...
           'ATTACHK 3= timed out (not considered)'},'Warning');
waitfor(m);

%% change buttom color to yellow during simulation
set(gcbo,'Backgroundcolor','y');
pause(1) % allows matlab to show button color change becasue function executes fast
%% get user input parameters as global 
global ap ag por rlim vpor asp asp2 vnsinput u2 
global alphaTransgg alphaTransbg vns vgm  
ap= get(handles.ap_st,'String'); ap=str2double(ap);
ag= get(handles.ag_st,'String'); ag=str2double(ag);
por= get(handles.por_st,'String'); por=str2double(por);
rlim= get(handles.rlim_st,'String'); rlim=str2double(rlim);
vpor= get(handles.vpor_st,'String'); vpor=str2double(vpor);
asp= get(handles.asp_st,'String'); asp=str2double(asp);
asp2= get(handles.asp2_st,'String'); asp2=str2double(asp2);
vnsinput= get(handles.vnsinput,'String'); vnsinput=str2double(vnsinput);
alphaTransgg= get(handles.alphaTransgg,'String'); alphaTransgg=str2double(alphaTransgg);
alphaTransbg= get(handles.alphaTransbg,'String'); alphaTransbg=str2double(alphaTransbg);
%% set global variables to pass to profiles calculation
global alpha1 alpha2 alphaRFSP alphaREENT eta 
%% set globals to pass through values to other functions
global XOUTaf YOUTaf ZOUTaf TBULKaf TNEARaf TTOTALaf ATTACHKaf XINITaf YINITaf RINITaf ZINITaf NSVELaf
global XOUTef YOUTef ZOUTef TBULKef TNEARef TTOTALef ATTACHKef XINITef YINITef RINITef ZINITef NSVELef
global XOUTau YOUTau ZOUTau TBULKau TNEARau TTOTALau ATTACHKau XINITau YINITau RINITau ZINITau NSVELau
global XOUTeu YOUTeu ZOUTeu TBULKeu TNEAReu TTOTALeu ATTACHKeu XINITeu YINITeu RINITeu ZINITeu NSVELeu
[alpha1, alpha2, alphaRFSP, alphaREENT, u2,eta]=UpscaleALPHAS(...
XOUTaf, YOUTaf, ZOUTaf, TBULKaf, TNEARaf, TTOTALaf, ATTACHKaf, XINITaf, YINITaf, RINITaf ,ZINITaf,NSVELaf,...
XOUTef, YOUTef, ZOUTef, TBULKef, TNEARef, TTOTALef, ATTACHKef, XINITef, YINITef ,RINITef, ZINITef,NSVELef,...
XOUTau, YOUTau, ZOUTau, TBULKau, TNEARau, TTOTALau, ATTACHKau, XINITau, YINITau, RINITau, ZINITau,NSVELau,...
XOUTeu, YOUTeu, ZOUTeu, TBULKeu, TNEAReu, TTOTALeu, ATTACHKeu, XINITeu, YINITeu, RINITeu, ZINITeu,NSVELeu);


%% update static text with calculated values 
% eta and u2
set(handles.etasim,'String',num2str(eta,'%5.3e'));
set(handles.u2sim,'String',num2str(u2,'%5.3e'));
%efficiencies
set(handles.alpha1_static,'String',num2str(alpha1,'%5.3e'));
set(handles.alpha2_static,'String',num2str(alpha2,'%5.3e'));
set(handles.alphaRFSP_static,'String',num2str(alphaRFSP,'%5.3e'));
set(handles.alphaREENT_static,'String',num2str(alphaREENT,'%5.3e'));
%check alpha sum
alphacheck = alpha1+alpha2+alphaRFSP+alphaREENT;
set(handles.acheck_calc,'String',num2str(alphacheck,'%6.4e'));
    if alphacheck<(1+1e-5)&&alphacheck>(1-1e-5)
        set(handles.acheck_calc,'BackgroundColor','g');
    else
        set(handles.acheck_calc,'BackgroundColor','r');
    end
% update near surface value
if vnsinput==0.0
    if u2>0.0
        vns = u2;
        set(handles.statvns,'String',num2str(u2,'%5.3e'));
    else
        vns = vpor*0.05;
        set(handles.statvns,'String',num2str(vns,'%5.3e'));
    end
else
    set(handles.statvns,'String',num2str(vnsinput,'%5.3e'));
    vns = vnsinput;
end
 %calculate vns geometric mean
 vgm = (vpor*vns)^0.5;
 set(handles.statvgm,'String',num2str(vgm));
%alert user
msg_readyALPHAS;
%% activate calculate rate constant buttom
set(handles.pushRATES,'Enable','on')
set(handles.pushRATES,'BackgroundColor','g')



function pushbutton_getValCALC_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_getValCALC (see GCBO)
global vporBTC vnsBTC vns vporOUT vnsOUT vgmOUT apOUT_FLAG
% activate ap output
apOUT_FLAG = 1;
%% change alternative buttom to red if needed
lgray =[0.83 0.82 0.78];
set(handles.pushbutton_getValUSER,'Backgroundcolor',lgray);

% enable near surface implicit vs explcit panel
set(handles.ns_panel,'BackgroundColor','g')

% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 % get the current value from the static text field
 % update the edit text field with the corresponding rate constant values
set(handles.kf,'String',char(get(handles.kf_static,'String')));
set(handles.kf2,'String',char(get(handles.kf2_static,'String')));
set(handles.kns,'String',char(get(handles.kns_static,'String'))); 
set(handles.kf2star,'String',char(get(handles.kf2star_static,'String'))); 
 % update the edit text field with the corresponding alpha values
set(handles.alpha1,'String',char(get(handles.alpha1_static,'String'))); 
set(handles.alpha2,'String',char(get(handles.alpha2_static,'String'))); 
set(handles.alphaRFSP,'String',char(get(handles.alphaRFSP_static,'String'))); 
set(handles.alphaREENT,'String',char(get(handles.alphaREENT_static,'String')));
%% check if alpha1 and alpha2 are zero
% alpha1 = str2double((get(handles.alpha1,'String')));
% alpha2 = str2double((get(handles.alpha2,'String')));
% if (alpha1+alpha2)==0
%     % enable only explicit calc checkbox
%     set(handles.checkboxEXP,'Enable','on')  
% else
%     % enable explicit and implicit calc checkbox
%     set(handles.checkboxIMP,'Enable','on')
%     set(handles.checkboxEXP,'Enable','on')    
% end
% enable implicit and explicit runs
set(handles.checkboxIMP,'Enable','on')
set(handles.checkboxEXP,'Enable','on')   
% load in global proper vpor
vporBTC= get(handles.statvpor,'String'); 
set(handles.vporBTC,'String',vporBTC);
vporBTC=str2double(vporBTC);
% update vpor and vns in BTC box
vnsBTC = vns; 
set(handles.vnsBTC,'String',num2str(vnsBTC));
% set values for output 
vnsOUT = vnsBTC;
vporOUT = vporBTC;
vgmOUT =str2double(get(handles.statvgm,'String'));

% show done message 
msg_calcVAL


%% Simulates retained profile and BTC 
function pushbuttonPROF_BTC_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonPROF_BTC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ap ag vns asp asp2 eta_custom eta
global c sf ss  r n
global alpha1 alpha2 alphaRFSP alphaREENT v2 kf kf2 kns kf2star 
global npart ttime delta_t dispersivity xmax dcol vpor pulse_time Co_input por
global OUTDIR outputdir
global part_kf part_kns part_loc part_status exit_time dx
global vporBTC vnsBTC apOUT_FLAG BTC_points


%% get user input parameters as global 
npart= get(handles.npart,'String'); npart=str2double(npart);
ttime= get(handles.ttime,'String'); ttime=str2double(ttime);
delta_t= get(handles.delta_t,'String'); delta_t=str2double(delta_t);
dx =  get(handles.dx,'String'); dx=str2double(dx);
dispersivity= get(handles.dispersivity,'String'); dispersivity=str2double(dispersivity);
xmax= get(handles.xmax,'String'); xmax=str2double(xmax);
dcol= get(handles.dcol,'String'); dcol=str2double(dcol);
BTC_points= get(handles.BTC_points,'String');
BTC_points = str2double(BTC_points);
% vpor= get(handles.statvpor,'String'); vpor=str2double(vpor);
pulse_time= get(handles.pulse_time,'String'); pulse_time=str2double(pulse_time);
Co_input= get(handles.Co_input,'String'); Co_input=str2double(Co_input);
OUTDIR=get(handles.outputname,'String');
% get rates and alphas from loaded static text
alpha1= get(handles.alpha1,'String'); alpha1=str2double(alpha1);
alpha2= get(handles.alpha2,'String'); alpha2=str2double(alpha2);
alphaRFSP= get(handles.alphaRFSP,'String');  alphaRFSP=str2double(alphaRFSP);
alphaREENT= get(handles.alphaREENT,'String'); alphaREENT=str2double(alphaREENT); 
% v2= get(handles.statvns,'String'); v2=str2double(v2);  
kf= get(handles.kf,'String'); kf=str2double(kf);  
kf2= get(handles.kf2,'String'); kf2=str2double(kf2);  
kns= get(handles.kns,'String'); kns=str2double(kns);
kf2star= get(handles.kf2star,'String'); kf2star=str2double(kf2star); 
%% change buttom color to yellow during simulation
set(gcbo,'Backgroundcolor','y');
global NSIND
val=get(handles.checkboxIMP,'value');
if val
    NSIND=0;
else
    NSIND=1;
end
%% simulate
[concBTCnorm,numDATTF,numDATTS,numDNES,numDAQF,binsBTC,binsPROF]=UpscaleBTC_PROF (npart,ttime,delta_t,dispersivity, xmax, dcol, vporBTC,vnsBTC, pulse_time);
% update dx value if user was not usable
set(handles.dx,'String',num2str(dx,'%5.3e'));
%% Create OUTPUT directory to write output BTC, profile, and sim parameters
% %  create string from output directory  
OUTDIR=get(handles.outputname,'String');
outs = strcat('\',OUTDIR,'\');
% % set working directory        
if ~isdeployed
    % MATLAB environment
    outpath = strrep(mfilename('fullpath'),'\Upscale_Continuum_GUI','\');
    mkdir(outpath,OUTDIR);
    outputdir = strrep(mfilename('fullpath'),'\Upscale_Continuum_GUI',outs);
else
   %deployed application
    outpath=pwd;
    mkdir(outpath,OUTDIR);
    outputdir=strcat(outpath,outs)
end
% write flux output files
 upscale_write_OUT (concBTCnorm,numDATTF,numDATTS,numDNES,numDAQF,binsBTC,binsPROF)
%% change color buttom to green
msg_readyBTC_PROF;

function ap_Callback(hObject, eventdata, handles)
% hObject    handle to ap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ap as text
%        str2double(get(hObject,'String')) returns contents of ap as a double
ap = str2double(get(hObject,'String' )); 
set(hObject,'String',ap); 
set(handles.ap,'String',ap); 


% --- Executes during object creation, after setting all properties.
function ap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function por_Callback(hObject, eventdata, handles)
% hObject    handle to por (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of por as text
%        str2double(get(hObject,'String')) returns contents of por as a double
por = str2double(get(hObject,'String' )); 
set(hObject,'String',por); 
set(handles.por,'String',por); 

% --- Executes during object creation, after setting all properties.
function por_CreateFcn(hObject, eventdata, handles)
% hObject    handle to por (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







function ag_Callback(hObject, eventdata, handles)
% hObject    handle to ag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ag as text
%        str2double(get(hObject,'String')) returns contents of ag as a double
ag = str2double(get(hObject,'String' )); 
set(hObject,'String',ag); 
set(handles.ag,'String',ag); 


% --- Executes during object creation, after setting all properties.
function ag_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vpor_Callback(hObject, eventdata, handles)
global vpor 
% hObject    handle to vpor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vpor as text
%        str2double(get(hObject,'String')) returns contents of vpor as a double
vpor = str2double(get(hObject,'String' )); 
set(hObject,'String',vpor); 
set(handles.vpor,'String',vpor); 
set(handles.statvpor,'String',num2str(vpor,'%5.3e'));
% get geometric mean near surface velocity calc if vnsinput>0.0

    



% --- Executes during object creation, after setting all properties.
function vpor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vpor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alphaTransgg_Callback(hObject, eventdata, handles)
% hObject    handle to alphaTransgg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alphaTransgg as text
%        str2double(get(hObject,'String')) returns contents of alphaTransgg as a double
alphaTransgg = str2double(get(hObject,'String' )); 
set(hObject,'String',alphaTransgg); 
set(handles.alphaTransgg,'String',alphaTransgg); 


% --- Executes during object creation, after setting all properties.
function alphaTransgg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphaTransgg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vnsinput_Callback(hObject, eventdata, handles)
global vnsinput
% hObject    handle to vnsinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vnsinput as text
%        str2double(get(hObject,'String')) returns contents of vnsinput as a double

vnsinput = str2double(get(hObject,'String' )); 
set(hObject,'String',vnsinput); 
set(handles.vnsinput,'String',vnsinput); 
if vnsinput >0.0
    set(handles.statvns,'String',num2str(vnsinput,'%5.3e'));
else
    set(handles.statvns,'String','not calculated   yet');
end

% --- Executes during object creation, after setting all properties.
function vnsinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vnsinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rlim_Callback(hObject, eventdata, handles)
% hObject    handle to rlim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rlim as text
%        str2double(get(hObject,'String')) returns contents of rlim as a double

rlim = str2double(get(hObject,'String' )); 
set(hObject,'String',rlim); 
set(handles.rlim,'String',rlim); 

% --- Executes during object creation, after setting all properties.
function rlim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rlim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text30_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text30 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called





function kf_custom_Callback(hObject, eventdata, handles)
% hObject    handle to kf_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kf_custom as text
%        str2double(get(hObject,'String')) returns contents of kf_custom as a double
kf = str2double(get(hObject,'String' )); 
set(hObject,'String',kf); 
set(handles.kf_custom,'String',kf); 

% --- Executes during object creation, after setting all properties.
function kf_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kf_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kf2_custom_Callback(hObject, eventdata, handles)
% hObject    handle to kf2_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kf2_custom as text
%        str2double(get(hObject,'String')) returns contents of kf2_custom as a double
kf2 = str2double(get(hObject,'String' )); 
set(hObject,'String',kf2); 
set(handles.kf2_custom,'String',kf2); 

% --- Executes during object creation, after setting all properties.
function kf2_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kf2_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kns_custom_Callback(hObject, eventdata, handles)
% hObject    handle to kns_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kns_custom as text
%        str2double(get(hObject,'String')) returns contents of kns_custom as a double
kns = str2double(get(hObject,'String' )); 
set(hObject,'String',kns); 
set(handles.kns_custom,'String',kns); 

% --- Executes during object creation, after setting all properties.
function kns_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kns_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function kf2star_custom_Callback(hObject, eventdata, handles)
% hObject    handle to kf2star_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of kf2star_custom as text
%        str2double(get(hObject,'String')) returns contents of kf2star_custom as a double
kf2star = str2double(get(hObject,'String' )); 
set(hObject,'String',kf2star); 
set(handles.kf2star_custom,'String',kf2star); 

% --- Executes during object creation, after setting all properties.
function kf2star_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kf2star_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function npart_Callback(hObject, eventdata, handles)
% hObject    handle to npart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of npart as text
%        str2double(get(hObject,'String')) returns contents of npart as a double
npart = str2double(get(hObject,'String' )); 
set(hObject,'String',npart); 
set(handles.npart,'String',npart); 

% --- Executes during object creation, after setting all properties.
function npart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to npart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% function dx_Callback(hObject, eventdata, handles)
% % hObject    handle to dx (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% 
% % Hints: get(hObject,'String') returns contents of dx as text
% %        str2double(get(hObject,'String')) returns contents of dx as a double
% dx = str2double(get(hObject,'String' )); 
% set(hObject,'String',dx); 
% set(handles.dx,'String',dx); 
% 
% % --- Executes during object creation, after setting all properties.
% function dx_CreateFcn(hObject, eventdata, handles)
% % hObject    handle to dx (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    empty - handles not created until after all CreateFcns called
% 
% % Hint: edit controls usually have a white background on Windows.
% %       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end



function ttime_Callback(hObject, eventdata, handles)
% hObject    handle to ttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ttime as text
%        str2double(get(hObject,'String')) returns contents of ttime as a double
ttime = str2double(get(hObject,'String' )); 
set(hObject,'String',ttime); 
set(handles.ttime,'String',ttime); 

% --- Executes during object creation, after setting all properties.
function ttime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function delta_t_Callback(hObject, eventdata, handles)
% hObject    handle to delta_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of delta_t as text
%        str2double(get(hObject,'String')) returns contents of delta_t as a double
delta_t = str2double(get(hObject,'String' )); 
set(hObject,'String',delta_t); 
set(handles.delta_t,'String',delta_t); 

% --- Executes during object creation, after setting all properties.
function delta_t_CreateFcn(hObject, eventdata, handles)
% hObject    handle to delta_t (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dispersivity_Callback(hObject, eventdata, handles)
% hObject    handle to dispersivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dispersivity as text
%        str2double(get(hObject,'String')) returns contents of dispersivity as a double
dispersivity = str2double(get(hObject,'String' )); 
set(hObject,'String',dispersivity); 
set(handles.dispersivity,'String',dispersivity); 

% --- Executes during object creation, after setting all properties.
function dispersivity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dispersivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xmax_Callback(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xmax as text
%        str2double(get(hObject,'String')) returns contents of xmax as a double
xmax = str2double(get(hObject,'String' )); 
set(hObject,'String',xmax); 
set(handles.xmax,'String',xmax); 

% --- Executes during object creation, after setting all properties.
function xmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dcol_Callback(hObject, eventdata, handles)
% hObject    handle to dcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dcol as text
%        str2double(get(hObject,'String')) returns contents of dcol as a double
dcol = str2double(get(hObject,'String' )); 
set(hObject,'String',dcol); 
set(handles.dcol,'String',dcol); 

% --- Executes during object creation, after setting all properties.
function dcol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dcol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Co_input_Callback(hObject, eventdata, handles)
% hObject    handle to Co_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Co_input as text
%        str2double(get(hObject,'String')) returns contents of Co_input as a double
Co_input = str2double(get(hObject,'String' )); 
set(hObject,'String',Co_input); 
set(handles.Co_input,'String',Co_input); 

% --- Executes during object creation, after setting all properties.
function Co_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Co_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pulse_time_Callback(hObject, eventdata, handles)
% hObject    handle to pulse_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pulse_time as text
%        str2double(get(hObject,'String')) returns contents of pulse_time as a double
pulse_time = str2double(get(hObject,'String' )); 
set(hObject,'String',pulse_time); 
set(handles.pulse_time,'String',pulse_time); 

% --- Executes during object creation, after setting all properties.
function pulse_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pulse_time (see GCBO)
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


% --- Executes on button press in pushbutton_getValUSER.
function pushbutton_getValUSER_Callback(hObject, eventdata, handles)
global por ap ag alpha1 alpha2 alphaRFSP alphaREENT 
global alphaTransgg alphaTransbg  eta apOUT_FLAG
global vporBTC vnsBTC vns_custom vporOUT vnsOUT vgmOUT 
% activate ap output
apOUT_FLAG = 0;

%% change alternative buttom to red if needed
lgray =[0.83 0.82 0.78];
set(handles.pushbutton_getValCALC,'Backgroundcolor',lgray);
% hObject    handle to pushbutton_getValUSER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.kf,'String',char(get(handles.kf_custom,'String')));
set(handles.kf2,'String',char(get(handles.kf2_custom,'String')));
set(handles.kns,'String',char(get(handles.kns_custom,'String'))); 
set(handles.kf2star,'String',char(get(handles.kf2star_custom,'String')));
 % update the edit text field with the corresponding alpha values
set(handles.alpha1,'String',char(get(handles.alpha1_custom,'String'))); 
set(handles.alpha2,'String',char(get(handles.alpha2_custom,'String'))); 
set(handles.alphaRFSP,'String',char(get(handles.alphaRFSP_custom,'String'))); 
set(handles.alphaREENT,'String',char(get(handles.alphaREENT_custom,'String'))); 
% enable near surface implicit vs explcit panel
set(handles.ns_panel,'BackgroundColor','g')

%% check that Pore scale paramters from user input are read in 
eta_custom=get(handles.eta_custom,'String');eta_custom=str2double(eta_custom);
if eta_custom>0.0 
    % get parameters in the absence of trajectory simulation flux data
    por=get(handles.por_custom,'String');por=str2double(por);
    ap= get(handles.ap_custom,'String'); ap=str2double(ap);
    ag= get(handles.ag_custom,'String'); ag=str2double(ag);
    alpha1 =get(handles.alpha1_custom,'String');alpha1=str2double(alpha1);
    alpha2 =get(handles.alpha2_custom,'String');alpha2=str2double(alpha2);
    alphaRFSP =get(handles.alphaRFSP_custom,'String');alphaRFSP=str2double(alphaRFSP);
    alphaREENT =get(handles.alphaREENT_custom,'String');alphaREENT=str2double(alphaREENT);
    alphaTransgg =get(handles.alphaTransgg_custom,'String');alphaTransgg=str2double(alphaTransgg);
    alphaTransbg =get(handles.alphaTransbg_custom,'String');alphaTransbg=str2double(alphaTransbg);
    vns_custom=get(handles.vns_custom,'String');vns_custom=str2double(vns_custom);
    eta = eta_custom;
    % load in global proper vpor
    % update vpor and vns in BTC box
    vporBTC= get(handles.vpor_custom,'String');  
    set(handles.vporBTC,'String',vporBTC);
    vporBTC=str2double(vporBTC);
    vnsBTC = get(handles.vns_custom,'String'); 
    set(handles.vnsBTC,'String',vnsBTC);
    vnsBTC=str2double(vnsBTC);
    % assing velocity values for output
    vporOUT = vporBTC;
    vnsOUT = vnsBTC; 
    vgmOUT =str2double(get(handles.statvgm_custom,'String'));
end
%% enable explicit and implicit calc checkbox




set(handles.checkboxIMP,'Enable','on')
set(handles.checkboxEXP,'Enable','on')
% show done message 
msg_customVAL


% --- Executes on button press in checkboxEXP.
function checkboxEXP_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxEXP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxEXP
global NSIND
vexp=get(handles.checkboxEXP,'value');
lightGrey2   = [0.7 0.7 0.7];
%enable profile BTC button
set(handles.pushbuttonPROF_BTC,'Enable','on')
set(handles.pushbuttonPROF_BTC,'BackgroundColor','g')
set(handles.vporBTC,'Enable','on');
set(handles.vnsBTC,'Enable','on');
if vexp
    NSIND = 1;
    set(handles.checkboxIMP,'value',0);
    %change format accordingly
    set(handles.kf2,'ForegroundColor',lightGrey2);
    set(handles.kf2,'FontWeight','Normal');
    set(handles.kf2star,'ForegroundColor','k');
    set(handles.kf2star,'FontWeight','Bold');
    set(handles.kns,'ForegroundColor','k');
    set(handles.kns,'FontWeight','Bold');
    % change style for common efficiencies and kf values displayed for imp and exp
    set(handles.alpha1,'ForegroundColor','k'); set(handles.alpha1,'FontWeight','bold');
    set(handles.alpha2,'ForegroundColor','k'); set(handles.alpha2,'FontWeight','bold');
    set(handles.alphaRFSP,'ForegroundColor','k'); set(handles.alphaRFSP,'FontWeight','bold');
    set(handles.alphaREENT,'ForegroundColor','k'); set(handles.alphaREENT,'FontWeight','bold');
    set(handles.kf,'ForegroundColor','k'); set(handles.kf,'FontWeight','bold');    
    
else
    % check if implicit is disable
    implicit = get(handles.checkboxIMP,'Enable');
    % check second character of string, on/off   n/f
    if implicit(2)=='n'
        NSIND = 0;
        set(handles.checkboxIMP,'value',1);  
        %change format accordingly
        set(handles.kf2,'ForegroundColor','k');
        set(handles.kf2,'FontWeight','Bold');
        set(handles.kf2star,'ForegroundColor',lightGrey2);
        set(handles.kf2star,'FontWeight','Normal');
        set(handles.kns,'ForegroundColor',lightGrey2);
        set(handles.kns,'FontWeight','Normal');
    end
end


% --- Executes on button press in checkboxIMP.
function checkboxIMP_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxIMP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxIMP
global NSIND
vimp=get(handles.checkboxIMP,'value');
lightGrey2   = [0.7 0.7 0.7];
%enable profile BTC button
set(handles.pushbuttonPROF_BTC,'Enable','on')
set(handles.pushbuttonPROF_BTC,'BackgroundColor','g')
set(handles.vporBTC,'Enable','on');
set(handles.vnsBTC,'Enable','on');
if vimp
    NSIND = 0;
    set(handles.checkboxEXP,'value',0)
    %change format accordingly
    set(handles.kf2,'ForegroundColor','k');
    set(handles.kf2,'FontWeight','Bold');
    set(handles.kf2star,'ForegroundColor',lightGrey2);
    set(handles.kf2star,'FontWeight','Normal');
    set(handles.kns,'ForegroundColor',lightGrey2);
    set(handles.kns,'FontWeight','Normal');
    % change style for common efficiencies and kf values displayed for imp and exp
    set(handles.alpha1,'ForegroundColor','k'); set(handles.alpha1,'FontWeight','bold');
    set(handles.alpha2,'ForegroundColor','k'); set(handles.alpha2,'FontWeight','bold');
    set(handles.alphaRFSP,'ForegroundColor','k'); set(handles.alphaRFSP,'FontWeight','bold');
    set(handles.alphaREENT,'ForegroundColor','k'); set(handles.alphaREENT,'FontWeight','bold');
    set(handles.kf,'ForegroundColor','k'); set(handles.kf,'FontWeight','bold');
else
    NSIND = 1;
    set(handles.checkboxEXP,'value',1)
    %change format accordingly
    set(handles.kf2,'ForegroundColor',lightGrey2);
    set(handles.kf2,'FontWeight','Normal');
    set(handles.kf2star,'ForegroundColor','k');
    set(handles.kf2star,'FontWeight','Bold');
    set(handles.kns,'ForegroundColor','k');
    set(handles.kns,'FontWeight','Bold');
end


% --- Executes during object creation, after setting all properties.
function kf2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kf2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object deletion, before destroying properties.
function kf2_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to kf2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function kf2star_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kf2star (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function kns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function uipanel3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function outputname_Callback(hObject, eventdata, handles)
% hObject    handle to outputname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputname as text
%        str2double(get(hObject,'String')) returns contents of outputname as a double
outputname = get(hObject,'String'); 
set(hObject,'String',outputname); 
set(handles.outputname,'String',outputname); 

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



function alpha1_custom_Callback(hObject, eventdata, handles)
% hObject    handle to alpha1_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha1_custom as text
%        str2double(get(hObject,'String')) returns contents of alpha1_custom as a double
alpha1_custom = str2double(get(hObject,'String' )); 
set(hObject,'String',alpha1_custom); 
set(handles.alpha1_custom,'String',num2str(alpha1_custom,'%5.4e'));
%deactivate buttons for flux data processing
if alpha1_custom>=0.0&&alpha1_custom<=1.0
     % disable impor and alphas calc buttons
%      set(handles.pushbuttomIMPORT,'Enable','off')
%      set(handles.pushALPHA,'Enable','off')
%      lightGrey2   = [0.7 0.7 0.7];
%      set(handles.pushbuttomIMPORT,'BackgroundColor',lightGrey2);  
%       lightGrey2   = [0.7 0.7 0.7];
%      set(handles.pushALPHA,'BackgroundColor',lightGrey2);  
     
else
     % reset user efificiencies
     set(handles.alpha1_custom,'String','Edit Text');
     set(handles.alpha2_custom,'String','Edit Text')
     set(handles.alphaRFSP_custom,'String','Edit Text')
     set(handles.alphaREENT_custom,'String','Edit Text')
end



%check sum of efficiencies
alpha2_custom= str2double(get(handles.alpha2_custom,'String'));
alphaRFSP_custom= str2double(get(handles.alphaRFSP_custom,'String'));
alphaREENT_custom= str2double(get(handles.alphaREENT_custom,'String'));
alphacheck_noflux = alpha1_custom+alpha2_custom+alphaRFSP_custom+alphaREENT_custom;
set(handles.acheck_custom,'String',num2str(alphacheck_noflux,'%6.4e'));
%change format and dectivate rates button
if alphacheck_noflux<(1+1e-5)&&alphacheck_noflux>(1-1e-5)
    set(handles.acheck_custom,'BackgroundColor','g');
     set(handles.pushRATES,'Enable','on')
     lightGrey2   = [0.7 0.7 0.7];
     set(handles.pushRATES,'BackgroundColor','g');   
else
    set(handles.acheck_custom,'BackgroundColor','r');
    set(handles.pushRATES,'Enable','off')
     lightGrey2   = [0.7 0.7 0.7];
     set(handles.pushRATES,'BackgroundColor',lightGrey2);   
    
end



% --- Executes during object creation, after setting all properties.
function alpha1_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha1_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alpha2_custom_Callback(hObject, eventdata, handles)
% hObject    handle to alpha2_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alpha2_custom as text
%        str2double(get(hObject,'String')) returns contents of alpha2_custom as a double
alpha2 = str2double(get(hObject,'String' )); 
set(hObject,'String',alpha2); 
set(handles.alpha2_custom,'String',num2str(alpha2,'%5.4e'));

%deactivate buttons for flux data processing
if alpha2>=0.0&&alpha2<=1.0
     % disable impor and alphas calc buttons
     set(handles.pushbuttomIMPORT,'Enable','off')
     set(handles.pushALPHA,'Enable','off')
     lightGrey2   = [0.7 0.7 0.7];
     set(handles.pushbuttomIMPORT,'BackgroundColor',lightGrey2);  
      lightGrey2   = [0.7 0.7 0.7];
     set(handles.pushALPHA,'BackgroundColor',lightGrey2);  
     
else
     set(handles.pushbuttomIMPORT,'Enable','on')
     set(handles.pushbuttomIMPORT,'BackgroundColor','r');   
     set(handles.pushALPHA,'Enable','on')
     set(handles.pushALPHA,'BackgroundColor','r');   
     % reset user efificiencies
     set(handles.alpha1_custom,'String','Edit Text');
     set(handles.alpha2_custom,'String','Edit Text')
     set(handles.alphaRFSP_custom,'String','Edit Text')
     set(handles.alphaREENT_custom,'String','Edit Text')
end


%check sum of efficiencies
alpha1= str2double(get(handles.alpha1_custom,'String'));
alphaRFSP= str2double(get(handles.alphaRFSP_custom,'String'));
alphaREENT= str2double(get(handles.alphaREENT_custom,'String'));
alphacheck = alpha1+alpha2+alphaRFSP+alphaREENT;
set(handles.acheck_custom,'String',num2str(alphacheck,'%6.4e'));
%change format and dectivate rates button
if alphacheck<(1+1e-5)&&alphacheck>(1-1e-5)
    set(handles.acheck_custom,'BackgroundColor','g');
     set(handles.pushRATES,'Enable','on')
     set(handles.pushRATES,'BackgroundColor','g');   
else
    set(handles.acheck_custom,'BackgroundColor','r');
    set(handles.pushRATES,'Enable','off')
     lightGrey2   = [0.7 0.7 0.7];
     set(handles.pushRATES,'BackgroundColor',lightGrey2);   
    
end


% --- Executes during object creation, after setting all properties.
function alpha2_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha2_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alphaRFSP_custom_Callback(hObject, eventdata, handles)
% hObject    handle to alphaRFSP_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alphaRFSP_custom as text
%        str2double(get(hObject,'String')) returns contents of alphaRFSP_custom as a double
alphaRFSP = str2double(get(hObject,'String' )); 
set(hObject,'String',alphaRFSP); 
set(handles.alphaRFSP_custom,'String',num2str(alphaRFSP,'%5.4e'));
%deactivate buttons for flux data processing
if alphaRFSP>=0.0&&alphaRFSP<=1.0
     % disable impor and alphas calc buttons
     set(handles.pushbuttomIMPORT,'Enable','off')
     set(handles.pushALPHA,'Enable','off')
     lightGrey2   = [0.7 0.7 0.7];
     set(handles.pushbuttomIMPORT,'BackgroundColor',lightGrey2);  
     set(handles.pushALPHA,'BackgroundColor',lightGrey2);  
     
else 
     % reset user efificiencies
     set(handles.alpha1_custom,'String','Edit Text');
     set(handles.alpha2_custom,'String','Edit Text')
     set(handles.alphaRFSP_custom,'String','Edit Text')
     set(handles.alphaREENT_custom,'String','Edit Text')
end

%check sum of efficiencies
alpha1= str2double(get(handles.alpha1_custom,'String'));
alpha2= str2double(get(handles.alpha2_custom,'String'));
alphaREENT= str2double(get(handles.alphaREENT_custom,'String'));
alphacheck = alpha1+alpha2+alphaRFSP+alphaREENT;
set(handles.acheck_custom,'String',num2str(alphacheck,'%6.4e'));
%change format and dectivate rates button
if alphacheck<(1+1e-5)&&alphacheck>(1-1e-5)
    set(handles.acheck_custom,'BackgroundColor','g');
     set(handles.pushRATES,'Enable','on')
     set(handles.pushRATES,'BackgroundColor','g');   
else
    set(handles.acheck_custom,'BackgroundColor','r');
    set(handles.pushRATES,'Enable','off')
     lightGrey2   = [0.7 0.7 0.7];
     set(handles.pushRATES,'BackgroundColor',lightGrey2);   
    
end


% --- Executes during object creation, after setting all properties.
function alphaRFSP_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphaRFSP_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alphaREENT_custom_Callback(hObject, eventdata, handles)
% hObject    handle to alphaREENT_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alphaREENT_custom as text
%        str2double(get(hObject,'String')) returns contents of alphaREENT_custom as a double
alphaREENT = str2double(get(hObject,'String' )); 
set(hObject,'String',alphaREENT); 
set(handles.alphaREENT_custom,'String',num2str(alphaREENT,'%5.4e'));
%deactivate buttons for flux data processing
if alphaREENT>=0.0&&alphaREENT<=1.0
     % disable impor and alphas calc buttons
     set(handles.pushbuttomIMPORT,'Enable','off')
     set(handles.pushALPHA,'Enable','off')
     lightGrey2   = [0.7 0.7 0.7];
     set(handles.pushbuttomIMPORT,'BackgroundColor',lightGrey2);  
     set(handles.pushALPHA,'BackgroundColor',lightGrey2);  
     
else  
     % reset user efificiencies
     set(handles.alpha1_custom,'String','Edit Text');
     set(handles.alpha2_custom,'String','Edit Text')
     set(handles.alphaRFSP_custom,'String','Edit Text')
     set(handles.alphaREENT_custom,'String','Edit Text')
end

%check sum of efficiencies
alpha1= str2double(get(handles.alpha1_custom,'String'));
alpha2= str2double(get(handles.alpha2_custom,'String'));
alphaRFSP= str2double(get(handles.alphaRFSP_custom,'String'));
alphacheck = alpha1+alpha2+alphaRFSP+alphaREENT;
set(handles.acheck_custom,'String',num2str(alphacheck,'%6.4e'));
%change format and dectivate rates button
if alphacheck<(1+1e-5)&&alphacheck>(1-1e-5)
    set(handles.acheck_custom,'BackgroundColor','g');
     set(handles.pushRATES,'Enable','on')
     set(handles.pushRATES,'BackgroundColor','g');   
else
    set(handles.acheck_custom,'BackgroundColor','r');
    set(handles.pushRATES,'Enable','off')
     lightGrey2   = [0.7 0.7 0.7];
     set(handles.pushRATES,'BackgroundColor',lightGrey2);   
    
end


% --- Executes during object creation, after setting all properties.
function alphaREENT_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphaREENT_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function alphaRFSP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphaRFSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushRATES.
function pushRATES_Callback(hObject, eventdata, handles)
global  vns vgm vpor vkns alphaTransgg alphaTransbg por ap ag eta
global  vkns_custom vns_custom vgm_custom vpor_custom alphaTransgg_custom
global alphaTransbg_custom por_custom ap_custom ag_custom  eta_custom
%% change buttom color to yellow during simulation
set(gcbo,'Backgroundcolor','y');
pause(1) % allows matlab to show button color change because function executes fast
%% calculate rate constants indepedently for trajectory-defined and user-defined
% cases depending if data exist
% get alpha checks from both cases
acheck_calc = str2double(get(handles.acheck_calc,'String'));
acheck_noflux = str2double(get(handles.acheck_custom,'String'));
%% for trajectory-defined
if acheck_calc==1
    vpor=get(handles.vpor_st,'String');vpor=str2double(vpor);
    %vns is calculated/determined in previous step (calculate efficiencies)
    
    %calculate velocity geometric mean
    vgm = (vpor*vns)^0.5;
    set(handles.statvgm,'String',num2str(vgm));
    
    % determine which value of characteristic velocity will be used for vns
    checkvns=get(handles.checkvns,'value');
    checkvgm=get(handles.checkvgm,'value');
    checkvpor=get(handles.checkvpor,'value');
    if checkvns
        vkns = vns;% keep vns value
    end
    if checkvgm
        vkns =vgm;
    end
    if checkvpor
        vkns = vpor;
    end
    
    % get parameters from trajectory simulation flux data
    ap= get(handles.ap_st,'String'); ap=str2double(ap);
    ag= get(handles.ag_st,'String'); ag=str2double(ag);
    por=get(handles.por_st,'String');por=str2double(por);
    alpha1 =get(handles.alpha1_static,'String');alpha1=str2double(alpha1);
    alpha2 =get(handles.alpha2_static,'String');alpha2=str2double(alpha2);
    alphaRFSP =get(handles.alphaRFSP_static,'String');alphaRFSP=str2double(alphaRFSP);
    alphaREENT =get(handles.alphaREENT_static,'String');alphaREENT=str2double(alphaREENT);
    alphaTransgg =get(handles.alphaTransgg,'String');alphaTransgg=str2double(alphaTransgg);
    alphaTransbg =get(handles.alphaTransbg,'String');alphaTransbg=str2double(alphaTransbg);
    eta=get(handles.etasim,'String');eta=str2double(eta);
    vns=get(handles.statvns,'String');vns=str2double(vns);
    %calculate rate constants
    [kf,kf2,kns,kf2star]=UpscaleRATES(ag,alpha1,alpha2,alphaRFSP,alphaREENT,alphaTransgg,alphaTransbg,eta,por,vns,vpor,vkns);
    % fill rate constants values in corresponding fields
    set(handles.kf_static,'String', num2str(kf));
    set(handles.kf2_static,'String', num2str(kf2));
    set(handles.kns_static,'String', num2str(kns));
    set(handles.kf2star_static,'String', num2str(kf2star));
    % enable load values buttont
    set(handles.pushbutton_getValCALC,'Enable','on')
    set(handles.pushbutton_getValCALC,'BackgroundColor','g')
end

%% for user-defined
if acheck_noflux==1
    % hObject    handle to pushRATES (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    eta_custom=get(handles.eta_custom,'String');eta_custom=str2double(eta_custom);
    % get main parameters
    
    vns_custom=get(handles.vns_custom,'String');vns_custom=str2double(vns_custom);
    vpor_custom=get(handles.vpor_custom,'String');vpor_custom=str2double(vpor_custom);
    
    %calculate vns geometric mean
    vgm_custom = (vpor_custom*vns_custom)^0.5;
    set(handles.statvgm_custom,'String',num2str(vgm_custom));
    
    % determine which value of characteristic velocity will be used for vns
    checkvns_custom=get(handles.checkvns_custom,'value');
    checkvgm_custom=get(handles.checkvgm_custom,'value');
    checkvpor_custom=get(handles.checkvpor_custom,'value');
    if checkvns_custom
        vkns_custom = vns_custom;
    end
    if checkvgm_custom
        vkns_custom =vgm_custom;
    end
    if checkvpor_custom
        vkns_custom = vpor_custom;
    end
    
    
    % get parameters in the absence of trajectory simulation flux data
    por_custom=get(handles.por_custom,'String');por_custom=str2double(por_custom);
    ap_custom= get(handles.ap_custom,'String'); ap_custom=str2double(ap_custom);
    ag_custom= get(handles.ag_custom,'String'); ag_custom=str2double(ag_custom);
    alpha1_custom =get(handles.alpha1_custom,'String');alpha1_custom=str2double(alpha1_custom);
    alpha2_custom =get(handles.alpha2_custom,'String');alpha2_custom=str2double(alpha2_custom);
    alphaRFSP_custom =get(handles.alphaRFSP_custom,'String');alphaRFSP_custom=str2double(alphaRFSP_custom);
    alphaREENT_custom =get(handles.alphaREENT_custom,'String');alphaREENT_custom=str2double(alphaREENT_custom);
    alphaTransgg_custom =get(handles.alphaTransgg_custom,'String');alphaTransgg_custom=str2double(alphaTransgg_custom);
    alphaTransbg_custom =get(handles.alphaTransbg_custom,'String');alphaTransbg_custom=str2double(alphaTransbg_custom);
    vns_custom=get(handles.vns_custom,'String');vns_custom=str2double(vns_custom);
    %calculate rate constants
    %     [kf,kf2,kns,kf2star]=UpscaleRATES(ag,alpha1,alpha2,alphaRFSP,alphaREENT,alphaTransgg,alphaTransbg,eta,por,vns_custom,vpor,vns);
    [kf,kf2,kns,kf2star]=UpscaleRATES(ag_custom,alpha1_custom,alpha2_custom,alphaRFSP_custom,alphaREENT_custom,alphaTransgg_custom,alphaTransbg_custom,eta_custom,por_custom,vns_custom,vpor_custom,vkns_custom);
    % fill rate constants values in corresponding fields
    set(handles.kf_custom,'String', num2str(kf));
    set(handles.kf2_custom,'String', num2str(kf2));
    set(handles.kns_custom,'String', num2str(kns));
    set(handles.kf2star_custom,'String', num2str(kf2star));
    
    % activate apropiate rate selection buttons
    if eta_custom>0.0
        set(handles.pushbutton_getValUSER,'Enable','on')
        set(handles.pushbutton_getValUSER,'BackgroundColor','g')
    end
end
%% change buttom color to green when calc is done
set(gcbo,'Backgroundcolor','g');

% --- Executes on button press in checkvns.
function checkvns_Callback(hObject, eventdata, handles)
% hObject    handle to checkvns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkvns
checkvns=get(handles.checkvns,'value');
if checkvns
    set(handles.checkvgm,'value',0)
    set(handles.checkvpor,'value',0)
    % disable set values and continuum simulation button
    lgray =[0.83 0.82 0.78];
    set(handles.pushbutton_getValCALC,'Enable','off')
    set(handles.pushbuttonPROF_BTC,'Enable','off')
    set(handles.pushbutton_getValCALC,'BackgroundColor',lgray)
    set(handles.pushbuttonPROF_BTC,'BackgroundColor',lgray)
    set(handles.ns_panel,'BackgroundColor',[0.94,0.94,0.94])
    % clear continuum panel checkboxes
    set(handles.checkboxIMP,'Value',0)
    set(handles.checkboxEXP,'Value',0)
    set(handles.checkboxIMP,'Enable','off')
    set(handles.checkboxEXP,'Enable','off')    
else
    set(handles.checkvgm,'value',1)
    % disable set values and continuum simulation button
    lgray =[0.83 0.82 0.78];
    set(handles.pushbutton_getValCALC,'Enable','off')
    set(handles.pushbuttonPROF_BTC,'Enable','off')
    set(handles.pushbutton_getValCALC,'BackgroundColor',lgray)
    set(handles.pushbuttonPROF_BTC,'BackgroundColor',lgray)
    set(handles.ns_panel,'BackgroundColor',[0.94,0.94,0.94])
    % clear continuum panel checkboxes
    set(handles.checkboxIMP,'Value',0)
    set(handles.checkboxEXP,'Value',0)
    set(handles.checkboxIMP,'Enable','off')
    set(handles.checkboxEXP,'Enable','off')    
end

% --- Executes on button press in checkvgm.
function checkvgm_Callback(hObject, eventdata, handles)
% hObject    handle to checkvgm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkvgm
checkvgm=get(handles.checkvgm,'value');
if checkvgm
    set(handles.checkvns,'value',0)
    set(handles.checkvpor,'value',0)
    % disable set values and continuum simulation button
    lgray =[0.83 0.82 0.78];
    set(handles.pushbutton_getValCALC,'Enable','off')
    set(handles.pushbuttonPROF_BTC,'Enable','off')
    set(handles.pushbutton_getValCALC,'BackgroundColor',lgray)
    set(handles.pushbuttonPROF_BTC,'BackgroundColor',lgray)
    set(handles.ns_panel,'BackgroundColor',[0.94,0.94,0.94])
    % clear continuum panel checkboxes
    set(handles.checkboxIMP,'Value',0)
    set(handles.checkboxEXP,'Value',0)
    set(handles.checkboxIMP,'Enable','off')
    set(handles.checkboxEXP,'Enable','off')    
else
    set(handles.checkvpor,'value',1)
    % disable set values and continuum simulation button
    lgray =[0.83 0.82 0.78];
    set(handles.pushbutton_getValCALC,'Enable','off')
    set(handles.pushbuttonPROF_BTC,'Enable','off')
    set(handles.pushbutton_getValCALC,'BackgroundColor',lgray)
    set(handles.pushbuttonPROF_BTC,'BackgroundColor',lgray)
    set(handles.ns_panel,'BackgroundColor',[0.94,0.94,0.94])
    % clear continuum panel checkboxes
    set(handles.checkboxIMP,'Value',0)
    set(handles.checkboxEXP,'Value',0)
    set(handles.checkboxIMP,'Enable','off')
    set(handles.checkboxEXP,'Enable','off')    
end

% --- Executes on button press in checkvpor.
function checkvpor_Callback(hObject, eventdata, handles)
% hObject    handle to checkvpor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkvpor
checkvpor=get(handles.checkvpor,'value');
if checkvpor
    set(handles.checkvns,'value',0)
    set(handles.checkvgm,'value',0)
    % disable set values and continuum simulation button
    lgray =[0.83 0.82 0.78];
    set(handles.pushbutton_getValCALC,'Enable','off')
    set(handles.pushbuttonPROF_BTC,'Enable','off')
    set(handles.pushbutton_getValCALC,'BackgroundColor',lgray)
    set(handles.pushbuttonPROF_BTC,'BackgroundColor',lgray)
    set(handles.ns_panel,'BackgroundColor',[0.94,0.94,0.94])
    % clear continuum panel checkboxes
    set(handles.checkboxIMP,'Value',0)
    set(handles.checkboxEXP,'Value',0)
    set(handles.checkboxIMP,'Enable','off')
    set(handles.checkboxEXP,'Enable','off')    
else
    set(handles.checkvgm,'value',1)
    % disable set values and continuum simulation button
    lgray =[0.83 0.82 0.78];
    set(handles.pushbutton_getValCALC,'Enable','off')
    set(handles.pushbuttonPROF_BTC,'Enable','off')
    set(handles.pushbutton_getValCALC,'BackgroundColor',lgray)
    set(handles.pushbuttonPROF_BTC,'BackgroundColor',lgray)
    set(handles.ns_panel,'BackgroundColor',[0.94,0.94,0.94])
    % clear continuum panel checkboxes
    set(handles.checkboxIMP,'Value',0)
    set(handles.checkboxEXP,'Value',0)
    set(handles.checkboxIMP,'Enable','off')
    set(handles.checkboxEXP,'Enable','off')    
end

% --- Executes during object creation, after setting all properties.
function statvns_CreateFcn(hObject, eventdata, handles)

% hObject    handle to statvns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes during object creation, after setting all properties.
function alpha1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function eta_custom_Callback(hObject, eventdata, handles)
global eta_custom
% hObject    handle to eta_custom (see GCBO
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eta_custom as text
%        str2double(get(hObject,'String')) returns contents of eta_custom as a double
eta_custom = str2double(get(hObject,'String' )); 
% set(handles.eta_custom,'String',eta_user); 
set(handles.eta_custom,'String',num2str(eta_custom,'%5.4e'));
if eta_custom >0.0&&eta_custom <1.0
    %$ accept value (green color)
    set(handles.eta_custom,'ForegroundColor','k');
else
    % reject values red color
    set(handles.eta_custom,'String','set valid eta');
    set(handles.eta_custom,'ForegroundColor','r');
    
     
end

function vpor_custom_Callback(hObject, eventdata, handles)
% hObject    handle to vpor_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vpor_custom as text
%        str2double(get(hObject,'String')) returns contents of vpor_custom as a double
global vpor_custom
vpor_custom = str2double(get(hObject,'String' )); 
% set(handles.eta_custom,'String',eta_user); 
set(handles.vpor_custom,'String',num2str(vpor_custom,'%5.4e'));
if vpor_custom>0.0
    %activate input fields
    set(handles.vns_custom,'Enable','on') ;
    %update static vpor_custom
    set(handles.statvpor_custom,'String',num2str(vpor_custom,'%5.4e'));
    % calculate v2
    v2est=(vpor_custom)*0.05; 
    set(handles.vns_custom,'String',num2str(v2est,'%5.4e'));
    set(handles.vns_custom,'ForegroundColor','r');
    set(handles.statvns_custom,'String',num2str(v2est));
    %calculate vns geometric mean
    vgm = (vpor_custom*v2est)^0.5;
    set(handles.statvgm_custom,'String',num2str(vgm));
    
else
    %deactivate input fields
    set(handles.vns_custom,'String','Edit Text')    
    set(handles.vns_custom,'Enable','off')     
    
    
end


% --- Executes during object creation, after setting all properties.
function vpor_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vpor_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function eta_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eta_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vns_custom_Callback(hObject, eventdata, handles)
global vns_noflux vgmnoflux
% hObject    handle to vns_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vns_custom as text
%        str2double(get(hObject,'String')) returns contents of vns_custom as a double
vns_noflux = str2double(get(hObject,'String' )); 
set(hObject,'String',vns_noflux); 
set(handles.vns_custom,'String',num2str(vns_noflux,'%5.4e'));


if vns_noflux >0.0
    set(handles.statvns_custom,'String',num2str(vns_noflux,'%5.4e'));
     vpor1=get(handles.vpor_custom,'String');
    %calculate vns geometric mean
    vgmnoflux = (str2double(vpor1)*vns_noflux)^0.5;
    set(handles.statvgm_custom,'String',num2str(vgmnoflux));    
     % disable impor and alphas calc buttons
%      set(handles.pushbuttomIMPORT,'Enable','off')
%      set(handles.pushALPHA,'Enable','off')
%      lightGrey2   = [0.7 0.7 0.7];
%      set(handles.pushbuttomIMPORT,'BackgroundColor',lightGrey2);  
%       lightGrey2   = [0.7 0.7 0.7];
%      set(handles.pushALPHA,'BackgroundColor',lightGrey2);     
else
     set(handles.pushbuttomIMPORT,'Enable','on')
     set(handles.pushbuttomIMPORT,'BackgroundColor','r');   
     set(handles.pushALPHA,'Enable','on')
     set(handles.pushALPHA,'BackgroundColor','r');   
     set(handles.vns_custom,'String','Edit Text');
     set(handles.vns_custom,'ForegroundColor','k');
     set(handles.statvns,'String','not calculated   yet');
     set(handles.statvgm_custom,'String','0.000e00');
     % reset user efificiencies
     set(handles.alpha1_custom,'String','Edit Text');
     set(handles.alpha2_custom,'String','Edit Text')
     set(handles.alphaRFSP_custom,'String','Edit Text')
     set(handles.alphaREENT_custom,'String','Edit Text')
end

% --- Executes during object creation, after setting all properties.
function vns_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vns_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function statvgm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to statvgm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function etasim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to etasim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function kf_static_CreateFcn(hObject, eventdata, handles)
% hObject    handle to kf_static (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function alphaTransbg_Callback(hObject, eventdata, handles)
% hObject    handle to alphaTransbg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alphaTransbg as text
%        str2double(get(hObject,'String')) returns contents of alphaTransbg as a double
alphaTransbg = str2double(get(hObject,'String' )); 
set(hObject,'String',alphaTransbg); 
set(handles.alphaTransbg,'String',alphaTransbg); 


% --- Executes during object creation, after setting all properties.
function alphaTransbg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphaTransbg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function u2sim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to u2sim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function dx_Callback(hObject, eventdata, handles)
% hObject    handle to dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dx as text
%        str2double(get(hObject,'String')) returns contents of dx as a double
dx = str2double(get(hObject,'String' )); 
set(hObject,'String',dx); 
set(handles.dx,'String',dx); 

% --- Executes during object creation, after setting all properties.
function dx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutom_IMP_PARAM.
function pushbutom_IMP_PARAM_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutom_IMP_PARAM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function statvpor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to statvpor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function ag_custom_Callback(hObject, eventdata, handles)
% hObject    handle to ag_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ag_custom as text
%        str2double(get(hObject,'String')) returns contents of ag_custom as a double
ag_noflux = str2double(get(hObject,'String' )); 
set(handles.ag_custom,'String',num2str(ag_noflux,'%5.4e'));

% --- Executes during object creation, after setting all properties.
function ag_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ag_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ap_custom_Callback(hObject, eventdata, handles)
% hObject    handle to ap_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ap_custom as text
%        str2double(get(hObject,'String')) returns contents of ap_custom as a doubleset(hObject,'String',eta_user); 
ap_noflux = str2double(get(hObject,'String' )); 
set(handles.ap_custom,'String',num2str(ap_noflux,'%5.4e'));



% --- Executes during object creation, after setting all properties.
function ap_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ap_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function por_custom_Callback(hObject, eventdata, handles)
% hObject    handle to por_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of por_custom as text
%        str2double(get(hObject,'String')) returns contents of por_custom as a double
por_noflux = str2double(get(hObject,'String' )); 
set(handles.por_custom,'String',num2str(por_noflux,'%5.4e'));

% --- Executes during object creation, after setting all properties.
function por_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to por_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function asp_st_CreateFcn(hObject, eventdata, handles)
% hObject    handle to asp_st (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function alpha1_static_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alpha1_static (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function acheck_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to acheck_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkvns_custom.
function checkvns_custom_Callback(hObject, eventdata, handles)
% hObject    handle to checkvns_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkvns_custom
checkvns_custom=get(handles.checkvns_custom,'value');
if checkvns_custom
    set(handles.checkvgm_custom,'value',0)
    set(handles.checkvpor_custom,'value',0)
    % disable set values and continuum simulation button
    lgray =[0.83 0.82 0.78];
    set(handles.pushbutton_getValUSER,'Enable','off')
    set(handles.pushbuttonPROF_BTC,'Enable','off')
    set(handles.pushbutton_getValUSER,'BackgroundColor',lgray)
    set(handles.pushbuttonPROF_BTC,'BackgroundColor',lgray)
    set(handles.ns_panel,'BackgroundColor',[0.94,0.94,0.94])
    % clear continuum panel checkboxes
    set(handles.checkboxIMP,'Value',0)
    set(handles.checkboxEXP,'Value',0)
    set(handles.checkboxIMP,'Enable','off')
    set(handles.checkboxEXP,'Enable','off')
else
    set(handles.checkvgm_custom,'value',1)
    % disable set values and continuum simulation button
    lgray =[0.83 0.82 0.78];
    set(handles.pushbutton_getValUSER,'Enable','off')
    set(handles.pushbuttonPROF_BTC,'Enable','off')
    set(handles.pushbutton_getValUSER,'BackgroundColor',lgray)
    set(handles.pushbuttonPROF_BTC,'BackgroundColor',lgray)
    set(handles.ns_panel,'BackgroundColor',[0.94,0.94,0.94]) 
    % clear continuum panel checkboxes
    set(handles.checkboxIMP,'Value',0)
    set(handles.checkboxEXP,'Value',0)
    set(handles.checkboxIMP,'Enable','off')
    set(handles.checkboxEXP,'Enable','off')
end


% --- Executes on button press in checkvgm_custom.
function checkvgm_custom_Callback(hObject, eventdata, handles)
% hObject    handle to checkvgm_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkvgm_custom
checkvgm_custom=get(handles.checkvgm_custom,'value');
if checkvgm_custom
    set(handles.checkvns_custom,'value',0)
    set(handles.checkvpor_custom,'value',0)
        % disable set values and continuum simulation button
    lgray =[0.83 0.82 0.78];
    set(handles.pushbutton_getValUSER,'Enable','off')
    set(handles.pushbuttonPROF_BTC,'Enable','off')
    set(handles.pushbutton_getValUSER,'BackgroundColor',lgray)
    set(handles.pushbuttonPROF_BTC,'BackgroundColor',lgray)
    set(handles.ns_panel,'BackgroundColor',[0.94,0.94,0.94])
    % clear continuum panel checkboxes
    set(handles.checkboxIMP,'Value',0)
    set(handles.checkboxEXP,'Value',0)
    set(handles.checkboxIMP,'Enable','off')
    set(handles.checkboxEXP,'Enable','off')    
else
    set(handles.checkvns_custom,'value',1)
        % disable set values and continuum simulation button
    lgray =[0.83 0.82 0.78];
    set(handles.pushbutton_getValUSER,'Enable','off')
    set(handles.pushbuttonPROF_BTC,'Enable','off')
    set(handles.pushbutton_getValUSER,'BackgroundColor',lgray)
    set(handles.pushbuttonPROF_BTC,'BackgroundColor',lgray)
    set(handles.ns_panel,'BackgroundColor',[0.94,0.94,0.94])
    % clear continuum panel checkboxes
    set(handles.checkboxIMP,'Value',0)
    set(handles.checkboxEXP,'Value',0)
    set(handles.checkboxIMP,'Enable','off')
    set(handles.checkboxEXP,'Enable','off')    
end

% --- Executes on button press in checkvpor_custom.
function checkvpor_custom_Callback(hObject, eventdata, handles)
% hObject    handle to checkvpor_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkvpor_custom
checkvpor_custom=get(handles.checkvpor_custom,'value');
if checkvpor_custom
    set(handles.checkvns_custom,'value',0)
    set(handles.checkvgm_custom,'value',0)
        % disable set values and continuum simulation button
    lgray =[0.83 0.82 0.78];
    set(handles.pushbutton_getValUSER,'Enable','off')
    set(handles.pushbuttonPROF_BTC,'Enable','off')
    set(handles.pushbutton_getValUSER,'BackgroundColor',lgray)
    set(handles.pushbuttonPROF_BTC,'BackgroundColor',lgray)
    set(handles.ns_panel,'BackgroundColor',[0.94,0.94,0.94])
    % clear continuum panel checkboxes
    set(handles.checkboxIMP,'Value',0)
    set(handles.checkboxEXP,'Value',0)
    set(handles.checkboxIMP,'Enable','off')
    set(handles.checkboxEXP,'Enable','off')    
else
    set(handles.checkvgm_custom,'value',1)
        % disable set values and continuum simulation button
    lgray =[0.83 0.82 0.78];
    set(handles.pushbutton_getValUSER,'Enable','off')
    set(handles.pushbuttonPROF_BTC,'Enable','off')
    set(handles.pushbutton_getValUSER,'BackgroundColor',lgray)
    set(handles.pushbuttonPROF_BTC,'BackgroundColor',lgray)
    set(handles.ns_panel,'BackgroundColor',[0.94,0.94,0.94])
    % clear continuum panel checkboxes
    set(handles.checkboxIMP,'Value',0)
    set(handles.checkboxEXP,'Value',0)
    set(handles.checkboxIMP,'Enable','off')
    set(handles.checkboxEXP,'Enable','off')    
end


function alphaTransgg_custom_Callback(hObject, eventdata, handles)
% hObject    handle to alphaTransgg_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alphaTransgg_custom as text
%        str2double(get(hObject,'String')) returns contents of alphaTransgg_custom as a double


% --- Executes during object creation, after setting all properties.
function alphaTransgg_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphaTransgg_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alphaTransbg_custom_Callback(hObject, eventdata, handles)
% hObject    handle to alphaTransbg_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alphaTransbg_custom as text
%        str2double(get(hObject,'String')) returns contents of alphaTransbg_custom as a double


% --- Executes during object creation, after setting all properties.
function alphaTransbg_custom_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphaTransbg_custom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BTC_points_Callback(hObject, eventdata, handles)
% hObject    handle to BTC_points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global BTC_points
% Hints: get(hObject,'String') returns contents of BTC_points as text
%        str2double(get(hObject,'String')) returns contents of BTC_points as a double
BTC_points= get(handles.BTC_points,'String');
BTC_points = str2double(BTC_points);
if BTC_points<=10
    BTC_points =10;
    set(handles.BTC_points,'String','10');
end
% --- Executes during object creation, after setting all properties.
function BTC_points_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BTC_points (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
