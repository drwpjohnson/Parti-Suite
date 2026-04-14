%FUNCTION TO DETERMINE FRACTIONAL AREA WRITTEN - CESAR RON 
function [AF_PZ,AF_ZH,AF_PZH,AF_Z] = HAREAFRACT(XP,YP,RZOI,XHET,YHET,RHET,MPRO)

%DEFINE COLLOID CENTER IN COLLECTOR FRAME OF REFERENCE
XmP0 = XP; 
YmP0 = YP; 

%DEFINE HETP PROJECTIONS MATRIX AND ZOI-HET MATRIX
m1 = MPRO; %HETP PROJECTIONS
m2(1,:) = [XmP0 YmP0 RZOI]; %ZOI
m2(2,:) = [XHET YHET RHET]; %HET 

% ZOI and HET radii
rz = m2(1,3);
rh = m2(2,3);

% distances between ZOI and HET
dxzh = m2(2,1)-m2(1,1);
dyzh = m2(2,2)-m2(1,2);
dzh = sqrt(dxzh^2+dyzh^2);
sumrzh = rz + rh;
diffrzh = rz - rh;
% number of rows for m1 and m2
s1 = size(m1,1);
s2 = size(m2,1);

% distances between PRO and both ZOI and HET
dx = bsxfun(@minus, m1(:,1), m2(:,1)');
dy = bsxfun(@minus, m1(:,2), m2(:,2)');

% sum and difference between PRO and both ZOI and HET
sumr = bsxfun(@plus, m1(:,3), m2(:,3)');
diffr = bsxfun(@minus, m1(:,3), m2(:,3)');

% distance between PRO and both ZOI and HET
dist   = sqrt(dx.^2 + dy.^2);

% pairs PRO-ZOI and PRO-HET which overlap
pairs_o = find(dist < sumr);

% pairs PRO-ZOI and PRO-HET that partially overlap
pairs_po = intersect(pairs_o,find(dist > abs(diffr)));

% pairs PRO-ZOI and PRO-HET that completely overlap
pairs_co = intersect(pairs_o,find(dist <= abs(diffr)));

% PRO overlap matrix: 1 for partial overlap, -1 for complete overlap, 0 for no overlap
om_p = zeros(s1,s2); % column 1: PRO-ZOI overlap; column 2: PRO-HET overlap
om_p(pairs_po) = 1;
om_p(pairs_co) = -1;

% ZOI-HET overlap matrix: 1 for partial overlap, -1 for complete overlap, 0 for no overlap
om_zh = 0;
if dzh > sumrzh % no 2 overlap exist for ZOI-HET
    om_zh = om_zh;
else % 2 overlap exist for ZOI-HET
    if abs(diffrzh) >= dzh % ZOI-HET complete overlap
        om_zh = -1;
    else % ZOI-HET partial overlap
        om_zh = 1;
    end
end

% calculate 2 overlap areas for PRO-ZOI and PRO-HET
c1 = repmat(1:s1, [s2 1])'; % circle from m1 corresponding to value in pairs()
c2 = repmat(1:s2, [s1 1]); % circle from m2 corresponding to value in pairs()
r1 = m1(c1(pairs_o),3); % radius from m1 corresponding to value in pairs()
r2 = m2(c2(pairs_o),3); % radius from m2 corresponding to value in pairs()
d(:,1) = dist(pairs_o); % distance from dist corresponding to value in pairs()
Ao2_1 = zeros(s1,s2);
Ao2_1(pairs_o) = overlap2(r1, r2, d); % function to calculate overlap area between 2 circles(differentiates total and partial overlap)

% calculate 2 overlap area for ZOI-HET
if dzh<(rz+rh)
   Ao2_2 = overlap2(rz, rh, dzh);
else
   Ao2_2 = 0.0;
end

% matrix for 2 overlap area for PRO-ZOI
Ao2_pz = zeros(s1,1);
% matrix for 2 overlap area for PRO-HET
Ao2_ph = zeros(s1,1);
% matrix for 2 overlap area for ZOI-HET
Ao2_zh = zeros(1,1);
% matrix for 3 overlap area
Ao3_f = zeros(s1,1);

% determine 2 or 3 overlap area for each PRO
for i=1:s1 % [1] loop through each PRO
    azh = om_zh;
    apz = om_p(i,1);
    aph = om_p(i,2);
    if ((apz==1)&&(aph==1)) % [2] PRO-ZOI partial overlap, PRO-HET partial overlap
        if azh==0 % [3] no ZOI-HET overlap            
            % 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = Ao2_1(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;        
        elseif azh==1 % [3] ZOI-HET partial overlap            
            % ZOI-HET intersection points
            izh = intersection(rz, rh, m2(1,1), m2(1,2), m2(2,1), m2(2,2), 0, 0);   
            % ZOI-HET intersection points inside PRO: 1 for inside, 0 for outside
            ipip = inside(m1(i,1), m1(i,2), m1(i,3), izh);
            % PRO-ZOI intersection points
            ipz = intersection(rz, m1(i,3), m2(1,1), m2(1,2), m1(i,1), m1(i,2), 0, 0);
            % PRO-ZOI intersection points inside HET: 1 for inside, 0 for outside
            ipih = inside(m2(2,1), m2(2,2), m2(2,3), ipz);               
            % PRO-HET intersection points
            iph = intersection(rh, m1(i,3), m2(2,1), m2(2,2), m1(i,1), m1(i,2), m2(2,1), m2(2,2));
            % PRO-HET intersection points inside ZOI: 1 for inside, 0 for outside
            ipiz = inside(m2(1,1), m2(1,2), m2(1,3), iph);                    
            % decide if 3 overlap or 2 overlap area
            ipip_o = find(ipip==1); 
            ipih_o = find(ipih==1);
            ipiz_o = find(ipiz==1);
            if (isempty(ipip_o))&&(isempty(ipih_o))&&(isempty(ipiz_o)) % [4] 2 overlap area 
                % 3 overlap area
                Ao3_f(i,1) = 0;
                % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                Ao2_pz(i,1) = Ao2_1(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2;
            else % [4] 3 overlap area
                % points corresponding to vertices of polygon required for 3 overlap area calculation 
                locator_ip = find(ipip == 1);
                locator_ih = find(ipih == 1);
                locator_iz = find(ipiz == 1);
                % decide if polygon within 3 overlap area is formed by 3 or 4 points
                if (isempty(locator_ih))&&(numel(locator_ip)>1)&&(numel(locator_iz>1)) % 3 overlap area with polygon formed by 4 points
                    points_ip = intersection(rz, rh, m2(1,1), m2(1,2), m2(2,1), m2(2,2), 0, 0);
                    points_iz = intersection(rh, m1(i,3), m2(2,1), m2(2,2), m1(i,1), m1(i,2), m2(2,1), m2(2,2));
                    points_ih = [];
                    % 3 overlap area
                    Ao3_f(i,1) = overlap4(points_ip, points_iz, rh, rz, m1(i,3));
                    % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                    Ao2_pz(i,1) = Ao2_1(i,1)-Ao3_f(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2-Ao3_f(i,1);
                elseif (isempty(locator_iz))&&(numel(locator_ip)>1)&&(numel(locator_ih>1)) % 3 overlap area with polygon formed by 4 points
                    points_ip = intersection(rz, rh, m2(1,1), m2(1,2), m2(2,1), m2(2,2), 0, 0);
                    points_iz = [];
                    points_ih = intersection(m1(i,3), rz,  m1(i,1), m1(i,2), m2(1,1), m2(1,2), m1(i,1), m1(i,2));
                    % 3 overlap area
                    Ao3_f(i,1) = overlap4(points_ip, points_ih, rz, rh, m1(i,3));
                    % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                    Ao2_pz(i,1) = Ao2_1(i,1)-Ao3_f(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2-Ao3_f(i,1);
                elseif (isempty(locator_ip))&&(numel(locator_iz)>1)&&(numel(locator_ih>1)) % 3 overlap area with polygon formed by 4 points
                    points_ip = [];
                    points_iz = intersection(rh, m1(i,3), m2(2,1), m2(2,2), m1(i,1), m1(i,2), m2(2,1), m2(2,2));
                    points_ih = intersection(m1(i,3), rz, m1(i,1), m1(i,2), m2(1,1), m2(1,2), m1(i,1), m1(i,2));
                    % 3 overlap area
                    Ao3_f(i,1) = overlap4(points_iz, points_ih, m1(i,3), rh, rz);
                    % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                    Ao2_pz(i,1) = Ao2_1(i,1)-Ao3_f(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2-Ao3_f(i,1);
                elseif (isempty(locator_ip))&&(isempty(locator_ih))&&(numel(locator_iz)>1) % 3 overlap area correspond to PRO-HET 2 overlap area
                    % calculate 3 overlap area
                    Ao3_f(i,1) = Ao2_1(i,2);
                    % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                    Ao2_pz(i,1) = Ao2_1(i,1)-Ao3_f(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2-Ao3_f(i,1);
                    %CHECK IF OTHER OPTIONS MIGTH APPLY FOR THIS CONDITIONS
                elseif ((numel(locator_ip)==1)&&(numel(locator_ih)==1)&&(numel(locator_iz)==1))% 3 overlap area with polygon formed by 3 points
                    points_ih = ipz(locator_ih,:);
                    points_iz = iph(locator_iz,:);
                    points_ip = izh(locator_ip,:);
                    % calculate 3 overlap area
                    Ao3_f(i,1) = overlap3(m1(i,3), rz, rh, points_ih, points_ip, points_iz);
                    % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                    Ao2_pz(i,1) = Ao2_1(i,1)-Ao3_f(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2-Ao3_f(i,1);
                else
                    % 3 overlap area
                    Ao3_f(i,1) = 0;
                    % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                    Ao2_pz(i,1) = Ao2_1(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2;
                end
            end % [4] END
        elseif azh==-1 % [3] ZOI-HET complete overlap        
            if rz >= rh % [4] for ZOI >= HET 
                % calculate 3 overlap area
                Ao3_f(i,1) = Ao2_1(i,2);
                % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                Ao2_pz(i,1) = Ao2_1(i,1)-Ao3_f(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2-Ao3_f(i,1);
            elseif rh > rz % [4] for HET > ZOI 
                % calculate 3 overlap area
                Ao3_f(i,1) = Ao2_1(i,1);
                % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2-Ao3_f(i,1);
            end % [4] end           
        end % [3] end
    elseif ((apz==1)&&(aph==-1)) %[2] PRO-ZOI partial overlap, PRO-HET complete overlap        
        if azh==0 % [3] ZOI-HET no overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = Ao2_1(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
        elseif azh==1 % [3] ZOI-HET partial overlap            
            if rh >= m1(i,3) % [4] for HET >= PRO
                % calculate 3 overlap area
                Ao3_f(i,1) = Ao2_1(i,1);
                % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2-Ao3_f(i,1);
            elseif m1(i,3) > rh % [4] for PRO > HET 
                % calculate 3 overlap area
                Ao3_f(i,1) = Ao2_2;
                % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                Ao2_pz(i,1) = Ao2_1(i,1)-Ao3_f(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
            end
        elseif azh==-1 % [3] ZOI-HET complete overlap
            if rh >= m1(i,3) % [4] for HET >= PRO
                % calculate 3 overlap area
                Ao3_f(i,1) = Ao2_1(i,1);
                % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2-Ao3_f(i,1);
            elseif m1(i,3) > rh % [4] for PRO > HET 
                % calculate 3 overlap area
                Ao3_f(i,1) = Ao2_2;
                % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                Ao2_pz(i,1) = Ao2_1(i,1)-Ao3_f(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
            end
        end % [3] end
    elseif ((apz==-1)&&(aph==1)) %[2] PRO-ZOI complete overlap, PRO-HET partial overlap    
        if azh==0 % [3] ZOI-HET no overlap
             % calculate 3 overlap area
             Ao3_f(i,1) = 0;
             % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
             Ao2_pz(i,1) = Ao2_1(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
        elseif azh==1 % [3] ZOI-HET partial overlap
            if rz >= m1(i,3) % [4] for ZOI >= PRO
                % calculate 3 overlap area
                Ao3_f(i,1) = Ao2_1(i,2);
                % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                Ao2_pz(i,1) = Ao2_1(i,1)-Ao3_f(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2-Ao3_f(i,1);
            elseif m1(i,3) > rz % [4] for ZOI < PRO 
                % calculate 3 overlap area
                Ao3_f(i,1) = Ao2_2;
                % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                Ao2_pz(i,1) = Ao2_1(i,1)-Ao3_f(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
            end % [4] end  
        elseif azh==-1 % [3] ZOI-HET complete overlap
             if rz >= rh % [4] for ZOI >= HET 
                % calculate 3 overlap area
                Ao3_f(i,1) = Ao2_1(i,2);
                % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                Ao2_pz(i,1) = Ao2_1(i,1)-Ao3_f(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2-Ao3_f(i,1);
            elseif rh > rz % [4] for HET > ZOI 
                % calculate 3 overlap area
                Ao3_f(i,1) = Ao2_2;
                % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
            end % [4] end  
        end % [3] end 
    elseif((apz==-1)&&(aph==-1)) %[2] PRO-ZOI complete overlap, PRO-HET complete overlap   
        if azh==0 % [3] ZOI-HET no overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = Ao2_1(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
        elseif azh==1 % [3] ZOI-HET partial overlap
            if (m1(i,3) >= rz)&&(m1(i,3) >= rh) % [4]
                % calculate 3 overlap area
                Ao3_f(i,1) = Ao2_2;
                % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                Ao2_pz(i,1) = Ao2_1(i,1)-Ao3_f(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
            else % [4]
                % calculate 3 overlap area
                Ao3_f(i,1) = Ao2_1(i,2);
                % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2-Ao3_f(i,1);
            end % [4] end
        elseif azh==-1 % [3] ZOI-HET complete overlap
            if (rz >= rh)&&(rz >= m1(i,3)) % [4]
                if rh >= m1(i,3) % [5]
                    % calculate 3 overlap area
                    Ao3_f(i,1) = Ao2_1(i,1);
                    % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                    Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2-Ao3_f(i,1);
                elseif m1(i,3) > rh % [5]
                    % calculate 3 overlap area
                    Ao3_f(i,1) = Ao2_2;
                    % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                    Ao2_pz(i,1) = Ao2_1(i,1)-Ao3_f(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
                end % [5] end
            elseif (rh >= rz)&&(rh >= m1(i,3)) % [4]
                if rz >= m1(i,3) % [5]
                    % calculate 3 overlap area
                    Ao3_f(i,1) = Ao2_1(i,1);
                    % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                    Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2-Ao3_f(i,1);
                elseif m1(i,3) > rz % [5]
                    % calculate 3 overlap area
                    Ao3_f(i,1) = Ao2_2;
                    % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                    Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
                end % [5] end
            elseif (m1(i,3) >= rz)&&(m1(i,3) >= rh) % [4]
                if rz >= rh % [5]
                    % calculate 3 overlap area
                    Ao3_f(i,1) = Ao2_2;
                    % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                    Ao2_pz(i,1) = Ao2_1(i,1)-Ao3_f(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
                elseif rh > rz % [5]
                    % calculate 3 overlap area
                    Ao3_f(i,1) = Ao2_2;
                    % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
                    Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
                end % [5] end    
            end % [4] end
        end % [3] end
    elseif((apz==1)&&(aph==0)) %[2] PRO-ZOI partial overlap, PRO-HET no overlap
        if azh==0 % [3] ZOI-HET no overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = Ao2_1(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
        elseif azh==1 % [3] ZOI-HET partial overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = Ao2_1(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2;
        elseif azh==-1 % [3] ZOI-HET complete overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = Ao2_1(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2;
        end % [3] end
    elseif((apz==0)&&(aph==1)) %[2] PRO-ZOI no overlap, PRO-HET partial overlap
        if azh==0 % [3] ZOI-HET no overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
        elseif azh==1 % [3] ZOI-HET partial overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2;
        elseif azh==-1 % [3] ZOI-HET complete overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = Ao2_1(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2;
        end % [3] end
    elseif((apz==-1)&&(aph==0)) %[2] PRO-ZOI complete overlap, PRO-HET no overlap
        if azh==0 % [3] ZOI-HET no overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = Ao2_1(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
        elseif azh==1 % [3] ZOI-HET no overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = Ao2_1(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2;
        elseif azh==-1 % [3] ZOI-HET no overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = Ao2_1(i,1); Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2;
        end % [3] end
     elseif((apz==0)&&(aph==-1)) %[2] PRO-ZOI no overlap, PRO-HET complete overlap
        if azh==0 % [3] ZOI-HET no overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
        elseif azh==1 % [3] ZOI-HET no overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2;
        elseif azh==-1 % [3] ZOI-HET no overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2;
        end % [3] end
     elseif((apz==0)&&(aph==0)) %[2] PRO-ZOI no overlap, PRO-HET no overlap
        if azh==0 % [3] ZOI-HET no overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
        elseif azh==1 % [3] ZOI-HET no overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2;
        elseif azh==-1 % [3] ZOI-HET no overlap
            % calculate 3 overlap area
            Ao3_f(i,1) = 0;
            % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
            Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = Ao2_2;
        end % [3] end
    else %[2] any other case where no overlap occurs
        % calculate 3 overlap area
        Ao3_f(i,1) = 0;
        % 2 overlap area PRO-ZOI, PRO-HET, ZOI-HET
        Ao2_pz(i,1) = 0; Ao2_ph(i,1) = 0; Ao2_zh(i,1) = 0;
    end % [2] end 
end % [1] end loop through each PRO

% final overlapping area
Ao2_pzf = Ao2_pz; Ao2_phf = Ao2_ph;

% keep checking this for other scenarios
if sum(Ao2_zh) > 0 
    Ao2_zhf = Ao2_2;
    for i=1:s1 % [1] loop through each PRO
    Ao2_zhf = Ao2_zhf-Ao3_f(i,1); 
    end
else
    Ao2_zhf = 0;
end

% calculate attractive FRACTIONAL AREA
AF_PZ = sum(Ao2_pzf)/(pi*rz^2);
AF_ZH = sum(Ao2_zhf)/(pi*rz^2);
% calculate repulsive AFRACT
AF_PZH = sum(Ao3_f)/(pi*rz^2);
AF_Z = 1-AF_PZ-AF_ZH-AF_PZH;

% % plot ZOI and HET
% circles(m2(1,1), m2(1,2), m2(1,3), 'r') %ZOI
% circles(m2(2,1), m2(2,2), m2(2,3), 'g') %HET

% % store and plot PRO
% centers_1 = [];
% radii_1   = [];
% for i = 1:size(m1,1)
%     center_1       = [m1(i,1) m1(i,2)];
%     centers_1(i,:) = center_1; %fix the zeros is giving at the beggining
%     radius_1       = [m1(i,3)];
%     radii_1(i,:)   = radius_1;
%     circles(centers_1(i,1), centers_1(i,2), radii_1(i,:), 'b')
% end

% % function to plot circles
% function circles(x0,y0,r,color)
% hold on
% theta = 0:pi/50:2*pi;
% x = r * cos(theta) + x0;
% y = r * sin(theta) + y0;
% plot(x, y, color);
% hold off
% end

% function to calculate 2 overlap area
function Ao2 = overlap2(r1, r2, d)
r1_2 = r1.^2;
r2_2 = r2.^2;
d_2 = d.^2;
a1 = acos((d_2 + r1_2 - r2_2)./(2.*d.*r1));
a2 = acos((d_2 + r2_2 - r1_2)./(2.*d.*r2));
Ao2 = r1_2.*a1 + r2_2.*a2-.5*sqrt((-d+r1+r2).*(d+r1-r2).*(d-r1+r2).*(d+r1+r2));

% fix total overlap situation, r1 - r2 > d
f = find(abs(imag(a1)) + abs(imag(a2)) > 0);
Ao2(f) = pi * min(r1(f),r2(f)).^2;
end

% function to calculate 3 overlap area with 3 intersection points
function Ao3 = overlap3(r1, r2, r3, points_A, points_B, points_C)  
r2_2 = r2^2;
r3_2 = r3^2;
r1_2 = r1^2;

% distance between points forming the polygon
dAB_x = bsxfun(@minus, points_A(:,1), points_B(:,1));
dBC_x = bsxfun(@minus, points_C(:,1), points_B(:,1));
dAC_x = bsxfun(@minus, points_C(:,1), points_A(:,1));
dAB_y = bsxfun(@minus, points_A(:,2), points_B(:,2));
dBC_y = bsxfun(@minus, points_C(:,2), points_B(:,2));
dAC_y = bsxfun(@minus, points_C(:,2), points_A(:,2));

% longitude of polygon sides
dAB = sqrt(dAB_x.^2+dAB_y.^2);
dBC = sqrt(dBC_x.^2+dBC_y.^2);
dAC = sqrt(dAC_x.^2+dAC_y.^2);

% area of the polygon (triangle)
s = 0.5*(dAB+dBC+dAC);
Ap = sqrt(s.*(s-dAB).*(s-dBC).*(s-dAC));

% angle of circular segment
theta_AB = 2*asin(dAB./(2*r2)); 
theta_BC = 2*asin(dBC./(2*r3));
theta_AC = 2*asin(dAC./(2*r1));

% area of circular segment
Acs_AB = 0.5*r2_2*(theta_AB-sin(theta_AB));
Acs_BC = 0.5*r3_2*(theta_BC-sin(theta_BC));
Acs_AC = 0.5*r1_2*(theta_AC-sin(theta_AC));

% total 3 overlap area 
Ao3 = Acs_AB + Acs_BC + Acs_AC + Ap;
end

% function to calculate 3 overlap area with 4 intersection points
function Ao3 = overlap4(points_ab, points_cd, r1, r2, r3)

% polygon coordinates
xa = points_ab(1,1); xb = points_ab(2,1); xc = points_cd(1,1); xd = points_cd(2,1);
ya = points_ab(1,2); yb = points_ab(2,2); yc = points_cd(1,2); yd = points_cd(2,2);
                
% distance between points forming the polygon
dx_ab = xa-xb; dx_cd = xc-xd; dx_ac = xa-xc; dx_bd = xb-xd; dx_ad = xa-xd; dx_bc = xb-xc;
dy_ab = ya-yb; dy_cd = yc-yd; dy_ac = ya-yc; dy_bd = yb-yd; dy_ad = ya-yd; dy_bc = yb-yc;
                
% longitude of polygon sides
d_ab = sqrt(dx_ab^2+dy_ab^2); d_cd = sqrt(dx_cd^2+dy_cd^2); 
d_ac = sqrt(dx_ac^2+dy_ac^2); d_bd = sqrt(dx_bd^2+dy_bd^2);
                
% longitude of polygon diagonals
d_ad = sqrt(dx_ad^2+dy_ad^2); d_bc = sqrt(dx_bc^2+dy_bc^2); 

% area of polygon (quadrilateral)
Ap = 0.25*sqrt(4*d_ad^2*d_bc^2-(d_ab^2+d_cd^2-d_ac^2-d_bd^2)^2);
                                
% angle of circular segment
theta_ab = 2*asin(d_ab/(2*r2)); theta_cd = 2*asin(d_cd/(2*r3));
theta_ac = 2*asin(d_ac/(2*r1)); theta_bd = 2*asin(d_bd/(2*r1));
                
% area of circular segment
Acs_ab = 0.5*r2^2*(theta_ab-sin(theta_ab));
Acs_cd = 0.5*r3^2*(theta_cd-sin(theta_cd));
Acs_ac = 0.5*r1^2*(theta_ac-sin(theta_ac));
Acs_bd = 0.5*r1^2*(theta_bd-sin(theta_bd));
                
% total 3 overlap area
Ao3 = Acs_ab + Acs_cd + Acs_ac + Acs_bd + Ap;
end

% function to determine intersection points between 2 circles
function  intersection_points = intersection(r1, r2, x1, y1, x2, y2, x0, y0) 
intersection_points = [];
r1_2 = r1^2;
r2_2 = r2^2;
dx12 = x2-x1;
dy12 = y2-y1;
d12 = sqrt(dx12^2+dy12^2);
d12_2 = dx12^2+dy12^2;
if dy12<0
    phi_12 = 2*pi - acos(dx12/d12);
else
    phi_12 = acos(dx12/d12);
end
psi_12 = acos((r1_2+d12_2-r2_2)/(2*r1*d12)); 
omega1_12 = phi_12 + psi_12;
omega2_12 = phi_12 - psi_12;
x1_12 = cos(omega1_12)*r1 + x0;
y1_12 = sin(omega1_12)*r1 + y0;
x2_12 = cos(omega2_12)*r1 + x0;
y2_12 = sin(omega2_12)*r1 + y0;
intersection_points = [intersection_points; x1_12 y1_12; x2_12 y2_12];
end

% function to determine intersection points inside a circle
function inside_points = inside(x3, y3, r3, intersection_points)
inside_points = zeros(size(intersection_points,1),1);
for j=1:size(intersection_points,1)
    di = sqrt((intersection_points(j,1)-x3)^2+(intersection_points(j,2)-y3)^2);
    if di <= r3
        inside_points(j,1) = 1;
    end
end
end

end