function dlong=disperse(vmagn,dt,dispersivity)
%   Generate the needed random numbers and reset the seed
    rnum1 = 10; % intialize random as not valid number
    while rnum1>2||rnum1<-2 %use only +-2 std from normal distribution
        rnum1=randn; % generate normal distribution random number
    end
%   calculate dispersion associated particle displacement
	dlong = rnum1*(2*dispersivity*vmagn*dt)^0.5;
end