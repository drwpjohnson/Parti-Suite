function cA132 = fcalcA132
global ve e1 n1 e2 n2 e3 n3 T kb hp
s2 = 2^0.5;
cA132=(3/4)*kb*T*(e1-e3)/(e1+e3)*(e2-e3)/(e2+e3)+3*hp*ve/8/s2*...
    (n1^2-n3^2)*(n2^2-n3^2)/sqrt(n1^2+n3^2)/sqrt(n2^2+n3^2)/...
    (sqrt(n1^2+n3^2)+sqrt(n2^2+n3^2));
end