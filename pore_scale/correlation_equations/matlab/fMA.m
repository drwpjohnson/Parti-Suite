function [etadm, etaim, etagm, etam, kfm, kfdm]=fMA(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff) 

  %% Ma and Jhonson correlations
 
 etadm = g.^2.*((8+4*(1-g).*(As.^(1/3)).*(Npe.^(1/3)))./(8+(1-g).*Npe.^(0.97))).*(Nlo.^0.015).*(Ngi.^0.8).*(Nr.^0.028);
 etaim = As.*(Nr.^(15/8)).*(Nlo.^(1/8));
 etagm = 0.7*(Nr.^-0.05).*Ng.*(Ngi./(Ngi+0.9));
 etam = etadm + etaim + etagm;
 
 % velocity rate Ma and Jhonson
 
 kfm = -(3/2)*(((1-f(1))*v(1))/dc(1))*(log(1-etam(1)))*(((3-f(1))/(3-3*f(1)))-((2*(3-f(1)))/(pi*(3-3*f(1))))*acos(((3-3*f(1))/(3-f(1)))^0.5)+(2/pi)*((2*((3-f(1))/(3-3*f(1)))^(0.5))-1)^0.5); 

 %% Parametros de simulacion


 kfdm = kfm*86400*Ceff;
end