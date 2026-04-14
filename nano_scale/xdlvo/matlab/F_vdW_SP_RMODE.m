%Force vdW_Sphere-Plate_RMODE (N)
function[ForcevdW]=F_vdW_SP_RMODE(H,n,A132,aasp,a1,lambdavdW,RMODE,Nco)
b=5.32; %appropiate for sphere-plate interaction
        if RMODE==1 %ASPERITIES ON COLLOID
            %a1=n*aasp
            ForcevdW=(n*-A132*aasp*H.^-2/6).*...
                (lambdavdW./(lambdavdW+H.*b));
        end
        if RMODE==2 %ASPERITIES ON COLLECTOR
            %a1=a1
            ForcevdW= n*H.^-2*(-A132*a1*aasp/6/(a1+aasp)).*...
                (lambdavdW./(lambdavdW+H.*b));
        end
        if RMODE==3 %ASPERITIES ON BOTH SURFACES
            %a1=aasp
            ForcevdW= Nco*n*H.^-2*(-A132*aasp*aasp/6/(aasp+aasp)).*...
                (lambdavdW./(lambdavdW+H.*b));
        end
    % make zero Force values calculated for H>aasp 
    %(comply with Dejarguin aproximation)
    c=H>aasp;
    ForcevdW(c)=0.0;    
end