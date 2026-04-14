%     SUBROUTINE HAPPEL REVISED REAL COORDINATES INPUT (revised Feb 2015) 
%     FLOW FIELD IS ALWAYS FROM MINUS Z TO PLUS Z
function [VxH1,VyH1,VzH1]= HAPPELFF (a,b,c,SLIP,K1,K2,K3,K4,AG)
% 
      cT = c+SLIP;                  %TANGENTIAL STREAMLINE FUNCTIONS QUED TO SLIP LENGTH
      RO = (a^2+b^2+c^2)^0.5;       %REAL UNITS
      RDIS = RO/AG;                 %DIMENSIONLESS
      RDISSLIP = (RO+SLIP)/AG;         %DIMENSIONLESS
      ROXY = (a^2+b^2)^0.5;         %REAL UNITS   
      FT = (-K1/(2.0*RDISSLIP^3.0)+K2/(2.0*RDISSLIP)...
      +K3+2.0*K4*RDISSLIP^2.0); 
      FN = K1/RDIS^3.0+K2/RDIS+K3+K4*RDIS^2.0; 
%     Obtain velocity components via differentiating streamline functions (REVISED DERIVATION)
%      velocity components are dimensionless	
      VxH1 = (a*c/RO^2)*(-FN+FT);
      VyH1 = (b*c/RO^2)*(-FN+FT);
	  VzH1 = ((c/RO)^2)*(-FN)+ ((ROXY/RO)^2.0)*(-FT);
%     NORMAL AND TANGENTIAL VELOCITIES
%     VN = Z/RO*FN
%     VT = ROXY/RO*FT        
end