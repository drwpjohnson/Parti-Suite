%Sphere_Plate_AB functions
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
%% Parameters_Sphere-Plate_AB
a1=1e-6; %[m] colloid radius
Temp=20;%[°C] temperature
kB=1.3806485E-23;%[J/K] Boltzman constant
T=Temp+273.15; %[K]
lambdaAB=6e-10;%[m] Lewis acid-base decay length
ho=1.58e-10;%[m]Minimum Separation Distance
gammaoAB=-0.027;%[J/m2] Acid-base energy at minimum separation
aasp=1.5e-8;%[m] asperity height (only if RMODE>0 and RMS<= 5nm)
Nco=2.5; %number of interactions per asperity (Range betweeen 1-4)
RZOIAB=2*(lambdaAB*a1)^0.5;
asplimAB = 0.5*(pi^0.5)*RZOIAB;
if (aasp>=asplimAB)
    nAB = 1; %number of asperities within RZOI for AB
else
    nAB = pi/4*((RZOIAB^2)/(aasp^2)); %number of asperities within RZOI for AB
end

%% AB Functions
%AB colloid-plate
[deltaG_AB_colloid_plate]=E_AB_SP_colloid_plate(H,lambdaAB,a1,gammaoAB,ho);%[J]
[F_AB_colloid_plate]=F_AB_SP_colloid_plate(H,lambdaAB,a1,gammaoAB,ho);%[N]
%AB RMODE
    RMODE=1; %insert RMODE here
[deltaG_AB_RMODE1]=E_AB_SP_RMODE(H,lambdaAB,aasp,nAB,gammaoAB,ho,RMODE,a1);%[J]
[F_AB_RMODE1]=F_AB_SP_RMODE(H,lambdaAB,aasp,nAB,gammaoAB,ho,RMODE,a1);%[N]
    RMODE=2; %insert RMODE here
[deltaG_AB_RMODE2]=E_AB_SP_RMODE(H,lambdaAB,aasp,nAB,gammaoAB,ho,RMODE,a1);%[J]
[F_AB_RMODE2]=F_AB_SP_RMODE(H,lambdaAB,aasp,nAB,gammaoAB,ho,RMODE,a1);%[N]
    RMODE=3; %insert RMODE here
[deltaG_AB_RMODE3]=E_AB_SP_RMODE(H,lambdaAB,aasp,nAB*Nco,gammaoAB,ho,RMODE,a1);%[J]
[F_AB_RMODE3]=F_AB_SP_RMODE(H,lambdaAB,aasp,nAB*Nco,gammaoAB,ho,RMODE,a1);%[N]

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
% filename = strcat(datadir,'SPoutput_AB.xlsx');
% % write header
% col_header={'H(m)','deltaG_AB_colloidplate(J)','F_AB_colloidplate(N)',...
%             'deltaG_AB_RMODE1(J)','F_AB(N)_RMODE1'...
%             'deltaG_AB_RMODE2(J)','F_AB(N)_RMODE2'...
%             'deltaG_AB_RMODE3(J)','F_AB(N)_RMODE3'};
% xlswrite(filename,col_header,'Hoja1','A1'); %change 'Sheet1' instead 'Hoja1'
% % write matrix data
% A(:,1)=H;  A(:,2)=deltaG_AB_colloid_plate; A(:,3)=F_AB_colloid_plate;
% A(:,4)=deltaG_AB_RMODE1; A(:,5)=F_AB_RMODE1;
% A(:,6)=deltaG_AB_RMODE2; A(:,7)=F_AB_RMODE2;
% A(:,8)=deltaG_AB_RMODE3; A(:,9)=F_AB_RMODE3;
% % dump data to file
% xlswrite(filename,A,1,'A2');