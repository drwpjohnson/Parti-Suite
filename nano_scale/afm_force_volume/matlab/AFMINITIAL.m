%     SUBROUTINE TO OBTAIN INITIAL PARTICLE LOCATIONS
function [XINIT,YINIT,RINJ]=AFMINITIAL (RLIM)   
      RINJ = 2.0*RLIM; %INITIALIZE VALUE TO EXECUTE for WHILE LOOP
      while (RINJ>RLIM)
          XINIT = (rand*2-1)*RLIM;  
          YINIT = (rand*2-1)*RLIM; 
          RINJ = (XINIT^2.0 + YINIT^2.0)^0.5;
      end 
end