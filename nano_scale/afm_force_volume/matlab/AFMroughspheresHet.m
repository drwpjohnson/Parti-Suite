%% zoom in FUNCTIONS

%% This function renders hemispheres as rough elements or smooth surfaces depending on tht
% RMODE value; 
% RMODE = 0: Smooth collector and colloid
% RMODE = 1: Smooth collector rough colloid
% RMODE = 2: Smooth colloid rough collector
% RMODE = 3: Rough collector and colloid
% include surface charge heterogeneity on roughness hemispheres 
% elements as different color
function AFMroughspheresHet(hetpaint,colloidHetPaint,nfig,subp,xcap,ycap,zcap,xhetv,yhetv,zhetv,rhetv,xs,ys,zs,x,y,z,ac,ap,res,numasp,colflag,RMODE)
global ZETACST ZETAHET ZETAHETP ZETAPST
% colflag = 1 for collector
% colflag = 2 for colloid
if colflag==1
    xo = 0.0; yo=0.0; zo = 0.0;
    adummy = ac;
else
    xo = x; yo=y; zo = z;
    adummy = ap;
end
% set collector color based on charge sign
if ZETACST<0.0
    collecolor = 'r';
else
    collecolor = 'g';
end
% set collector hetdomain color based on charge sign
if ZETAHET<0.0
    hetcolor = 'r';
else
    hetcolor = 'g';
end
% set colloid color based on charge sign
if ZETAPST<0.0
    colcolor = [0.9290 0.6940 0.1250];
else
    colcolor = 'b';
end
% set colloid hetdomain color based on charge sign
if ZETAHETP<0.0
    hetpcolor = [0.9290 0.6940 0.1250];
else
    hetpcolor = 'b';
end


% colcolor = [0.9290 0.6940 0.1250]; % gold
% determine number of hetdomains
nhet=length(xhetv);
% testing representing a roughness hemisphere on each node of cap
% set an arbitrary distance to draw roughness from center of cap
rdist = numasp*res/2;
% generate unit sphere
[nr,nc]=size(xcap); % get size of nodes array
if numasp>25
    [xr,yr,zr]= sphere(10); % calculate unit sphere using 5 elements
else
    [xr,yr,zr]= sphere(20); % calculate unit sphere using 10 elements
end
xr=xr*res/2; yr=yr*res/2; zr=zr*res/2; % scale sphere to asperity radius (asp)
% calculate dist matrix and logic matrix
d = ((xcap-xs).^2+(ycap-ys).^2+(zcap-zs).^2).^0.5;
c = d<=rdist;
% indicate plot window
figure(nfig)
subplot(subp(1),subp(2),subp(3))
hold on
drawnow nocallbacks
if RMODE>0
    %loop through array
    for i=1:nr
        for j=1:nc
            % draw sphere
            if c(i,j)
                if colflag ==1&&(RMODE==2||RMODE==3) %collector roughness
                    % remove sphere elements if inside collector surface
                    xasp=xr+xcap(i,j); yasp=yr+ycap(i,j); zasp=zr+zcap(i,j);
                    ra = ((xasp-xo).^2+(yasp-yo).^2+(zasp-zo).^2).^0.5;
                    c1= ra<ac;
                    xasp(c1)=NaN;
                    yasp(c1)=NaN;
                    zasp(c1)=NaN;
                    %% find projection of hemisphere points on collector
                    % find unit vectors
                    xau=(xasp-xo)./ra; yau=(yasp-yo)./ra; zau=(zasp-zo)./ra;
                    % find projections on collector surface
                    xas = xau*adummy+xo; yas = yau*adummy+yo; zas = zau*adummy+zo;
                    %% obtain elements on roughness hemispherical element associated with hetdomains
                    for k=1:nhet
                        rhetdis = ((xas-xhetv(k)).^2+(yas-yhetv(k)).^2+(zas-zhetv(k)).^2).^0.5;
                        % determine logic matrix to elements inside hetdomain
                        if k==1
                            % for first element no need to combine previous positions
                            ctotal=rhetdis<=rhetv(k);
                        else
                            ctotal = (rhetdis<=rhetv(k))|(ctotal);
                        end
                    end
                    % divide surface of roughess element in associated with hetdomains vs
                    % prealocate
                    xrhet=NaN(size(xasp)); yrhet=xrhet; zrhet=xrhet;
                    xrnohet=xrhet; yrnohet=xrhet; zrnohet=xrhet;
                    %  obtain surface associated with hetdomains
                    xrhet(ctotal) = xasp(ctotal);
                    yrhet(ctotal) = yasp(ctotal);
                    zrhet(ctotal) = zasp(ctotal);
                    % obtain surface not associated with hetdomains
                    xrnohet(~ctotal) = xasp(~ctotal);
                    yrnohet(~ctotal) = yasp(~ctotal);
                    zrnohet(~ctotal) = zasp(~ctotal);
                    %% plot
                    %figure(nfig)
                    subplot(subp(1),subp(2),subp(3))
                    surf(xrhet,yrhet,zrhet,'FaceColor',hetcolor,'EdgeColor','k');
                    surf(xrnohet,yrnohet,zrnohet,'FaceColor',collecolor,'EdgeColor','k');
                elseif colflag ==2&&(RMODE==1||RMODE==3) %colloid roughness
                    % remove sphere elements if inside colloid surface
                    xasp=xr+xcap(i,j); yasp=yr+ycap(i,j); zasp=zr+zcap(i,j);
                    ra = ((xasp-xo).^2+(yasp-yo).^2+(zasp-zo).^2).^0.5;
                    c1= ra<ap;
                    xasp(c1)=NaN;
                    yasp(c1)=NaN;
                    zasp(c1)=NaN;
                    %% find projection of hemisphere points on collector
                    % find unit vectors
                    xau=(xasp-xo)./ra; yau=(yasp-yo)./ra; zau=(zasp-zo)./ra;
                    % find projections on collector surface
                    xas = xau*adummy+xo; yas = yau*adummy+yo; zas = zau*adummy+zo;
                    %% obtain elements on roughness hemispherical element associated with hetdomains
                    for k=1:nhet
                        rhetdis = ((xas-xhetv(k)).^2+(yas-yhetv(k)).^2+(zas-zhetv(k)).^2).^0.5;
                        % determine logic matrix to elements inside hetdomain
                        if k==1
                            % for first element no need to combine previous positions
                            ctotal=rhetdis<=rhetv(k);
                        else
                            ctotal = (rhetdis<=rhetv(k))|(ctotal);
                        end
                    end
                    % divide surface of roughess element in associated with hetdomains vs
                    % prealocate
                    xrhet=NaN(size(xasp)); yrhet=xrhet; zrhet=xrhet;
                    xrnohet=xrhet; yrnohet=xrhet; zrnohet=xrhet;
                    %  obtain surface associated with hetdomains
                    xrhet(ctotal) = xasp(ctotal);
                    yrhet(ctotal) = yasp(ctotal);
                    zrhet(ctotal) = zasp(ctotal);
                    % obtain surface not associated with hetdomains
                    xrnohet(~ctotal) = xasp(~ctotal);
                    yrnohet(~ctotal) = yasp(~ctotal);
                    zrnohet(~ctotal) = zasp(~ctotal);
                    %% plot
                    %figure(nfig)
                    subplot(subp(1),subp(2),subp(3))                    
                    surf(xrhet,yrhet,zrhet,'FaceColor',hetpcolor,'EdgeColor','k');
                    surf(xrnohet,yrnohet,zrnohet,'FaceColor',colcolor,'EdgeColor','k');
                end
            end
        end
    end 
    % draw smooth collector
    if RMODE ==1&&colflag==1
        %figure(nfig)
        subplot(subp(1),subp(2),subp(3))
        surf(xcap,ycap,zcap,'FaceColor',collecolor,'EdgeColor','none')
        hetpaint(nfig,subp,xcap,ycap,zcap,xhetv,yhetv,zhetv,rhetv)
    end
     % draw smooth colloid
    if RMODE ==2&&colflag==2
        %figure(nfig)
        subplot(subp(1),subp(2),subp(3))
        surf(xcap,ycap,zcap,'FaceColor',colcolor,'EdgeColor','none')
        colloidHetPaint(nfig,subp,xhetv,yhetv,zhetv,rhetv,x,y,z,ap)
    end   
    
else % for smooth surface
    if colflag ==1 % collector smooth surface
        %figure(nfig)
        subplot(subp(1),subp(2),subp(3))
        surf(xcap,ycap,zcap,'FaceColor',collecolor,'EdgeColor','none')
        drawnow
        hetpaint(nfig,subp,xcap,ycap,zcap,xhetv,yhetv,zhetv,rhetv)
    end
    if colflag ==2 % colloid smooth surface
       %figure(nfig)
       subplot(subp(1),subp(2),subp(3))
       surf(xcap,ycap,zcap,'FaceColor',colcolor,'EdgeColor','none')
       colloidHetPaint(nfig,subp,xhetv,yhetv,zhetv,rhetv,x,y,z,ap)  
    end        
end
end

