function traj_happel()
%     PROGRAM TO SIMULATE PARTICLE TRAJECTORIES IN HAPPEL CELL GEOMETRY
%% CLEAR VARIABLES AND WINDOWS
% fighandles will close any figure windows that is not the gui
clc;
figHandles = findobj('type', 'figure', '-not', 'name', 'Happel_GUI');
close(figHandles);
%%  start sim clock
tic;
% start progress bar
pbar = waitbar(0,'Simulating colloid trajectories..','Position', [50 500 290 50]);
%% declare global variables ( have included physical constants and
% any parameter read from input file
global NPART ATTMODE CLUSTER VJET VSUP RLIM POROSITY AG TTIME...
    AP RHOP RHOW VISC ER T IS ZI ZETAPST ZETACST ZETAHET HETMODE RHET0...
    RHET1 RHET2 SCOV ZETAHETP HETMODEP RHETP0 RHETP1 SCOVP...
    A132 LAMBDAVDW VDWMODE A11 AC1C1 A22 AC2C2 A33...
    T1 T2 GAMMA0AB LAMBDAAB GAMMA0STE LAMBDASTE B RMODE ASP ASP2...
    KINT W132 BETA DIFFSCALE GRAVFACT MULTB MULTNS MULTC DFACTNS DFACTC...
    NOUT PRINTMAX NPARTPERT cbPZ cbMZ cbPX cbMX simplotCHECK detplotCHECK finput workdir

% from perturbation loaded particles
global  NPARTatt NPARTrem ATTACHKP XOUTP YOUTP ZOUTP ROUTP HOUTP JP
global simplot detplot saveSIMPLOT
%% initialize etas and eta counters
global eta2 eta4 eta5 eta6 RB
ceta2 = 0; ceta4 = 0; ceta5 = 0; ceta6=0;
%%  READ INPUT FILE
% global variables must match the ones read via FUNCread_input
% define input file name
inputfile = finput;
% uses read_input function
DATAIN = HFUNCread_input(inputfile);
%% SET MAXIMUM NUMBER OF VALUES PER VECTOR
MAXVAL =int32(50000);                               %MAXIMUM NUMBER OF VALUES IN ARRAYS
%% DEFINE OTHER VARIABLES (DOUBLE)
X = double(0);
[Y,Z,H,R,XO,YO,ZO,HO,Xm0,Ym0,Zm0,JX,JY]=deal(X);  %SPATIAL COORDINATES
[XINIT,YINIT,ZINIT,HINIT,RINJ,RJET,ZMAX] =deal(X);      %INITIAL COORDINATES
[ETX,ETY,ETZ,ENX,ENY,ENZ] =deal(X);                     %TANGENTIAL AND NORMAL UNIT VECTORS
[FCOLL,FVDW,FEDL,FAB,FSTE,FBORN]=deal(X);               %FORCES
[MP,NIO,KAPPA,ZETAC,ERE0]=deal(X);                      %MASS AND EDL PARAMETERS
[RZOI,RZOIBULK,RZOICONT]=deal(X);                       %ZONE OF INFLUENCE
[FDRGX,FDRGY,FDRGZ,FDRGR]=deal(X);                      %DRAG FORCES
[FDIFX,FDIFY,FDIFZ]=deal(X);                            %DifFUSION FORCES
[FDifT,FDifTX,FDifTY,FDifTZ]=deal(X);                   %DifFUSION TANGENTIAL FORCES
[FDifN,FDifNX,FDifNY,FDifNZ]=deal(X);                   %DifFUSION NORMAL FORCES
[FLifT,FLifTX,FLifTY,FLifTZ]=deal(X);                   %LifT FORCE
[FG,FGN,FGNX,FGNY,FGNZ,FGTX,FGTY,FGTZ]=deal(X);         %GRAVITY FORCE
[dTMRT,dT,TBULK,TNEAR,TFRIC]=deal(X);                   %TIME
[TINJ,PTIMEF,ETIME]=deal(X);                            %SIMULATION TIME
[VxH1,VyH1,VzH1,VX,VY,VZ,VT,VN]=deal(X);                %FLUID VELOCITIES
[VTX,VTY,VTZ,VNX,VNY,VNZ]=deal(X);                      %FLUID VELOCITIES TANGENTIAL AND NORMAL
[UX,UXO,UY,UYO,UZ,UZO,UT,UTO,UN,OMEGA]=deal(X);         %COLLOID VELOCITIES
[UTX,UTXO,UTY,UTYO,UTZ,UTZO]=deal(X);                   %COLLOID TANGENTIAL VELOCITIES
[UNX,UNXO,UNY,UNYOUNZ,UNZO]=deal(X);                    %COLLOID NORMAL VELOCITIES
[PP,WW,K1,K2,K3,K4,RB,SHELL]=deal(X);                   %HAPPEL POROSITY AND FLOW FIELD PARAMETERS
% [VX,VY,VZ,VR,UX,UXO,UY,UYO,UR,UZ,UZO,OMEGA]=deal(X);  %VELOCITIES JET
% [c2R,p0R,q1R,q2R,q3R,q4R]=deal(X);                    %CONTINUUM JET FLOW FIELD PARAMETERS
% [c2Z,p0Z,q1Z,q2Z,q3Z,q4Z]=deal(X);                    %CONTINUUM JET FLOW FIELD PARAMETERS
[VM,HBAR,M3,M4,M5]=deal(X);                             %HYDRODYNAMIC RETARDATION
[A1,B1,C1,D1,E1,A2,B2,C2,D2,E2,A3,B3,C3,D3,E3]=deal(X); %HYDRODYNAMIC RETARDATION
[A4,B4,C4,D4,E4,FUN1,FUN2,FUN3,FUN4]=deal(X);           %HYDRODYNAMIC RETARDATION
[FCOLLO,HFRIC,HMIN,FMIN]=deal(X);                       %CONTACT SEPARATION DISTANCE VARIABLES
[ACONT,CORF,FCOLFRIC,ASTE]=deal(X);                     %DEFORMATION VARIABLES
[XREF1,YREF1,ZREF1,TREF1,DREF1,DIND1]=deal(X);          %SLOW MOTION IN NEAR SURFACE
[XREF2,YREF2,ZREF2,TREF2,DREF2,DIND2,DIND3]=deal(X);    %SLOW MOTION IN CONTACT
[XP,YP,ZP,AFRACT,AF]=deal(X);                           %HETERODOMAIN PARAMETERS
[FEDLCST,FEDLHET]=deal(X);                              %HETERODOMAIN EDL PARAMETERS
[MOB]=deal(X);                                          %DETACHMENT PARAMETER
[EVDW,EEDL]=deal(X);                                    %DLVO ENERGY
[PI,G,E0,ECHG,KB,H0,SIGMAC,DELTASEP]=deal(X);           %CONSTANTS
[ROXY,RTSUM,RSUM,TSQSUM,TSUM,HSUM,NSVEL,HAVE]=deal(X);  %AVERAGE NS VELOCITY AND SEP DISTANCE
[RARC,RARC1,THETA,THETAINIT,PHI,PHIINIT]=deal(X);       %ARCLENGTH CALCULATION
% DEFINE OTHER VARIABLES (char)
DUMMY='dummy';
FILESINGLE='filename';
% DEFINE OTHER VARIABLES (integers)
I = int16(0);
[J,K,N,L,IO]=deal(I);                                   %LOOP PARAMETERS
[PCOUNT,OUTCOUNT,OUTMAX,OUTFLAG,NPRINT]=deal(I);        %OUTPUT FILE PARAMETERS
[ATTACHK,HFLAG,NSVISIT,FRICVISIT]=deal(I);              %PARTICLE INDICATORS
[IREF1,IREF2,HETTYPE,NPARTLOOP]=deal(I);                %MISCELLANEOUS PARAMETERS
[nrand,RMULT]=deal(I);                                  %RANDOM NUMBER PARAMETERS
% %     MC VARIABLES DECLARATION, THESE ARE NEEDED FOR THE CLUSTER VERSION. DON'T DELETE%
%       character*40 argv
%       character*40 filenam
%       integer ipart,ilen
%       character*6 chri
%       character*10 date, time, zone
%       integer iarray(8)

%%  DEFINE PHYSICAL CONSTANTS
PI=3.14159265359;         %PIE (CHERRY,STRAWBERRY RHUBARB, ETC.)
G=9.80665;                %ACCELERATION DUE TO GRAVITY (M/S^2)
E0=8.85418781762E-12;     %VACUUM PERMITTIVITY (C^2/N M^2)
ECHG=1.602176621E-19;     %ELEMENTARY CHARGE (C)
KB=1.3806485E-23;         %BOLTZMANN CONSTANT (J/K)
%
%%  DEFINE HARDWIRED VALUES (not read from INPUT FILE)
H0=0.158E-9;              %MINIMUM SEPARATION DISTANCE (M)
SIGMAC=5.0E-10;           %BORN COLLISION DIAMTER (M)
DELTASEP=5.0E-10;         %BUFFER OUTWARD FROM H0 (M)
OUTMAX=PRINTMAX;            %LARGEST OUTPUT ARRAY LENGTH
% The max asperity height defines the slip length (B).
% In torque balances, the max asperity height was important only for detachment
% wherein it increases the arresting torque lever arm.
% Approximate collector max surface roughness as B/2. Need to update to
% allow either or both surfaces to contribute coarse roughness.
ASP2 = B/2;
%CALCULATE ADHESIVE TORQUE LEVER ARM
RLEV = AP*ASP2/(AP+ASP2);
%% define gravity direction
if cbMZ==1 
    EGX =0.0; 
    EGY =0.0;  
    EGZ =-1.0; 
end
if cbPZ==1
    EGX =0.0; 
    EGY =0.0;  
    EGZ =+1.0;     
end
if cbMX==1
    EGX =-1.0; 
    EGY =0.0;  
    EGZ =0.0;     
end
if cbPX==1
    EGX =+1.0; 
    EGY =0.0;  
    EGZ =0.0;     
end
%% CHECK superficial velocity sign (read as VJET from main GUI code)
% model is set for -Z flow direction
if VJET>0.0
    VSUP = VJET;
else
    VSUP = -VJET;
end
%
%%    INITIALIZE RANDOM NUMBER GENERATOR SEED (for rand and randn) injection and diffusion calcs
%     in MATLAB if a common seed is needed then use rng(seed)e.g. rng(7654321),
%     this will make that simulation results will bedentical for a given number
%     of particles and conditions (maybe useful for testing)
%      In contrast, if a non common seed  is requiered, make seed dependent
%       of machine clock different results per execution ( for parallel
%       version this seed may need to be initialized inside particle loop and
%      include particle number+clock in seed)
%
% initializae seed based on clock
rng('shuffle');
%
%% surface colors based on charge
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
%% display trajectory info during runtime
% set showout to 1 to display during simulation info matchin output interval
% set showout to 0 (default) to avoid display and speed up code
showout = 0;
%%    SET CENTER OF COLLECTOR
Xm0 = 0.0;
Ym0 = 0.0;
Zm0 = 0.0;
%     SET NULL HETTYPE 0=NONE, 1=LARGE, 2=SMALL, 3=BOTH
HETTYPE = 0;
%     SET NULL HETFLAG, 0=NOT OVER HETERODOMAIN, 1=PASSED OVER HETERODOMAIN
HETFLAG = 0;
%     CALCULATE MASS OF PARTICLE
MP = (4.0/3.0)*(PI)*(AP^3)*RHOP;
%	CALCULATE MOMEMTUM RELAXATION TIME
dTMRT = MP/(6.0*PI*VISC*AP);
%     SET TIME STEP
dT = MULTB*dTMRT;
%     SET VIRTUAL MASS COEFFICIENT
VM = (2.0/3.0)*PI*(AP^3)*RHOW;
%     SET TORQUE AND DRAG FORCE COEFFICIENT
M3 = 6.0*PI*VISC*AP;
%     CALCULATE Happel sphere-in-cell model analytical streamline function parameters (from Rajagopalan & Tien, 1976)
PP = (1-POROSITY)^(1.0/3.0);
WW = 2.0-3.0*PP+3.0*PP^5.0-2.0*PP^6.0;
K1 = 1/WW;
K2 = -(3.0+2.0*PP^5.0)/WW;
K3 = (2.0+3.0*PP^5.0)/WW;
K4 = -PP^5.0/WW;
%     FLUID SHELL RADIUS
RB = AG/((1-POROSITY)^(1.0/3.0));
%     FLUID SHELL THICKNESS
SHELL = RB-AG;
%     CALCULATE KAPPA NOTE: IS FOR 1:1 ELECTROLYTE ONLY
ERE0 = ER*E0;            %ABSOLUTE PERMITTIVITY
NIO = IS*2*6.02214086E23;
KAPPA = ((ECHG^2.0)*NIO*(ZI^2.0)/(ERE0*KB*T))^0.5;
%   CALCULATE RZOIBULK: RADIUS OF ZONE OF INFLUENCE WITHOUT DEFORMATION
RZOIBULK = 2.0*((1/KAPPA)*AP)^0.5;
%   CALCULATE ACONTMAX: MAXIMUM RADIUS OF CONTACT USING JKR (NEGATIVE SIGN ADDED TO MAKE CONTACT AREA POSITIVE FOR ATTRACTIVE WORK OF ADHESION, W132<0)
if (W132>0.0)
    W132 = 0.0;
end
ACONTMAX = (-6.0*PI*W132*(AP^2.0)/KINT)^(1.0/3.0);
%   CALCULATE MAXIMUM VERTICAL DEFORMATION OF THE COLLOID
DELTAMAX = AP - (AP^2-ACONTMAX^2)^0.5;
%   CALCULATE STERIC INTERACTION RADIUS
ASTE=(ACONTMAX^2+2*LAMBDASTE*(AP+(AP^2-ACONTMAX^2)^0.5))^0.5;
%   SET A132=0 FOR LAYERED SYTEMS TO SHOW IN OUTPUT THAT A132 IS NOT USED
if (VDWMODE~=1)
    A132 = 0.0;
end

%     CALCULATE HFRIC - SEPARATION AT WHICH WE CONSIDER CONTACT TO OCCUR AND ZERO SLIP. DEFORMATION STARTS TO OCCUR FOR SEPARATION DISTANCES SMALLER
%                       THAN THIS VALUE. WE DEFINE THIS DISTANCE TO BE THAT WHERE EACH OF THE CONTACT FORCES HAVE REACHED 0.01% OF THEIR VALUE AT
%                       VACUUM MINIMUM SEPARATION OF 0.158 NM
H = H0;
ASP0 = 0.0;
NASP0 = 0.0;
RMODE0 = 0;
FBORN=HFORCEBORN (A132,SIGMAC,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE);
FSTE=HFORCESTE (PI,GAMMA0STE,LAMBDASTE,ASTE,H);
FAB= HFORCEAB (PI,AG,AP,ASP0,NASP0,RMODE0,LAMBDAAB,GAMMA0AB,H,H0);
FBORNFRIC = 0.0001*FBORN;
FSTEFRIC = 0.0001*FSTE;
FABFRIC = 0.0001*FAB;
while ((FBORN>FBORNFRIC)||(FSTE>FSTEFRIC)||(abs(FAB)>abs(FABFRIC)))
    H = H + 1.0E-12;
    FBORN=HFORCEBORN (A132,SIGMAC,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE);
    FSTE=HFORCESTE (PI,GAMMA0STE,LAMBDASTE,ASTE,H);
    FAB= HFORCEAB (PI,AG,AP,ASP0,NASP0,RMODE0,LAMBDAAB,GAMMA0AB,H,H0);
    
    HFRIC = H;
end

%     CALCULATE HMIN - SEPARATION DISTANCE AT WHICH WE CONSIDER MAXIMUM DEFORMATION TO BE ACHIEVED. SEPARATION DISTANCES SMALLER THAN THIS VALUE CONTINUE
%                      TO HAVE MAXIMUM DEFORMATION. WE DEFINE THIS VALUE TO BE THE LOCATION OF THE ENERGY MINIMUM (CALCULATED FOR SMOOTH SURFACES) FOR ALL
%                      ATTRACTIVE INTERACTIONS WITH BORN AS THE BACKSTOP
% if VDW EDL and AB interactions are all repulsive hardwire HMIN
% otherwise find the minimum
if (A132<0.0&&GAMMA0AB>0.0)&&(ZETACST*ZETAPST>0.0)
    HMIN = H0;
else
    H = H0;
    FCOLL = 1.0;
    while (FCOLL>0.0)
        HMIN = H;
        H = H + 1.0E-12;
        FVDW=HFORCEVDW (A132,AG,AP,ASP0,NASP0,RMODE0,H,LAMBDAVDW,A11,...
            A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE);
        FEDL =HFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETACST,ZETAPST,AG,AP,ASP,NASP0,RMODE,H,PI);
        FAB= HFORCEAB (PI,AG,AP,ASP0,NASP0,RMODE0,LAMBDAAB,GAMMA0AB,H,H0);
        FBORN=HFORCEBORN (A132,SIGMAC,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE);
        if (FVDW>0.0)
            FVDW = 0.0;
        end
        if (FEDL>0.0)
            FEDL = 0.0;
        end
        if (FAB>0.0)
            FAB = 0.0;
        end
        FCOLL = FVDW + FEDL + FAB + FBORN;
    end
end


%%	SET COEFFICIENTS FOR UNIVERSAL HYDRODYNAMIC FUNCTIONS
A1 = 0.9267;             %FROM MASLIYAH & BHATTACHARJEE 2005
B1 = -0.3990;
C1 = 0.1487;
D1 = -0.601;
E1 = 1.202;
%
A2 = 0.5695;             %FROM MASLIYAH & BHATTACHARJEE 2005
B2 = 1.355;
C2 = 1.36;
D2 = 0.875;
E2 = 0.525;
%
A3 = 0.2803;             %FIT FROM GCB 1967 (SEE SPREADSHEET)
B3 = -0.1430;
C3 = 1.472;
D3 = -0.6772;
E3 = 2.765;
%
A4 = 0.2653;            %FIT FROM GCB 1967 (SEE SPREADSHEET)
B4 = -0.2942;
C4 = 0.9041;
D4 = -0.6054;
E4 = 1.291;

%     TRAJECTORY LOOP
%%  SET NUMBER OF PARTICLES depending on parallel or single computer version
% hardwire cluster and pert to 0 for initial MATLAB ported code
CLUSTER = 0;
if (CLUSTER==1)
    NPARTLOOP = 1;
    %         MC read number of particles and ID of particle as a program argument for the cluster version
    %           call getarg(1,argv)
    %           read(argv,*)npart
    %           call getarg(2,argv)
    %           read(argv,*)ipart
else
    %check for colloid number loaded for perturbation
    if (ATTMODE==-1)
        if NPART>NPARTPERT
            m=warndlg('Colloids simulated will exceed flux files population, resetting value','Warning');
            waitfor(m);
            NPART = NPARTPERT;
        end
    end
    NPARTLOOP = NPART;
end
%% format definitions for all flux, traj files and run-time message here
%common headers for flux and trajectory files
format101 =['NPART= %d VSUP(ms-1)= %15.8E RLIM(m)= %15.8E '...
    'POROSITY= %15.8E AG(m)= %15.8E RB(m)= %15.8E '...
    'TTIME(s)= %15.8E ATTMODE= %d SLIP(m)= %15.8E '...
    'RMODE= %d ASP(m)= %15.8E ASP2(m)= %15.8E \r\n'];

format102 =['AP(m)= %15.8E IS(mol/m3)= %15.8E ZI= %15.8E '...
    'ZETAPST(V)= %15.8E ZETACST(V)= %15.8E RHOP(kg/m3)= %15.8E '...
    'RHOW(kg/m3)= %15.8E VISC(kg/m/s)= %15.8E ER= %15.8E '...
    'T(K)= %15.8E DIFFSCALE= %15.8E GRAVFACT= %15.8E cbPZ= %d  cbMZ= %d  cbPX= %d  cbMX= %d  simplotCHECK= %d detplotCHECK= %d \r\n'];


format103 =['SCOV= %15.8E ZETAHET(V)= %15.8E HETMODE= %d '...
    'RHET0(m)= %15.8E RHET1(m)= %15.8E RHET2(m)= %15.8E '...
    'SCOVP= %15.8E ZETAHETP(V) %15.8E HETMODEP %15.8E RHETP0(m) %15.8E RHETP1(m) %15.8E '...
    'RZOIBULK(m)= %15.8E dTMRT(s)= %15.8E MULTB= %15.8E '...
    'MULTNS= %15.8E MULTC= %15.8E VDWMODE= %15.8E\r\n'];

format104 =['A132(J)= %15.8E LAMBDAVDW(m)= %15.8E GAMMA0AB(J/m2)= %15.8E '...
    'LAMBDAAB(m)= %15.8E GAMMA0STE(J/m2)=  %15.8E LAMBDASTE(m)=  %15.8E KINT(N/m2)=  %15.8E '...
    'W132(J/m2)=  %15.8E ACONTMAX(m)=  %15.8E BETA=  %15.8E '...
    'DFACTNS=  %15.8E DFACTC= %15.8E A11(J)= %15.8E A22(J)= %15.8E '...
    'A33(J)= %15.8E AC1C1(J)= %15.8E AC2C2(J)= %15.8E '...
    'T1= %15.8E T2= %15.8E\r\n'];



% extra headers for trajectory files only

format105 =('ATTACHK= %d\r\n');

format106 =['I                 X                Y               Z           '...
    'R                 H                ETIME           PIMEF       '...
    'FCOLL             FVDW             FEDL            FAB         '...
    'FSTE              FBORN            UT              UN          '...
    'VT                VN               FDRGT           FDRGN       '...
    'FDIFX             FDIFY            FDIFZ           FGT         '...
    'FGN               FLIFT            ACONT           RZOI        '...
    'AFRACT\r\n'];

format107 = ['%d %15.8E %15.8E %15.8E  '...
    '%11.8E %11.8E %11.8E %11.8E '...
    '%11.8E %11.8E %11.8E %11.8E '...
    '%11.8E %11.8E %11.8E %11.8E '...
    '%11.8E %11.8E %11.8E %11.8E '...
    '%11.8E %11.8E %11.8E %11.8E '...
    '%11.8E %11.8E %11.8E %11.8E '...
    '%11.8E\r\n'];

% extra headers for flux files only
format110 =['ATTACHK1=EXIT,'...
    'ATTACHK2=ATTACHED-BY-PERFECT-SINK-OR-TORQUE,'...
    'ATTACHK3=REMAINING-UNRESOLVED-WHEN-SIMULATION-ENDS,'...
    'ATTACHK4=TORQUE-WITH-SLOW-MOTION,'...
    'ATTACHK5=IN-NEAR-SURFACE-WITH-SLOW-MOTION,'...
    'ATTACHK6=CRASHED \r\n'];

format206 =['PARTICLE               ATTACHK             XINIT(m)            '...
    'YINIT(m)               RINJ(m)             ZINIT(m)            '...
    'RINIT(m)               HINIT(m)            XOUT(m)             '...
    'YOUT(m)                ZOUT(m)             ROUT(m)             '...
    'HOUT(m)                ETIME(s)            PTIMEIN(s)          '...
    'PTIMEOUT(s)            TBULK(s)            TNEAR(s)            '...
    'TFRIC(s)               NSVISIT             FRICVISIT           '...
    'ACONT(m)               RZOI(m)             AFRACT              '...
    'HETTYPE                HETFLAG             NSVEL(m/s)          '...
    'HAVE(m)                XINNS(m)            YINNS(m)            '...
    'ZINNS(m)\r\n'];

format207 =['%d %15.8E %15.8E '...
    '%15.8E %15.8E %15.8E '...
    '%15.8E %15.8E %15.8E '...
    '%15.8E %15.8E %15.8E '...
    '%15.8E %15.8E %15.8E '...
    '%15.8E %15.8E %15.8E '...
    '%15.8E %15d %15d '...
    '%15.8E %15.8E %15.8E '...
    '%15.8E %15.8E %15.8E '...
    '%15.8E %15.8E %15.8E '...
    '%15.8E \r\n'];




% runtime message display format for loading mode
format6001 = 'J= %d I= %d Z= %8.4E  H= %8.4E  AFRACT= %8.4E';
format6002 = 'J= %d I= %d Z= %8.4E  H= %8.4E  AFRACT= %8.4E ATTACHK = %d';
% runtime message display format for perturbation mode
format7001 = 'J= %d oldJ= %d I= %d Z= %8.4E  H= %8.4E  AFRACT= %8.4E';
format7002 = 'J= %d oldJ= %d I= %d Z= %8.4E  H= %8.4E  AFRACT= %8.4E ATTACHK = %d oldATTACHK = %d';
%% flux files and trajectory files names defined here
fluxfname = {'FLUXEX_HAP.OUT','FLUXATT_HAP.OUT','FLUXREM_HAP.OUT'};
trajfname = {'HAP_TRAJEX.','HAP_TRAJATT.','HAP_TRAJREM.'};
%original naming, kept for cluster version if needed
% trajfname = {'HAPHETTRAJEX.','HAPHETTRAJATT.','HAPHETTRAJREM.'};
%% open flux files for single computer version
if(CLUSTER==0)
    %        code %below is to open diretory, this is done in the GUI shell
    %        instead
    %        GUI
    % set working directory
    %         if ~isdeployed
    %             % MATLAB environment
    %             workdir = strrep(mfilename('fullpath'),'\traj_happel','\');
    %             mkdir(workdir,'outputHAPPEL');
    %             workdir = strrep(mfilename('fullpath'),'\traj_happel','\outputHAPPEL\');
    % %             workdir = strrep(mfilename('fullpath'),'\traj_jet','\');
    %         else
    %             %deployed application
    %             workdir=pwd;
    %             mkdir(workdir,'outputHAPPEL');
    %             workdir=strcat(workdir,'\outputHAPPEL\');
    %         end
    % set fluxfilenames
    fileFLUXEX = strcat(workdir,char(fluxfname(1)));
    FLUXEX = fopen(fileFLUXEX,'w');
    fileFLUXATT = strcat(workdir,char(fluxfname(2)));
    FLUXATT = fopen(fileFLUXATT,'w');
    fileFLUXREM = strcat(workdir,char(fluxfname(3)));
    FLUXREM = fopen(fileFLUXREM,'w');
    % write headers -FLUXEX
    fprintf(FLUXEX,format101,NPART,VSUP,RLIM,POROSITY,AG,RB,TTIME,ATTMODE,B,RMODE,ASP,ASP2);
    fprintf(FLUXEX,format102,AP,IS,ZI,ZETAPST,ZETACST,RHOP,RHOW,VISC,ER,T,DIFFSCALE,GRAVFACT,cbPZ,cbMZ,cbPX, cbMX,simplotCHECK,detplotCHECK);
    fprintf(FLUXEX,format103,SCOV,ZETAHET,HETMODE,RHET0,RHET1,RHET2,SCOVP,ZETAHETP,HETMODEP,RHETP0,RHETP1,RZOIBULK,dTMRT,MULTB,MULTNS,MULTC,VDWMODE);
    fprintf(FLUXEX,format104,A132,LAMBDAVDW,GAMMA0AB,LAMBDAAB,GAMMA0STE,LAMBDASTE,KINT,W132,ACONTMAX,BETA,DFACTNS,DFACTC,A11,A22,A33,AC1C1,AC2C2,T1,T2);
    fprintf(FLUXEX,format110);
    fprintf(FLUXEX,format206);
    % write headers -FLUXATT
    fprintf(FLUXATT,format101,NPART,VSUP,RLIM,POROSITY,AG,RB,TTIME,ATTMODE,B,RMODE,ASP,ASP2);
    fprintf(FLUXATT,format102,AP,IS,ZI,ZETAPST,ZETACST,RHOP,RHOW,VISC,ER,T,DIFFSCALE,GRAVFACT,cbPZ,cbMZ,cbPX, cbMX,simplotCHECK,detplotCHECK);
    fprintf(FLUXATT,format103,SCOV,ZETAHET,HETMODE,RHET0,RHET1,RHET2,SCOVP,ZETAHETP,HETMODEP,RHETP0,RHETP1,RZOIBULK,dTMRT,MULTB,MULTNS,MULTC,VDWMODE);
    fprintf(FLUXATT,format104,A132,LAMBDAVDW,GAMMA0AB,LAMBDAAB,GAMMA0STE,LAMBDASTE,KINT,W132,ACONTMAX,BETA,DFACTNS,DFACTC,A11,A22,A33,AC1C1,AC2C2,T1,T2);
    fprintf(FLUXATT,format110);
    fprintf(FLUXATT,format206);
    % write headers -FLUXREM
    fprintf(FLUXREM,format101,NPART,VSUP,RLIM,POROSITY,AG,RB,TTIME,ATTMODE,B,RMODE,ASP,ASP2);
    fprintf(FLUXREM,format102,AP,IS,ZI,ZETAPST,ZETACST,RHOP,RHOW,VISC,ER,T,DIFFSCALE,GRAVFACT,cbPZ,cbMZ,cbPX, cbMX,simplotCHECK,detplotCHECK);
    fprintf(FLUXREM,format103,SCOV,ZETAHET,HETMODE,RHET0,RHET1,RHET2,SCOVP,ZETAHETP,HETMODEP,RHETP0,RHETP1,RZOIBULK,dTMRT,MULTB,MULTNS,MULTC,VDWMODE);
    fprintf(FLUXREM,format104,A132,LAMBDAVDW,GAMMA0AB,LAMBDAAB,GAMMA0STE,LAMBDASTE,KINT,W132,ACONTMAX,BETA,DFACTNS,DFACTC,A11,A22,A33,AC1C1,AC2C2,T1,T2);
    fprintf(FLUXREM,format110);
    fprintf(FLUXREM,format206);
    %      ccccccccccccccc* END WRITE FLUX HEADERS FOR SINGLE CORE VERSION cccccccccccccccccccccccccccccc^
end
%% OPEN SIX OUTPUT FILES FOR PARALLEL VERSION
if (CLUSTER==1)
    % %        %% OPEN SIX OUTPUT FILES FOR PARALLEL VERSION
    % %         THESE NEED TO BE OPENED OUTSIDE THE LOOP TO AVOID MULTIPLE UNITS BEING WRITTEN TO SIMULTANEOUSLY
    % %         REMOVE THE %% FROM THE LINES IN THE LINES IN THE SECTION BELOW FOR THE CLUSTER VERSION
    % %
    % %         OPEN HAPHETTRAJEX.OUT FOR OUTPUT
    %           filenam='HAPHETTRAJEX.'//chri(ipart)//'.OUT'
    %           call chrpak(filenam,40,ilen)
    %           OPEN (UNIT=11,FILE=filenam,STATUS='REPLACE')
    % %
    % %         OPEN HAPHETTRAJATT.OUT FOR OUTPUT
    %           filenam='HAPHETTRAJATT.'//chri(ipart)//'.OUT'
    %           call chrpak(filenam,40,ilen)
    %           OPEN (UNIT=12,FILE=filenam,STATUS='REPLACE')
    % %
    % %         OPEN HAPHETTRAJREM.OUT FOR OUTPUT
    %           filenam='HAPHETTRAJREM.'//chri(ipart)//'.OUT'
    %           call chrpak(filenam,40,ilen)
    %           OPEN (UNIT=13,FILE=filenam,STATUS='REPLACE')
    % %
    % %         OPEN HAPHETFLUXEX.OUT FOR OUTPUT
    %           filenam='HAPHETFLUXEX.'//chri(ipart)//'.OUT'
    %           call chrpak(filenam,40,ilen)
    %           OPEN (UNIT=21,FILE=filenam,STATUS='REPLACE')
    % %
    % %         OPEN HAPHETFLUXATT.OUT FOR OUTPUT
    %           filenam='HAPHETFLUXATT.'//chri(ipart)//'.OUT'
    %           call chrpak(filenam,40,ilen)
    %           OPEN (UNIT=22,FILE=filenam,STATUS='REPLACE')
    % %
    % %	    OPEN HAPHETFLUXREM.OUT FOR OUTPUT
    %           filenam='HAPHETFLUXREM.'//chri(ipart)//'.OUT'
    %           call chrpak(filenam,40,ilen)
    %           OPEN (UNIT=23,FILE=filenam,STATUS='REPLACE')
    % END OPEN SIX OUTPUT FILES FOR PARALLEL VERSION
end
%% LOOP THROUGH PARTICLES  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NPARTLOOP = 6; %test debug
%initialize release data vectors for loading and perturbation mode
perTIME=0.0; perREL=0.0; perREM=0.0;

% NEAR SURFACE OUTPUT DATA
XINNS = zeros(1,NPARTLOOP);
YINNS = zeros(1,NPARTLOOP);
ZINNS = zeros(1,NPARTLOOP);

for J = 1:NPARTLOOP
    %% DEFINE ARRAYS FIRST, PREALLOCATE FOR SPEED
    XOT = NaN(MAXVAL,1); YOT=XOT; ZOT=XOT; ROT=XOT;      %PARTICLE POSITION
    IOT = XOT;                                          %STEP NUMBER
    HOT = XOT; ETIMEOT=XOT;                             %SEPARATION DISTANCE
    FCOLLOT=XOT; FVDWOT=XOT; FEDLOT=XOT;                %DLVO FORCES
    FABOT=XOT; FSTEOT=XOT; FBORNOT=XOT;                 %ACID BASE STERIC AND BORN FORCES
    FDRGXOT=XOT; FDRGYOT=XOT; FDRGZOT=XOT;              %DRAG FORCE CARTESIAN
    FDRGTOT=XOT; FDRGNOT=XOT;                           %DRAG FORCE NORMAL-TANGENIAL
    FDIFXOT=XOT; FDIFYOT=XOT; FDIFZOT=XOT;              %DifFUSION FORCE
    FGTOT=XOT; FGNOT=XOT; FLIFTOT=XOT;                  %GRAVITY AND LIFT
    UXOT=XOT; UYOT=XOT; UZOT=XOT;                       %PARTICLE VELOCITY CARTESIAN
    UTOT=XOT; UNOT=XOT;                                 %PARTICLE VELOCITY NORMAL-TANGENIAL
    VXOT=XOT; VYOT=XOT; VZOT=XOT;                       %FLUID VELOCITY CARTESIAN
    VTOT=XOT; VNOT=XOT;                                 %FLUID VELOCITY NORMAL-TANGENIAL
    PTIMEFOT=XOT; AFRACTOT=XOT;                         %TRAJ TIME AND FRACTION OF HET/ZOI OVERLAP
    ACONTOT=XOT; RZOIOT=XOT;                            %CONTACT AREA; ZONE OF INFLUENCE RADIUS;
    XHET=zeros(100,1);                                  %COLLECTOR HET LOCATIONS
    YHET=XHET; ZHET=XHET; RHET=XHET;                    %COLLECTOR HET LOCATIONS
    XHETP=zeros(10000000,1);                            %COLLOID HET LOCATIONS
    YHETP=XHETP; ZHETP=XHETP; RHETP=XHETP;              %COLLOID HET LOCATIONS
    seed = int32(0);                                    %RANDOM NUMBER PARAMETER
    if (CLUSTER==0)
        ipart = J;
        %
        %% open 3  trajectory files for each J particle
        filenameEX = [char(trajfname(1)) num2str(J) '.OUT'];
        fileTRAJEX = strcat(workdir,filenameEX);
        TRAJEX = fopen(fileTRAJEX,'w');
        filenameATT = [char(trajfname(2)) num2str(J) '.OUT'];
        fileTRAJATT = strcat(workdir,filenameATT);
        TRAJATT = fopen(fileTRAJATT,'w');
        filenameREM = [char(trajfname(3)) num2str(J) '.OUT'];
        fileTRAJREM = strcat(workdir,filenameREM);
        TRAJREM = fopen(fileTRAJREM,'w');
        %% write headers
        % TRAJEX
        fprintf(TRAJEX,format101,NPART,VSUP,RLIM,POROSITY,AG,RB,TTIME,ATTMODE,B,RMODE,ASP,ASP2);
        fprintf(TRAJEX,format102,AP,IS,ZI,ZETAPST,ZETACST,RHOP,RHOW,VISC,ER,T,DIFFSCALE,GRAVFACT,cbPZ,cbMZ,cbPX, cbMX,simplotCHECK,detplotCHECK);
        fprintf(TRAJEX,format103,SCOV,ZETAHET,HETMODE,RHET0,RHET1,RHET2,SCOVP,ZETAHETP,HETMODEP,RHETP0,RHETP1,RZOIBULK,dTMRT,MULTB,MULTNS,MULTC,VDWMODE);
        fprintf(TRAJEX,format104,A132,LAMBDAVDW,GAMMA0AB,LAMBDAAB,GAMMA0STE,LAMBDASTE,KINT,W132,ACONTMAX,BETA,DFACTNS,DFACTC,A11,A22,A33,AC1C1,AC2C2,T1,T2);
        % TRAJATT
        fprintf(TRAJATT,format101,NPART,VSUP,RLIM,POROSITY,AG,RB,TTIME,ATTMODE,B,RMODE,ASP,ASP2);
        fprintf(TRAJATT,format102,AP,IS,ZI,ZETAPST,ZETACST,RHOP,RHOW,VISC,ER,T,DIFFSCALE,GRAVFACT,cbPZ,cbMZ,cbPX, cbMX,simplotCHECK,detplotCHECK);
        fprintf(TRAJATT,format103,SCOV,ZETAHET,HETMODE,RHET0,RHET1,RHET2,SCOVP,ZETAHETP,HETMODEP,RHETP0,RHETP1,RZOIBULK,dTMRT,MULTB,MULTNS,MULTC,VDWMODE);
        fprintf(TRAJATT,format104,A132,LAMBDAVDW,GAMMA0AB,LAMBDAAB,GAMMA0STE,LAMBDASTE,KINT,W132,ACONTMAX,BETA,DFACTNS,DFACTC,A11,A22,A33,AC1C1,AC2C2,T1,T2);
        % TRAJREM
        fprintf(TRAJREM,format101,NPART,VSUP,RLIM,POROSITY,AG,RB,TTIME,ATTMODE,B,RMODE,ASP,ASP2);
        fprintf(TRAJREM,format102,AP,IS,ZI,ZETAPST,ZETACST,RHOP,RHOW,VISC,ER,T,DIFFSCALE,GRAVFACT,cbPZ,cbMZ,cbPX, cbMX,simplotCHECK,detplotCHECK);
        fprintf(TRAJREM,format103,SCOV,ZETAHET,HETMODE,RHET0,RHET1,RHET2,SCOVP,ZETAHETP,HETMODEP,RHETP0,RHETP1,RZOIBULK,dTMRT,MULTB,MULTNS,MULTC,VDWMODE);
        fprintf(TRAJREM,format104,A132,LAMBDAVDW,GAMMA0AB,LAMBDAAB,GAMMA0STE,LAMBDASTE,KINT,W132,ACONTMAX,BETA,DFACTNS,DFACTC,A11,A22,A33,AC1C1,AC2C2,T1,T2);
    end
    %% open files and write headers for parallel version (not impemented yet in MATLAB)
    if (CLUSTER==1)
        % %         EXIT FLUX FILE, UNIT=21
        %           WRITE (21,101) RB,AG,AP,TTIME,NPART,VSUP,GRAVFACT
        %           WRITE (21,102) POROSITY,ZETACST,ZETAPST,ZETAHET,SCOV,MULTB,
        %      &                    MULTNS,MULTC,dTMRT
        %           WRITE (21,103) IS,BETA,KINT,LAMBDASTE,GAMMA0STE,RZOIBULK,
        %      &                    DFACTNS,DFACTC
        %           WRITE (21,104) RLIM,ATTMODE
        %           WRITE (21,110)
        %           WRITE (21,206)
        %
        % %         ATTACHMENT FLUX FILE, UNIT=22
        %           WRITE (22,101) RB,AG,AP,TTIME,NPART,VSUP,GRAVFACT
        %           WRITE (22,102) POROSITY,ZETACST,ZETAPST,ZETAHET,SCOV,MULTB,
        %      &                    MULTNS,MULTC,dTMRT
        %           WRITE (22,103) IS,BETA,KINT,LAMBDASTE,GAMMA0STE,RZOIBULK,
        %      &                    DFACTNS,DFACTC
        %           WRITE (22,104) RLIM,ATTMODE
        %           WRITE (22,110)
        %           WRITE (22,206)
        %
        % %         REMAINING FLUX FILE, UNIT=23
        %           WRITE (23,101) RB,AG,AP,TTIME,NPART,VSUP,GRAVFACT
        %           WRITE (23,102) POROSITY,ZETACST,ZETAPST,ZETAHET,SCOV,MULTB,
        %      &                    MULTNS,MULTC,dTMRT
        %           WRITE (23,103) IS,BETA,KINT,LAMBDASTE,GAMMA0STE,RZOIBULK,
        %      &                    DFACTNS,DFACTC
        %           WRITE (23,104) RLIM,ATTMODE
        %           WRITE (23,110)
        %           WRITE (23,206)
    end
    %
    % %% WRITE FORMAT FOR OUTPUT FILES %%
    % %       COMMON HEADERS FOR BOTH FLUX AND TRAJECTORY FILES
    % 101	FORMAT ('RB(m)= ',E15.8,2X,
    %      *'AG(m)= ',E15.8,2X,'AP(m)= ',E15.8,2X,
    %      *'TTIME(s)= ',E15.8,2X,'NPART= ',I6,2X,'VSUP(ms-1)= ',E15.8,2X,
    %      &'GRAVFACT=',E15.8)
    % 102   FORMAT ('POROSITY= ',E15.8,2X,'ZETACST(V)= ',E15.8,2X,
    %      *'ZETAPST(V)= ',E15.8,2X,'ZETAHET(V)= ',E15.8,2X,'SCOV= ',E15.8,2X,
    %      *'MULTB= ',E15.8,2X,'MULTNS= ',E15.8,2X,'MULTC= ',E15.8,2X,
    %      *'dTMRT(s)= ',E15.8)
    % 103   FORMAT ('IS(mol/m3)= ',E15.8,2X,
    %      *'BETA= ',E15.8,2X,'KINT= ',E15.8,2X,
    %      &'LAMBDASTE(m)= 'E15.8,2X,'GAMMA0STE(J/m2)= ',E15.8,2X,
    %      &'RZOIBULK(m)= ',E15.8,2X,'DFACTNS= 'E15.8,2X,'DFACTC= 'E15.8)
    % 104   FORMAT ('RLIM= ',E15.8,2X,'ATTMODE(0=SEP,1=TORQUE)=',I5)
    %
    % %     DEFINE ATTACHK VALUES FOR FLUX FILES
    % 110   FORMAT ('ATTACHK1=EXIT
    %      &         ATTACHK2=ATTACHED-BY-SEP-OR-TORQUE
    %      &         ATTACHK3=REMAINING-IN-BULK
    %      &         ATTACHK4=TORQUE-W-SLOW-MOTION
    %      &         ATTACHK5=IN-NEAR-SURFACE-WITH-SLOW-MOTION
    %      &         ATTACHK6=CRASHED')
    %
    % %     DECLARE ATTACHK VALUE FOR EACH PARTICLE TRAJECTORY FILE
    % 105   FORMAT ('ATTACHK= ',I5)
    %
    % %     LABEL AND WRITE VARIABLES FOR TRAJECTORY FILES
    % 106   FORMAT ('X',14X,'Y',14X,'Z',14X,'I',14X,'H',14X,
    %      &  'FCOLL',10X,'FEDL',11X,'FVDW',11X,
    %      &  'FDRGX',10X,'FDRGY',10X,'FDRGZ',10X,
    %      &  'FDIFX',10X,'FDIFY',10X,'FDIFZ',10X,
    %      &  'UX',13X,'UY',13X,'UZ',13X,
    %      &  'VX',13X,'VY',13X,'VZ',13X,
    %      &  'PTIMEF',9X,'AFRACT',10X,'HETTYPE',10X,
    %      &  'NSVEL(ms-1)',10X,'HAVE(m)')
    % 107   FORMAT (E15.8,14X,E15.8,14X,E15.8,14X,I15,14X,E15.8,14X,
    %      &  E15.8,10X,E15.8,11X,E15.8,11X,
    %      &  E15.8,10X,E15.8,10X,E15.8,10X,
    %      &  E15.8,10X,E15.8,10X,E15.8,10X,
    %      &  E15.8,13X,E15.8,13X,E15.8,13X,
    %      &  E15.8,13X,E15.8,13X,E15.8,13X,
    %      &  E15.8,9X,E15.8,10X,I4,10X,
    %      &  E15.8,10X,E15.8)
    %
    % %     LABEL AND WRITE VARIABLES FOR FLUX FILES
    % 206   FORMAT ('PARTICLE',10X,'HINIT(m)',12X,'XINIT(m)',11X,'YINIT(m)'
    %      &,12X,'ZINIT(m)',12X,'RINJ(M)',13X,'HOUT(m)',13X,'XOUT(m)',14X,
    %      &'YOUT(m)',13X,'ZOUT(m)',13X,'PTIMEIN(s)',9X,'PTIMEOUT(s)',9X,
    %      &'ETIME(s)',11X,'TBULK(s)',16x,'TNEAR(s)',10X,'NSVISIT',10x,
    %      & 'TFRIC',10x,'FRICVISIT',10X,
    %      &'ATTACHK',10X,'AFRACT',10X,'HETTYPE',10X,
    %      &'NSVEL(ms-1)',10X,'HAVE(m)')
    % 207   FORMAT (I7,10X,E15.8,12X,E15.8,11X,E15.8
    %      &,12X,E15.8,12X,E15.8,13X,E15.8,13X,E15.8,14X,
    %      &E15.8,13X,E15.8,13X,E15.8,9X,E15.8,9X,
    %      &E15.8,11X,E15.8,16x,E15.8,10x,I15,10X
    %      & E15.8,10X,I15,10X,
    %      &I5,10X,E15.8,10X,I4,10X,
    %      &E15.8,10X,E15.8)
    % END WRITE FORMAT FOR OUTPUT FILES %%
    %% Particle intial set up prior to injection, differentiate between loading and perturbation simulation
    % test debug
    FADH=1e-10; FREP=1e-10;
    % ATTMODE -1 for perturbation, ATTMODE  0 or 1 for perfect sink or contact mode, repectively
    if ATTMODE==-1
        %SET INITIAL PARTICLE TIME TO BE 0
        PTIMEF = 0.0;
        %COLLOID STARTS IN CONTACT
        dT = MULTC*dTMRT;
        HFLAG = 3;
        %load initial loactions from arrays ATTAHKP XOUTP YOUTP ZOUTP ROUTP HOUTP
        XINIT = XOUTP(J);
        YINIT = YOUTP(J);
        ZINIT = ZOUTP(J);
        RINIT = ROUTP(J);
        HINIT = HOUTP(J);
        X = XINIT;
        Y = YINIT;
        Z = ZINIT;
        H = HINIT;
        R = RINIT;
        % Rxy for 2D plot only
        Rxy = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0))^0.5;
        % alternate displayed trajectory directions in 2D circle
        if mod(J,2)==0
            Rxy = -Rxy;
        end
        %CALCULATE FLUID VELOCITY COMPONENTS AND SET COLLOID NORMAL VELOCITY
        [VxH1,VyH1,VzH1]= HAPPELFF (X,Y,Z,B,K1,K2,K3,K4,AG);
        VX = VxH1*VSUP;
        VY = VyH1*VSUP;
        VZ = VzH1*VSUP;
        UZ = 0.0;
    else %PERFECT SINK OR CONTACT MODE
        %% SET INITIAL PARTICLE TIME (EVENLY DISTRIBUTED THROUGH TIME FOR FLUX) SET MAXIMUM INJECTION TIME HALF OF TOTAL SIMULATION TIME
        TINJ = TTIME/6.0;
        PTIMEF = double(ipart-1)*TINJ/double(NPART);
        % save injection tiime in total time
        %SET TIME STEP
        dT = MULTB*dTMRT;
        HFLAG =1;
        ACONT = 0.0;
        %%INITIALIZE LOCATION OF PARTICLES
        [XINIT,YINIT,ZINIT,RINJ,HINIT]=HAPINITIAL(RLIM,RB,AG,AP);
        %
        X = XINIT;
        Y = YINIT;
        Z = ZINIT;
        H = HINIT;
        R = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0)+(Z-Zm0)*(Z-Zm0))^0.5;
        % Rxy for 2D plot only
        Rxy = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0))^0.5;
        % alternate displayed trajectory directions in 2D circle
        if mod(J,2)==0
            Rxy = -Rxy;
        end
        RINIT = R; % !! line added check with Cesar
        %SET FLUID VELOCITY COMPONENTS AND COLLOID NORMAL VELOCITY
        VX = 0.0;
        VY = 0.0;
        VZ = -VSUP;
        UZ = VZ;
    end
    %% UPDATED INITIALIZATION
    %   CALCULATE UNIT VECTORS
    ENX = (X-Xm0)/R;
    ENY = (Y-Ym0)/R;
    ENZ = (Z-Zm0)/R ;
    %   INITIALIZE VELOCITIES
    UX = 0.0;
    UY = 0.0;
    UN = UX*ENX+UY*ENY+UZ*ENZ;
    UNX = UN*ENX;
    UNY = UN*ENY;
    UNZ = UN*ENZ;
    UTX = UX-UNX;
    UTY = UY-UNY;
    UTZ = UZ-UNZ;
    UT = (UTX^2+UTY^2+UTZ^2)^(0.5);
    %   FIT OMEGA*AP/UT AS FUNCTION OF H/AP USING GCB 1967b TABLES 2&3
    OMEGA = UT/AP*(0.5518+117.4*(H/AP))/(1+232.1*(H/AP)+237.7*(H/AP)^2.0);
    VN = VX*ENX+VY*ENY+VZ*ENZ;
    VNX = VN*ENX;
    VNY = VN*ENY;
    VNZ = VN*ENZ;
    VTX = VX-VNX;
    VTY = VY-VNY;
    VTZ = VZ-VNZ;
    VT = (VTX*VTX+VTY*VTY+VTZ*VTZ)^0.5;
    %   CALCULATE RZOI AND RZOIAB
    RZOI = (ACONT^2+2/KAPPA*(AP+(AP^2-ACONT^2)^0.5))^0.5;
    RZOIAB = (ACONT^2+2*LAMBDAAB*(AP+(AP^2-ACONT^2)^0.5))^0.5;
    %   CALCULATE THE NUMBER OF ASPERITIES WITHIN EACH ZOI
    NASP = 0.0;
    NASPAB = 0.0;
    ASPLIM = 0.5*(PI^0.5)*RZOI;
    ASPLIMAB = 0.5*(PI^0.5)*RZOIAB;
    if (RMODE>0)
        if (ASP>=ASPLIM)
            NASP = 1.0;
        else
            NASP = (RZOI^2/ASP^2)*(PI/4);
        end
        if (ASP>=ASPLIMAB)
            NASPAB = 1.0;
        else
            NASPAB = (RZOIAB^2/ASP^2)*(PI/4);
        end
    end
    %   CALCULATE FORCES FOR INITIAL POSITION FOR FIRST TRAJECTORY POINT
    FVDW=HFORCEVDW (A132,AG,AP,ASP,NASP,RMODE,H,LAMBDAVDW,A11,...
        A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE);
    
    %   FAVORABLE CONDITIONS IF BULK ZETAC AND ZETAP ARE OPPOSITE IN SIGN, THEN SET SCOV = 0.0 AND SCOVP = 0.0
    if or(and(ZETACST>=0.0,ZETAPST<=0.0),and(ZETACST<=0.0,ZETAPST>=0.0))
        SCOV = 0.0;
        SCOVP = 0.0;
    end
    %   UNDER UNFAVORABLE CONDITIONS HETERODOMIANS WILL BE SIMULATED IN EITHER COLLECTOR (HETC), OR COLLOID (HETP), OR BOTH
    %   TO CALCULATE HETC AND HETP FRACTIONAL AREAS WITHIN ZOI, HETERODOMAINS WILL BE PROJECTED ONTO THE FRAME OF REFERENCE
    %   WITH X-Y PLANE MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER
    if or(SCOV>0.0,SCOVP>0.0)
        %   CALCULATE PROJECTION OF COLLOID CENTER ON HAPPEL SPHERE
        XG = Xm0+ENX*AG;
        YG = Ym0+ENY*AG;
        ZG = Zm0+ENZ*AG;
        AFRACT = 0.0;
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
    end
    %   CALCULATE HETERODOMAINS INFLUENCE
    if and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
        %   HETEROGENEITY ON COLLECTOR (HETC) SUBROUTINE TO DETERMINE CLOSEST HETERODOMAIN TO COLLOID
        %   HETC WILL BE TRANSLATED TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER
        if (SCOV>0.0)
            [XHET,YHET,ZHET,RHET] = HAPHETTRACK(X,Y,Z,Xm0,Ym0,Zm0,AG,HETMODE,SCOV,RHET0,RHET1,RHET2,0);
            [XHET_AF,YHET_AF,ZHET_AF] = HETC_TRANSFORM(XG,YG,ZG,THETA,PHI,XHET,YHET,ZHET);
            RHET_AF = RHET;
        else
            XHET_AF = 0.0;
            YHET_AF = 0.0;
            ZHET_AF = 0.0;
            RHET_AF = 0.0;
        end
        %   INITIALIZE FRACTIONAL AREAS
        AFRACT = 0.0; %TOTAL ATTRACTIVE FRACTIONAL AREA
        AFRACT_PZ = 0.0; %PRO-ZOI FRACTIONAL AREA
        AFRACT_ZH = 0.0; %ZOI-HET FRACTIONAL AREA
        AFRACT_PZH = 0.0; %PRO-ZOI-HET FRACTIONAL AREA
        AFRACT_Z = 0.0; %ZOI FRACTIONAL AREA NON-OVERLAPPED
        %   CALCULATE OVERLAPING AREA OF HETERODOMAINS AND ZOI
        %   GIVEN THAT THE PROJECTION OF COLLOID CENTER CORRESPONDS TO THE ORIGIN OF THE FRAME OF REFERENCE WITH X-Y PLANE
        %   MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER, VARIABLES
        %   EQUAL TO 0.0 MUST BE PASSED TO THE FIRST TWO POSITIONS OF SUBROUTINE FRACTIONAL_AREA
        [AF_PZ,AF_ZH,AF_PZH,AF_Z] = HAREAFRACT(Xm0,Ym0,RZOI,Xm0,Ym0,Zm0,MPRO_AF(:,[1,2,4]));
        AFRACT = AF_PZ;
        AFRACT_PZ = AF_PZ;
        for K=1:HETMODE
            [AF_PZ,AF_ZH,AF_PZH,AF_Z] = HAREAFRACT(Xm0,Ym0,RZOI,XHET_AF(K),YHET_AF(K),RHET_AF(K),MPRO_AF(:,[1,2,4]));
            AFRACT = AFRACT + AF_ZH; %TOTAL ATTRACTIVE FRACTIONAL AREA
            if (AF_ZH >= 0.0)
                AFRACT = AFRACT - AF_PZH; %TOTAL ATTRACTIVE FRACTIONAL AREA
                AFRACT_PZ = AFRACT_PZ - AF_PZH; %PRO-ZOI FRACTIONAL AREA
            end
            AFRACT_ZH = AFRACT_ZH + AF_ZH; %ZOI-HET FRACTIONAL AREA
            AFRACT_PZH = AFRACT_PZH + AF_PZH; %PRO-ZOI-HET FRACTIONAL AREA
            AFRACT_Z = 1 - AFRACT_PZ - AFRACT_ZH - AFRACT_PZH; %ZOI FRACTIONAL AREA NON-OVERLAPPED
        end
        if (AFRACT>0.0)
            %CALCULATE PRO-ZOI ATTRACTIVE CONTRIBUTION TO EDL FORCE
            ZETAC = ZETACST;
            ZETAP = ZETAHETP;
            FEDL= HFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
            FEDL_PZ = FEDL;
            %CALCULATE ZOI-HET ATTRACTIVE CONTRIBUTION TO EDL FORCE
            ZETAC = ZETAHET;
            ZETAP = ZETAPST;
            FEDL= HFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
            FEDL_ZH = FEDL;
            %CALCULATE PRO-ZOI-HET REPULSIVE CONTRIBUTION TO EDL FORCE
            ZETAC = ZETAHET;
            ZETAP = ZETAHETP;
            FEDL= HFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
            FEDL_PZH = FEDL;
            %CALCULATE ZOI REPULSIVE CONTRIBUTION TO EDL FORCE
            ZETAC = ZETACST;
            ZETAP = ZETAPST;
            FEDL= HFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
            FEDL_Z = FEDL;
            %CALCULATE NET EDL FORCE
            %REPULSIVE AFRACT: AFRACT_Z, AFRACT_PZH
            %ATRACTIVE AFRACT: AFRACT_ZH, AFRACT_PZ
            FEDL =  AFRACT_PZ*FEDL_PZ + AFRACT_ZH*FEDL_ZH + AFRACT_PZH*FEDL_PZH + AFRACT_Z*FEDL_Z;
            % CALCULATE ATRACTIVE AFRACT
            AFRACT_ATT = AFRACT_ZH+AFRACT_PZ;
        else %(AFRACT>0.0)
            ZETAC = ZETACST;
            ZETAP = ZETAPST;
            FEDL= HFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
        end %(AFRACT>0.0)
    else %and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
        AFRACT = -1.0;
        ZETAC = ZETACST;
        ZETAP = ZETAPST;
        FEDL= HFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
    end %and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
    
    FAB= HFORCEAB (PI,AG,AP,ASP,NASPAB,RMODE,LAMBDAAB,GAMMA0AB,H,H0);
    %         FAB = 0.0; % !!debugEP
    
    FBORN=HFORCEBORN (A132,SIGMAC,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE);
    
    FSTE=HFORCESTE (PI,GAMMA0STE,LAMBDASTE,ASTE,H);
    FCOLL = FVDW + FEDL + FAB + FBORN + FSTE;
    FDIFX = 0.0;
    FDIFY = 0.0;
    FDIFZ = 0.0;
    % calculate gravity magnitude
    FG=HGRAVITY(GRAVFACT,AP,G,RHOP,RHOW,PI);
    %% calculate gravity for initial step
    % gravity direction EGX EGY EGZ is set at the beginning of this code
    % depending on GUI input (cbMZ cbPZ cbMX cbPX)
    % the function below projects cartesian gravity toward normal and
    % tangential axes. +Normal points away from the collector surface,
    % -Normal points towards collector surface
    % +tangential is aligned with tangential velocity from Happel flow field
    % -tangential is opposed to tangential velocity from Happel flow field 
    [FGN,FGT,FGNX,FGNY,FGNZ,FGTX,FGTY,FGTZ]= HFUNGVECT(FG,EGX,EGY,EGZ,ENX,ENY,ENZ,ETX,ETY,ETZ);
    %%
    FLifT=HFORCELIFT (RHOW,R,AP,AG,VT,UT,OMEGA);
    HBAR = (H+B)/AP; %REDUCED RETARDATION DUE TO ROUGHNESS
    FUN2=1.0+B2*exp(-C2*HBAR)+D2*exp(-E2*HBAR^A2);
    FUN3=1.0+B3*exp(-C3*HBAR)+D3*exp(-E3*HBAR^A3);
    FUN4=1.0+B4*exp(-C4*HBAR)+D4*exp(-E4*HBAR^A4);
    [FDRGN,FDRGT]=HFORCEDRAG (FUN2,FUN3,FUN4,M3,VN,VT);
    
    %   RESTART TRANSLATION AND OUTPUT COUNTERS
    I = 0;
    PCOUNT = 0;
    PCOUNT2 = 0;
    NSplot = 0;
    NSplotVAR = 30;
    PARRAY=0;
    OUTCOUNT = 0;
    OUTFLAG = 1;
    ATTACHK = 0; %INITIALIZE ATTACHK FLAG
    ARRESTFLAG = 0; %USED TO ALLOW COLLOID REACH EQUILIBRIUM SEPARATION DISTANCE
    %   RESET STAGNANT PARTICLE INDICATOR
    IREF1 = 0;
    IREF2 = 0;
    %   RESET CUMULATIVE BULK,NEAR-SURFACE, AND FRICTION TIMES
    TBULK = 0.0;
    TNEAR = 0.0;
    TFRIC = 0.0;
    ETIME = 0.0;
    %   RESET NEAR-SURFACE AND FRICTION VISIT COUNTERS
    NSVISIT = 0;
    FRICVISIT = 0;
    %   RESET AVERAGE SEPARATION DISTANCE AND NEAR-SURFACE VELOCITY PARAMETERS
    L = 0;
    HSUM = 0;
    HAVE = 0.0;
    NSDIST = 0.0;
    NSVEL = 0.0;
    %restart Happel circle for transport plots
    drawcircle =1;
    %% INITIALIZE simplot figures
    % calculate output interval as a function of dTMRT
    NOUTinterval=1/dTMRT/NOUT;
    if simplot==1||detplot==1
        if simplot ==1
            %Define figure index and titles
            % dashboard figure
            Tfig =  strcat('F_Transport_',num2str(J,' %d'));
            n01=double(100000+J);
            fT=figure(n01);
            set(gcf,'name',Tfig,'NumberTitle','off');
            % define folder names to save figures if needed
            filefT = strcat(workdir,Tfig);
        end
        if detplot==1
            % detailed near surface figure
            Dnearfig =  strcat('F_Near_Surface_',num2str(J,' %d'));
            n02=double(200000+J);
            fDnear=figure(n02);
            set(gcf,'name',Dnearfig,'NumberTitle','off');
            % save previous open figure (contact)
            if J>1
                fDcontactOLD = fDcontact;
                % figure is closed after attachment conditions are reached
                % below in the code
            end
            % detailed contact figure
            Dcontactfig =  strcat('F_Contact_',num2str(J,' %d'));
            n03=double(300000+J);
            fDcontact=figure(n03);
            set(gcf,'name',Dcontactfig,'NumberTitle','off');
            % define folder names to save figures if needed
            filefDnear = strcat(workdir,Dnearfig);
            filefContact = strcat(workdir,Dcontactfig);
        end
        if simplot==1
            %% Transport figure (dashboard)
            figure(fT);
            sgtitle('Bulk=red Near=magenta Contact=blue')
            subplot(2,5,1)
            semilogy (ETIME,H,'. r');
            hold on;  ylabel('Sep. Dist. (m)'); xlabel('Time (s)');
            grid on;   axis square;
            drawnow;
            figure(fT);
            subplot(2,5,2)
            plot(ETIME,0.0,'. r')
            hold on; ylabel('Drag Force Nor. (N)'); xlabel('Time (s)');
            grid on; axis square;
            drawnow;
            figure(fT);
            subplot(2,5,3)
            plot(ETIME,0.0,'. r')
            hold on; ylabel('Drag Force Tan. (N)'); xlabel('Time (s)');
            grid on; axis square;
            drawnow;
            figure(fT);
            subplot(2,5,4)
            % draw circle representing collector slice and fluid shell
            % once
            if drawcircle ==1
                th = 0:pi/50:2*pi;
                xcirc = AG * cos(th) + 0.0;
                ycirc = AG * sin(th) + 0.0;
                figure(fT);
                plot(xcirc, ycirc,'-k');
                hold on; axis square;
                xcirc = RB * cos(th) + 0.0;
                ycirc = RB * sin(th) + 0.0;
                figure(fT);
                plot(xcirc, ycirc,'--b');
            end
            figure(fT);
            plot(Rxy,Z,'. r')
            hold on; ylabel('Z (m)'); xlabel('Rxy (m)'); ylim ([-RB RB]); xlim ([-RB RB]);
            grid on; axis square;
            drawnow;
            figure(fT);
            subplot(2,5,5)
            semilogy (ETIME,1e-10,'. b');
            hold on;  axis square;
            semilogy (ETIME,1e-10,'o r');
            grid on;
            legend('FADHES','FREPUL','location','southeast','AutoUpdate','off');%MATTLAB 2017 and newer
            ylabel('Contact Forces (N)'); xlabel('Time (s)');
            drawnow;
            % initialize entry to contact flag
            cflag = 0;
            figure(fT);
            subplot(2,5,6)
            plot(ETIME,0.0,'. r')
            hold on; ylabel('ColVel. Nor. (m/s)(- to grain, + away grain)'); xlabel('Time (s)');
            grid on; axis square;
            drawnow;
            figure(fT);
            subplot(2,5,7)
            plot(ETIME,0.0,'. r')
            hold on;ylabel('ColVel. Tan. (m/s)(- w/flow, + opp./flow)'); xlabel('Time (s)');
            grid on;  axis square;
            drawnow;
            figure(fT);
            subplot(2,5,8)
            plot(ETIME,0.0,'. r')
            hold on;ylabel('ColVel.XY (m/s)(- to poles, + away poles)'); xlabel('Time (s)');
            grid on;  axis square;
            drawnow;
            figure(fT);
            subplot(2,5,9)
            plot(ETIME,0.0,'. r')
            hold on;ylabel('Colloidal Force N)'); xlabel('Time (s)');
            grid on;  axis square;
            drawnow;
            figure(fT);
            subplot(2,5,10)
            plot(ETIME,0.0,'. b')
            hold on; ylabel('Area ZOI w/Heterodomain (fract.)'); xlabel('Time (s)');
            grid on; axis square; ylim ([0 1]);
            drawnow;
        end
    end
    %%    cccccccccccccccccc TRANSLATION LOOP cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc^
    while (ATTACHK==0)
        %%      OUTPUT TO ARRAY
        PCOUNT = PCOUNT + 1; %COUNT THE NUMBER OF TRANSLATIONS TO OUTPUT
        % modify output frequency based on separation distance
        if H>2.0e-7
            NOUTdummy=NOUTinterval;
        elseif H>HFRIC&&H<=2.0e-7&&AFRACT>0.0
            NOUTdummy=ceil(NOUTinterval/10);
        elseif H<=HFRIC&&ATTMODE>=0
            NOUTdummy=ceil(NOUTinterval/100);
            if NOUTdummy<20
                NOUTdummy=1;
            end
        elseif H<=HFRIC&&ATTMODE==-1
            NOUTdummy=ceil(NOUTinterval/10);
        end
        if I==0||PCOUNT>=NOUTdummy
            % output to array
            PARRAY = 1;
            %calculate UXY
            UXY = (UX*UX+UY*UY)^0.5;
            %calculate Rxy
            Rxy = (X*X+Y*Y)^0.5;
            if mod(J,2)==0
                Rxy = -Rxy;
            end
            % test debug
            %% sim plots
            if H>2.0e-7&&simplot==1 % bulk transport
                figure(fT)
                % set(figure(10), 'Position',  [100, 100, 1200, 600])
                subplot(2,5,1)
                semilogy (ETIME,H,'. r');
                figure(fT)
                subplot(2,5,2)
                plot(ETIME,FDRGN,'. r')
                figure(fT)
                subplot(2,5,3)
                plot(ETIME,FDRGT,'. r')
                figure(fT)
                subplot(2,5,4)
                plot(Rxy,Z,'. r')
                % display zeros for contact forces if not in contact
                figure(fT)
                subplot(2,5,5)
                semilogy (ETIME,1e-10,'. b');
                semilogy (ETIME,1e-10,'o r');
                %
                figure(fT)
                subplot(2,5,6)
                plot(ETIME,UN,'. r')
                figure(fT)
                subplot(2,5,7)
                plot(ETIME,UT,'. r')
                figure(fT)
                subplot(2,5,8)
                plot(ETIME,UXY,'. r')
                figure(fT)
                subplot(2,5,9)
                plot(ETIME,FCOLL,'. r')
                % display zero AFRACT if in bulk
                figure(fT)
                subplot(2,5,10)
                plot(ETIME,0.0,'. r')
                drawnow;
                %PARRAY=1;
            elseif H>HFRIC&&H<=2.0e-7&&simplot==1 %NEAR SURFACE
                figure (fT)
                %set(figure(11), 'Position',  [100, 100, 1200, 600])
                subplot(2,5,1)
                semilogy (ETIME,H,'. m');
                figure(fT)
                subplot(2,5,2)
                plot(ETIME,FDRGN,'. m')
                figure(fT)
                subplot(2,5,3)
                plot(ETIME,FDRGT,'. m')
                figure(fT)
                subplot(2,5,4)
                plot(Rxy,Z,'. m')
                % display zeros for contact forces if not in contact
                figure(fT)
                subplot(2,5,5)
                semilogy (ETIME,1e-10,'. b');
                semilogy (ETIME,1e-10,'o r');
                %
                figure(fT)
                subplot(2,5,6)
                plot(ETIME,UN,'. m')
                figure(fT)
                subplot(2,5,7)
                plot(ETIME,UT,'. m')
                figure(fT)
                subplot(2,5,8)
                plot(ETIME,UXY,'. m')
                figure(fT)
                subplot(2,5,9)
                plot (ETIME,FCOLL,'. m');
                figure(fT)
                subplot(2,5,10)
                if AFRACT <0.0
                    plot(ETIME,0.0,'. m')
                else
                    plot(ETIME,AFRACT,'. m')
                end
                drawnow;
                %PARRAY=1;
            end
            if H<=HFRIC&&simplot==1 %friction
                figure (fT)
                %set(figure(11), 'Position',  [100, 100, 1200, 600])
                subplot(2,5,1)
                semilogy (ETIME,H,'. b');
                figure(fT)
                subplot(2,5,2)
                plot(ETIME,FDRGN,'. b')
                figure(fT)
                subplot(2,5,3)
                plot(ETIME,FDRGT,'. b')
                figure(fT)
                subplot(2,5,4)
                plot(Rxy,Z,'. b')
                figure(fT)
                subplot(2,5,5)
                semilogy (ETIME,FADH,'. b');
                semilogy (ETIME,FREP,'o r');
                % adapt time scale to start with contact
                if cflag==0&&ATTMODE>=0
                    Frictime=ETIME;
                    xlim([Frictime Frictime*1.01])
                    cflag=1;
                elseif ATTMODE>=0
                    xlim([Frictime ETIME])
                end
                figure(fT)
                subplot(2,5,6)
                plot(ETIME,UN,'. b')
                figure(fT)
                subplot(2,5,7)
                plot(ETIME,UT,'. b')
                figure(fT)
                subplot(2,5,8)
                plot(ETIME,UXY,'. b')
                figure(fT)
                subplot(2,5,9)
                plot (ETIME,FCOLL,'. b');
                figure(fT)
                subplot(2,5,10)
                plot(ETIME,AFRACT,'. b')
                drawnow;
                %PARRAY=1;
            end
            %% DETAILED SURFACE VISUALIZATION
            % near surface visualization
            % scale near surface plot based on colloid size
            nang=500;% resolution angular grid points for collector sphere cap array
            fsurf = 5; % factor of sphere cap (as amultiple of the arc of length AP)
            % set factor to axis limits around center of plot (as a factor of AP)
            axsc = 1.3*fsurf/2;
            nsplotH = 2.0e-7; % default near surface visualization distance
            if axsc*AP<2.0e-7
                nsplotH = axsc*AP;
            end
            if H<=nsplotH&&H>2*HFRIC&&detplot==1&&(PCOUNT2==NSplotVAR||NSplot==1)
                % reset NSplot (for plotting the first time the particle
                % enters the near surface
                if NSplot==1
                    NSplot=2;
                end
                %% plot geometry
                % estimate sphere cap grid resolution
                res = fsurf*AP*2/nang;
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
                %% plot
                % plot geometry
                figure(fDnear)
                subplot(1,2,1)
                title('Top view')
                plot3(xpl,ypl,zpl,'ob')
                axis([-axsc*AP+xpl axsc*AP+xpl -axsc*AP+ypl axsc*AP+ypl -axsc*AP+zpl axsc*AP+zpl])
                axis square
                view(aznorm,elnorm)
                hold on
                xlabel('X'); ylabel('Y'); zlabel('Z');
                % plot sphere cap surface on collector
                surf(xcap,ycap,zcap,'FaceColor',collecolor,'EdgeColor','none')
                subp=[1,2,1];
                [XHET,YHET,ZHET,RHET]=HAPHETTRACK(X,Y,Z,Xm0,Ym0,Zm0,AG,HETMODE,SCOV,RHET0,RHET1,RHET2,1);
                % paint hetdomains on collector cap
                if SCOV>0
                    hetpaint(fDnear,subp,xcap,ycap,zcap,XHET,YHET,ZHET,RHET)
                end
                % draw hetdomains on colloid surface
                if SCOVP>0
                    colloidHetPaint(fDnear,subp,MHETP_PLOT(:,1),MHETP_PLOT(:,2),MHETP_PLOT(:,3),MHETP_PLOT(:,4),X,Y,Z,AP)
                end
                %% generate colloid ring and zoi to visualizae colloid border and zoi
                [xcirc,ycirc,zcirc,xzoi,yzoi,zzoi]=colloid_circle(X,Y,Z,AP,AG,RZOIBULK);
                figure(fDnear)
                subplot(1,2,1)
                plot3(xcirc,ycirc,zcirc,'.','MarkerEdgeColor','k')
                plot3(xzoi,yzoi,zzoi,'.','MarkerEdgeColor',colcolor)
                %%
                figure(fDnear)
                subplot(1,2,2)
                title('Side view')
                plot3(xpl,ypl,zpl,'ob')
                axis([-axsc*AP+xpl axsc*AP+xpl -axsc*AP+ypl axsc*AP+ypl -axsc*AP+zpl axsc*AP+zpl])
                axis square
                view(azpers,elpers)
                hold on
                xlabel('X'); ylabel('Y'); zlabel('Z');
                % plot sphere cap surface on collector
                surf(xcap,ycap,zcap,'FaceColor',collecolor,'EdgeColor','none')
                subp=[1,2,2];
                % paint hetdomains on collector cap
                if SCOV>0
                    hetpaint(fDnear,subp,xcap,ycap,zcap,XHET,YHET,ZHET,RHET)
                end
                % draw hetdomains on colloid surface
                if SCOVP>0
                    colloidHetPaint(fDnear,subp,MHETP_PLOT(:,1),MHETP_PLOT(:,2),MHETP_PLOT(:,3),MHETP_PLOT(:,4),X,Y,Z,AP)
                end
                %% generate colloid ring and zoi to visualizae colloid border and zoi
                figure(fDnear)
                subplot(1,2,2)
                plot3(xcirc,ycirc,zcirc,'.','MarkerEdgeColor','k')
                plot3(xzoi,yzoi,zzoi,'.','MarkerEdgeColor',colcolor)
                %%
                % plot center of cap from angles
                z1=cos(thetap)*AG;
                x1=cos(phip)*rxys;
                y1=sin(phip)*rxys;
                % hold off figure
                figure(fDnear)
                subplot(1,2,1)
                hold off
                figure(fDnear)
                subplot(1,2,2)
                hold off
            end
            %%
            %% TEXT OUTPUT
            % TEXT AND DASHBOARD OUTPUT COUNTER RESET
            PCOUNT = 0;
            % DETAILED SURFACE VISUALIZATION COUNTER AND RESET
            PCOUNT2=PCOUNT2+1;
            if PCOUNT2==NSplotVAR+1
                PCOUNT2=0;
            end
            if PARRAY==1 %ARRAY OUTPUT ACTIVATED
                % integrate output counter
                OUTCOUNT = OUTCOUNT +1;
                IOT(OUTCOUNT) = I;
                XOT(OUTCOUNT) = X;
                YOT(OUTCOUNT) = Y;
                ZOT(OUTCOUNT) = Z;
                ROT(OUTCOUNT) = R;
                HOT(OUTCOUNT) = H;
                ETIMEOT(OUTCOUNT) = ETIME;
                PTIMEFOT(OUTCOUNT) = PTIMEF;
                FCOLLOT(OUTCOUNT) = FCOLL;
                FVDWOT(OUTCOUNT) = FVDW;
                FEDLOT(OUTCOUNT) = FEDL;
                FDRGXOT(OUTCOUNT) = FDRGX;
                FDRGYOT(OUTCOUNT) = FDRGY;
                FDRGZOT(OUTCOUNT) = FDRGZ;
                FDIFXOT(OUTCOUNT) = FDIFX;
                FDIFYOT(OUTCOUNT) = FDIFY;
                FDIFZOT(OUTCOUNT) = FDIFZ;
                FABOT(OUTCOUNT) = FAB;
                FSTEOT(OUTCOUNT) = FSTE;
                FBORNOT(OUTCOUNT) = FBORN;
                UTOT(OUTCOUNT) = UT;
                UNOT(OUTCOUNT) = UN;
                VTOT(OUTCOUNT) = VT;
                VNOT(OUTCOUNT) = VN;
                FDRGTOT(OUTCOUNT) = FDRGT;
                FDRGNOT(OUTCOUNT) = FDRGN;
                FGTOT(OUTCOUNT) = FGT;
                FGNOT(OUTCOUNT) = FGN;
                FLIFTOT(OUTCOUNT) = FLifT;
                ACONTOT(OUTCOUNT) = ACONT;
                RZOIOT(OUTCOUNT) = RZOI;
                UXOT(OUTCOUNT) = UX;
                UYOT(OUTCOUNT) = UY;
                UZOT(OUTCOUNT) = UZ;
                VXOT(OUTCOUNT) = VX;
                VYOT(OUTCOUNT) = VY;
                VZOT(OUTCOUNT) = VZ;
                PTIMEFOT(OUTCOUNT) = PTIMEF;
                AFRACTOT(OUTCOUNT) = AFRACT;
                %             RESET OUTPUT COUNTER TO KEEP STORING NEW VALUE IN THE BEGINNING OF THE ARRAY
                %             FLAG THIS EVENT TO OUTPUT ARRAY PROPERLY WHEN TRAJECTORY IS RESOLVED
                if (OUTCOUNT>OUTMAX)
                    OUTFLAG = OUTFLAG + 1;
                    %                 if ARRAY REWRITE OCCURS OUTMAX TIMES,   OVERWRITE SECOND
                    %                 TO LAST POSITION TO HOLD SPACE FOR FINAL RESOLVED POSITION
                    if (OUTFLAG==OUTMAX)
                        OUTFLAG = OUTFLAG - 1;
                    end
                    OUTCOUNT = OUTFLAG;    %!! check
                end
                %%             Display simulation progress in  MATLAB command window
                if(CLUSTER==0&&showout==1)
                    msg = sprintf(format6001,J,I,Z,H,AFRACT);
                    disp(msg)
                end
                PARRAY=0;
            end
        end
        %%
        %%
        
        I = I + 1; %COUNT THE NUMBER OF TRANSLATIONS
        PTIMEF = PTIMEF + dT; %ADD TIME STEP TO TOTAL TIME
        %         CALCULATE ELAPSED TIME
        ETIME = ETIME + dT;
        %%         RECORD PREVIOUS VALUES
        XO = X;
        YO = Y;
        ZO = Z;
        HO = H;
        IO = I - 1;
        %         TRANSLATE PARTICLE
        X = XO + UX*dT;
        Y = YO + UY*dT;
        Z = ZO + UZ*dT;
        %         CALCULATE RADIAL DISTANCE
        R = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0)+(Z-Zm0)*(Z-Zm0))^0.5;
        
        %   CALCULATE VERTICAL DEFORMATION AS FUNCTION OF R
        %   EQUATION OF LINE CONNECTING POINTS DELTA=0,Z=AP+HFRIC AND DELTA=DELTAMAX,Z=AP-DELTAMAX+HMIN (ADJUST TO INCLUDE ASPERITIES)
        if (RMODE==0)  %SMOOTH-SMOOTH INTERACTION
            DELTA = DELTAMAX*(R-AG-AP-HFRIC)/(HMIN-HFRIC-DELTAMAX);
        elseif ((RMODE==1)||(RMODE==2))  %SMOOTH-ROUGH INTERACTION
            DELTA = DELTAMAX*(R-AG-AP-HFRIC-ASP)/(HMIN-HFRIC-DELTAMAX);
        elseif (RMODE==3)  %ROUGH-ROUGH INTERACTION
            DELTA = DELTAMAX*(R-AG-AP-HFRIC-0.5*(2*ASP+3^0.5*ASP))/(HMIN-HFRIC-DELTAMAX);
        end
        if (DELTA>DELTAMAX)
            DELTA = DELTAMAX;
        end
        if (DELTA<0.0)
            DELTA = 0.0;
        end
        %         CALCULATE CONTACT AREA
        ACONT = BETA*(2.0*AP*DELTA-DELTA^2.0)^0.5;
        RZOI = (ACONT^2+2/KAPPA*(AP+(AP^2-ACONT^2)^0.5))^0.5;
        RZOIAB = (ACONT^2+2*LAMBDAAB*(AP+(AP^2-ACONT^2)^0.5))^0.5;
        ASPLIM = 0.5*(PI^0.5)*RZOI;
        ASPLIMAB = 0.5*(PI^0.5)*RZOIAB;
        if (RMODE>0)
            if (ASP>=ASPLIM)
                NASP = 1.0;
            else
                NASP = (RZOI^2/ASP^2)*(PI/4);
            end
            if (ASP>=ASPLIMAB)
                NASPAB = 1.0;
            else
                NASPAB = (RZOIAB^2/ASP^2)*(PI/4);
            end
        end
        if (RMODE==0)  %SMOOTH-SMOOTH INTERACTION
            H = R - AG - AP + DELTA;
        elseif ((RMODE==1)||(RMODE==2))  %SMOOTH-ROUGH INTERACTION
            H = R - AG - AP + DELTA - ASP;
        elseif (RMODE==3)  %ROUGH-ROUGH INTERACTION
            H = R - AG - AP + DELTA - 0.5*(2*ASP+3^0.5*ASP); %THIRD TERM IS AVERAGE SEPARATION DISTANCE BETWEEN UNDERLYING SMOOTH SURFACES FOR OPPOSED AND COMPLIMENTARY ASPERITY PACKING
        end
        
        %         DETERMINE UNIT VECTORS
        ENX = (X-Xm0)/R;
        ENY = (Y-Ym0)/R;
        ENZ = (Z-Zm0)/R;
        
        %%         INCREMENT BULK OR NEAR SURFACE TRAJECTORY TIME, TRACK PARTICLE TO STUCK INDICATOR if IN NEAR SURFACE DOMAIN
        if (H>2.0E-7)
            AFRACT = -1; %reset AFRACT if away from surface
            if (HFLAG==2)    %particle coming from near surface
                TNEAR = TNEAR + dT;
                dT = MULTB*dTMRT; %change dT after accumulating timestep from near surface
                HFLAG = 1; %flag particle in bulk
                if (IREF1>200) %calc NSVEL if near surf. res. time signific.
                    %         		  CALCULATE ENTRY AND EXIT PROJECTION ON GRAIN
                    ENXEP = Xm0+ENXENTER*AG;
                    ENYEP = Ym0+ENYENTER*AG;
                    ENZEP = Zm0+ENZENTER*AG;
                    ENXP = Xm0+ENX*AG;
                    ENYP = Ym0+ENY*AG;
                    ENZP = Zm0+ENZ*AG;
                    %DETERMINE CHORD TRAVELED IN NEAR SURFACE VISIT
                    CHORD = ((ENXEP-ENXP)^2.0+(ENYEP-ENYP)^2.0+(ENZEP-ENZP)^2.0)^0.5;
                    %DETERMINE ANGLE (THETA) BETWEEN PROJECTED ENTRY AND EXIT (RADIANS)
                    %= 2arcsin(c/2AG) where c is the chord and AG is the grain radius
                    %our chord is already normalized to AG so remove AG in above formula
                    %https://en.wikipedia.org/wiki/Circular_segment
                    NSTHETA =  2.0*(asin(CHORD/(2.0*AG))); % ANGLE IN RADIANS;
                    NSARC = AG*NSTHETA;
                    %ACCUMULATE DISTANCE TRAVELED IN NEAR SURFACE VISIT
                    NSDIST = NSDIST+NSARC;
                    %CALCULATE AVERAGE NEAR SURFACE VELOCITY
                    NSVEL = NSDIST/TNEAR;
                end
                IREF1 = 0; %reset IREF1 if particle leaves near surface
            elseif (HFLAG==1)
                TBULK = TBULK+dT;
            end
        elseif ((H<=2.0E-7)&&(H>HFRIC))    %H IS IN NEAR SURFACE
            if (HFLAG==1)    %particle is coming from bulk
                TBULK = TBULK + dT;
                dT = MULTNS*dTMRT; %change dT after accumulating timestep from bulk
                HFLAG = 2; %flag particle in near surface
                NSVISIT = NSVISIT + 1; %COUNT NUMBER OF VISITS TO NEAR SURFACE FROM BULK
                %SET NORMAL UNIT VECTOR FOR ENTRANCE TO NEAR SURFACE FOR CALCULATING AVERAGE VELOCITY
                ENXENTER = ENX;
                ENYENTER = ENY;
                ENZENTER = ENZ;
                RENTER = R;
                % save near surface enter locations to array
                XINNS(J)=X;
                YINNS(J)=Y;
                ZINNS(J)=Z; 
                % activate near surface detailed plot only once
                if NSplot==0
                    NSplot = 1;
                end
            elseif (HFLAG==3)    %particle is coming from friction
                TFRIC = TFRIC + dT;
                dT = MULTNS*dTMRT; %change dT after accumulating timestep from friction
                HFLAG = 2; %flag particle in near surface
                IREF2 = 0; %reset friction IREF
                %SET NORMAL UNIT VECTOR FOR ENTRANCE TO NEAR SURFACE FOR CALCULATING AVERAGE VELOCITY
                ENXENTER = ENX;
                ENYENTER = ENY;
                ENZENTER = ENZ;
                RENTER = R;
            elseif (HFLAG==2)    %particle is coming from near surface
                TNEAR = TNEAR + dT; %NEAR SURFACE RESIDENCE TIME
                %                 NUMBER OF CONSECUTIVE TIME STEPS IN NEAR SURFACE
                L = L+1;
                %                 CALCULATE AVERAGE NEAR-SURFACE SEPARATION DISTANCE
                HSUM = H + HSUM;
                HAVE = HSUM/L;
                %CALCULATE AVERAGE NEAR SURFACE VELOCITY
                %NOTE: BULK TANGENTIAL VELOCITY IS NOT INCLUDED EVEN if COLLOID CROSSES NEAR-SURFACE BOUNDARY MULTIPLE TIMES
                %                  NSVEL = (NSDIST+0.5*(RENTER+R)*2*asin(0.5*((ENXENTER-ENX)^2.0+(ENYENTER-ENY)^2.0+(ENZENTER-ENZ)^2.0)^0.5))/TNEAR;
            end
            
            if (IREF1==0)    %IDENTifY REFERENCE POINT AND TIME
                XREF1 = X;
                YREF1 = Y;
                ZREF1 = Z;
                TREF1 = 0.0;
                IREF1 = 1;
            else
                IREF1 = IREF1 + 1;
                TREF1 = TREF1 + dT;
                if (IREF1>1000)
                    DREF1 = ((X-XREF1)*(X-XREF1)+(Y-YREF1)*...
                        (Y-YREF1)+(Z-ZREF1)*(Z-ZREF1))^0.5;  %COMPARE REFERENCE DISTANCE TO DifFUSION ONLY DISPLACEMENT
                    if (VN>VT)
                        DCOEF = FUN1;
                    else
                        DCOEF = FUN4;
                    end
                    DIND3 = (6.0*DCOEF*KB*T*TREF1/M3)^0.5;
                    DIND1 = DFACTNS*(6.0*DCOEF*KB*T*TREF1/M3)^0.5; %SCALE DISPLACEMENT TO DifFUSION (WITHOUT DIFFSCALE)
                    if ((DREF1<DIND1)&&(H>5*HFRIC))... %DON'T FORCE REMAIN DURING DETACH
                            ||(abs(Z+R)<=AP/2)  %TAG AS REMAIN IF AT REAR FLOW STAG ZONE
                        ATTACHK = 5; %RETENTION WITHOUT CONTACT IN NEAR SURFACE
                    else
                        IREF1 = 0;
                    end
                end %If IREF>1000
            end %if IREF1==0
            
        elseif ((H<=2.0E-7)&&(H<=HFRIC))    %particle is in friction
            if (HFLAG==2)   %particle coming from near surface
                TNEAR = TNEAR + dT;
                dT = MULTC*dTMRT; %change dT after accumulating timestep from near surface
                HFLAG = 3; %flag particle in friction
                if (IREF1>200)
                    %         		  CALCULATE ENTRY AND EXIT PROJECTION ON GRAIN
                    ENXEP = Xm0+ENXENTER*AG;
                    ENYEP = Ym0+ENYENTER*AG;
                    ENZEP = Zm0+ENZENTER*AG;
                    ENXP = Xm0+ENX*AG;
                    ENYP = Ym0+ENY*AG;
                    ENZP = Zm0+ENZ*AG;
                    %DETERMINE CHORD TRAVELED IN NEAR SURFACE VISIT
                    CHORD = ((ENXEP-ENXP)^2.0+(ENYEP-ENYP)^2.0+(ENZEP-ENZP)^2.0)^0.5;
                    %DETERMINE ANGLE (THETA) BETWEEN PROJECTED ENTRY AND EXIT (RADIANS)
                    %= 2arcsin(c/2AG) where c is the chord and AG is the grain radius
                    %our chord is already normalized to AG so remove AG in above formula
                    %https://en.wikipedia.org/wiki/Circular_segment
                    NSTHETA =  2.0*(asin(CHORD/(2.0*AG))); % ANGLE IN RADIANS;
                    NSARC = AG*NSTHETA;
                    %ACCUMULATE DISTANCE TRAVELED IN NEAR SURFACE VISIT
                    NSDIST = NSDIST+NSARC;
                    %CALCULATE AVERAGE NEAR SURFACE VELOCITY
                    NSVEL = NSDIST/TNEAR;
                end
                FRICVISIT = FRICVISIT + 1; %count number of visits to friction
            elseif (HFLAG==3)
                TFRIC = TFRIC + dT; %friction residence time
            end
            if (H<H0)
                ATTACHK = 6; %Flag if particle runs into surface
            end
            if (ATTMODE==0)    %attachment by perfect sink
                ATTACHK = 2;
            else %TORQUE BALANCE MODE FOR ATTACHMENT AND DETACHMENT
                if ((UT==0.0)&&(ARRESTFLAG==1))    %UR=0.0 AND COLLOID HAS REACHED EQUILIBRIUM SEPARATION (FADH~FREP)
                    ATTACHK = 2; %PARTICLE ARRESTS
                end
                if (IREF2==0)    %IDENTifY REFERENCE POINT AND TIME
                    XREF2 = X;
                    YREF2 = Y;
                    ZREF2 = Z;
                    TREF2 = 0.0;
                    IREF2 = 1;
                else
                    IREF2 = IREF2 + 1;
                    TREF2 = TREF2 + dT;
                    if (IREF2>30)    %COMPARE REFERENCE DISTANCE TO DifFUSION ONLY DISPLACEMENT
                        DREF2 = ((X-XREF2)*(X-XREF2)+(Y-YREF2)*(Y-YREF2)+(Z-ZREF2)*(Z-ZREF2))^0.5;
                        if (VN>VT)
                            DCOEF = FUN1;
                        else
                            DCOEF = FUN4;
                        end
                        DIND2 = DFACTC*(6.0*DCOEF*KB*T*TREF2/M3)^0.5; %SCALE DISPLACEMENT TO DifFUSION (WITHOUT DIFFSCALE)
                        if (DREF2<DIND2)
                            ATTACHK = 4; %RETENTION WITH CONTACT
                        else
                            IREF2 = 0;
                        end
                    end
                end %FOR if IREF2==0
            end %FOR ATTMODE==0
        end %FOR H<2.0E-7
        %%         EXIT CONDITION if PARTICLE IS IN BULK FLUID
        % Exit only lower hemisphere if gravity align with flow
        if (R>RB)&&(Z<0.0)&&(cbPZ==1||cbMZ==1)
            ATTACHK = 1;
        end
        % reflect if in upper hemisphere
        if (R>RB)&&(Z>=0.0)&&(cbPZ==1||cbMZ==1)
            X=XO;
            Y=YO;
            Z=ZO;
        end
        % Exit any hemisphere after 5% of ZINIT if gravity orthogonal to flow
        if (R>RB)&&(Z<ZINIT*0.95)&&(cbPX==1||cbMX==1)
            ATTACHK = 1;
        end
        
        %         FINISH TRAJECTORY if PARTICLE STILL IN THE SYSTEM WHEN TOTAL TIME IS REACHED (NO STAGNANT)
        if (PTIMEF>TTIME)
            ATTACHK = 3;
        end
        %
        %         SKIP FORCE AND INTEGRATION if PARTICLE RESOLVES
        if (ATTACHK==0)
            %             DETERMINE UNIT VECTORS
            ENX = (X-Xm0)/R;
            ENY = (Y-Ym0)/R;
            ENZ = (Z-Zm0)/R;
            %             DETERMINE FORCES
            %
            %%            CALCULATE COLLOIDAL FORCE
            %             USED SPHERE-SPHERE GEOMETRY (VIOLATES LINEAR APROXIMATION APPROACH,
            %             REASONABLE FOR LARGE COLLECTOR RADII)
            %             CALCULATE EDL
            
            %   FAVORABLE CONDITIONS IF BULK ZETAC AND ZETAP ARE OPPOSITE IN SIGN, THEN SET SCOV = 0.0 AND SCOVP = 0.0
            if or(and(ZETACST>=0.0,ZETAPST<=0.0),and(ZETACST<=0.0,ZETAPST>=0.0))
                SCOV = 0.0;
                SCOVP = 0.0;
            end
            %   UNDER UNFAVORABLE CONDITIONS HETERODOMIANS WILL BE SIMULATED IN EITHER COLLECTOR (HETC), OR COLLOID (HETP), OR BOTH
            %   TO CALCULATE HETC AND HETP FRACTIONAL AREAS WITHIN ZOI, HETERODOMAINS WILL BE PROJECTED ONTO THE FRAME OF REFERENCE
            %   WITH X-Y PLANE MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER
            if and(or(SCOV>0.0,SCOVP>0.0),I==1)
                %   CALCULATE PROJECTION OF COLLOID CENTER ON HAPPEL SPHERE
                XG = Xm0+ENX*AG;
                YG = Ym0+ENY*AG;
                ZG = Zm0+ENZ*AG;
                AFRACT = 0.0;
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
            elseif and(or(SCOV>0.0,SCOVP>0.0),I>1) %and(or(SCOV>0.0,SCOVP>0.0),I==1)
                %   CALCULATE PROJECTION OF COLLOID CENTER ON HAPPEL SPHERE
                XG = Xm0+ENX*AG;
                YG = Ym0+ENY*AG;
                ZG = Zm0+ENZ*AG;
                AFRACT = 0.0;
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
                %   HETEROGENEITY ON COLLOID (HETP) SUBROUTINE TO DETERMINE HETERODOMAIN PROJECTIONS
                %   HETP PROJECTIONS WILL BE GENERATED ASSUMING THAT THE COLLOID CENTER COINCIDES WITH THE HAPPEL SPHERE CENTER
                %   HETP WILL BE TRANSLATED TO THE COLLECTOR FRAME OF REFERENCE AND
                %   ROTATED BASED ON COLLOID SPHERICAL COORDINATES, FOR FRONT-END PLOTTING
                %   HETP PROJECTIONS WILL BE TRANSLATED AND ROTATED TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING
                %   THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER, TO CALCULATE AFRAC
                [MHETP_PLOT,MPRO_AF] = HETP_TRANSFORM(X,Y,Z,XG,YG,ZG,THETA,PHI,MHETP,MPRO);
            end %and(or(SCOV>0.0,SCOVP>0.0),I==1)
            %   CALCULATE HETERODOMAINS INFLUENCE
            if and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
                %   HETEROGENEITY ON COLLECTOR (HETC) SUBROUTINE TO DETERMINE CLOSEST HETERODOMAIN TO COLLOID
                %   HETC WILL BE TRANSLATED TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER
                if (SCOV>0.0)
                    [XHET,YHET,ZHET,RHET] = HAPHETTRACK(X,Y,Z,Xm0,Ym0,Zm0,AG,...
                        HETMODE,SCOV,RHET0,RHET1,RHET2,0);
                    [XHET_AF,YHET_AF,ZHET_AF] = HETC_TRANSFORM(XG,YG,ZG,THETA,PHI,XHET,YHET,ZHET);
                    RHET_AF = RHET;
                else
                    XHET_AF = 0.0;
                    YHET_AF = 0.0;
                    ZHET_AF = 0.0;
                    RHET_AF = 0.0;
                end
                %   INITIALIZE FRACTIONAL AREAS
                AFRACT = 0.0; %TOTAL ATTRACTIVE FRACTIONAL AREA
                AFRACT_PZ = 0.0; %PRO-ZOI FRACTIONAL AREA
                AFRACT_ZH = 0.0; %ZOI-HET FRACTIONAL AREA
                AFRACT_PZH = 0.0; %PRO-ZOI-HET FRACTIONAL AREA
                AFRACT_Z = 0.0; %ZOI FRACTIONAL AREA NON-OVERLAPPED
                %   CALCULATE OVERLAPING AREA OF HETERODOMAINS AND ZOI
                %   GIVEN THAT THE PROJECTION OF COLLOID CENTER CORRESPONDS TO THE ORIGIN OF THE FRAME OF REFERENCE WITH X-Y PLANE
                %   MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER, VARIABLES
                %   EQUAL TO 0.0 MUST BE PASSED TO THE FIRST TWO POSITIONS OF SUBROUTINE FRACTIONAL_AREA
                [AF_PZ,AF_ZH,AF_PZH,AF_Z] = HAREAFRACT(Xm0,Ym0,RZOI,Xm0,Ym0,Zm0,MPRO_AF(:,[1,2,4]));
                AFRACT = AF_PZ;
                AFRACT_PZ = AF_PZ;
                for K=1:HETMODE
                    [AF_PZ,AF_ZH,AF_PZH,AF_Z] = HAREAFRACT(Xm0,Ym0,RZOI,XHET_AF(K),YHET_AF(K),RHET_AF(K),MPRO_AF(:,[1,2,4]));
                    AFRACT = AFRACT + AF_ZH; %TOTAL ATTRACTIVE FRACTIONAL AREA
                    if (AF_ZH >= 0.0)
                        AFRACT = AFRACT - AF_PZH; %TOTAL ATTRACTIVE FRACTIONAL AREA
                        AFRACT_PZ = AFRACT_PZ - AF_PZH; %PRO-ZOI FRACTIONAL AREA
                    end
                    AFRACT_ZH = AFRACT_ZH + AF_ZH; %ZOI-HET FRACTIONAL AREA
                    AFRACT_PZH = AFRACT_PZH + AF_PZH; %PRO-ZOI-HET FRACTIONAL AREA
                    AFRACT_Z = 1 - AFRACT_PZ - AFRACT_ZH - AFRACT_PZH; %ZOI FRACTIONAL AREA NON-OVERLAPPED
                    if and(AF_ZH>0.0,K==1)
                        HETTYPE = 1;
                    end
                    if or(HETMODE==5,HETMODE==9)
                        if ((AF_ZH>0.0)&&(HETTYPE==0)&&(K>1))
                            HETTYPE = 2;
                        end
                        if ((AF_ZH>0.0)&&(HETTYPE==1)&&(K>1))
                            HETTYPE = 4;
                        end
                    elseif (HETMODE==73)
                        if ((AF_ZH>0.0)&&(HETTYPE==0)&&(K>1&&K<=9))
                            HETTYPE = 2;
                        end
                        if ((AF_ZH>0.0)&&(HETTYPE==0)&&(K>9))
                            HETTYPE = 3;
                        end
                        if ((AF_ZH>0.0)&&(HETTYPE==1)&&(K>1&&K<=9))
                            HETTYPE = 4;
                        end
                        if ((AF_ZH>0.0)&&(HETTYPE==1)&&(K>9))
                            HETTYPE = 5;
                        end
                        if ((AF_ZH>0.0)&&(HETTYPE==2)&&(K>9))
                            HETTYPE = 6;
                        end
                    end
                end
                if (AFRACT>0.0)
                    %CALCULATE PRO-ZOI ATTRACTIVE CONTRIBUTION TO EDL FORCE
                    ZETAC = ZETACST;
                    ZETAP = ZETAHETP;
                    FEDL= HFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
                    FEDL_PZ = FEDL;
                    %CALCULATE ZOI-HET ATTRACTIVE CONTRIBUTION TO EDL FORCE
                    ZETAC = ZETAHET;
                    ZETAP = ZETAPST;
                    FEDL= HFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
                    FEDL_ZH = FEDL;
                    %CALCULATE PRO-ZOI-HET REPULSIVE CONTRIBUTION TO EDL FORCE
                    ZETAC = ZETAHET;
                    ZETAP = ZETAHETP;
                    FEDL= HFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
                    FEDL_PZH = FEDL;
                    %CALCULATE ZOI REPULSIVE CONTRIBUTION TO EDL FORCE
                    ZETAC = ZETACST;
                    ZETAP = ZETAPST;
                    FEDL= HFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
                    FEDL_Z = FEDL;
                    %CALCULATE NET EDL FORCE
                    FEDL =  AFRACT_PZ*FEDL_PZ + AFRACT_ZH*FEDL_ZH + AFRACT_PZH*FEDL_PZH + AFRACT_Z*FEDL_Z;
                else %(AFRACT>0.0)
                    ZETAC = ZETACST;
                    ZETAP = ZETAPST;
                    FEDL= HFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
                end %(AFRACT>0.0)
            else %and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
                ZETAC = ZETACST;
                ZETAP = ZETAPST;
                FEDL= HFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
            end %and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
            %
            %   CALCULATE VDW
            FVDW=HFORCEVDW (A132,AG,AP,ASP,NASP,RMODE,H,LAMBDAVDW,A11,...
                A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE);
            %   CALCULATE ACID-BASE, BORN, AND STERIC REPULSION
            FAB= HFORCEAB (PI,AG,AP,ASP,NASPAB,RMODE,LAMBDAAB,GAMMA0AB,H,H0);
            %             FAB = 0.0; %!!debugEP
            %   CALCULATE BORN FORCE
            FBORN=HFORCEBORN (A132,SIGMAC,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE);
            FSTE=HFORCESTE (PI,GAMMA0STE,LAMBDASTE,ASTE,H);
            %   CALCULATE COLLOIDAL FORCE
            FCOLL = FVDW + FEDL + FAB + FSTE + FBORN;
            %   CALCULATE DRAG FORCE
            %   CALCULATE FLUID VELOCITY AT GIVEN LOCATION BEFORE CALCULATING DRAG FORCE
            if (R<=RB)
                [VxH1,VyH1,VzH1]= HAPPELFF (X,Y,Z,B,K1,K2,K3,K4,AG);
                %                 fluid velocity component are dimensionless, scaled via VSUP
                VX = VxH1*(VSUP);
                VY = VyH1*(VSUP);
                VZ = VzH1*(VSUP);
            else
                VX = 0.0;
                VY = 0.0;
                VZ = -VSUP;
            end
            %           CALCULATE NORMAL AND TANGENTIAL FLOW VELOCITIES FROM 3D
            %           COMPONENTS
            VN = VX*ENX+VY*ENY+VZ*ENZ;
            VNX = VN*ENX;
            VNY = VN*ENY;
            VNZ = VN*ENZ;
            VTX = VX-VNX;
            VTY = VY-VNY;
            VTZ = VZ-VNZ;
            VT = (VTX*VTX+VTY*VTY+VTZ*VTZ)^0.5;
            %             DEFINE TANGENTIAL FLUID VELOCITY UNIT VECTORS FOR CARTESIAN COMPONENTS DETERMINED BELOW
            if (VT==0)
                ETX = 0.0;
                ETY = 0.0;
                ETZ = 0.0;
            else
                ETX = VTX/VT;
                ETY = VTY/VT;
                ETZ = VTZ/VT;
            end
            %%             UNIVERSAL HYDRODYNAMIC FUNCTIONS
            HBAR = (H+B)/AP;
            FUN1=1.0+B1*exp(-C1*HBAR)+D1*exp(-E1*HBAR^A1);
            FUN2=1.0+B2*exp(-C2*HBAR)+D2*exp(-E2*HBAR^A2);
            FUN3=1.0+B3*exp(-C3*HBAR)+D3*exp(-E3*HBAR^A3);
            FUN4=1.0+B4*exp(-C4*HBAR)+D4*exp(-E4*HBAR^A4);
            %%             NORMAL AND TANGENTIAL DRAG FORCES ARE CALCULATED WITH CORRECTED FUN2 AND FUN3 IN THE SUBROUTINE
            [FDRGN,FDRGT]=HFORCEDRAG (FUN2,FUN3,FUN4,M3,VN,VT);
            %%             CALCULATE DifFUSION FORCE
            [FDIFX,FDIFY,FDIFZ]=HFORCEDIFF(DIFFSCALE,PI,VISC,AP,KB,T,dT);
            if (H<=HFRIC)
                % DifFUSION FORCES EQUAL TO ZERO IN CONTACT
                FDIFX=0.0;
                FDIFY=0.0;
                FDIFZ=0.0;
            end
            %%          CALCULATE LifT FORCE
            FLifT=HFORCELIFT (RHOW,R,AP,AG,VT,UT,OMEGA);
            %%          BREAK FORCES INTO CARTESIAN COMPONENTS
            %           WHEN EXAMINING NORMAL AND TANGENTIAL: POSITIVE NORMAL IS AWAY FROM THE SURFACE,
            %           NEGATIVE NORMAL IS TOWARDS THE SURFACE
            %           GRAVITATIONAL
            %% calculate gravity
            % gravity direction EGX EGY EGZ is set at the beginning of this code
            % depending on GUI input (cbMZ cbPZ cbMX cbPX)
            % the function below projects cartesian gravity toward normal and
            % tangential axes. +Normal points away from the collector surface,
            % -Normal points towards collector surface
            % +tangential is aligned with tangential velocity from Happel flow field
            % -tangential is opposed to tangential velocity from Happel flow field 
            [FGN,FGT,FGNX,FGNY,FGNZ,FGTX,FGTY,FGTZ]= HFUNGVECT(FG,EGX,EGY,EGZ,ENX,ENY,ENZ,ETX,ETY,ETZ);
            %%             COLLOIDAL
            FCOLLX=FCOLL*ENX;
            FCOLLY=FCOLL*ENY;
            FCOLLZ=FCOLL*ENZ;
            %             DRIVING DRAG FORCE
            FDRGNX=FDRGN*ENX;
            FDRGNY=FDRGN*ENY;
            FDRGNZ=FDRGN*ENZ;
            FDRGTX=FDRGT*ETX;
            FDRGTY=FDRGT*ETY;
            FDRGTZ=FDRGT*ETZ;
            FDRGX = FDRGNX + FDRGTX;
            FDRGY = FDRGNY + FDRGTY;
            FDRGZ = FDRGNZ + FDRGTZ;
            %            LifT
            FLifTX=FLifT*ENX;
            FLifTY=FLifT*ENY;
            FLifTZ=FLifT*ENZ;
            %           DifFUSION FORCES OPERATE WHEN NOT IN CONTACT
            FDifN=FDIFX*ENX+FDIFY*ENY+FDIFZ*ENZ;
            FDifNX=FDifN*ENX;
            FDifNY=FDifN*ENY;
            FDifNZ=FDifN*ENZ;
            FDifTX=(FDIFX-FDifNX);
            FDifTY=(FDIFY-FDifNY);
            FDifTZ=(FDIFZ-FDifNZ);
            
            %%          INTEGRATE
            %             INTEGRATION ADDS AN EXTRA TERM TO ACCOUNT FOR FLOW DISTURBANCE
            %             DUE TO PRESENCE OF STATIONARY PARTICLE,
            %             REF. MA ET AL. 2009 SI -Hemispheres-in-cell geometry to predict colloid deposition in porous media
            %	        INTEGRATE NORMAL AND TANGENTIAL(X,Y,Z) FORCES TO PARTICLE VELOCITIES
            %
            %             STEADY STATE FORMULATION
            %        	    UNX = (FUN1/M3)*(FGNX+FCOLLX+FDifNX+FLifTX+FDRGNX)
            %        	    UNY = (FUN1/M3)*(FGNY+FCOLLY+FDifNY+FLifTY+FDRGNY)
            %        	    UNZ = (FUN1/M3)*(FGNZ+FCOLLZ+FDifNZ+FLifTZ+FDRGNZ)
            %
            %             UTX = (FUN4*(FGTX+FDifTX)+FDRGTX)/M3
            %             UTY = (FUN4*(FGTY+FDifTY)+FDRGTY)/M3
            %             UTZ = (FUN4*(FGTZ+FDifTZ)+FDRGTZ)/M3
            
            %            SAVE VELOCITIES FROM PREVIOUS TIME STEP
            if (I==2)    %NEED TO APPLY AT  I=2 SINCE FIRST TRANSLATION IS ALREADY DONE
                UN = UX*ENX+UY*ENY+UZ*ENZ;
                UNX = UN*ENX;
                UNY = UN*ENY;
                UNZ = UN*ENZ;
                UTX = UX-UNX;
                UTY = UY-UNY;
                UTZ = UZ-UNZ;
            end
            UXO = UNX + UTX;
            UYO = UNY + UTY;
            UZO = UNZ + UTZ;
            UN = UXO*ENX+UYO*ENY+UZO*ENZ;
            UNXO = UN*ENX;
            UNYO = UN*ENY;
            UNZO = UN*ENZ;
            UTXO = UXO-UNXO;
            UTYO = UYO-UNYO;
            UTZO = UZO-UNZO;
            %%            INTEGRATION UTILIZING AN IMPLICIT APPROACH, I.E., RESISITNG DRAG PARTICLE VELOCITY CORRESPONDS
            %             TO THE FUTURE LOCATION WHILE FORCES CORRESPOND TO ACTUAL LOCATION.
            %             expLICIT APPROACH WAS DISCARDED BECAUSE THE MODEL BECOMES UNSTABLE AND EXTREMELY DEPENDENT ON dT
            %
            UNX = ((MP+VM)*UNXO+(FGNX+FCOLLX+FDifNX+FLifTX+FDRGNX)*dT)/...
                (MP+VM+M3/FUN1*dT);
            UNY = ((MP+VM)*UNYO+(FGNY+FCOLLY+FDifNY+FLifTY+FDRGNY)*dT)/...
                (MP+VM+M3/FUN1*dT);
            UNZ = ((MP+VM)*UNZO+(FGNZ+FCOLLZ+FDifNZ+FLifTZ+FDRGNZ)*dT)/...
                (MP+VM+M3/FUN1*dT);
            %             NORMAL VELOCITY IS NEGATIVE if THE VELOCITY VECTOR POINTS
            %                         TO THE COLLECTOR WHEN PROJECTED ON THE COLLOID POSITION VECTOR
            if (ENX*UNX+ENY*UNY+ENZ*UNZ)<0
                UN = -(UNX^2+UNY^2+UNZ^2)^0.5;
            else
                UN = (UNX^2+UNY^2+UNZ^2)^0.5;
            end
            %%             TANGENTIAL VELOCITY FROM MA ET AL. 2009 EQUATION S14
            if (H>HFRIC)
                UTX = ((MP+VM)*UTXO+(FGTX+FDifTX+FDRGTX)*dT)/...
                    (MP+VM+M3/FUN4*dT);
                UTY = ((MP+VM)*UTYO+(FGTY+FDifTY+FDRGTY)*dT)/...
                    (MP+VM+M3/FUN4*dT);
                UTZ = ((MP+VM)*UTZO+(FGTZ+FDifTZ+FDRGTZ)*dT)/...
                    (MP+VM+M3/FUN4*dT);
                UT = (UTX^2+UTY^2+UTZ^2)^(0.5);
                %TANGENTIAL VELOCITY IS NEGATIVE if THE TANGENTIAL VELOCITY VECTOR POINTS
                %TO THE ENTRANCE OF THE CELL (+Z) WHEN PROJECTED ON THE
                %Z-AXIS
                if -UTZ<0
                    UT = -(UTX^2+UTY^2+UTZ^2)^0.5;
                else
                    UT = (UTX^2+UTY^2+UTZ^2)^0.5;
                end
                %FIT OMEGA*AP/UT AS FUNCTION OF H/AP USING GCB 1967b TABLES 2&3
                OMEGA = abs(UT)/AP*(0.5518+117.4*(H/AP))/(1+232.1*(H/AP)+237.7*(H/AP)^2.0);
            end
            %
            %%             INTEGRATION if PARTICLE IS IN CONTACT
            if (H<=HFRIC)
                %                 CALCULATE NORMAL ADHESIVE AND REPULSIVE FORCES FOR RESISTING TORQUE
                FADH = FVDW + FEDL + FGN + FLifT + FDRGN;
                FREP = FBORN;
                if (FAB<0.0)
                    FADH = FADH + FAB;
                else
                    FREP = FREP + FAB;
                end
                if (FSTE<0.0)
                    FADH = FADH + FSTE;
                else
                    FREP = FREP + FSTE;
                end
                % Is FADH becomes positive (repulsive), set to zero
                if (FADH>0.0)
                    FADH = 0.0;
                else
                    % SINCE ATTRACTIVE FORCES ARE NEGATIVE IN SIGN, FLIP THE SIGN OF FADH TO MAKE IT POSITIVE
                    FADH = -FADH;
                end
                if (RLEV<=ACONT)
                    RLEV = ACONT; %LARGER RESISTING LEVER ARM DUE TO DEFORMATION THAN ROUGHNESS
                end
                %                 CALCULATE COEFFICIENT OF ROLLING FRICTION if WORK OF ADHESION IS ATTRACTIVE
                %                 FORCE AND TORQUE COMPONENTS FROM GCB 1967A/B AS H/AP GOES TO 0
                FSHRT = 1.7005;
                TSHRY = 0.9440;
                FTRT = (8.0/15.0)*log(H/AP)-0.9588;
                FROT = -(2.0/15.0)*log(H/AP)-0.2526;
                TTRY = -(1.0/10.0)*log(H/AP)-0.1895;
                TROY = (2.0/5.0)*log(H/AP)-0.3817;
                %INTEGRATE TANGENTIAL VELOCITY
                %FG AND FDifF TANGENTIAL are currently not included in the tangential torque balance                 
                %However, adding FGT for gravity oriented in +-Z is trivial. Whereas when gravity os orineted in the XY plane
                % we need to develop the math.
                %This is a point for future exploration
                UTO = (UTXO*UTXO+UTYO*UTYO+UTZO*UTZO)^0.5;
                %THE TERM IN THE VELOCITY INTEGRATION APPEAR ALL POSITIVE, RESISTING FORCES AND TORQUES NEGATIVE SIGN IS DETERMINED BY THE
                %DIMENSIONLESS HYDRODYNAMIC CORRECTION FACTOR CALCULATED ABOVE, THE NORMAL FORCE MUST BE NEGATIVE (ATRACTIVE) FOR ADHESION TO OCCUR (EQUAL TO ATRACTIVE COLLOIDAL FORCES)
                %TANGENTIAL VELOCITY FROM MA ET AL. 2011 EQUATION S6 - NOTE THAT MISTAKES ARE CORRECTED
                UT = (1.4*(MP+VM)*UTO-FADH*RLEV/AP*(AP-DELTA)/AP*dT+...
                    6.0*PI*VISC*(AP-DELTA)*VT*dT*(FSHRT+2.0/3.0*AP/(H+AP)*TSHRY))...
                    /(1.4*(MP+VM)-6.0*PI*VISC*(AP-DELTA)*dT*(FTRT+FROT+4.0/3.0*(TTRY+TROY)));
                %                 ASSIGN NEGATIVE TANGENTIAL VELOCITY AS ZERO
                if (UT<0.0)
                    UT = 0.0;
                    ARRESTFLAG = 1;
                end
                %                 RESET ARRESTFLAG if COLLOID IS NOT IN EQUILIBRIUM
                %                   if ((FADH<0.995*FREP)||(FADH>1.005*FREP))
                if ((FADH<0.95*FREP)||(FADH>1.05*FREP))
                    ARRESTFLAG = 0;
                end
                UTX = ETX*UT;
                UTY = ETY*UT;
                UTZ = ETZ*UT;
                %                 NO SLIP SO OMEGA*AP/UT=1
                OMEGA = UT/AP;
            end %(H<HFRIC)
            %
            %             RECOMPOSE CARTESIAN VELOCITIES
            UX=UNX+UTX;
            UY=UNY+UTY;
            UZ=UNZ+UTZ;
        else %ATTACHK>0
            %             STORE FINAL TRAJECTORY VALUES
            %               XOT(OUTCOUNT) = X;
            %               YOT(OUTCOUNT) = Y;
            %               ZOT(OUTCOUNT) = Z;
            %               ROT(OUTCOUNT) = R;
            %               IOT(OUTCOUNT) = I;
            %               HOT(OUTCOUNT) = H;
            %               FCOLLOT(OUTCOUNT) = FCOLL;
            %               FEDLOT(OUTCOUNT) = FEDL;
            %               FVDWOT(OUTCOUNT) = FVDW;
            %               FDRGXOT(OUTCOUNT) = FDRGX;
            %               FDRGYOT(OUTCOUNT) = FDRGY;
            %               FDRGZOT(OUTCOUNT) = FDRGZ;
            %               FDIFXOT(OUTCOUNT) = FDIFX;
            %               FDIFYOT(OUTCOUNT) = FDIFY;
            %               FDIFZOT(OUTCOUNT) = FDIFZ;
            %               UXOT(OUTCOUNT) = UX;
            %               UYOT(OUTCOUNT) = UY;
            %               UZOT(OUTCOUNT) = UZ;
            %               VXOT(OUTCOUNT) = VX;
            %               VYOT(OUTCOUNT) = VY;
            %               VZOT(OUTCOUNT) = VZ;
            %               PTIMEFOT(OUTCOUNT) = PTIMEF;
            %               AFRACTOT(OUTCOUNT) = AFRACT;
            %
            %% check
            OUTCOUNT = OUTCOUNT+1;
            IOT(OUTCOUNT) = I;
            XOT(OUTCOUNT) = X;
            YOT(OUTCOUNT) = Y;
            ZOT(OUTCOUNT) = Z;
            ROT(OUTCOUNT) = R;
            HOT(OUTCOUNT) = H;
            ETIMEOT(OUTCOUNT) = ETIME;
            PTIMEFOT(OUTCOUNT) = PTIMEF;
            FCOLLOT(OUTCOUNT) = FCOLL;
            FVDWOT(OUTCOUNT) = FVDW;
            FEDLOT(OUTCOUNT) = FEDL;
            FDRGXOT(OUTCOUNT) = FDRGX;
            FDRGYOT(OUTCOUNT) = FDRGY;
            FDRGZOT(OUTCOUNT) = FDRGZ;
            FDIFXOT(OUTCOUNT) = FDIFX;
            FDIFYOT(OUTCOUNT) = FDIFY;
            FDIFZOT(OUTCOUNT) = FDIFZ;
            FABOT(OUTCOUNT) = FAB;
            FSTEOT(OUTCOUNT) = FSTE;
            FBORNOT(OUTCOUNT) = FBORN;
            FDRGTOT(OUTCOUNT) = FDRGT;
            UTOT(OUTCOUNT) = UT;
            UNOT(OUTCOUNT) = UN;
            VTOT(OUTCOUNT) = VT;
            VNOT(OUTCOUNT) = VN;
            FDRGNOT(OUTCOUNT) = FDRGN;
            FGTOT(OUTCOUNT) = FGT;
            FGNOT(OUTCOUNT) = FGN;
            FLIFTOT(OUTCOUNT) = FLifT;
            ACONTOT(OUTCOUNT) = ACONT;
            RZOIOT(OUTCOUNT) = RZOI;
            UXOT(OUTCOUNT) = UX;
            UYOT(OUTCOUNT) = UY;
            UZOT(OUTCOUNT) = UZ;
            VXOT(OUTCOUNT) = VX;
            VYOT(OUTCOUNT) = VY;
            VZOT(OUTCOUNT) = VZ;
            AFRACTOT(OUTCOUNT) = AFRACT;
            %% REVERT TO PREVIOUS POSITION IN CONTACT MODE SINCE FINAL STEP UT<0
            if ((ATTMODE==1)&&(ATTACHK==2))
                XOT(OUTCOUNT) = XO;
                YOT(OUTCOUNT) = YO;
                ZOT(OUTCOUNT) = ZO;
                IOT(OUTCOUNT) = IO;
                HOT(OUTCOUNT) = HO;
            end
        end %if ATTACHK==0
        %% display progress
        if(I==2)
            if ATTMODE==-1
                msg = sprintf(format7001,J,JP(J),I,Z,H,AFRACT);
                disp(msg)
            else
                msg = sprintf(format6001,J,I,Z,H,AFRACT);
                disp(msg)
            end
            
        end
        if(ATTACHK>0)
            if ATTMODE==-1
                msg = sprintf(format7002,J,JP(J),I,Z,H,AFRACT,ATTACHK,ATTACHKP(J));
                disp(msg)
            else
                msg = sprintf(format6002,J,I,Z,H,AFRACT,ATTACHK);
                disp(msg)
            end
        end
    end %TRAJECTORY LOOP (ATTACHK=0)
    %% plot final contact visualization
    if ATTACHK==6&&detplot==1
        figure(fDcontact)
        plot3(0,0,0,'ob')
        title ('Colloid crashed. Consider reducing near surface time step multiplier.')
        drawnow
        % close previus generated contact figure
        if J>1
            close(fDcontactOLD)
        end
    end
    if (ATTACHK==2||ATTACHK==4)&&detplot==1
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
        % close previous contact figure (if simulating mnore than one
        % colloid)
        if J>1
            close(fDcontactOLD)
        end
        % draw wire sphere for colloid as reference
        [xw,yw,zw]=sphere(200);
        xw=xw*AP+X; yw=yw*AP+Y; zw=zw*AP+Z;
        % plot geometry
        figure(fDcontact)
        subplot(1,2,1)
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
        subp=[1,2,1];
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
        end
        roughspheresHet(@hetpaint,@colloidHetPaint,fDcontact,subp,xcap,ycap,zcap,XHET,YHET,ZHET,RHET,xs,ys,zs,X,Y,Z,AG,AP,res,numaspAG,colflag,RMODE)
        %roughspheresHet(fD,subp,xcap,ycap,zcap,XHET,YHET,ZHET,RHET,xs,ys,zs,X,Y,Z,AG,AP,res,numasp,colflag,RMODE)
        %% drawn roughness hemispheres on colloid (colflag=2)
        colflag = 2;
        roughspheresHet(@hetpaint,@colloidHetPaint,fDcontact,subp,xcapcol,ycapcol,zcapcol,MHETP_PLOT(:,1),MHETP_PLOT(:,2),MHETP_PLOT(:,3),MHETP_PLOT(:,4),xs,ys,zs,X,Y,Z,AG,AP,res,numaspAP,colflag,RMODE)
        %           roughspheresHet(fD,subp,xcapcol,ycapcol,zcapcol,XHETP,YHETP,ZHETP,RHETP,xs,ys,zs,X,Y,Z,AG,AP,res,numasp,colflag,RMODE)
        %%
        % plot center of cap from angles
        z1=cos(thetap)*AG;
        x1=cos(phip)*rxys;
        y1=sin(phip)*rxys;
        %%
        subplot(1,2,2)
        surf(xc,yc,zc,'FaceColor','none')
        drawnow
        hold on
        plot3(X,Y,Z,'ok','MarkerFaceColor',colcolor,'MarkerSize',10)
        axis ([-1.5*AG 1.5*AG -1.5*AG 1.5*AG -1.5*AG 1.5*AG])
        axis square
        %% generate colloid ring and zoi to visualizae colloid border and zoi
        [xcirc,ycirc,zcirc,xzoi,yzoi,zzoi]=colloid_circle(X,Y,Z,AP,AG,RZOI);
        figure(fDcontact)
        subplot(1,2,1)
        %         plot3(xcirc,ycirc,zcirc,'.','MarkerEdgeColor',colcolor)
        plot3(xzoi,yzoi,zzoi,'.','MarkerEdgeColor',colcolor,'MarkerSize',10)
        %% hold off plots
        figure(fDcontact)
        title (' ')
        drawnow
        subplot(1,2,1)
        hold off
        subplot(1,2,2)
        hold off
        %%
    end
    %%       WRITE ARRAY TO FILES
    %       write attachk flag value and labels
    fprintf(TRAJEX,format105,ATTACHK);
    fprintf(TRAJEX,format106);
    fprintf(TRAJATT,format105,ATTACHK);
    fprintf(TRAJATT,format106);
    fprintf(TRAJREM,format105,ATTACHK);
    fprintf(TRAJREM,format106);
    
    %       WRITE DATA TO FLUX AND TRAJECTORY FILES
    % replace J with old J for perturbation mode
    if (ATTMODE == -1)
        jpart = JP(J);
    else
        jpart = J;
    end
    if (ATTACHK==1)  %EXIT TRAJECTORY FILE TO CLUSTER
        for K=1:OUTCOUNT
            fprintf(TRAJEX,format107,IOT(K),XOT(K),YOT(K),ZOT(K),ROT(K),HOT(K),...
                ETIMEOT(K),PTIMEFOT(K),FCOLLOT(K),FVDWOT(K),FEDLOT(K),...
                FABOT(K),FSTEOT(K),FBORNOT(K),UTOT(K),UNOT(K),VTOT(K),...
                VNOT(K),FDRGTOT(K),FDRGNOT(K),FDIFXOT(K),FDIFYOT(K),...
                FDIFZOT(K),FGTOT(K),FGNOT(K),FLIFTOT(K),ACONTOT(K),...
                RZOIOT(K),AFRACTOT(K));
        end
        %           WRITE TO FLUX FILE
        fprintf(FLUXEX,format207,jpart,ATTACHK,XINIT,...
            YINIT,RINJ,ZINIT,...
            RINIT,HINIT,X,...
            Y,Z,R,...
            H,ETIME,PTIMEFOT(1),...
            PTIMEF,TBULK,TNEAR,...
            TFRIC,NSVISIT,FRICVISIT,...
            ACONT,RZOI,AFRACT,...
            HETTYPE,HETFLAG,NSVEL,...
            HAVE,XINNS(jpart),YINNS(jpart),...
            ZINNS(jpart));
    end
    %
    if ((ATTACHK==2)||(ATTACHK==4)||(ATTACHK==6))   %ATTACHED PARTICLE
        for K=1:OUTCOUNT
            fprintf(TRAJATT,format107,IOT(K),XOT(K),YOT(K),ZOT(K),ROT(K),HOT(K),...
                ETIMEOT(K),PTIMEFOT(K),FCOLLOT(K),FVDWOT(K),FEDLOT(K),...
                FABOT(K),FSTEOT(K),FBORNOT(K),UTOT(K),UNOT(K),VTOT(K),...
                VNOT(K),FDRGTOT(K),FDRGNOT(K),FDIFXOT(K),FDIFYOT(K),...
                FDIFZOT(K),FGTOT(K),FGNOT(K),FLIFTOT(K),ACONTOT(K),...
                RZOIOT(K),AFRACTOT(K));
        end
        %           WRITE TO FLUX FILE
        fprintf(FLUXATT,format207,jpart,ATTACHK,XINIT,...
            YINIT,RINJ,ZINIT,...
            RINIT,HINIT,X,...
            Y,Z,R,...
            H,ETIME,PTIMEFOT(1),...
            PTIMEF,TBULK,TNEAR,...
            TFRIC,NSVISIT,FRICVISIT,...
            ACONT,RZOI,AFRACT,...
            HETTYPE,HETFLAG,NSVEL,...
            HAVE,XINNS(jpart),YINNS(jpart),...
            ZINNS(jpart));
    end
    %
    if ((ATTACHK==3)||(ATTACHK==5))   %REMAINING PARTICLE
        for K=1:OUTCOUNT
            fprintf(TRAJREM,format107,IOT(K),XOT(K),YOT(K),ZOT(K),ROT(K),HOT(K),...
                ETIMEOT(K),PTIMEFOT(K),FCOLLOT(K),FVDWOT(K),FEDLOT(K),...
                FABOT(K),FSTEOT(K),FBORNOT(K),UTOT(K),UNOT(K),VTOT(K),...
                VNOT(K),FDRGTOT(K),FDRGNOT(K),FDIFXOT(K),FDIFYOT(K),...
                FDIFZOT(K),FGTOT(K),FGNOT(K),FLIFTOT(K),ACONTOT(K),...
                RZOIOT(K),AFRACTOT(K));
        end
        %           WRITE TO FLUX FILE
        fprintf(FLUXREM,format207,jpart,ATTACHK,XINIT,...
            YINIT,RINJ,ZINIT,...
            RINIT,HINIT,X,...
            Y,Z,R,...
            H,ETIME,PTIMEFOT(1),...
            PTIMEF,TBULK,TNEAR,...
            TFRIC,NSVISIT,FRICVISIT,...
            ACONT,RZOI,AFRACT,...
            HETTYPE,HETFLAG,NSVEL,...
            HAVE,XINNS(jpart),YINNS(jpart),...
            ZINNS(jpart));
    end
    %
    %% OUTPUT PLOTS
    % plot hetdomains interacting with attached colloid if pertinent
    if AFRACT>0.0&&(ZETAPST*ZETACST>0.0)&&SCOV>0.0
        % activate hetdomains drawing flag
        hetdraw = 1;
    else
        hetdraw = 0;
    end
    %% save exit time for release colloids in perturbation mode
    if ATTMODE ==-1
        perATT(J)=ATTACHK; %save resolved status of each particle
        perTIME(J+1)=PTIMEF; %start from index 2 to save first positio to time zero
    end
    %generate release and remaining percentage vectors
    if J==NPARTLOOP&&ATTMODE==-1
        %preallocate
        perREL = zeros(1,NPARTLOOP+1);%have extra elemento to include initial element for time zero
        perREM = zeros(1,NPARTLOOP+1);
        % set initial state
        perREL(1)=0.0; perREM(1)=100.0; perTIME(1)=0.0;
        % populate arrays
        %start copunters
        nrel = 0; nrem = NPARTLOOP;
        for k=1:NPARTLOOP
            if perATT(k)==1 %||perATT(k)==5 %! discuss this criteria
                nrel = nrel+1;
                nrem = nrem-1;
                perREL(k+1)=(nrel+1)/NPARTLOOP*100;
                perREM(k+1)=(nrem-1)/NPARTLOOP*100;
            else
                perREL(k+1)=(nrel)/NPARTLOOP*100;
                perREM(k+1)=(nrem)/NPARTLOOP*100;
            end
        end
    end
    % plot trajectories and reset arrays values
    nfig = 1;
    [XOT,YOT,ZOT,HOT]=HAPplottraj(J,NPARTLOOP,perTIME,perREL,perREM,...
        ATTMODE,XOT,YOT,ZOT,HOT,XINIT,YINIT,ZINIT,RLIM,AP,AG,RB,...
        ATTACHK,MAXVAL,hetdraw,HETMODE,XHET,YHET,ZHET,RHET,nfig);
    % plot all heterodomains at the end of simulation
    if ipart==1
        % draw rlim circle if loading mode
        if ATTMODE~=-1
            HAPcircle(0.0,0.0,RLIM,nfig)
        end
        % draw collector sphere
        [xe,ye,ze] = sphere;
        figure (nfig+1)
        surf (xe*AG,ye*AG,ze*AG,'EdgeAlpha',0.1,'FaceAlpha',0)
        if hetdraw==1
            %             JETplothetsurf(HETMODE,SCOV,RHET0,RHET1,REXIT)
        end
    end
    %% close trajectory files
    fclose(TRAJEX);
    fclose(TRAJATT);
    fclose(TRAJREM);
    %% save and close simplots if apply
    
    if saveSIMPLOT ==1&&simplot==1
        % save and close transport figure(dashboard)
        savefig (fT,filefT);
        close (fT);
    end
    if saveSIMPLOT==0&&simplot==1
        % close detailed dashboard (transport) and near surface figures
        close (fT);
        pause(2);
    end
    if saveSIMPLOT ==1&&detplot==1
        % save and close close (fT); near surface figure
        savefig (fDnear,filefDnear);
        close (fDnear);
        % save close (fT); contact figure
        savefig (fDcontact,filefContact);
    end
    if saveSIMPLOT ==0&&detplot==1
        close (fDnear);
        pause(2);
    end
    
    
    
    
    
    %update progress bar
    waitbar(double(J)/double(NPARTLOOP))
    %% count etas
    if ATTACHK==2
        ceta2=ceta2+1;
    end
    if ATTACHK==4
        ceta4=ceta4+1;
    end
    if ATTACHK==5
        ceta5=ceta5+1;
    end
    if ATTACHK==6
        ceta6=ceta6+1;
    end
end %LOOP TO NEXT PARTICLE
%% calculate etas
eta2 = ceta2/(double(NPARTLOOP)*RB^2/RLIM^2);
eta4 = ceta4/(double(NPARTLOOP)*RB^2/RLIM^2);
eta5 = ceta5/(double(NPARTLOOP)*RB^2/RLIM^2);
eta6 = ceta6/(double(NPARTLOOP)*RB^2/RLIM^2);
%% save figures
if ATTMODE~=-1
    fig1 = strcat(workdir,'Fig1_Rlim_Plane');
    savefig (1,fig1);
end
fig2 = strcat(workdir,'Fig2_Happel_Geometry_3D');
savefig (2,fig2);
fig3 = strcat(workdir,'Fig3_HvsZ_2D');
savefig (3,fig3);
fig4 = strcat(workdir,'Fig4_HvsZ_2D_zoom_in');
savefig (4,fig4);
% close all files
fclose('all');
% close progress bar
waitbar(1)
close(pbar)
% stop simulation clock
toc
%% HAPPEL trajectory code ends
end

