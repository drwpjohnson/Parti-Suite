% SUBOROUTINE DIFFUSION FORCE -  use MATLAB randn
function [FDIFX,FDIFY,FDIFZ]=AFMFORCEDIFF(DIFFSCALE,PI,VISC,AP,KB,T,dT) 
      randm = 10*ones(1,3); % initialize random numbers to pass while condition below
    for i=1:3
        while randm(i)>2||randm(i)<-2 %use only +-2 std from normal distribution
            randm(i)=randn; % generat normal distribution random number
        end
    end     
%     KIM AND ZYDNEY (2004) INDICATE FORMULAS USED IN 2D systems applied TO Z AND R AND ARE ADDITIVE 
	FDIFZ = DIFFSCALE*(randm(1))*((12.0*PI*AP*VISC*KB*T/(dT))^0.5);
%     DIFFUSION APPLIED IN 3DIMENSIONS
	FDIFX = DIFFSCALE*(randm(2))*((12.0*PI*AP*VISC*KB*T/(dT))^0.5);
	FDIFY = DIFFSCALE*(randm(3))*((12.0*PI*AP*VISC*KB*T/(dT))^0.5);
end