%Sphere-Sphere Born and Ste functions
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
%% Parameters_Sphere-Sphere_Born and Ste
a1=1e-6; %[m] colloid radius
Temp=20;%[°C] temperature
kB=1.3806485E-23;%[J/K] Boltzman constant
h=6.62607004E-34; %[J*s] Planck constant
T=Temp+273.15; %[K]
sigmaC=5e-10;%[m]Born collision diameter

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

lambdaSte=4e-10;%[m] Steric decay length
gammaoSte=0.0195;%[J/m2]Energy at minimum separation

%Acid-base surface energy components
gamma1plus=0;
gamma1minus=1.1;
gamma2plus=.4;
gamma2minus=37.4;
gamma3plus=25.5;
gamma3minus=25.5;
gammaoAB=2*1000^-1*((gamma3plus)^.5*((gamma1minus)^.5+(gamma2minus)^.5-...
    (gamma3minus)^.5)+(gamma3minus)^.5*...
    ((gamma1plus)^.5+(gamma2plus)^.5-(gamma3plus)^.5)-...
    (gamma1plus*gamma2minus)^.5-(gamma1minus*gamma2plus)^.5);%[J/m2] Acid-base energy at minimum separation
         
%Work of adhesion (for contact area
    gamma1LW=42;
    gamma2LW=32.9;
    gamma3LW=21.8;
    W132=2*1000^-1*((gamma1LW*gamma3LW)^.5+(gamma2LW*gamma3LW)^.5-(gamma1LW*gamma2LW)^.5-gamma3LW)+gammaoAB;%[J/m2]Work of adhesion

E1=3e9;%[N/m2]Colloid Young's modulus
V1=0.33;%Colloid Poisson's ratio
E2=7.3e10;%[N/m2]Collector Young's modulus
V2=0.22;%Collector Poisson's ratio
Kint=4/3/((1-V1^2)/E1+(1-V2^2)/E2);%[N/m2]Combined elastic modulus
acont=(-6*pi*W132*a1^2/Kint)^(1/3);%[m] Contact radius
aSte=(acont^2+2*lambdaSte*(a1+(a1^2-acont^2)^.5))^.5;%Radius of steric hydration contact
%% Born_Ste Functions
%Born
[deltaG_Born]=E_Born_SS(H,A132,sigmaC,a1);%[J]
[F_Born]=F_Born_SS(H,A132,sigmaC,a1);%[N]
%Ste
[deltaG_Ste]=E_Ste_SS(H,lambdaSte,gammaoSte,aSte);%[J]
[F_Ste]=F_Ste_SS(H,lambdaSte,gammaoSte,aSte);%[N]

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
% filename = strcat(datadir,'SSoutput_Born_Ste.xlsx');
% % write header
% col_header={'H(m)','deltaG_Born(J)','F_Born(N)',...
%             'deltaG_Ste(J)','F_Ste(N)'};
% xlswrite(filename,col_header,'Hoja1','A1'); %change 'Sheet1' instead 'Hoja1'
% % write matrix data
% A(:,1)=H;  A(:,2)=deltaG_Born; A(:,3)=F_Born;
% A(:,4)=deltaG_Ste; A(:,5)=F_Ste;
% % dump data to file
% xlswrite(filename,A,1,'A2');