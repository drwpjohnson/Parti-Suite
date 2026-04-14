%Force vdW_Sphere-Sphere_RMODE(N)
function[ForcevdW]=F_vdW_SS_RMODE(n,H,a2,A132,aasp,lambdavdW,a1,RMODE,Nco)
b=5.32; %appropiate for sphere-plate interaction
    if RMODE==1 %ASPERITIES ON COLLOID
        ForcevdW=n*(a2*-A132*aasp*H.^-2/(6*(aasp+a2))).*...
                 (lambdavdW./(lambdavdW+H.*b));
    end
    if RMODE==2 %ASPERITIES ON COLLECTOR
        ForcevdW=n*H.^-2*(-A132*a1*aasp/6/(a1+aasp)).*...
                 (lambdavdW./(lambdavdW+H.*b));
    end
    if RMODE==3 %ASPERITIES ON BOTH SURFACES
        ForcevdW=Nco*n*H.^-2*(-A132*aasp*aasp/6/(aasp+aasp)).*...
                 (lambdavdW./(lambdavdW+H.*b));
    end
    % make zero Force values calculated for H>aasp 
    %(comply with Dejarguin aproximation)
    c=H>aasp;
    ForcevdW(c)=0.0;      
end