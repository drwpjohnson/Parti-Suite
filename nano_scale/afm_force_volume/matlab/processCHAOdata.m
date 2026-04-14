%processCHAOdata.m
% filename = "J:\Google Drive\MATLAB current projects\AFM module\Chao data\1mM 1nN.xlsm";
% sheet="data";
% mM1nN = importfileCHAO(filename, sheet, [2, 7201]);
% LOCS = importCHAOlocs(filename, sheet, [2, 7201]);
% 
% dir ="J:\Google Drive\MATLAB current projects\AFM module";
% mat_file = strcat(dir,"\mM1nN_raw_data.mat");
% save(mat_file,'mM1nN','LOCS');
clc; clear; close all

dir ="J:\Google Drive\MATLAB current projects\AFM module";
mat_file = strcat(dir,"\mM1nN_raw_data.mat");
load(mat_file,'mM1nN','LOCS');
% convert table to array
mM1nN_array = table2array(mM1nN(:,5:end));
[nr,nc] = size(mM1nN_array);
%% adjustable parameters
% number of data points to estimate rolling average
avg_points = 100;
% number of skips through series of profiles
nskips = 1; 
% set limits on series examined (add error caching)
series_start = 1;
series_end = 10000;%ceil(nr/2);
% error caching
if series_start <1
   series_start = 1; 
end
if series_end*2>nr
   series_end = ceil(nr/2);
end
% calculate zoi from experimental conditions
rzoidummy = 1e-8;
colcolor = [0.9290 0.6940 0.1250]; 
%% locations figure
% get locations vectors from data
% 
conv_fac = 1e-9; % nm to m
LOCS_array =table2array(LOCS)*conv_fac;
LAT1aux = LOCS_array(:,1);
LAT2aux = LOCS_array(:,2);
c=isnan(LAT1aux);
% LAT1aux(c)=[];
c=isnan(LAT2aux);
% LAT2aux(c)=[];
nloc = length(LAT1aux);
% probe locations
afaux = zeros(1,nloc);

figure(1)
plot3(LAT1aux,LAT2aux,afaux,'sb')
title({'Probe Locations(blue squares)',...
    'ZOI (gold circles)'});
axis square
hold on
% % plot zoi around probe locations

for i=1:nloc
    [xc,yc,zc]=AFMcircle(LAT1aux(i),LAT2aux(i),0.0,rzoidummy,40);
    plot3(xc,yc,zc,'-','Color',colcolor)
end




%% profile figures
% prealocate processed data arrays
H_proc = NaN(ceil(nr/2),nc);
F_proc = NaN(ceil(nr/2),nc);
Fmm_proc = NaN(ceil(nr/2),nc);
% prealocate index array
auxM = NaN(ceil(nr/2),nc);
% prealocate series lenghts array
npoints_proc = NaN(1,ceil(nr/2));
% plot profiles
k=1;
% factor of 2 in skips and end becasues
% a profile is defined in 2 rows (H and F)
if series_start==1
    row_start = 1;
else
    row_start = series_start*2-1;
end
row_end = series_end*2;
%
for i=row_start:2*nskips:row_end
    Hv = mM1nN_array(i,5:end);
    Fv = mM1nN_array(i+1,5:end);
    % remove NaN
    c=isnan(Hv);
    Hv(c)=[];
    Fv(c)=[];
    % remove values in negative H
    c=Hv<0.0;
    Hv(c)=[];
    Fv(c)=[];
    % obtain rolling average profiles
    Fv_mm = movmean(Fv,avg_points);
    %populate processed arrays
    n=length(Hv);
    H_proc(k,1:n)=Hv;    
    F_proc(k,1:n)=Fv;
    Fmm_proc(k,1:n)=Fv_mm;
    npoints_proc(k) = n;
    % populate index array
    v = ones(1,n)*k;
    auxM(k,1:n)=v;
    % register location ni vectors to plot
    xprof(k) = LAT1aux(i);
    yprof(k) = LAT2aux(i);
    % count to next profile
    k=k+1;
end
% transpose arrays
H_proc   = H_proc';
F_proc   = F_proc';
Fmm_proc = Fmm_proc';
auxM     = auxM';
% plot locations of examined profiles
figure(1)
plot3(xprof,yprof,zeros(1,length(xprof)),'.r','MarkerSize',15)
% generate index vector for plot
% plot raw profiles
figure(2)
scatter3(H_proc(:),auxM(:),F_proc(:),30,F_proc(:),'.')
colormap jet
colorbar
title('Raw Force Profiles')
h=gca;
set(h,'xscale','log')
xlabel('H(m)'); ylabel('Index'); zlabel('F(N)');
hold on
view(0,0)

%plot rolling average profiles
figure(3)
scatter3(H_proc(:),auxM(:),Fmm_proc(:),30,Fmm_proc(:),'.')
colormap jet
colorbar
title('Moving Average Force Profiles')
h=gca;
set(h,'xscale','log')
xlabel('H(m)'); ylabel('Index'); zlabel('F(N)');
hold on
view(0,0)
% axis([1e-9 1e-7 -Inf Inf -0.5e-10 0.5e-10])

%% histograms and heatmap
% window values from user input
% Primary minimum
% maximum separation distance
hpridisc = 2.0e-9;
% Force Barrier
% minimum separation distance
hbardisc1 = 1.0e-9;
% maximum separation distance
hbardisc2 = 3.0e-9;
% app.hpridisc.Value = num2str(Hlow-HMIN+HFRIC);
% app.hbardisc1.Value = num2str(Hlow);
% app.hbardisc2.Value = num2str(Hhigh);
%% evaluate profiles one by one
npoints_proc(isnan(npoints_proc))=[];
nprof = length(npoints_proc);
% prealocate vector for primary force minimum
priFdisc = NaN(1,nprof);
% prealocate vector for force barrier
barFdisc = NaN(1,nprof);
% loop each profile
for i=1:nprof
    nrows = npoints_proc(i);
    Fmm_prof = Fmm_proc(1:nrows,i);
    H_prof = H_proc(1:nrows,i);
    % find primary Force minimum
    Hpri_range =H_prof(H_prof<hpridisc);
    Fpri_range =Fmm_prof(H_prof<hpridisc);
    if min(Fpri_range)<0.0
        priFdisc(i)=min(Fpri_range);
    end
    % find  Force barrier
    Hbar_range =H_prof(and(H_prof>=hbardisc1,H_prof<=hbardisc2));
    Fbar_range =Fmm_prof(and(H_prof>=hbardisc1,H_prof<=hbardisc2));
    if max(Fbar_range)>0.0
        barFdisc(i)=max(Fbar_range);
    end    
    
end
% figure 4
% create a mesh from scatter data
tri = delaunay(xprof,yprof);
% barrier heatmap
% test plot3
figure(4)
trisurf(tri,xprof,yprof,barFdisc)
xlabel('X(m)'); ylabel('Y(m)'); zlabel('F(N)'); 
title('Barrier Heatmap')
colormap jet
colorbar
h=gca;
set(h,'zscale','log')
axis square


% figure 5
% primary minima heatmap
% barrier heatmap
% test plot3
figure(5)
trisurf(tri,xprof,yprof,priFdisc)
xlabel('X(m)'); ylabel('Y(m)'); zlabel('F(N)'); 
title('Primary Minimum Heatmap')
colormap jet
colorbar
h=gca;
axis square



% prepare histograms binning
lowbarF  = min(barFdisc)/2;
highbarF = max(barFdisc)*2;
highpriF = max(priFdisc)/2;
lowpriF  = min(priFdisc)*2;
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

% figure 6
% barrier histogram
% error catching in case the binning is undefined
c=isnan(edgesBar);
if sum(c)==0
    figure(6)
    hbar=histogram(barFdisc,edgesBar,'FaceColor','r');
    title('Barrier')
    xlabel('F(N)');ylabel('Frequency')
    Ybar = hbar.Values;
else
    f = warndlg('No barriers detected in specified window ','Warning');
end
%
% figure 7
% primary minimum histogram
c=isnan(edgesPri);
if sum(c)==0
    figure(7)
    hpri=histogram(priFdisc,edgesPri,'FaceColor','b');
    Ypri = hpri.Values;
    title('Primary Minimum')
    xlabel('F(N)');ylabel('Frequency')
    disp('Simulation Completed')
else
    f = warndlg('No primary minimum detected in specified window ','Warning');
end









% %probe locations
% figure(1)
% plot3(LAT1aux,LAT2aux,afaux,'sb')
% title({'Probe Locations(blue squares)',...
%     'ZOI (gold circles)',...
%     'Heterodomains (green circles)'});
%
% axis square
% zlabel({'Fraction of ZOI','occupied by heterodomain'})
% hold on
% % plot zoi around probe locations
% for i=1:NPARTLOOP
%     [xc,yc,zc]=AFMcircle(LAT1aux(i),LAT2aux(i),0.0,rzoiaux(i),50);
%     plot3(xc,yc,zc,'-','Color',colcolor)
% end
% % plot hetdomains on AFMdomain
% if AXstring=='x'
%     mxhetPLOT = myhetOUT;
%     myhetPLOT = mzhetOUT;
% end
% if AXstring=='y'
%     mxhetPLOT = mxhetOUT;
%     myhetPLOT = mzhetOUT;
% end
% if AXstring=='z'
%     mxhetPLOT= mxhetOUT;
%     myhetPLOT = myhetOUT;
% end
% for j=1:NPARTLOOP
%     % changed het location plotting to account for axis swapping!!!!
%     for i=1:rangeHetV(j)
%         [xc,yc,zc]=AFMcircle(mxhetPLOT(i,j),myhetPLOT(i,j),0.0,mrhetOUT(i,j),50);
%         plot3(xc,yc,zc,'-g')
%     end
% end


% figure(2)
% % surf(HOT,auxM,FCOLLOT,'EdgeColor','none')
% scatter3(HOT(:),auxM(:),FCOLLOT(:),30,FCOLLOT(:),'.')
% colormap jet
% colorbar
% title('Force Profiles')
% h=gca;
% set(h,'xscale','log')
% xlabel('H(m)'); ylabel('Index'); zlabel('F(N)');


%%
function f_fig(nfig,x,y,axlim,linfor)
figure(nfig)
plot(x,y,linfor)
axis(axlim)
hold on
end