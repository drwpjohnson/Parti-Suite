clc; clear; close all;
% test normal and tangential vectors from TRAJHAP,
% gravity vector consistency with gravity and flow alignment
% the model has flow in the Z- direction for all cases
% gravity can be +Z -Z +X -X
%% set geometry
% happel sphere
AG = 1.0;
Xm0 = 0.0;
Ym0 = 0.0;
Zm0 = 0.0;
%
[xh,yh,zh] = sphere;
xh = xh*AG;
yh = yh*AG;
zh = zh*AG;
%
POROSITY = 0.5;
%% set gravity
FG = 1.5; % gravity magnitude
% gravity unit vector
EGX = 0;
EGY = 0;
EGZ = +1;
% gravity vector
FGX = FG*EGX;
FGY = FG*EGY;
FGZ = FG*EGZ;
%% prepare plot
figure(1)
subplot(1,2,1)
surf(xh,yh,zh)
dom = 2*AG;
axis([-dom dom -dom dom -dom dom])
xlabel('x');ylabel('y');zlabel('z');
set(gca,'FontSize',20)

hold on
subplot(1,2,2)
surf(xh,yh,zh)
dom = 2*AG;
axis([-dom dom -dom dom -dom dom])
xlabel('x');ylabel('y');zlabel('z');
set(gca,'FontSize',20)

hold on
%% particle location
% pc = 1 custom
% pc = 2 random
% pc =  3 multiple positions along a randomly located arc from z to -z
pc=3;
if pc==1
    % CUSTOM particle location
    X = 0.0;
    Y = 0.0;
    Z = 1;
    D = (X*X+Y*Y+Z*Z).^0.5;
    R = AG*1.4;
    X = X/D*R;
    Y = Y/D*R;
    Z = Z/D*R;
    np=1;
end
if pc==2
    % random particle location
    X = (rand*2-1);
    Y = (rand*2-1);
    Z = (rand*2-1);
    D = (X*X+Y*Y+Z*Z).^0.5;
    R = AG*1.4;
    X = X/D*R;
    Y = Y/D*R;
    Z = Z/D*R;
    np =1;
end
if pc==3
    % random orientation in XY plane
    ang = rand*2*pi;
    np = 5;
    % position vector length XYZ
    R = AG*1.4;
    % angles realtive to xy
    angz = linspace(pi/2,-pi/2,np);
    % z coordinates
    ZV = R*sin(angz);
    % calculate rxy vector
    RXY = (R.*R-ZV.*ZV).^0.5;
    % calculate components
    % along the same arc
    XV = RXY*cos(ang);
    YV = RXY*sin(ang);
end
%% flow field parameters
    %CALCULATE Happel sphere-in-cell model analytical streamline function parameters (from Rajagopalan & Tien, 1976)
    PP = (1-POROSITY)^(1.0/3.0);
    WW = 2.0-3.0*PP+3.0*PP^5.0-2.0*PP^6.0;
    K1 = 1/WW;
    K2 = -(3.0+2.0*PP^5.0)/WW;
    K3 = (2.0+3.0*PP^5.0)/WW;
    K4 = -PP^5.0/WW;
    % SLIP LENGTH
    B = 0.0;
    %FLUID SHELL RADIUS
    RB = AG/((1-POROSITY)^(1.0/3.0));
    % superficial velocity
    VSUP = 1.0;
for i=1:np
    if np>1
        X =XV(i);
        Y =YV(i);
        Z =ZV(i);
    end
    %% calculate Happel flow field and normal and tangential vectors
    [VxH1,VyH1,VzH1]= HAPPELFF (X,Y,Z,B,K1,K2,K3,K4,AG);
    %fluid velocity component are dimensionless, scaled via VSUP
    VX = VxH1*(VSUP);
    VY = VyH1*(VSUP);
    VZ = VzH1*(VSUP);
    %   CALCULATE NORMAL UNIT VECTORS (dictated by collector center)
    ENX = (X-Xm0)/R;
    ENY = (Y-Ym0)/R;
    ENZ = (Z-Zm0)/R ;
    % CALCULATE TANGENTIAL UNIT VECTORS  (dictated from flow field)
    % normal and tangetinal fluid velocities
    VN = VX*ENX+VY*ENY+VZ*ENZ;
    VNX = VN*ENX;
    VNY = VN*ENY;
    VNZ = VN*ENZ;
    VTX = VX-VNX;
    VTY = VY-VNY;
    VTZ = VZ-VNZ;
    VT = (VTX*VTX+VTY*VTY+VTZ*VTZ)^0.5;
    % tangential vectors
    ETX = VTX/VT;
    ETY = VTY/VT;
    ETZ = VTZ/VT;
    %% gravity calculate projection of gravity XYZ to normal/tangential
    [FGN,FGT,FGNX,FGNY,FGNZ,FGTX,FGTY,FGTZ]= HFUNGVECT(FG,EGX,EGY,EGZ,ENX,ENY,ENZ,ETX,ETY,ETZ);
    %% prepare plot arrays
    % arrays for quiver3 plot
    % NORMAL components
    EN = [X Y Z ENX 0   0;
          X Y Z 0   ENY 0;
          X Y Z 0   0   ENZ];
    % TANGENTIAL components
    ET = [X Y Z ETX 0   0;
          X Y Z 0   ETY 0;
          X Y Z 0   0   ETZ];
    % GRAVITY components normal
    VFGN = [X Y Z FGNX 0    0;
            X Y Z 0    FGNY 0;
            X Y Z 0    0    FGNZ];    
    % GRAVITY components tangential
    VFGT = [X Y Z FGTX 0    0;
            X Y Z 0    FGTY 0;
            X Y Z 0    0    FGTZ];        
    %% plot
    
    figure (1)
    subplot(1,2,1)
    plot3(X,Y,Z,'ok','MarkerFaceColor','r')
    axis square
    %unit vectors
    lw = 1.5; % line width
    sc = 0.3; % scale
    %normals
    quiver3(X,Y,Z,ENX,ENY,ENZ,sc,'-r','linewidth',lw)
    quiver3(EN(:,1),EN(:,2),EN(:,3),EN(:,4),EN(:,5),EN(:,6),sc,'-r','linewidth',lw)
    %tangentials
    quiver3(X,Y,Z,ETX,ETY,ETZ,sc,'-b','linewidth',lw)
    quiver3(ET(:,1),ET(:,2),ET(:,3),ET(:,4),ET(:,5),ET(:,6),sc,'-b','linewidth',lw)
    %
    subplot(1,2,2)
    plot3(X,Y,Z,'ok','MarkerFaceColor','r')
    axis square
    %unit vectors
    lw = 2.0; % line width
    sc = 0.3; % scale
    % gravity vector
    quiver3(X,Y,Z,FGX,FGY,FGZ,sc,'--k','linewidth',lw)
    %normal axis
    quiver3(X,Y,Z,ENX,ENY,ENZ,sc,'-r','linewidth',lw)
    %gravity on normal
    quiver3(X,Y,Z,FGNX,FGNY,FGNZ,sc,'--g','linewidth',lw)
    %quiver3(EN(:,1),EN(:,2),EN(:,3),EN(:,4),EN(:,5),EN(:,6),sc,'-r','linewidth',lw)
    %tangential axis
    quiver3(X,Y,Z,ETX,ETY,ETZ,sc,'-b','linewidth',lw)
    %gravity on tangential
    quiver3(X,Y,Z,FGTX,FGTY,FGTZ,sc,'--g','linewidth',lw)
    %quiver3(ET(:,1),ET(:,2),ET(:,3),ET(:,4),ET(:,5),ET(:,6),sc,'-b','linewidth',lw)
end


