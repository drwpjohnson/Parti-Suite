%% zoom in FUNCTIONS
%%  generate a spherical segment around Equator of colloid sphere centered in origin
% colloid projection on collector
function [xcap,ycap,zcap]=AFMsphere_capEQ(ap,angasp,angzoi,fzoi,RZOIBULK)
global ASPcolloid
% INPUT
% ap colloid radius
% angasp: angle that describes 2*asp_colloid projected as arc on colloid surface
% angzoi: angle that describes 2*RZOIBULK projected as arc on colloid surface

% RZOIBULK non-deformed zone of interaction

% accounting only inside zoi
%OUTPUTS
% xcapEQEQ,ycapEQEQ,zcapEQEQ: 
% theta angle with Z+
% phi angle with X+
% nang resolution angular grid points for sphere cap array
% find sphere cap center
% inrease ZOI projection on colloid by 20% to accomodate nearby asperities
% angzoi_num =2*angzoi;
% 
%
x=0;
y=-ap;
z =0;
r = (x*x+y*y+z*z)^0.5;
if r>eps
    unitx = x/r;
    unity = y/r;
else
    unitx = 0.0;
    unity = 0.0;

end
unitz = z/r;

xs = unitx*ap;
ys = unity*ap;
zs = 0.0;
% find cap center point angles relative to sphere
thetap = acos(zs/ap);
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
% double the domain initial limits (based on ZOI)
% the actual asperities will be discriminated below
angzoi = 2*angzoi;
% calculate limti angle to generate array of asperities.
numasp = ceil(angzoi/angasp);
% becasue mesh generation needs integer steps, alim is recalculated
% from nasp to accomodate whole asperities
if numasp<=3
    alim = angasp;
    numasp = 3;
else
    alim = (numasp-1)*angasp/2;
end
theta = linspace(-alim+thetap,alim+thetap,numasp);
phi = linspace(-alim+phip,alim+phip,numasp);
% set angle limit as a function of an arc the same lenght as ap
n=length(theta); % define length of array
% prealocate x,y,z, array
xcapEQ=NaN(n); ycapEQ=xcapEQ; zcapEQ=xcapEQ;
thetapap = xcapEQ;
for i=1:n
    for j=1:n
        % locate point in z (theta from Z+)
        zcapEQ(i,j)=cos(theta(i))*ap;
        rxycapEQ = (ap*ap-zcapEQ(i,j)*zcapEQ(i,j))^0.5;
        % locate point in x y (phi from X+)
        xcapEQ(i,j)=cos(phi(j))*rxycapEQ;
        ycapEQ(i,j)=sin(phi(j))*rxycapEQ;
        thetapap(i,j)=theta(i);
    end
end
% discriminate
xcap = xcapEQ;
ycap = ycapEQ;
zcap = zcapEQ;


% transforms sphere cap matrix to vector
xcap = xcap(:);
ycap = ycap(:);
zcap = zcap(:);

% discriminate locations inside fzoi*RZOIBULK
rxzcap = ((xcap).^2+(zcap).^2).^0.5;
% obtain logic vector
c = rxzcap<=fzoi*RZOIBULK+ASPcolloid;
% extract asperities locations inside ZOI
xcap = xcap(c);
ycap = ycap(c);
zcap = zcap(c);

% %
end








