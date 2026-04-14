function AFM_happel()
% PROGRAM TO SIMULATE PARTICLE TRAJECTORIES IN HAPPEL CELL GEOMETRY
%% CLEAR VARIABLES AND WINDOWS
% fighandles will close any figure windows that is not the gui
clc;
figHandles = findobj('type', 'figure', '-not', 'name', 'Happel_GUI');
close(figHandles);
%%  start sim clock
tic;
% set switch to single calc for afract for heterogeneity
% single_afract = 1; single calculation calculation of afract entering near
% surface
% single_afract = 0; calculation of afract on every translation on near
% surface;
% works in combination with variable het_afract_calculated, to indicate
% that one calculaton of afract was performed in the trajecotry loop
% do not delete single_afract or het_afract_calculated
single_afract = 1;
% start progress bar
pbar = waitbar(0,'Simulating AFM force profiles..','Position', [50 500 290 50]);
%% declare global variables ( have included physical constants and
% any parameter read from input file
global NPART ATTMODE CLUSTER VJET VSUP RLIM POROSITY AG TTIME...
    AP RHOP RHOW VISC ER T IS ZI ZETAPST ZETACST ZETAHET HETMODE RHET0...
    RHET1 RHET2 SCOV ZETAHETP HETMODEP RHETP0 RHETP1 SCOVP...
    A132 LAMBDAVDW VDWMODE A11 AC1C1 A22 AC2C2 A33...
    T1 T2 GAMMA0AB LAMBDAAB GAMMA0STE LAMBDASTE B RMODE ASPcolloid ASPdomain ASP2...
    KINT W132 BETA DIFFSCALE GRAVFACT MULTB MULTNS MULTC DFACTNS DFACTC...
    NOUT PRINTMAX NPARTPERT cbPZ cbMZ cbPX cbMX simplotCHECK detplotCHECK finput workdir...
    LTLT concav HSMOOTH

% from perturbation loaded particles
global  NPARTatt NPARTrem ATTACHKP XOUTP YOUTP ZOUTP ROUTP HOUTP JP
global simplot detplot saveSIMPLOT
% globals for output
global HOT FCOLLOT HVECTOR FVDWOT FEDLOT FABOT FSTEOT FBORNOT AFRACTOT
global mxhetPLOT  myhetPLOT mrhetOUT
global LAT1V LAT2V
global LAT1loc LAT2loc
global HFRIC HMIN Hlow Hhigh
global NPARTLOOP LAT1aux LAT2aux

HVECTOR = [];
HSMOOTH = [];
HS = [];

%% factor to limit aspetities contributions based on H threshold
% Hthreshold = 1/LTLT*ASP ( asperity on collector or domain)
% LTLT represents the threshold factor between H and a (where a equals the
% smaller radius among AP AG and ASP)
LTLT = 1;

% save asperity arrays if there are not too many
asp_max_number = 100;



%% initialize etas and eta counters
global eta2 eta4 eta5 eta6 RB
ceta2 = 0; ceta4 = 0; ceta5 = 0; ceta6=0;
%%  READ INPUT FILE
% % global variables must match the ones read via FUNCread_input
% % define input file name
% inputfile = finput;
% % uses read_input function
% DATAIN = HFUNCread_input(inputfile);
%% SET MAXIMUM NUMBER OF VALUES PER VECTOR
MAXVAL =int32(50000);                               %MAXIMUM NUMBER OF VALUES IN ARRAYS
%% DEFINE OTHER VARIABLES (DOUBLE)
X = double(0);
[Y,Z,H,R,XO,YO,ZO,HO,Xm0,Ym0,Zm0,JX,JY]=deal(X);  %SPATIAL COORDINATES
[XINIT,YINIT,ZINIT,HINIT,RINJ,RJET,AXMAX] =deal(X);      %INITIAL COORDINATES
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
%% hardwire AG  for AFM mode as a 10^9 factor of AP
AG = 1e9*AP;
% other hardwire parameters
NOUT = 5000;
simplot = 0;
detplot = 0;
VJET = 0.0;
GRAVFACT = 1.0;
cbMZ = 1.0;
cbPZ = 0.0;
cbMX = 0.0;
cbPX = 0.0;
DIFFSCALE = 1.35;
MULTB = 1.0;
MULTNS = 1.0;
MULTC = 1.0;
ATTMODE = 1.0;
%% CHECK superficial velocity sign (read as VJET from main GUI code)
% model is set for -Z flow direction
if VJET>0.0
    VSUP = VJET;
else
    VSUP = -VJET;
end
%
%%    INITIALIZE RANDOM NUMBER GENERATOR SEED (for rand and randn) injection and diffusion calcs
%     in MATLAB if a common seed is needed then use rng(seed)R.g. rng(7654321),
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
% PP = (1-POROSITY)^(1.0/3.0);
% WW = 2.0-3.0*PP+3.0*PP^5.0-2.0*PP^6.0;
% K1 = 1/WW;
% K2 = -(3.0+2.0*PP^5.0)/WW;
% K3 = (2.0+3.0*PP^5.0)/WW;
% K4 = -PP^5.0/WW;
% %     FLUID SHELL RADIUS
% RB = AG/((1-POROSITY)^(1.0/3.0));
% %     FLUID SHELL THICKNESS
% SHELL = RB-AG;
%     CALCULATE KAPPA NOTE: IS FOR 1:1 ELECTROLYTE ONLY
ERE0 = ER*E0;            %ABSOLUTE PERMITTIVITY
NIO = IS*2*6.02214086E23;
KAPPA = ((ECHG^2.0)*NIO*(ZI^2.0)/(ERE0*KB*T))^0.5;
%   CALCULATE RZOIBULK: RADIUS OF ZONE OF INFLUENCE WITHOUT DEFORMATION
RZOIBULK = 2.0*((1/KAPPA)*AP)^0.5;
% activate flag to indicate small colloid relative to collector asperities
concav = 0;
if RZOIBULK<=2*ASPdomain
    concav=1;
end
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
% initialize empty arrays for roughness asperities locations
xcap = []; ycap = []; zcap = []; %colloid asperities
xasp_domain= []; yasp_domain= []; zasp_domain= []; % domain asperities
%     CALCULATE HFRIC - SEPARATION AT WHICH WE CONSIDER CONTACT TO OCCUR AND ZERO SLIP. DEFORMATION STARTS TO OCCUR FOR SEPARATION DISTANCES SMALLER
%                       THAN THIS VALUE. WE DEFINE THIS DISTANCE TO BE THAT WHERE EACH OF THE CONTACT FORCES HAVE REACHED 0.01% OF THEIR VALUE AT
%                       VACUUM MINIMUM SEPARATION OF 0.158 NM
H = H0;
ASP0 = 0.0;
NASP0 = 0.0;
RMODE0 = 0;
FBORN=AFMFORCEBORN (A132,SIGMAC,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE);
FSTE=AFMFORCESTE (PI,GAMMA0STE,LAMBDASTE,ASTE,H);
FAB= AFMFORCEAB (PI,AG,AP,ASP0,NASP0,RMODE0,LAMBDAAB,GAMMA0AB,H,H0);
FBORNFRIC = 0.0001*FBORN;
FSTEFRIC = 0.0001*FSTE;
FABFRIC = 0.0001*FAB;
%     CALCULATE HFRIC -
% determine HFRIC as the H at which repulsive contact forces
% decay 1/10000 of their H0 value. HFRIC is farther away than HMIN
while ((FBORN>FBORNFRIC)||(FSTE>FSTEFRIC)||(abs(FAB)>abs(FABFRIC)))
    H = H + 1.0E-12;
    FBORN=AFMFORCEBORN (A132,SIGMAC,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE);
    FSTE=AFMFORCESTE (PI,GAMMA0STE,LAMBDASTE,ASTE,H);
    FAB= AFMFORCEAB (PI,AG,AP,ASP0,NASP0,RMODE0,LAMBDAAB,GAMMA0AB,H,H0);
    
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
    % ignore roughness
    while (FCOLL>0.0)
        HMIN = H;
        H = H + 1.0E-12;
        %         FVDW=AFMFORCEVDW (A132,AG,AP,ASP0,NASP0,RMODE0,H,LAMBDAVDW,A11,...
        %             A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE);
        %
        [FVDW,FVDW2,Hasp_colloid,Hasp_domain]=AFMFORCEVDW (X,Y,Z,A132,AG,AP,ASPcolloid,ASPdomain,NASP0,RMODE0,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,H,HS,LAMBDAVDW,A11,...
            A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE,@AFM_asp_tracking_RMODE3);
        
        
        %FEDL =AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETACST,ZETAPST,AG,AP,ASP0,NASP0,RMODE0,H,PI);
        FEDL =AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETACST,ZETAPST,AG,AP,ASPcolloid,ASPdomain,NASP0,RMODE0,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
        
        %FAB= AFMFORCEAB (PI,AG,AP,ASP0,NASP0,RMODE0,LAMBDAAB,GAMMA0AB,H,H0);
        FAB= AFMFORCEAB (PI,AG,AP,ASPcolloid,ASPdomain,RMODE,LAMBDAAB,GAMMA0AB,H,H0,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
        FBORN=AFMFORCEBORN (A132,SIGMAC,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE);
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
%     TRAJECTORY LOOP
%%  SET NUMBER OF PARTICLES depending on parallel or single computer version
% hardwire cluster and pert to 0 for initial MATLAB ported code
CLUSTER = 0;
NPARTLOOP = NPART*NPART;
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
    'HAVE(m)\r\n'];

format207 =['%d %15.8E %15.8E '...
    '%15.8E %15.8E %15.8E '...
    '%15.8E %15.8E %15.8E '...
    '%15.8E %15.8E %15.8E '...
    '%15.8E %15.8E %15.8E '...
    '%15.8E %15.8E %15.8E '...
    '%15.8E %15d %15d '...
    '%15.8E %15.8E %15.8E '...
    '%15.8E %15.8E %15.8E '...
    '%15.8E\r\n'];




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
%Add button where user specifies the axis on which to drive the colloid
%toward the collector (x,y,or z)!!!!
%AXstring = get handle!!!!
AXstring = 'y';
%% initialize array size
% Z range parameters
HSPAN = 5.0e-7; %maximum separation distance (m)
% HMIN is calculated above as the minimum separation due to atractive
% forces were deformation is maximal
% Hlow is  + ROUGHNESS
% Hhigh is Hlow+HSPAN
% geometric factor to step size from ZMAX to ZMIN
% has to be >1.0
GFACT = 1.01;
% % define range,
Hlow = HMIN;
Hhigh = Hlow+HSPAN;
% create locations vector in H
HVECTOR(1)=Hhigh;
i=1;
while HVECTOR(i)>Hlow
    i=i+1;
    HVECTOR(i)=HVECTOR(i-1)/GFACT;
end
HVECTOR(end)=Hlow;
HSMOOTH = HVECTOR; %keep data estructure only, HSMOOTH AND HVECTOR are recalculated below if needed 
%number of locations
nsteps =length(HVECTOR);
%% initialize vector arrays based on nsteps
%% DEFINE ARRAYS FIRST, PREALLOCATE FOR SPEED
XOT = NaN(nsteps,NPARTLOOP); YOT=XOT; ZOT=XOT; ROT=XOT;     %PARTICLE POSITION
IOT = XOT;                                                  %STEP NUMBER
HOT = XOT; ETIMEOT=XOT;                                     %SEPARATION DISTANCE
FCOLLOT=XOT; FVDWOT=XOT; FEDLOT=XOT;                        %DLVO FORCES
FABOT=XOT; FSTEOT=XOT; FBORNOT=XOT;                         %ACID BASE STERIC AND BORN FORCES
FDRGXOT=XOT; FDRGYOT=XOT; FDRGZOT=XOT;                      %DRAG FORCE CARTESIAN
FDRGTOT=XOT; FDRGNOT=XOT;                                   %DRAG FORCE NORMAL-TANGENIAL
FDIFXOT=XOT; FDIFYOT=XOT; FDIFZOT=XOT;                      %DifFUSION FORCE
FGTOT=XOT; FGNOT=XOT; FLIFTOT=XOT;                          %GRAVITY AND LIFT
UXOT=XOT; UYOT=XOT; UZOT=XOT;                               %PARTICLE VELOCITY CARTESIAN
UTOT=XOT; UNOT=XOT;                                         %PARTICLE VELOCITY NORMAL-TANGENIAL
VXOT=XOT; VYOT=XOT; VZOT=XOT;                               %FLUID VELOCITY CARTESIAN
VTOT=XOT; VNOT=XOT;                                         %FLUID VELOCITY NORMAL-TANGENIAL
PTIMEFOT=XOT; AFRACTOT=XOT;                                 %TRAJ TIME AND FRACTION OF HET/ZOI OVERLAP
ACONTOT=XOT; RZOIOT=XOT;                                    %CONTACT AREA; ZONE OF INFLUENCE RADIUS;
XHET=zeros(100,1);                                          %COLLECTOR HET LOCATIONS
YHET=XHET; ZHET=XHET; RHET=XHET;                            %COLLECTOR HET LOCATIONS
XHETP=zeros(10000000,1);                                    %COLLOID HET LOCATIONS
YHETP=XHETP; ZHETP=XHETP; RHETP=XHETP;                      %COLLOID HET LOCATIONS
%% define probe locations in a regular grid
% intialize location vectors
% changed XINITV,YINITV to LAT1V,LAT2V !!!!
LAT1V = NaN(1,NPARTLOOP);
LAT2V = LAT1V;
RINJV = LAT1V;
ugrid = 1;
% random probe locations (circle)
if ugrid ==0
    for j=1:NPARTLOOP
        % changed x,y to lat1,lat2 !!!!
        [LAT1V(j),LAT2V(j),RINJV(j)]=AFMINITIAL (RLIM);
    end
end
% uniform probe locations (square)
if ugrid==1
     % changed x,y to lat1,lat2 !!!!
    LAT1lim = linspace(-RLIM/2,RLIM/2,NPART);
    LAT2lim = linspace(-RLIM/2,RLIM/2,NPART);
%     LAT1lim = linspace(-RLIM,0,NPART);
%     LAT2lim = linspace(-RLIM,0,NPART);
    [LAT1loc,LAT2loc]=meshgrid(LAT1lim,LAT2lim);
    [nr,nc]=size(LAT1loc);
    j=1;
    for im=1:nr
        for jm=1:nc
            % changed x,y to lat1,lat2 !!!!
            LAT1V(j) = LAT1loc(im,jm);
            LAT2V(j) = LAT2loc(im,jm);
            j=j+1;
        end
    end
    % changed x,y to lat1,lat2 !!!!
    RINJV = (LAT1V.*LAT1V+LAT2V.*LAT2V).^0.5;
end
%% initialize hetdomains on AFMdomain output matrices
nhetDOM = 100;
rangeHetV = NaN(1,NPARTLOOP);
mxhetOUT = NaN(nhetDOM,NPARTLOOP);
myhetOUT = mxhetOUT;
mzhetOUT = mxhetOUT;
mrhetOUT = mxhetOUT;
%
%%  set parameters for ROUGH surfaces
if RMODE>0
    fzoi = 1;
else
    if RMODE==1||RMODE==3
        % calculate fzoi as a function of asperities and zoi
        ratio_asp_colloid = (RZOIBULK/ASPcolloid);
        %
        if ratio_asp_colloid<3
            fzoi = 2.0;
        else
            fzoi = 1.0;
        end
    end
    
    if RMODE==2||RMODE==3
        % calculate fzoi as a function of asperities and zoi
        ratio_asp_domain = (RZOIBULK/ASPdomain);
        %
        if ratio_asp_domain<3
            fzoi = 2.0;
        else
            fzoi = 1.0;
        end
    end
    
end
% generate colloid asperities for RMODE 1 and 3
if RMODE ==1||RMODE==3
    % asperity generation COLLOID
    % uniform asperities locations
    % single size
    %use arc lenght to describe uniform grid spaced on spherical (colloid)
    % the chord formed on the colloid surface with 2 adjacent asperities equals
    % to 2*ASP
    % calculate 2 asp arc from chord
    angasp = 2*asin(ASPcolloid/AP);
    %arc = angasp/2/pi*AP;
    % calculate aproximate zoi arc valid only across range of  ZOI
    % corresponding to 1 to 100 mM IS
    angzoi = (2*asin(RZOIBULK/AP));
    %ARCZOI = angzoi/2/pi*AP;
    [xcap0,ycap0,zcap0]=AFMsphere_capEQ(AP,angasp,angzoi,fzoi,RZOIBULK);
end
% prealocate array for visual representation of asperities
if RMODE==2||RMODE==3
    mat_asp_domx = NaN(asp_max_number,NPARTLOOP);
    mat_asp_domy = mat_asp_domx;
    mat_asp_domz = mat_asp_domx;
    range_mat_asp = NaN(1,NPARTLOOP);
end
%% LOOP THROUGH PARTICLES  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NPARTLOOP = 6; %test debug
%initialize release data vectors for loading and perturbation mode
perTIME=0.0; perREL=0.0; perREM=0.0;

for J = 1:NPARTLOOP
    seed = int32(0);                                    %RANDOM NUMBER PARAMETER
    if (CLUSTER==0)
        ipart = J;
    end
   
    %% Particle intial set up prior to injection, differentiate between loading and perturbation simulation
    % test debug
    FADH=1e-10; FREP=1e-10;
    %% SET INITIAL PARTICLE TIME (EVENLY DISTRIBUTED THROUGH TIME FOR FLUX) SET MAXIMUM INJECTION TIME HALF OF TOTAL SIMULATION TIME
    HFLAG =1;
    ACONT = 0.0;
    %% convert HVECTOR TO XYZ coordinates (AXVECTOR)
    % define range, updating the coordinates to collector center
    HINIT =Hlow;
    if RMODE==0 %smooth surfaces
        AXVECTOR = HVECTOR+AP+AG;
        AXMAX=max(AXVECTOR);
    end
    if RMODE==1%roughnes on one surface colloid(1)
        % minimum separation distance corresponds to asperities on
        % colloid relative to flat domain
        AXVECTOR = HVECTOR+AP+AG+ASPcolloid;
        AXMAX=max(AXVECTOR);
    end
    if RMODE==2 %roughnes on one surface domain(2)
        % set probe location in XZ plane
        X = LAT1V(J);
        Z = LAT2V(J);
        % for this RMODE2 actual local separation distances are considered to
        % allow colloid translation in between domain asperities.
        % same strategy needs to be properly set for all other RMODEs
        % generate domain asperities array
        [xasp_domain,yasp_domain,zasp_domain]=AFM_asp_tracking(X,Y,Z,AG,fzoi,RZOIBULK,ASPdomain);
        %% calculation of HVECTOR for  a given location. Translate colloid towards
        % surface following y axis until crash occurs on rough domain for a given xz position
        % HVECTOR parallel to the axis of translation.
        % i.e. from 200nm to H0
        % HVECTOR is the separation distance along the axis of trasnlation
        % H = 0 occurs at actual contact with the asperity
        % AXVECTOR is the correspongin colloid positions with HVECTOR
        %Hasp_domain is the array of
        % local actual separation distances between surfaces
        ntest = 2000;  %number of translations for testing crash
        HSPAN = 2e-7;
        HVECTOR = linspace(HSPAN,H0,nsteps);
        % RSPAN is the added maximummheight of asperities
        % RSPAN = ASPcolloid; % for RMODE 1
        RSPAN = ASPdomain; % for RMODE 2
        % RSPAN = ASPdomain+ASPcolloid; % for RMODE 3
        % plane of efective contact (highest asperity height)
        AXVECTORtest = linspace(HSPAN+RSPAN,H0,ntest)+AP+AG;
        % set crash_flag = 0; no crash
        crash_flag = 0;
        % reset crash index in array as minimum separatioin distance position
        cindex = ntest;
        for i=1:ntest
            Y=AXVECTORtest(i);
            % calculate separation distances colloid to asperities
            % vectorized calculation for array of separation distances
            % array of distances between asperity centers and colloid center
            RXYZ = ((X-xasp_domain).*(X-xasp_domain)+(Y-yasp_domain).*(Y-yasp_domain) + (Z-zasp_domain).*(Z-zasp_domain)).^0.5;
            % factor of projection on  Y component (array)
            facY =  (Y-AG)./RXYZ;
            % separation distance between asperity and colloid surface
            Hasp_domain = RXYZ-AP-ASPdomain;
            c=Hasp_domain<=H0;
            % seapration distance between asperity and smooth surface in between
            % asperities
            cs = Y-AP-AG<=H0;
            if cs==0
                % check for crash
                if sum(c)>=1&&crash_flag==0
                    % reset flag
                    crash_flag = 1;
                    cindex = i-1;
                    % disp(ycrash-AP-AG)
                    % save crash distance array
                    crash_Hasp_domain = Hasp_domain;
                end
                if crash_flag==0
                    % save domain before crash
                    precrash_Hasp_domain=Hasp_domain;
                end
            end
        end
        
        % produce array of AXVECTOR with corrected bounds to prevent crash
        if crash_flag == 1
            % minimum sep distance with no crash is calculate from asperity at
            % which crash occurs
            % find minimun sep in array
            [hminasp,iminasp]=min(precrash_Hasp_domain);
            % calculate crash point on asperity surface
            % asperity coordinate
            xad = xasp_domain(iminasp);
            yad = yasp_domain(iminasp);
            zad = zasp_domain(iminasp);
            % calculate Y colloid coordinate at crash X,Z are fixed in AFM
            Xcrash = X;
            Zcrash = Z;
            Ycrash = ((AP+ASPdomain)^2-((xad-Xcrash)*(xad-Xcrash)+(zad-Zcrash)*(zad-Zcrash)))^0.5+yad;
            % calculate contact point on asperity surface
            %     d=((xad-Xcrash)*(xad-Xcrash)+(yad-Ycrash)*(yad-Ycrash)+(zad-Zcrash)*(zad-Zcrash))^0.5;
            d = AP+ASPdomain;
            xcont = AP*(xad-Xcrash)/d+Xcrash;
            ycont = AP*(yad-Ycrash)/d+Ycrash;
            zcont = AP*(zad-Zcrash)/d+Zcrash;
            % determinbe HSMOOTH
            HSMOOTH = Ycrash-AP-AG+HVECTOR;
            % if HSMOOTH reports crash with smooth surface then  recalculate
            if min(HSMOOTH)<=H0
                HSMOOTH = HVECTOR;
                Ycrash = AG+AP+H0;
                %disp('no crash');
            else
                %disp('crash');
            end
            % determine AXVECTOR
            AXVECTOR = Ycrash+HVECTOR;
        else
            % if no crash with asperities occurs means that colloid tranlation is
            % aligned in between 4 large domain asperities,in a SCP array. Not likely but
            % possible
            %minimum sep distance is H0
            Xcrash = X;
            Zcrash = Z;
            Ycrash = AG+AP+H0;
            xcont = X;
            ycont = Ycrash;
            zcont = Z;
            %HSMOOTH = HVECTOR
            HSMOOTH = HVECTOR;
            % determine AXVECTOR
            AXVECTOR = Ycrash+HVECTOR;
            %disp('no crash');
        end
        % calcualte Hsmooth(separation distance distance to smooth collector)
        HminSMOOTH = Ycrash-AG-AP;
        disp(HminSMOOTH)
        % end calculation of crash estimation in translation
        AXMAX=max(AXVECTOR);
        % savea YCRASH vector
        YcrashVEC(J)=Ycrash;
    end
    if RMODE==3 %roughness on both surfaces colloid and collector
        % in the case that asperities are of different size,determined by
        % the smaller one
        AXVECTOR = HVECTOR+AP+AG+ASPcolloid+ASPdomain;
        AXMAX = max(AXVECTOR);
    end
    
    
    %% INITIALIZE LOCATION OF PARTICLES
    RINJ = RINJV(J);
    % changed to ifs setting XINIT,YINIT,ZINIT to LAT1,LAT2, or AXMAX depending on which axis is
    % normal AXstring!!!!
    if AXstring=='x'
        YINIT = LAT1V(J);
        ZINIT = LAT2V(J);
        XINIT = AXMAX;
    end
    if AXstring=='y'
        XINIT = LAT1V(J);
        ZINIT = LAT2V(J);
        YINIT = AXMAX;
    end
    if AXstring=='z'
        XINIT = LAT1V(J);
        YINIT = LAT2V(J);
        ZINIT = AXMAX;
    end
    
    
    
    %% Intialize locations in cartesian system
    % no change here!!!!
    X = XINIT;
    Y = YINIT;
    Z = ZINIT;
    H = HVECTOR(1);
    HS = HSMOOTH(1);
    R = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0)+(Z-Zm0)*(Z-Zm0))^0.5;
    % Rxy for 2D plot only
    Rxy = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0))^0.5;
    % alternate displayed trajectory directions in 2D circle
    if mod(J,2)==0
        Rxy = -Rxy;
    end
    
    %SET FLUID VELOCITY COMPONENTS AND COLLOID NORMAL VELOCITY
    VX = 0.0;
    VY = 0.0;
    VZ = -VSUP;
    UZ = VZ;
    
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

    if RMODE==1||RMODE==3
        % translaste colloid asperities array relative to colloid position
        xcap = xcap0+X;
        ycap = ycap0+Y;
        zcap = zcap0+Z;
    end
    if RMODE==2||RMODE==3
        % generate domain asperities
        [xasp_domain,yasp_domain,zasp_domain]=AFM_asp_tracking(X,Y,Z,AG,fzoi,RZOIBULK,ASPdomain);
        if length(xasp_domain)<=asp_max_number
            % save to array
            range_mat_asp(J) =length(xasp_domain);
            mat_asp_domx(1:range_mat_asp(J),J) = xasp_domain;
            mat_asp_domy(1:range_mat_asp(J),J) = yasp_domain;
            mat_asp_domz(1:range_mat_asp(J),J) = zasp_domain;
        end
        
    end
    
    % CALCULATE COLLOIDAL FORCES
    % CALCULATE FVDW
    [FVDW,FVDW2,Hasp_colloid,Hasp_domain]=AFMFORCEVDW (X,Y,Z,A132,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,H,HS,LAMBDAVDW,A11,...
    A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE,@AFM_asp_tracking_RMODE3); 

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
        [MHETP, MPRO]=AFMHETTRACKP(Xm0,Ym0,Zm0,H,RZOIBULK,AP,HETMODEP,SCOVP,RHETP0,RHETP1);
        %   HETP WILL BE TRANSLATED TO THE COLLECTOR FRAME OF REFERENCE AND
        %   ROTATED BASED ON COLLOID SPHERICAL COORDINATES, FOR FRONT-END PLOTTING
        %   HETP PROJECTIONS WILL BE TRANSLATED AND ROTATED TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING
        %   THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER, TO CALCULATE AFRACT
        [MHETP_PLOT,MPRO_AF] = AFMHETP_TRANSFORM(X,Y,Z,XG,YG,ZG,THETA,PHI,MHETP,MPRO);
    end
   
    %   CALCULATE HETERODOMAINS INFLUENCE IN EDL
    if and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
        %   HETEROGENEITY ON COLLECTOR (HETC) SUBROUTINE TO DETERMINE CLOSEST HETERODOMAIN TO COLLOID
        %   HETC WILL BE TRANSLATED TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER
        if (SCOV>0.0)
            
            [XHET,YHET,ZHET,RHET] = AFMHETTRACK(X,Y,Z,Xm0,Ym0,Zm0,AG,HETMODE,SCOV,RHET0,RHET1,RHET2,0);
            [XHET_AF,YHET_AF,ZHET_AF] = AFMHETC_TRANSFORM(XG,YG,ZG,THETA,PHI,XHET,YHET,ZHET);
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
        [AF_PZ,AF_ZH,AF_PZH,AF_Z] = AFMAREAFRACT(Xm0,Ym0,RZOI,Xm0,Ym0,Zm0,MPRO_AF(:,[1,2,4]));
        AFRACT = AF_PZ;
        AFRACT_PZ = AF_PZ;
        for K=1:HETMODE
            [AF_PZ,AF_ZH,AF_PZH,AF_Z] = AFMAREAFRACT(Xm0,Ym0,RZOI,XHET_AF(K),YHET_AF(K),RHET_AF(K),MPRO_AF(:,[1,2,4]));
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
            %FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
            FEDL=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
            
            FEDL_PZ = FEDL;
            %CALCULATE ZOI-HET ATTRACTIVE CONTRIBUTION TO EDL FORCE
            ZETAC = ZETAHET;
            ZETAP = ZETAPST;
            %FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
            FEDL=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
            
            FEDL_ZH = FEDL;
            %CALCULATE PRO-ZOI-HET REPULSIVE CONTRIBUTION TO EDL FORCE
            ZETAC = ZETAHET;
            ZETAP = ZETAHETP;
            %FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
            FEDL=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
            
            FEDL_PZH = FEDL;
            %CALCULATE ZOI REPULSIVE CONTRIBUTION TO EDL FORCE
            ZETAC = ZETACST;
            ZETAP = ZETAPST;
            %FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
            FEDL=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
            
            FEDL_Z = FEDL;
            %CALCULATE NET EDL FORCE
            FEDL =  AFRACT_PZ*FEDL_PZ + AFRACT_ZH*FEDL_ZH + AFRACT_PZH*FEDL_PZH + AFRACT_Z*FEDL_Z;
        else %(AFRACT>0.0)
            ZETAC = ZETACST;
            ZETAP = ZETAPST;
            %FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
            FEDL=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,...
                NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
            
            
        end %(AFRACT>0.0)
        
    else %and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
        AFRACT = -1.0;
        ZETAC = ZETACST;
        ZETAP = ZETAPST;
        %FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
        
        FEDL=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,...
            NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
        
        
    end %and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
    
    %FAB= AFMFORCEAB (PI,AG,AP,ASP,NASPAB,RMODE,LAMBDAAB,GAMMA0AB,H,H0);
    FAB= AFMFORCEAB (PI,AG,AP,ASPcolloid,ASPdomain,RMODE,LAMBDAAB,GAMMA0AB,H,H0,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
    
    
    %         FAB = 0.0; % !!debugEP
    
    FBORN=AFMFORCEBORN (A132,SIGMAC,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE);
    
    FSTE=AFMFORCESTE (PI,GAMMA0STE,LAMBDASTE,ASTE,H);
    FCOLL = FVDW + FEDL + FAB + FBORN + FSTE;
    FDIFX = 0.0;
    FDIFY = 0.0;
    FDIFZ = 0.0;
    FG=AFMGRAVITY(GRAVFACT,AP,G,RHOP,RHOW,PI);
    FGN=FG*ENZ;
    FGT=(FG*FG-FGN*FGN)^0.5;
    FLifT=AFMFORCELIFT (RHOW,R,AP,AG,VT,UT,OMEGA);
    HBAR = (H+B)/AP; %REDUCED RETARDATION DUE TO ROUGHNESS
    FUN2=1.0+B2*exp(-C2*HBAR)+D2*exp(-E2*HBAR^A2);
    FUN3=1.0+B3*exp(-C3*HBAR)+D3*exp(-E3*HBAR^A3);
    FUN4=1.0+B4*exp(-C4*HBAR)+D4*exp(-E4*HBAR^A4);
    [FDRGN,FDRGT]=AFMFORCEDRAG (FUN2,FUN3,FUN4,M3,VN,VT);
    
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
    
    %%    cccccccccccccccccc TRANSLATION LOOP cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc^
    % intialize afract calc reset flag, independent of single_afract,
    % dont change value
    het_afract_calculated = 0;
    % prealocate FSTEVEC for testing
    FSTEVEC=NaN(1,nsteps);
    % change while to for loop to lop through disances predefined above
    for i=1:nsteps
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
        
        %%
        %%             Display simulation progress in  MATLAB command window
        if(CLUSTER==0&&showout==1)
            msg = sprintf(format6001,J,I,Z,H,AFRACT);
            disp(msg)
        end
        %end
        %%
        %%
        I = I + 1; %COUNT THE NUMBER OF TRANSLATIONS
        PTIMEF = PTIMEF + dT; %ADD TIME STEP TO TOTAL TIME
        %         CALCULATE ELAPSED TIME
        ETIME = ETIME + dT;
        %%         RECORD PREVIOUS VALUES
        % No change here!!!!
        XO = X;
        YO = Y;
        ZO = Z;
        HO = H;
        IO = I - 1;
        % TRANSLATE PARTICLE
        %         X = XO + UX*dT;
        %         Y = YO + UY*dT;
        %         Z = ZO + UZ*dT;
        % define particle positions to simulate AFM approach
        % changed to ifs setting X,Y,Z to XO,YO,ZO or AXVECTOR depending on which axis is
        % normal via AXstring!!!!
        if AXstring=='x'
            Y = YO;
            Z = ZO;
            X = AXVECTOR(i);
        end
        if AXstring=='y'
            X = XO;
            Z = ZO;
            Y = AXVECTOR(i);
        end
        if AXstring=='z'
            X = XO;
            Y = YO;
            Z = AXVECTOR(i);
        end
        % translaste colloid asperities array relative to colloid posiotion
        if RMODE==1||RMODE==3
            xcap = xcap0+X;
            ycap = ycap0+Y;
            zcap = zcap0+Z;
        end
        
        % CALCULATE RADIAL DISTANCE
        R = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0)+(Z-Zm0)*(Z-Zm0))^0.5;
        
        %   CALCULATE VERTICAL DEFORMATION AS FUNCTION OF R
        %   EQUATION OF LINE CONNECTING POINTS DELTA=0,Z=AP+HFRIC AND DELTA=DELTAMAX,Z=AP-DELTAMAX+HMIN (ADJUST TO INCLUDE ASPERITIES)
        if (RMODE==0)  %SMOOTH-SMOOTH INTERACTION
            DELTA = DELTAMAX*(R-AG-AP-HFRIC)/(HMIN-HFRIC-DELTAMAX);
        elseif ((RMODE==1)||(RMODE==2))  %SMOOTH-ROUGH INTERACTION
            if RMODE==1
                ASP = ASPcolloid;
            else
                ASP = ASPdomain;
            end
            DELTA = DELTAMAX*(R-AG-AP-HFRIC-ASP)/(HMIN-HFRIC-DELTAMAX);
        elseif (RMODE==3)  %ROUGH-ROUGH INTERACTION
            %             DELTA = DELTAMAX*(R-AG-AP-HFRIC-0.5*(2*ASP+3^0.5*ASP))/(HMIN-HFRIC-DELTAMAX);
            DELTA = DELTAMAX*(R-AG-AP-HFRIC-ASPcolloid-ASPdomain)/(HMIN-HFRIC-DELTAMAX);
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
        % assing H from HVECTOR
        H = HVECTOR(i);
        % assing HS from HSMOOTH (smooth underlying surfce sep distance)
        HS = HSMOOTH(i);
        %
        DELTAV(i) = DELTA;
        %         DETERMINE UNIT VECTORS
        ENX = (X-Xm0)/R;
        ENY = (Y-Ym0)/R;
        ENZ = (Z-Zm0)/R;
        
        % remove from here until line 1637 to avoid premature
        % termination!!!!
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
%         if (R>RB)&&(Z>=0.0)&&(cbPZ==1||cbMZ==1)
%             X=XO;
%             Y=YO;
%             Z=ZO;
%         end
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
        %         if (ATTACHK==0)
        %             DETERMINE UNIT VECTORS
        ENX = (X-Xm0)/R;
        ENY = (Y-Ym0)/R;
        ENZ = (Z-Zm0)/R;
        %             DETERMINE FORCES
        %             CALCULATE GRAVITATIONAL FORCE
        FG=AFMGRAVITY(GRAVFACT,AP,G,RHOP,RHOW,PI);
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
            [MHETP, MPRO]=AFMHETTRACKP(Xm0,Ym0,Zm0,H,RZOIBULK,AP,HETMODEP,SCOVP,RHETP0,RHETP1);
            %   HETP WILL BE TRANSLATED TO THE COLLECTOR FRAME OF REFERENCE AND
            %   ROTATED BASED ON COLLOID SPHERICAL COORDINATES, FOR FRONT-END PLOTTING
            %   HETP PROJECTIONS WILL BE TRANSLATED AND ROTATED TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING
            %   THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER, TO CALCULATE AFRACT
            [MHETP_PLOT,MPRO_AF] = AFMHETP_TRANSFORM(X,Y,Z,XG,YG,ZG,THETA,PHI,MHETP,MPRO);
        elseif and(or(SCOV>0.0,SCOVP>0.0),I>1) %and(or(SCOV>0.0,SCOVP>0.0),I==1)
            %   CALCULATE PROJECTION OF COLLOID CENTER ON HAPPEL SPHERE
            XG = Xm0+ENX*AG;
            YG = Ym0+ENY*AG;
            ZG = Zm0+ENZ*AG;
            % reste afract value only if single_afract is deactivated
            if het_afract_calculated==0
                AFRACT = 0.0;
            end
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
            [MHETP_PLOT,MPRO_AF] = AFMHETP_TRANSFORM(X,Y,Z,XG,YG,ZG,THETA,PHI,MHETP,MPRO);
        end %and(or(SCOV>0.0,SCOVP>0.0),I==1)
        %   CALCULATE HETERODOMAINS INFLUENCE
        if and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
            % if single calculation fro afract is toggled, calculate afract
            % once -  AFM simulation
            if het_afract_calculated ==0
                %   HETEROGENEITY ON COLLECTOR (HETC) SUBROUTINE TO DETERMINE CLOSEST HETERODOMAIN TO COLLOID
                %   HETC WILL BE TRANSLATED TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER
                if (SCOV>0.0)
                    %                     if J==10
                    %                         disp('stop')
                    %                     end
                    [XHET,YHET,ZHET,RHET] = AFMHETTRACK(X,Y,Z,Xm0,Ym0,Zm0,AG,...
                        HETMODE,SCOV,RHET0,RHET1,RHET2,0);
                    [XHET_AF,YHET_AF,ZHET_AF] = AFMHETC_TRANSFORM(XG,YG,ZG,THETA,PHI,XHET,YHET,ZHET);
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
                [AF_PZ,AF_ZH,AF_PZH,AF_Z] = AFMAREAFRACT(Xm0,Ym0,RZOI,Xm0,Ym0,Zm0,MPRO_AF(:,[1,2,4]));
                AFRACT = AF_PZ;
                AFRACT_PZ = AF_PZ;
                for K=1:HETMODE
                    [AF_PZ,AF_ZH,AF_PZH,AF_Z] = AFMAREAFRACT(Xm0,Ym0,RZOI,XHET_AF(K),YHET_AF(K),RHET_AF(K),MPRO_AF(:,[1,2,4]));
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
                
                % allow afract calculation only to happens once
                % reset flag
                if single_afract==1
                    het_afract_calculated =1;
                end
            end
            if (AFRACT>0.0)
                %CALCULATE PRO-ZOI ATTRACTIVE CONTRIBUTION TO EDL FORCE
                ZETAC = ZETACST;
                ZETAP = ZETAHETP;
                %FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
                FEDL=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,...
                    NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
                
                FEDL_PZ = FEDL;
                %CALCULATE ZOI-HET ATTRACTIVE CONTRIBUTION TO EDL FORCE
                ZETAC = ZETAHET;
                ZETAP = ZETAPST;
                %FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
                FEDL=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,...
                    NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
                FEDL_ZH = FEDL;
                %CALCULATE PRO-ZOI-HET REPULSIVE CONTRIBUTION TO EDL FORCE
                ZETAC = ZETAHET;
                ZETAP = ZETAHETP;
                %FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
                FEDL=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,...
                    NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
                FEDL_PZH = FEDL;
                %CALCULATE ZOI REPULSIVE CONTRIBUTION TO EDL FORCE
                ZETAC = ZETACST;
                ZETAP = ZETAPST;
                %FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
                FEDL=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,...
                    NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
                FEDL_Z = FEDL;
                %CALCULATE NET EDL FORCE
                FEDL =  AFRACT_PZ*FEDL_PZ + AFRACT_ZH*FEDL_ZH + AFRACT_PZH*FEDL_PZH + AFRACT_Z*FEDL_Z;
            else %(AFRACT>0.0)
                ZETAC = ZETACST;
                ZETAP = ZETAPST;
                %FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
                FEDL=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
                
                
            end %(AFRACT>0.0)
        else %and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
            ZETAC = ZETACST;
            ZETAP = ZETAPST;
            %FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI);
            FEDL=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,...
                NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
            
        end %and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
        %
        %   CALCULATE VDW
        %         FVDW=AFMFORCEVDW (A132,AG,AP,ASP,NASP,RMODE,H,LAMBDAVDW,A11,...
        %             A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE);
        [FVDW,FVDW2,Hasp_colloid,Hasp_domain]=AFMFORCEVDW (X,Y,Z,A132,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,H,HS,LAMBDAVDW,A11,...
            A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE,@AFM_asp_tracking_RMODE3);
        
        %   CALCULATE ACID-BASE, BORN, AND STERIC REPULSION
        %         FAB= AFMFORCEAB (PI,AG,AP,ASP,NASPAB,RMODE,LAMBDAAB,GAMMA0AB,H,H0);
        FAB= AFMFORCEAB (PI,AG,AP,ASPcolloid,ASPdomain,RMODE,LAMBDAAB,GAMMA0AB,H,H0,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
        
        %             FAB = 0.0; %!!debugEP
        %   CALCULATE BORN FORCE
        FBORN=AFMFORCEBORN (A132,SIGMAC,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE);
        FSTE=AFMFORCESTE (PI,GAMMA0STE,LAMBDASTE,ASTE,H);
        FSTEVEC(i)=FSTE;
        %   CALCULATE COLLOIDAL FORCE
        FCOLL = FVDW + FEDL + FAB + FSTE + FBORN;
        %             %   CALCULATE DRAG FORCE
        %             %   CALCULATE FLUID VELOCITY AT GIVEN LOCATION BEFORE CALCULATING DRAG FORCE
        %             if (R<=RB)
        %                 [VxH1,VyH1,VzH1]= HAPPELFF (X,Y,Z,B,K1,K2,K3,K4,AG);
        %                 %                 fluid velocity component are dimensionless, scaled via VSUP
        %                 VX = VxH1*(VSUP);
        %                 VY = VyH1*(VSUP);
        %                 VZ = VzH1*(VSUP);
        %             else
        %                 VX = 0.0;
        %                 VY = 0.0;
        %                 VZ = -VSUP;
        %             end
        %             %           CALCULATE NORMAL AND TANGENTIAL FLOW VELOCITIES FROM 3D
        %             %           COMPONENTS
        %             VN = VX*ENX+VY*ENY+VZ*ENZ;
        %             VNX = VN*ENX;
        %             VNY = VN*ENY;
        %             VNZ = VN*ENZ;
        %             VTX = VX-VNX;
        %             VTY = VY-VNY;
        %             VTZ = VZ-VNZ;
        %             VT = (VTX*VTX+VTY*VTY+VTZ*VTZ)^0.5;
        %             %             DEFINE TANGENTIAL FLUID VELOCITY UNIT VECTORS FOR CARTESIAN COMPONENTS DETERMINED BELOW
        %             if (VT==0)
        %                 ETX = 0.0;
        %                 ETY = 0.0;
        %                 ETZ = 0.0;
        %             else
        %                 ETX = VTX/VT;
        %                 ETY = VTY/VT;
        %                 ETZ = VTZ/VT;
        %             end
        %             %%             UNIVERSAL HYDRODYNAMIC FUNCTIONS
        %             HBAR = (H+B)/AP;
        %             FUN1=1.0+B1*exp(-C1*HBAR)+D1*exp(-E1*HBAR^A1);
        %             FUN2=1.0+B2*exp(-C2*HBAR)+D2*exp(-E2*HBAR^A2);
        %             FUN3=1.0+B3*exp(-C3*HBAR)+D3*exp(-E3*HBAR^A3);
        %             FUN4=1.0+B4*exp(-C4*HBAR)+D4*exp(-E4*HBAR^A4);
        %             %%             NORMAL AND TANGENTIAL DRAG FORCES ARE CALCULATED WITH CORRECTED FUN2 AND FUN3 IN THE SUBROUTINE
        %             [FDRGN,FDRGT]=AFMFORCEDRAG (FUN2,FUN3,FUN4,M3,VN,VT);
        %%             CALCULATE DifFUSION FORCE
        [FDIFX,FDIFY,FDIFZ]=AFMFORCEDIFF(DIFFSCALE,PI,VISC,AP,KB,T,dT);
        if (H<=HFRIC)
            % DifFUSION FORCES EQUAL TO ZERO IN CONTACT
            FDIFX=0.0;
            FDIFY=0.0;
            FDIFZ=0.0;
        end
        %%          CALCULATE LifT FORCE
        FLifT=AFMFORCELIFT (RHOW,R,AP,AG,VT,UT,OMEGA);
        %%          BREAK FORCES INTO CARTESIAN COMPONENTS
        %           WHEN EXAMINING NORMAL AND TANGENTIAL: POSITIVE NORMAL IS AWAY FROM THE SURFACE,
        %           NEGATIVE NORMAL IS TOWARDS THE SURFACE
        %           GRAVITATIONAL
        % Gravity counter-current with flow
        if cbPZ==1
            FGN=-FG*abs(ENZ);
            FGNX=FGN*abs(ENX);
            FGNY=FGN*ENY;
            FGNZ=FGN*ENZ;
            FGTX=0.0-FGNX;
            FGTY=0.0-FGNY;
            FGTZ=-FG-FGNZ;
        end
        
        % Gravity concurrent with flow
        if cbMZ==1
            FGN=FG*abs(ENZ);
            FGNX=FGN*abs(ENX);
            FGNY=FGN*ENY;
            FGNZ=FGN*ENZ;
            FGTX=0.0-FGNX;
            FGTY=0.0-FGNY;
            FGTZ=FG-FGNZ;
        end
        % Gravity orthogonal to flow (+x)
        if cbPX==1
            FGN=-FG*abs(ENX);
            FGNX=FGN*abs(ENX);
            FGNY=FGN*ENY;
            FGNZ=FGN*ENZ;
            FGTX=-FG-FGNX;
            FGTY=0.0-FGNY;
            FGTZ=0.0-FGNZ;
        end
        % Gravity orthogonal to flow (-x)
        if cbMX==1
            FGN=FG*abs(ENX);
            FGNX=FGN*abs(ENX);
            FGNY=FGN*ENY;
            FGNZ=FGN*ENZ;
            FGTX=FG-FGNX;
            FGTY=0.0-FGNY;
            FGTZ=0.0-FGNZ;
        end
        %             COLLOIDAL
        FCOLLX=FCOLL*ENX;
        FCOLLY=FCOLL*ENY;
        FCOLLZ=FCOLL*ENZ;
        %             DRIVING DRAG FORCE
        %             FDRGNX=FDRGN*ENX;
        %             FDRGNY=FDRGN*ENY;
        %             FDRGNZ=FDRGN*ENZ;
        %             FDRGTX=FDRGT*ETX;
        %             FDRGTY=FDRGT*ETY;
        %             FDRGTZ=FDRGT*ETZ;
        %             FDRGX = FDRGNX + FDRGTX;
        %             FDRGY = FDRGNY + FDRGTY;
        %             FDRGZ = FDRGNZ + FDRGTZ;
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
        
        %             %%          INTEGRATE
        %             %             INTEGRATION ADDS AN EXTRA TERM TO ACCOUNT FOR FLOW DISTURBANCE
        %             %             DUE TO PRESENCE OF STATIONARY PARTICLE,
        %             %             REF. MA ET AL. 2009 SI -Hemispheres-in-cell geometry to predict colloid deposition in porous media
        %             %	        INTEGRATE NORMAL AND TANGENTIAL(X,Y,Z) FORCES TO PARTICLE VELOCITIES
        %             %
        %             %             STEADY STATE FORMULATION
        %             %        	    UNX = (FUN1/M3)*(FGNX+FCOLLX+FDifNX+FLifTX+FDRGNX)
        %             %        	    UNY = (FUN1/M3)*(FGNY+FCOLLY+FDifNY+FLifTY+FDRGNY)
        %             %        	    UNZ = (FUN1/M3)*(FGNZ+FCOLLZ+FDifNZ+FLifTZ+FDRGNZ)
        %             %
        %             %             UTX = (FUN4*(FGTX+FDifTX)+FDRGTX)/M3
        %             %             UTY = (FUN4*(FGTY+FDifTY)+FDRGTY)/M3
        %             %             UTZ = (FUN4*(FGTZ+FDifTZ)+FDRGTZ)/M3
        %
        %             %            SAVE VELOCITIES FROM PREVIOUS TIME STEP
        %             if (I==2)    %NEED TO APPLY AT  I=2 SINCE FIRST TRANSLATION IS ALREADY DONE
        %                 UN = UX*ENX+UY*ENY+UZ*ENZ;
        %                 UNX = UN*ENX;
        %                 UNY = UN*ENY;
        %                 UNZ = UN*ENZ;
        %                 UTX = UX-UNX;
        %                 UTY = UY-UNY;
        %                 UTZ = UZ-UNZ;
        %             end
        %             UXO = UNX + UTX;
        %             UYO = UNY + UTY;
        %             UZO = UNZ + UTZ;
        %             UN = UXO*ENX+UYO*ENY+UZO*ENZ;
        %             UNXO = UN*ENX;
        %             UNYO = UN*ENY;
        %             UNZO = UN*ENZ;
        %             UTXO = UXO-UNXO;
        %             UTYO = UYO-UNYO;
        %             UTZO = UZO-UNZO;
        %             %%            INTEGRATION UTILIZING AN IMPLICIT APPROACH, I.E., RESISITNG DRAG PARTICLE VELOCITY CORRESPONDS
        %             %             TO THE FUTURE LOCATION WHILE FORCES CORRESPOND TO ACTUAL LOCATION.
        %             %             expLICIT APPROACH WAS DISCARDED BECAUSE THE MODEL BECOMES UNSTABLE AND EXTREMELY DEPENDENT ON dT
        %             %
        %             UNX = ((MP+VM)*UNXO+(FGNX+FCOLLX+FDifNX+FLifTX+FDRGNX)*dT)/...
        %                 (MP+VM+M3/FUN1*dT);
        %             UNY = ((MP+VM)*UNYO+(FGNY+FCOLLY+FDifNY+FLifTY+FDRGNY)*dT)/...
        %                 (MP+VM+M3/FUN1*dT);
        %             UNZ = ((MP+VM)*UNZO+(FGNZ+FCOLLZ+FDifNZ+FLifTZ+FDRGNZ)*dT)/...
        %                 (MP+VM+M3/FUN1*dT);
        %             %             NORMAL VELOCITY IS NEGATIVE if THE VELOCITY VECTOR POINTS
        %             %                         TO THE COLLECTOR WHEN PROJECTED ON THE COLLOID POSITION VECTOR
        %             if (ENX*UNX+ENY*UNY+ENZ*UNZ)<0
        %                 UN = -(UNX^2+UNY^2+UNZ^2)^0.5;
        %             else
        %                 UN = (UNX^2+UNY^2+UNZ^2)^0.5;
        %             end
        %             %%             TANGENTIAL VELOCITY FROM MA ET AL. 2009 EQUATION S14
        %             if (H>HFRIC)
        %                 UTX = ((MP+VM)*UTXO+(FGTX+FDifTX+FDRGTX)*dT)/...
        %                     (MP+VM+M3/FUN4*dT);
        %                 UTY = ((MP+VM)*UTYO+(FGTY+FDifTY+FDRGTY)*dT)/...
        %                     (MP+VM+M3/FUN4*dT);
        %                 UTZ = ((MP+VM)*UTZO+(FGTZ+FDifTZ+FDRGTZ)*dT)/...
        %                     (MP+VM+M3/FUN4*dT);
        %                 UT = (UTX^2+UTY^2+UTZ^2)^(0.5);
        %                 %TANGENTIAL VELOCITY IS NEGATIVE if THE TANGENTIAL VELOCITY VECTOR POINTS
        %                 %TO THE ENTRANCE OF THE CELL (+Z) WHEN PROJECTED ON THE
        %                 %Z-AXIS
        %                 if -UTZ<0
        %                     UT = -(UTX^2+UTY^2+UTZ^2)^0.5;
        %                 else
        %                     UT = (UTX^2+UTY^2+UTZ^2)^0.5;
        %                 end
        %                 %FIT OMEGA*AP/UT AS FUNCTION OF H/AP USING GCB 1967b TABLES 2&3
        %                 OMEGA = abs(UT)/AP*(0.5518+117.4*(H/AP))/(1+232.1*(H/AP)+237.7*(H/AP)^2.0);
        %             end
        %             %
        %             %%             INTEGRATION if PARTICLE IS IN CONTACT
        %             if (H<=HFRIC)
        %                 %                 CALCULATE NORMAL ADHESIVE AND REPULSIVE FORCES FOR RESISTING TORQUE
        %                 FADH = FVDW + FEDL + FGN + FLifT + FDRGN;
        %                 FREP = FBORN;
        %                 if (FAB<0.0)
        %                     FADH = FADH + FAB;
        %                 else
        %                     FREP = FREP + FAB;
        %                 end
        %                 if (FSTE<0.0)
        %                     FADH = FADH + FSTE;
        %                 else
        %                     FREP = FREP + FSTE;
        %                 end
        %                 % Is FADH becomes positive (repulsive), set to zero
        %                 if (FADH>0.0)
        %                     FADH = 0.0;
        %                 else
        %                     % SINCE ATTRACTIVE FORCES ARE NEGATIVE IN SIGN, FLIP THE SIGN OF FADH TO MAKE IT POSITIVE
        %                     FADH = -FADH;
        %                 end
        %                 if (RLEV<=ACONT)
        %                     RLEV = ACONT; %LARGER RESISTING LEVER ARM DUE TO DEFORMATION THAN ROUGHNESS
        %                 end
        %                 %                 CALCULATE COEFFICIENT OF ROLLING FRICTION if WORK OF ADHESION IS ATTRACTIVE
        %                 %                 FORCE AND TORQUE COMPONENTS FROM GCB 1967A/B AS H/AP GOES TO 0
        %                 FSHRT = 1.7005;
        %                 TSHRY = 0.9440;
        %                 FTRT = (8.0/15.0)*log(H/AP)-0.9588;
        %                 FROT = -(2.0/15.0)*log(H/AP)-0.2526;
        %                 TTRY = -(1.0/10.0)*log(H/AP)-0.1895;
        %                 TROY = (2.0/5.0)*log(H/AP)-0.3817;
        %                 %                 INTEGRATE TANGENTIAL VELOCITY
        %                 %                 By ignoring FG AND FDifF TANGENTIAL, the influence of gravity and Brownian motion are ignored.
        %                 %                 However we need to do this because determining the direction in the tangential axis is not straight forward.
        %                 %                 This is a point for future exploration
        %                 UTO = (UTXO*UTXO+UTYO*UTYO+UTZO*UTZO)^0.5;
        %                 %                 THE TERM IN THE VELOCITY INTEGRATION APPEAR ALL POSITIVE, RESISTING FORCES AND TORQUES NEGATIVE SIGN IS DETERMINED BY THE
        %                 %                 DIMENSIONLESS HYDRODYNAMIC CORRECTION FACTOR CALCULATED ABOVE, THE NORMAL FORCE MUST BE NEGATIVE (ATRACTIVE) FOR ADHESION TO OCCUR (EQUAL TO ATRACTIVE COLLOIDAL FORCES)
        %                 %                 TANGENTIAL VELOCITY FROM MA ET AL. 2011 EQUATION S6 - NOTE THAT MISTAKES ARE CORRECTED
        %                 UT = (1.4*(MP+VM)*UTO-FADH*RLEV/AP*(AP-DELTA)/AP*dT+...
        %                     6.0*PI*VISC*(AP-DELTA)*VT*dT*(FSHRT+2.0/3.0*AP/(H+AP)*TSHRY))...
        %                     /(1.4*(MP+VM)-6.0*PI*VISC*(AP-DELTA)*dT*(FTRT+FROT+4.0/3.0*(TTRY+TROY)));
        %                 %                 ASSIGN NEGATIVE TANGENTIAL VELOCITY AS ZERO
        %                 if (UT<0.0)
        %                     UT = 0.0;
        %                     ARRESTFLAG = 1;
        %                 end
        %                 %                 RESET ARRESTFLAG if COLLOID IS NOT IN EQUILIBRIUM
        %                 %                   if ((FADH<0.995*FREP)||(FADH>1.005*FREP))
        %                 if ((FADH<0.95*FREP)||(FADH>1.05*FREP))
        %                     ARRESTFLAG = 0;
        %                 end
        %                 UTX = ETX*UT;
        %                 UTY = ETY*UT;
        %                 UTZ = ETZ*UT;
        %                 %                 NO SLIP SO OMEGA*AP/UT=1
        %                 OMEGA = UT/AP;
        %             end %(H<HFRIC)
        %             %
        %             %             RECOMPOSE CARTESIAN VELOCITIES
        %             UX=UNX+UTX;
        %             UY=UNY+UTY;
        %             UZ=UNZ+UTZ;
        %         else %ATTACHK>0
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
        %% save forces to matrices
        OUTCOUNT = i;
        IOT(OUTCOUNT,J) = I;
        XOT(OUTCOUNT,J) = X;
        YOT(OUTCOUNT,J) = Y;
        ZOT(OUTCOUNT,J) = Z;
        ROT(OUTCOUNT,J) = R;
        HOT(OUTCOUNT,J) = H;
        HSOT(OUTCOUNT,J) = HS;
        ETIMEOT(OUTCOUNT,J) = ETIME;
        PTIMEFOT(OUTCOUNT,J) = PTIMEF;
        FCOLLOT(OUTCOUNT,J) = FCOLL;
        FVDWOT(OUTCOUNT,J) = FVDW;
        FEDLOT(OUTCOUNT,J) = FEDL;
        FDRGXOT(OUTCOUNT,J) = FDRGX;
        FDRGYOT(OUTCOUNT,J) = FDRGY;
        FDRGZOT(OUTCOUNT,J) = FDRGZ;
        FDIFXOT(OUTCOUNT,J) = FDIFX;
        FDIFYOT(OUTCOUNT,J) = FDIFY;
        FDIFZOT(OUTCOUNT,J) = FDIFZ;
        FABOT(OUTCOUNT,J) = FAB;
        FSTEOT(OUTCOUNT,J) = FSTE;
        FBORNOT(OUTCOUNT,J) = FBORN;
        FDRGTOT(OUTCOUNT,J) = FDRGT;
        UTOT(OUTCOUNT,J) = UT;
        UNOT(OUTCOUNT,J) = UN;
        VTOT(OUTCOUNT,J) = VT;
        VNOT(OUTCOUNT,J) = VN;
        FDRGNOT(OUTCOUNT,J) = FDRGN;
        FGTOT(OUTCOUNT,J) = FGT;
        FGNOT(OUTCOUNT,J) = FGN;
        FLIFTOT(OUTCOUNT,J) = FLifT;
        ACONTOT(OUTCOUNT,J) = ACONT;
        RZOIOT(OUTCOUNT,J) = RZOI;
        UXOT(OUTCOUNT,J) = UX;
        UYOT(OUTCOUNT,J) = UY;
        UZOT(OUTCOUNT,J) = UZ;
        VXOT(OUTCOUNT,J) = VX;
        VYOT(OUTCOUNT,J) = VY;
        VZOT(OUTCOUNT,J) = VZ;
        AFRACTOT(OUTCOUNT,J) = AFRACT;
        

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
            [MHETP, MPRO]=AFMHETTRACKP(Xm0,Ym0,Zm0,H,RZOIBULK,AP,HETMODEP,SCOVP,RHETP0,RHETP1);
            %   HETP WILL BE TRANSLATED TO THE COLLECTOR FRAME OF REFERENCE AND
            %   ROTATED BASED ON COLLOID SPHERICAL COORDINATES, FOR FRONT-END PLOTTING
            %   HETP PROJECTIONS WILL BE TRANSLATED AND ROTATED TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING
            %   THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER, TO CALCULATE AFRACT
            [MHETP_PLOT,MPRO_AF] = AFMHETP_TRANSFORM(X,Y,Z,XG,YG,ZG,THETA,PHI,MHETP,MPRO);
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
    
    %
    %% OUTPUT PLOTS
    
    %% save and close simplots if apply
    
    %     if saveSIMPLOT ==1&&simplot==1
    %         % save and close transport figure(dashboard)
    %         savefig (fT,filefT);
    %         close (fT);
    %     end
    %     if saveSIMPLOT==0&&simplot==1
    %         % close detailed dashboard (transport) and near surface figures
    %         close (fT);
    %         pause(2);
    %     end
    %     if saveSIMPLOT ==1&&detplot==1
    %         % save and close close (fT); near surface figure
    %         savefig (fDnear,filefDnear);
    %         close (fDnear);
    %         % save close (fT); contact figure
    %         savefig (fDcontact,filefContact);
    %     end
    %     if saveSIMPLOT ==0&&detplot==1
    %         close (fDnear);
    %         pause(2);
    %     end
    
    %% save  hetdomains in AFMdomain to matrices
    rangeHetV(J) = length(XHET);
    mxhetOUT(1:rangeHetV(J),J)=XHET;
    myhetOUT(1:rangeHetV(J),J)=YHET;
    mzhetOUT(1:rangeHetV(J),J)=ZHET;
    mrhetOUT(1:rangeHetV(J),J)=RHET;
    %update progress bar
    waitbar(double(J)/double(NPARTLOOP))
    % diagnostic plot below probe and asperities
%     if J>=1
%         disp(J)
%         figure(100)
%         plot(xasp_domain,zasp_domain,'o')
%         hold on
%         dom =5e-6;
%         axis([-dom dom -dom dom])
%         axis square
%         plot(X,Z,'sk')
%             
%     end
end %LOOP TO NEXT PARTICLE
%% calculate etas
eta2 = ceta2/(double(NPARTLOOP)*RB^2/RLIM^2);
eta4 = ceta4/(double(NPARTLOOP)*RB^2/RLIM^2);
eta5 = ceta5/(double(NPARTLOOP)*RB^2/RLIM^2);
eta6 = ceta6/(double(NPARTLOOP)*RB^2/RLIM^2);
%% save figures
% if ATTMODE~=-1
%     fig1 = strcat(workdir,'Fig1_Rlim_Plane');
%     savefig (1,fig1);
% end
% fig2 = strcat(workdir,'Fig2_Happel_Geometry_3D');
% savefig (2,fig2);
% fig3 = strcat(workdir,'Fig3_HvsZ_2D');
% savefig (3,fig3);
% fig4 = strcat(workdir,'Fig4_HvsZ_2D_zoom_in');
% savefig (4,fig4);
% % close all files
% fclose('all');

% stop simulation clock
toc
%% probe and hetdomain locations
% get rzoi vector
rzoiaux =RZOIOT(end,:);
%
% changed xaux and yaux to LAT1aux and LAT2aux to separate from x and y!!!!
% changed ifs to use AXstring to obtain correct xaux and yaux!!!!
if AXstring=='x'
    LAT1aux = YOT(1,:);
    LAT2aux = ZOT(1,:);
end
if AXstring=='y'
    LAT1aux = XOT(1,:);
    LAT2aux = ZOT(1,:);
end
if AXstring=='z'
    LAT1aux = XOT(1,:);
    LAT2aux = YOT(1,:);
end
afaux = AFRACTOT(end,:);
% convert any negative afract to zero
afaux(afaux<0)=0;
%% AFRACT and PROFILE plots

% let user know in progress bar that plots are being generated
% start progress bar
waitbar(1.0)
close(pbar)
pbar1 = waitbar(0,'Generating plots','Position', [50 500 290 50]);

%probe locations
figure(1)
%plot afract height
plotmode_afract =2;
if plotmode_afract ==1 %plot black markers only
plot3(LAT1aux,LAT2aux,afaux,'sk')
hold on
end
if plotmode_afract ==2 %plot anttenae corresponding to each marker
    for i=1:length(afaux)
        if afaux(i)>0.0
            plot3([LAT1aux(i) LAT1aux(i)],[LAT2aux(i) LAT2aux(i)],[afaux(i) 0.0],'-c')
            hold on
            plot3(LAT1aux(i),LAT2aux(i),afaux(i),'sc','MarkerFaceColor','b')
            
        else
            plot3(LAT1aux(i),LAT2aux(i),afaux(i),'sk')
            hold on       
        end
    end
end
% include RZOI value in title
rzoilabel = num2str(rzoiaux(1)*1e9,3);
rzoiTitle = strcat("ZOI radius (",rzoilabel," nm, gold circles)");
% include RHET values in title

if HETMODE == 1
    
elseif HETMODE == 3
    
elseif HETMODE == 2
    
else
    
end
if SCOV>0.0
    if RMODE>1
        title({rzoiTitle,...
            'Rotate figure to see plan view',...
            'Probe-detected Collector Heterodomains (green circles)',...
            'Probe-detected Domain-Asperities Locations (blue circles)'});
    else
        title({rzoiTitle,...
            'Rotate figure to see plan view',...
            'Probe-detected Collector Heterodomains (green circles)'});
    end
else
    if RMODE>1
        title({rzoiTitle,...
            'Rotate figure to see plan view',...
            'Probe-detected Domain-Asperities Locations (blue circles)'});
    else
        title({rzoiTitle,...
            'Rotate figure to see plan view'});
    end
end
axis square
axis([-Inf Inf -Inf Inf 0 Inf])
zlabel({'Fraction of ZOI','occupied by heterodomain'})
hold on
% plot zoi around probe locations
for i=1:NPARTLOOP
    [xc,yc,zc]=AFMcircle(LAT1aux(i),LAT2aux(i),0.0,rzoiaux(i),50);
    plot3(xc,yc,zc,'-','Color',colcolor,'LineWidth',2)
    drawnow
end
% plot hetdomains on AFMdomain
if AXstring=='x'
    mxhetPLOT = myhetOUT;
    myhetPLOT = mzhetOUT;
end
if AXstring=='y'
    mxhetPLOT = mxhetOUT;
    myhetPLOT = mzhetOUT;
end
if AXstring=='z'
    mxhetPLOT= mxhetOUT;
    myhetPLOT = myhetOUT;
end
for j=1:NPARTLOOP
    % changed het location plotting to account for axis swapping!!!!
    for i=1:rangeHetV(j)
        [xc,yc,zc]=AFMcircle(mxhetPLOT(i,j),myhetPLOT(i,j),0.0,mrhetOUT(i,j),50);
        %         plot3(xc,yc,zc,'-g')
        fill(xc,yc,'g','LineStyle','none');
    end
end
% draw asperities
if (RMODE==2||RMODE==3)&& length(xasp_domain)<=asp_max_number
    %     % single asperity sphere
    %     [asp_dom_spherex,asp_dom_spherey,asp_dom_spherez] = sphere(10);
    %     asp_dom_spherex=asp_dom_spherex*ASPdomain;
    %     asp_dom_spherey=asp_dom_spherey*ASPdomain;
    %     asp_dom_spherez=asp_dom_spherez*ASPdomain;
    % singe asperity circle
    [xcirc,ycirc,zcirc]=AFMcircle(0,0,0,ASPdomain,20);
    
    for J=1:NPARTLOOP
        for i=1:range_mat_asp(J)
            xpos = mat_asp_domx(i,J);
            ypos = mat_asp_domy(i,J);
            zpos = mat_asp_domz(i,J);
            % transform actual coordinates to plot coordinates depending
            % on axis of approach
            % plot hetdomains on AFMdomain
            if AXstring=='x'
                xposplot = ypos;
                yposplot = zpos;
            end
            if AXstring=='y'
                xposplot = xpos;
                yposplot = zpos;
            end
            if AXstring=='z'
                xposplot= xpos;
                yposplot = ypos;
            end
            zposplot = 0.0;
            
            %             surf(asp_dom_spherex+xposplot,asp_dom_spherey+yposplot,asp_dom_spherez+zposplot)
            plot(xcirc+xposplot,ycirc+yposplot,'--b')
            
        end
    end
elseif (RMODE==2||RMODE==3)&&length(xasp_domain)>asp_max_number
    warndlg('Excesive number of asperities on domain to plot')
end
waitbar(0.5)
%% force profile surface
% auxiliar indexing matrix
auxM = ones(nsteps,NPARTLOOP);
v = ones(1,nsteps);
for i=1:NPARTLOOP
    auxM(:,i) =v*i;
end

figure(2)
% surf(HOT,auxM,FCOLLOT,'EdgeColor','none')
forcescale = FCOLLOT(:);
for i=1:length(forcescale)
    if forcescale(i)>5e-9
        forcescale(i)=5e-9;
    end
    if forcescale(i)<-5e-9
        forcescale(i)=-5e-9;
    end
end
scatter3(HOT(:),auxM(:),FCOLLOT(:),30,forcescale,'.')
colormap jet
colorbar
title('Force Profiles')
h=gca;
set(h,'xscale','log')
xlabel('H(m)'); ylabel('Index'); zlabel('F(N)');
axis([-Inf Inf -Inf Inf -5e-9 5e-9 ])
% close progress bar
waitbar(1)
close(pbar1)
end

