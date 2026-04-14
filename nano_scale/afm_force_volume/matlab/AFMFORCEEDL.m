%     SUBROUTINE FORCE EDL (N) (SPHERE-SPHERE GEOMETRY) (DERIVED FROM ENERGY GIVEN BY LIN   WIESNER 2012)
function FEDL=AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,AFM_asp_tracking_RMODE3)
global LTLT
J = 1-(PI/4); %CALCULATE AREA OF SURFACE NOT OCCUPIED BY ASPERITIES USING JAMMING LIMIT FOR CUBIC PACKED SPHERES
if (RMODE==0)   %SMOOTH SURFACE ON BOTH (SPHERE-SPHERE GEOMETRY) (DERIVED FROM ENERGY GIVEN BY LIN   WIESNER 2012)
    % determine geometry factor for smooth surfaces
    AEFF = AP*AG/(AP+AG);
    COEF1 = 64.0*PI*ERE0*AEFF*(KB*T/ZI/ECHG)^2.0  ...
        *tanh(ZI*ECHG*ZETAC/4/KB/T)*tanh(ZI*ECHG*ZETAP/4/KB/T);
    FEDL = COEF1*KAPPA*exp(-KAPPA*H);
end
if (RMODE==1)   %ASPERITIES ON COLLOID
    % determine geometry factor for smooth surfaces
    AEFF = AP*AG/(AP+AG);
    % determine geometry factor for asperities
    AEFFASP = ASPcolloid*AG/(ASPcolloid+AG);
    H2 = H +ASPcolloid; %SEPARATION DISTANCE BETWEEN UNDERLYING SMOOTH COLLECTOR AND COLLOID
    %        CALCULATE EDL INTERACTION BETWEEN COLLOID AND COLLECTOR (SPHERE-SPHERE DERIVED FROM ENERGY GIVEN BY LIN   WIESNER 2012)
    COEF1 = 64.0*PI*ERE0*AEFF*(KB*T/ZI/ECHG)^2.0...
        *tanh(ZI*ECHG*ZETAC/4/KB/T)*tanh(ZI*ECHG*ZETAP/4/KB/T);
    FEDL1 = COEF1*KAPPA*exp(-KAPPA*H2);
    %        CALCULATE EDL INTERACITON BETWEEN ASPERTIES AND COLLECTOR (SPHERE-SPHERE)
    COEF2 = 64.0*PI*ERE0*AEFFASP*(KB*T/ZI/ECHG)^2.0 ...
        *tanh(ZI*ECHG*ZETAC/4/KB/T)*tanh(ZI*ECHG*ZETAP/4/KB/T);
    % vectorized calculation for array of separation distances
    Hasp_colloid = ycap-AG-ASPcolloid;
    % calculate only for asperities inside Hthreshold
    c=Hasp_colloid<=1/LTLT*ASPcolloid;
    if sum(c)>=1
        %extract valid separation distances
        Hasp_colloid=Hasp_colloid(c);

        FEDL2 = COEF2*KAPPA*exp(-KAPPA*Hasp_colloid);
    else
        FEDL2 = 0.0;
    end
    %        CALCULATE TOTAL INTERACTION (MULTIPLY OFFSET SMOOTH SURFACE BY 1-JAMMING LIMIT OF SURFACE COVERED BY ASPERITIES)
    % needed because EDL is a surface, not a volumetric interaction like VDW
    FEDL = J*FEDL1 + sum(FEDL2) ;
end
if (RMODE==2)   %ASPERITIES ON COLLECTOR
    % determine geometry factor for smooth surfaces
    AEFF = AP*AG/(AP+AG);
    % determine geometry factor for asperities
    AEFFASP = ASPdomain*AG/(ASPdomain+AG);
    H2 = HS; %SEPARATION DISTANCE BETWEEN UNDERLYING SMOOTH COLLECTOR AND COLLOID
    %        CALCULATE EDL INTERACTION BETWEEN COLLOID AND COLLECTOR (SPHERE-SPHERE DERIVED FROM ENERGY GIVEN BY LIN   WIESNER 2012)
    COEF1 = 64.0*PI*ERE0*AEFF*(KB*T/ZI/ECHG)^2.0...
        *tanh(ZI*ECHG*ZETAC/4/KB/T)*tanh(ZI*ECHG*ZETAP/4/KB/T);
    FEDL1 = COEF1*KAPPA*exp(-KAPPA*H2);
    %        CALCULATE EDL INTERACITON BETWEEN ASPERTIES AND COLLOID (SPHERE-SPHERE)
    COEF2 = 64.0*PI*ERE0*AEFFASP*(KB*T/ZI/ECHG)^2.0*...
        tanh(ZI*ECHG*ZETAC/4/KB/T)*tanh(ZI*ECHG*ZETAP/4/KB/T) ;
    % vectorized calculation for array of separation distances
    % array of distances between asperity centers and colloid center
    RXYZ = ((X-xasp_domain).*(X-xasp_domain)+(Y-yasp_domain).*(Y-yasp_domain) + (Z-zasp_domain).*(Z-zasp_domain)).^0.5;
    % factor of projection on  Y component (array)
    facY =  (Y-AG)./RXYZ;
    % separation distance between asperity and colloid surface
    Hasp_domain = RXYZ-AP-ASPdomain;
    % calculate only for asperities inside Hthreshold
    c=Hasp_domain<=1/LTLT*ASPdomain;
    if sum(c)>=1
        %extract valid separation distances
        Hasp_domain=Hasp_domain(c);
        facY = facY(c);
        FEDL2 = COEF2*KAPPA*exp(-KAPPA*Hasp_domain);
    else
        FEDL2 = 0.0;
    end
    %        CALCULATE TOTAL INTERACTION (MULTIPLY OFFSET SMOOTH SURFACE BY 1-JAMMING LIMIT OF SURFACE COVERED BY ASPERITIES)
    FEDL = J*FEDL1 + sum(facY.*FEDL2) ;
end
if (RMODE==3)    %ASPERITIES ON BOTH SURFACES
    % determine geometry factor for smooth surfaces
    AEFF = AP*AG/(AP+AG);
    % determine geometry factor for asperities
    AEFFASP = ASPdomain*ASPcolloid/(ASPdomain+ASPcolloid);
    H2 = H+ASPdomain+ASPcolloid; %AVERAGE SEPARATION DISTANCE BETWEEN UNDERLYING SMOOTH COLLECTOR AND COLLOID FOR OPPOSED AND COMPLIMENTARY ASPERITY PACKING
    %        CALCULATE EDL INTERACTION BETWEEN COLLOID AND COLLECTOR (SPHERE-SPHERE (DERIVED FROM ENERGY GIVEN BY LIN   WIESNER 2012)
    COEF1 = 64.0*PI*ERE0*AEFF*(KB*T/ZI/ECHG)^2.0...
        *tanh(ZI*ECHG*ZETAC/4/KB/T)*tanh(ZI*ECHG*ZETAP/4/KB/T);
    FEDL1 = COEF1*KAPPA*exp(-KAPPA*H2);
    %        CALCULATE EDL INTERACTION BETWEEN ASPERITIES (SPHERE-SPHERE JUSTifIED BY LINEAR APPROXIMATION)
    COEF2 = 64.0*PI*ERE0*AEFFASP*(KB*T/ZI/ECHG)^2.0* ...
        tanh(ZI*ECHG*ZETAC/4/KB/T)*tanh(ZI*ECHG*ZETAP/4/KB/T) ;
    % loop through one colloid asperity interacting with
    % a subdomain of asperities in ZOI
    % pralocate array of asperities contributions to interaction
    FEDL2 = NaN(1,length(xcap));
    % define bounds of zoi subset
    Rsubdomain = 2*ASPdomain;
    % determine smaller asperity size
    if ASPdomain<=ASPcolloid
        ASPsmaller = ASPdomain;
    else
        ASPsmaller = ASPcolloid;
    end
    %
    for i=1:length(xcap)
        % vectorized calculation for array of separation distances
        xcol = xcap(i);
        ycol = ycap(i);
        zcol = zcap(i);
        % call function to track asperities in subset of ZOI on the collector near projected colloid asperity location
        [xasp,yasp,zasp]=AFM_asp_tracking_RMODE3(xcol,ycol,zcol,AG,Rsubdomain,ASPdomain);
        Harray = ((xcol-xasp).*(xcol-xasp)+(ycol-yasp).*(ycol-yasp)+(zcol-zasp).*(zcol-zasp)).^0.5-ASPcolloid-ASPdomain;
        % find minnimum separtion distance
        [Hmin,imin] = min(Harray);
        % calculate only for asperities inside Hthreshold

        if Hmin<=1/LTLT*ASPsmaller
            % array of total interaction of a single colloid asperity with
            % all domain asperities
            FEDLoneasp = COEF2*KAPPA*exp(-KAPPA*Hmin);
            % array of distances between colloid asperity center and domain asperities centers
            RXYZ = ((xcol-xasp(imin)).*(xcol-xasp(imin))+(ycol-yasp(imin)).*(ycol-yasp(imin)) + (zcol-zasp(imin)).*(zcol-zasp(imin))).^0.5;
            % calculate unit vectors pointing from domains asperity to
            % colloid asperity center. DLVO forces contribution is only in
            % Y (laterals cancel each other)
            unity = (ycol-yasp(imin))./RXYZ;
            %disp(unity)
            % Correct array of interactions to component on Y axis
            FEDL2(i) = unity.*FEDLoneasp;
        else
            FEDL2(i)=0.0;
        end
    end  
    %        CALCULATE TOTAL INTERACTION (MULTIPLY OFFSET SMOOTH SURFACE BY 1-JAMMING LIMIT OF SURFACE COVERED BY ASPERITIES)
    FEDL = J*FEDL1 + sum(FEDL2) ;
end
if (abs(FEDL)<1.0E-30)
    FEDL = 0.0;
end
end