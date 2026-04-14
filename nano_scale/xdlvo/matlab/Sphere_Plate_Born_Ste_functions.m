%Sphere_Plate Born and Ste functions
clc; clear; close all; fclose all;
%% Separation step factor, H as a matrix
Hsf = 1; % percentual 
Hmin = 1e-10; % minimum separation distance
Hmax = 1e-6;  % maximum separation distance
% generate geometric vector
H(1)=Hmin; i=1;
while H(i)<=Hmax
    H(i+1) = H(i)*(1+Hsf/100);
    i=i+1;
end
%% Parameters_Sphere-Plate_Born and Ste
a1=1e-6; %[m] colloid radius
Temp=20;%[°C] temperature
kB=1.3806485E-23;%[J/K] Boltzman constant
h=6.62607004E-34; %[J*s] Planck constant
T=Temp+273.15; %[K]

    %parameters for Hamaker constant
Ve=2042260000000000;%[s-1] Main electronic absorption frequency
eps1=2.55;%Colloid dielectric constant 1
n1=1.557;%Colloid refractive index 1
eps2=3.8; %Colloid dielectric constant 2
n2=1.448; %Colloid refractive index 2
eps3=80; %Fluid dielectric constant
n3=1.333; %Fluid refractive index
A132=(3/4)*kB*T*(eps1-eps3)/(eps1+eps3)*(eps2-eps3)...
    /(eps2+eps3)+3*h*Ve/8/(2)^.5*(n1^2-n3^2)*(n2^2-n3^2)...
    /(n1^2+n3^2)^.5/(n2^2+n3^2)^.5...
    /((n1^2+n3^2)^.5+(n2^2+n3^2)^.5); % [J] Hamaker constant

lambdaSte=5.9e-10;%[m] Steric decay length
gammaoSte=0.010055;%[J/m2] Energy at minimum separation
W132=-0.029;%[J/m2]Work of adhesion
E1=3e9;%[N/m2]Colloid Young's modulus
V1=0.33;%Colloid Poisson's ratio
E2=7.3e10;%[N/m2]Collector Young's modulus
V2=0.22;%Collector Poisson's ratio
Kint=4/3/((1-V1^2)/E1+(1-V2^2)/E2);%[N/m2]Combined elastic modulus
acont=(-6*pi*W132*a1^2/Kint)^(1/3);%[m] Contact radius
aSte=(acont^2+2*lambdaSte*(a1+(a1^2-acont^2)^.5))^.5;%Radius of steric hydration contact
sigmaC=5e-10;%[m]Born collision diameter
%% Born_Ste Functions
%Ste colloid-plate
[deltaG_Ste_colloid_plate]=E_Ste_SP_colloid_plate(H,lambdaSte,gammaoSte,aSte);%[J]
[F_Ste_colloid_plate]=F_Ste_SP_colloid_plate(H,lambdaSte,gammaoSte,aSte);%[N]
%Born colloid_plate
[deltaG_Born_colloid_plate]=E_Born_SP_colloid_plate(H,A132,sigmaC,a1);%[J]
[F_Born_colloid_plate]=F_Born_SP_colloid_plate(H,A132,sigmaC,a1);%[N]

%% write to xls file (apply this part for call results, then compare if 
% there is any error with DLVO Excel file results)
%% set working directory   

% if ~isdeployed
%     % MATLAB environment
%     mfilename('fullpath')
%     datadir = strrep(mfilename('fullpath'),'\Sphere_Plate_RMODE','\');
% else
%     %deployed application
%     datadir=strcat(pwd,'\');   
% end
% filename = strcat(datadir,'SPoutput_Born_Ste.xlsx');
% % write header
% col_header={'H(m)','deltaG_Born_colloidplate(J)','F_Born_colloidplate(N)',...
%             'deltaG_Ste_colloidplate(J)','F_Ste_colloidplate(N)'};
% xlswrite(filename,col_header,'Hoja1','A1'); %change 'Sheet1' instead 'Hoja1'
% % write matrix data
% A(:,1)=H;  A(:,2)=deltaG_Born_colloid_plate; A(:,3)=F_Born_colloid_plate;
% A(:,4)=deltaG_Ste_colloid_plate; A(:,5)=F_Ste_colloid_plate;
% % dump data to file
% xlswrite(filename,A,1,'A2');