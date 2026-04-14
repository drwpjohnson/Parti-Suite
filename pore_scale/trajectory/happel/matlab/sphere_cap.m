%% zoom in FUNCTIONS
%%  generate a spherical segment around
% colloid projection on collector
function [xcap,ycap,zcap,xs,ys,zs,thetap,phip,rxys,unitx,unity,unitz]=sphere_cap(x,y,z,ap,ac,fsurf,numasp,res)
% INPUT
% x,y,z, colloid position
% ap colloid radius
% ac collector radius
% fsurf:  factor that defines size of sphere cap (as an arc length as multiple of ap)
% nang: resolution angular grid points for sphere cap array (integer)
% rhet: heterodomain radius
% asp: asperity height(or radius?)
%OUTPUTS
% factor of sphere cap (as amultiple of the arc of length ap)
% theta angle with Z+
% phi angle with X+
% nang resolution angular grid points for sphere cap array
% find sphere cap center
r = (x*x+y*y+z*z)^0.5;
unitx = x/r;  unity = y/r;  unitz = z/r; 
xs = unitx*ac;
ys = unity*ac;
zs = 0.0;
% find cap center point angles relative to sphere
thetap = acos(zs/ac);
rxys = (xs*xs+ys*ys)^0.5; 
if rxys>=eps
    if ys>=0.0
        phip = acos(xs/rxys);
    else
        if xs>=0.0
            phip = asin(ys/rxys);
        else
            phip = pi-asin(ys/rxys);
        end
    end
else
    phip = 0.0;
end
%% loop angles to generate cap
% set angle limit as a function of an arc the same lenght as ap
%     numasp = 100;
%     fsurf = numasp*res/ap;
if ap>ac
    % this case is oriented when the sphere cap is generated on the colloid
    % the nominal ap and ac arguments are swap to have the function acomplish
    % the case. The angle limit is calculated to represent the same arc length
    % on the collector and on the colloid
    alim = fsurf*ac/ap/2;
    grainarc =alim*ap; 
    alim = grainarc/ac;
else
    alim = fsurf*ap/ac/2;
end
% create linearly spaced vectors takin in account an extra step (numasp+1)
% becasue of limits of linear space
theta = linspace(-alim+thetap,alim+thetap,numasp+1);
phi = linspace(-alim+phip,alim+phip,numasp+1);
n=length(theta); % define length of array
% prealocate x,y,z, array
xcap=NaN(n); ycap=xcap; zcap=xcap;
thetacap = xcap;
for i=1:n
    for j=1:n
        % locate point in z (theta from Z+)
        zcap(i,j)=cos(theta(i))*ac;
        rxycap = (ac*ac-zcap(i,j)*zcap(i,j))^0.5;
        % locate point in x y (phi from X+)
        xcap(i,j)=cos(phi(j))*rxycap;
        ycap(i,j)=sin(phi(j))*rxycap; 
        thetacap(i,j)=theta(i);
    end
end
%% recreate projection on the surface (work in a single plane xy)
runitxy=((unitx*unitx)+(unity*unity))^0.5;
if runitxy<eps
    runitxy=eps;
end
xs2D = unitx/runitxy*ac;
ys2D = unity/runitxy*ac;
%% rotate cap using parallel big circles approach to maintain aspect ratio of cap in any position on the sphere
%calculate xy unit vector to center of cap
rxy = (xs2D*xs2D+ys2D*ys2D)^0.5;
if rxy<eps
    rxy=eps;
end
unitx2D = xs2D/rxy;
unity2D = ys2D/rxy;
% calculate thetapart: particle theta
thetapart = acos(z/(x*x+y*y+z*z)^0.5);
arot = -thetapart; % rotation angle relative to equator
% prealocate x,y,z, rotated array
xcapR=NaN(n); ycapR=xcapR; zcapR=xcapR;
for i=1:n
    for j=1:n
        % find latitude circle radius
        rlat = (xcap(i,j)*xcap(i,j)+ycap(i,j)*ycap(i,j))^0.5;
        % find cap element unit vector in xy plane
        uxcap = xcap(i,j)/rlat;
        uycap = ycap(i,j)/rlat;
        % obtain dot product with cap center vector (in xy) to determine 
        % parallel circle radius
        r1 = abs(unitx2D*uxcap+unity2D*uycap)*ac;
        % find new circle center
        xo1 = -unitx2D*r1+uxcap*ac;
        yo1 = -unity2D*r1+uycap*ac;
        % perform rotation in parallel circle relative to parallel circle center
        % new center of coordinates (auxiliar center, xau,yau,and unit
        % vectors are defined from this center
        xau = xcap(i,j)-xo1;
        yau = ycap(i,j)-yo1;
        rau = (xau*xau+yau*yau)^0.5;
        uxau = xau/rau;
        uyau = yau/rau;
        %
        totang = arot+thetacap(i,j);
        rxyAUX = +r1*cos(totang);
        % go back to original center of coordinates
        % offset by xo1 and yo1 values
        xcapR(i,j)=rxyAUX*uxau+xo1;
        ycapR(i,j)=rxyAUX*uyau+yo1;
        zcapR(i,j)=r1*sin(thetacap(i,j)+arot);
    end
end
% update x,y,z cap values with rotated values
xcap=xcapR; ycap=ycapR; zcap=zcapR;
% set zs value to actual lcoation of projection of colloid on sphere
if ap>ac
    zs = unitz*ap;
else
    zs = unitz*ac;    
end
% set thetap to actual angle of projection of colloid on sphere
thetap=thetapart;
%% represent asperities
% draw roughness only if its scale exceeds a factor of res TBD
% create a model roughness hemisphere
% [xr,yr,zr]= sphere;
% fr=2.0;
% xr=fr*xr*res; yr=fr*yr*res; zr=fr*zr*res;
% if asp>0.0
%     % introduce asperity heights 
%     for i=1:n
%         for j=1:n
%             if isnan(xcap(i,j)) 
%             else
%                 
%             end
%         end
%     end
% end
end
