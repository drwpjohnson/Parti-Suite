% read_input
function A = HFUNCread_input(input_file)
% A is a double precision vector with all input values
% define global variables/ have to match
global NPART ATTMODE CLUSTER VSUP RLIM POROSITY AG REXIT TTIME...
AP RHOP RHOW VISC ER T IS ZI ZETAPST ZETACST ZETAHET HETMODE RHET0...
RHET1 RHET2 SCOV  ZETAHETP HETMODEP RHETP0 RHETP1 SCOVP...
A132 LAMBDAVDW VDWMODE A11 AC1C1 A22 AC2C2 A33...
T1 T2 GAMMA0AB LAMBDAAB GAMMA0STE LAMBDASTE B RMODE ASP ASP2...
KINT W132 BETA DIFFSCALE GRAVFACT MULTB MULTNS MULTC DFACTNS DFACTC...
NOUT PRINTMAX cbPZ cbMZ cbPX cbMX
% open uunput file created by GUI
fileID = fopen(input_file,'r');
% read values here
% allin = textscan(fileID,'%s');
allinput = textscan(fileID, '%f','Delimiter','\t','CommentStyle','%');
A = cell2mat(allinput);
A(isnan(A))=[];
% assign values to variables
NPART=int32(A(1)); ATTMODE=int32(A(2)); CLUSTER=int32(A(3));
VSUP=A(4); RLIM=A(5); POROSITY=A(6); AG=A(7); REXIT=A(8); TTIME=A(9);
AP=A(10); RHOP=A(11); RHOW=A(12); VISC=A(13); ER=A(14); T=A(15); IS=A(16);
ZI=A(17); ZETAPST=A(18); ZETACST=A(19); ZETAHET=A(20); HETMODE=int32(A(21));
RHET0=A(22); RHET1=A(23); RHET2=A(24); SCOV=A(25); 
%
ZETAHETP=A(26); HETMODEP=A(27); RHETP0=A(28); RHETP1=A(29); SCOVP=A(30);
%
A132=A(31); LAMBDAVDW=A(32);
VDWMODE=A(33); A11=A(34); AC1C1=A(35); A22=A(36); AC2C2=A(37); A33=A(38);
T1=A(39); T2=A(40); GAMMA0AB=A(41); LAMBDAAB=A(42); GAMMA0STE=A(43); 
LAMBDASTE=A(44); B=A(45); RMODE=A(46); ASP=A(47);
% 
KINT=A(48); W132=A(49); BETA=A(50); 
DIFFSCALE=A(51); GRAVFACT=A(52); 
MULTB=A(53); MULTNS=A(54); MULTC=A(55); DFACTNS=A(56); DFACTC=A(57);
NOUT=int32(A(58)); PRINTMAX=int32(A(59));
cbPZ=int32(A(60));cbMZ=int32(A(61));cbPX=int32(A(62));cbMX=int32(A(63));

% clear allin
fclose(fileID);
end