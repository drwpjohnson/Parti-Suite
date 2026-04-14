%Sphere_Sphere vdW functions
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
%% Parameters_Sphere-sphere
a1=1e-6; %[m] colloid radius
a2=0.000255;%[m]Collector radius
Temp=20;%[°C] temperature
kB=1.3806485E-23;%[J/K] Boltzman constant
h=6.62607004E-34; %[J*s] Planck constant
T=Temp+273.15; %[K]
lambdavdW=1e-7;%[m] vdW characterisitic wavelength

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

aasp=1.5e-8;%[m] asperity height (only if RMODE>0 and RMS<= 5nm)
e_charge=1.602176621E-19;%elementary charge
Na=6.02214086E+23;%Avogadro number
z=1;%Valence of the symmetric electrolyte
IS=6; %[mol/m3] ionic strength
eps0=8.85418781762E-12; %[C2/(N·m2)] Vacuum permittivity
epsr=80;%Relative permittivity of water
eps=eps0*epsr;
Kminus1=(eps*kB*T/2/Na/z^2/e_charge^2/IS)^.5; % [m]Debye length
RZOI= 2*(Kminus1*a1)^0.5;
Nco=2.5; %number of interactions per asperity (Range betweeen 1-4)
asplim = 0.5*(pi^0.5)*RZOI;
if (aasp>=asplim)
    n = 1; %Number of asperities
else
    n =(RZOI^2)/((aasp^2)/(pi/4)); %Number of asperities
end

%% vdW Functions
%vdW colloid-plate
[F_vdW_colloid_plate]=F_vdW_SS_colloid_plate(H,A132,a1,a2,lambdavdW);%[N]
[deltaG_vdW_colloid_plate]=E_vdW_SS_colloid_plate(H,A132,a1,a2,lambdavdW);%[J]
%vdW RMODE
    RMODE=1;%insert RMODE here
[F_vdW_RMODE1]=F_vdW_SS_RMODE(n,H,a2,A132,aasp,lambdavdW,a1,RMODE);%[N]
[deltaG_vdW_RMODE1]=E_vdW_SS_RMODE(n,H,A132,aasp,a2,lambdavdW,a1,RMODE);%[J]
    RMODE=2;%insert RMODE here
[F_vdW_RMODE2]=F_vdW_SS_RMODE(n,H,a2,A132,aasp,lambdavdW,a1,RMODE);%[N]
[deltaG_vdW_RMODE2]=E_vdW_SS_RMODE(n,H,A132,aasp,a2,lambdavdW,a1,RMODE);%[J]
    RMODE=3;%insert RMODE here
[F_vdW_RMODE3]=F_vdW_SS_RMODE(n*Nco,H,a2,A132,aasp,lambdavdW,a1,RMODE);%[N]
[deltaG_vdW_RMODE3]=E_vdW_SS_RMODE(n*Nco,H,A132,aasp,a2,lambdavdW,a1,RMODE);%[J]


%% vdW Coated systems
    % coated systems parameters
    
    %A2p_2p----->"p" refers to "prime"
T1=0; %Colloid coating thickness 1
T2=0; %Collector coating thickness 2
A1_1=0; %Colloid Hamaker constant
A1p_1p=0; %Colloid coating Hamaker constant
A2_2=0; %Collector Hamaker constant
A2p_2p=0; %Collector coating Hamaker constant
A3_3=0; %Fluid Hamaker constant

%Combined Hamaker constant - Coated systems
    if T1==0 && T2==0 %Colloid - Collector
        A1_2=0;
        else
        A1_2=A1_1^.5*A2_2^.5;
    end

    if T2==0 %Colloid - Collector coating
        A1_2p=0;
        else
        A1_2p=A1_1^.5*A2p_2p^.5;
    end

    if T1==0 && T2==0 %Colloid - Fluid
        A1_3=0;
        else
        A1_3=A1_1^.5*A3_3^.5;
    end

    if T1==0 %Colloid coating - Collector
        A1p_2=0;
        else
        A1p_2=A1p_1p^.5*A2_2^.5;
    end

    if T1==0||T2==0 %Colloid coating - Collector coating
        A1p_2p=0; 
        else
        A1p_2p= A1p_1p^.5*A2p_2p^.5;
    end

    if T1==0 %Colloid coating - Fluid
       A1p_3=0; 
        else
        A1p_3=A1p_1p^.5*A3_3^.5;
    end

    if T1==0 && T2==0  %Collector - Fluid
        A2_3=0;
        else
        A2_3=A3_3^.5*A2_2^.5;
    end

    if T2==0 %Collector coating - Fluid
        A2p_3=0;
        else
        A2p_3=A3_3^.5*A2p_2p^.5;
    end
    
    %INSERT TYPE OF COATED SYSTEM;
system=1;%Layered_colloid_Layered_collector 
%Hamaker constant contributions - Layered colloid - Layered collector
        %Ac---> "c" refers to Hamaker constant contributions
if system==1
    if T1==0||T2==0 %Colloid coating - Collector coating
        Ac_1p_2p=0;
        else
        Ac_1p_2p=A1p_2p-A2p_3-A1p_3+A3_3;
    end
    
    if T1==0||T2==0 %Colloid - Collector coating
        Ac_1_2p=0;
        else
        Ac_1_2p=A1_2p-A1p_2p-A1_3+A1p_3;
    end
    
    if T1==0||T2==0 %Colloid coating - Collector
        Ac_1p_2=0;
        else
        Ac_1p_2=A1p_2-A2_3-A1p_2p+A2p_2p;
    end
    
    if T1==0||T2==0 %Colloid - Collector
        Ac_1_2=0;
        else
        Ac_1_2=A1_2-A1p_2-A1_2p+A1_1;
    end
end
[F_vdW_CS_1]=F_vdW_SS_coated_systems(H,a1,a2,lambdavdW,...
              T1,T2,Ac_1p_2p,Ac_1_2p,Ac_1p_2,Ac_1_2,system); %[N]

[E_vdW_CS_1]=E_vdW_SP_coated_systems(H,a1,lambdavdW,...
             T1,T2,Ac_1p_2p,Ac_1_2p,Ac_1p_2,Ac_1_2,system);%[J]

%Hamaker constant contributions - Colloid - Layered collector
system=2; %Colloid_Layered_collector
if system==2
    if T1>0 %Colloid - Collector coating
        Ac_1_2p=0;
        else
        Ac_1_2p=A1_2p-A2p_3-A1_3+A3_3;
    end
       
    if T1>0 %Colloid - Collector
        Ac_1_2=0;
        else
        Ac_1_2=A1_2-A2_3-A1_2p+A3_3;
    end  
 [F_vdW_CS_2]=F_vdW_SS_coated_systems(H,a1,a2,lambdavdW,...
              T1,T2,Ac_1p_2p,Ac_1_2p,Ac_1p_2,Ac_1_2,system); %[N]

[E_vdW_CS_2]=E_vdW_SS_coated_systems(H,a1,a2,lambdavdW,...
                    T1,T2,Ac_1p_2p,Ac_1_2p,Ac_1p_2,Ac_1_2,system);%[J]
end

%Hamaker constant contributions - Layered colloid - Collector
system=3;
if system==3 %Layered_colloid_Collector
    if T2>0 %Colloid coating - Surface
        Ac_1p_2=0;
        else
        Ac_1p_2=A1p_2-A2_3-A1p_3+A3_3;
    end
    
    if T2>0 %Colloid - Surface
        Ac_1_2=0;
        else
        Ac_1_2=A1_2-A1p_2-A1_3+A1p_1p;
    end
    
    [F_vdW_CS_3]=F_vdW_SS_coated_systems(H,a1,a2,lambdavdW,...
              T1,T2,Ac_1p_2p,Ac_1_2p,Ac_1p_2,Ac_1_2,system); %[N]

    [E_vdW_CS_3]=E_vdW_SS_coated_systems(H,a1,a2,lambdavdW,...
             T1,T2,Ac_1p_2p,Ac_1_2p,Ac_1p_2,Ac_1_2,system);%[J]
end

%% write to xls file (apply this part for call results, then compare if 
% there is any error with DLVO Excel file results)

% % set working directory        
% if ~isdeployed
%     % MATLAB environment
%     mfilename('fullpath')
%     datadir = strrep(mfilename('fullpath'),'\Sphere_Sphere_RMODE','\');
% else
%     %deployed application
%     datadir=strcat(pwd,'\');   
% end
% filename = strcat(datadir,'SSoutput_vdW.xlsx');
% % write header
% col_header={'H(m)','deltaG_vdW_colloidplate(J)','F_vdW_colloidplate(N)',...
%             'deltaG_vdW_RMODE1(J)','F_vdW(N)_RMODE1'...
%             'deltaG_vdW_RMODE2(J)','F_vdW(N)_RMODE2'...
%             'deltaG_vdW_RMODE3(J)','F_vdW(N)_RMODE3'};
% xlswrite(filename,col_header,'Hoja1','A1'); %change 'Sheet1' instead 'Hoja1'
% % write matrix data
% A(:,1)=H;  A(:,2)=deltaG_vdW_colloid_plate; A(:,3)=F_vdW_colloid_plate;
% A(:,4)=deltaG_vdW_RMODE1; A(:,5)=F_vdW_RMODE1;
% A(:,6)=deltaG_vdW_RMODE2; A(:,7)=F_vdW_RMODE2;
% A(:,8)=deltaG_vdW_RMODE3; A(:,9)=F_vdW_RMODE3;
% % dump data to file
% xlswrite(filename,A,1,'A2');