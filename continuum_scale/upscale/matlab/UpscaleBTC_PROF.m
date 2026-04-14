%% UpscaleBTC_PROF - profiles calculation
function [concBTCnorm,numDATTF,numDATTS,numDNES,numDAQF,binsBTC,binsPROF]=UpscaleBTC_PROF (npart,ttime,delta_t,dispersivity, xmax, dcol, vpor,v2, pulse_time)
%% set global variables to pass to BTX and retained profile calculation
global alpha1 alpha2 alphaRFSP alphaREENT  kf kf2 kns kf2star 
global Co_input por
global part_kf part_kns part_loc part_status exit_time
global c sf ss r n
global NSIND dx BTC_points
tic
% start progress bar
pbar = waitbar(0,'Simulating colloid transport in column..');
%% option to overwrite variables if user=1 (for developer test only)
user = 0;
if user==1
    alpha1=0.00269;
    alpha2=0.00537;
%    alphaRFSP=0.0267;
    alphaRFSP=0.03602;
    alphaREENT=0.953;
    alphaTrans=0.0;
    v2=0.004;
    kf=7.043;
    kf2=0.00099;
%    kns = 0.00;
    kns=0.0375;
    kf2star=0.0275;
end
%% set input parameters
% number of particles to simulate
% npart = 50000;  
% % total time (hr)
% ttime = 12;
% % spacial step (m)
% dx=0.02;
% % time step (hr)
% delta_t=0.01;
% % dispersivity (m)  
% dispersivity=0.0014;
% % set length of the system (m)
% xmax = 0.2;
% % set column diameter (m)
% dcol = 0.0381;
% % average pore water velocity (m/hr)
% vpor = 0.1667;
% % fraction of colloid population with non-zero fast kf (1/hr)
 kf_flag = alpha1;
% % rectangular pulse injection period (hr)
% pulse_time = 3.58;
% Co to be represented by npart
% Co_input = 1e6;
%% number of time steps simulated
ntimes = round(ttime/delta_t);
%% select near surface domain representation implicit (0) explicit (1)
% NSIND is fed from GUI and depends on checkbox user decision
% Option to set NSIND here
%   NSIND = 1
%% Scale rate constants by the time step  
kfprob= kf*delta_t;
kf2prob = kf2*delta_t;
knsprob = kns*delta_t;
kf2starprob = kf2star*delta_t;
%% Randomd number seed initialized  based on clock
% rng('shuffle'); 
rng('default');
%% part_status(j) values:
%0 = aqueous
%1 = attached fast
%2 =  attached slow
%-5 through -10 = particle has passed gates
%-3 = near surface
%-2 = exited
%% initialize particle kfs (probability)
part_kf=zeros(1,npart);
part_kns=zeros(1,npart);
%% ------------------------------------------------------------
if NSIND ==0
    % Fill kf Array for Implicit Near Surface (2 kfs)
    for i = 1: npart
    if(rand<=kf_flag) 
        rtmp=kfprob;
    else
        rtmp=kf2prob;
    end
    part_kf(i) = rtmp;
    % 	WRITE(33,*) part_kf(i)/delta_t
    end
else
    % Fill kf and kns arrays for Explicit Near Surface
    %   CALL init_random_seed()
     for i=1:npart
        if(rand<=kf_flag) % assign non-zero kf to kf_flag fraction
            part_kf(i)=kfprob;
            part_kns(i)=0.0;
        else   
            part_kf(i)=0.0;
            % assign non-zero kns to kns fraction of non-kf fraction
            part_kns(i)=knsprob;
        end
        %WRITE(32,*) part_kf(i)/delta_t
        %WRITE(33,*) part_kns(i)/delta_t
     end
end
%%
% WRITE(6,*) '  ..Pulse injection of length = ',pulse_time
ntinj = floor(pulse_time/delta_t) + 1;
% WRITE(6,*) '        (',ntinj,' time steps)'
dt = pulse_time/npart;
% initilize arrays
part_status =zeros(1,npart);
part_loc =zeros(1,npart);
for cd=1:6 %set exit time matrix to zeros
	for j=1:npart
		exit_time(j,cd)=NaN;
        Texit_time(j,cd)=NaN;
    end
end	
part_start = zeros(1,npart);
for i=2:npart
    part_start(i) = part_start(i-1)+dt;
end
% initial time
tzero = 0.0;
%% initialize output arrays
%fast attached particles across column
DATTFpart_status=NaN(1,npart);
DATTFpart_loc=NaN(1,npart);
DATTFpart_start=NaN(1,npart);
DATTFpart_kf=NaN(1,npart);
DATTFpart_kns=NaN(1,npart);
%slow attached particles across column
DATTSpart_status=NaN(1,npart);
DATTSpart_loc=NaN(1,npart);
DATTSpart_start=NaN(1,npart);
DATTSpart_kf=NaN(1,npart);
DATTSpart_kns=NaN(1,npart);
%aqueous phase particles across column
DAQFpart_status=NaN(1,npart);
DAQFpart_loc=NaN(1,npart);
DAQFpart_start=NaN(1,npart);
DAQFpart_kf=NaN(1,npart);
DAQFpart_kns=NaN(1,npart);
%Near surface particles across column
DNESpart_status=NaN(1,npart);
DNESpart_loc=NaN(1,npart);
DNESpart_start=NaN(1,npart);
DNESpart_kf=NaN(1,npart);
DNESpart_kns=NaN(1,npart);
%%  Perform particle simulation
inflag = 0;
pint = ntimes/20;
% Open time loop
for i=1:ntimes
    %update progress bar
    waitbar(i/ntimes)
    xtime = tzero + i*delta_t;
    itest = i/pint;
    itest = itest*pint;
    if (itest==i)
       display (i,'Time step ');
    end
  %  Advect particles with macroscopic velocity
%
    for j=1:npart % open particle loop 1
        if (xtime>=part_start(j))
            vxmod=vpor;
            if NSIND == 1 %For Explicit Near Surface
                if part_status(j)==-3 
                 vxmod=v2;
                end 
            end
            %
            if part_status(j)==0||part_status(j)==-3
                part_loc(j) = part_loc(j) + (vxmod*delta_t);
                vmagn = vxmod;
                dlong=disperse(vmagn,dt,dispersivity);
                part_loc(j) = part_loc(j) + dlong;
                %      Can allow particle to leave upstream end in this case
                if part_loc(j)<=0.0 
                    part_loc(j) = 0.0;
                end
                %Check exit at five locations located geometrically upstream from xmax     
                for cd=1:6
					xcheck=xmax/(2^(6-cd));
                    % save xcheck distances to vector
                    xBTC(cd)=xcheck;
					if isnan(exit_time(j,cd))
						if part_loc(j)>=xcheck  %particle has crossed xcheck
							exit_time(j,cd) = tzero + i*delta_t;
                            if xcheck>=xmax
                                part_status(j)=-2;
                            end
						end
					end
				end
				%end check exit
            end
        end
    end % close particle loop 1
%  reseting particle status counters
    naqueous = 0;
    nattfast = 0;
    nattslow = 0;
    nexited = 0;
    nentered = 0;
    nnearsurf = 0;
%
    for j=1:npart % open particle loop 2
        if xtime>=part_start(j) 
            nentered = nentered + 1;
        end
    end % close particle loop 2
  
    if inflag==0 
        if nentered==npart
            disp ('all particles have entered the system');
            inflag=1;
        end
    end
%  
    for j = 1:npart % open particle loop 3
        %% check rate constant to transfer particles between domains
        if xtime>=part_start(j) % active particle
            if NSIND ==0 % implicit near surface
                if part_status(j)==0 % aqueous particle
                    if rand<=part_kf(j) % trial for fast or slow attachment
                        %
                         if  part_kf(j)==kfprob
                            part_status(j)=1; % fast attached particle 
                         end
                         if  part_kf(j)==kf2prob
                            part_status(j)=2; % slow attached particle 
                         end
                    end
                end     
            end % end of implicit near surface
			if NSIND ==1 % explicit near surface
				if part_status(j)==-3
					if(rand<=kf2starprob)   %trial for slow attachment from near surface 
						part_status(j)=2;
					end 				
				end                
				if part_status(j)==0 % aqueous particle
                    rand1=rand;
					if rand1<=part_kf(j)   % trial for fast attachment
						part_status(j)=1; % particle becomes attached 
					end
					if part_status(j)==0 % if particle remained aqueous 
						if rand1<=part_kns(j)   % continued trial to enter near surface only significant to slow attachers
							part_status(j)=-3; % slow particle enters near surface
							if(rand<=kf2starprob)   % trial for slow attachment 
								part_status(j)=2; % particle becomes attached 
							end % end slow attachment trial
						end % end near surface trial
					end
				end
			end % end of explicit near surface
        end % end of active particle
        %% check particle status    
        if part_status(j)==-2 %count only those past xmax 
            nexited = nexited + 1;
        end
        if part_status(j)==0 
            naqueous = naqueous + 1;
        end
        if part_status(j)==1 % fast attachment
            nattfast = nattfast + 1;
        end
        if part_status(j)==2 % slow attachment
            nattslow = nattslow + 1;
        end        
        if part_status(j)==-3 
            nnearsurf = nnearsurf + 1;
        end
    end % close particle loop 3
  c = naqueous/nentered;
  sf = nattfast/nentered;
  ss = nattslow/nentered;
  r = nexited/nentered;
  n = nnearsurf/nentered;
end % close time loop
%%  Write out locations of fast attached particles
k=1;  
for i=1:npart  
  if part_status(i)==1 
      DATTFpart_status(k)=part_status(i);
      DATTFpart_loc(k)=part_loc(i);
      DATTFpart_start(k)=part_start(i);
      DATTFpart_kf(k)=part_kf(i);
      DATTFpart_kns(k)=part_kns(i);
      k=k+1;
  end
end
%%  Write out locations of slow attached particles
k=1;  
for i=1:npart  
  if part_status(i)==2 
      DATTSpart_status(k)=part_status(i);
      DATTSpart_loc(k)=part_loc(i);
      DATTSpart_start(k)=part_start(i);
      DATTSpart_kf(k)=part_kf(i);
      DATTSpart_kns(k)=part_kns(i);
      k=k+1;
  end
end

%%  Write out locations of aqueous particles
k=1;
for i = 1: npart
  if part_status(i)==0 
      DAQFpart_status(k)=part_status(i);
      DAQFpart_loc(k)=part_loc(i);
      DAQFpart_start(k)=part_start(i);
      DAQFpart_kf(k)=part_kf(i);
      DAQFpart_kns(k)=part_kns(i);
      k=k+1;
  end
end
%%  Write out locations of near surface particles
k=1;
for i = 1: npart
  if part_status(i)==-3 
      DNESpart_status(k)=part_status(i);
      DNESpart_loc(k)=part_loc(i);
      DNESpart_start(k)=part_start(i);
      DNESpart_kf(k)=part_kf(i);
      DNESpart_kns(k)=part_kns(i);
      k=k+1;
  end
end
%% Write out non-zero exit times of actually exited particles
for cd=1:6
	k(cd)=1;
	for i = 1: npart
	  Texit_time(k,cd)=exit_time(i,cd);
	  k(cd)=k(cd)+1;
	end
end
%%
waitbar(1)
close(pbar) 
disp ('Completed: Retained profile and BTC profile simulations ')
toc

%% plot histograms and extract data
% close previusly existing retained profile and BTC
close (figure(4));
close (figure(5));
%% plot histograms and extract data
%% calculate Co
Co = npart/(vpor*pulse_time*pi*(dcol/2)^2*por);

%% set edges for histograms across column length
ndx = round(xmax/dx);
if ndx<3
    ndx = 3; 
    dx =xmax/ndx;
end

edgesPROF = 0:xmax/ndx:xmax;
for i=1:length(edgesPROF)-1
    binsPROF(i)=(edgesPROF(i)+edgesPROF(i+1))/2;
end
% retained colloid profiles (attached, near surface, aqueous)
figure (4)
histDATTF=histogram (DATTFpart_loc,edgesPROF,'FaceColor','r');
hold on;
histDATTS=histogram (DATTSpart_loc,edgesPROF,'FaceColor','m');
set(gca,'yscale','log');
 xlabel('Distance (m)');ylabel('Number/Section');
histDNES=histogram (DNESpart_loc,edgesPROF,'FaceColor','g');
histDAQF=histogram (DAQFpart_loc,edgesPROF,'FaceColor','b');
%% scale retained profiles to Co_input
% add fast and slow attached and near surface and aqueous counts
numRET = (histDATTF.Values+histDATTS.Values+histDNES.Values+histDAQF.Values)*Co_input/Co;
numDATTF=histDATTF.Values*Co_input/Co;
numDATTS=histDATTS.Values*Co_input/Co;
numDNES=histDNES.Values*Co_input/Co;
numDAQF=histDAQF.Values*Co_input/Co;
close(figure(4));
%% plot retention profiles
% figure (4)
% plot (binsPROF,numDATTF,'.-r','MarkerSize',12,'LineWidth',2 )
% set(gca,'yscale','log'); xlabel('Distance (m)');ylabel('Number/Section');hold on
% hold on;
% plot (binsPROF,numDNES,'.-m','MarkerSize',12,'LineWidth',2 )
% plot (binsPROF,numDAQF,'.-r','MarkerSize',12,'LineWidth',2 )
% legend('Attached','Near Surface','Aqueous'); set(gca,'FontSize',15)
%% plot retention histograms
figure (4)
subplot(1,2,2)
RETAINbars = [numDATTF;numDATTS;numDNES;numDAQF]';
ymax = 10*max(numRET);
% if no colloids retained set a default max value
if ymax<1.0
    ymax = 1;
end
%
ymin = 0.1;
barfig=bar(binsPROF,RETAINbars,1);
ylim([ymin ymax])
set(gca,'yscale','log'); xlabel('Distance (m)');ylabel('Number');hold on
barfig(1).FaceColor = 'r';barfig(2).FaceColor = 'm';barfig(3).FaceColor = 'g';barfig(4).FaceColor = 'b';
legend('Attached Fast','Attached Slow','Near Surface','Aqueous'); set(gca,'FontSize',15)

subplot(1,2,1)
RETAINbars = [numDATTF;numDATTS;numDNES;numDAQF]';
barfig=bar(binsPROF,RETAINbars,'stacked','BarWidth',0.5);
ylim([ymin ymax])
set(gca,'yscale','log'); xlabel('Distance (m)');ylabel('Number');hold on
barfig(1).FaceColor = 'r';barfig(2).FaceColor = 'm';barfig(3).FaceColor = 'g';barfig(4).FaceColor = 'b';
legend('Attached Fast','Attached Slow','Near Surface','Aqueous'); set(gca,'FontSize',15)





%% BTC
% define BTCs format
fBTC= [{'.-b'},{'.-r'},{'.-g'},{'.-m'},{'.-c'},{'.-k'}];
for cd=1:6
	edgesBTC = tzero:ttime/(2*BTC_points):ttime;
	figure(11)
	histbtc = histogram (Texit_time(:,cd),edgesBTC,'FaceColor','b');
	set(gca,'yscale','log'); xlabel('time (hr)');
	ylabel('Number'); set(gca,'FontSize',15)
	hBTC(:,cd)=histbtc.Values;
	close(figure(11));
	% calculate bin centers
	for i=1:length(edgesBTC)-1
		binsBTC(i)=(edgesBTC(i)+edgesBTC(i+1))/2;
	end
	% calculate Co
	Co = npart/(vpor*pulse_time*pi*(dcol/2)^2*por);
	% calculate volume of water corresponding to each bin
	for i=1:length(edgesBTC)-1
		timesBTC(i,cd)=edgesBTC(i+1)-edgesBTC(i);
	end
	% calculate concentration at each bin
	concBTC(:,cd)=hBTC(:,cd)./(timesBTC(:,cd)*vpor*pi*(dcol/2)^2*por);
	concBTCnorm(:,cd) =concBTC(:,cd)./Co; 
	figure (5)
    fname(cd) = xBTC(cd);   
	plot (binsBTC,concBTCnorm(:,cd),char(fBTC(cd)),'MarkerSize',12,'LineWidth',2 )
	set(gca,'yscale','log'); xlabel('time (hr)');
	ylabel('C/Co'); set(gca,'FontSize',15);
    hold on
end
figure(5)
legend(strcat(num2str(fname(1)),'m'),strcat(num2str(fname(2)),'m'),strcat(num2str(fname(3)),'m'),...
    strcat(num2str(fname(4)),'m'),strcat(num2str(fname(5)),'m'),strcat(num2str(fname(6)),'m'),...
    'Location','south')

