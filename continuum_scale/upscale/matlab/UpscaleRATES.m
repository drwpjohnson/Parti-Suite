function [kf,kf2,kns,kf2star]=UpscaleRATES(ag,alpha1,alpha2,alphaRFSP,alphaREENT,alphaTransgg,alphaTransbg,eta,por,vns,vpor,vkns)
% % input average pore water velocity (m/hr)
% vpor = 0.1667;
%% calculate rate constants
% calculate number of collector per unit length (Nc/L)
NcL=3/2*(1-por)^(1/3)/(2*ag);
%% calculate kf (1/hr)v2
kf = -(NcL*vpor)*log(1-eta);
%%  calculate kf2 (1/hr)
kf2 = -(NcL*vns)*log(1-eta*(alpha2+alphaRFSP*alphaTransgg+alphaREENT*alphaTransbg));
%%  calculate kns (1/hr)
kns = -(NcL*vkns)*log(1-eta*(alpha2+alphaRFSP*alphaTransgg+alphaREENT*alphaTransbg));
%%  calculate kf2star (1/hr)
kf2star=-log(1-alpha2)*vns/pi/ag;
end