% SUBROUTINE HETTRACK
%  function to find closest heterodomains to projection of center of the
%  colloid on collector surface
function [XHET,YHET,RHET] = JHETTRACK(X,Y,ZCONT,Xm0,Ym0,Zm0,RJET,...
                            HETMODE,SCOV,RHET0,RHET1)
%       DIMENSION XHET(10),YHET(10),RHET(10)
%       DOUBLE PRECISION X,Y,Z,ZCONT,Xm0,Ym0,Zm0,XHET,YHET
%       DOUBLE PRECISION XP,YP,NHETREAL
%       DOUBLE PRECISION RO,R1,RZOI,SCOV,SCOV1,RHET0,RHET1,RHET
%       DOUBLE PRECISION RRING,ROXY,RJET
%       DOUBLE PRECISION THETA,THETAP,THETAPABS,THETA1
%       DOUBLE PRECISION DTHETA,DPHI,ARCL
%       DOUBLE PRECISION PHI,PHIP,PHI1
%       DOUBLE PRECISION AFRACT,AF
%       DOUBLE PRECISION PI
%       INTEGER NHET,HETMODE,NRING,NHETRING,NTHETA,NPHI,N,M,J
      PI=3.14159265359;
      Z = ZCONT;
% C     EQUIVALENT SURFACE COVERAGE CORRESPONDING TO UNIFORM HETERODOMAINS IS USED IN CALCULATION, EQUALS HALF OF BIMODAL SURFACE COVERAGE
      if (HETMODE==1) 
          SCOV1 = SCOV;
      elseif (HETMODE==5)   %FOR BIMODAL MODEL SCOV IS BASED ON BIG HETERODOMAINS, MUST DIVIDE SCOV BY 2
          SCOV1 = SCOV*0.5;
      end
% C
% C     CALCULATE APPROXIMATE NUMBER OF HETERODOMAINS REQUIRED
% C     ACTUAL SURFACE COVERAGE HAS TO BE CALCULATED IN HETSAMEARC
% C     AFTER ALL HETERODOMAINS ARE EXPLICITLY GENERATED
% C     APPROXIMATION IS GOOD TO WITHIN 5% OR BETTER
      NHET = round(SCOV1*(RJET^2.0)/(RHET0^2.0));
% C     CALCULATE NUMBER OF RINGS THAT YIELD NHET ASSUMING EVEN SPACING 
      NHETREAL = NHET;
% C     THE DENOMINATOR 1/3.3 WAS CALIBRATED TO YIELD EVENLY SPACING DISTRIBUTION OF HETDOMAINS MATCHING SCOV
      NRING = round((NHETREAL/3.3)^0.5);
% C     CALCULATE STEP IN R (DTHETA) AND ASSOCIATED ARCLENGTH
      DTHETA =  RJET/(NRING-1);
      ARCL = DTHETA; 
% C     CALCULATE RADIAL DISTANCE OF COLLOID FROM AXIS
      ROXY = ((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0))^0.5;
      THETAP = ROXY; % THETAP IS COLLOID RADIAL DISTANCE FROM AXIS 
      if (ROXY==0.0)  
          PHIP = 0.0; %!PHIP IS COLLOID ANGLE WITH RESPECT TO X-AXIS IN RADIANS
      else
          if ((Y-Ym0)>=0.0)  
              PHIP = acos((X-Xm0)/ROXY);
          else
              PHIP = 2.0*PI-acos((X-Xm0)/ROXY);
          end
      end
% C     FIND CLOSEST RING TO PARTICLE PROJECTION
% C     SINCE THE RING NUMBER 1 IS CLOSEST TO AXIS  
      NTHETA = round(THETAP/DTHETA)+1;
% C     GENERATE HETERODOMAINS AT AXIS
      if (NTHETA==1)  
          PHI = 0.0;
          RRING = 0.0; 
          THETA = 0.0;
% C         IDENTIFY ARRAY OF HETERODOMAINS FOR SINGLE BIMODAL SET
          for J=1:HETMODE
              if (J==1)   
% C               GENERATE FIRST HETERODOMAIN
                  XHET(J) = RRING*cos(PHI)+Xm0;
                  YHET(J) = RRING*sin(PHI)+Ym0; 
                  RHET(J) = RHET0;
              else 
                  N = 2;
                  ODD = rem(J,N);
                  if (ODD>0)  
                      PHI = 0.0;
                      THETA1 = double(J-4)*(1.0/3.0*DTHETA);
                  else 
                      PHI = double(J-3)*(1.0/3.0*DTHETA);
                      THETA1 = 0.0;
                  end
                  XHET(J) = THETA1+Xm0;
                  YHET(J) = PHI+Ym0;
                  RHET(J) = RHET1;
              end                      
          end
      else %!(NTHETA.EQ.0) NOT AT POLES
          THETA = (NTHETA-1)*(DTHETA);
% C         CALCULATE RING RADIUS
          RRING = THETA;
% C         CALCULATE AZIMUTH ANGLE STEP 1(CHANGES FOR EACH RING)
          NHETRING = round(2.0*PI*RRING/ARCL);
          if (NHETRING<3)  
              NHETRING = 3;
          end
% C         RECALCULATE STEP IN PHI BASED ON NHETRING
          DPHI = 2.0*PI/NHETRING; %!ANGLE IN RADIANS BETWEEN HETERODOMAINS ON A RING
% C         CALCULATE OFFSET AS 10% OF THE STEP IN PHI if RING IS ODD OR EVEN
          M = rem(NTHETA,2);
          if (M==0)  
              PHIOFF = 0.1*DPHI; 
          else
              PHIOFF = -0.1*DPHI; 
          end
% C       CALCULATE THE AZIMUTH ANGLE TAKING IN ACCOUNT THE OFFSET OF THE HETDOMINS IN EACH RING
          PHI = PHIOFF+DPHI*(round(PHIP/DPHI+PHIOFF));
% C         GENERATE HETERODOMAINS NOT AT POLES
          for J=1:HETMODE
              if (J==1)  
% C               GENERATE FIRST HETERODOMAIN
                  XHET(J) = RRING*cos(PHI)+Xm0;
                  YHET(J) = RRING*sin(PHI)+Ym0;
                  RHET(J) = RHET0;
              else
                  if (J==2)  
                        PHI1 = PHI - (1.0/3.0*DPHI);
                        R1 = RRING + (1.0/3.0*DTHETA);
                  end
                  if (J==3)  
                       PHI1 = PHI + (1.0/3.0*DPHI);
                        R1 = RRING + (1.0/3.0*DTHETA); 
                  end
                  if (J==4)  
                        PHI1 = PHI + (1.0/3.0*DPHI);
                        R1 = RRING - (1.0/3.0*DTHETA); 
                  end
                  if (J==5)  
                        PHI1 = PHI - (1.0/3.0*DPHI);
                        R1 = RRING - (1.0/3.0*DTHETA); 
                  end
                      XHET(J) = R1*cos(PHI1);
                      YHET(J) = R1*sin(PHI1);
                      RHET (J) = RHET1;
              end                      
          end
      end
end
     