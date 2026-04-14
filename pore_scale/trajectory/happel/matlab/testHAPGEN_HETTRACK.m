clc; clear; close all;
%% inputs
% collector center (m)
Xm0=0.0; Ym0=0.0; Zm0=0.0;
% collector diameter (m)
AG = 2.55E-4; %2.55E-4;
% fraction hetdomains surface coverage
SCOV = 0.0005;
% HETMODE (number of hetdomains pattern to repeat: 1 single, 5 for bimodal (1 large+ 4 smalls)
HETMODE = 5;
% hetdomain radii(m)
RHET0 = 1.8e-7; %single size or large hetdomain
RHET1 = RHET0/3.0; %small hetdomains (only used in HETMODE =5)
%% generate geometry and hetdomains - call HAPHETGEN function 
nfig=1; % define figure number
[XHETall,YHETall,ZHETall,genSCOV]=HAPHETGEN (Xm0,Ym0,Zm0,AG,SCOV,HETMODE,RHET0,RHET1,nfig);
%% generate n colloids in space and highlight closest hetdomains
% locate colloid at fixed distance and randomly orientations from the surface in fluid shell
for n=1:50
     dist = 1.0*AG;
%     % random unit vectors
    dom=0.2*AG;
     x=(rand*2-1); y=(rand*2-1); %z=(rand*2-1);
     z=-1;
     rvec = ((x-Xm0)^2+(y-Ym0)^2+(z-Zm0)^2)^0.5;
     %     % scale location to fix dist
     x=x/rvec*dist; y=y/rvec*dist; z=z/rvec*dist;

%   x=0.1; y=0.0; z=1.2*AG;
%   x=0.5*AG; y=0.0; z=1.2*AG;
    % call Hetdomain tracking function HAPHETTRACK
    [XHET,YHET,ZHET,RHET]=HAPHETTRACK(x,y,z,Xm0,Ym0,Zm0,AG,...
                              HETMODE,SCOV,RHET0,RHET1);
    %% plot colloid, line connecting to collector center and closest hetdomain(s)
    figure (nfig)
    plot3(x,y,z,'o k','MarkerFaceColor','r','MarkerSize',8);   
    plot3([x Xm0],[y Ym0],[z Zm0],'- k','LineWidth',1.5);   
    plot3(XHET,YHET,ZHET,'d b','LineWidth',1.0,'MarkerSize',6);
    % lines below change point of view location looking at origin
%     az = 0;
%     el = 90;
%     view(az, el);
    drawnow
    
  
end





