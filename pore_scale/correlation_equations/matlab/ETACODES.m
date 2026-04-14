% Eta calculations 'Rajogapalan and Tien, 1976','Tufenkji and
% Elimielech, 2004','Ma,Pedel,Fife,Jhonson 2015','Long and Hilpert, 2011','Nelson and Ginn, 2011')
clc; clear; close all
%% Setting parameters and constants
%Collector diameter (mm)
dci = 0.2; dc = dci*0.001; %(m)
%Particle size (um)
dpi = 1; dp = dpi*0.000001; %(m)
%Pore water velocity (m/day)
vi = 7.1; v = vi/86400; %(m/s)
% Particle density (kg/m3)
denp = 1055; 
% Fluid density (kg/m3)
denf = 998;
% fluid viscosity (kg/ms)
visf = 0.000998;
%Temperatura (K)
T = 298.2;
%Hamaker constant (J)
A = 3.84E-21;
%Porosity 
f = 0.4; p = (1-f)^(1/3); w = 2-(3*p)+(3*(p^5))-(2*(p^6));
%Fluid approach velocity (m3/m2/day)
Ui = vi*f; U = Ui/86400;

Scf = 0.06; %Scale factor
Ceff = 0.08; %Collector efficiency

%Boltzmann constant (j/kg)
B = 1.381E-23;

 

%% Dimensionless numbers
%DIffusion Coeficient (m2/s)
D = (B*T)/(6*pi*visf*(dp/2));
%Happel model parameter
As = (2*(1-((1-f)^(5/3))))/((2-(3*((1-f)^(1/3)))+(3*((1-f)^(5/3)))-(2*(1-f)^2)));
 Nr = dp/dc; %Aspect ratio
 Nlo = A/(9*pi*visf*((dp/2)^2)*U); %Numero de London
 Nvdw = A/(B*T); %Numero de van der waals
 Na = A/(12*pi*visf*U*((dc/2)^2)); %Attraction number
 Npe = U*dc/D; %Numero de Peclet
 Ng = (2*((dp/2)^(2))*(denp-denf)*9.806)/(9*visf*U); %Numero de gravedad
 Ngi = 1/(1+Ng);
 g=(1-f)^(1/3);
 
 %% Rajogapalan correlations
 
 etadr = g^2*4*As^(1/3)*Npe^(-2/3);
 etair = As*Nlo^(1/8)*Nr^(15/8);
 etagr = 0.00338*As*Ng^1.2*Nr^-0.4;
 etar = etadr + etair + etagr;
 
 % velocity rate rajogapalan
 
 kfr = -(3/2)*((1-f)^(1/3)*v/dc)*log(1-etar); 
 
 %% Tufenki and Elimelech correlations
 
 etadt = 2.4*(As^(1/3))*(Nr^-0.081)*(Npe^-0.715)*(Nvdw^0.052);
 etait = 0.55*As*(Nr^1.675)*(Na^0.125);
 etagt = 0.22*(Nr^-0.24)*(Ng^1.11)*(Nvdw^0.053);
 etat = etadt + etait + etagt;
 
 % velocity rate Tufenki and Elimelech
 
 kft = -(3/2)*((1-f)*v/dc)*log(1-etat); 
 
  %% Ma and Jhonson correlations
 
 etadm = g^2*((8+4*(1-g)*(As^(1/3))*(Npe^(1/3)))/(8+(1-g)*Npe^(0.97)))*(Nlo^0.015)*(Ngi^0.8)*(Nr^0.028);
 etaim = As*(Nr^(15/8))*(Nlo^(1/8));
 etagm = 0.7*(Nr^-0.05)*Ng*(Ngi/(Ngi+0.9));
 etam = etadm + etaim + etagm;
 
 % velocity rate Ma and Jhonson
 
 kfm = -(3/2)*(((1-f)*v)/dc)*(log(1-etam))*(((3-f)/(3-3*f))-((2*(3-f))/(pi*(3-3*f)))*acos(((3-3*f)/(3-f))^0.5)+(2/pi)*((2*((3-f)/(3-3*f))^(0.5))-1)^0.5); 
 
  %% Long and Hilpert correlations
 
 etadl = 15.56*(g^6/((1-g^3)^2))*(Npe^-0.65)*(Nr^0.19);
 etail = 0.55*As*(Nr^1.675)*(Na^0.125);
 etagl = 0.22*(Nr^-0.24)*(Ng^1.11)*(Nvdw^0.053);
 etal = etadl + etail + etagl;
 
 % velocity rate Long and Hilpert
 
 kfl = -(3/2)*((1-f)*v/dc)*log(1-etal);
 
  %% Nelson and Ginn correlations
 
 etadn = (g^2)*(2.4*As^(1/3))*((Npe/(Npe+16))^0.75)*(Npe^-0.68)*(Nlo^0.015)*(Ngi^0.8);
 etain = As*Nlo^(1/8)*Nr^(15/8);
 etagn = 0.7*(Nr^-0.05)*Ng*(Ngi/(Ngi+0.9));
 etan = etadn + etain + etagn;
 
 % velocity rate Nelson adn Ginn
 
 kfn = -(3/2)*((1-f)^(1/3)*v/dc)*log(1-etan);
 %% Parametros de simulacion

 kfdr = kfr*86400*Ceff;
 kfdt = kft*86400*Ceff;
 kfdm = kfm*86400*Ceff;
 kfdl = kfl*86400*Ceff;
 kfdn = kfn*86400*Ceff;
 
 x(1)=0.001;
 for i=2:108
     
     x(i)=(x(i-1))*(1+Scf);
    
 end
 
 Yr = exp(-kfdr*x/vi);
 Yt = exp(-kfdt*x/vi);
 Ym = exp(-kfdm*x/vi);
 Yl = exp(-kfdl*x/vi);
 Yn = exp(-kfdn*x/vi);
 
 figure (1)
 lw = 2;
 plot(x,Yr)
 hold on
 plot (x,Yt,'LineWidth',lw)
 plot (x,Ym,'LineWidth',lw)
 plot (x,Yl,'LineWidth',lw)
 plot (x,Yn,'LineWidth',lw)
 legend('Rajogapalan and Tien, 1976','Tufenkji and Elimielech, 2004','Ma,Pedel,Fife,Jhonson 2015','Long and Hilpert, 2011','Nelson and Ginn, 2011')
 xlabel('Column length (m)'); ylabel('C/Co')
 figure (2)
 plot(x,log10(Yr))
 hold on
 plot (x,log10(Yt),'LineWidth',lw)
 plot (x,log10(Ym),'LineWidth',lw)
 plot (x,log10(Yl),'LineWidth',lw)
 plot (x,log10(Yn),'LineWidth',lw)
 legend('Rajogapalan and Tien, 1976','Tufenkji and Elimielech, 2004','Ma,Pedel,Fife,Jhonson 2015','Long and Hilpert, 2011','Nelson and Ginn, 2011')
 xlabel('Column length (m)'); ylabel(' log C/Co')