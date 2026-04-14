% write circle on xy plane at fixed z
function[xcirc,ycirc,zcirc]=HAP_info_circle(xo,yo,zo,ro,np)
    % np number of points in circle
%     ang = linspace(-2*pi,2*pi,np);
    ang = linspace(0.0,2*pi,np);
    xcirc = ro*cos(ang)+xo;
    ycirc = ro*sin(ang)+yo;
    zcirc = ones(1,np)*zo;
end