%Energy vdW_Sphere-Plate_coated systems(J)
function [E_vdW_CS]=E_vdW_SP_coated_systems(H,a1,lambdavdW,...
                    T1,T2,Ac_1p_2p,Ac_1_2p,Ac_1p_2,Ac_1_2,system)
 ap=a1-T2;%colloid core radius          
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
            C2= 2*ap+2*T1;
         end
         %coefficient 3
          if Ac_1p_2p==0
            C3=0;
            else
            C3= 2*ap+T1;
          end
          %Coefficient 4
          if Ac_1p_2p==0
            C4=0;
            else
            C4= 2*ap+2*T1+T2;
          end
         %Coefficient 5
          if Ac_1p_2p==0
            C5=0;
            else
            C5= T1+T2;
          end
          %Coefficient 6
          if Ac_1p_2p==0
            C6=0;
            else
            C6=2*ap+T1+T2;
          end
          %Colloid coating thickness 1
          if Ac_1p_2p==0
              T1=0;
          end         
         %Colloid coating thickness 2
          if Ac_1p_2p==0
              T2=0;
          end  
             
    E_vdW_CS=-Ac_1p_2p*(1/6*(C1./H+C1./(H+C2)+log(H./(H+C2)))...
        .*(lambdavdW./(lambdavdW+11.12.*H)))-Ac_1_2p...
        *(1/6*(ap./(H+T1)+ap./(H+C3)+log((H+T1)./(H+C3)))...
        .*(lambdavdW./(lambdavdW+11.12.*(H+T1))))-Ac_1p_2...
        *(1/6*(C1./(H+T2)+C1./(H+C4)+log((H+T2)./(H+C4)))...
        .*(lambdavdW./(lambdavdW+11.12.*(H+T2))))-Ac_1_2...
        *(1/6*(ap./(H+C5)+ap./(H+C6)+log((H+C5)./(H+C6)))...
        .*(lambdavdW./(lambdavdW+11.12.*(H+C5))));
     end
     
    if system==2
        if Ac_1_2==0
            T2=0;   
        end
          %Coefficient 1      
         if Ac_1_2==0
            C1=0;
            else
            C1= ap*2;
         end
         %coefficient 2
         if Ac_1_2==0
            C2=0;
            else
            C2= ap*2+T2;
         end
         
    E_vdW_CS=-Ac_1_2p*(1/6*(ap./H+ap./(H+C1)+log(H./(H+C1)))...
        .*(lambdavdW./(lambdavdW+11.12.*H)))-Ac_1_2...
        *(1/6*(ap./(H+T2)+ap./(H+C2)+log((H+T2)./(H+C2)))...
        .*(lambdavdW./(lambdavdW+11.12.*(H+T2))));
         
     end
     
     if system==3
         if Ac_1p_2==0
             C1=0;
         else
             C1=ap+T1;
         end
         
         if Ac_1p_2==0
             C2=0;
         else
             C2=ap*2+T1*2;
         end
         
         if Ac_1p_2==0
             C3=0;
         else
             C3=2*ap+T1;
         end
      
      E_vdW_CS=-Ac_1p_2*(1/6*(C1./H+C1./(H+C2)+log(H./(H+C2)))...
          .*(lambdavdW./(lambdavdW+11.12.*H)))-Ac_1_2...
          *(1/6*(ap./(H+T1)+ap./(H+C3)+log((H+T1)./(H+C3)))...
          .*(lambdavdW./(lambdavdW+11.12.*(H+T1))));
         
     end

end