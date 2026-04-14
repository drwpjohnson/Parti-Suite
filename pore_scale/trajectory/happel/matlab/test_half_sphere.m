clc; clear; close all;
[xu,yu,zu]= sphere; % calculate unit sphere
% collector
ac = 10;
x=xu*ac; y=yu*ac; z=zu*ac;
% rough element on pole
asp = 1;
xa=xu*asp; ya=yu*asp; za=zu*asp+ac;
% remove half sphere of rough element
d = (xa.^2+ya.^2+za.^2).^0.5;
c= d<ac;
xa(c)=NaN;
ya(c)=NaN;
za(c)=NaN;
figure(1)
surf(x,y,z,'FaceColor','none')
hold on
surf(xa,ya,za)
axis image