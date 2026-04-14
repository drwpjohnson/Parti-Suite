%Energy EDL_Sphere-Sphere_RMODE (J)
function[deltaGEDL]=E_EDL_SS_RMODE(H,a2,eps,K,kB,T,z,zeta1,e_charge,zeta2,aasp,a1,RMODE,n,Nco)
    if RMODE==1
          deltaGEDL=n*64*pi*eps*aasp*a2/(aasp+a2)*...
            (kB*T/z/e_charge)^2*tanh(z*e_charge*zeta1/4/kB/T)*...
            tanh(z*e_charge*zeta2/4/kB/T).*exp(-K*H);
    end
    if RMODE==2
          deltaGEDL=n*(64*pi*eps*a1*aasp/(a1+aasp)*...
            (kB*T/z/e_charge)^2*tanh(z*e_charge*zeta1/4/kB/T)*...
            tanh(z*e_charge*zeta2/4/kB/T).*exp(-K*H));
    end
    if RMODE==3
          deltaGEDL=Nco*n*(64*pi*eps*aasp*aasp/(aasp+aasp)*...
            (kB*T/z/e_charge)^2*tanh(z*e_charge*zeta1/4/kB/T)*...
            tanh(z*e_charge*zeta2/4/kB/T).*exp(-K*H));
    end
    %
    % make zero Energy values calculated for H>aasp 
    %(comply with Dejarguin aproximation)
    c=H>aasp;
    deltaGEDL(c)=0.0;    
end