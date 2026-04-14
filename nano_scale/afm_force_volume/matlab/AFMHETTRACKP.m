% SUBROUTINE GENERATION AND PROJECTION OF HETERODOMAINS ON COLLOID WRITTEN - CESAR RON 
% ISO CONVENTION USED FOR SPHERICAL COORDINATES [R,THETA,PHI] (RADIAL, POLAR, AZIMUTAHL) 
function [MHETP, MPRO]=AFMHETTRACKP(X,Y,Z,H,RZOI,AP,HETMODEP,SCOVP,RHETP0,RHETP1)

PI=3.14159265359;

% DEFINE COLLOID CENTER IN COLLECTOR FRAME OF REFERENCE
XmP0 = X; 
YmP0 = Y; 
ZmP0 = Z;
% RADIAL LIMIT WITHIN HETERODOMAINS WILL BE PROJECTED
RPL = RZOI + RHETP0;
% LIMITS IN Z AXIS FOR THE RANGE WITHIN WHICH HETERODOMIANS WILL NOT BE PROJECTED
ZU = AP + ZmP0;
ZL = ZmP0;
% HETMODEPP TO BE USED IN DOUBLE PRECISION CALCULATIONS
HMODEREAL = HETMODEP;
% CALCULATE OPENING ANGLE FOR ARC LENGTH OF SINGLE HETDOMAIN
OMEGA0 = RHETP0/AP;
OMEGA1 = RHETP1/AP ;
%CALCULATE DIFFERENCE BETWEEN AP AND AP'
DAP = AP*(1-cos(OMEGA0));
% CALCULATE PROJECTED HETDOMAIN MAJOR AXIS
RPRO0 = AP*sin(OMEGA0);
RPRO1 = AP*sin(OMEGA1);
% EQUIVALENT SURFACE COVERAGE CORRESPONDING TO UNIFORM HETDOMAINS IS USED IN CALCULATION
if (HETMODEP==1)
    SCOVP0 = SCOVP;
else 
    SCOVP0 = SCOVP*((1.0-cos(OMEGA0))/((1.0-cos(OMEGA0))+(HMODEREAL-1.0)*(1.0-cos(OMEGA1))));
end    
% CALCULATE THEORETICAL NUMBER OF HETDOMAINS
NHETP0 = round(SCOVP0*4.0/(2.0*(1.0-cos(OMEGA0))));
NHETP1 = (HMODEREAL-1.0)*NHETP0;
% INITIALIZE COUNT OF HETERODOMAINS
HC = 0;
% CALCULATE NUMBER OF RINGS THAT YIELD NHET ASSUMING EVEN SPACING 
NHETREAL0 = NHETP0;
NRING = round((NHETREAL0/1.3)^0.5);
NRINGREAL = NRING;
SCOVP = (NHETREAL0*2.0*(1-cos(OMEGA0))+(HMODEREAL-1.0)*NHETREAL0*2.0*(1-cos(OMEGA1)))/(4.0);

%SPHERICAL COORDINATES: RADIUS, THETA (POLAR ANGLE), PHI (AZIMUTHAL ANGLE)
%AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
%CALCULATE THETA ANGLE STEP AND CONSTANT ARC LENGTH
DTHETA =  PI/(NRINGREAL-1.0);
% INITITIALIZE THETA COLLOID ANGLE
THETA = 0.0;
% CALCULATE ARCLENGHT CONSTANT 
ARCL = DTHETA*AP;
% GENERATE HETDOMAINS FROM 0.0 TO PI THETA DOMAIN  
for I=1:NRING
    THETA = (I-1)*DTHETA;
    if or(I==1,I==NRING) %AT POLES
        RRING = 0.0; %IN POLE NO RING AND ONLY ONE HETDOMAIN
        NHETRING = 1;
        DTHETA1 = 1.0/3.0*DTHETA;
        DPHI = 0.0;
        if (I==1)   
            THETA = 0.0;
        elseif (I==NRING)
            THETA = PI;
        end
        %POPULATE HETERODOMAINS AT POLE
        for J=1:HETMODEP
            HC = HC + 1;
            if (J==1) %GENERATE LARGE HETERODOMAIN
                PHI = 0.0;
                XHET = RRING*cos(PHI)+XmP0;
                YHET = RRING*sin(PHI)+YmP0;
                ZHET = AP*cos(THETA)+ZmP0; 
                RHET = RHETP0;
                BETA = acos((ZmP0-ZHET)/AP); %ELEVATION ANGLE OF THE HETERODOMAIN RESPECT TO PROJECTION PLANE
                ARG = (ZmP0-ZHET)/AP;
                if (ARG>=1.0)
                    ARG = 1.0;
                    BETA = acos(ARG);
                elseif (ARG<=-1.0)
                    ARG = -1.0;
                    BETA = acos(ARG);
                end
                RDHET = ((XHET-XmP0)^2+(YHET-YmP0)^2)^0.5; %RADIAL DISTANCE OF HETERODOMAIN CENTER
                XHETP(HC) = XHET;
                YHETP(HC) = YHET;
                ZHETP(HC) = ZHET;
                RHETP(HC) = RHET;
                THETAP(HC) = THETA;
                PHIP(HC) = PHI;
                if and(ZHET<=ZU,ZHET>=ZL) %NOT TO PROJECT HETDOMAIN IN UPPER HEMISPHERE OF THE COLLOID
                    XPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                    YPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                    ZPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                    RPRO(HC) = 0.0; %EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                else %GENERATE PROJECTION OF HETDOMAINS IN LOWER HEMISPHERE OF THE COLLOID
                    if (RDHET>=RPL) %NOT TO PROJECT HETDOMAIN OUTSIDE PROJECTION RADIAL LIMIT
                        XPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                        YPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                        ZPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                        RPRO(HC) = 0.0; %EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT OF PROJECTION
                    else %GENERATE PROJECTION OF HETDOMAIN INSIDE PROJECTION RADIAL LIMIT AND LOWER HEMISPHERE OF COLLOID
                        DC = DAP*sin(BETA); %TOTAL DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-Y PLANE
                        DX = DC*cos(PHI); %DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-AXIS
                        DY = DC*sin(PHI); %DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN Y-AXIS
                        A = RPRO0; %ELLIPSE MAJOR AXIS
                        B = RPRO0*cos(BETA); %!ELLIPSE MINOR AXIS
                        XPRO(HC) = XHET - DX;
                        YPRO(HC) = YHET - DY;
                        ZPRO(HC) = -(AP + H);
                        RPRO(HC) = (A*B)^0.5; %EQUIVALENT CIRCLE RADIUS
                    end
                end
            else %GENERATE MEDIUM AND SMALL HETDOMAINS AROUND LARGE HETERODOMAIN 
                if (HETMODEP==5) %1:4
                    THETA1 = THETA + DTHETA1;  
                    PHI = double(J-2)*PI/2.0;
                    R1 = AP*sin(THETA1);
                    XHET = R1*cos(PHI)+XmP0;
                    YHET = R1*sin(PHI)+YmP0;
                    ZHET = AP*cos(THETA1)+ZmP0;
                    RHET = RHETP1;
                    BETA = acos((ZmP0-ZHET)/AP); %ELEVATION ANGLE OF THE HETERODOMAIN RESPECT TO PROJECTION PLANE
                    ARG = (ZmP0-ZHET)/AP;
                    if (ARG>=1.0)
                        ARG = 1.0;
                        BETA = acos(ARG);
                    elseif (ARG<=-1.0)
                        ARG = -1.0;
                        BETA = acos(ARG);
                    end
                    RDHET = ((XHET-XmP0)^2+(YHET-YmP0)^2)^0.5; %RADIAL DISTANCE OF HETERODOMAIN CENTER
                    XHETP(HC) = XHET;
                    YHETP(HC) = YHET;
                    ZHETP(HC) = ZHET;
                    RHETP(HC) = RHET;
                    THETAP(HC) = THETA1;
                    PHIP(HC) = PHI;
                    if and(ZHET<=ZU,ZHET>=ZL) %NOT TO PROJECT HETDOMAIN IN UPPER HEMISPHERE OF THE COLLOID
                        XPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        YPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        ZPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        RPRO(HC) = 0.0; %EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                    else %GENERATE PROJECTION OF HETDOMAINS IN LOWER HEMISPHERE OF THE COLLOID
                        if (RDHET>=RPL) %NOT TO PROJECT HETDOMAIN OUTSIDE PROJECTION RADIAL LIMIT
                            XPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                            YPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                            ZPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                            RPRO(HC) = 0.0; %EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT OF PROJECTION
                        else %GENERATE PROJECTION OF HETDOMAIN INSIDE PROJECTION RADIAL LIMIT AND LOWER HEMISPHERE OF COLLOID
                            DC = DAP*sin(BETA); %TOTAL DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-Y PLANE
                            DX = DC*cos(PHI); %DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-AXIS
                            DY = DC*sin(PHI); %DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN Y-AXIS
                            A = RPRO1; %ELLIPSE MAJOR AXIS
                            B = RPRO1*cos(BETA); %!ELLIPSE MINOR AXIS
                            XPRO(HC) = XHET - DX;
                            YPRO(HC) = YHET - DY;
                            ZPRO(HC) = -(AP + H);
                            RPRO(HC) = (A*B)^0.5; %EQUIVALENT CIRCLE RADIUS
                        end
                    end
                elseif (HETMODEP==9) %1:8
                    THETA1 = THETA + DTHETA1;  
                    PHI = double(J-2)*PI/4.0;
                    XHET = R1*cos(PHI)+XmP0;
                    YHET = R1*sin(PHI)+YmP0;
                    ZHET = AP*cos(THETA1)+ZmP0;
                    RHET = RHETP1;
                    BETA = acos((ZmP0-ZHET)/AP); %ELEVATION ANGLE OF THE HETERODOMAIN RESPECT TO PROJECTION PLANE
                    ARG = (ZmP0-ZHET)/AP;
                    if (ARG>=1.0)
                        ARG = 1.0;
                        BETA = acos(ARG);
                    elseif (ARG<=-1.0)
                        ARG = -1.0;
                        BETA = acos(ARG);
                    end
                    RDHET = ((XHET-XmP0)^2+(YHET-YmP0)^2)^0.5; %RADIAL DISTANCE OF HETERODOMAIN CENTER
                    XHETP(HC) = XHET;
                    YHETP(HC) = YHET;
                    ZHETP(HC) = ZHET;
                    RHETP(HC) = RHET;
                    THETAP(HC) = THETA1;
                    PHIP(HC) = PHI;
                    if and(ZHET<=ZU,ZHET>=ZL) %NOT TO PROJECT HETDOMAIN IN UPPER HEMISPHERE OF THE COLLOID
                        XPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        YPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        ZPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        RPRO(HC) = 0.0; %EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                    else %GENERATE PROJECTION OF HETDOMAINS IN LOWER HEMISPHERE OF THE COLLOID
                        if (RDHET>=RPL) %NOT TO PROJECT HETDOMAIN OUTSIDE PROJECTION RADIAL LIMIT
                            XPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                            YPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                            ZPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                            RPRO(HC) = 0.0; %EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT OF PROJECTION
                        else %GENERATE PROJECTION OF HETDOMAIN INSIDE PROJECTION RADIAL LIMIT AND LOWER HEMISPHERE OF COLLOID
                            DC = DAP*sin(BETA); %TOTAL DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-Y PLANE
                            DX = DC*cos(PHI); %DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-AXIS
                            DY = DC*sin(PHI); %DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN Y-AXIS
                            A = RPRO1; %ELLIPSE MAJOR AXIS
                            B = RPRO1*cos(BETA); %!ELLIPSE MINOR AXIS
                            XPRO(HC) = XHET - DX;
                            YPRO(HC) = YHET - DY;
                            ZPRO(HC) = -(AP + H);
                            RPRO(HC) = (A*B)^0.5; %EQUIVALENT CIRCLE RADIUS
                        end
                    end
                end
            end                      
        end
    else % NOT AT POLES
        RRING = AP*sin(THETA);
        %CALCULATE NUMBER OF HETERODOMAINS IN RING
        NHETRING = round(2.0*PI*RRING/ARCL);
        if (NHETRING<3)  
            NHETRING = 3;
        end
        NHRINGREAL = NHETRING;
        %CALCULATE STEP IN PHI (AZIMUTHAL ANGLE) BASED ON NHETRING
        DPHI = 2.0*PI/NHRINGREAL;
        %CALCULATE OFFSET AS 10% OF THE STEP IN PHI IF RING IS ODD OR EVEN
        M = rem(I,2);
        if (M==0)  
            PHIOFF = 0.1*DPHI; 
        else
            PHIOFF = -0.1*DPHI; 
        end
        %POPULATE HETERODOMAINS ON RINGS
        for K=1:NHETRING
            %CALCULATE PHI ANGLE
            PHI = (K-1)*DPHI + PHIOFF;
            for J=1:HETMODEP
                HC = HC + 1;
                if (J==1) %GENERATE LARGE HETERODOMAIN
                    XHET = RRING*cos(PHI)+XmP0;
                    YHET = RRING*sin(PHI)+YmP0;
                    ZHET = AP*cos(THETA)+ZmP0; 
                    RHET = RHETP0;
                    BETA = acos((ZmP0-ZHET)/AP); %ELEVATION ANGLE OF THE HETERODOMAIN RESPECT TO PROJECTION PLANE
                    ARG = (ZmP0-ZHET)/AP;
                    if (ARG>=1.0)
                        ARG = 1.0;
                        BETA = acos(ARG);
                    elseif (ARG<=-1.0)
                        ARG = -1.0;
                        BETA = acos(ARG);
                    end
                    RDHET = ((XHET-XmP0)^2+(YHET-YmP0)^2)^0.5; %RADIAL DISTANCE OF HETERODOMAIN CENTER
                    XHETP(HC) = XHET;
                    YHETP(HC) = YHET;
                    ZHETP(HC) = ZHET;
                    RHETP(HC) = RHET;
                    THETAP(HC) = THETA;
                    PHIP(HC) = PHI;
                    if and(ZHET<=ZU,ZHET>=ZL) %NOT TO PROJECT HETDOMAIN IN UPPER HEMISPHERE OF THE COLLOID
                        XPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        YPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        ZPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        RPRO(HC) = 0.0; %EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                    else %GENERATE PROJECTION OF HETDOMAINS IN LOWER HEMISPHERE OF THE COLLOID
                        if (RDHET>=RPL) %NOT TO PROJECT HETDOMAIN OUTSIDE PROJECTION RADIAL LIMIT
                            XPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                            YPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                            ZPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                            RPRO(HC) = 0.0; %EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT OF PROJECTION
                        else %GENERATE PROJECTION OF HETDOMAIN INSIDE PROJECTION RADIAL LIMIT AND LOWER HEMISPHERE OF COLLOID
                            DC = DAP*sin(BETA); %TOTAL DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-Y PLANE
                            DX = DC*cos(PHI); %DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-AXIS
                            DY = DC*sin(PHI); %DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN Y-AXIS
                            A = RPRO0; %ELLIPSE MAJOR AXIS
                            B = RPRO0*cos(BETA); %!ELLIPSE MINOR AXIS
                            XPRO(HC) = XHET - DX;
                            YPRO(HC) = YHET - DY;
                            ZPRO(HC) = -(AP + H);
                            RPRO(HC) = (A*B)^0.5; %EQUIVALENT CIRCLE RADIUS
                        end
                    end                                        
                else %GENERATE MEDIUM AND SMALL HETDOMAINS AROUND LARGE HETERODOMAIN
                    if (HETMODEP==5) %1:4
                        if (J==2)
                            PHI1 = PHI-(1.0/3.0*DPHI);
                            THETA1 = THETA+(1.0/3.0*DTHETA);                           
                        end
                        if (J==3)
                            PHI1 = PHI+(1.0/3.0*DPHI);
                            THETA1 = THETA+(1.0/3.0*DTHETA); 
                        end
                        if (J==4)
                            PHI1 = PHI+(1.0/3.0*DPHI);
                            THETA1 = THETA-(1.0/3.0*DTHETA); 
                        end
                        if (J==5)
                            PHI1 = PHI-(1.0/3.0*DPHI);
                            THETA1 = THETA-(1.0/3.0*DTHETA); 
                        end
                        R1 = AP*sin(THETA1);
                        XHET = R1*cos(PHI1)+XmP0;
                        YHET = R1*sin(PHI1)+YmP0;
                        ZHET = AP*cos(THETA1)+ZmP0;
                        RHET = RHETP1;
                        BETA = acos((ZmP0-ZHET)/AP); %ELEVATION ANGLE OF THE HETERODOMAIN RESPECT TO PROJECTION PLANE
                        ARG = (ZmP0-ZHET)/AP;
                        if (ARG>=1.0)
                            ARG = 1.0;
                            BETA = acos(ARG);
                        elseif (ARG<=-1.0)
                            ARG = -1.0;
                            BETA = acos(ARG);
                        end
                        RDHET = ((XHET-XmP0)^2+(YHET-YmP0)^2)^0.5; %RADIAL DISTANCE OF HETERODOMAIN CENTER
                        XHETP(HC) = XHET;
                        YHETP(HC) = YHET;
                        ZHETP(HC) = ZHET;
                        RHETP(HC) = RHET;
                        THETAP(HC) = THETA1;
                        PHIP(HC) = PHI1;
                        if and(ZHET<=ZU,ZHET>=ZL) %NOT TO PROJECT HETDOMAIN IN UPPER HEMISPHERE OF THE COLLOID
                            XPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            YPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            ZPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            RPRO(HC) = 0.0; %EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        else %GENERATE PROJECTION OF HETDOMAINS IN LOWER HEMISPHERE OF THE COLLOID
                            if (RDHET>=RPL) %NOT TO PROJECT HETDOMAIN OUTSIDE PROJECTION RADIAL LIMIT
                                XPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                YPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                ZPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                RPRO(HC) = 0.0; %EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT OF PROJECTION
                            else %GENERATE PROJECTION OF HETDOMAIN INSIDE PROJECTION RADIAL LIMIT AND LOWER HEMISPHERE OF COLLOID
                                DC = DAP*sin(BETA); %TOTAL DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-Y PLANE
                                DX = DC*cos(PHI1); %DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-AXIS
                                DY = DC*sin(PHI1); %DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN Y-AXIS
                                A = RPRO1; %ELLIPSE MAJOR AXIS
                                B = RPRO1*cos(BETA); %!ELLIPSE MINOR AXIS
                                XPRO(HC) = XHET - DX;
                                YPRO(HC) = YHET - DY;
                                ZPRO(HC) = -(AP + H);
                                RPRO(HC) = (A*B)^0.5; %EQUIVALENT CIRCLE RADIUS
                            end
                        end
                    elseif (HETMODEP==9) %1:8
                        if (J==2)
                            PHI1 = PHI-(1.0/3.0*DPHI);
                            THETA1 = THETA+(1.0/3.0*DTHETA); 
                        end
                        if (J==3)
                            PHI1 = PHI+(1.0/3.0*DPHI);
                            THETA1 = THETA+(1.0/3.0*DTHETA); 
                        end
                        if (J==4)
                            PHI1 = PHI+(1.0/3.0*DPHI);
                            THETA1 = THETA-(1.0/3.0*DTHETA); 
                        end
                        if (J==5)
                            PHI1 = PHI-(1.0/3.0*DPHI);
                            THETA1 = THETA-(1.0/3.0*DTHETA); 
                        end
                        if (J==6)
                            PHI1 = PHI-(1.0/3.0*DPHI);
                            THETA1 = THETA; 
                        end
                        if (J==7)
                            PHI1 = PHI;
                            THETA1 = THETA+(1.0/3.0*DTHETA); 
                        end
                        if (J==8)
                            PHI1 = PHI+(1.0/3.0*DPHI);
                            THETA1 = THETA; 
                        end
                        if (J==9)
                            PHI1 = PHI;
                            THETA1 = THETA-(1.0/3.0*DTHETA); 
                        end
                        R1 = AP*sin(THETA1);
                        XHET = R1*cos(PHI1)+XmP0;
                        YHET = R1*sin(PHI1)+YmP0;
                        ZHET = AP*cos(THETA1)+ZmP0;
                        RHET = RHETP1;
                        BETA = acos((ZmP0-ZHET)/AP); %ELEVATION ANGLE OF THE HETERODOMAIN RESPECT TO PROJECTION PLANE
                        ARG = (ZmP0-ZHET)/AP;
                        if (ARG>=1.0)
                            ARG = 1.0;
                            BETA = acos(ARG);
                        elseif (ARG<=-1.0)
                            ARG = -1.0;
                            BETA = acos(ARG);
                        end
                        RDHET = ((XHET-XmP0)^2+(YHET-YmP0)^2)^0.5; %RADIAL DISTANCE OF HETERODOMAIN CENTER
                        XHETP(HC) = XHET;
                        YHETP(HC) = YHET;
                        ZHETP(HC) = ZHET;
                        RHETP(HC) = RHET;
                        THETAP(HC) = THETA1;
                        PHIP(HC) = PHI1;
                        if and(ZHET<=ZU,ZHET>=ZL) %NOT TO PROJECT HETDOMAIN IN UPPER HEMISPHERE OF THE COLLOID
                            XPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            YPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            ZPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            RPRO(HC) = 0.0; %EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        else %GENERATE PROJECTION OF HETDOMAINS IN LOWER HEMISPHERE OF THE COLLOID
                            if (RDHET>=RPL) %NOT TO PROJECT HETDOMAIN OUTSIDE PROJECTION RADIAL LIMIT
                                XPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                YPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                ZPRO(HC) = 0.0; %0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                RPRO(HC) = 0.0; %EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT OF PROJECTION
                            else %GENERATE PROJECTION OF HETDOMAIN INSIDE PROJECTION RADIAL LIMIT AND LOWER HEMISPHERE OF COLLOID
                                DC = DAP*sin(BETA); %TOTAL DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-Y PLANE
                                DX = DC*cos(PHI1); %DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-AXIS
                                DY = DC*sin(PHI1); %DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN Y-AXIS
                                A = RPRO1; %ELLIPSE MAJOR AXIS
                                B = RPRO1*cos(BETA); %!ELLIPSE MINOR AXIS
                                XPRO(HC) = XHET - DX;
                                YPRO(HC) = YHET - DY;
                                ZPRO(HC) = -(AP + H);
                                RPRO(HC) = (A*B)^0.5; %EQUIVALENT CIRCLE RADIUS
                            end
                        end
                    end
                end                      
            end
        end
    end
end

% GENERATE MATRIX WITH HETP LOCATIONS AND RADII IN (XmP0,YmP0,ZmP0) FRAME OF REFERENCE
if (SCOVP>0)
    MHETP(:,1) = XHETP;
    MHETP(:,2) = YHETP;
    MHETP(:,3) = ZHETP;
    MHETP(:,4) = RHETP;
else
    MHETP(:,1) = 0;
    MHETP(:,2) = 0;
    MHETP(:,3) = 0;
    MHETP(:,4) = 0;
end
% GENERATE MATRIX WITH HETP PROJECTION LOCATIONS AND RADII IN (XmP0,YmP0,ZmP0) FRAME OF REFERENCE
if (SCOVP>0)
    INDEX = find(RPRO~=0);
    MPRO(:,1) = XPRO(INDEX);
    MPRO(:,2) = YPRO(INDEX);
    MPRO(:,3) = ZPRO(INDEX);
    MPRO(:,4) = RPRO(INDEX);
else
    MPRO(:,1) = 0;
    MPRO(:,2) = 0;
    MPRO(:,3) = 0;
    MPRO(:,4) = 0;
end
end