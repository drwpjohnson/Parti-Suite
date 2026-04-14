%Energy vdW_Sphere-sphere_colloid_plate (J)
function[deltaG_vdW]=E_vdW_SS_colloid_plate(H,A132,a1,a2,lambdavdW)
b=5.32; %can be used or optimized for sphere-sphere interaction
deltaG_vdW=-A132*H.^-1*a1*a2/(6*(a1+a2)).*...
    (1-b*H./lambdavdW.*log(1+lambdavdW*H.^-1/b));
end