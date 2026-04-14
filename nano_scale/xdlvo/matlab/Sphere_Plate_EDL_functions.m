%Sphere_Plate_EDL functions
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
%% Parameters_Sphere-Plate_EDL
a1=1e-6; %[m] colloid radius
Temp=20;%[°C] temperature
kB=1.3806485E-23;%[J/K] Boltzman constant
h=6.62607004E-34; %[J*s] Planck constant
T=Temp+273.15; %[K]
lambdavdW=1e-7;%[m] vdW characterisitic wavelength
theta=1-pi/4;   
zeta1=-.051;%[V]Colloid zeta potential
zeta2=-.06;%[V] Collector zeta potential
IS=6; %[mol/m3] ionic strength

e_charge=1.602176621E-19;%elementary charge
Na=6.02214086E+23;%Avogadro number
z=1;%Valence of the symmetric electrolyte
eps0=8.85418781762E-12; %[C2/(N·m2)] Vacuum permittivity
epsr=80;%Relative permittivity of water
eps=eps0*epsr;
Kminus1=(eps*kB*T/2/Na/z^2/e_charge^2/IS)^.5; % [m]Debye length
K=1/Kminus1;%[m^-1]Inverse debye length
aasp=1.5e-8;%[m] asperity height (only if RMODE>0 and RMS<= 5nm)
RZOI= 2*(Kminus1*a1)^0.5;
Nco=2.5; %number of interactions per asperity (Range betweeen 1-4)
asplim = 0.5*(pi^0.5)*RZOI;
if (aasp>=asplim)
    n = 1; %Number of asperities
else
    n =(RZOI^2)/((aasp^2)/(pi/4)); %Number of asperities
end

%% EDL Functions
%EDL colloid-plate
[deltaG_EDL_colloid_plate]=E_EDL_SP_colloid_plate(H,theta,eps,K,kB,T,z,zeta1,e_charge,zeta2,a1);%[J]
[F_EDL_colloid_plate]=F_EDL_SP_colloid_plate(H,theta,eps,K,kB,T,z,zeta1,e_charge,zeta2,a1);%[N]
%EDL RMODE
    RMODE=1; %insert RMODE here
[F_EDL_RMODE1]=F_EDL_SP_RMODE(H,n,eps,K,kB,T,z,zeta1,e_charge,zeta2,aasp,a1,RMODE);%[N]
[deltaG_EDL_RMODE1]=E_EDL_SP_RMODE(H,n,eps,K,kB,T,z,zeta1,e_charge,zeta2,aasp,a1,RMODE);%[J]
    RMODE=2; %insert RMODE here
[F_EDL_RMODE2]=F_EDL_SP_RMODE(H,n,eps,K,kB,T,z,zeta1,e_charge,zeta2,aasp,a1,RMODE);%[N]
[deltaG_EDL_RMODE2]=E_EDL_SP_RMODE(H,n,eps,K,kB,T,z,zeta1,e_charge,zeta2,aasp,a1,RMODE);%[J]
    RMODE=3; %insert RMODE here
[F_EDL_RMODE3]=F_EDL_SP_RMODE(H,n*Nco,eps,K,kB,T,z,zeta1,e_charge,zeta2,aasp,a1,RMODE);%[N]
[deltaG_EDL_RMODE3]=E_EDL_SP_RMODE(H,n*Nco,eps,K,kB,T,z,zeta1,e_charge,zeta2,aasp,a1,RMODE);%[J]

%% write to xls file (apply this part for call results, then compare if 
% there is any error with DLVO Excel file results)

% % set working directory        
% if ~isdeployed
%     % MATLAB environment
%     mfilename('fullpath')
%     datadir = strrep(mfilename('fullpath'),'\Sphere_Plate_RMODE','\');
% else
%     %deployed application
%     datadir=strcat(pwd,'\');   
% end
% filename = strcat(datadir,'SPoutput_EDL.xlsx');
% % write header
% col_header={'H(m)','deltaG_EDL_colloidplate(J)','F_EDL_colloidplate(N)',...
%             'deltaG_EDL_RMODE1(J)','F_EDL(N)_RMODE1'...
%             'deltaG_EDL_RMODE2(J)','F_EDL(N)_RMODE2'...
%             'deltaG_EDL_RMODE3(J)','F_EDL(N)_RMODE3'};
% xlswrite(filename,col_header,'Hoja1','A1'); %change 'Sheet1' instead 'Hoja1'
% % write matrix data
% A(:,1)=H;  A(:,2)=deltaG_EDL_colloid_plate; A(:,3)=F_EDL_colloid_plate;
% A(:,4)=deltaG_EDL_RMODE1; A(:,5)=F_EDL_RMODE1;
% A(:,6)=deltaG_EDL_RMODE2; A(:,7)=F_EDL_RMODE2;
% A(:,8)=deltaG_EDL_RMODE3; A(:,9)=F_EDL_RMODE3;
% % dump data to file
% xlswrite(filename,A,1,'A2');