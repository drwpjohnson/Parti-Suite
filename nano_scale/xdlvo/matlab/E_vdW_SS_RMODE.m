%Energy vdW_Sphere-sphere_RMODE (J)
function[deltaGvdW]=E_vdW_SS_RMODE(n,H,A132,aasp,a2,lambdavdW,a1,RMODE,Nco)
b=5.32; %appropiate for sphere-plate interaction
    if RMODE==1   %ASPERITIES ON COLLOID
        deltaGvdW=-n*A132*aasp*a2*H.^-1/(6*(aasp+a2)).*...
                  (1-b*H./lambdavdW.*log(1+lambdavdW*H.^-1/b));
    end
    if RMODE==2  %ASPERITIES ON COLLECTOR
        deltaGvdW=n*H.^-1*(-A132*a1*aasp/6/(a1+aasp)).*...
                  (1-(b*H.*log(1+lambdavdW*H.^-1/b))/lambdavdW);
    end
    if RMODE==3  %ASPERITIES ON BOTH SURFACES
        deltaGvdW=Nco*n*H.^-1*(-A132*aasp*aasp/6/(aasp+aasp)).*...
                  (1-(b*H.*log(1+lambdavdW*H.^-1/b))/lambdavdW);
    end    
   %
    % make zero Energy values calculated for H>aasp 
    %(comply with Dejarguin aproximation)
    c=H>aasp;
    deltaGvdW(c)=0.0;        
end
