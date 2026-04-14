%Force AB_Sphere-Plate_colloid_collector (N)
function[ForceGAB]=F_AB_SS_colloid_collector(H,lambdaAB,a1,gammaoAB,ho,a2)
aeff=2*a1*a2/(a1+a2);
%Bounds on geometric Correction
Lower=(1-lambdaAB/aeff+(1+lambdaAB/aeff)*exp(-2*aeff/lambdaAB));
Upper=(1-lambdaAB/aeff+lambdaAB^2/(2*aeff^2)-4*...
       aeff/(3*lambdaAB)*exp(-2*aeff/lambdaAB)...
       -(1+lambdaAB/aeff+lambdaAB^2/(2*aeff^2))*exp(-4*aeff/lambdaAB));

ForceGAB=((1-a1/a2)*Lower+a1/a2*Upper)*pi*aeff*gammaoAB.*...
    exp(-(H-ho)/lambdaAB);
end