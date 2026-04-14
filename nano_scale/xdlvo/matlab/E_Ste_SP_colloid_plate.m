%Energy EDL_Sphere-Plate_colloid_plate (J)
function[deltaGSte]=E_Ste_SP_colloid_plate(H,lambdaSte,gammaoSte,aSte)
deltaGSte=gammaoSte.*exp(-H/lambdaSte)*pi*aSte^2;
end