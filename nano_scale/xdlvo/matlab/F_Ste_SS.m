%Force Ste_Sphere-Sphere(N)
function[ForceSte]=F_Ste_SS(H,lambdaSte,gammaoSte,aSte)
ForceSte=gammaoSte/lambdaSte.*exp(-H/lambdaSte)*pi*aSte^2;
end