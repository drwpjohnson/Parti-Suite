%Force Born_Sphere-Plate_colloid_plate (N)
function[ForceBorn]=F_Born_SP_colloid_plate(H,A132,sigmaC,a1)
ForceBorn=(abs(A132)*sigmaC^6/1260).*((7*a1-H).*H.^-8+(9*a1+H)./(2*a1+H).^8);
end