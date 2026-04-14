%test code for colorcode trajectories
clc; clear; close all;

%% create dummy vectors for output
x =0:0.01:100;
%create zeros y vector
y=zeros(1,length(x));
h=1./exp(x);
z=h+1.0e-6;
% set figure number
nfig=1;
%% cal  color coded trajectory function  
colorcodeH(x,y,z,h,nfig)