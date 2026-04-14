%Force vdW_Sphere-sphere_colloid_plate (N)
function[ForcevdW]=F_vdW_SS_colloid_plate(H,A132,a1,a2,lambdavdW)
b=5.32; %can be used or optimized for sphere sphere interaction
ForcevdW=-A132*a1*a2*H.^-2/(6*(a1+a2)).*(lambdavdW./(lambdavdW+b*H));
end