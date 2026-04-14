function [cacont,Kint] = fcalcacont
global E1 v1 E2 v2 W132 a1 
Kint = 4/3/((1-v1^2)/E1+(1-v2^2)/E2);
cacont=(-6*pi*W132*a1^2/Kint)^(1/3);
end