%Energy vdW_Sphere-Plate_coated systems(J)
function [E_vdW_CS]=E_vdW_SS_coated_systems(H,a1,a2,lambdavdW,...
                    T1,T2,Ac_1p_2p,Ac_1_2p,Ac_1p_2,Ac_1_2,system)
 ap=a1-T1;%colloid core radius  
 ac=a2-T2;%collector core radius         
 %% TYPEs OF COATED SYSTEM  
 
     if system==1 %Layered_colloid_Layered_collector  
         
          %Coefficient 1      
         if Ac_1p_2p==0
            C1=0;
            else
            C1= ap+T1;
         end
         %coefficient 2
         if Ac_1p_2p==0
            C2=0;
            else
            C2= ac+T2;
         end
         %coefficient 3
          if Ac_1p_2p==0
            C3=0;
            else
            C3= ap+ac+T1+T2;
          end
          %Coefficient 4
          if Ac_1p_2p==0
            C4=0;
            else
            C4= ap+ac+T2;
          end
         %Coefficient 5
          if Ac_1p_2p==0
            C5=0;
            else
            C5=ap+ac+T1;
          end
          %Coefficient 6
          if Ac_1p_2p==0
            C6=0;
            else
            C6=T1+T2;
          end
          %Coefficient 7
          if Ac_1p_2p==0
            C7=0;
            else
            C7=ap+ac;
          end
             
    E_vdW_CS=-Ac_1p_2p*(1/6*(2*C1*C2./(H.^2+2.*H*C3)...
            +2*C1*C2./(H.^2+2.*H*C3+4*C1*C2)+log((H.^2+2.*H*C3)...
            ./(H.^2+2.*H*C3+4*C1*C2))).*(lambdavdW./(lambdavdW+11.12.*H)))...
            -Ac_1_2p*(1/6*(2*(a1-T1)*C2./((H+T1).^2 ...
            +2.*(H+T1)*C4)+2*(a1-T1)*C2./((H+T1).^2 ...
            +2.*(H+T1)*C4+4*(a1-T1)*C2)...
            +log(((H+T1).^2+2.*(H+T1)*C4)./((H+T1).^2+2.*(H+T1)...
            *C4+4*(a1-T1)*C2))).*(lambdavdW./(lambdavdW+11.12.*(H+T1))))...
            -Ac_1p_2*(1/6*(4*C1*(a2-T2)./((H+T2).^2+2.*(H+T2)*C5)...
            +2*C1*(a2-T2)./((H+T2).^2+2.*(H+T2)*C5+4*C1*(a2-T2))...
            +log(((H+T2).^2+2.*(H+T2)*C5)./((H+T2).^2 ...
            +2.*(H+T2)*C5+4*(a2-T2)*C1)))...
            .*(lambdavdW./(lambdavdW+11.12.*(H+T2))))...
            -Ac_1_2*(1/6*(2*(a1-T1)*(a2-T2)./((H+T1+T2).^2 ...
            +2.*(H+T1+T2)*C7)+2*(a1-T1)*(a2-T2)./((H+T1+T2).^2 ...
            +2.*(H+T1+T2)*C7+4*(a1-T1)*(a2-T2))+log(((H+T1+T2).^2 ...
            +2.*(H+T1+T2)*C7)./((H+T1+T2).^2+2.*(H+T1+T2)*C7...
            +4*(a1-T1)*(a2-T2))))...
            .*(lambdavdW./(lambdavdW+11.12.*(H+T1+T2))));
     end
     
    if system==2 %Colloid - Layered Collector
        if Ac_1_2==0
            T2=0;   
        end
          %Coefficient 1      
         if Ac_1_2p==0
            C1=0;
            else
            C1= (a2-T2)+T2; %CHECK THIS REDUNDANCY IN EXCEL FILE
         end
         %coefficient 2
         if Ac_1_2p==0
            C2=0;
            else
            C2= a1+a2-T2+T2; %CHECK THIS REDUNDANCY IN EXCEL FILE
         end
         %coefficient 3
         if Ac_1_2p==0
            C3=0;
            else
            C3= a1+a2-T2;
         end
         
    E_vdW_CS=-Ac_1_2p*(1/6*(2*a1*C1./(H.^2+2.*H*C2)...
            +2*a1*C1./(H.^2+2.*H*C2+4*a1*C1)...
            +log((H.^2+2.*H*C2)./(H.^2+2.*H*C2+4*a1*C1)))...
            .*(C1./(C1+11.12.*H)))+Ac_1_2*(1/6*(2*a1*(a2-T2)...
            ./((H+T2).^2+2.*(H+T2)*C3)+2*a1*(a2-T2)...
            ./((H+T2).^2+2.*(H+T2)*C3+4*a1*(a2-T2))...
            +log(((H+T2).^2+2.*(H+T2)*C3)./((H+T2).^2 ...
            +2.*(H+T2)*C3+4*a1*(a2-T2)))).*(C1./(C1+11.12.*(H+T2))));
         
     end
     
     if system==3 %Layered Colloid - Collector 
          if Ac_1p_2==0
             T1=0;
         end
         %Coefficient 1 
         if Ac_1p_2==0
             C1=0;
         else
             C1=a1-T1+T1;
         end
         %Coefficient 2 
         if Ac_1p_2==0
             C2=0;
         else
             C2=a1+a2-T1+T1;
         end
         %Coefficient 3 
         if Ac_1p_2==0
             C3=0;
         else
             C3=a1+a2-T1;
         end

      E_vdW_CS=-Ac_1p_2*(1/6*(2*C1*a2./(H.^2+2.*H*C2)...
            +2*C1*a2./(H.^2+2.*H*C2+4*C1*a2)...
            +log((H.^2+2.*H*C2)./(H.^2+2.*H*C2+4*C1*a2)))...
            .*(C1./(C1+11.12.*H)))-Ac_1_2*(1/6*(2*a2*(a1-T1)...
            ./((H+T1).^2+2.*(H+T1)*C3)+2*a2*(C1-T1)...
            ./((H+T1).^2+2.*(H+T1)*C3+4*a2*(a1-T1))...
            +log(((H+T1).^2+2.*(H+T1)*C3)./((H+T1).^2 ...
            +2.*(H+T1)*C3+4*a2*(a1-T1)))).*(C1./(C1+11.12.*(H+T1))));
         
     end

end