% function to track asperities inside RZOIBULK on the collector
function [xasp,yasp,zasp]=AFM_asp_tracking(x,y,z,AG,fzoi,RZOIBULK,ASP_domain)
global concav
% INPUT:
% x,y,z colloid location
% AG collector radius (defines collector plane above origin at collector
% center)
% fzoi = factor to discriminate asperities proximal to zoi set to 1 for
% accounting only inside zoi
% RZOIBULK non-deformed zone of interaction
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
if concav==0
    dom=RZOIBULK;
else
    dom=ASP_domain;
end

% create array around closest node
xposr = xn_int*step:step:xn_int*step+2.0*dom;
xnegr =flip(xn_int*step:-step:xn_int*step-2.0*dom);
xrange = [xnegr(1:end-1) xposr];
%
zposr = zn_int*step:step:zn_int*step+2.0*dom;
znegr =flip(zn_int*step:-step:zn_int*step-2.0*dom);
zrange = [znegr(1:end-1) zposr];
% create local mesh using meshgrid
[xasp,zasp] = meshgrid(xrange,zrange);
% trasnform matrices to vectors
xasp=xasp(:);
zasp=zasp(:);
% discriminate locations inside ZOI
rxzasp = ((xasp-x).^2+(zasp-z).^2).^0.5;
% obtain logic vector
c = rxzasp<=fzoi*dom+ASP_domain;
% extract asperities locations inside ZOI
xasp = xasp(c);
zasp = zasp(c);
% obtain y value (planar)
yasp = ones(size(xasp))*AG;
end