function [par_cell1,par_cell2,par_cell3,par_cell4]=fpar_out_CorrEqs()
% globalinputs for single eta
global dciSE dpiSE viSE denpSE denfSE visfSE TSE ASE fSE  CeffSE
% intermediate parameters and dimensionless numbers for single eta
global NrSE NloSe NvdwSE NaSE NpeSE NgSE NgiSE 
% set globals for correlation equations output single eta
global etadrSE etairSE etagrSE etarSE %Rajogapalan and Tien 1976
global etadtSE etaitSE etagtSE etatSE  %Tufenkji and Elimelech 2004
global etadmSE etaimSE etagmSE etamSE  %Ma, Jhonson 2015
global etadlSE etailSE etaglSE etalSE  %Long and Hilpert 2011
global etadnSE etainSE etagnSE etanSE  %Nelson and Ginn 2011
% rate coefficients single eta
global kfrSE kftSE kfmSE kflSE kfnSE
%% build cell matrix for parameters output
par_cell1 = ...
{'Collector_diameter(mm)',dciSE;
'Colloid_diameter(um)',dpiSE;
'Pore_water_velocity(m/day)',viSE;
'Colloid_density(kg/m3)',denpSE;
'Fluid_density(kg/m3)',denfSE;
'Fluid_viscosity(kg-m/s)',visfSE;
'Temperature(K)',TSE;
'Hamaker_constant(J)',ASE;
'Porosity(-)',fSE;
'Attachment_efficienty(-)',CeffSE;};
%% build cell matrix for dimensionless numbers output
par_cell2 = ...
{'Nr',NrSE;
'Nlo',NloSe;
'Nvdw',NvdwSE;
'Na',NaSE;
'Npe',NpeSE;
'Ng',NgSE;
'Ngi',NgiSE;};
%% build cell matrix for etas output
par_cell3 = ...
{'Authors','Total','Diffusion','Interception','Gravity';
'Rajogapalan_and_Tien_1976',etarSE,etadrSE,etairSE,etagrSE;
'Tufenkji_and_Elimelech_2004',etatSE,etadtSE,etaitSE,etagtSE;
'Ma,Pedel,Fife&Johnson_2015',etamSE,etadmSE,etaimSE,etagmSE;
'Long_and_Hilpert_2011',etalSE,etadlSE,etailSE,etaglSE;
'Nelson_and_Ginn_2011',etanSE,etadnSE,etainSE,etagnSE;};
%% build cell matrix for kfs output
par_cell4 = ...
{'Authors','kf(1/s)',;
'Rajogapalan_and_Tien_1976',kfrSE;
'Tufenkji_and_Elimelech_2004',kftSE;
'Ma,Pedel,Fife&Johnson_2015',kfmSE;
'Long_and_Hilpert_2011',kflSE;
'Nelson_and_Ginn_2011',kfnSE;};
end