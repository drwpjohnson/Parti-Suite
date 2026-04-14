% test_asperities_AFMFORCEVDW
clc; clear; close all;
global LTLT
%% integration of interactions between roguh surfaces:
% 1) assume colloid motion in Y only
% 2) identify asperities in collector using a regular grid
% 3) identify closest colloid-collector asperities and number of ZOIs
% 4) determine correct integration (only normal and laterals?)
% 5) determine minimum adom relative to ZOI, consider colloid wedging between to relative large asperities
%%



%%  DEFINE PHYSICAL CONSTANTS
PI=3.14159265359;         %PIE (CHERRY,STRAWBERRY RHUBARB, ETC.)
G=9.80665;                %ACCELERATION DUE TO GRAVITY (M/S^2)
E0=8.85418781762E-12;     %VACUUM PERMITTIVITY (C^2/N M^2)
ECHG=1.602176621E-19;     %ELEMENTARY CHARGE (C)
KB=1.3806485E-23;         %BOLTZMANN CONSTANT (J/K)
ER = 80.10;                 %water relative permitivity
T = 298; %K



% factor to limit aspetities contributions based on H threshold
% Hthreshold = 1/LTLT*ASP ( asperity on collector or domain) 
% LTLT represents the threshold factor between H and a (where a equals the
% smaller radius among AP AG and ASP)
LTLT = 1;

% Ionic strength mol/m3 = milimolar (1 to 100 mM ADD TO GUI)
IS = 1.0;
% Define colloid radius
% lower limit of 5e-7 radius consistent with AFM practice (ADD TO GUI)
AP = 1e-6;
% domain length (use as adom in GUI and RLIM in subroutines,lower limit adom to 2*RZOI ADD TO GUI)
RLIM = 5.0e-6;
% hardwire AG  for AFM mode as a 1e9 factor of AP (ADD TO GUI)
AG = 1e9*AP;

% surfaces zeta potentials
ZETAC = -0.06; %V
ZETAP = -0.06; %V
% AB parameters
GAMMA0AB = -2.7e-2; %J/m2
LAMBDAAB = 6.0e-10; %m
H0=0.158E-9;              %MINIMUM SEPARATION DISTANCE (M)
SIGMAC=5.0E-10;           %BORN COLLISION DIAMTER (M)
DELTASEP=5.0E-10;         %BUFFER OUTWARD FROM H0 (M)


%calculate RZOI
%     CALCULATE KAPPA NOTE: IS FOR 1:1 ELECTROLYTE ONLY
ERE0 = ER*E0;            %ABSOLUTE PERMITTIVITY
NIO = IS*2*6.02214086E23;
ZI = 1; % ELECTROLYTE VALENCE
KAPPA = ((ECHG^2.0)*NIO*(ZI^2.0)/(ERE0*KB*T))^0.5;
%   CALCULATE RZOIBULK: RADIUS OF ZONE OF INFLUENCE WITHOUT DEFORMATION
RZOIBULK = 2.0*((1/KAPPA)*AP)^0.5;

% calculate fzoi as a function of asperities and zoi
% ratio_asp_colloid = (RZOIBULK/ASPcolloid);
% ratio_asp_collector = (RZOIBULK/ASPdomain);
% %
% if ratio_asp_colloid<3 || ratio_asp_collector<3
%     fzoi = 2.0;
% else
%     fzoi = 1.0;
% end



% colloid position
HSPAN = 5e-7;
X = 0.0;
Z = 0.0;
H = HSPAN;
% collector position
XO = 0.0;
YO = 0.0;
ZO = 0.0;

% define  arguments for VDW
NASP = [];
A132 = 7.18e-21; %default value
LAMBDAVDW = 1.0e-7; %default value
%coating parameters not apply to rough calculation VDWMODE = 1
VDWMODE = 1;
A11 = 0.0;
A22 = 0.0;
A33= 0.0; 
AC1C1 = 0.0; 
AC2C2= 0.0; 
T1= 0.0; 
T2= 0.0; 

% define  arguments for EDL.


%% test for a range of H for smooth vs rough colloid (RMODE =1)
% test also for range of asperities
ASPcolloidvec =  [1e-9 5e-9];
Hvec = 1.e-10:1e-9:2.0e-7;
fzoi = 1;
% prealocate VDW force vectors
FVDWvecs = NaN(1,length(Hvec));
FVDWvecr = NaN(length(Hvec),length(ASPcolloidvec));
FABs = NaN(length(Hvec)); 
FEDLs = NaN(length(Hvec));
FABr1 = NaN(length(Hvec),length(ASPcolloidvec));
FEDLr1 = NaN(length(Hvec),length(ASPcolloidvec));
% calculate VDW for each separation distance smooth surfaces
RMODE =0;
Yvec = Hvec(1)+AG+AP:1e-9:Hvec(end)+AG+AP;
for i=1:length(Hvec)
    Y = Yvec(i);
    % make empty roughness arrays 
    xcap=[];
    ycap = [];
    zcap = [];
    xasp_domain = [];
    yasp_domain = [];
    zasp_domain = [];
    ASPcolloid = 0.0;
    ASPdomain = 0.0;
    [FVDW,FVDW2,Hasp_colloid,Hasp_domain]=AFMFORCEVDW (X,Y,Z,A132,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,Hvec(i),LAMBDAVDW,A11,...
    A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE,@AFM_asp_tracking_RMODE3);
    FVDWvecs(i)=FVDW;

    FABs(i)= AFMFORCEAB (PI,AG,AP,ASPcolloid,ASPdomain,RMODE,LAMBDAAB,GAMMA0AB,H,H0,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
    FEDLs(i)=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
end
% calcualte VDW for each separation distance rough colloid
RMODE =1;
for j=1:length(ASPcolloidvec)
    ASPdomain = 0.0;
    ASPcolloid = ASPcolloidvec(j);
    Yvec = Hvec(1)+AG+ASPdomain+ASPcolloid+AP:1e-9:Hvec(end)+AG+ASPdomain+ASPcolloid+AP;
    % uniform colloid asperities locations
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

    %grid points in regular aspect grid on colloid from sphere_cap function
    %modified from zoom in detailed plots for Traj-Happel
    [xcap0,ycap0,zcap0]=AFMsphere_capEQ(AP,angasp,angzoi,fzoi,RZOIBULK);

    for i=1:length(Hvec)
        Y = Yvec(i);
        % translate cap relative to colloid center.
        xcap=xcap0+X;
        ycap=ycap0+Y;
        zcap=zcap0+Z;
        [FVDW,FVDW2,Hasp_colloid,Hasp_domain]=AFMFORCEVDW (X,Y,Z,A132,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,Hvec(i),LAMBDAVDW,A11,...
            A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE,@AFM_asp_tracking_RMODE3);
        FVDWvecr(i,j)=FVDW;

        FABr1(i,j)= AFMFORCEAB (PI,AG,AP,ASPcolloid,ASPdomain,RMODE,LAMBDAAB,GAMMA0AB,H,H0,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
        FEDLr1(i,j)=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);


%         figure(11)
%         semilogy(Hasp_colloid)
%         hold on
    end
end
% plot results
figure(10)
 subplot(1,4,1)
semilogy(Hvec,FVDWvecs,'.-b')
set(gca,'FontSize',20)
hold on
for j=1:length(ASPcolloidvec)
    semilogy(Hvec,FVDWvecr(:,j),'.-')
    drawnow
    pause(0.1)
end
legend('VDW smooth','VDW small ASP','VDW large ASP')

for j=1:length(ASPcolloidvec)
    subplot(1,4,2)
    set(gca,'FontSize',20)
    hold on
    semilogy(Hvec,FEDLr1(:,j),'.-')
    drawnow
    pause(0.1)
end
legend('EDL small ASP','EDL large ASP')

for j=1:length(ASPcolloidvec)
    subplot(1,4,3)
    set(gca,'FontSize',20)
    hold on
    semilogy(Hvec,FABr1(:,j),'.-')
    drawnow
    pause(0.1)
end
legend('FAB RMODE1')

for j=1:length(ASPcolloidvec)
    subplot(1,4,4)
    set(gca,'FontSize',20)
    hold on
    semilogy(Hvec,FVDWvecr(:,j)+FEDLr1(:,j)+FABr1(:,j),'.-')
    drawnow
    pause(0.1)
end
legend('TOTAL RMODE1')




%legend('FVDW smooth surfaces','FVDW rough colloid')
%% test for a range of H for smooth vs rough domain (RMODE =2)
% test also for range of asperities
ASPdomainvec = ASPcolloidvec;
% prealocate VDW force vectors
FVDWvecs2 = NaN(1,length(Hvec));
FVDWvecr2 = NaN(length(Hvec),length(ASPdomainvec));
FABr2 = NaN(length(Hvec),length(ASPcolloidvec));
FEDLr2 = NaN(length(Hvec),length(ASPcolloidvec));

% calcualte VDW for each separation distance rough colloid
RMODE =2;
for j=1:length(ASPdomainvec)
    ASPdomain = ASPdomainvec(j);
    ASPcolloid = 0.0;
    Yvec = Hvec(1)+AG+ASPdomain+ASPcolloid+AP:1e-9:Hvec(end)+AG+ASPdomain+ASPcolloid+AP;
    %% asperity generation COLLECTOR
    % uniform asperities locations
    % single size
    Y = Yvec(end);
    [xasp_domain,yasp_domain,zasp_domain]=AFM_asp_tracking(X,Y,Z,AG,fzoi,RZOIBULK,ASPdomain);

    for i=1:length(Hvec)
        Y=Yvec(i); % moving colloid in y axis
        [FVDW,FVDW2,Hasp_colloid,Hasp_domain]=AFMFORCEVDW (X,Y,Z,A132,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,Hvec(i),LAMBDAVDW,A11,...
            A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE,@AFM_asp_tracking_RMODE3);
        FVDWvecr2(i,j)=FVDW;

        FABr2(i,j)= AFMFORCEAB (PI,AG,AP,ASPcolloid,ASPdomain,RMODE,LAMBDAAB,GAMMA0AB,H,H0,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
        FEDLr2(i,j)=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);


    end
end
% plot results
figure(20)
subplot(1,4,1)
semilogy(Hvec,FVDWvecs,'.-b')
set(gca,'FontSize',20)
hold on
for j=1:length(ASPdomainvec)
    semilogy(Hvec,FVDWvecr2(:,j),'.-r')
    drawnow
    pause(0.1)
end


for j=1:length(ASPdomainvec)
    subplot(1,4,2)
    set(gca,'FontSize',20)
    hold on
    semilogy(Hvec,FEDLr2(:,j),'.-r')
    drawnow
    pause(0.1)
end
legend('EDL RMODE2')

for j=1:length(ASPdomainvec)
    subplot(1,4,3)
    set(gca,'FontSize',20)
    hold on
    semilogy(Hvec,FABr2(:,j),'.-g')
    drawnow
    pause(0.1)
end
legend('FAB RMODE2')


for j=1:length(ASPcolloidvec)
    subplot(1,4,4)
    set(gca,'FontSize',20)
    hold on
    semilogy(Hvec,FVDWvecr2(:,j)+FEDLr2(:,j)+FABr2(:,j),'.-k')
    drawnow
    pause(0.1)
end
legend('TOTAL RMODE2')


%% test for a range of H for smooth vs rough colloid and domain (RMODE =3)
% test also for range of asperities
ASPdomainvecR3 = ASPdomainvec;
ASPcolloidvecR3 = ASPdomainvec;
% prealocate VDW force vectors
FVDWvecs3 = NaN(1,length(Hvec));
FVDWvecr3 = NaN(length(Hvec),length(ASPdomainvecR3));
FVDW2vecr3 = FVDWvecr3;
FVDW1vecr3 = FVDWvecr3;

FABr3 = NaN(length(Hvec),length(ASPdomainvecR3));
FEDLr3 = NaN(length(Hvec),length(ASPdomainvecR3));

% calculate VDW for each separation distance smooth surfaces
RMODE =0;
for i=1:length(Hvec)
    [FVDW,FVDW2,Hasp_colloid,Hasp_domain]=AFMFORCEVDW (X,Y,Z,A132,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,Hvec(i),LAMBDAVDW,A11,...
    A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE,@AFM_asp_tracking_RMODE3);
    FVDWvecs2(i)=FVDW;
end
% calculate VDW for each separation distance rough colloid
RMODE =3;
for j=1:length(ASPdomainvecR3)
    ASPdomain = ASPdomainvecR3(j);
    ASPcolloid = ASPcolloidvecR3(j);
    Yvec = Hvec(1)+AG+ASPdomain+ASPcolloid+AP:1e-9:Hvec(end)+AG+ASPdomain+ASPcolloid+AP;
    %% asperity generation COLLOID
    % uniform colloid asperities locations
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
    %grid points in regular aspect grid on colloid from sphere_cap function
    %modified from zoom in detailed plots for Traj-Happel
    [xcap0,ycap0,zcap0]=AFMsphere_capEQ(AP,angasp,angzoi,fzoi,RZOIBULK);

    %% asperity generation DOMAIN
    % uniform asperities locations
    % single size
    Y = Yvec(end);
    [xasp_domain,yasp_domain,zasp_domain]=AFM_asp_tracking(X,Y,Z,AG,fzoi,RZOIBULK,ASPdomain);

    for i=1:length(Hvec)
        Y=Yvec(i); % moving colloid in y axis
        % translate cap relative to colloid center.
        xcap=xcap0+X;
        ycap=ycap0+Y;
        zcap=zcap0+Z;
        % calculate interaction
        [FVDW,FVDW2,Hasp_colloid,Hasp_domain]=AFMFORCEVDW (X,Y,Z,A132,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,Hvec(i),LAMBDAVDW,A11,...
            A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE,@AFM_asp_tracking_RMODE3);
        FVDWvecr3(i,j)=FVDW;
        FVDW2vecr3(i,j)=sum(FVDW2);
        FVDW1vecr3(i,j)=FVDW-FVDW2vecr3(i,j);

        FABr3(i,j)= AFMFORCEAB (PI,AG,AP,ASPcolloid,ASPdomain,RMODE,LAMBDAAB,GAMMA0AB,H,H0,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
        FEDLr3(i,j)=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,@AFM_asp_tracking_RMODE3);
    end
end
% plot results
figure(30)
subplot(1,4,1)
semilogy(Hvec,FVDWvecs,'.-b')
set(gca,'FontSize',20)
hold on
for j=1:length(ASPdomainvecR3)
    semilogy(Hvec,FVDWvecr3(:,j),'.-r')
    semilogy(Hvec,FVDW1vecr3(:,j),'--m')
    semilogy(Hvec,FVDW2vecr3(:,j),'.-g')
    legend( 'smooth','rmode3','smooth rmode3', 'rough rmode 3')
    drawnow
    pause(0.1)
end
for j=1:length(ASPdomainvec)
    subplot(1,4,2)
    set(gca,'FontSize',20)
    hold on
    semilogy(Hvec,FEDLr3(:,j),'.-r')
    drawnow
    pause(0.1)
end
legend('EDL RMODE3')

for j=1:length(ASPdomainvec)
    subplot(1,4,3)
    set(gca,'FontSize',20)
    hold on
    semilogy(Hvec,FABr3(:,j),'.-g')
    drawnow
    pause(0.1)
end
legend('FAB RMODE3')

for j=1:length(ASPcolloidvec)
    subplot(1,4,4)
    set(gca,'FontSize',20)
    hold on
    semilogy(Hvec,FVDWvecr3(:,j)+FEDLr3(:,j)+FABr3(:,j),'.-k')
    drawnow
    pause(0.1)
end
legend('TOTAL RMODE3')

