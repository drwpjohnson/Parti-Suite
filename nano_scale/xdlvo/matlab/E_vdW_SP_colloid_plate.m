%Energy vdW_Sphere-Plate_colloid_plate (J)
function[deltaG_vdW]=E_vdW_SP_colloid_plate(H,A132,a1,lambdavdW)
b=5.32; %appropiate for sphere-plate interaction
deltaG_vdW=-A132*H.^-1*a1/6.*(1-b*H./lambdavdW.*log(1+lambdavdW*H.^-1/b));
end
