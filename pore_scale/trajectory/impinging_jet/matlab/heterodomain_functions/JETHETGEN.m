% HAPHETGEN - function to generate explicitly all hetdomains and plot if requested. EP
% function[XHET,YHET,ZHET,RHET]=HAPHETGEN(X,Y,Z,Xm0,Ym0,Zm0,AG,...
%                               HETMODE,SCOV,RHET0,RHET1)
function [XHETall,YHETall,ZHETall,genSCOV]=JETHETGEN (Xm0,Ym0,Zm0,RJET,SCOV,HETMODE,RHET0,RHET1,nfig)
 %% inputs
% % impingin plane center (m)
% Xm0,Ym0,Zm0,
% % Jet radius (m)
% RJET
% % fraction hetdomains surface coverage
% SCOV
% % HETMODE (number of hetdomains pattern to repeat: 1 single, 5 for bimodal (1 large+ 4 smalls)
% % hetdomain radii(m)
% RHET0 %single size or large hetdomain
% RHET1 %small hetdomains (only used in HETMODE =5)
%% outputs
% maxnumber of hetdomains expected (to preallocate)
maxval = int32(1e6);
% all hetdomains locations and radii(m)
XHETall = NaN(1,maxval); YHETall = XHETall; 
ZHETall = XHETall; RHETall=XHETall;
%% parameters and constants
PI=3.14159265359; % to match FORTRAN version
%% correct scov if needed
%EQUIVALENT SURFACE COVERAGE CORRESPONDING TO UNIFORM HETERODOMAINS IS USED IN CALCULATION, EQUALS HALF OF BIMODAL SURFACE COVERAGE
if (HETMODE==1)  
    SCOV1 = SCOV;
elseif(HETMODE==5)   %FOR BIMODAL MODEL SCOV IS BASED ON BIG HETERODOMAINS, MUST DIVIDE SCOV BY 2
    SCOV1 = SCOV/2.0;
end
%% CALCULATE APPROXIMATE NUMBER OF HETERODOMAINS REQUIRED
% ACTUAL SURFACE COVERAGE calculted while generating complete surface
% from previous tests APPROXIMATION IS GOOD TO WITHIN 5% OR BETTER
%  for the expression:
  NHET = round(SCOV1*(RJET^2.0)/(RHET0^2.0));
%CALCULATE NUMBER OF RINGS THAT YIELD NHET ASSUMING EVEN SPACING 
  NHETREAL = NHET;
%THE DENOMINATOR 1/1.2 WAS CALIBRATED TO YIELD EVEN SPACING DISTRIBUTION OF HETDOMAINS MATCING SCOV
  NRING = round((NHETREAL/3.3)^0.5);
%CALCULATE STEP IN THETA AND ASSOCIATED ARCLENGTH
  DTHETA =  RJET/(NRING-1);
  ARCL = DTHETA; 
%% generate hetdomains
k=1; % start hetdomain all array counter
genhetarea = 0.0; %total hetdomain area (to evaluate generated vs requested)
if HETMODE==1
    Ahet = PI*RHET0^2.0;
else
    Ahet = PI*(RHET0^2.0+4*RHET1^2.0);
end
% generate rings
for I=1:NRING
    % calculate radius of each ring
    RRING = (I-1)*DTHETA;
    % pole conditions
    if I==1 
        %% in pole there is no ring and only one hetdomain over it
        RRING = 0.0;
        NHETRING = 1;
        DPHI = 0.0;
        % populate pole
        for J=1:HETMODE
            if (J==1)   
               %GENERATE LARGE HETERODOMAIN AT POLE
                PHI = 0.0;
                XHET(J) = RRING*cos(PHI)+Xm0;
                YHET(J) = RRING*sin(PHI)+Ym0;
                ZHET(J) = Zm0; 
                RHET(J) = RHET0;
            else 
                %GENERATE SMALL HETERODOMAINS OFFSET FROM LARGE HETERODOMAIN AT POLE 
                R1 = RRING + (1.0/3.0*DTHETA);  
                PHI = double(J-2)*PI/2.0;
                XHET(J) = R1*cos(PHI)+Xm0;
                YHET(J) = R1*sin(PHI)+Ym0;
                ZHET(J) = Zm0;
                RHET(J) = RHET1;
            end                      
        end
        % save poles hetdomains local array to all array
        for J=1:HETMODE
            XHETall(k) = XHET(J);
            YHETall(k) = YHET(J);
            ZHETall(k) = ZHET(J);
            RHETall(k) = RHET(J);
            % count hetdomains
            k=k+1;
        end
        %integrate hetdomain area
        genhetarea = genhetarea+Ahet;    
    else
        %% not in pole
        NHETRING = round(2.0*PI*RRING/ARCL); %use round instead of floor, rare numerical discrepancies occur with HAPHETTRACK
        if NHETRING <3 % use 3 hetdomains at least in small rings
            NHETRING = 3;
        end
        DPHI = 2*PI/NHETRING;
        %       CALCULATE OFFSET AS 10% OF THE STEP IN PHI if RING IS ODD OR EVEN
%         if (THETA>=0.0)  
%             N = round((PI/2.0-THETA)/DTHETA)+1;
%             %THETA1 = THETA - (1.0/3.0*DTHETA); % no need for this line,%
%         else
%             N = round((PI+THETA)/DTHETA)+1;
%             %THETA1 = THETA + (1.0/3.0*DTHETA); % no need for this line,%
%         end  
%             N = round((PI/2.0-THETA)/DTHETA)+1; %% test
%             M = rem(N,2); % note MATLAB rem substitutes FOTRAN MOD
            M = rem(I,2); % note MATLAB rem substitutes FOTRAN MOD, fixed I corresponds to ring number
        if (M==0)  
            PHIOFF = 0.1*DPHI; 
        else
            PHIOFF = -0.1*DPHI; 
        end
        % populate rings
        for L=1:NHETRING
            %CALCULATE THE AZIMUTH ANGLE TAKING IN ACCOUNT THE OFFSET OF THE HETDOMAINS IN EACH RING
            PHI = PHIOFF+(L-1)*DPHI; 
            % GENERATE HETERODOMAINS NOT AT POLES
            for J=1:HETMODE
                if (J==1)   
                %GENERATE LARGE HETERODOMAIN NOT AT POLES
                    XHET(J) = RRING*cos(PHI)+Xm0;
                    YHET(J) = RRING*sin(PHI)+Ym0;
                    ZHET(J) = Zm0; 
                    RHET(J) = RHET0;
                else %GENERATE SMALL HETERODOMAINS OFFSET FROM LARGE HETERODOMAINS
                    if (J==2)   
                        PHI1 = PHI - (1.0/3.0*DPHI);
                        R1 = RRING + (1.0/3.0*DTHETA);
                    end
                    if (J==3)   
                        PHI1 = PHI + (1.0/3.0*DPHI);
                        R1 = RRING + (1.0/3.0*DTHETA); 
                    end
                    if (J==4)   
                        PHI1 = PHI + (1.0/3.0*DPHI);
                        R1 = RRING - (1.0/3.0*DTHETA); 
                    end
                    if (J==5)   
                        PHI1 = PHI - (1.0/3.0*DPHI);
                        R1 = RRING - (1.0/3.0*DTHETA); 
                    end                                      
                    XHET(J) = R1*cos(PHI1);
                    YHET(J) = R1*sin(PHI1);
                    ZHET(J) = Zm0;
                    RHET(J) = RHET1;
                end                      
            end
            % save ring hetdomains local array to all array
            for J=1:HETMODE
                XHETall(k) = XHET(J);
                YHETall(k) = YHET(J);
                ZHETall(k) = ZHET(J);
                RHETall(k) = RHET(J);
                % count hetdomains
                k=k+1;   
            end
            %integrate hetdomain area
            genhetarea = genhetarea+Ahet;
        end
    end
end
%% calculate actual scov
genSCOV = genhetarea/(4*PI*RJET^2.0);
%% draw geometry if requested
if nfig>0
        %% draw collector circle
        JETcircle3D(Xm0,Ym0,Zm0,RJET,nfig)
        %% draw hetdomains
        if HETMODE ==1
            figure (nfig)
            plot3 (XHETall,YHETall,ZHETall,'o k','MarkerFaceColor','g','MarkerLineColor','none','MarkerSize',5)
            axis square, hold on; grid on; 
        end
        if HETMODE ==5
            % sort hetdomains
            cont = HETMODE; cb=1;cs=1;
            for i=1:k-1
                if cont==HETMODE
                    % extract large hetdomains
                    XHETbig(cb)=XHETall(i);
                    YHETbig(cb)=YHETall(i);
                    ZHETbig(cb)=ZHETall(i);
                    RHETbig(cb)=RHETall(i);
                    % count large hetdomains
                    cb=cb+1;
                    cont = 1;
                else
                    % extract small hetdomains
                    XHETsmall(cs)=XHETall(i);
                    YHETsmall(cs)=YHETall(i);
                    ZHETsmall(cs)=ZHETall(i);
                    RHETsmall(cs)=RHETall(i);
                    % count large hetdomains
                    cs=cs+1;
                    cont = 1+cont;
                end
            end
            figure (nfig)
            plot3 (XHETbig,YHETbig,ZHETbig,'o k','MarkerFaceColor','g','MarkerSize',6)
            axis square, hold on; grid on; 
            figure (nfig)
            plot3 (XHETsmall,YHETsmall,ZHETsmall,'o k','MarkerFaceColor','g','MarkerSize',3)
            axis square, hold on; grid on; 

        % the option below works too but is slow   
        %     for i=1:k-1
        %     figure (nfig)
        %     plot3 (XHETall(i),YHETall(i),ZHETall(i),'o k','MarkerFaceColor','g','MarkerSize',5*RHETall(i)/RHET0)
        %     axis square; hold on; grid on; 
        %     end
        end
end
end % function HAPHETGEN










