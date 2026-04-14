%Energy vdW_Sphere-Plate_RMODE (J)
function[deltaGvdW]=E_vdW_SP_RMODE(H,n,A132,aasp,a1,lambdavdW,RMODE,Nco)
b=5.32; %appropiate for sphere-plate interaction
    if RMODE==1 %ASPERITIES ON COLLOID
        %a1=n*aasp
        deltaGvdW= (n*-A132*aasp*H.^-1/6).*...
            (1-b*H./lambdavdW.*log(1+lambdavdW*H.^-1/b));
    end
    if RMODE==2 %ASPERITIES ON COLLECTOR
        %a1=a1
        deltaGvdW= n*H.^-1*(-A132*a1*aasp/6/(a1+aasp)).*...
            (1-(b*H.*log(1+lambdavdW*H.^-1/b))/lambdavdW);
    end
    if RMODE==3  %ASPERITIES ON BOTH SURFACES
        %a1=aasp (compare with the function above)
        deltaGvdW= Nco*n*H.^-1*(-A132*aasp*aasp/6/(aasp+aasp)).*...
            (1-(b*H.*log(1+lambdavdW*H.^-1/b))/lambdavdW);
    end
   %
    % make zero Energy values calculated for H>aasp 
    %(comply with Dejarguin aproximation)
    c=H>aasp;
    deltaGvdW(c)=0.0;    
end