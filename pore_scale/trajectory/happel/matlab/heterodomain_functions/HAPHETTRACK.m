function [XHET,YHET,ZHET,RHET]=HAPHETTRACK(X,Y,ZCONT,Xm0,Ym0,Zm0,AG,...
                              HETMODE,SCOV,RHET0,RHET1)
%       DIMENSION XHET(10),YHET(10),ZHET(10),RHET(10)
%       DOUBLE PRECISION X,Y,ZCONT,Z,Xm0,Ym0,Zm0,XHET,YHET,ZHET
%       DOUBLE PRECISION XP,YP,ZP,NHETREAL
%       DOUBLE PRECISION RO,R1,AG,RZOI,SCOV,SCOV1,RHET0,RHET1,RHET
%       DOUBLE PRECISION RRING,ROXY
%       DOUBLE PRECISION THETA,THETAP,THETAPABS,THETA1
%       DOUBLE PRECISION DTHETA,DPHI,ARCL
%       DOUBLE PRECISION PHI,PHIP,PHI1
%       DOUBLE PRECISION AFRACT,AF
%       DOUBLE PRECISION PI
%       INTEGER NHET,HETMODE,NRING,NHETRING,NTHETA,NPHI,N,M,J
      PI=3.14159265359;
      Z = ZCONT; %TOPS OF ASPERITIES DEFINE NEW CONTACT SURFACE
%     EQUIVALENT SURFACE COVERAGE CORRESPONDING TO UNIFORM HETERODOMAINS IS USED IN CALCULATION, EQUALS HALF OF BIMODAL SURFACE COVERAGE
      if (HETMODE==1)  
        SCOV1 = SCOV;
      elseif(HETMODE==5)   %FOR BIMODAL MODEL SCOV IS BASED ON BIG HETERODOMAINS, MUST DIVIDE SCOV BY 2
        SCOV1 = SCOV/2.0;
      end
%
%     CALCULATE APPROXIMATE NUMBER OF HETERODOMAINS REQUIRED
%     ACTUAL SURFACE COVERAGE HAS TO BE CALCULATED IN HETSAMEARC
%     AFTER ALL HETERODOMAINS ARE EXPLICITLY GENERATED
%     APPROXIMATION IS GOOD TO WITHIN 5% OR BETTER
      NHET = round(SCOV1*(4.0*AG^2.0)/(RHET0^2.0));
%     CALCULATE NUMBER OF RINGS THAT YIELD NHET ASSUMING EVEN SPACING 
      NHETREAL = NHET;
%     THE DENOMINATOR 1/1.2 WAS CALIBRATED TO YIELD EVEN SPACING DISTRIBUTION OF HETDOMAINS MATCING SCOV
      NRING = round((NHETREAL/1.2)^0.5);
%     CALCULATE STEP IN THETA AND ASSOCIATED ARCLENGTH
      DTHETA =  PI/(NRING-1);
      ARCL = DTHETA*AG;
%     CALCULATE RADIAL DISTANCE AND SEPARATION DISTANCE
      RO = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0)+(Z-Zm0)*(Z-Zm0))^0.5;
%     CALCULATE ELEVATION ANGLE
      THETAP = asin((Z-Zm0)/RO);
%     CALCULATE PROJECTION OF COLLOID POSITION ON XY PLANE
      ROXY = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0))^0.5;
      if (ROXY==0.0)  
        PHIP = 0.0;
      else
        if ((Y-Ym0)>=0.0)  
            PHIP = acos((X-Xm0)/ROXY);
        else
            PHIP = 2.0*PI-acos((X-Xm0)/ROXY);
        end
      end

%     FIND CLOSEST RING TO PARTICLE PROJECTION
%     SINCE THE RING NUMBER 1 IS AT THETAP= PI/2 AND MAX AND NRING IS AT -PI/2
      if(THETAP>=0)   
        THETAPABS = PI/2-THETAP;
      else
        THETAPABS = PI/2+abs(THETAP); %% CHECK SIMMETRY CONDITION THETA DOMAIN FROM 0 TO PI (0 at the z+ pole, pi at Z- pole
      end
%     NTHETA IS CLOSEST RING
%      NTHETA = round(THETAPABS/DTHETA); %old error check FORTRAN
      NTHETA = round(THETAPABS/DTHETA)+1; %fixed
      %% RECOGNIZE HETERODOMAINS AT POLES
      if or(NTHETA==1,NTHETA==NRING)   % %% fix condition to ntheta ==1
        PHI = 0.0;
        RRING = 0.0;
        if (NTHETA==1)   %% fix condition to ntheta ==1
            THETA = PI/2.0;
        else
            THETA = -PI/2.0;
        end
%       FIND CLOSEST SMALL HETERODOMAINS OFFSET FROM LARGE HETERODOMAIN AT POLES
        for J=1:HETMODE
            if (J==1)   
%               RECOGNIZE LARGE HETERODOMAIN AT POLES
                XHET(J) = RRING*cos(PHI)+Xm0;
                YHET(J) = RRING*sin(PHI)+Ym0;
                ZHET(J) = AG*sin(THETA)+Zm0; 
                RHET(J) = RHET0;
            else 
%               RECOGNIZE SMALL HETERODOMAINS OFFSET FROM LARGE HETERODOMAIN AT POLES 
                THETA1 = THETA + (1.0/3.0*DTHETA);  
                PHI = double(J-2)*PI/2.0;
                R1 = AG*cos(THETA1);
                XHET(J) = R1*cos(PHI)+Xm0;
                YHET(J) = R1*sin(PHI)+Ym0;
                ZHET(J) = AG*sin(THETA1)+Zm0;
                RHET(J) = RHET1;
            end                      
        end
      else
          %% NOT AT POLES
%         THETA = PI/2.0-NTHETA*DTHETA; %% check potential error in FORTRAN
         THETA = PI/2.0-(NTHETA-1)*DTHETA; % fixed!!
%       CALCULATE RING RADIUS
        RRING = AG*cos(THETA);
%         CALCULATE AZIMUTH ANGLE STEP 1(CHANGES FOR EACH RING)
          NHETRING = round(2.0*PI*RRING/ARCL);%use round instead of floor, rare numerical discrepancies occur with HAPHETTRACK
          if (NHETRING<3)  
            NHETRING = 3;
          end
%       RECALCULATE STEP IN PHI BASED ON NHETRING
        DPHI = 2.0*PI/NHETRING;
%       CALCULATE OFFSET AS 10% OF THE STEP IN PHI if RING IS ODD OR EVEN
%       GENERATE SMALLER HETERODOMAINS AROUND LARGE HETERODOMAIN AT POLES 
%         if (THETA>=0.0)  
%             %N = round((PI/2.0-THETA)/DTHETA);%% check potential error in FORTRAN
%             N = round((PI/2.0-THETA)/DTHETA)+1;
%             %THETA1 = THETA - (1.0/3.0*DTHETA); %no need of this line
%         else
%             %N = round((PI+THETA)/DTHETA);%% check potential error in FORTRAN
%             N = round((PI+THETA)/DTHETA)+1;
%             %THETA1 = THETA + (1.0/3.0*DTHETA);  %no need of this line
%         end  
            N = round((PI/2.0-THETA)/DTHETA)+1; %% fixed N correspond to ring number
            M = rem(N,2);
        if (M==0)  
            PHIOFF = 0.1*DPHI; 
        else
            PHIOFF = -0.1*DPHI; 
        end
%       CALCULATE THE AZIMUTH ANGLE TAKING IN ACCOUNT THE OFFSET OF THE HETDOMINS IN EACH RING
%         PHI = DPHI*round((PHIP-PHIOFF)/DPHI)+PHIOFF; %% check potential error in FORTRAN
        PHI = PHIOFF+DPHI*(round(PHIP/DPHI+PHIOFF));
%       RECOGNIZE HETERODOMAINS NOT AT POLES
        for J=1:HETMODE
            if (J==1)   
%               RECOGNIZE LARGE HETERODOMAIN NOT AT POLES
                XHET(J) = RRING*cos(PHI)+Xm0;
                YHET(J) = RRING*sin(PHI)+Ym0;
                ZHET(J) = AG*sin(THETA)+Zm0; 
                RHET(J) = RHET0;
            else %RECOGNIZE SMALL HETERODOMAINS OFFSET FROM LARGE HETERODOMAINS
                if (J==2)   
                    PHI1 = PHI - (1.0/3.0*DPHI);
                    THETA1 = THETA + (1.0/3.0*DTHETA);
                end
                if (J==3)   
                    PHI1 = PHI + (1.0/3.0*DPHI);
                    THETA1 = THETA + (1.0/3.0*DTHETA); 
                end
                if (J==4)   
                    PHI1 = PHI + (1.0/3.0*DPHI);
                    THETA1 = THETA - (1.0/3.0*DTHETA); 
                end
                if (J==5)   
                    PHI1 = PHI - (1.0/3.0*DPHI);
                    THETA1 = THETA - (1.0/3.0*DTHETA); 
                end                                   
                R1 = AG*cos(THETA1);   
                XHET(J) = R1*cos(PHI1);
                YHET(J) = R1*sin(PHI1);
                ZHET(J) = AG*sin(THETA1);
                RHET (J) = RHET1;
            end                      
       end
      end
end