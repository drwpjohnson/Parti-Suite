% function to track asperities in subset of ZOI on the collector near projected colloid asperity location  
function [xasp,yasp,zasp]=AFM_asp_tracking_RMODE3(x,y,z,AG,Rsubdomain,ASP_domain)
% INPUT:
% x,y,z colloid asperity location
% AG collector radius (defines collector plane above origin at collector
% center)
% Rsubdomain is the subset of ZOI on the collector near projected colloid asperity
% ASP_domain collector asperities radius
% 
%OUTPUT:
% xasp,yasp,zasp array of asperities centers
%
% grid step size
step = 2*ASP_domain;
% find closest  node of regular location of asperities to colloid
% projection
% determine integer number of steps in grid and fraction of steps
xn_int = fix(x/(step));
xn_fract = (x/(step))-xn_int;
zn_int = fix(z/(step));
zn_fract = (z/(step))-zn_int;
% update the integer depending of the fraction
if (xn_fract>0.5)&&(xn_fract>=0.0)
    xn_int=xn_int+1;
end
if (xn_fract<-0.5)&&(xn_fract<=0.0)
    xn_int=xn_int-1;
end
if (zn_fract>0.5)&&(zn_fract>=0.0)
    zn_int=zn_int+1;
end
if (zn_fract<-0.5)&&(zn_fract<=0.0)
    zn_int=zn_int-1;
end
% create array around closest node
xposr = xn_int*step:step:xn_int*step+Rsubdomain;
xnegr =flip(xn_int*step:-step:xn_int*step-Rsubdomain);
xrange = [xnegr(1:end-1) xposr];
%
zposr = zn_int*step:step:zn_int*step+Rsubdomain;
znegr =flip(zn_int*step:-step:zn_int*step-Rsubdomain);
zrange = [znegr(1:end-1) zposr];
% create local mesh using meshgrid
[xasp,zasp] = meshgrid(xrange,zrange);
% trasnform matrices to vectors
xasp=xasp(:);
zasp=zasp(:);
% obtain y value (planar)
yasp = ones(size(xasp))*AG;
end