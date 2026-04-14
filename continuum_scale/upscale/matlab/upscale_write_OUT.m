%write RETAINED AND EXITED
function upscale_write_OUT (concBTCnorm,numDATTF,numDATTS,numDNES,numDAQF,binsBTC,binsPROF)
global ap ag vporOUT vnsOUT vgmOUT alphaTransgg alphaTransbg eta asp asp2
global apOUT_FLAG
global c sf ss r n
global outputdir npart part_kf part_kns part_loc part_status exit_time
global alpha1 alpha2 alphaRFSP alphaREENT kf kf2 kns kf2star 
global  ttime dx delta_t dispersivity xmax dcol pulse_time Co_input por
global  HtfNUMBER HtuNUMBER HnfNUMBER HnuNUMBER edgesNear edgesTotal restime
% calculate total mass balance fraction
t = c+sf+ss+r+n;
%   c = naqueous/nentered;
%   sf = nattfast/nentered;
%   ss = nattslow/nentered;
%   r = nexited/nentered;
%   n = nnearsurf/nentered;

%% set filenames with paths
retained = strcat(outputdir,'Retained.txt')
exited = strcat(outputdir,'Exited.txt')
param = strcat(outputdir,'Sim_Parameters.txt')
BTC = strcat(outputdir,'BTC_histogram.txt')
PROF = strcat(outputdir,'RETAINED_histogram.txt')
% retPROF =strcat(outputdir,'Retention_Profile.txt');
% BTC =strcat(outputdir,'BTC.txt');
%% open files
retOUT = fopen(retained,'w');
exitOUT = fopen(exited,'w');
parOUT = fopen(param,'w');
btcOUT = fopen(BTC,'w');
profOUT = fopen(PROF,'w');
%% Set formats and  Write Headers for BTC and prof
% retained flux
format101 =[' part_status     part_loc(m)     part_kf(hr-1)     part_kns(hr-1) \r\n'];     
fprintf(retOUT,format101);
format102=[' %8d %8d %15.8E %15.8E  \r\n'];
% exited flux
format201 =[' part_status    exitdist(m)     exit_time(hr)     part_kf(hr-1)     part_kns(hr-1) \r\n'];     
fprintf(exitOUT,format201);
format202=[' %8d  %15.8E %15.8E %15.8E %15.8E  \r\n'];
%% write data to files
for cd=1:6
    xdist(cd)=xmax/(2^(6-cd));
	for i=1:npart
		if ~isnan(part_status(i))
			if part_status(i)==-2 % if particle exited
				  fprintf(exitOUT,format202,part_status(i),xdist(cd),exit_time(i,cd),part_kf(i),part_kns(i));       
			else % if particle is retained
				  fprintf(retOUT,format102,part_status(i),part_loc(i),part_kf(i),part_kns(i));  
			end
		end
	 
	end
end
%% Set formats and  Write parameters used for BTC and profile simulation
fprintf(parOUT,'********************_Pore_Scale_Parameters_********************\r\n');
fprintf(parOUT,' \r\n');
format31 =[' Colloid_radius(m)     Collector_radius(m)     Porosity(-)\r\n'];     
fprintf(parOUT,format31);
if apOUT_FLAG==1
    format32 =' %15.8E %15.8E %15.8E\r\n';
    fprintf(parOUT,format32,ap,ag,por); 
else
    format321 =[' N/A             %15.8E %15.8E\r\n'];
    fprintf(parOUT,format321,ag,por);     
end 
format34 =[' Favorable_Conditions_Single_Collector_efficiency(-)     RMS_roughness(m)     Roughness_lever_arm_for_contact(m)\r\n'];     
fprintf(parOUT,format34);

if  apOUT_FLAG==1
    format35 =[' %15.8E            %15.8E            %15.8E\r\n'];
    fprintf(parOUT,format35,eta,asp,asp2);
else
    format351 = [' %15.8E           N/A            N/A \r\n'];
    fprintf(parOUT,format351,eta);
end
format35 =[' Average_pore_water_velocity(m/hr)     Average_near_surface_water_velocity(m/hr)     Geometric_mean_water_velocity(m/hr)\r\n'];     
fprintf(parOUT,format35);
format36 =[' %15.8E            %15.8E            %15.8E\r\n'];
fprintf(parOUT,format36,vporOUT,vnsOUT,vgmOUT); 
fprintf(parOUT,' \r\n');
fprintf(parOUT,' \r\n');
% sim parameters output
fprintf(parOUT,'********************_Continuum_Simulation_Parameters_********************\r\n');
fprintf(parOUT,' \r\n');
format301 =[' Number_of Colloids(#)     Total_Sim_Time(hr)     Step_Injection_Period(hr)\r\n'];     
fprintf(parOUT,format301);
format302 =[' %8d %15.8E %15.8E\r\n'];
fprintf(parOUT,format302,npart,ttime,pulse_time); 
%
fprintf(parOUT,' \r\n');
format303 =[' Spatial_Step(m)           TimeStep(hr)            Column_Length(m)\r\n'];     
fprintf(parOUT,format303);
format304 =[' %15.8E %15.8E %15.8E\r\n'];
fprintf(parOUT,format304,dx,delta_t,xmax); 
%
fprintf(parOUT,' \r\n');
format305 =[' Column_Diameter(m)        Colloid_Inj_Conc(#/m3)    Dispersivity(m)\r\n'];     
fprintf(parOUT,format305);
format306 =[' %15.8E %15.8E %15.8E\r\n'];
fprintf(parOUT,format306,dcol,Co_input,dispersivity); 
%
fprintf(parOUT,' \r\n');
fprintf(parOUT,' \r\n');
fprintf(parOUT,'********************_Rate_Constants_and_Alphas_********************\r\n');
fprintf(parOUT,' \r\n');
format307 =[' kf(1/hr)        kf2(1/hr)       kns(1/hr)       kf2*(1/hr)\r\n'];     
fprintf(parOUT,format307);
format308 =[' %15.8E   %15.8E   %15.8E   %15.8E\r\n'];
fprintf(parOUT,format308,kf,kf2,kns,kf2star);
%
fprintf(parOUT,' \r\n');
format309 =[' alpha1(-)        alpha2(-)       alpha_RFSP(-)       alphaREENT(-)\r\n'];     
fprintf(parOUT,format309);
format310 =[' %15.8E %15.8E %15.8E %15.8E\r\n'];
fprintf(parOUT,format310,alpha1,alpha2,alphaRFSP,alphaREENT); 
%
fprintf(parOUT,' \r\n');
format311 =[' alphaTrans_gg(-)                 alphaTrans_bg(-)\r\n'];     
fprintf(parOUT,format311);
format312 =[' %15.8E                   %15.8E\r\n'];
fprintf(parOUT,format312,alphaTransgg,alphaTransbg); 
%
fprintf(parOUT,' \r\n');
fprintf(parOUT,' \r\n');
fprintf(parOUT,'********************_Column_Mass_Balance_********************\r\n');
fprintf(parOUT,' \r\n');
format307 =[' naqueous/nentered(-)        nattfast/nentered(-)       nattslow/nentered(-)       nexited/nentered(-)       nnearsurf/nentered(-)         Total(-)\r\n'];     
fprintf(parOUT,format307);
format308 =[' %15.8E          %15.8E          %15.8E           %15.8E          %15.8E          %15.8E\r\n'];
fprintf(parOUT,format308,c,sf,ss,r,n,t);
%   c = naqueous/nentered;
%   sf = nattfast/nentered;
%   ss = nattslow/nentered;
%   r = nexited/nentered;
%   n = nnearsurf/nentered;
%% write BTC histograms
format403 =[' C/Co@various distances (m) \r\n'];
format401 =['  time_bin(hr)  %15.8E %15.8E %15.8E %15.8E %15.8E %15.8E \r\n'];     
fprintf(btcOUT,format403);
fprintf(btcOUT,format401,xdist(1),xdist(2),xdist(3),xdist(4),xdist(5),xdist(6));
format402=[' %15.8E %15.8E %15.8E %15.8E %15.8E %15.8E %15.8E\r\n'];
[nr]=length(concBTCnorm);
for i=1:nr
    fprintf(btcOUT,format402,binsBTC(i),concBTCnorm(i,1),concBTCnorm(i,2),concBTCnorm(i,3),concBTCnorm(i,4),concBTCnorm(i,5),concBTCnorm(i,6));   
end
%% write RETAINED profile histograms
format501 =[' distance_bin(m)     number_attached_fast     number_attached_slow     number_near_surface     number_aqueous\r\n'];     
fprintf(profOUT,format501);
format502=[' %15.8E %15.8E %15.8E %15.8E %15.8E \r\n'];
for i=1:length(numDATTF)
    fprintf(profOUT,format502,binsPROF(i),numDATTF(i),numDATTS(i),numDNES(i),numDAQF(i));   
end
%% output residence time histograms data if these exist
if restime ==1
    % open files
    htotal = strcat(outputdir,'Histogram_residence_total.txt')
    hnsurf = strcat(outputdir,'Histogram_residence_time_near_surface.txt')
    htotOUT = fopen(htotal,'w');
    hnsOUT = fopen(hnsurf,'w');
    % formats
    format601=['**********Total residence time prior to attachment - histogram data***************'];
    format602=[' bin_lower_edge(s)     bin_upper_edge(s)     number_favorable     number_favorable\r\n'];     
    format603=[' %15.8E %15.8E %15.8E %15.8E\r\n'];
    format701=['**********Near surface residence time prior to attachment - histogram data********'];
    format702=[' bin_lower_edge(s)     bin_upper_edge(s)     number_favorable     number_favorable\r\n'];     
    format703=[' %15.8E %15.8E %15.8E %15.8E\r\n'];    
    %% write to file total res time histogram
    % create bin lower and upper edge vector
    loweredge = edgesTotal(1:end-1);
    upperedge = edgesTotal(2:end);
    % write title and header
    fprintf(htotOUT,format601);
    fprintf(htotOUT,format602);
    for i=1:length(HtfNUMBER)
        fprintf(htotOUT,format603,loweredge(i),upperedge(i),HtfNUMBER(i),HtuNUMBER(i));
    end
    %% write to file near surface res time histogram
    % create bin lower and upper edge vector
    loweredge = edgesNear(1:end-1);
    upperedge = edgesNear(2:end);
    % write title and header
    fprintf(hnsOUT,format701);
    fprintf(hnsOUT,format702);
    for i=1:length(HnfNUMBER)
        fprintf(hnsOUT,format703,loweredge(i),upperedge(i),HnfNUMBER(i),HnuNUMBER(i));
    end
end
%% close files
fclose('all');
end
