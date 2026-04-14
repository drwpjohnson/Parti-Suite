function HAP_hetdomain_info()
% tile size
tile = 1;
% view area size
dom =tile/2;
% hetdomain sizes
rhet0 = tile/20; % large
rhet1 = rhet0/2; % medium
rhet2 = rhet1/2; % small
% unit circle
[xu,yu,zu]=HAP_info_circle(0,0,0,1.0,50);
figure('name','Example heterodomain tiles','NumberTitle','off');
%
subplot(2,2,1)
fill(xu*rhet0,yu*rhet0,'g');
hold on
title({'Large only',' (HETMODE = 1)'})
sgtitle('Collector Hetmode Options') 

axis([-dom dom  -dom dom]);
axis square
%
subplot(2,2,2)
fill(xu*rhet0,yu*rhet0,'g');
hold on
title({'1 Large, 4 Medium',' (HETMODE = 5)'})
% loop surrounding hetdomains
for i=1:4
    ang = i*pi/2;
    x = xu*rhet1+tile/3*cos(ang);
    y = yu*rhet1+tile/3*sin(ang);
    fill(x,y,'g');
end
axis([-dom dom  -dom dom]);
axis square
%
subplot(2,2,3)
fill(xu*rhet0,yu*rhet0,'g');
hold on
title({'1 Large, 8 Medium',' (HETMODE = 9)'})
% loop surrounding medium size hetdomains
for i=1:8
    ang = i*pi/4;
    x = xu*rhet1+tile/3*cos(ang);
    y = yu*rhet1+tile/3*sin(ang);
    fill(x,y,'g');
end
axis([-dom dom  -dom dom]);
axis square
%
subplot(2,2,4)
fill(xu*rhet0,yu*rhet0,'g');
hold on
title({'1 Large, 8 Medium, 64 Small',' (HETMODE = 73)'})
% loop surrounding medium size hetdomains
for i=1:8
    ang = i*pi/4;
    xoff = tile/3*cos(ang);
    yoff = tile/3*sin(ang);
    x = xu*rhet1+xoff;
    y = yu*rhet1+yoff;
    fill(x,y,'g');
    % loop surrounding small size hetdomains
    for j=1:8
        ang1 = j*pi/4;
        x1 = xu*rhet2+tile/6*cos(ang1)+xoff;
        y1 = yu*rhet2+tile/6*sin(ang1)+yoff;
        fill(x1,y1,'g');
    end
end
axis([-dom dom  -dom dom]);
axis square

end