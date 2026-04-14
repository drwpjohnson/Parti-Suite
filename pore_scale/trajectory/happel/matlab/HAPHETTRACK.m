% FUNCTION TO TRACK COLLECTOR HETERODOMAINS WRITTEN - CESAR RON
% ISO CONVENTION USED FOR SPHERICAL COORDINATES [R,THETA,PHI] (RADIAL, POLAR, AZIMUTAHL)
function [XHET,YHET,ZHET,RHET]=HAPHETTRACK(X,Y,Z,Xm0,Ym0,Zm0,AG,...
                               HETMODE,SCOV,RHET0,RHET1,RHET2,HETCFLAG)
PI=3.14159265359;

%EQUIVALENT SURFACE COVERAGE CORRESPONDING TO UNIFORM HETERODOMAINS IS USED IN CALCULATION, EQUALS HALF OF BIMODAL SURFACE COVERAGE
if (HETMODE==1) %UNIFORM 
    HM1 = 0.0;
    HM2 = 0.0;
elseif(HETMODE==5) %1:4  
    HM1 = 4.0;
    HM2 = 0.0;  
elseif(HETMODE==9) %1:8
    HM1 = 8.0;
    HM2 = 0.0;  
elseif(HETMODE==73) %1:8:64
    HM1 = 8.0;
    HM2 = 64.0;  
end
SCOV0 = SCOV*(RHET0^2)/(RHET0^2+HM1*RHET1^2+HM2*RHET2^2);

%CALCULATE THEORETICAL NUMBER OF HETERODOMAINS REQUIRED
NHET0 = round(SCOV0*(4.0*AG^2.0)/(RHET0^2.0));
NHET1 = HM1*NHET0;
NHET2 = HM2*NHET0;

%CALCULATE NUMBER OF RINGS THAT YIELD NHET ASSUMING EVEN SPACING 
NHETREAL0 = NHET0;
%THE DENOMINATOR 1/1.3 WAS CALIBRATED TO YIELD EVEN SPACING DISTRIBUTION OF HETDOMAINS MATCHING SCOV
NRING = round((NHETREAL0/1.3)^0.5);
NRINGREAL = NRING;

%SPHERICAL COORDINATES: RADIUS, THETA (POLAR ANGLE), PHI (AZIMUTHAL ANGLE)
%AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
%CALCULATE THETA ANGLE STEP AND CONSTANT ARC LENGTH
DTHETA =  PI/(NRINGREAL-1);
ARCL = DTHETA*AG;

%CALCULATE CALCULATE DISTANCE TO COLLOID CENTER
RO = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0)+(Z-Zm0)*(Z-Zm0))^0.5;

%CALCULATE THETA ANGLE
THETAP = acos((Z-Zm0)/RO);
%CALCULATE PROJECTION OF COLLOID POSITION ON XY PLANE
ROXY = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0))^0.5;
%CALCULATE COLLOID PHI ANGLE
if (ROXY==0.0)  
    PHIP = 0.0;
else
    if ((Y-Ym0)>=0.0)  
        PHIP = acos((X-Xm0)/ROXY);
    else
        PHIP = 2.0*PI-acos((X-Xm0)/ROXY);
    end
end

if (HETCFLAG==0) % GENERATE HETC FOR AFRACT CALCULATION
    %NTHETAP IS CLOSEST RING TO COLLOID PROJECTION
    NTHETAP = round(THETAP/DTHETA)+1;
    %AT POLE
    if or(NTHETAP==1,NTHETAP==NRING) 
        DTHETA1 = 1.0/3.0*DTHETA;
        DPHI = 0.0;
        RRING = 0.0;
        if (NTHETAP==1)   
            THETA = 0.0;
        elseif (NTHETAP==NRING)
            THETA = PI;
        end
        %POPULATE HETERODOMAINS AT POLE
        for J=1:HETMODE
            if (J==1) %GENERATE LARGE HETERODOMAIN
                PHI = 0.0;
                R1 = RRING;
                XHET(J) = R1*cos(PHI)+Xm0;
                YHET(J) = R1*sin(PHI)+Ym0;
                ZHET(J) = AG*cos(THETA)+Zm0; 
                RHET(J) = RHET0;
                THETAT(J) = THETA;
                PHIT(J) = PHI;
            else %GENERATE MEDIUM AND SMALL HETDOMAINS AROUND LARGE HETERODOMAIN 
                if (HETMODE==5) %1:4
                    THETA1 = THETA + DTHETA1;  
                    PHI = double(J-2)*PI/2.0;
                    R1 = AG*sin(THETA1);
                    XHET(J) = R1*cos(PHI)+Xm0;
                    YHET(J) = R1*sin(PHI)+Ym0;
                    ZHET(J) = AG*cos(THETA1)+Zm0;
                    RHET(J) = RHET1;
                    THETAT(J) = THETA1;
                    PHIT(J) = PHI;
                elseif (HETMODE==9) %1:8
                    THETA1 = THETA + DTHETA1;  
                    PHI = double(J-2)*PI/4.0;
                    R1 = AG*sin(THETA1);
                    XHET(J) = R1*cos(PHI)+Xm0;
                    YHET(J) = R1*sin(PHI)+Ym0;
                    ZHET(J) = AG*cos(THETA1)+Zm0;
                    RHET(J) = RHET1;
                    THETAT(J) = THETA1;
                    PHIT(J) = PHI;
                elseif (HETMODE==73) %1:8:64
                    if and(J>=2,J<=9)
                        THETA1 = THETA + DTHETA1;  
                        PHI = double(J-2)*PI/4.0;
                        R1 = AG*sin(THETA1);
                        XHET(J) = R1*cos(PHI)+Xm0;
                        YHET(J) = R1*sin(PHI)+Ym0;
                        ZHET(J) = AG*cos(THETA1)+Zm0;
                        RHET(J) = RHET1;
                        THETAT(J) = THETA1;
                        PHIT(J) = PHI;
                    elseif and(J>=10,J<=17)
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA1 = round(1.155*sin(2.094*double(J-9)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(2-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*double(J-9)+3.927)+0.2989*sin(3.665*double(J-9)-7.069));
                        PHI1 = PHI + F_PHI*DPHI1;
                        R1 = AG*sin(THETA2);
                        XHET(J) = R1*cos(PHI1)+Xm0;
                        YHET(J) = R1*sin(PHI1)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET(J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI1;
                    elseif and(J>=18,J<=25)
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA1 = round(1.155*sin(2.094*double(J-17)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(3-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*double(J-17)+3.927)+0.2989*sin(3.665*double(J-17)-7.069));
                        PHI1 = PHI + F_PHI*DPHI1;
                        R1 = AG*sin(THETA2);
                        XHET(J) = R1*cos(PHI1)+Xm0;
                        YHET(J) = R1*sin(PHI1)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET(J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI1;
                    elseif and(J>=26,J<=33)
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA1 = round(1.155*sin(2.094*double(J-25)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(4-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*double(J-25)+3.927)+0.2989*sin(3.665*double(J-25)-7.069));
                        PHI1 = PHI + F_PHI*DPHI1;
                        R1 = AG*sin(THETA2);
                        XHET(J) = R1*cos(PHI1)+Xm0;
                        YHET(J) = R1*sin(PHI1)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET(J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI1;
                    elseif and(J>=34,J<=41)
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA1 = round(1.155*sin(2.094*double(J-33)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(5-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*double(J-33)+3.927)+0.2989*sin(3.665*double(J-33)-7.069));
                        PHI1 = PHI + F_PHI*DPHI1;
                        R1 = AG*sin(THETA2);
                        XHET(J) = R1*cos(PHI1)+Xm0;
                        YHET(J) = R1*sin(PHI1)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET(J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI1;
                    elseif and(J>=42,J<=49)
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA1 = round(1.155*sin(2.094*double(J-41)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(6-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*double(J-41)+3.927)+0.2989*sin(3.665*double(J-41)-7.069));
                        PHI1 = PHI + F_PHI*DPHI1;
                        R1 = AG*sin(THETA2);
                        XHET(J) = R1*cos(PHI1)+Xm0;
                        YHET(J) = R1*sin(PHI1)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET(J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI1;
                    elseif and(J>=50,J<=57)
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA1 = round(1.155*sin(2.094*double(J-49)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(7-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*double(J-49)+3.927)+0.2989*sin(3.665*double(J-49)-7.069));
                        PHI1 = PHI + F_PHI*DPHI1;
                        R1 = AG*sin(THETA2);
                        XHET(J) = R1*cos(PHI1)+Xm0;
                        YHET(J) = R1*sin(PHI1)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET(J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI1;
                    elseif and(J>=58,J<=65)
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA1 = round(1.155*sin(2.094*double(J-57)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(8-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*double(J-57)+3.927)+0.2989*sin(3.665*double(J-57)-7.069));
                        PHI1 = PHI + F_PHI*DPHI1;
                        R1 = AG*sin(THETA2);
                        XHET(J) = R1*cos(PHI1)+Xm0;
                        YHET(J) = R1*sin(PHI1)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET(J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI1;
                    elseif and(J>=66,J<=73)
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA1 = round(1.155*sin(2.094*double(J-65)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(9-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*double(J-65)+3.927)+0.2989*sin(3.665*double(J-65)-7.069));
                        PHI1 = PHI + F_PHI*DPHI1;
                        R1 = AG*sin(THETA2);
                        XHET(J) = R1*cos(PHI1)+Xm0;
                        YHET(J) = R1*sin(PHI1)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET(J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI1;
                    end
                end
            end                      
        end
    else % NOT AT POLES
        %THETA ANGLE
        THETA = (NTHETAP-1)*DTHETA; 
        %CALCULATE RING RADIUS
        RRING = AG*sin(THETA);
        %CALCULATE NUMBER OF HETERODOMAINS IN RING
        NHETRING = round(2.0*PI*RRING/ARCL);
        if (NHETRING<3)  
            NHETRING = 3;
        end
        NHRINGREAL = NHETRING;
        %RECALCULATE STEP IN PHI BASED ON NHETRING
        DPHI = 2.0*PI/NHRINGREAL;
        %CALCULATE OFFSET AS 10% OF THE STEP IN PHI IF RING IS ODD OR EVEN
        M = rem(NTHETAP,2);
        if (M==0)  
            PHIOFF = 0.1*DPHI; 
        else
            PHIOFF = -0.1*DPHI; 
        end
        %CALCULATE PHI ANGLE BASED ON COLLOID PHI ANGLE
        PHI = DPHI*round((PHIP-PHIOFF)/DPHI)+PHIOFF; 
        for J=1:HETMODE
            if (J==1) %GENERATE LARGE HETERODOMAIN
                XHET(J) = RRING*cos(PHI)+Xm0;
                YHET(J) = RRING*sin(PHI)+Ym0;
                ZHET(J) = AG*cos(THETA)+Zm0; 
                RHET(J) = RHET0;
                THETAT(J) = THETA;
                PHIT(J) = PHI;
            else %GENERATE MEDIUM AND SMALL HETDOMAINS AROUND LARGE HETERODOMAIN
                if (HETMODE==5) %1:4
                    DTHETA1 = 1.0/3.0*DTHETA;
                    DPHI1 = 1.0/3.0*DPHI;
                    if (J==2)   
                        PHI1 = PHI - DPHI1;
                        THETA1 = THETA + DTHETA1;
                    end
                    if (J==3)   
                        PHI1 = PHI + DPHI1;
                        THETA1 = THETA + DTHETA1; 
                    end
                    if (J==4)   
                        PHI1 = PHI + DPHI1;
                        THETA1 = THETA - DTHETA1; 
                    end
                    if (J==5)   
                        PHI1 = PHI - DPHI1;
                        THETA1 = THETA - DTHETA1;
                    end                                   
                    R1 = AG*sin(THETA1);   
                    XHET(J) = R1*cos(PHI1)+Xm0;
                    YHET(J) = R1*sin(PHI1)+Ym0;
                    ZHET(J) = AG*cos(THETA1)+Zm0;
                    RHET (J) = RHET1;
                    THETAT(J) = THETA1;
                    PHIT(J) = PHI1;
                elseif (HETMODE==9) %1:8
                    DTHETA1 = 1.0/3.0*DTHETA;
                    F_THETA1 = round(1.155*sin(2.094*double(J-1)+3.142));
                    THETA1 = THETA + F_THETA1*DTHETA1;
                    DPHI1 = 1.0/3.0*DPHI;
                    F_PHI1 = round(1.115*sin(0.5236*double(J-1)+3.927)+0.2989*sin(3.665*double(J-1)-7.069));
                    PHI1 = PHI + F_PHI1*DPHI1;
                    R1 = AG*sin(THETA1);   
                    XHET(J) = R1*cos(PHI1)+Xm0;
                    YHET(J) = R1*sin(PHI1)+Ym0;
                    ZHET(J) = AG*cos(THETA1)+Zm0;
                    RHET (J) = RHET1;
                    THETAT(J) = THETA1;
                    PHIT(J) = PHI1;
                elseif (HETMODE==73) %1:8:64
                    if and(J>=2,J<=9)
                        DTHETA1 = 1.0/3.0*DTHETA;
                        F_THETA1 = round(1.155*sin(2.094*double(J-1)+3.142));
                        THETA1 = THETA + F_THETA1*DTHETA1;
                        DPHI1 = 1.0/3.0*DPHI;
                        F_PHI1 = round(1.115*sin(0.5236*double(J-1)+3.927)+0.2989*sin(3.665*double(J-1)-7.069));
                        PHI1 = PHI + F_PHI1*DPHI1;
                        R1 = AG*sin(THETA1);   
                        XHET(J) = R1*cos(PHI1)+Xm0;
                        YHET(J) = R1*sin(PHI1)+Ym0;
                        ZHET(J) = AG*cos(THETA1)+Zm0;
                        RHET (J) = RHET1;
                        THETAT(J) = THETA1;
                        PHIT(J) = PHI1;    
                    elseif and(J>=10,J<=17)
                        DTHETA1 = 1.0/3.0*DTHETA;
                        F_THETA1 = round(1.155*sin(2.094*(1)+3.142));
                        THETA1 = THETA + F_THETA1*DTHETA1;
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA2 = round(1.155*sin(2.094*double(J-9)+3.142));
                        THETA2 = THETA1 + F_THETA2*DTHETA2;
                        DPHI1 = 1.0/3.0*DPHI;
                        F_PHI1 = round(1.115*sin(0.5236*(1)+3.927)+0.2989*sin(3.665*(1)-7.069));
                        PHI1 = PHI + F_PHI1*DPHI1;
                        DPHI2 = 1.0/3.0*DPHI1;
                        F_PHI2 = round(1.115*sin(0.5236*double(J-9)+3.927)+0.2989*sin(3.665*double(J-9)-7.069));
                        PHI2 = PHI1 + F_PHI2*DPHI2;
                        R1 = AG*sin(THETA2);   
                        XHET(J) = R1*cos(PHI2)+Xm0;
                        YHET(J) = R1*sin(PHI2)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET (J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI2; 
                    elseif and(J>=18,J<=25)
                        DTHETA1 = 1.0/3.0*DTHETA;
                        F_THETA1 = round(1.155*sin(2.094*(2)+3.142));
                        THETA1 = THETA + F_THETA1*DTHETA1;
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA2 = round(1.155*sin(2.094*double(J-17)+3.142));
                        THETA2 = THETA1 + F_THETA2*DTHETA2;
                        DPHI1 = 1.0/3.0*DPHI;
                        F_PHI1 = round(1.115*sin(0.5236*(2)+3.927)+0.2989*sin(3.665*(2)-7.069));
                        PHI1 = PHI + F_PHI1*DPHI1;
                        DPHI2 = 1.0/3.0*DPHI1;
                        F_PHI2 = round(1.115*sin(0.5236*double(J-17)+3.927)+0.2989*sin(3.665*double(J-17)-7.069));
                        PHI2 = PHI1 + F_PHI2*DPHI2;
                        R1 = AG*sin(THETA2);   
                        XHET(J) = R1*cos(PHI2)+Xm0;
                        YHET(J) = R1*sin(PHI2)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET (J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI2;
                    elseif and(J>=26,J<=33)
                        DTHETA1 = 1.0/3.0*DTHETA;
                        F_THETA1 = round(1.155*sin(2.094*(3)+3.142));
                        THETA1 = THETA + F_THETA1*DTHETA1;
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA2 = round(1.155*sin(2.094*double(J-25)+3.142));
                        THETA2 = THETA1 + F_THETA2*DTHETA2;
                        DPHI1 = 1.0/3.0*DPHI;
                        F_PHI1 = round(1.115*sin(0.5236*(3)+3.927)+0.2989*sin(3.665*(3)-7.069));
                        PHI1 = PHI + F_PHI1*DPHI1;
                        DPHI2 = 1.0/3.0*DPHI1;
                        F_PHI2 = round(1.115*sin(0.5236*double(J-25)+3.927)+0.2989*sin(3.665*double(J-25)-7.069));
                        PHI2 = PHI1 + F_PHI2*DPHI2;
                        R1 = AG*sin(THETA2);   
                        XHET(J) = R1*cos(PHI2)+Xm0;
                        YHET(J) = R1*sin(PHI2)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET (J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI2;
                    elseif and(J>=34,J<=41)
                        DTHETA1 = 1.0/3.0*DTHETA;
                        F_THETA1 = round(1.155*sin(2.094*(4)+3.142));
                        THETA1 = THETA + F_THETA1*DTHETA1;
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA2 = round(1.155*sin(2.094*double(J-33)+3.142));
                        THETA2 = THETA1 + F_THETA2*DTHETA2;
                        DPHI1 = 1.0/3.0*DPHI;
                        F_PHI1 = round(1.115*sin(0.5236*(4)+3.927)+0.2989*sin(3.665*(4)-7.069));
                        PHI1 = PHI + F_PHI1*DPHI1;
                        DPHI2 = 1.0/3.0*DPHI1;
                        F_PHI2 = round(1.115*sin(0.5236*double(J-33)+3.927)+0.2989*sin(3.665*double(J-33)-7.069));
                        PHI2 = PHI1 + F_PHI2*DPHI2;
                        R1 = AG*sin(THETA2);   
                        XHET(J) = R1*cos(PHI2)+Xm0;
                        YHET(J) = R1*sin(PHI2)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET (J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI2;
                    elseif and(J>=42,J<=49)
                        DTHETA1 = 1.0/3.0*DTHETA;
                        F_THETA1 = round(1.155*sin(2.094*(5)+3.142));
                        THETA1 = THETA + F_THETA1*DTHETA1;
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA2 = round(1.155*sin(2.094*double(J-41)+3.142));
                        THETA2 = THETA1 + F_THETA2*DTHETA2;
                        DPHI1 = 1.0/3.0*DPHI;
                        F_PHI1 = round(1.115*sin(0.5236*(5)+3.927)+0.2989*sin(3.665*(5)-7.069));
                        PHI1 = PHI + F_PHI1*DPHI1;
                        DPHI2 = 1.0/3.0*DPHI1;
                        F_PHI2 = round(1.115*sin(0.5236*double(J-41)+3.927)+0.2989*sin(3.665*double(J-41)-7.069));
                        PHI2 = PHI1 + F_PHI2*DPHI2;
                        R1 = AG*sin(THETA2);   
                        XHET(J) = R1*cos(PHI2)+Xm0;
                        YHET(J) = R1*sin(PHI2)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET (J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI2;
                    elseif and(J>=50,J<=57)
                        DTHETA1 = 1.0/3.0*DTHETA;
                        F_THETA1 = round(1.155*sin(2.094*(6)+3.142));
                        THETA1 = THETA + F_THETA1*DTHETA1;
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA2 = round(1.155*sin(2.094*double(J-49)+3.142));
                        THETA2 = THETA1 + F_THETA2*DTHETA2;
                        DPHI1 = 1.0/3.0*DPHI;
                        F_PHI1 = round(1.115*sin(0.5236*(6)+3.927)+0.2989*sin(3.665*(6)-7.069));
                        PHI1 = PHI + F_PHI1*DPHI1;
                        DPHI2 = 1.0/3.0*DPHI1;
                        F_PHI2 = round(1.115*sin(0.5236*double(J-49)+3.927)+0.2989*sin(3.665*double(J-49)-7.069));
                        PHI2 = PHI1 + F_PHI2*DPHI2;
                        R1 = AG*sin(THETA2);   
                        XHET(J) = R1*cos(PHI2)+Xm0;
                        YHET(J) = R1*sin(PHI2)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET (J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI2;
                    elseif and(J>=58,J<=65)
                        DTHETA1 = 1.0/3.0*DTHETA;
                        F_THETA1 = round(1.155*sin(2.094*(7)+3.142));
                        THETA1 = THETA + F_THETA1*DTHETA1;
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA2 = round(1.155*sin(2.094*double(J-57)+3.142));
                        THETA2 = THETA1 + F_THETA2*DTHETA2;
                        DPHI1 = 1.0/3.0*DPHI;
                        F_PHI1 = round(1.115*sin(0.5236*(7)+3.927)+0.2989*sin(3.665*(7)-7.069));
                        PHI1 = PHI + F_PHI1*DPHI1;
                        DPHI2 = 1.0/3.0*DPHI1;
                        F_PHI2 = round(1.115*sin(0.5236*double(J-57)+3.927)+0.2989*sin(3.665*double(J-57)-7.069));
                        PHI2 = PHI1 + F_PHI2*DPHI2;
                        R1 = AG*sin(THETA2);   
                        XHET(J) = R1*cos(PHI2)+Xm0;
                        YHET(J) = R1*sin(PHI2)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET (J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI2;
                    elseif and(J>=66,J<=73)
                        DTHETA1 = 1.0/3.0*DTHETA;
                        F_THETA1 = round(1.155*sin(2.094*(8)+3.142));
                        THETA1 = THETA + F_THETA1*DTHETA1;
                        DTHETA2 = 1.0/3.0*DTHETA1;
                        F_THETA2 = round(1.155*sin(2.094*double(J-65)+3.142));
                        THETA2 = THETA1 + F_THETA2*DTHETA2;
                        DPHI1 = 1.0/3.0*DPHI;
                        F_PHI1 = round(1.115*sin(0.5236*(8)+3.927)+0.2989*sin(3.665*(8)-7.069));
                        PHI1 = PHI + F_PHI1*DPHI1;
                        DPHI2 = 1.0/3.0*DPHI1;
                        F_PHI2 = round(1.115*sin(0.5236*double(J-65)+3.927)+0.2989*sin(3.665*double(J-65)-7.069));
                        PHI2 = PHI1 + F_PHI2*DPHI2;
                        R1 = AG*sin(THETA2);   
                        XHET(J) = R1*cos(PHI2)+Xm0;
                        YHET(J) = R1*sin(PHI2)+Ym0;
                        ZHET(J) = AG*cos(THETA2)+Zm0;
                        RHET (J) = RHET2;
                        THETAT(J) = THETA2;
                        PHIT(J) = PHI2;
                    end
                end
            end                      
        end
    end
elseif (HETCFLAG==1) % GENERATE HETC FOR GUI FRONTEND REPRESENTATION 
    %NTHETAP IS CLOSEST RING TO COLLOID PROJECTION
    NTHETAP = round(THETAP/DTHETA)+1;
    %M_THETA CONTAINS VALUES OF NTHETA THAT WILL YIELD THETA ANGLE DOMAIN
    if (NTHETAP==1)
        M_NTHETA = [NTHETAP NTHETAP+1];
    elseif (NTHETAP==NRING)
        M_NTHETA = [NTHETAP NTHETAP-1];
    else
        M_NTHETA = [NTHETAP (NTHETAP-1) (NTHETAP+1)];
    end
    H = 0; % HETC COUNTER
    %LOOP THROUGH THETA DOMAIN
    for K=1:length(M_NTHETA)
        NTHETA = M_NTHETA(K);
        %AT POLE
        if or(NTHETA==1,NTHETA==NRING) 
            DTHETA1 = 1.0/3.0*DTHETA;
            DPHI = 0.0;
            RRING = 0.0;
            if (NTHETA==1)   
                THETA = 0.0;
            elseif (NTHETA==NRING)
                THETA = PI;
            end
            %POPULATE HETERODOMAINS AT POLE
            for J=1:HETMODE
                H = H + 1;
                if (J==1) %GENERATE LARGE HETERODOMAIN
                    PHI = 0.0;
                    R1 = RRING;
                    XHET(H) = R1*cos(PHI)+Xm0;
                    YHET(H) = R1*sin(PHI)+Ym0;
                    ZHET(H) = AG*cos(THETA)+Zm0; 
                    RHET(H) = RHET0;
                    THETAT(H) = THETA;
                    PHIT(H) = PHI;
                else %GENERATE MEDIUM AND SMALL HETDOMAINS AROUND LARGE HETERODOMAIN 
                    if (HETMODE==5) %1:4
                        THETA1 = THETA + DTHETA1;  
                        PHI = double(J-2)*PI/2.0;
                        R1 = AG*sin(THETA1);
                        XHET(H) = R1*cos(PHI)+Xm0;
                        YHET(H) = R1*sin(PHI)+Ym0;
                        ZHET(H) = AG*cos(THETA1)+Zm0;
                        RHET(H) = RHET1;
                        THETAT(H) = THETA1;
                        PHIT(H) = PHI;
                    elseif (HETMODE==9) %1:8
                        THETA1 = THETA + DTHETA1;  
                        PHI = double(J-2)*PI/4.0;
                        R1 = AG*sin(THETA1);
                        XHET(H) = R1*cos(PHI)+Xm0;
                        YHET(H) = R1*sin(PHI)+Ym0;
                        ZHET(H) = AG*cos(THETA1)+Zm0;
                        RHET(H) = RHET1;
                        THETAT(H) = THETA1;
                        PHIT(H) = PHI;
                    elseif (HETMODE==73) %1:8:64
                        if and(J>=2,J<=9)
                            THETA1 = THETA + DTHETA1;  
                            PHI = double(J-2)*PI/4.0;
                            R1 = AG*sin(THETA1);
                            XHET(H) = R1*cos(PHI)+Xm0;
                            YHET(H) = R1*sin(PHI)+Ym0;
                            ZHET(H) = AG*cos(THETA1)+Zm0;
                            RHET(H) = RHET1;
                            THETAT(H) = THETA1;
                            PHIT(H) = PHI;
                        elseif and(J>=10,J<=17)
                            DTHETA2 = 1.0/3.0*DTHETA1;
                            F_THETA1 = round(1.155*sin(2.094*double(J-9)+3.142));
                            THETA2 = THETA1 + F_THETA1*DTHETA2;  
                            PHI = double(2-2)*PI/4.0;
                            DPHI1 = 1.0/3.0*(PI/4.0);
                            F_PHI = round(1.115*sin(0.5236*double(J-9)+3.927)+0.2989*sin(3.665*double(J-9)-7.069));
                            PHI1 = PHI + F_PHI*DPHI1;
                            R1 = AG*sin(THETA2);
                            XHET(H) = R1*cos(PHI1)+Xm0;
                            YHET(H) = R1*sin(PHI1)+Ym0;
                            ZHET(H) = AG*cos(THETA2)+Zm0;
                            RHET(H) = RHET2;
                            THETAT(H) = THETA2;
                            PHIT(H) = PHI1;
                        elseif and(J>=18,J<=25)
                            DTHETA2 = 1.0/3.0*DTHETA1;
                            F_THETA1 = round(1.155*sin(2.094*double(J-17)+3.142));
                            THETA2 = THETA1 + F_THETA1*DTHETA2;  
                            PHI = double(3-2)*PI/4.0;
                            DPHI1 = 1.0/3.0*(PI/4.0);
                            F_PHI = round(1.115*sin(0.5236*double(J-17)+3.927)+0.2989*sin(3.665*double(J-17)-7.069));
                            PHI1 = PHI + F_PHI*DPHI1;
                            R1 = AG*sin(THETA2);
                            XHET(H) = R1*cos(PHI1)+Xm0;
                            YHET(H) = R1*sin(PHI1)+Ym0;
                            ZHET(H) = AG*cos(THETA2)+Zm0;
                            RHET(H) = RHET2;
                            THETAT(H) = THETA2;
                            PHIT(H) = PHI1;
                        elseif and(J>=26,J<=33)
                            DTHETA2 = 1.0/3.0*DTHETA1;
                            F_THETA1 = round(1.155*sin(2.094*double(J-25)+3.142));
                            THETA2 = THETA1 + F_THETA1*DTHETA2;  
                            PHI = double(4-2)*PI/4.0;
                            DPHI1 = 1.0/3.0*(PI/4.0);
                            F_PHI = round(1.115*sin(0.5236*double(J-25)+3.927)+0.2989*sin(3.665*double(J-25)-7.069));
                            PHI1 = PHI + F_PHI*DPHI1;
                            R1 = AG*sin(THETA2);
                            XHET(H) = R1*cos(PHI1)+Xm0;
                            YHET(H) = R1*sin(PHI1)+Ym0;
                            ZHET(H) = AG*cos(THETA2)+Zm0;
                            RHET(H) = RHET2;
                            THETAT(H) = THETA2;
                            PHIT(H) = PHI1;
                        elseif and(J>=34,J<=41)
                            DTHETA2 = 1.0/3.0*DTHETA1;
                            F_THETA1 = round(1.155*sin(2.094*double(J-33)+3.142));
                            THETA2 = THETA1 + F_THETA1*DTHETA2;  
                            PHI = double(5-2)*PI/4.0;
                            DPHI1 = 1.0/3.0*(PI/4.0);
                            F_PHI = round(1.115*sin(0.5236*double(J-33)+3.927)+0.2989*sin(3.665*double(J-33)-7.069));
                            PHI1 = PHI + F_PHI*DPHI1;
                            R1 = AG*sin(THETA2);
                            XHET(H) = R1*cos(PHI1)+Xm0;
                            YHET(H) = R1*sin(PHI1)+Ym0;
                            ZHET(H) = AG*cos(THETA2)+Zm0;
                            RHET(H) = RHET2;
                            THETAT(H) = THETA2;
                            PHIT(H) = PHI1;
                        elseif and(J>=42,J<=49)
                            DTHETA2 = 1.0/3.0*DTHETA1;
                            F_THETA1 = round(1.155*sin(2.094*double(J-41)+3.142));
                            THETA2 = THETA1 + F_THETA1*DTHETA2;  
                            PHI = double(6-2)*PI/4.0;
                            DPHI1 = 1.0/3.0*(PI/4.0);
                            F_PHI = round(1.115*sin(0.5236*double(J-41)+3.927)+0.2989*sin(3.665*double(J-41)-7.069));
                            PHI1 = PHI + F_PHI*DPHI1;
                            R1 = AG*sin(THETA2);
                            XHET(H) = R1*cos(PHI1)+Xm0;
                            YHET(H) = R1*sin(PHI1)+Ym0;
                            ZHET(H) = AG*cos(THETA2)+Zm0;
                            RHET(H) = RHET2;
                            THETAT(H) = THETA2;
                            PHIT(H) = PHI1;
                        elseif and(J>=50,J<=57)
                            DTHETA2 = 1.0/3.0*DTHETA1;
                            F_THETA1 = round(1.155*sin(2.094*double(J-49)+3.142));
                            THETA2 = THETA1 + F_THETA1*DTHETA2;  
                            PHI = double(7-2)*PI/4.0;
                            DPHI1 = 1.0/3.0*(PI/4.0);
                            F_PHI = round(1.115*sin(0.5236*double(J-49)+3.927)+0.2989*sin(3.665*double(J-49)-7.069));
                            PHI1 = PHI + F_PHI*DPHI1;
                            R1 = AG*sin(THETA2);
                            XHET(H) = R1*cos(PHI1)+Xm0;
                            YHET(H) = R1*sin(PHI1)+Ym0;
                            ZHET(H) = AG*cos(THETA2)+Zm0;
                            RHET(H) = RHET2;
                            THETAT(H) = THETA2;
                            PHIT(H) = PHI1;
                        elseif and(J>=58,J<=65)
                            DTHETA2 = 1.0/3.0*DTHETA1;
                            F_THETA1 = round(1.155*sin(2.094*double(J-57)+3.142));
                            THETA2 = THETA1 + F_THETA1*DTHETA2;  
                            PHI = double(8-2)*PI/4.0;
                            DPHI1 = 1.0/3.0*(PI/4.0);
                            F_PHI = round(1.115*sin(0.5236*double(J-57)+3.927)+0.2989*sin(3.665*double(J-57)-7.069));
                            PHI1 = PHI + F_PHI*DPHI1;
                            R1 = AG*sin(THETA2);
                            XHET(H) = R1*cos(PHI1)+Xm0;
                            YHET(H) = R1*sin(PHI1)+Ym0;
                            ZHET(H) = AG*cos(THETA2)+Zm0;
                            RHET(H) = RHET2;
                            THETAT(H) = THETA2;
                            PHIT(H) = PHI1;
                        elseif and(J>=66,J<=73)
                            DTHETA2 = 1.0/3.0*DTHETA1;
                            F_THETA1 = round(1.155*sin(2.094*double(J-65)+3.142));
                            THETA2 = THETA1 + F_THETA1*DTHETA2;  
                            PHI = double(9-2)*PI/4.0;
                            DPHI1 = 1.0/3.0*(PI/4.0);
                            F_PHI = round(1.115*sin(0.5236*double(J-65)+3.927)+0.2989*sin(3.665*double(J-65)-7.069));
                            PHI1 = PHI + F_PHI*DPHI1;
                            R1 = AG*sin(THETA2);
                            XHET(H) = R1*cos(PHI1)+Xm0;
                            YHET(H) = R1*sin(PHI1)+Ym0;
                            ZHET(H) = AG*cos(THETA2)+Zm0;
                            RHET(H) = RHET2;
                            THETAT(H) = THETA2;
                            PHIT(H) = PHI1;
                        end
                    end
                end                      
            end
        else % NOT AT POLES
            %THETA ANGLE
            THETA = (NTHETA-1)*DTHETA; 
            %CALCULATE RING RADIUS
            RRING = AG*sin(THETA);
            %CALCULATE NUMBER OF HETERODOMAINS IN RING
            NHETRING = round(2.0*PI*RRING/ARCL);
            if (NHETRING<3)  
                NHETRING = 3;
            end
            NHRINGREAL = NHETRING;
            %RECALCULATE STEP IN PHI BASED ON NHETRING
            DPHI = 2.0*PI/NHRINGREAL;
            %CALCULATE OFFSET AS 10% OF THE STEP IN PHI IF RING IS ODD OR EVEN
            M = rem(NTHETA,2);
            if (M==0)  
                PHIOFF = 0.1*DPHI; 
            else
                PHIOFF = -0.1*DPHI; 
            end
            %%M_PHI CONTAINS VALUES OF NPHI THAT WILL YIELD PHI ANGLE DOMAIN
            NPHI = round((PHIP-PHIOFF)/DPHI);
            if (NTHETA==2)
                M_NPHI = [1:NHETRING];
            else
                if (NPHI==0)
                    M_NPHI = [NPHI (NPHI+1) (NHETRING-1)];
                else
                    M_NPHI = [NPHI (NPHI+1) (NPHI-1)];
                end
            end
            %LOOP THROUGH PHI DOMAIN
            for M=1:length(M_NPHI)
                %CALCULATE PHI ANGLE BASED ON COLLOID PHI ANGLE
                PHI = M_NPHI(M)*DPHI+PHIOFF;
                for J=1:HETMODE
                    H = H + 1;
                    if (J==1) %GENERATE LARGE HETERODOMAIN
                        XHET(H) = RRING*cos(PHI)+Xm0;
                        YHET(H) = RRING*sin(PHI)+Ym0;
                        ZHET(H) = AG*cos(THETA)+Zm0; 
                        RHET(H) = RHET0;
                        THETAT(H) = THETA;
                        PHIT(H) = PHI;
                    else %GENERATE MEDIUM AND SMALL HETDOMAINS AROUND LARGE HETERODOMAIN
                        if (HETMODE==5) %1:4
                            DTHETA1 = 1.0/3.0*DTHETA;
                            DPHI1 = 1.0/3.0*DPHI;
                            if (J==2)   
                                PHI1 = PHI - DPHI1;
                                THETA1 = THETA + DTHETA1;
                            end
                            if (J==3)   
                                PHI1 = PHI + DPHI1;
                                THETA1 = THETA + DTHETA1; 
                            end
                            if (J==4)   
                                PHI1 = PHI + DPHI1;
                                THETA1 = THETA - DTHETA1; 
                            end
                            if (J==5)   
                                PHI1 = PHI - DPHI1;
                                THETA1 = THETA - DTHETA1;
                            end                                   
                            R1 = AG*sin(THETA1);   
                            XHET(H) = R1*cos(PHI1)+Xm0;
                            YHET(H) = R1*sin(PHI1)+Ym0;
                            ZHET(H) = AG*cos(THETA1)+Zm0;
                            RHET(H) = RHET1;
                            THETAT(H) = THETA1;
                            PHIT(H) = PHI1;
                        elseif (HETMODE==9) %1:8
                            DTHETA1 = 1.0/3.0*DTHETA;
                            F_THETA1 = round(1.155*sin(2.094*double(J-1)+3.142));
                            THETA1 = THETA + F_THETA1*DTHETA1;
                            DPHI1 = 1.0/3.0*DPHI;
                            F_PHI1 = round(1.115*sin(0.5236*double(J-1)+3.927)+0.2989*sin(3.665*double(J-1)-7.069));
                            PHI1 = PHI + F_PHI1*DPHI1;
                            R1 = AG*sin(THETA1);   
                            XHET(H) = R1*cos(PHI1)+Xm0;
                            YHET(H) = R1*sin(PHI1)+Ym0;
                            ZHET(H) = AG*cos(THETA1)+Zm0;
                            RHET(H) = RHET1;
                            THETAT(H) = THETA1;
                            PHIT(H) = PHI1;
                        elseif (HETMODE==73) %1:8:64
                            if and(J>=2,J<=9)
                                DTHETA1 = 1.0/3.0*DTHETA;
                                F_THETA1 = round(1.155*sin(2.094*double(J-1)+3.142));
                                THETA1 = THETA + F_THETA1*DTHETA1;
                                DPHI1 = 1.0/3.0*DPHI;
                                F_PHI1 = round(1.115*sin(0.5236*double(J-1)+3.927)+0.2989*sin(3.665*double(J-1)-7.069));
                                PHI1 = PHI + F_PHI1*DPHI1;
                                R1 = AG*sin(THETA1);   
                                XHET(H) = R1*cos(PHI1)+Xm0;
                                YHET(H) = R1*sin(PHI1)+Ym0;
                                ZHET(H) = AG*cos(THETA1)+Zm0;
                                RHET(H) = RHET1;
                                THETAT(H) = THETA1;
                                PHIT(H) = PHI1;    
                            elseif and(J>=10,J<=17)
                                DTHETA1 = 1.0/3.0*DTHETA;
                                F_THETA1 = round(1.155*sin(2.094*(1)+3.142));
                                THETA1 = THETA + F_THETA1*DTHETA1;
                                DTHETA2 = 1.0/3.0*DTHETA1;
                                F_THETA2 = round(1.155*sin(2.094*double(J-9)+3.142));
                                THETA2 = THETA1 + F_THETA2*DTHETA2;
                                DPHI1 = 1.0/3.0*DPHI;
                                F_PHI1 = round(1.115*sin(0.5236*(1)+3.927)+0.2989*sin(3.665*(1)-7.069));
                                PHI1 = PHI + F_PHI1*DPHI1;
                                DPHI2 = 1.0/3.0*DPHI1;
                                F_PHI2 = round(1.115*sin(0.5236*double(J-9)+3.927)+0.2989*sin(3.665*double(J-9)-7.069));
                                PHI2 = PHI1 + F_PHI2*DPHI2;
                                R1 = AG*sin(THETA2);   
                                XHET(H) = R1*cos(PHI2)+Xm0;
                                YHET(H) = R1*sin(PHI2)+Ym0;
                                ZHET(H) = AG*cos(THETA2)+Zm0;
                                RHET(H) = RHET2;
                                THETAT(H) = THETA2;
                                PHIT(H) = PHI2; 
                            elseif and(J>=18,J<=25)
                                DTHETA1 = 1.0/3.0*DTHETA;
                                F_THETA1 = round(1.155*sin(2.094*(2)+3.142));
                                THETA1 = THETA + F_THETA1*DTHETA1;
                                DTHETA2 = 1.0/3.0*DTHETA1;
                                F_THETA2 = round(1.155*sin(2.094*double(J-17)+3.142));
                                THETA2 = THETA1 + F_THETA2*DTHETA2;
                                DPHI1 = 1.0/3.0*DPHI;
                                F_PHI1 = round(1.115*sin(0.5236*(2)+3.927)+0.2989*sin(3.665*(2)-7.069));
                                PHI1 = PHI + F_PHI1*DPHI1;
                                DPHI2 = 1.0/3.0*DPHI1;
                                F_PHI2 = round(1.115*sin(0.5236*double(J-17)+3.927)+0.2989*sin(3.665*double(J-17)-7.069));
                                PHI2 = PHI1 + F_PHI2*DPHI2;
                                R1 = AG*sin(THETA2);   
                                XHET(H) = R1*cos(PHI2)+Xm0;
                                YHET(H) = R1*sin(PHI2)+Ym0;
                                ZHET(H) = AG*cos(THETA2)+Zm0;
                                RHET(H) = RHET2;
                                THETAT(H) = THETA2;
                                PHIT(H) = PHI2;
                            elseif and(J>=26,J<=33)
                                DTHETA1 = 1.0/3.0*DTHETA;
                                F_THETA1 = round(1.155*sin(2.094*(3)+3.142));
                                THETA1 = THETA + F_THETA1*DTHETA1;
                                DTHETA2 = 1.0/3.0*DTHETA1;
                                F_THETA2 = round(1.155*sin(2.094*double(J-25)+3.142));
                                THETA2 = THETA1 + F_THETA2*DTHETA2;
                                DPHI1 = 1.0/3.0*DPHI;
                                F_PHI1 = round(1.115*sin(0.5236*(3)+3.927)+0.2989*sin(3.665*(3)-7.069));
                                PHI1 = PHI + F_PHI1*DPHI1;
                                DPHI2 = 1.0/3.0*DPHI1;
                                F_PHI2 = round(1.115*sin(0.5236*double(J-25)+3.927)+0.2989*sin(3.665*double(J-25)-7.069));
                                PHI2 = PHI1 + F_PHI2*DPHI2;
                                R1 = AG*sin(THETA2);   
                                XHET(H) = R1*cos(PHI2)+Xm0;
                                YHET(H) = R1*sin(PHI2)+Ym0;
                                ZHET(H) = AG*cos(THETA2)+Zm0;
                                RHET(H) = RHET2;
                                THETAT(H) = THETA2;
                                PHIT(H) = PHI2;
                            elseif and(J>=34,J<=41)
                                DTHETA1 = 1.0/3.0*DTHETA;
                                F_THETA1 = round(1.155*sin(2.094*(4)+3.142));
                                THETA1 = THETA + F_THETA1*DTHETA1;
                                DTHETA2 = 1.0/3.0*DTHETA1;
                                F_THETA2 = round(1.155*sin(2.094*double(J-33)+3.142));
                                THETA2 = THETA1 + F_THETA2*DTHETA2;
                                DPHI1 = 1.0/3.0*DPHI;
                                F_PHI1 = round(1.115*sin(0.5236*(4)+3.927)+0.2989*sin(3.665*(4)-7.069));
                                PHI1 = PHI + F_PHI1*DPHI1;
                                DPHI2 = 1.0/3.0*DPHI1;
                                F_PHI2 = round(1.115*sin(0.5236*double(J-33)+3.927)+0.2989*sin(3.665*double(J-33)-7.069));
                                PHI2 = PHI1 + F_PHI2*DPHI2;
                                R1 = AG*sin(THETA2);   
                                XHET(H) = R1*cos(PHI2)+Xm0;
                                YHET(H) = R1*sin(PHI2)+Ym0;
                                ZHET(H) = AG*cos(THETA2)+Zm0;
                                RHET(H) = RHET2;
                                THETAT(H) = THETA2;
                                PHIT(H) = PHI2;
                            elseif and(J>=42,J<=49)
                                DTHETA1 = 1.0/3.0*DTHETA;
                                F_THETA1 = round(1.155*sin(2.094*(5)+3.142));
                                THETA1 = THETA + F_THETA1*DTHETA1;
                                DTHETA2 = 1.0/3.0*DTHETA1;
                                F_THETA2 = round(1.155*sin(2.094*double(J-41)+3.142));
                                THETA2 = THETA1 + F_THETA2*DTHETA2;
                                DPHI1 = 1.0/3.0*DPHI;
                                F_PHI1 = round(1.115*sin(0.5236*(5)+3.927)+0.2989*sin(3.665*(5)-7.069));
                                PHI1 = PHI + F_PHI1*DPHI1;
                                DPHI2 = 1.0/3.0*DPHI1;
                                F_PHI2 = round(1.115*sin(0.5236*double(J-41)+3.927)+0.2989*sin(3.665*double(J-41)-7.069));
                                PHI2 = PHI1 + F_PHI2*DPHI2;
                                R1 = AG*sin(THETA2);   
                                XHET(H) = R1*cos(PHI2)+Xm0;
                                YHET(H) = R1*sin(PHI2)+Ym0;
                                ZHET(H) = AG*cos(THETA2)+Zm0;
                                RHET(H) = RHET2;
                                THETAT(H) = THETA2;
                                PHIT(H) = PHI2;
                            elseif and(J>=50,J<=57)
                                DTHETA1 = 1.0/3.0*DTHETA;
                                F_THETA1 = round(1.155*sin(2.094*(6)+3.142));
                                THETA1 = THETA + F_THETA1*DTHETA1;
                                DTHETA2 = 1.0/3.0*DTHETA1;
                                F_THETA2 = round(1.155*sin(2.094*double(J-49)+3.142));
                                THETA2 = THETA1 + F_THETA2*DTHETA2;
                                DPHI1 = 1.0/3.0*DPHI;
                                F_PHI1 = round(1.115*sin(0.5236*(6)+3.927)+0.2989*sin(3.665*(6)-7.069));
                                PHI1 = PHI + F_PHI1*DPHI1;
                                DPHI2 = 1.0/3.0*DPHI1;
                                F_PHI2 = round(1.115*sin(0.5236*double(J-49)+3.927)+0.2989*sin(3.665*double(J-49)-7.069));
                                PHI2 = PHI1 + F_PHI2*DPHI2;
                                R1 = AG*sin(THETA2);   
                                XHET(H) = R1*cos(PHI2)+Xm0;
                                YHET(H) = R1*sin(PHI2)+Ym0;
                                ZHET(H) = AG*cos(THETA2)+Zm0;
                                RHET(H) = RHET2;
                                THETAT(H) = THETA2;
                                PHIT(H) = PHI2;
                            elseif and(J>=58,J<=65)
                                DTHETA1 = 1.0/3.0*DTHETA;
                                F_THETA1 = round(1.155*sin(2.094*(7)+3.142));
                                THETA1 = THETA + F_THETA1*DTHETA1;
                                DTHETA2 = 1.0/3.0*DTHETA1;
                                F_THETA2 = round(1.155*sin(2.094*double(J-57)+3.142));
                                THETA2 = THETA1 + F_THETA2*DTHETA2;
                                DPHI1 = 1.0/3.0*DPHI;
                                F_PHI1 = round(1.115*sin(0.5236*(7)+3.927)+0.2989*sin(3.665*(7)-7.069));
                                PHI1 = PHI + F_PHI1*DPHI1;
                                DPHI2 = 1.0/3.0*DPHI1;
                                F_PHI2 = round(1.115*sin(0.5236*double(J-57)+3.927)+0.2989*sin(3.665*double(J-57)-7.069));
                                PHI2 = PHI1 + F_PHI2*DPHI2;
                                R1 = AG*sin(THETA2);   
                                XHET(H) = R1*cos(PHI2)+Xm0;
                                YHET(H) = R1*sin(PHI2)+Ym0;
                                ZHET(H) = AG*cos(THETA2)+Zm0;
                                RHET(H) = RHET2;
                                THETAT(H) = THETA2;
                                PHIT(H) = PHI2;
                            elseif and(J>=66,J<=73)
                                DTHETA1 = 1.0/3.0*DTHETA;
                                F_THETA1 = round(1.155*sin(2.094*(8)+3.142));
                                THETA1 = THETA + F_THETA1*DTHETA1;
                                DTHETA2 = 1.0/3.0*DTHETA1;
                                F_THETA2 = round(1.155*sin(2.094*double(J-65)+3.142));
                                THETA2 = THETA1 + F_THETA2*DTHETA2;
                                DPHI1 = 1.0/3.0*DPHI;
                                F_PHI1 = round(1.115*sin(0.5236*(8)+3.927)+0.2989*sin(3.665*(8)-7.069));
                                PHI1 = PHI + F_PHI1*DPHI1;
                                DPHI2 = 1.0/3.0*DPHI1;
                                F_PHI2 = round(1.115*sin(0.5236*double(J-65)+3.927)+0.2989*sin(3.665*double(J-65)-7.069));
                                PHI2 = PHI1 + F_PHI2*DPHI2;
                                R1 = AG*sin(THETA2);   
                                XHET(H) = R1*cos(PHI2)+Xm0;
                                YHET(H) = R1*sin(PHI2)+Ym0;
                                ZHET(H) = AG*cos(THETA2)+Zm0;
                                RHET(H) = RHET2;
                                THETAT(H) = THETA2;
                                PHIT(H) = PHI2;
                            end
                        end
                    end                      
                end
            end
        end
    end     
end
end