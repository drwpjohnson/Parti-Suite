function [etadn, etain, etagn, etan, kfn, kfdn]=fNEL(g, As, Npe, Nlo, Ngi, Nr, Ng, f, v, dc, Ceff) 


 
   %% Nelson and Ginn correlations
 
 etadn = (g.^2).*(2.4*As.^(1/3)).*((Npe./(Npe+16)).^0.75).*(Npe.^-0.68).*(Nlo.^0.015).*(Ngi.^0.8);
 etain = As.*Nlo.^(1/8).*Nr.^(15/8);
 etagn = 0.7*(Nr.^-0.05).*Ng.*(Ngi./(Ngi+0.9));
 etan = etadn + etain + etagn;
 
 % velocity rate Nelson adn Ginn
 
 kfn = -(3/2)*((1-f(1))^(1/3)*v(1)/dc(1))*log(1-etan(1));
 %% Parametros de simulacion


 kfdn = kfn*86400*Ceff;
end