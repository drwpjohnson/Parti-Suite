%     SUBROUTINE LEWIS ACID-BASE FORCE (N) (DERIVED FROM WOOD & REHMANN 2014)
function FAB= AFMFORCEAB (PI,AG,AP,ASPcolloid,ASPdomain,RMODE,LAMBDAAB,GAMMA0AB,H,H0,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,AFM_asp_tracking_RMODE3)
global LTLT

if (RMODE==0)   %SMOOTH COLLOID AND COLLECTOR
    %         CALCULATE THE EFFECTIVE RADIUS USING COLLOID AND COLLECTOR RADIUS
    AEFF = 2*(AP*AG)/(AP+AG);
    %         LOWER BOUND ON GEOMETRIC CORRECTION - SPHERE-PLATE APPROXIMATION USING EFFECTIVE RADIUS
    LOWGEO = 1-LAMBDAAB/AEFF+(1+LAMBDAAB/AEFF)*exp(-2*AEFF/LAMBDAAB);
    %         UPPER BOUND ON GEOMETRIC CORRECTION - SAME SIZE SPHERE-SPHERE APPROXIMATION USING EFFECTIVE RADIUS
    HIGHGEO = 1-LAMBDAAB/AEFF+LAMBDAAB^2.0/(2*AEFF^2.0)-...
        (4*AEFF/(3*LAMBDAAB))*exp(-2*AEFF/LAMBDAAB)-...
        (1+LAMBDAAB/AEFF+LAMBDAAB^2.0/(2*AEFF^2.0))*...
        exp(-4*AEFF/LAMBDAAB);
    %         GEOMETRIC CORRECTION FOR SPHERE-SPHERE
    COEFF = ((1-AP/AG)*LOWGEO+AP/AG*HIGHGEO);
    %         CALCULATE AB INTERACTION BETWEEN COLLOID AND COLLECTOR (SPHERE-SPHERE)
    FAB = COEFF*PI*AEFF*GAMMA0AB*exp(-(H-H0)/LAMBDAAB);
end
if (RMODE==1)   %ASPERITIES ON COLLOID
    %         CALCULATE THE EFFECTIVE RADIUS USING ASPERITY AND COLLECTOR RADIUS
    AEFF = 2*(ASPcolloid*AG)/(ASPcolloid+AG);
    %         LOWER BOUND ON GEOMETRIC CORRECTION - SPHERE-PLATE APPROXIMATION USING EFFECTIVE RADIUS
    LOWGEO = 1-LAMBDAAB/AEFF+(1+LAMBDAAB/AEFF)*exp(-2*AEFF/LAMBDAAB);
    %         UPPER BOUND ON GEOMETRIC CORRECTION - SAME SIZE SPHERE-SPHERE APPROXIMATION USING EFFECTIVE RADIUS
    HIGHGEO = 1-LAMBDAAB/AEFF+LAMBDAAB^2.0/(2*AEFF^2.0)-...
        (4*AEFF/(3*LAMBDAAB))*exp(-2*AEFF/LAMBDAAB)-...
        (1+LAMBDAAB/AEFF+LAMBDAAB^2.0/(2*AEFF^2.0))*...
        exp(-4*AEFF/LAMBDAAB);
    %         GEOMETRIC CORRECTION FOR SPHERE-SPHERE
    COEFF = ((1-ASPcolloid/AG)*LOWGEO+ASPcolloid/AG*HIGHGEO);
    %         CALCULATE AB INTERACTION BETWEEN ASPERITIES AND DOMAIN (SPHERE-SPHERE)
    % vectorized calculation for array of separation distances
    Hasp_colloid = ycap-AG-ASPcolloid;
    % calculate only for asperities inside Hthreshold
    c=Hasp_colloid<=1/LTLT*ASPcolloid;
    if sum(c)>=1
        %extract valid separation distances
        Hasp_colloid=Hasp_colloid(c);
        FAB1 = COEFF*PI*AEFF*GAMMA0AB*exp(-(Hasp_colloid-H0)/LAMBDAAB);
    else
        FAB1 = 0.0;
    end
    %         CALCULATE TOTAL INTERACTION
    FAB = sum(FAB1);
end
if (RMODE==2)   %ASPERITIES ON domain
    %         CALCULATE THE EFFECTIVE RADIUS USING ASPERITY AND COLLOID RADIUS
    AEFF = 2*(ASPdomain*AP)/(ASPdomain+AP);
    %         LOWER BOUND ON GEOMETRIC CORRECTION - SPHERE-PLATE APPROXIMATION USING EFFECTIVE RADIUS
    LOWGEO = 1-LAMBDAAB/AEFF+(1+LAMBDAAB/AEFF)*...
        exp(-2*AEFF/LAMBDAAB);
    %         UPPER BOUND ON GEOMETRIC CORRECTION - SAME SIZE SPHERE-SPHERE APPROXIMATION USING EFFECTIVE RADIUS
    HIGHGEO = 1-LAMBDAAB/AEFF+LAMBDAAB^2.0/(2*AEFF^2.0)-...
        (4*AEFF/(3*LAMBDAAB))*exp(-2*AEFF/LAMBDAAB)-...
        (1+LAMBDAAB/AEFF+LAMBDAAB^2.0/(2*AEFF^2.0))*...
        exp(-4*AEFF/LAMBDAAB);
    %         GEOMETRIC CORRECTION FOR SPHERE-SPHERE
    COEFF = ((1-ASPdomain/AP)*LOWGEO+ASPdomain/AP*HIGHGEO);
    %         CALCULATE AB INTERACTION BETWEEN ASPERITIES AND COLLOID (SPHERE-SPHERE)
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
        FAB1 = COEFF*PI*AEFF*GAMMA0AB*exp(-(Hasp_domain-H0)/LAMBDAAB);
    else
        FAB1 = 0.0;
    end
    %         CALCULATE TOTAL INTERACTION
    FAB = sum(facY.*FAB1);
end
if (RMODE==3)    %ASPERITIES ON BOTH SURFACES
    AEFF = 2*(ASPdomain*ASPcolloid)/(ASPdomain+ASPcolloid);

    %         GEOMETRIC CORRECTION FOR SAME SIZE SPHERE
    COEFF = 1-LAMBDAAB/AEFF+LAMBDAAB^2.0/(2*AEFF^2.0)-...
        (4*AEFF/(3*LAMBDAAB))*exp(-2*AEFF/LAMBDAAB)-...
        (1+LAMBDAAB/AEFF+LAMBDAAB^2.0/(2*AEFF^2.0))*...
        exp(-4*AEFF/LAMBDAAB);
    %
    % loop through one colloid asperity interacting with
    % a subdomain of asperities in ZOI
    % pralocate array of asperities contributions to interaction
    FAB1 = NaN(1,length(xcap));
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
            FABoneasp = COEFF*PI*AEFF*GAMMA0AB*exp(-(Hmin-H0)/LAMBDAAB);
            % array of distances between colloid asperity center and domain asperities centers
            RXYZ = ((xcol-xasp(imin)).*(xcol-xasp(imin))+(ycol-yasp(imin)).*(ycol-yasp(imin)) + (zcol-zasp(imin)).*(zcol-zasp(imin))).^0.5;
            % calculate unit vectors pointing from domains asperity to
            % colloid asperity center. DLVO forces contribution is only in
            % Y (laterals cancel each other)
            unity = (ycol-yasp(imin))./RXYZ;
            %disp(unity)
            % Correct array of interactions to component on Y axis
            FAB1(i) = unity.*FABoneasp;
        else
            FAB1(i)=0.0;
        end
    end
    %
    %         CALCULATE TOTAL INTERACTION
    FAB = sum(FAB1);
end


if (abs(FAB)<1.0E-30)
    FAB = 0.0;
end
end