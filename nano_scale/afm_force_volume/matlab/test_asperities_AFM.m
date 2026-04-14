% test_asperities_AFM
clc; clear; close all;

%% integration of interactions between roguh surfaces:
% 1) assume colloid motion in Z only
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
AP = 1e-6;
% domain length (use as adom in GUI and RLIM in subroutines,lower limit adom to 2*RZOI ADD TO GUI)
RLIM = 5.0e-6;
% hardwire AG  for AFM mode as a 1e9 factor of AP (ADD TO GUI)
AG = 1e9*AP;
% asperities on colloid (lower limit 1e-9 radius, upper limit AP, ADD TO GUI)
ASPcolloid = 8e-8;
% asperities on collector (lower limit to 1e-9 radius ADD TO GUI)
ASPdomain = 8e-8;

%calculate RZOI
%     CALCULATE KAPPA NOTE: IS FOR 1:1 ELECTROLYTE ONLY
ERE0 = ER*E0;            %ABSOLUTE PERMITTIVITY
NIO = IS*2*6.02214086E23;
ZI = 1; % ELECTROLYTE VALENCE
KAPPA = ((ECHG^2.0)*NIO*(ZI^2.0)/(ERE0*KB*T))^0.5;
%   CALCULATE RZOIBULK: RADIUS OF ZONE OF INFLUENCE WITHOUT DEFORMATION
RZOIBULK = 2.0*((1/KAPPA)*AP)^0.5;

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
X = 0.0;
Y = AP+AG+ASPcolloid+ASPdomain;
Z = 0.0;
H = Y-(AG+AP+ASPcolloid+ASPdomain);
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
%zoom(5.0)
%surf (xplane,yplane,zplane,'EdgeColor','none')
surf (xus2*AP+X,yus2*AP+Y,zus2*AP+Z)
view(0,45)
axis square
plotdom = RLIM*2;
axis([-plotdom plotdom -plotdom+AG plotdom+AG  -plotdom plotdom ])


%% asperity generation COLLOID
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
[xcap,ycap,zcap]=AFMsphere_capEQ(AP,angasp,angzoi,fzoi,RZOIBULK);


% translate cap relative to colloid center.
xcap=xcap+X;
ycap=ycap+Y;
zcap=zcap+Z;


for i=1:length(xcap)
    figure(1)
    surf (xus2*ASPcolloid+xcap(i),yus2*ASPcolloid+ycap(i),zus2*ASPcolloid+zcap(i));
    %plot3(xasp(i,j),yasp(i,j),AG,'o')
end


%% asperity generation COLLECTOR
% uniform asperities locations
% single size
[xasp_collector,yasp_collector,zasp_collector]=AFM_asp_tracking(X,Y,Z,AG,fzoi,RZOIBULK,ASPdomain);


for i=1:length(xasp_collector)
    figure(1)
    surf (xus2*ASPdomain+xasp_collector(i),yus2*ASPdomain+yasp_collector(i),zus2*ASPdomain+zasp_collector(i));
    %plot3(xasp_collector(i),yasp_collector(i),zasp_collector(i),'o')
end
% draw ZOI boundary on collector
[xcirc,ycirc,zcirc]=AFMcircleXZ(X,Y-AP-ASPcolloid-H/2,Z,RZOIBULK,50);
figure(1)
plot3(xcirc,ycirc,zcirc,'o-g')



