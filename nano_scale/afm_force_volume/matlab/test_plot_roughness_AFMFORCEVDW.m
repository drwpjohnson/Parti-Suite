% test_asperities_AFMFORCEVDW
clc; clear; close all;
global ASPcolloid LTLT concav
LTLT = 1; %hardwired value for respecting Derjagarguin criteria (calc roughness <=1 ASP radius)
%% integration of interactions between roguh surfaces:
% 1) assume colloid motion in Y only
% 2) identify asperities in collector using a regular grid
% 3) identify closest colloid-collector asperities and number of ZOIs
% 4) determine correct integration (only normal and laterals?)
% 5) determine minimum adom relative to ZOI, consider colloid wedging between to relative large asperities
%%

% physical constants
E0 = 8.85418781762E-12;     %VACUUM PERMITTIVITY (C^2/N M^2)
ER = 80.10;                 %water relative permitivity
ECHG = 1.602176621E-19;     % ELEMENTARY CHARGE (C)
KB=1.3806485E-23;           %BOLTZMANN CONSTANT (J/K)
T = 298; %K

% Ionic strength mol/m3 = milimolar (1 to 100 mM ADD TO GUI)
IS = 1.0;
% Define colloid radius
% lower limit of 5e-7 radius consistent with AFM practice (ADD TO GUI)
AP = 5e-7;
% domain length (use as adom in GUI and RLIM in subroutines,lower limit adom to 2*RZOI ADD TO GUI)
RLIM = 5.0e-6;
% hardwire AG  for AFM mode as a 1e9 factor of AP (ADD TO GUI)
AG = 1e9*AP;

%% RMODE set 0 for smooth, 1 only rough colloid, 2 only rough domain, 3 rough colloid and domain
RMODE = 2;
% asperities on colloid (lower limit 1e-9 radius, upper limit AP, ADD TO GUI)
ASPcolloid = 1e-8;
% asperities on collector (lower limit to 1e-9 radius ADD TO GUI)
ASPdomain = 1.6e-6;
% overwrite asperities depending on RMODE
if RMODE==1
    ASPdomain = 0.0;
end
if RMODE==2
    ASPcolloid = 0.0;
end

%%

%calculate RZOI
%     CALCULATE KAPPA NOTE: IS FOR 1:1 ELECTROLYTE ONLY
ERE0 = ER*E0;            %ABSOLUTE PERMITTIVITY
NIO = IS*2*6.02214086E23;
ZI = 1; % ELECTROLYTE VALENCE
KAPPA = ((ECHG^2.0)*NIO*(ZI^2.0)/(ERE0*KB*T))^0.5;
%   CALCULATE RZOIBULK: RADIUS OF ZONE OF INFLUENCE WITHOUT DEFORMATION
RZOIBULK = 2.0*((1/KAPPA)*AP)^0.5;
% activate flag to indicate small colloid relative to collector asperities
concav = 0;
if RZOIBULK<=2*ASPdomain
    concav=1;
end


% calculate fzoi as a function of asperities and zoi
ratio_asp_colloid = (RZOIBULK/ASPcolloid);
ratio_asp_collector = (RZOIBULK/ASPdomain);
%
if ratio_asp_colloid<3 || ratio_asp_collector<3
    fzoi = 2.0;
else
    fzoi = 1.0;
end


% colloid position
HSPAN = 1e-7;
X = 0.0;
Y = AG+ASPdomain+AP+ASPcolloid+HSPAN;
Z = 3.0*AP;
H = HSPAN;
% collector position
XO = 0.0;
YO = 0.0;
ZO = 0.0;
% unit spheres
[xus1,yus1,zus1]=sphere(200); % collector
[xus2,yus2,zus2]=sphere(20); % colloid
% plane at y=AG
[xplane,zplane] = meshgrid(linspace(-RLIM/2,RLIM/2,100));
yplane =ones(size(xplane))*AG ;
% p[lot smooth surfaces
figure(1)
% surf (xus1*AG,yus1*AG,zus1*AG,'FaceColor','none')
plot3(0,0,0,'ok')
hold on

%surf (xplane,yplane,zplane,'EdgeColor','none')
surf (xus2*AP+X,yus2*AP+Y,zus2*AP+Z)
view(0,45)
axis square
plotdom = RLIM*2;
axis([-plotdom plotdom -plotdom+AG plotdom+AG  -plotdom plotdom ])


%% asperity generation COLLOID
if RMODE ==1||RMODE==3
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

    %grid points in regular aspcet grid on colloid from sphere_cap function
    %modified from zoom in detailed plots for Traj-Happel
    [xcap0,ycap0,zcap0]=AFMsphere_capEQ(AP,angasp,angzoi,fzoi,RZOIBULK);


    % translate cap relative to colloid center.
    xcap=xcap0+X;
    ycap=ycap0+Y;
    zcap=zcap0+Z;


    for i=1:length(xcap)
        figure(1)
        surf (xus2*ASPcolloid+xcap(i),yus2*ASPcolloid+ycap(i),zus2*ASPcolloid+zcap(i));
        %plot3(xasp(i,j),yasp(i,j),AG,'o')
    end
end

if RMODE ==2
    xcap = [];
    ycap = [];
    zcap = [];
end

%% asperity generation DOMAIN
% uniform asperities locations
% single size
if RMODE==2||RMODE==3
    [xasp_domain,yasp_domain,zasp_domain]=AFM_asp_tracking_test(X,Y,Z,AG,fzoi,RZOIBULK,ASPdomain);
    
    
    for i=1:length(xasp_domain)
        figure(1)
        surf (xus2*ASPdomain+xasp_domain(i),yus2*ASPdomain+yasp_domain(i),zus2*ASPdomain+zasp_domain(i));
        plot3(xasp_domain(i),yasp_domain(i),zasp_domain(i),'o')
    end
    % draw ZOI boundary on collector
    [xcirc,ycirc,zcirc]=AFMcircleXZ(X,Y-AP-ASPcolloid-H/2,Z,RZOIBULK,50);
    figure(1)
    plot3(xcirc,ycirc,zcirc,'.-m')
    zoom(5.0)
end

%% interaction calc VDW
% colloid asperity array needs to be generated only once for all locations.
% xcap0,ycap0,zcap0, array is translates using colloid position to get
% xcap,ycap,zcap
%
% domain asperity array depends on colloid location, needs to be generated
% only once for each location.
%xasp_domain,yasp_domain,zasp_domain

% define rest of arguments
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




[FVDW,FVDW2,Hasp_colloid,Hasp_domain]=AFMFORCEVDW (X,Y,Z,A132,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,H,LAMBDAVDW,A11,...
    A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE,@AFM_asp_tracking_RMODE3);
if RMODE ==1
    % add separation distance lines of actions to figure
    for i=1:length(xcap)
        figure(1)
        plot3([xcap(i) xcap(i)],[AG+Hasp_colloid(i) AG], [zcap(i) zcap(i)],'.-b','MarkerSize',10)
        if i==1
            zoom(1.0)
        end
    end
end

if RMODE ==2

    % calculate interception point of line of action with colloid surface
    % calculate separtion distance in line of action
    RXYZ =((X-xasp_domain).*(X-xasp_domain)+(Y-yasp_domain).*(Y-yasp_domain)+(Z-zasp_domain).*(Z-zasp_domain)).^0.5;
    unitx = (X-xasp_domain)./RXYZ;
    unity = (Y-yasp_domain)./RXYZ;
    unitz = (Z-zasp_domain)./RXYZ;
    %start points on domain 
    xstart = xasp_domain+unitx*ASPdomain;
    ystart = yasp_domain+unity*ASPdomain;
    zstart = zasp_domain+unitz*ASPdomain;
    % endpoints on collector surface
    xend = X-unitx*AP;
    yend = Y-unity*AP;
    zend = Z-unitz*AP;    
    % add separation distance lines of actions to figure
    for i=1:length(xasp_domain)
        figure(1)
        plot3([xstart(i) xend(i)],[ystart(i) yend(i)], [zstart(i) zend(i)],'.-b','MarkerSize',10)
        if i==1
            zoom(1.0)
        end
    end
end

% plot contribution of each asperity to FVDW
figure(3)
bar(FVDW2)