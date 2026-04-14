function [etadr, etair, etagr, etar, kfr, kfdr]=fRAGO(g, As, Npe, Nlo, Nr, Ng, f, v, dc, Ceff) 

 
 %% Rajogapalan correlations
 
 etadr = g.^2.*4.*As.^(1/3).*Npe.^(-2/3);
 etair = As.*Nlo.^(1/8).*Nr.^(15/8);
 etagr = 0.00338.*As.*Ng.^1.2.*Nr.^-0.4;
 etar = etadr + etair + etagr;
 
 % velocity rate rajogapalan
 
 kfr = -(3/2)*((1-f(1))^(1/3)*v(1)/dc(1))*log(1-etar(1)); 
 

 %% Parametros de simulacion

   kfdr = kfr*86400*Ceff;
end