function  HAPcircle(x,y,r,nfig)
%modified from mathworks.com
th = 0:pi/500:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
figure (nfig)
plot(xunit, yunit,'-k','Linewidth',1.5);
hold on;
end