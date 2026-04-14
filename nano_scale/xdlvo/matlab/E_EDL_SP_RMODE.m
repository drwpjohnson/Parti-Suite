%Energy EDL_Sphere-Plate_RMODE1 (J)
function[deltaGEDL]=E_EDL_SP_RMODE(H,n,eps,K,kB,T,z,zeta1,...
                    e_charge,zeta2,aasp,a1,RMODE,Nco)
    if RMODE==1
        %a1=n*aasp
        deltaGEDL= n*64*pi*eps/K*(kB*T/z/e_charge)^2*...
                    tanh(z*e_charge*zeta1/4/kB/T)*...
                    tanh(z*e_charge*zeta2/4/kB/T)*((K*aasp-1).*...
                    exp(-K*H)+(K*aasp+1).*exp(-K*(H+2*aasp)));
    end
    if RMODE==2
        %a1=a1
        deltaGEDL=n*(64*pi*eps*a1*aasp/(a1+aasp)*...
                  (kB*T/z/e_charge)^2*tanh(z*e_charge*zeta1/4/kB/T)*...
                    tanh(z*e_charge*zeta2/4/kB/T).*exp(-K*H));
    end
    if RMODE==3
        %a1=aasp
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