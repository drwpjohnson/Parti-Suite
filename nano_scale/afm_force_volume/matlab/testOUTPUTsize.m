clc; clear; close all;
mname = mfilename('fullpath');
outputpath = strrep(mname,'\testOUTPUTsize','\');
filename1 = 'outputAFM.xlsx';
filename2 = strcat(outputpath,filename1);
M = ones(1000,2500);
xlswrite(filename2,M,'M','A1');