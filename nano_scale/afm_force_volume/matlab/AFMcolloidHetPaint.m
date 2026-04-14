%% zoom in FUNCTIONS
% function to render a sphere of fine elements as the colloid and
% paint elments inside colloid hetdomains 
% Used in near surface figure
function AFMcolloidHetPaint(nfig,subp,xhetvcol,yhetvcol,zhetvcol,rhetvcol,x,y,z,ap)
global  ZETAHETP
% set collod hetdomain color
if ZETAHETP>=0.0
    hetpcolor = 'b';
else
    hetpcolor = [0.9290 0.6940 0.1250]; % gold;
end

% set center of collector
xo = 0.0;
yo = 0.0;
zo = 0.0;
% determine number of hetdomains
nhet=length(xhetvcol);
% calculate radial distance of all elements to center of collector
rdist = ((x-xo)^2+(y-yo)^2+(z-zo)^2)^0.5;
% calculate sphere resolution that represents smallest hetdomain
res_sphere = ceil(ap/(min(rhetvcol)/10));
if res_sphere<300
    res_sphere=300;
elseif res_sphere>500
    res_sphere=500;
end
% generate unit sphere
[xcols,ycols,zcols]= sphere(res_sphere); % calculate unit sphere obtain 3 matrices of 100x100 elements
% [xp,yp,zp]= sphere(10); %coarse mesh to represent colloid
% xp=xp*ap+x; yp=yp*ap+y; zp=zp*ap+z;
% scale and translate sphere
xcols = xcols*ap+x; ycols = ycols*ap+y; zcols = zcols*ap+z;
% calculate sphereical mesh resolution
% resp = (xcols(1,1)-xcols(1,2)
% calculate dist matrix and logic matrix to extract only the closest  half
% of colloid sphere elements relative to the collector
d = ((xcols-xo).^2+(ycols-yo).^2+(zcols-zo).^2).^0.5;
c = d<=rdist;
% calculate boundary that define equatorial ring
% tol = ap/(res_sphere/20);
% c1=(d>rdist-tol)&(d<rdist+tol);
% indicate plot window
figure(nfig)
subplot(subp(1),subp(2),subp(3))
hold on
%loop through array (colloid sphere)
%% loop through all colloid hetdomains and extract colloid surface elements
for k=1:nhet
    % calculate distance matriz to hetdomain center
    rhetdis = ((xcols-xhetvcol(k)).^2+(ycols-yhetvcol(k)).^2+(zcols-zhetvcol(k)).^2).^0.5;
    % determine logic matrix to elements inside hetdomain
    if k==1
        % for first element no need to combine previous positions, need to
        % discriminate if element is in closest hemisphee to collector
        % surface
        ctotal = rhetdis<=rhetvcol(k)&c;
    else
        ctotal = ((rhetdis<=rhetvcol(k))|(ctotal))&c;
    end
end
% prealocate
xrhet=NaN(size(xcols)); yrhet=xrhet; zrhet=xrhet;
% xrnohet=xrhet; yrnohet=xrhet; zrnohet=xrhet;
% xhemicol = xrhet; yhemicol = xrhet; zhemicol = xrhet;
% xring = xrhet; yring = xrhet; zring = xrhet;
%  obtain surface associated with hetdomains
xrhet(ctotal) = xcols(ctotal);
yrhet(ctotal) = ycols(ctotal);
zrhet(ctotal) = zcols(ctotal);
% obtain surface not associated with hetdomains
% ctotalComp = ctotal==0&c;
% xrnohet(ctotalComp) = xcols(ctotalComp);
% yrnohet(ctotalComp) = ycols(ctotalComp);
% zrnohet(ctotalComp) = zcols(ctotalComp);
% % obtain colloid hemisphere
% xhemicol(c)=xcols(c);
% yhemicol(c)=ycols(c);
% zhemicol(c)=zcols(c);
% % obtain equator ring
% xring(c1) = xcols(c1);
% yring(c1) = ycols(c1);
% zring(c1) = zcols(c1);
%% plot hetdomain associated colloid sphere elements
surf(xrhet,yrhet,zrhet,'FaceColor',hetpcolor,'EdgeColor','none');
% colcolor = [0.9290 0.6940 0.1250]; % gold
% colcolor = 'none'; %wired
% surf(xrnohet,yrnohet,zrnohet,'FaceColor',colcolor,'EdgeColor','none');
% surf(xrnohet,yrnohet,zrnohet,'FaceColor',colcolor,'EdgeColor','k');
% surf(xhemicol,yhemicol,zhemicol,'FaceColor',colcolor,'EdgeColor','k');
% draw equator ring to represent colloid
% surf(xring,yring,zring,'FaceColor',colcolor,'EdgeColor','none');
% surf(xp,yp,zp,'FaceColor','none','EdgeColor','k')
end
