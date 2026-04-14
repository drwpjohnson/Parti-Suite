% AFM_heat_hist.m
function AFM_heat_hist()
global NPARTLOOP HOT FCOLLOT 
global LAT1loc LAT2loc LAT1aux LAT2aux
global barFdisc priFdisc HbarFdisc HpriFdisc
global LAT1barFdisc LAT2barFdisc LAT1priFdisc LAT2priFdisc
global hpridisc hbardisc1 hbardisc2 
global HFRIC HMIN Hlow Hhigh
global Ybar Ypri centersBar centersPri
global hpridisc hbardisc1 hbardisc2
%% Force maxima and minima analysis
% array size corresponds to (nsteps,NPARTLOOP)
% obtain abolute maximum and minimum of each profile
c=HOT(:,1)>hbardisc1;
[barFraw,imaxF] = max(FCOLLOT(c,:));
[priFraw,iminF] = min(FCOLLOT);
% check max and min sign and generate logic arrays
csignmax=barFraw>0.0;
csignmin=priFraw<0.0;
% assign max and min separation location 
% hpridisc upper bound primary force minimum
% hbardisc1 lower bound force barrier
% hbardisc2 upper bound force barrier
% prealocate logic arrays for separation distance criteria
chmax =  false(1,NPARTLOOP);
chmin = false(1,NPARTLOOP);
% loop through output columns
for i=1:NPARTLOOP
    % identify <hpridisc locations for primary minimum
    if(HOT(iminF(i),i)<hpridisc)
        chmin(i)=true;
    else
        chmin(i)=false;
    end
    % identify >hbardisc1  and <hbardisc2 locations for barrier
    if(HOT(imaxF(i),i)<hbardisc2)    
        chmax(i)=true;
    else
        chmax(i)=false;
    end
end
% obtain discriminated barrier and primary minima array
barFdisc  = NaN(1,NPARTLOOP);
priFdisc  = NaN(1,NPARTLOOP);
% prealocate separation distance and lat1 lat2 locations arrays
HbarFdisc    = NaN(1,NPARTLOOP);
HpriFdisc    = NaN(1,NPARTLOOP);
LAT1barFdisc = NaN(1,NPARTLOOP);
LAT2barFdisc = NaN(1,NPARTLOOP);
LAT1priFdisc = NaN(1,NPARTLOOP);
LAT2priFdisc = NaN(1,NPARTLOOP);
for i=1:NPARTLOOP
    % check if Force is positive and in location range of interest
    if csignmax(i)&&chmax(i)
        barFdisc(i)=barFraw(i);
        % record separation distance and lat1 lat2 locations
        HbarFdisc(i)=HOT(imaxF(i),i);
        LAT1barFdisc(i)=LAT1aux(i); 
        LAT2barFdisc(i)=LAT2aux(i); 
    end
    % check if Force is negative and in location range of interest
    % allow positive minima
    if chmin(i)%csignmin(i)&&chmin(i)
        priFdisc(i)=priFraw(i);
        % record separation distance and lat1 lat2 locations
        HpriFdisc(i)=HOT(iminF(i),i);
        LAT1priFdisc(i)=LAT1aux(i); 
        LAT2priFdisc(i)=LAT2aux(i);          
    end  
    % do not allow positive minima
%     if csignmin(i)&&chmin(i)
%         priFdisc(i)=priFraw(i);
%     end  
end
% convert heatmap arrays to 2D probe locations
% changed xloc and yloc to LAT1loc and Lat2loc!!!!
[nr,nc]=size(LAT1loc);

% prealocate force location arrays
lowbarF  = min(barFdisc)/2;
highbarF = max(barFdisc)*2;
% check if priFdisc are not NaN (no primary minima)
% to allow heatmap display when primary minimum is absent
if sum(isnan(priFdisc))<length(priFdisc)
    highpriF = max(priFdisc)/2;
    lowpriF  = min(priFdisc)*2;
else
    highpriF = lowbarF/10;
    lowpriF = lowbarF/100;
end
barFlocHIST=NaN(nr,nc); %*maxinitF;
priFlocHIST=NaN(nr,nc);%*mininitF;
% array for plotting only (replace NaN)
barFlocPLOT = barFlocHIST;
priFlocPLOT = priFlocHIST;
% barrier
% check that barrier data is present
if sum(isnan(barFdisc))<length(barFdisc)
    k=1; % counter of barrier and primary minimum discriminated vectors
    for i=1:nr
        for j=1:nc
            % populate max force map location
            barFlocHIST(i,j)= barFdisc(k); 
            barFlocPLOT(i,j) = barFdisc(k);
            % override if NaN force value is registered
            if isnan(barFlocPLOT(i,j))
                barFlocPLOT(i,j)=lowbarF/100;
            end
            % count probe #location
            k=k+1;
        end
    end
end
% primary minimum
% check that primary minimum data is present
if sum(isnan(priFdisc))<length(priFdisc)
    k=1; % counter of barrier and primary minimum discriminated vectors
    for i=1:nr
        for j=1:nc
            % populate min force map location
            priFlocHIST(i,j)= priFdisc(k);
            priFlocPLOT(i,j)= priFdisc(k);
            % override if NaN force value is registered
            if isnan(priFlocPLOT(i,j))
                priFlocPLOT(i,j)=highpriF/100;
            end  
            % count probe #location
            k=k+1;
        end
    end
end

%% OUTPUT plots


%% barrier heatmap
% plot only if barrier data is present
if sum(isnan(barFlocPLOT(:)))<length(barFlocPLOT(:))
    figure(3)
    % changed xloc and yloc to LAT1loc and Lat2loc!!!!
    surf(LAT1loc,LAT2loc,barFlocPLOT,'EdgeColor','none')
    xlabel('X(m)'); ylabel('Y(m)'); zlabel('F(N)'); 
    title('Barrier Heatmap')
    colormap jet
    colorbar
    h=gca;
    set(h,'zscale','log')
    axis square
else
    % warn the user there is no barrier data present
    warndlg('No barrier detected, heatmap and histogram disabled')
end
%% primary minimum heatmap
% plot only if primary minimum data is present
if sum(isnan(priFlocPLOT(:)))<length(priFlocPLOT(:))
    figure(4)
    % changed xloc and yloc to LAT1loc and Lat2loc!!!!
    surf(LAT1loc,LAT2loc,priFlocPLOT,'EdgeColor','none')
    xlabel('X(m)'); ylabel('Y(m)'); zlabel('F(N)');
    title('Primary Minimum Heatmap')
    colormap jet
    colorbar
    axis square
    axis([-Inf Inf -Inf Inf lowpriF highpriF])
else
    % warn the user there is no primary minimum data present
    warndlg('No primary minimum detected, heatmap and histogram disabled')
end
%% histograms
% get edges for barrier and minima 
% lowbarF  = min(barFdisc)/2;
% highbarF = max(barFdisc)*2;
% highpriF = max(priFdisc)/2;
% lowpriF  = min(priFdisc)*2;
geobin = 0; % geometric or linear switch for histogram binning
nbins =10;
if geobin ==1
    binfactBar= (highbarF/lowbarF)^(1/(nbins-1));
    binfactPri= (highpriF/lowpriF)^(1/(nbins-1));
    edgesBar(1)=lowbarF;
    edgesPri(1)=lowpriF;
    for i=2:nbins
        edgesBar(i)=edgesBar(i-1)*binfactBar;
        edgesPri(i)=edgesPri(i-1)*binfactPri;
    end
else
    edgesBar = linspace(lowbarF,highbarF,nbins);
    edgesPri = linspace(lowpriF,highpriF,nbins);
end
% obtain centers
for i=1:nbins-1
    centersBar(i) = (edgesBar(i)+edgesBar(i+1))/2;
    centersPri(i) = (edgesPri(i)+edgesPri(i+1))/2;
end
% barrier 
% plot only if barrier data is present
if sum(isnan(barFdisc))<length(barFdisc)
    figure(5)
    hbar=histogram(barFdisc,edgesBar,'FaceColor','r');
    title('Barrier')
    xlabel('F(N)');ylabel('Frequency')
    Ybar = hbar.Values;
end
% primary minima
% plot only if primary minimum data is present
if sum(isnan(priFdisc))<length(priFdisc)
    figure(6)
    hpri=histogram(priFdisc,edgesPri,'FaceColor','b');
    Ypri = hpri.Values;
    title('Primary Minimum')
    xlabel('F(N)');ylabel('Frequency')
    disp('Simulation Completed')
end
end