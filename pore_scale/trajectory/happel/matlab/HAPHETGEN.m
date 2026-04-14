% HAPHETGEN - function to generate explicitly all hetdomains and plot if requested written by EP and CR
% function[XHET,YHET,ZHET,RHET]=HAPHETGEN(X,Y,Z,Xm0,Ym0,Zm0,AG,...
%                               HETMODE,SCOV,RHET0,RHET1)
function [XHETall,YHETall,ZHETall,genSCOV]=HAPHETGEN (Xm0,Ym0,Zm0,AG,SCOV,HETMODE,RHET0,RHET1,RHET2,nfig)
 close (figure(nfig))
%% inputs
% % collector center (m)
% Xm0,Ym0,Zm0,
% % collector diameter (m)
% AG
% % fraction hetdomains surface coverage
% SCOV
% % HETMODE (number of hetdomains pattern to repeat: 1 single, 5 for bimodal (1 large+ 4 smalls)
% % hetdomain radii(m)
% RHET0 %single size or large hetdomain
% RHET1 %small hetdomains (only used in HETMODE =5)
%% outputs
% maxnumber of hetdomains expected (to preallocate)
maxval = int32(1e6);
% all hetdomains locations and radii(m)
XHETall = NaN(1,maxval); YHETall = XHETall; 
ZHETall = XHETall; RHETall=XHETall;
%% parameters and constants
PI=3.14159265359; % to match FORTRAN version
%% correct scov if needed
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
%% CALCULATE THEORETICAL NUMBER OF HETERODOMAINS REQUIRED
% ACTUAL SURFACE COVERAGE calculted while generating complete surface
% from previous tests APPROXIMATION IS GOOD TO WITHIN 5% OR BETTER
% for the expression:
NHET0 = round(SCOV0*(4.0*AG^2.0)/(RHET0^2.0));
NHET1 = HM1*NHET0;
NHET2 = HM2*NHET0;
% CALCULATE NUMBER OF RINGS THAT YIELD NHET ASSUMING EVEN SPACING 
NHETREAL = NHET0;
% THE DENOMINATOR 1/1.3 WAS CALIBRATED TO YIELD EVEN SPACING DISTRIBUTION OF HETDOMAINS MATCING SCOV
NRING = round((NHETREAL/1.3)^0.5);
% SPHERICAL COORDINATES: RADIUS, THETA (POLAR ANGLE), PHI (AZIMUTHAL ANGLE)
% AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
% CALCULATE THETA ANGLE STEP AND CONSTANT ARC LENGTH
DTHETA =  PI/(NRING-1);
ARCL = DTHETA*AG;
%% display onlhy small top pole section if number of hetdomains (number of rings) is too large
% set maxnumber of rings
ringmax = 50;
% set camera zoom factor
czoom = 6;
if NRING>ringmax
    NRING1=ringmax;
else
    NRING1=NRING;
end
%% generate hetdomains
k=1; % start hetdomain all array counter
genhetarea = 0.0; %total hetdomain area (to evaluate generated vs requested)
if HETMODE==1
    Ahet = PI*RHET0^2.0;
else
    Ahet = PI*(RHET0^2.0+HM1*RHET1^2.0+HM2*RHET2^2.0);
end
% C     GENERATE HETERODOMAINS FROM 0 TO PI THETA DOMAIN (ANGLE MEASURED FROM POSITIVE Z-AXIS) 
for I=1:NRING1
    % calculate elevation angle of each ring
    THETA = (I-1)*DTHETA;
    % AT POLE
    if or(I==1,I==NRING) 
        % IN POLE NO RING AND ONLY ONE HETDOMAIN
        RRING = 0.0;
        NHETRING = 1;
        DTHETA1 = 1.0/3.0*DTHETA;
        DPHI = 0.0;
        % this if is not necessary, but kept to have consistency with
        % the FORTRAN version
        if (I==1)   
            THETA = 0.0;
        else
            THETA = PI;
        end
        % POPULATE HETDOMAINS AT POLE
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
                        F_THETA1 = round(1.155*sin(2.094*(J-9)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(2-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*(J-9)+3.927)+0.2989*sin(3.665*(J-9)-7.069));
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
                        F_THETA1 = round(1.155*sin(2.094*(J-17)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(3-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*(J-17)+3.927)+0.2989*sin(3.665*(J-17)-7.069));
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
                        F_THETA1 = round(1.155*sin(2.094*(J-25)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(4-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*(J-25)+3.927)+0.2989*sin(3.665*(J-25)-7.069));
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
                        F_THETA1 = round(1.155*sin(2.094*(J-33)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(5-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*(J-33)+3.927)+0.2989*sin(3.665*(J-33)-7.069));
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
                        F_THETA1 = round(1.155*sin(2.094*(J-41)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(6-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*(J-41)+3.927)+0.2989*sin(3.665*(J-41)-7.069));
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
                        F_THETA1 = round(1.155*sin(2.094*(J-49)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(7-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*(J-49)+3.927)+0.2989*sin(3.665*(J-49)-7.069));
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
                        F_THETA1 = round(1.155*sin(2.094*(J-57)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(8-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*(J-57)+3.927)+0.2989*sin(3.665*(J-57)-7.069));
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
                        F_THETA1 = round(1.155*sin(2.094*(J-65)+3.142));
                        THETA2 = THETA1 + F_THETA1*DTHETA2;  
                        PHI = double(9-2)*PI/4.0;
                        DPHI1 = 1.0/3.0*(PI/4.0);
                        F_PHI = round(1.115*sin(0.5236*(J-65)+3.927)+0.2989*sin(3.665*(J-65)-7.069));
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
        % save poles hetdomains local array to all array
        for J=1:HETMODE
            XHETall(k) = XHET(J);
            YHETall(k) = YHET(J);
            ZHETall(k) = ZHET(J);
            RHETall(k) = RHET(J);
            % count hetdomains
            k=k+1;
        end
        %integrate hetdomain area
        genhetarea = genhetarea+Ahet;
    else % NOT AT POLES
        %THETA ANGLE
        THETA = (I-1)*DTHETA;
        %CALCULATE RING RADIUS
        RRING = AG*sin(THETA);
        %CALCULATE NUMBER OF HETERODOMAINS IN RING
        NHETRING = round(2.0*PI*RRING/ARCL); %use round instead of floor, rare numerical discrepancies occur with HAPHETTRACK
        if NHETRING <3 % use 3 hetdomains at least in small rings
            NHETRING = 3;
        end
        DPHI = 2*PI/NHETRING;
        %CALCULATE OFFSET AS 10% OF THE STEP IN PHI IF RING IS ODD OR EVEN
        M = rem(I,2); % note MATLAB rem substitutes FOTRAN MOD, fixed I corresponds to ring number
        if (M==0)  
            PHIOFF = 0.1*DPHI; 
        else
            PHIOFF = -0.1*DPHI; 
        end
        % populate rings
        for L=1:NHETRING
            %CALCULATE OHI ANGLE
            PHI = (L-1)*DPHI+PHIOFF; 
            % GENERATE HETERODOMAINS NOT AT POLES
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
                        F_THETA1 = round(1.155*sin(2.094*(J-1)+3.142));
                        THETA1 = THETA + F_THETA1*DTHETA1;
                        DPHI1 = 1.0/3.0*DPHI;
                        F_PHI1 = round(1.115*sin(0.5236*(J-1)+3.927)+0.2989*sin(3.665*(J-1)-7.069));
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
                            F_THETA1 = round(1.155*sin(2.094*(J-1)+3.142));
                            THETA1 = THETA + F_THETA1*DTHETA1;
                            DPHI1 = 1.0/3.0*DPHI;
                            F_PHI1 = round(1.115*sin(0.5236*(J-1)+3.927)+0.2989*sin(3.665*(J-1)-7.069));
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
                            F_THETA2 = round(1.155*sin(2.094*(J-9)+3.142));
                            THETA2 = THETA1 + F_THETA2*DTHETA2;
                            DPHI1 = 1.0/3.0*DPHI;
                            F_PHI1 = round(1.115*sin(0.5236*(1)+3.927)+0.2989*sin(3.665*(1)-7.069));
                            PHI1 = PHI + F_PHI1*DPHI1;
                            DPHI2 = 1.0/3.0*DPHI1;
                            F_PHI2 = round(1.115*sin(0.5236*(J-9)+3.927)+0.2989*sin(3.665*(J-9)-7.069));
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
                            F_THETA2 = round(1.155*sin(2.094*(J-17)+3.142));
                            THETA2 = THETA1 + F_THETA2*DTHETA2;
                            DPHI1 = 1.0/3.0*DPHI;
                            F_PHI1 = round(1.115*sin(0.5236*(2)+3.927)+0.2989*sin(3.665*(2)-7.069));
                            PHI1 = PHI + F_PHI1*DPHI1;
                            DPHI2 = 1.0/3.0*DPHI1;
                            F_PHI2 = round(1.115*sin(0.5236*(J-17)+3.927)+0.2989*sin(3.665*(J-17)-7.069));
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
                            F_THETA2 = round(1.155*sin(2.094*(J-25)+3.142));
                            THETA2 = THETA1 + F_THETA2*DTHETA2;
                            DPHI1 = 1.0/3.0*DPHI;
                            F_PHI1 = round(1.115*sin(0.5236*(3)+3.927)+0.2989*sin(3.665*(3)-7.069));
                            PHI1 = PHI + F_PHI1*DPHI1;
                            DPHI2 = 1.0/3.0*DPHI1;
                            F_PHI2 = round(1.115*sin(0.5236*(J-25)+3.927)+0.2989*sin(3.665*(J-25)-7.069));
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
                            F_THETA2 = round(1.155*sin(2.094*(J-33)+3.142));
                            THETA2 = THETA1 + F_THETA2*DTHETA2;
                            DPHI1 = 1.0/3.0*DPHI;
                            F_PHI1 = round(1.115*sin(0.5236*(4)+3.927)+0.2989*sin(3.665*(4)-7.069));
                            PHI1 = PHI + F_PHI1*DPHI1;
                            DPHI2 = 1.0/3.0*DPHI1;
                            F_PHI2 = round(1.115*sin(0.5236*(J-33)+3.927)+0.2989*sin(3.665*(J-33)-7.069));
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
                            F_THETA2 = round(1.155*sin(2.094*(J-41)+3.142));
                            THETA2 = THETA1 + F_THETA2*DTHETA2;
                            DPHI1 = 1.0/3.0*DPHI;
                            F_PHI1 = round(1.115*sin(0.5236*(5)+3.927)+0.2989*sin(3.665*(5)-7.069));
                            PHI1 = PHI + F_PHI1*DPHI1;
                            DPHI2 = 1.0/3.0*DPHI1;
                            F_PHI2 = round(1.115*sin(0.5236*(J-41)+3.927)+0.2989*sin(3.665*(J-41)-7.069));
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
                            F_THETA2 = round(1.155*sin(2.094*(J-49)+3.142));
                            THETA2 = THETA1 + F_THETA2*DTHETA2;
                            DPHI1 = 1.0/3.0*DPHI;
                            F_PHI1 = round(1.115*sin(0.5236*(6)+3.927)+0.2989*sin(3.665*(6)-7.069));
                            PHI1 = PHI + F_PHI1*DPHI1;
                            DPHI2 = 1.0/3.0*DPHI1;
                            F_PHI2 = round(1.115*sin(0.5236*(J-49)+3.927)+0.2989*sin(3.665*(J-49)-7.069));
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
                            F_THETA2 = round(1.155*sin(2.094*(J-57)+3.142));
                            THETA2 = THETA1 + F_THETA2*DTHETA2;
                            DPHI1 = 1.0/3.0*DPHI;
                            F_PHI1 = round(1.115*sin(0.5236*(7)+3.927)+0.2989*sin(3.665*(7)-7.069));
                            PHI1 = PHI + F_PHI1*DPHI1;
                            DPHI2 = 1.0/3.0*DPHI1;
                            F_PHI2 = round(1.115*sin(0.5236*(J-57)+3.927)+0.2989*sin(3.665*(J-57)-7.069));
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
                            F_THETA2 = round(1.155*sin(2.094*(J-65)+3.142));
                            THETA2 = THETA1 + F_THETA2*DTHETA2;
                            DPHI1 = 1.0/3.0*DPHI;
                            F_PHI1 = round(1.115*sin(0.5236*(8)+3.927)+0.2989*sin(3.665*(8)-7.069));
                            PHI1 = PHI + F_PHI1*DPHI1;
                            DPHI2 = 1.0/3.0*DPHI1;
                            F_PHI2 = round(1.115*sin(0.5236*(J-65)+3.927)+0.2989*sin(3.665*(J-65)-7.069));
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
            % save ring hetdomains local array to all array
            for J=1:HETMODE
                XHETall(k) = XHET(J);
                YHETall(k) = YHET(J);
                ZHETall(k) = ZHET(J);
                RHETall(k) = RHET(J);
                % count hetdomains
                k=k+1;   
            end
            %integrate hetdomain area
            genhetarea = genhetarea+Ahet;
        end
    end
end
%% calculate actual scov
genSCOV = genhetarea/(4*PI*AG^2.0);
%% draw geometry if requested
if nfig>0
        %% draw collector sphere
        figure (nfig)
        [xe,ye,ze] = sphere;
        surf (xe*AG,ye*AG,ze*AG,'FaceColor',[211,211,211]/255,'EdgeAlpha',0.1)%,'FaceAlpha',0.5)
        xlabel ('X'); ylabel('Y'); zlabel('Z');
        axis ([-1.2*AG 1.2*AG -1.2*AG 1.2*AG -1.2*AG 1.2*AG]);axis square; grid on; hold on;
        %% draw hetdomains
        if HETMODE==1
            figure (nfig)
            plot3 (XHETall,YHETall,ZHETall,'o k','MarkerFaceColor','g','MarkerSize',6)
            axis square, hold on; grid on; 
        end
        if (HETMODE==5)||(HETMODE==9)||(HETMODE==73)
            % sort hetdomains
            cont = HETMODE; cb=1; cm =1; cs=1;
            for i=1:k-1
                if (HETMODE==5)||(HETMODE==9)
                    if cont==HETMODE
                        % extract large hetdomains
                        XHETbig(cb)=XHETall(i);
                        YHETbig(cb)=YHETall(i);
                        ZHETbig(cb)=ZHETall(i);
                        RHETbig(cb)=RHETall(i);
                        % count large hetdomains
                        cb=cb+1;
                        cont = 1;
                    else
                        % extract small hetdomains
                        XHETsmall(cs)=XHETall(i);
                        YHETsmall(cs)=YHETall(i);
                        ZHETsmall(cs)=ZHETall(i);
                        RHETsmall(cs)=RHETall(i);
                        % count large hetdomains
                        cs=cs+1;
                        cont = 1+cont;
                    end
                else
                    if cont==HETMODE
                        % extract large hetdomains
                        XHETbig(cb)=XHETall(i);
                        YHETbig(cb)=YHETall(i);
                        ZHETbig(cb)=ZHETall(i);
                        RHETbig(cb)=RHETall(i);
                        % count large hetdomains
                        cb=cb+1;
                        cont = 1;
                    elseif and(cont>=1,cont<=8)
                        % extract medium hetdomains
                        XHETmedium(cm)=XHETall(i);
                        YHETmedium(cm)=YHETall(i);
                        ZHETmedium(cm)=ZHETall(i);
                        RHETmedium(cm)=RHETall(i);
                        % count large hetdomains
                        cm=cm+1;
                        cont = 1+cont;
                    else
                        % extract small hetdomains
                        XHETsmall(cs)=XHETall(i);
                        YHETsmall(cs)=YHETall(i);
                        ZHETsmall(cs)=ZHETall(i);
                        RHETsmall(cs)=RHETall(i);
                        % count large hetdomains
                        cs=cs+1;
                        cont = 1+cont;
                    end
                end
            end
            figure (nfig)
            zoom reset
            camtarget ([0,0,AG]); camzoom(czoom)
            plot3 (XHETbig,YHETbig,ZHETbig,'o k','MarkerFaceColor','g','MarkerSize',6)
            axis square, hold on; grid on; 
            %view(45,45);
            figure (nfig)
            if (HETMODE==73)
                plot3 (XHETmedium,YHETmedium,ZHETmedium,'o k','MarkerFaceColor','g','MarkerSize',4)
                axis square, hold on; grid on; 
            end
            plot3 (XHETsmall,YHETsmall,ZHETsmall,'o k','MarkerFaceColor','g','MarkerSize',2)
            axis square, hold on; grid on; 

        % the option below works too but is slow   
        %     for i=1:k-1
        %     figure (nfig)
        %     plot3 (XHETall(i),YHETall(i),ZHETall(i),'o k','MarkerFaceColor','g','MarkerSize',5*RHETall(i)/RHET0)
        %     axis square; hold on; grid on; 
        %     end
        end
end
end % function HAPHETGEN










