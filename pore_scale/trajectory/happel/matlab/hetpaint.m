%% zoom in FUNCTIONS

% collector hetdomains painting function
function hetpaint(nfig,subp,xcap,ycap,zcap,xhetv,yhetv,zhetv,rhetv)
global ZETAHET
% nfig, indicates figure to paint hetdomains, e.g., for figure(1), use
% nfig=1;
% subp, 3 element vector to locate figure (if figure has subplots)
% e.g. for subplot(1,2,1), use subp = [1,2,1]
figure(nfig)
subplot(subp(1),subp(2),subp(3))
hold on
% set collector hetdomain color
if ZETAHET>=0.0
    hetcolor = 'g';
else
    hetcolor = 'r';
end
% prealocate dummy hetcap arrays
xhetcap = NaN(size(xcap));
yhetcap = xhetcap;
zhetcap = xhetcap;
% paint hetdomains
for k=1:length(xhetv)
    % obtain rdist vector
    rdist = ((xcap-xhetv(k)).^2+(ycap-yhetv(k)).^2+(zcap-zhetv(k)).^2).^0.5;
    c = rdist<=rhetv(k);
    % extract values from cap domain to hetdomain
    xhetcap(c)=xcap(c);
    yhetcap(c)=ycap(c);
    zhetcap(c)=zcap(c);
    if sum(sum(c))>0
        figure(nfig)
        subplot(subp(1),subp(2),subp(3))
        % plot
        surf(xhetcap,yhetcap,zhetcap,'FaceColor',hetcolor,'EdgeColor','none')  
    end
end
end
