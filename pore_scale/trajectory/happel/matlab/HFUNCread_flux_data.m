function HFUNCread_flux_data(filename1,filename2)
global NPARTPERT NPARTatt NPARTrem ATTACHKP XOUTP YOUTP ZOUTP ROUTP HOUTP JP
%% import load flux data from attachment and remaining flux files
[NPARTfluxATT,ATTACHKfluxATT,XINITm1,YINITm1,RINJm1,ZINITm1,RINITm1,HINITm1,XOUTm1,YOUTm1,ZOUTm1,ROUTm1,HOUTm1] = import_load_flux_data(filename1);
[NPARTfluxREM,ATTACHKfluxREM,XINITm2,YINITm2,RINJm2,ZINITm2,RINITm2,HINITm2,XOUTm2,YOUTm2,ZOUTm2,ROUTm2,HOUTm2] = import_load_flux_data(filename2);
%% check arrays and extract valid loading flux data
%check if empty and show warning, get different attachk populations
% discriminate to obtain only attachk 2 and 4 from ATT and REM flux files
% respectively
% ATTACHK1=EXIT
% ATTACHK2=ATTACHED-BY-PERFECT-SINK-OR-TORQUE
% ATTACHK3=REMAINING-UNRESOLVED-WHEN-SIMULATION-ENDS
% ATTACHK4=TORQUE-WITH-SLOW-MOTION
% ATTACHK5=IN-NEAR-SURFACE-WITH-SLOW-MOTION
% ATTACHK6=CRASHED
%% set swicth to extract all particles except crashed to perturbation
% extract_all: 1  Extracts attachk 2 3 4 5
% extract_all: 0  Extracts attachk 2 4 
% extract_all =1;
%initialize index vectors as scalars
indATTACHK2=0.0;
indATTACHK3=0.0;
indATTACHK4=0.0;
indATTACHK5=0.0;
indATTACHK6=0.0;
if isempty(NPARTfluxATT)
    m=warndlg('no ATTACHED colloids in ATTflux file','Warning');
    waitfor(m);
else
    indATTACHK2=ATTACHKfluxATT==2;
    indATTACHK4=ATTACHKfluxATT==4;
    indATTACHK6=ATTACHKfluxATT==6;
end
if isempty(NPARTfluxREM)
    m=warndlg('no SLOW MOTION colloids in REMflux file','Warning');
    waitfor(m);
else
    indATTACHK3=ATTACHKfluxREM==3;
    indATTACHK5=ATTACHKfluxREM==5;
end
%% extract loading particles
%% process arrays to extract all attachk 2 3 4 5 loading particles for perturbation
%reset particle number counters
NPARTatt2 = 0; NPARTatt3 = 0; NPARTatt4 = 0; NPARTatt5 = 0;  NPARTatt6=0;
% start index
n=0;
if sum(indATTACHK2)>0
    NPARTatt2=sum(indATTACHK2);
    for i=1:length(indATTACHK2)
        if indATTACHK2(i)==1
            n=n+1; 
            ATTACHKP(n)=ATTACHKfluxATT(i);
            XOUTP(n)=XOUTm1(i);
            YOUTP(n)=YOUTm1(i);
            ZOUTP(n)=ZOUTm1(i);
            ROUTP(n)=ROUTm1(i);
            HOUTP(n)=HOUTm1(i);
            JP(n)=NPARTfluxATT(i);
        end
    end
end
if sum(indATTACHK3)>0
    NPARTatt3=sum(indATTACHK3);
    for i=1:length(indATTACHK3)
        if indATTACHK3(i)==1
            n=n+1; 
            ATTACHKP(n)=ATTACHKfluxREM(i);
            XOUTP(n)=XOUTm2(i);
            YOUTP(n)=YOUTm2(i);
            ZOUTP(n)=ZOUTm2(i);
            ROUTP(n)=ROUTm2(i);
            HOUTP(n)=HOUTm2(i);
            JP(n)=NPARTfluxREM(i);
        end
    end    
end
if sum(indATTACHK4)>0
    NPARTatt4=sum(indATTACHK4);
    for i=1:length(indATTACHK4)
        if indATTACHK4(i)==1
            n=n+1; 
            ATTACHKP(n)=ATTACHKfluxATT(i);
            XOUTP(n)=XOUTm1(i);
            YOUTP(n)=YOUTm1(i);
            ZOUTP(n)=ZOUTm1(i);
            ROUTP(n)=ROUTm1(i);
            HOUTP(n)=HOUTm1(i);
            JP(n)=NPARTfluxATT(i);
        end
    end    
end
if sum(indATTACHK5)>0
    NPARTatt5=sum(indATTACHK5);
    for i=1:length(indATTACHK5)
        if indATTACHK5(i)==1
            n=n+1; 
            ATTACHKP(n)=ATTACHKfluxREM(i);
            XOUTP(n)=XOUTm2(i);
            YOUTP(n)=YOUTm2(i);
            ZOUTP(n)=ZOUTm2(i);
            ROUTP(n)=ROUTm2(i);
            HOUTP(n)=HOUTm2(i);
            JP(n)=NPARTfluxREM(i);
        end
    end    
end
% integrate number of particles to be used in perturbation mode
NPARTatt = NPARTatt2+NPARTatt4;
NPARTrem = NPARTatt3+NPARTatt5;
NPARTPERT = NPARTatt+NPARTrem;
%% alert user if there is crashed particles in loaded data
% count particles crashed
if sum(indATTACHK6)>0
    ncrashed = sum(indATTACHK6);
    % warning message
    ncrashedSTR = num2str(ncrashed);
    ncrashedSTR =  strcat(ncrashedSTR,'_crashed colloids ignored in perturbation, sep. dist. undefined ');
    m=warndlg(ncrashedSTR,'Warning'); 
    waitfor(m);
end
end


% if extract_all == 0
%     %% process arrays to extract only attachk 2 and 4 loading particles for perturbation
%     %reset particle number counters
%     NPARTatt = 0;
%     NPARTrem = 0;
%     % start index
%     n=0;
%     if sum(indATTACHK2)>0
%         NPARTatt=sum(indATTACHK2);
%         for i=1:length(indATTACHK2)
%             if indATTACHK2(i)==1
%                 n=n+1; 
%                 ATTACHKP(n)=ATTACHKfluxATT(i);
%                 XOUTP(n)=XOUTm1(i);
%                 YOUTP(n)=YOUTm1(i);
%                 ZOUTP(n)=ZOUTm1(i);
%                 ROUTP(n)=ROUTm1(i);
%                 HOUTP(n)=HOUTm1(i);
%             end
%         end
%     end
%     if sum(indATTACHK4)>0
%         NPARTrem=sum(indATTACHK4);
%         for i=1:length(indATTACHK4)
%             if indATTACHK4(i)==1
%                 n=n+1; 
%                 ATTACHKP(n)=ATTACHKfluxREM(i);
%                 XOUTP(n)=XOUTm2(i);
%                 YOUTP(n)=YOUTm2(i);
%                 ZOUTP(n)=ZOUTm2(i);
%                 ROUTP(n)=ROUTm2(i);
%                 HOUTP(n)=HOUTm2(i);
%             end
%         end    
%     end
%     NPARTPERT = NPARTatt+NPARTrem;
% else
%    %% process arrays to extract all attachk 2 3 4 5 loading particles for perturbation
%    %reset particle number counters
%     NPARTatt2 = 0; NPARTatt3 = 0; NPARTatt4 = 0; NPARTatt5 = 0;  NPARTatt6=0;
%     % start index
%     n=0;
%     if sum(indATTACHK2)>0
%         NPARTatt2=sum(indATTACHK2);
%         for i=1:length(indATTACHK2)
%             if indATTACHK2(i)==1
%                 n=n+1; 
%                 ATTACHKP(n)=ATTACHKfluxATT(i);
%                 XOUTP(n)=XOUTm1(i);
%                 YOUTP(n)=YOUTm1(i);
%                 ZOUTP(n)=ZOUTm1(i);
%                 ROUTP(n)=ROUTm1(i);
%                 HOUTP(n)=HOUTm1(i);
%             end
%         end
%     end
%     if sum(indATTACHK3)>0
%         NPARTatt3=sum(indATTACHK3);
%         for i=1:length(indATTACHK3)
%             if indATTACHK3(i)==1
%                 n=n+1; 
%                 ATTACHKP(n)=ATTACHKfluxREM(i);
%                 XOUTP(n)=XOUTm2(i);
%                 YOUTP(n)=YOUTm2(i);
%                 ZOUTP(n)=ZOUTm2(i);
%                 ROUTP(n)=ROUTm2(i);
%                 HOUTP(n)=HOUTm2(i);
%             end
%         end    
%     end
%     if sum(indATTACHK4)>0
%         NPARTatt4=sum(indATTACHK4);
%         for i=1:length(indATTACHK4)
%             if indATTACHK4(i)==1
%                 n=n+1; 
%                 ATTACHKP(n)=ATTACHKfluxREM(i);
%                 XOUTP(n)=XOUTm2(i);
%                 YOUTP(n)=YOUTm2(i);
%                 ZOUTP(n)=ZOUTm2(i);
%                 ROUTP(n)=ROUTm2(i);
%                 HOUTP(n)=HOUTm2(i);
%             end
%         end    
%     end
%     if sum(indATTACHK5)>0
%         NPARTatt5=sum(indATTACHK5);
%         for i=1:length(indATTACHK5)
%             if indATTACHK5(i)==1
%                 n=n+1; 
%                 ATTACHKP(n)=ATTACHKfluxREM(i);
%                 XOUTP(n)=XOUTm2(i);
%                 YOUTP(n)=YOUTm2(i);
%                 ZOUTP(n)=ZOUTm2(i);
%                 ROUTP(n)=ROUTm2(i);
%                 HOUTP(n)=HOUTm2(i);
%             end
%         end    
%     end
%     NPARTatt = NPARTatt2;
%     NPARTrem = NPARTatt3+NPARTatt4+NPARTatt5;
%     NPARTPERT = NPARTatt+NPARTrem;
% end

