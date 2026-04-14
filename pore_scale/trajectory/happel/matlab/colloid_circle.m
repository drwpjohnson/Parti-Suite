%% zoom in FUNCTIONS
% function to generate cricle around colloid perimeteriuntercepting plane
% norma to polo connection colloid-collector center
function [xcirc,ycirc,zcirc,xzoi,yzoi,zzoi]=colloid_circle(x,y,z,ap,ac,rzoi)
% set system center
xo = 0.0;
yo = 0.0;
zo = 0.0;
% number of points to generate circle (randomly on perimeter)
np = 1000;
% obtain vector normalplane  (pole connecting collector with colloid
% center)
r = ((x-xo)^2+(y-yo)^2+(z-zo)^2)^0.5;
% obtain unit vectors
unitx = (x-xo)/r; unity = (y-yo)/r; unitz = (z-zo)/r;
% generate circle around colloid equator in normal plane (not part of mesh)
if abs(z)>0.2*ac
    % obtain random x,y coordinates
    xra=(0.5-rand(1,np))*2*ap+x; yra=(0.5-rand(1,np))*2*ap+y;
    zra = -unitx/unitz*(xra-x)-unity/unitz*(yra-y)+z;
else
    % obtain random x,z coordinates
    xra=(0.5-rand(1,np))*2*ap+x; zra=(0.5-rand(1,np))*2*ap+z;
    yra = -unitx/unity*(xra-x)-unitz/unity*(zra-z)+y;
    %
end
%scale to ap
rra = ((xra-x).^2+(yra-y).^2+(zra-z).^2).^0.5; 
% xuc, yuc and zuc, define points around a unit circle centerd in the origine,
% inside a planme normal to the pole connectig colloid and collector
xuc = (xra-x)./rra; yuc = (yra-y)./rra; zuc = (zra-z)./rra;
xcirc=xuc*ap+x;  ycirc=yuc*ap+y; zcirc=zuc*ap+z; 
% move to collector surface
xoff = unitx*ac;
yoff = unity*ac;
zoff = unitz*ac;
xzoi = xuc*rzoi + xoff;
yzoi = yuc*rzoi + yoff;
zzoi = zuc*rzoi + zoff;
end