%Force Ste_Sphere-Plate_colloid_plate (N)
function[ForceSte]=F_Ste_SP_colloid_plate(H,lambdaSte,gammaoSte,aSte)
ForceSte=gammaoSte/lambdaSte.*exp(-H/lambdaSte)*pi*aSte^2;
end