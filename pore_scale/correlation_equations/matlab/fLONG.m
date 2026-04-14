function [etadl, etail, etagl, etal, kfl, kfdl]=fLONG(g, Npe, Nr, As, Na, Ng, Nvdw, f, v, dc, Ceff) 

 
   %% Long and Hilpert correlations
 
 etadl = 15.56*(g.^6./((1-g.^3).^2)).*(Npe.^-0.65).*(Nr.^0.19);
 etail = 0.55*As.*(Nr.^1.675).*(Na.^0.125);
 etagl = 0.22*(Nr.^-0.24).*(Ng.^1.11).*(Nvdw.^0.053);
 etal = etadl + etail + etagl;
 
 % velocity rate Long and Hilpert
 
 kfl = -(3/2)*((1-f(1))*v(1)/dc(1))*log(1-etal(1));
 

 kfdl = kfl*86400*Ceff;
end