function Hap_GUI_shell()
%shellcode to run traj_jet
% executed when run simulation button is pushed, generates input file from GUI fields and
% runs trajectory code
clc;
%% designate global variables
global NPART ATTMODE CLUSTER 
global VJET RLIM POROSITY AG REXIT TTIME VSUP
global AP RHOP RHOW VISC ER T
global IS ZI ZETAPST ZETACST 
global ZETAHET HETMODE RHET0 RHET1 RHET2 SCOV
global ZETAHETP HETMODEP RHETP0 RHETP1 SCOVP
global A132 LAMBDAVDW VDWMODE
global A11 AC1C1 A22 AC2C2 A33 T1 T2
global GAMMA0AB LAMBDAAB GAMMA0STE LAMBDASTE B RMODE ASP
global KINT W132 BETA DIFFSCALE GRAVFACT
global MULTB MULTNS MULTC DFACTNS DFACTC
global NOUT PRINTMAX
global INPUTNAME OUTDIR workdir finput 
global eta2 eta4 eta5 eta6 RB
global cbPZ cbMZ cbPX cbMX
global simplotCHECK detplotCHECK
% finput =' ';
% %% create directory to locate  input and output files
% %  create string from output directory  
% outs = strcat('\',OUTDIR,'\');
% % set working directory        
% if ~isdeployed
%     % MATLAB environment
%     workdir = strrep(mfilename('fullpath'),'\Jet_GUI_shell','\');
    %     mkdir(workdir,OUTDIR);
%     workdir = strrep(mfilename('fullpath'),'\Jet_GUI_shell',outs);
% else
%     %deployed application
%     workdir=pwd;
%     mkdir(workdir,OUTDIR);
%     workdir=strcat(workdir,outs);
% end
% %% create input file with parameters from jetGUI
% fin =strcat(INPUTNAME,'.txt'); 
% finput = strcat(workdir,fin);
jet =0; %switch to define jet input (jet=1) or happel (jet=0)
if jet==0
    REXIT = 0;
    VSUP =VJET;
end
    %%
f1 = fopen(finput,'w');
 
%% write input file
le='%';
l1 ='% Input for 3DJETLN and HAPHETLN';
l2 = '% Particle trajectory model for impinging jet utilizing linear approximation for heterogeneity calculation';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',le);
l1='% ********Simulation parameters (integer values)';
l2='% # of colloids		Perfect sink(0) or Contact(1) or Perturbation(-1) mode	        Single(0) or Parallel(1) simulation';
l3='% NPART			                    ATTMODE                                                    CLUSTER';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%4u %45u %55u \r\n',NPART,ATTMODE,CLUSTER);
fprintf(f1,'%s\r\n',le);
l1='% ********Flow and simulation geometry parameters (Continuum flow field applies for VJET<1.273 m/s)';
l2='% Fluid velocity   Injection radius        Happel porosity    Happel Collector Radius      Jet exit radius      Total simulation time';
l3='% VSUP(m/s)		RLIM(m)			POROSITY		AG(m)			REXIT(m)		TTIME(s)';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%10.3E      %15.3E          %15.3E         %15.3E         %15.3E           %15.3E\r\n',VJET,RLIM,POROSITY,AG,REXIT,TTIME);
fprintf(f1,'%s\r\n',le);
l1='% ********Colloid and fluid properties';
l2='% Colloid radius      Colloid density      Fluid density               Fluidviscosity    Relative permittivity       Temperature';
l3='% AP(m)			RHOP(kg/m3)		RHOW(kg/m3)		VISC(kg/m/s)		ER(-)			T(K)';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%10.3E        %15.3E          %15.3E         %15.3E        %15.3E          %15.3E\r\n',AP,RHOP,RHOW,VISC,ER,T);
fprintf(f1,'%s\r\n',le);
l1='% ********Water chemistry and surface charge parameters';
l2='% Ionic strength    Valence of electrolyte       Colloid zeta potential       Collector zeta potential';
l3='% IS(mol/m3)		ZI(-)				ZETAPST(V)			ZETACST(V)';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%10.3E        %15.3E                  %15.3E                %15.3E\r\n',IS,ZI,ZETAPST,ZETACST);
fprintf(f1,'%s\r\n',le);
l1='% ********Collector Heterogeneity parameters (set SCOV to 0.0 for no heterodomains,HETMODE: sum of numbers of small, medium and large heterodomains in each patch. HETMODE = 1  yields uniform sized large heterodomains HETMODE 5,9,73  yields 1:4 large:medium, 1:8 large:medium, and 1:8:64 large:medium:small, respectively';
l2='% Heterodomain zeta potential	# of het. per tile	Large het. radius   Medium het. radius      Small het. radius	Fractional surface coverage';
l3='% ZETAHET(V)			HETMODE			RHET0(m)		RHET1(m)		RHET2(m)		SCOV(-)';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%10.3E        %15u                 %15.3E         %15.3E         %15.3E        %15.3E\r\n',ZETAHET,HETMODE,RHET0,RHET1,RHET2,SCOV);
fprintf(f1,'%s\r\n',le);
l1='% ********Colloid Heterogeneity parameters (set SCOVP to 0.0 for no heterodomains,HETMODEP: sum of numbers of small, medium and large heterodomains in each patch. HETMODE = 1  yields uniform sized large heterodomains HETMODE 5 yields 1:4 large:medium';
l2='% Heterodomain zeta potential	# of het. per tile	Large het. radius	Small het. radius	Fractional surface coverage';
l3='% ZETAHETP(V)			HETMODEP			RHETP0(m)		RHETP1(m)		SCOVP(-)';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%10.3E        %15u                 %15.3E         %15.3E        %15.3E\r\n',ZETAHETP,HETMODEP,RHETP0,RHETP1,SCOVP);
fprintf(f1,'%s\r\n',le);
l1='% ********Van der Waals force parameters - Make sure to set VDWMODE (If VDWMODE = 2,3,4; A132(J) entry is inconsequential)';
l2='% Combined Hamaker constant		vdW decay length		Uncoated (1), Layered colloid - Layered collector (2), Colloid - Layered collector (3), Layered colloid - collector (4)';
l3='% A132(J)				LAMBDAVDW(m)			VDWMODE';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%10.3E                        %15.3E              %15u\r\n',A132,LAMBDAVDW,VDWMODE);
fprintf(f1,'%s\r\n',le);
l1='% ********Van der Waals force parameters - Coated systems';
l2='% Colloid Hamaker constants	Colloid coating Hamaker constant	Collector Hamaker constant	Collector coating Hamaker constant	Fluid Hamaker constant';
l3='% A11(J)				AC1C1(J)				A22(J)				AC2C2(J)				A33(J)';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%10.3E                      %15.3E                          %15.3E                  %15.3E                        %15.3E\r\n',A11,AC1C1,A22,AC2C2,A33);
fprintf(f1,'%s\r\n',le);
l1='% ********Van der Waals force parameters - Coated systems';
l2='% Colloid coating thickness 	Collector coating thickness';
l3='% T1(m)				T2(m)';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%10.3E                 %15.3E \r\n',T1,T2);
fprintf(f1,'%s\r\n',le);
l1='% ********Lewis acid-base and steric hydration force parameters';
l2='% AB energy at min. sep.		AB decay length		Ste. energy at min. sep.	Ste. decay length';
l3='% GAMMA0AB(J/m2)			LAMBDAAB(m)		GAMMA0STE(J/m2)			LAMBDASTE(m)';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%10.3E                        %15.3E               %15.3E              %15.3E\r\n',GAMMA0AB,LAMBDAAB,GAMMA0STE,LAMBDASTE);
fprintf(f1,'%s\r\n',le);
l1='%********Roughness parameters (Set Height Roughness mode to 0 for no roughness, 1 for rough colloid, 2 for rough collector, and 3 for rough colloid & collector)';
l2='%Slip Length        Roughness mode		Asperity Height';
l3='%B(m)               RMODE(-)            ASP(m)';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%10.3E          %8u       %10.3E\r\n',B,RMODE,ASP);  
fprintf(f1,'%s\r\n',le);
l1='% ********Deformation parameters (W132 is negative for attractive)';
l2='% Combined elastic modulus	Work of Adhesion	Contact Radius Factor (1.0 for detachment, <1.0 for attachment)';
l3='% KINT(N/m2)			W132(J/m2)		BETA(-)';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%10.3E                  %15.3E       %15.3E\r\n',KINT,W132,BETA);
fprintf(f1,'%s\r\n',le);
l1='% ********Diffusion and Gravity factors (DIFFSCALE calibrated to 1.35 or 0.0 for none, GRAVFACT is -1.0 for concurrent, 1.0 for countercurrent, 0.0 for none)';
l2='% Multiplier of diffusion force		Multiplier of gravity force';
l3='% DIFFSCALE(-)				  GRAVFACT(-)';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%10.3E              %15.3E\r\n',DIFFSCALE,GRAVFACT);
fprintf(f1,'%s\r\n',le);
l1='% ********Simulation time step and Slow motion parameters (displacement factors compare distance traveled to diffusion)';
l2='% Bulk time multiplier	Near-surface time mult.		Contact time mult.	Near-surface displacement factor	Contact displacement factor';
l3='% MULTB(-)		MULTNS(-)			MULTC(-)		DFACTNS(-)				DFACTC(-)';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%10.3E   %15.3E      %15.3E     %15.3E        %15.3E\r\n',MULTB,MULTNS,MULTC,DFACTNS,DFACTC);
fprintf(f1,'%s\r\n',le);
l1='% ********Output and Detachment parameters (integers)';
l2='% Output interval factor		Maximum output array size';
l3='% NOUT			PRINTMAX';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%5u            %12u\r\n',NOUT,PRINTMAX);
l1='% *******Gravity Alignment (checkboxes)';
l2='% Concurrent with flow      Counter-current with flow       Orthogonal to flow +X       Orthogonal to flow -X';
l3='% +Z			-Z              +X          -X';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%s\r\n',l3);
fprintf(f1,'%5u            %5u            %5u            %5u\r\n',cbPZ,cbMZ,cbPX,cbMX);
l1='% ******Simultaneous Plots (checkboxes)';
l2='% Dashboard      Detailed';
fprintf(f1,'%s\r\n',l1);
fprintf(f1,'%s\r\n',l2);
fprintf(f1,'%5u            %5u\r\n',simplotCHECK,detplotCHECK);
fclose(f1);
%% simulation runs
traj_happel()
end