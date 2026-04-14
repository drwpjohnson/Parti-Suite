%Energy AB_Sphere-Sphere_RMODE1 (J)
function[ForceGAB]=F_AB_SS_RMODE(H,lambdaAB,aasp,nAB,gammaoAB,ho,RMODE,a1,a2,Nco)%correc_factor_2,correc_factor_3
    if RMODE==1
        aeff=2*aasp*a2/(aasp+a2);%Effective radius for RMODE1 
        %Corrections_RMODE1
        Lower=(1-lambdaAB/aeff+(1+lambdaAB/aeff)*exp(-2*aeff/lambdaAB));
        Upper=(1-lambdaAB/aeff+lambdaAB^2/(2*aeff^2)-4*aeff/(3*lambdaAB)*exp(-2*aeff/lambdaAB)...
               -(1+lambdaAB/aeff+lambdaAB^2/(2*aeff^2))*exp(-4*aeff/lambdaAB));
        % Main function RMODE1
        ForceGAB=nAB*((1-aasp/a2)*Lower+aasp/a2*Upper)*...
                pi*aeff*gammaoAB.*exp(-(H-ho)/lambdaAB);
    end
    if RMODE==2
        aeff=2*a1*aasp/(a1+aasp);%[m]Effective radius for RMODE2
        %Corrections_RMODE2
        correc_factor=(1-lambdaAB/aeff+lambdaAB^2/(2*aeff^2)-4*aeff/...
            (3*lambdaAB)*exp(-2*aeff/lambdaAB)-(1+lambdaAB/aeff+lambdaAB^2/...
            (2*aeff^2))*exp(-4*aeff/lambdaAB));
         %Main function RMODE2
        ForceGAB=nAB*correc_factor*pi*aeff*...
            gammaoAB*exp(-(H-ho)/lambdaAB);            
    end
    if RMODE==3
        aeff=2*aasp*aasp/(aasp+aasp);%Effective radius for RMODE3      
        %Corrections_RMODe3
        correc_factor=(1-lambdaAB/aeff+lambdaAB^2/(2*aeff^2)-4*aeff/...
            (3*lambdaAB)*exp(-2*aeff/lambdaAB)-(1+lambdaAB/aeff+lambdaAB^2/...
            (2*aeff^2))*exp(-4*aeff/lambdaAB));
        % Main function RMODE
        ForceGAB=Nco*nAB*correc_factor*pi*aeff*...
            gammaoAB*exp(-(H-ho)/lambdaAB); 
    end
    %
    % make zero Force values calculated for H>aasp 
    %(comply with Dejarguin aproximation)
    c=H>aasp;
    ForceGAB(c)=0.0;    
end