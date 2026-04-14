function [X,Y,Z,H]=HAPplottraj(J,NPARTLOOP,perTIME,perREL,perREM,ATTMODE,X,Y,Z,H,XINIT,YINIT,ZINIT,RLIM,AP,AG,RB,...
                      ATTACHK,MAXVAL,hetdraw,HETMODE,XHET,YHET,ZHET,RHET,nfig)
% set flag for color coded trajectories for 2nd figure (3D general geometry)
% (cflag =1) or solid color lines cflag=0)
cflag=1;
if ATTMODE==-1
    if J==NPARTLOOP
        % sort times
        perTIME = sort(perTIME,'ascend');
        %% 1st figure for Perturbation Mode (release and remain vs time)  
        figure (nfig)
        plot(perTIME,perREL,'o-r','LineWidth',1.5)
        axis ([0.0 1.05*max(perTIME) 0 100]);
        grid on; hold on;
        plot(perTIME,perREM,'*-b','LineWidth',1.5)
        % more format 
        legend('Percentage Released','Percentage Remained')
        xlabel('Time (s)'); ylabel('Percentage (%)');
        set(gca,'FontSize',12)    
    end

else
    %% 1st figure (injection plane)
    % from title string
    format001 = 'Initial Locations in Rlim plane, Z= -%5.3E (m) ';
    format002 = 'red=exited blue=attached magenta=provisionally attached';
    format003 = 'cyan=retained without contact black=crashed  green=timed out';
    s = sprintf(format001,RB);
    figure (nfig)
    title({s,format002,format003}); axis ([-RLIM RLIM -RLIM RLIM])
    hold on; grid on; axis square;
    % more format 
    set(gca,'FontSize',12)
    xlabel('X(m)');ylabel('Y(m)');
    % draw a different style depending of particle fate
    switch ATTACHK
        case 1 % EXIT
            plot (XINIT,YINIT,'o r', 'MarkerFaceColor','r','LineWidth',0.5)
            drawnow;
        case 2 % ATTACH PERFECT SINK OR TORQUE BALANCE
            plot (XINIT,YINIT,'o b', 'MarkerFaceColor','b','LineWidth',0.5)
            drawnow;
        case 6 % ATTACH PARTICLE RAN INTO SURFACE
            plot (XINIT,YINIT,'o k', 'MarkerFaceColor','k','LineWidth',0.5)
            drawnow;
        case 3 % REM: AFTER TIME IS OVER
            plot (XINIT,YINIT,'o g', 'MarkerFaceColor','g','LineWidth',0.5)
            drawnow;
        case 4 %REM: RETENTION WITH CONTACT
            plot (XINIT,YINIT,'o m', 'MarkerFaceColor','m','LineWidth',0.5) 
            drawnow;
        case 5 %REM: RETENTION WITHOUT CONTACT
            plot (XINIT,YINIT,'o c', 'MarkerFaceColor','c','LineWidth',0.5)
            drawnow;
    end 
end
%% 2nd figure (3D general geometry)
figure (nfig+1)
% form title cell
format001 = 'Happel Geometry 3D';
format002 = 'red=bulk pore water magenta=near surface(<200nm)  blue=contact ';
title({format001,format002});
axis ([-RB RB -RB RB -RB RB])
hold on; grid on; axis square;
% more format 
set(gca,'FontSize',12)
xlabel('X(m)');ylabel('Y(m)');zlabel('Z(m)')
if cflag==0 %colorcode trajectories flag
    % draw a different style depending of particle fate
    switch ATTACHK
        case 1 % EXIT
            plot3 (X,Y,Z,'-r', 'LineWidth',0.5)
            drawnow;
        case 2 % ATTACH PERFECT SINK OR TORQUE BALANCE
            plot3 (X,Y,Z,'-b', 'LineWidth',0.5)
            drawnow;
        case 6 % ATTACH PARTICLE RAN INTO SURFACE
            plot3 (X,Y,Z,'--b', 'LineWidth',0.5)
            drawnow;
        case 3 % REM: AFTER TIME IS OVER
            plot3 (X,Y,Z,'-g', 'LineWidth',0.5) 
            drawnow;
        case 4 %REM: RETENTION WITH CONTACT
            plot3 (X,Y,Z,'-m', 'LineWidth',0.5) 
            drawnow;
        case 5 %REM: RETENTION WITHOUT CONTACT
            plot3 (X,Y,Z,'--m', 'LineWidth',0.5)
            drawnow;
    end
else
    %call color coded trajectories drawing routine
    colorcodeH(X,Y,Z,H,nfig+1);    
end
%% 3nd figure (2D H vs Z slice zoomout)
figure (nfig+2)
title('H vs Z, 2D')
axis ([-RB RB 0.0 RB-AG])
hold on; grid on;
% more format 
set(gca,'FontSize',12)
xlabel('Z(m)');ylabel('H(m)');
% draw a different style depending of particle fate
switch ATTACHK
    case 1 % EXIT
        plot (Z,H,'-r', 'LineWidth',0.5)
        drawnow;
    case 2 % ATTACH PERFECT SINK OR TORQUE BALANCE
        plot (Z,H,'-b', 'LineWidth',0.5)
        drawnow;
    case 6 % ATTACH PARTICLE RAN INTO SURFACE
        plot (Z,H,'--b', 'LineWidth',0.5)
        drawnow;
    case 3 % REM: AFTER TIME IS OVER
        plot (Z,H,'-g', 'LineWidth',0.5) 
        drawnow;
    case 4 %REM: RETENTION WITH CONTACT
        plot (Z,H,'-m', 'LineWidth',0.5) 
        drawnow;
    case 5 %REM: RETENTION WITHOUT CONTACT
        plot (Z,H,'--m', 'LineWidth',0.5)
        drawnow;
end
%% 4th figure (4. 2D H vs Z slice zoom in)
figure (nfig+3)
title('H vs Z, 2D zoom in (H< 0.4 µm)')
axis ([-RB RB 0.0 4.0E-7])
hold on; grid on;
% more format 
set(gca,'FontSize',12)
xlabel('Z(m)');ylabel('H(m)');
% draw a different style depending of particle fate
switch ATTACHK
    case 1 % EXIT
        plot (Z,H,'-r', 'LineWidth',0.5)
        drawnow;
    case 2 % ATTACH PERFECT SINK OR TORQUE BALANCE
        plot (Z,H,'-b', 'LineWidth',0.5)
        drawnow;
    case 6 % ATTACH PARTICLE RAN INTO SURFACE
        plot (Z,H,'--b', 'LineWidth',0.5)
        drawnow;
    case 3 % REM: AFTER TIME IS OVER
        plot (Z,H,'-g', 'LineWidth',0.5) 
        drawnow;
    case 4 %REM: RETENTION WITH CONTACT
        plot (Z,H,'-m', 'LineWidth',0.5) 
        drawnow;
    case 5 %REM: RETENTION WITHOUT CONTACT
        plot (Z,H,'--m', 'LineWidth',0.5)
        drawnow;
end
%% add hetdomain locations for 2nd to 4th figure
if hetdraw ==1
   % normalize markersize to hetdomain size
    sizemark = RHET/min(RHET)*3;
    % plot in 2nd figure (3D)
    figure (nfig+1)
    for j=1:HETMODE
        plot3 (XHET(j),YHET(j),ZHET(j),'o k','MarkerFaceColor','g','LineWidth',0.5,'MarkerSize',sizemark(j))
        drawnow;
    end
   % plot in 3rd and 4th figures (2D)
    for i=3:4
        figure (nfig+i-1)
        for j=1:HETMODE
            plot(ZHET(j),0.0,'o k','MarkerFaceColor','g','LineWidth',0.5,'MarkerSize',sizemark(j))
            drawnow;
        end
    end
    dim =[0.2 0.5 0.3 0.3]; % legend lcoation and dimension
    HAPhetlegend (nfig+2,dim)
end
%% reset trajectory arrays
X = NaN(MAXVAL,1); Y=X; Z=X; H=X; 
end