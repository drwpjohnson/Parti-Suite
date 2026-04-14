
function HFUNCread_flux_header(filename)
%% import header
% A is a cell matrix with all input values read from header
A = import_load_flux_header(filename, 1, 4);
%convert cell to double
A=cell2mat(A);
%% define global variables to match model
global NPART ATTMODE CLUSTER VSUP RLIM POROSITY AG  TTIME...
AP RHOP RHOW VISC ER T IS ZI ZETAPST ZETACST ZETAHET HETMODE RHET0...
RHET1 SCOV RHET2 ZETAHETP HETMODEP RHETP0 RHETP1 SCOVP...
A132 LAMBDAVDW VDWMODE A11 AC1C1 A22 AC2C2 A33...
T1 T2 GAMMA0AB LAMBDAAB GAMMA0STE LAMBDASTE B RMODE ASP...
KINT W132 BETA DIFFSCALE GRAVFACT MULTB MULTNS MULTC DFACTNS DFACTC...
cbPZ cbMZ cbPX cbMX simplotCHECK detplotCHECK
% NOUT PRINTMAX PERT NPARTPERT

%% assign values to variables
%line 1 of flux header
CLUSTER=0; % keeping in case parallel version occurs some day
NPART=int32(A(1,2)); VSUP=A(1,4); RLIM=A(1,6); POROSITY=A(1,8); AG=A(1,10); RB=A(1,12);
TTIME=A(1,14); ATTMODE=int32(A(1,16)); B=A(1,18); RMODE=A(1,20); ASP=A(1,22); ASP2=A(1,24); %SLIP in header = B in code
%line 2 of flux header
AP=A(2,2); IS=A(2,4); ZI=A(2,6); ZETAPST=A(2,8); ZETACST=A(2,10); RHOP=A(2,12);
RHOW=A(2,14); VISC=A(2,16); ER=A(2,18); T=A(2,20); DIFFSCALE=A(2,22); GRAVFACT=A(2,24); 
cbPZ=int32(A(2,26));  cbMZ=int32(A(2,28));  cbPX=int32(A(2,30));  cbMX=int32(A(2,32)); 
simplotCHECK=int32(A(2,34)); detplotCHECK=int32(A(2,36));
%line 3 of flux header
SCOV=A(3,2); ZETAHET=A(3,4); HETMODE=int32(A(3,6));RHET0=A(3,8); RHET1=A(3,10); RHET2=A(3,12);

SCOVP=A(3,14); ZETAHETP=A(3,16); HETMODEP=int32(A(3,18));RHETP0=A(3,20); RHETP1=A(3,22);

RZOIBULK=A(3,24); dTMRT=A(3,26); MULTB=A(3,28); MULTNS=A(3,30); MULTC=A(3,32); VDWMODE=A(3,34);

%line 4 of flux header
A132=A(4,2); LAMBDAVDW=A(4,4); GAMMA0AB=A(4,6); LAMBDAAB=A(4,8); GAMMA0STE=A(4,10); LAMBDASTE=A(4,12);  
KINT=A(4,14); W132=A(4,16); ACONTMAX=A(4,18); BETA=A(4,20);  DFACTNS=A(4,22); DFACTC=A(4,24); 
A11=A(4,26); A22=A(4,28);   A33=A(4,30); AC1C1=A(4,32);   AC2C2=A(4,34); T1=A(4,36); T2=A(4,38); 
%% check section make following values zero
% NOUT=int32(A(52)); PRINTMAX=int32(A(53));
end