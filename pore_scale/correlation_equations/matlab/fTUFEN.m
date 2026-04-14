function [etadt, etait, etagt, etat, kft, kfdt]=fTUFEN(As, Nr, Npe, Nvdw, Na, Ng, f, v, dc, Ceff) 

 
 %% Tufenki and Elimelech correlations
 
 etadt = 2.4*(As.^(1/3)).*(Nr.^-0.081).*(Npe.^-0.715).*(Nvdw.^0.052);
 etait = 0.55*As.*(Nr.^1.675).*(Na.^0.125);
 etagt = 0.22*(Nr.^-0.24).*(Ng.^1.11).*(Nvdw.^0.053);
 etat = etadt + etait + etagt;
 
%  velocity rate Tufenki and Elimelech
 
 kft = -(3/2)*((1-f(1))*v(1)/dc(1))*log(1-etat(1)); 
 
  
 %% Parametros de simulacion

 kfdt = kft*86400*Ceff;
end