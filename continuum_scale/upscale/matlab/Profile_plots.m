%Profile_plots
close all; clear edgesPROF binsPROF edgesBTC bisnBTC;
%% plot histograms and extract data
global Co_input
%% calculate Co
Co = npart/(vpor*pulse_time*pi*(dcol/2)^2*por);

%% set edges for histograms across column length
edgesPROF = 0:xmax/20:xmax;
% calculate bin centers
for i=1:length(edgesPROF)-1
    binsPROF(i)=(edgesPROF(i)+edgesPROF(i+1))/2;
end
% retained colloid profiles (attached, near surface, aqueous)
figure (4)
histDATT=histogram (DATTpart_loc,edgesPROF,'FaceColor','b');
set(gca,'yscale','log');
 xlabel('Distance (m)');ylabel('Number/Section');hold on
histDNES=histogram (DNESpart_loc,edgesPROF,'FaceColor','r');
histDAQF=histogram (DAQFpart_loc,edgesPROF,'FaceColor','g');
%% scale retained profiles to Co_input
numDATT=histDATT.Values*Co_input/Co;
numDNES=histDNES.Values*Co_input/Co;
numDAQF=histDAQF.Values*Co_input/Co;
close(figure(4));
%% plot retention profiles
% figure (4)
% plot (binsPROF,numDATT,'.-r','MarkerSize',12,'LineWidth',2 )
% set(gca,'yscale','log'); xlabel('Distance (m)');ylabel('Number/Section');hold on
% hold on;
% plot (binsPROF,numDNES,'.-m','MarkerSize',12,'LineWidth',2 )
% plot (binsPROF,numDAQF,'.-r','MarkerSize',12,'LineWidth',2 )
% legend('Attached','Near Surface','Aqueous'); set(gca,'FontSize',15)
%% plot retention histograms
figure (4)
RETAINbars = [numDATT;numDNES;numDAQF]';
barfig=bar(binsPROF,RETAINbars,1);
set(gca,'yscale','log'); xlabel('Distance (m)');ylabel('Number');hold on
barfig(1).FaceColor = 'r';barfig(2).FaceColor = 'g';barfig(1).FaceColor = 'b';
legend('Attached','Near Surface','Aqueous'); set(gca,'FontSize',15)


%% BTC
edgesBTC = tzero:ttime/40:ttime;
figure(5)
histbtc = histogram (Texit_time,edgesBTC,'FaceColor','b');
set(gca,'yscale','log'); xlabel('time (hr)');
ylabel('Number'); set(gca,'FontSize',15)
hBTC=histbtc.Values;
close(figure(5));
% calculate bin centers
for i=1:length(edgesBTC)-1
    binsBTC(i)=(edgesBTC(i)+edgesBTC(i+1))/2;
end
% calculate Co
Co = npart/(pulse_time*vpor*pi*(dcol/2)^2*por);
% calculate volume of water corresponding to each bin
for i=1:length(edgesBTC)-1
    timesBTC(i)=edgesBTC(i+1)-edgesBTC(i);
end
% calculate concentration at each bin
concBTC=hBTC./(timesBTC*vpor*pi*(dcol/2)^2*por);

figure (5)
plot (binsBTC,concBTC./Co,'.-b','MarkerSize',12,'LineWidth',2 )
set(gca,'yscale','log'); xlabel('time (hr)');
ylabel('C/Co'); legend('BTC');set(gca,'FontSize',15)
hold on

