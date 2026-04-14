%Energy Born_Sphere-Sphere(J)
function[deltaGBorn]=E_Born_SS(H,A132,sigmaC,a1)
deltaGBorn=abs(A132)*sigmaC^6/7560.*((6*a1-H)./H.^7+(8*a1+H)./(2*a1+H).^7);
end