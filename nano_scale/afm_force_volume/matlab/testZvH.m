clc; clear; close all;
% HRADWIRE VALUES
H0=0.158E-9;    %MINIMUM SEPARATION DISTANCE (M)
AG = 1.0;
%domain parameters
RLIM = 1e-4;
AP = 5e-7;

HMAX = 5e-7;


[XINIT,YINIT,RINJ]=AFMINITIAL (RLIM);  



 %% H range parameters
    HMAX = 5e-7; %maximum separation distance (m)
    % geometric factor to step size from ZMAX to ZMIN
    % has to be >1.0
    GFACT = 1.01;
    % define range, updating the coordinates to collector center
    if RMODE==0 %smooth surfaces
        HMIN = H0+AP+AG;
        ZSURF =  (AG-(XINIT^2.0 + YINIT^2.0))^0.5;
        RINIT = (XINIT^2.0 + YINIT^2.0 + ZMAX^2.0)^0.5;
        HINIT = RINIT-AP-AG;
        ZINIT = ZMAX;
    end
    if RMODE==1||2 %roughnes on one surface colloid(1) or collector(2) 
        HMIN = H0+AP+AG+ASP;
        ZSURF =  (AG-(XINIT^2.0 + YINIT^2.0))^0.5;
        RINIT = (XINIT^2.0 + YINIT^2.0 + ZMAX^2.0)^0.5;
        HINIT = RINIT-AP-AG-ASP;
        ZINIT = ZMAX;
    end
    if RMODE==3 %roughnes on both surfaces colloid and collector
        HMIN = H0+AP+AG+2*ASP;
        ZSURF =  (AG-(XINIT^2.0 + YINIT^2.0))^0.5;
        RINIT = (XINIT^2.0 + YINIT^2.0 + ZMAX^2.0)^0.5;
        HINIT = RINIT-AP-AG-2*ASP; 
        ZINIT = ZMAX;
    end 

% geometric factor to step size from ZMAX to ZMIN
% has to be >1.0
GFACT = 1.01
HVECTOR(1)=HMAX
i=1;
while HVECTOR(i)>H0
    i=i+1;
    HVECTOR(i)=HVECTOR(i-1)/GFACT;
end
%number of locations
nsteps =length(HVECTOR);

plot(HVECTOR,'s-b')
set(gca,'FontSize',20)