%Energy EDL_Sphere-Sphere(J)
function[deltaGSte]=E_Ste_SS(H,lambdaSte,gammaoSte,aSte)
deltaGSte=gammaoSte.*exp(-H/lambdaSte)*pi*aSte^2;
end