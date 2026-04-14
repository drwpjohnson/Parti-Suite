%Energy AB_Sphere-Plate_colloid_collector (J)
function[deltaGAB]=E_AB_SS_colloid_plate(H,lambdaAB,a1,gammaoAB,ho,a2)
aeff=2*a1*a2/(a1+a2);
%Bounds on geometric Correction
Lower=(1-lambdaAB/aeff+(1+lambdaAB/aeff)*exp(-2*aeff/lambdaAB));
Upper=(1-lambdaAB/aeff+lambdaAB^2/(2*aeff^2)-4*...
      aeff/(3*lambdaAB)*exp(-2*aeff/lambdaAB)...
      -(1+lambdaAB/aeff+lambdaAB^2/(2*aeff^2))*exp(-4*aeff/lambdaAB));
% c1 = ((1-a1/a2)*Lower+a1/a2*Upper)*pi*aeff*lambdaAB*gammaoAB;
% c2 =exp(-(H-ho)/lambdaAB);
% deltaGAB = c1*c2;
deltaGAB=((1-a1/a2)*Lower+a1/a2*Upper)*pi*aeff*lambdaAB*gammaoAB.*...
     exp(-(H-ho)/lambdaAB);

end