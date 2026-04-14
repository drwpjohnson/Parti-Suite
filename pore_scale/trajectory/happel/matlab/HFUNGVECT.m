% gravity vector projections on normal and tangential
function [FGN,FGT,FGNX,FGNY,FGNZ,FGTX,FGTY,FGTZ]= HFUNGVECT(FG,EGX,EGY,EGZ,ENX,ENY,ENZ,ETX,ETY,ETZ)
% calculates projection of gravity vector un normal and tangential
% directions
% calculate projection on normal and tangential
PGN = EGX*ENX+EGY*ENY+EGZ*ENZ;
PGT = EGX*ETX+EGY*ETY+EGZ*ETZ;
% calculate FG vector in normal and tangential
FGN = PGN*FG;
FGT = PGT*FG;
% calculate components
% NORMAL
FGNX = ENX*FGN;
FGNY = ENY*FGN;
FGNZ = ENZ*FGN;
% TANGENTIAL
FGTX = ETX*FGT;
FGTY = ETY*FGT;
FGTZ = ETZ*FGT;
% FGX = FG*EGX;
% FGY = FG*EGY;
% FGZ = FG*EGZ;
end
