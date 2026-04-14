% write circle on XZ plane at fixed Y
function[xcirc,ycirc,zcirc]=AFMcircleXZ(xo,yo,zo,ro,np)
    % np number of points in circle
%     ang = linspace(-2*pi,2*pi,np);
    ang = linspace(0.0,2*pi,np);
    xcirc = ro*cos(ang)+xo;
    zcirc = ro*sin(ang)+zo;
    ycirc = ones(1,np)*yo;
end