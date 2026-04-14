% test code for happel flowfield single position PNS_HAPPELFF.m
clc; clear; close all;
%% define conditions
vsup = -1.62e-5; %(m/s)
por = 0.375; %(-)
ag = 2.55e-4; %(m)
%% CALCULATE Happel sphere-in-cell model analytical streamline function parameters (from Rajagopalan & Tien, 1976)
PP = (1-por)^(1.0/3.0);
WW = 2.0-3.0*PP+3.0*PP^5.0-2.0*PP^6.0;
K1 = 1/WW;
K2 = -(3.0+2.0*PP^5.0)/WW;
K3 = (2.0+3.0*PP^5.0)/WW;
K4 = -PP^5.0/WW;
%FLUID SHELL RADIUS
rb = ag/((1-por)^(1.0/3.0));
%slip length
b=0;
% CALCULATE POSIITONIN TERMS OF h AT 45 DEGRESS
ap = 0.5e-6; %(m)
% h  = 1e-8:1e-8:(rb-ag-ap); %(m)
h  = 1e-8:1e-8:2.0e-7; %(m)
r = ag+h+ap;
% angle
ang = pi/4;
% get point coordinates and normal vectors
x =cos(ang)*r; z =sin(ang)*r; y=0.0*ones(1,length(r)); enx=x./r; enz=z./r; eny=y./r;
for i=1:length(z)
    [vx(i),vy(i),vz(i)]= HAPPELFF(x(i),0.0,z(i),b,K1,K2,K3,K4,ag);   
end
VXH = vx*vsup;
VYH = vy*vsup;
VZH = vz*vsup;
V = ((VXH.*VXH).^2+(VYH.*VYH).^2+(VZH.*VZH).^2).^0.5;
VNH = ((enx.*VXH).^2+(eny.*VYH).^2+(enz.*VZH).^2).^0.5;
VTH = ((VXH-enx.*VXH).^2+(VYH-enx.*VYH).^2+(VZH-enx.*VZH).^2).^0.5;

figure (1)
plot (h,VNH,'o-b','LineWidth',2)
grid on; hold on;
plot (h,VTH,'x-r','LineWidth',2)
xlabel ('H(m)'); ylabel('Fluid Velocity (m/s)');
legend ('VN','VT');
set (gca,'FontSize',15);