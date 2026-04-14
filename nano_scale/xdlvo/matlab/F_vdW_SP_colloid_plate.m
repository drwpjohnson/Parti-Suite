%Force vdW_Sphere-Plate_colloid_plate (N)
function[ForcevdW]=F_vdW_SP_colloid_plate(H,A132,a1,lambdavdW)
b=5.32; %appropiate for sphere-plate interaction
ForcevdW=-A132*a1*H.^-2/6.*(lambdavdW./(lambdavdW+b*H));
end
