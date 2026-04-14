% upscale - Data Processing
function [alpha1, alpha2, alphaRFSP, alphaREENT,u2,eta]=UpscaleALPHAS(...
XOUTaf, YOUTaf, ZOUTaf, TBULKaf, TNEARaf, TTOTALaf, ATTACHKaf, XINITaf, YINITaf, RINITaf ,ZINITaf,NSVELaf,...
XOUTef, YOUTef, ZOUTef, TBULKef, TNEARef, TTOTALef, ATTACHKef, XINITef, YINITef ,RINITef, ZINITef,NSVELef,...
XOUTau, YOUTau, ZOUTau, TBULKau, TNEARau, TTOTALau, ATTACHKau, XINITau, YINITau, RINITau, ZINITau,NSVELau,...
XOUTeu, YOUTeu, ZOUTeu, TBULKeu, TNEAReu, TTOTALeu, ATTACHKeu, XINITeu, YINITeu, RINITeu, ZINITeu,NSVELeu)
%% declare globals
global ap ag por vpor rlimFAV  
global asp 
global UPFLUX_header
global  HtfNUMBER HtuNUMBER HnfNUMBER HnuNUMBER edgesNear edgesTotal restime
%% close figures but GUI one
figHandles = findobj('type', 'figure', '-not', 'name', 'Upscale_Continuum_GUI');
close(figHandles);

% raise flag to indicate histogram data available for residence times
restime = 1;
% % set globals to pass through values to other functions
% global XOUTaf YOUTaf ZOUTaf TBULKaf TNEARaf TTOTALaf ATTACHKaf XINITaf YINITaf RINITaf ZINITaf
% global XOUTef YOUTef ZOUTef TBULKef TNEARef TTOTALef ATTACHKef XINITef YINITef RINITef ZINITef
% global XOUTau YOUTau ZOUTau TBULKau TNEARau TTOTALau ATTACHKau XINITau YINITau RINITau ZINITau
% global XOUTeu YOUTeu ZOUTeu TBULKeu TNEAReu TTOTALeu ATTACHKeu XINITeu YINITeu RINITeu ZINITeu
%% user input parameters as global 

% read RMODE
RMODE = UPFLUX_header{1,20};
% set asperity factor depending on RMODE
if RMODE==0 % smooth surfaces
    aspfact = 0.0;
end
if RMODE==1||RMODE==2 % rough colloid only or rough collector only
    aspfact = 1.0;
end
if RMODE==3 % rough colloid and rough collector
    aspfact = 2.0;
end
% % set collector and colloid radii (m)
% ap = 1.0e-6/2; ag =2.55e-04;
% % set porosity (-)
% por = 0.35;
% % set rlim (limiting injection radius)
% rlim = 1.5e-4;

% % input average near surface water velocity (m/hr) 
% v2 = 0.0;
% % input alphaTrans (fraction of RSFP colloids that are trasnmitted to downgradient near surface)
% alphaTrans = 0.25;
%% remove ATTACHK=3 colloids from data
% identify index of ATTACHK=3 colloids
indATT3 = ATTACHKau==3;
XOUTau(indATT3)=[];
YOUTau(indATT3)=[];
ZOUTau(indATT3)=[];
TBULKau(indATT3)=[];
TNEARau(indATT3)=[];
TTOTALau(indATT3)=[];
ATTACHKau(indATT3)=[];
XINITau(indATT3)=[];
YINITau(indATT3)=[];
RINITau(indATT3)=[];
ZINITau(indATT3)=[];
NSVELau(indATT3)=[];
%% reset noRFSP colloids flag
noRFSP = 0; 
% calculate b (fluid shell radius) (m)
b = ag/((1-por)^(1/3));
%% recognize Rear Flow Stagnation Point (RFSP) attached particles
% check collector+colloid radius from attachment flux data
% get collector+colloid radius+asperities from attachement data
agap = (XOUTaf(1)^2+YOUTaf(1)^2+ZOUTaf(1)^2)^0.5;
% note that asp2 is not used to calculate separation distance, it is used
% just for lever arm
apcheck = agap-ag-ap-aspfact*asp;
% check if the discrepancy between user input and flux data for ap and ag
% is larger than 20 nm 
if abs(apcheck)>2.0e-8
    %warning message
    %call message subroutine   
    warning_msgUPSCALE;
end
%obtain discrimnant vector logic values (1 for open surface, and 0 for RFSP) downflow injection_
% note that 
disc = (ZOUTau)>-(agap-ap-asp);
% check if there is no RFSP colloids
if sum(disc)==length(disc)
    noRFSP=1;
end
% check if there is no ATTunf colloids
noATTunf=0;
if sum(disc)==0
    noATTunf=1;
end
%obtain discriminant vector logic values (1 for open surface, and 0 for RFSP) upflow injection_
% disc = (ZOUTau)<(agap-ap);
% split array for UNFATT
c1=1;c2=1;
% figure (10)
% plot3(XOUTau,YOUTau,ZOUTau,'o b','MarkerSize',10)
% axis square;
for i=1:length(disc)
    % extract values for attached colloids
    if disc(i)==1
        XOUTau1(c1)=XOUTau(i); YOUTau1(c1)=YOUTau(i);
        ZOUTau1(c1)=ZOUTau(i); TBULKau1(c1)=TBULKau(i);
        TNEARau1(c1)=TNEARau(i);TTOTALau1(c1)=TTOTALau(i);
        ATTACHKau1(c1)=ATTACHKau(i);XINITau1(c1)=XINITau(i);
        YINITau1(c1)=YINITau(i);RINITau1(c1)=RINITau(i);
        ZINITau1(c1)=ZINITau(i);
        c1=c1+1;
    else
    % extract values for RFSP colloids  
        XOUTr(c2)=XOUTau(i); YOUTr(c2)=YOUTau(i);
        ZOUTr(c2)=ZOUTau(i); TBULKr(c2)=TBULKau(i);
        TNEARr(c2)=TNEARau(i);TTOTALr(c2)=TTOTALau(i);
        ATTACHKr(c2)=ATTACHKau(i);XINITr(c2)=XINITau(i);
        YINITr(c2)=YINITau(i);RINITr(c2)=RINITau(i);
        ZINITr(c2)=ZINITau(i);
        c2=c2+1;
    end
end
%% bypass histogram overlap analysis if no open surface attached colloids exist (noATTunf==1)
if noATTunf==0
    % rewrite original attunf arrays after splitting RFSP colloids 
    XOUTau=XOUTau1; clear XOUTau1;
    YOUTau=YOUTau1; clear YOUTau1;
    ZOUTau=ZOUTau1; clear ZOUTau1;
    TBULKau=TBULKau1; clear TBULKau1;
    TNEARau=TNEARau1; clear TNEARau1;
    TTOTALau=TTOTALau1; clear TTOTALau1;
    ATTACHKau= ATTACHKau1; clear ATTACHKau1;
    XINIT=XINITau1;
    YINIT=YINITau1;
    RINIT=RINITau1;
    ZINIT=ZINITau1;
    %% generate histograms
    %% get edges for attachment bins TNEAR TIME
    if min(TNEARaf)<min(TNEARau)
        minTot=min(TNEARaf);
    else
        minTot=min(TNEARau);
    end
    if max(TNEARau)>max(TNEARaf)
        maxTot=max(TNEARau);
    else
        maxTot=max(TNEARaf);
    end
    nbins =20;
    binfact= (maxTot/minTot)^(1/(nbins-1));
    edgesNear(1)=minTot;
    for i=2:nbins
        edgesNear(i)=edgesNear(i-1)*binfact;
    end
    %% get edges for attachment bins TOTAL TIME
    if min(TTOTALaf)<min(TTOTALau)
        minTot=min(TTOTALaf);
    else
        minTot=min(TTOTALau);
    end
    if max(TTOTALau)>max(TTOTALaf)
        maxTot=max(TTOTALau);
    else
        maxTot=max(TTOTALaf);
    end
    nbins =20;
    binfact= (maxTot/minTot)^(1/(nbins-1));
    edgesTotal(1)=minTot;
    for i=2:nbins
        edgesTotal(i)=edgesTotal(i-1)*binfact;
    end
    % capture slowest colloid, prevent rounding error in geometric bins
    % generation
    edgesTotal(end)=maxTot;
    %% plot histograms and extract data
    figure(1)
    histogram (TNEARaf,edgesNear,'FaceColor','b','Normalization','probability')
    set(gca,'xscale','log'); xlabel('Near Surface Time (s)');
    ylabel('Normalized Frequency'); set(gca,'FontSize',15)
    hold on
    histogram (TNEARau,edgesNear,'FaceColor','r','Normalization','probability')
    set(gca,'xscale','log'); 
    % assign objects to extract data from histograms
    Hnf=histogram (TNEARaf,edgesNear,'FaceColor','b','Normalization','probability');
    Hnu=histogram (TNEARau,edgesNear,'FaceColor','r','Normalization','probability');
    legend('Favorable ATT','Unfavorable ATT');
    % multiply pdfs by population to get actual numbers
    HnfNUMBER=round(Hnf.Values*length(TNEARaf));
    HnuNUMBER=round(Hnu.Values*length(TNEARau));


    figure(2)
    histogram (TTOTALaf,edgesTotal,'FaceColor','b'); %,'Normalization','probability')
    set(gca,'xscale','log'); xlabel('Total Time (s)');
    ylabel('Frequency'); set(gca,'FontSize',15)
    hold on
    histogram (TTOTALau,edgesTotal,'FaceColor','r');%,'Normalization','probability')
    set(gca,'xscale','log');
    % assign objects to extract data from histograms for alpha calculations
    Htf=histogram (TTOTALaf,edgesTotal,'FaceColor','b');
    Htu=histogram (TTOTALau,edgesTotal,'FaceColor','r');
    legend('Favorable ATT','Unfavorable ATT');
    % multiply pdfs by population to get actual numbers
    % HtfNUMBER=round(Htf.Values*length(TTOTALaf));
    % HtuNUMBER=round(Htu.Values*length(TTOTALau));
    HtfNUMBER=round(Htf.Values);
    HtuNUMBER=round(Htu.Values);

    %% determine overlap time for fav vs unf
    % determine overlapping bins fav vs unf
    ovlap = HtfNUMBER.*HtuNUMBER;
    % determine overlap index, save highest overlap bin 
    % need to add: that contains > 1% of both populations
    for i = 1:length(ovlap)
       if ovlap(i)>0
          ovi1 = i;
       end
    end
    % check if sum ovlap equal to zero, adjust ovi1 to functional value
    if sum(ovlap)==0
        ovi1=0;
    end
    %% evaluate overlap scenarios and recognize fast and slow attachment populations
    if ovi1==length(ovlap)
        % scenario of complete overlap
        nattf = sum(HtuNUMBER(1:ovi1));
        natts = 0;
    elseif sum(ovlap)==0
        %scenario where there is no overlap
        nattf = 0;
        natts = sum(HtuNUMBER);
    else
        %scenario of partial overlap
        nattf = sum(HtuNUMBER(1:ovi1));
        natts = sum(HtuNUMBER(ovi1+1:end));
    end
else
    % set ATTACHKau to empty
    ATTACHKau =[];
    % set number of slow and moving colloids to zero
    natts = 0;
    nattf = 0;
end
%% RFSP histogram
% get edges for RFSP bins 
nbins = 20;
if noRFSP==0
    minNear=min(TNEARr);
    maxNear=max(TNEARr);
    binfact= (maxNear/minNear)^(1/(nbins-1));
    edgesRFSP(1)=minNear;
    for i=2:nbins
        edgesRFSP(i)=edgesRFSP(i-1)*binfact;
    end
end
if noRFSP==0
    % if there is RFSP colloids generate histogram
    % assign objects to extract data from histograms for near surface colloid velocity calculations
    figure(3)
    %histogram (TNEARr,edgesRFSP,'FaceColor','b','Normalization','probability');
    Hr=histogram (TNEARr,edgesRFSP,'FaceColor','b','Normalization','probability');
    set(gca,'xscale','log'); xlabel('Near Surface Time (s)');
    ylabel('Frequency'); set(gca,'FontSize',15);legend('RFSP');
    HrPROB=Hr.Values; % use fraction only for colloid velocity calc.
end
%% extract number of colloids in every outcome
nsexit= sum(TNEAReu>0.0); % calculate number of exiting colloids with tnear>0.0 under unfavorable conditions
nsexitFAV= sum(TNEARef>0.0); % calculate number of exiting colloids with tnear>0.0 under favorable conditions
nattFAV = length(TTOTALaf); % calculate number of attached colloids under favorable conditions
if noRFSP==0
    nrfsp= length(ATTACHKr);
else
   nrfsp=0; 
end
natt=  length(ATTACHKau);
ntotal = nsexit+nrfsp+natt;
ntotalFAV = nsexitFAV+nattFAV;
%% calculate fractions relative to total injected across rlim
% normalize fraction to total injected under favorable
nsexitFAV_FRAC = nsexitFAV/ntotalFAV;
% denormalize fraction to unfavorable ntotal
nsexitFAV_NORM = nsexitFAV_FRAC*ntotal;
%
nsexitNORM=nsexit-nsexitFAV_NORM;
if nsexitNORM<0
   nsexitNORM=0;
end
% recalculate total number with nsexitFAV_NORM substracted
ntotalNORM = nsexitNORM+nrfsp+natt;
%% calculate fraccion of: fast attaching colloids (alpha1);
% slow attaching colloids (alpha2), RFSP colloids, and Reentrained colloids
alpha1 = nattf/ntotalNORM;
alpha2 = natts/ntotalNORM;
alphaRFSP = nrfsp/ntotalNORM;
alphaREENT = nsexitNORM/ntotalNORM;
check = alpha1+alpha2+alphaREENT+alphaRFSP;
%% calculate average near surface colloid velocity from flux files
% determine number of colloids with nonzero NSVEL
% stat counter 
nNS = 0;
for i=1:length(NSVELau)
   if NSVELau(i)>0.0
       nNS=nNS+1;
   end
end
for i=1:length(NSVELeu)
   if NSVELeu(i)>0.0
       nNS=nNS+1;
   end 
end
% calculate average near surface velocity
if nNS==0
    u2 = ((sum(NSVELau)+sum(NSVELeu))/nNS)*3600;
else
    u2 = 0.05*vpor;
end
%% calculate Happel single collector efficiency from favorable simulation
ninfav = length(ATTACHKaf)+length(ATTACHKef);
eta = length(ATTACHKaf)/(ninfav*b^2/rlimFAV^2);
end