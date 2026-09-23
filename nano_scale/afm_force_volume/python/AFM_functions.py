import numpy as np
import shutil
import math
import pandas as pd
from pathlib import Path
import zipfile
from openpyxl import load_workbook


def AFMFORCEBORN(A132, SIGMAC, AP, H, A11, A22, A33, AC1C1, AC2C2, VDWMODE):
    '''SUBROUTINE BORN FORCE (N) (DERIVED FROM ENERGY GIVEN BY RUCKENSTEIN & PRIEVE 1976)'''
    
    # FBORN = (A132*SIGMAC**6/1260)*((7*AP-H)/H**8+(9*AP+H)/(2*AP+H)**8)
    # Calculate intermediate variables
    A1C2 = np.sqrt(A11) * np.sqrt(AC2C2)
    A13 = np.sqrt(A11) * np.sqrt(A33)
    AC12 = np.sqrt(AC1C1) * np.sqrt(A22)
    AC1C2 = np.sqrt(AC1C1) * np.sqrt(AC2C2)
    AC13 = np.sqrt(AC1C1) * np.sqrt(A33)
    A23 = np.sqrt(A22) * np.sqrt(A33)
    AC23 = np.sqrt(AC2C2) * np.sqrt(A33)

    # Initialize FBORN
    FBORN = 0.0

    # Calculate FBORN based on VDWMODE
    if VDWMODE == 1:
        FBORN = (abs(A132) * SIGMAC**6 / 1260) * ((7 * AP - H) / H**8 + (9 * AP + H) / (2 * AP + H)**8)
    elif VDWMODE == 2:
        FBORN = (abs(AC1C2 - AC23 - AC13 + A33) * SIGMAC**6 / 1260) * ((7 * AP - H) / H**8 + (9 * AP + H) / (2 * AP + H)**8)
    elif VDWMODE == 3:
        FBORN = (abs(A1C2 - AC23 - A13 + A33) * SIGMAC**6 / 1260) * ((7 * AP - H) / H**8 + (9 * AP + H) / (2 * AP + H)**8)
    elif VDWMODE == 4:
        FBORN = (abs(AC12 - A23 - AC13 + A33) * SIGMAC**6 / 1260) * ((7 * AP - H) / H**8 + (9 * AP + H) / (2 * AP + H)**8)

    # Set FBORN to zero if it is very small
    if abs(FBORN) < 1.0E-30:
        FBORN = 0.0

    return FBORN

def AFMFORCESTE(PI, GAMMA0STE, LAMBDASTE, ASTE, H):
    '''SUBROUTINE STERIC FORCE'''
    # Calculate FSTE
    FSTE = (GAMMA0STE / LAMBDASTE) * np.exp(-H / LAMBDASTE) * PI * ASTE**2

    # Set FSTE to zero if it is very small
    if abs(FSTE) < 1.0E-30:
        FSTE = 0.0

    return FSTE

def AFMFORCEAB(PI, AG, AP, ASPcolloid, ASPdomain, RMODE, LAMBDAAB, GAMMA0AB, H, H0,
               X,Y, Z, xcap, ycap, zcap, xasp_domain, yasp_domain, zasp_domain, LTLT,
               AFM_asp_tracking_RMODE3):
    '''SUBROUTINE LEWIS ACID-BASE FORCE (N) (DERIVED FROM WOOD & REHMANN 2014)'''

    if RMODE == 0:   # SMOOTH COLLOID AND COLLECTOR
        # CALCULATE THE EFFECTIVE RADIUS USING COLLOID AND COLLECTOR RADIUS
        AEFF = 2 * (AP * AG) / (AP + AG)
        # LOWER BOUND ON GEOMETRIC CORRECTION - SPHERE-PLATE APPROXIMATION USING EFFECTIVE RADIUS
        LOWGEO = 1 - LAMBDAAB / AEFF + (1 + LAMBDAAB / AEFF) * np.exp(-2 * AEFF / LAMBDAAB)
        # UPPER BOUND ON GEOMETRIC CORRECTION - SAME SIZE SPHERE-SPHERE APPROXIMATION USING EFFECTIVE RADIUS
        HIGHGEO = 1 - LAMBDAAB / AEFF + LAMBDAAB**2.0 / (2 * AEFF**2.0) - \
                  (4 * AEFF / (3 * LAMBDAAB)) * np.exp(-2 * AEFF / LAMBDAAB) - \
                  (1 + LAMBDAAB / AEFF + LAMBDAAB**2.0 / (2 * AEFF**2.0)) * \
                  np.exp(-4 * AEFF / LAMBDAAB)
        # GEOMETRIC CORRECTION FOR SPHERE-SPHERE
        COEFF = (1 - AP / AG) * LOWGEO + AP / AG * HIGHGEO
        # CALCULATE AB INTERACTION BETWEEN COLLOID AND COLLECTOR (SPHERE-SPHERE)
        FAB = COEFF * PI * AEFF * GAMMA0AB * np.exp(-(H - H0) / LAMBDAAB)

    elif RMODE == 1:   # ASPERITIES ON COLLOID
        # CALCULATE THE EFFECTIVE RADIUS USING ASPERITY AND COLLECTOR RADIUS
        AEFF = 2 * (ASPcolloid * AG) / (ASPcolloid + AG)
        # LOWER BOUND ON GEOMETRIC CORRECTION - SPHERE-PLATE APPROXIMATION USING EFFECTIVE RADIUS
        LOWGEO = 1 - LAMBDAAB / AEFF + (1 + LAMBDAAB / AEFF) * np.exp(-2 * AEFF / LAMBDAAB)
        # UPPER BOUND ON GEOMETRIC CORRECTION - SAME SIZE SPHERE-SPHERE APPROXIMATION USING EFFECTIVE RADIUS
        HIGHGEO = 1 - LAMBDAAB / AEFF + LAMBDAAB**2.0 / (2 * AEFF**2.0) - \
                  (4 * AEFF / (3 * LAMBDAAB)) * np.exp(-2 * AEFF / LAMBDAAB) - \
                  (1 + LAMBDAAB / AEFF + LAMBDAAB**2.0 / (2 * AEFF**2.0)) * \
                  np.exp(-4 * AEFF / LAMBDAAB)
        # GEOMETRIC CORRECTION FOR SPHERE-SPHERE
        COEFF = (1 - ASPcolloid / AG) * LOWGEO + ASPcolloid / AG * HIGHGEO
        # CALCULATE AB INTERACTION BETWEEN ASPERITIES AND DOMAIN (SPHERE-SPHERE)
        # vectorized calculation for array of separation distances
        '''Problems when using roughness because of use of lists instead of arrays (ycap)'''
        Hasp_colloid = ycap - AG - ASPcolloid
        # calculate only for asperities inside Hthreshold
        c = Hasp_colloid <= 1 / LTLT * ASPcolloid
        if sum(c) >= 1:
            # extract valid separation distances
            Hasp_colloid=Hasp_colloid[c]
            FAB1 = COEFF * PI * AEFF * GAMMA0AB * np.exp(-(Hasp_colloid - H0) / LAMBDAAB)
        else:
            FAB1 = np.array([0.0])
        # CALCULATE TOTAL INTERACTION
        FAB = sum(FAB1)

    elif RMODE == 2:   # ASPERITIES ON DOMAIN
        # CALCULATE THE EFFECTIVE RADIUS USING ASPERITY AND COLLOID RADIUS
        AEFF = 2 * (ASPdomain * AP) / (ASPdomain + AP)
        # LOWER BOUND ON GEOMETRIC CORRECTION - SPHERE-PLATE APPROXIMATION USING EFFECTIVE RADIUS
        LOWGEO = 1 - LAMBDAAB / AEFF + (1 + LAMBDAAB / AEFF) * np.exp(-2 * AEFF / LAMBDAAB)
        # UPPER BOUND ON GEOMETRIC CORRECTION - SAME SIZE SPHERE-SPHERE APPROXIMATION USING EFFECTIVE RADIUS
        HIGHGEO = 1 - LAMBDAAB / AEFF + LAMBDAAB**2.0 / (2 * AEFF**2.0) - \
                  (4 * AEFF / (3 * LAMBDAAB)) * np.exp(-2 * AEFF / LAMBDAAB) - \
                  (1 + LAMBDAAB / AEFF + LAMBDAAB**2.0 / (2 * AEFF**2.0)) * \
                  np.exp(-4 * AEFF / LAMBDAAB)
        # GEOMETRIC CORRECTION FOR SPHERE-SPHERE
        COEFF = (1 - ASPdomain / AP) * LOWGEO + ASPdomain / AP * HIGHGEO
        # CALCULATE AB INTERACTION BETWEEN ASPERITIES AND COLLOID (SPHERE-SPHERE)
        #  vectorized calculation for array of separation distances
        #  array of distances between asperity centers and colloid center
        RXYZ = np.sqrt((X-xasp_domain)*(X-xasp_domain)+(Y-yasp_domain)*(Y-yasp_domain) + (Z-zasp_domain)*(Z-zasp_domain))
        # factor of projection on  Y component (array)
        facY =  (Y-AG)/RXYZ
        # separation distance between asperity and colloid surface
        Hasp_domain = RXYZ-AP-ASPdomain
        # # calculate only for asperities inside Hthreshold
        c=Hasp_domain <= 1/LTLT*ASPdomain
        if sum(c)>=1:
            # extract valid separation distances
            Hasp_domain=Hasp_domain[c]
            facY = facY[c]
            FAB1 = COEFF*PI*AEFF*GAMMA0AB*np.exp(-(Hasp_domain-H0)/LAMBDAAB)
        else:
            FAB1 = np.array([0.0])
        
        # #         CALCULATE TOTAL INTERACTION
        FAB = sum(facY*FAB1)

    elif RMODE == 3:    # ASPERITIES ON BOTH SURFACES
        AEFF = 2 * (ASPdomain * ASPcolloid) / (ASPdomain + ASPcolloid)

        # GEOMETRIC CORRECTION FOR SAME SIZE SPHERE
        COEFF = 1 - LAMBDAAB / AEFF + LAMBDAAB**2.0 / (2 * AEFF**2.0) - \
                (4 * AEFF / (3 * LAMBDAAB)) * np.exp(-2 * AEFF / LAMBDAAB) - \
                (1 + LAMBDAAB / AEFF + LAMBDAAB**2.0 / (2 * AEFF**2.0)) * \
                np.exp(-4 * AEFF / LAMBDAAB)
        
        #  loop through one colloid asperity interacting with
        #  a subdomain of asperities in ZOI
        #  pralocate array of asperities contributions to interaction
        FAB1 = np.full(len(xcap), np.nan)
        #  define bounds of zoi subset
        Rsubdomain = 2*ASPdomain
        #  determine smaller asperity size
        if ASPdomain <= ASPcolloid:
            ASPsmaller = ASPdomain
        else:
            ASPsmaller = ASPcolloid
        
        for i in range(0,len(xcap)):
            # # vectorized calculation for array of separation distances
            xcol = xcap[i]
            ycol = ycap[i]
            zcol = zcap[i]
            # # call function to track asperities in subset of ZOI on the collector near projected colloid asperity location
            xasp, yasp, zasp = AFM_asp_tracking_RMODE3(xcol,ycol,zcol,AG,Rsubdomain,ASPdomain)
            Harray = np.sqrt((xcol-xasp)*(xcol-xasp)+(ycol-yasp)*(ycol-yasp)+(zcol-zasp)*(zcol-zasp))-ASPcolloid-ASPdomain
            # # find minnimum separtion distance
            imin = np.argmin(Harray)
            Hmin = Harray[imin]
            # # calculate only for asperities inside Hthreshold

            if Hmin<=1/LTLT*ASPsmaller:
                #  array of total interaction of a single colloid asperity with
                #  all domain asperities
                FABoneasp = COEFF*PI*AEFF*GAMMA0AB*np.exp(-(Hmin-H0)/LAMBDAAB)
                #  array of distances between colloid asperity center and domain asperities centers
                RXYZ = np.sqrt((xcol-xasp[imin])*(xcol-xasp[imin])+(ycol-yasp[imin])*(ycol-yasp[imin]) + (zcol-zasp[imin])*(zcol-zasp[imin]))
                #  calculate unit vectors pointing from domains asperity to
                #  colloid asperity center. DLVO forces contribution is only in
                #  Y (laterals cancel each other)
                unity = (ycol-yasp[imin])/RXYZ
                #  disp(unity)
                #  Correct array of interactions to component on Y axis
                FAB1[i] = unity*FABoneasp
            else:
                FAB1[i]=0.0
          
        #          CALCULATE TOTAL INTERACTION
        FAB = sum(FAB1)

    if abs(FAB) < 1.0E-30:
        FAB = 0.0

    return FAB

def AFM_asp_tracking_RMODE3(x,y,z,AG,Rsubdomain,ASP_domain):

    '''function to track asperities in subset of ZOI on the collector near projected colloid asperity location ''' 
    #  x,y,z colloid asperity location
    #  AG collector radius (defines collector plane above origin at collector
    #  center)
    #  Rsubdomain is the subset of ZOI on the collector near projected colloid asperity
    #  ASP_domain collector asperities radius
    #  
    # OUTPUT:
    #  xasp,yasp,zasp array of asperities centers
    # 
    #  grid step size
    step = 2*ASP_domain
    #  find closest  node of regular location of asperities to colloid
    #  projection
    #  determine integer number of steps in grid and fraction of steps
    xn_int = np.fix(x/(step))
    xn_fract = (x/(step))-xn_int
    zn_int = np.fix(z/(step))
    zn_fract = (z/(step))-zn_int
    #  update the integer deping of the fraction
    if (xn_fract>0.5) and (xn_fract>=0.0):
        xn_int=xn_int+1
    if (xn_fract<-0.5) and (xn_fract<=0.0):
        xn_int=xn_int-1
    if (zn_fract>0.5) and (zn_fract>=0.0):
        zn_int=zn_int+1
    if (zn_fract<-0.5) and (zn_fract<=0.0):
        zn_int=zn_int-1
    #  create array around closest node
    n_steps = int(
        np.floor(
            Rsubdomain / step
        )
    )

    offsets = (
        np.arange(
            -n_steps,
            n_steps + 1,
            dtype=float,
        )
        * step
    )

    xrange = (
        xn_int * step
        + offsets
    )

    zrange = (
        zn_int * step
        + offsets
    )
    #  create local mesh using meshgrid
    xasp,zasp = np.meshgrid(xrange,zrange)
    #  trasnform matrices to vectors
    xasp=xasp.flatten()
    zasp=zasp.flatten()
    #  obtain y value (planar)
    yasp = np.full_like(xasp,AG, dtype=np.float64)

    return xasp, yasp, zasp

def AFMFORCEVDW(X,Y,Z,A132,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,
                xcap,ycap,zcap,xasp_domain,yasp_domain,zasp_domain,H,HS,
                LAMBDAVDW,A11,A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE, LTLT,
                AFM_asp_tracking_RMODE3):
    
    '''SUBROUTINE VDW FORCE (N)'''

    A12 = np.sqrt(A11) * np.sqrt(A22)
    A1C2 = np.sqrt(A11) * np.sqrt(AC2C2)
    A13 = np.sqrt(A11) * np.sqrt(A33)
    AC12 = np.sqrt(AC1C1) * np.sqrt(A22)
    AC1C2 = np.sqrt(AC1C1) * np.sqrt(AC2C2)
    AC13 = np.sqrt(AC1C1) * np.sqrt(A33)
    A23 = np.sqrt(A22) * np.sqrt(A33)
    AC23 = np.sqrt(AC2C2) * np.sqrt(A33)

    # asperitis separation distance arrays
    Hasp_colloid = np.zeros_like(ycap)
    Hasp_domain =np.zeros_like(xasp_domain)
    FVDW2 = np.zeros_like(xcap)

    # determine geometry factor for smooth surfaces
    AEFF = AP * AG / (AP + AG)

    
    #   CALC VDW (SPHERE-SPHERE GEOMETRY JUSTIFIED BY LINEAR APPROXIMATION) Gregory retarded vdw energy 1981 from Elimelech Part. Dep book
    if VDWMODE == 1:
        if RMODE == 0:   # SMOOTH SURFACE ON BOTH 
            FVDW = -(A132 * AEFF /(6.0 * H**2.0)) * (LAMBDAVDW / (LAMBDAVDW + 5.32 * H)) # (SPHERE-SPHERE GEOMETRY) -RETARDED VAN DER WAALS np.expRESSION DERIVED FROM ENERGY GIVEN BY NIR 1977 INCLUDING RETARDATION FROM GREGORY 1981
        elif RMODE == 1:   # ASPERITIES ON COLLOID
            # Determine geometry factor for asperities
            AEFFASP = ASPcolloid * AG / (ASPcolloid + AG)
            H2 = H + ASPcolloid  # SEPARATION DISTANCE BETWEEN UNDERLYING SMOOTH COLLECTOR AND COLLOID
            # CALCULATE VDW INTERACTION BETWEEN COLLOID AND COLLECTOR (SPHERE-SPHERE)
            FVDW1 = -(A132 *AEFF/ (6.0 * H2**2.0)) * (LAMBDAVDW / (LAMBDAVDW + 5.32 * H2))
            # vectorized calculation for array of separation distances
            Hasp_colloid = ycap - AG - ASPcolloid
            '''Va a soltar un error al trabajar con vectores vacios'''
            # calculate only for asperities inside Hthreshold 
            c = Hasp_colloid<=1/LTLT*ASPcolloid        
            if sum(c)>=1:
                # extract valid separation distances
                Hasp_colloid=Hasp_colloid[c]
                # CALCULATE VDW INTERACTION BETWEEN ASPERITIES AND COLLECTOR (SPHERE-SPHERE)
                FVDW2 = -(A132 *AEFFASP / (6.0 * Hasp_colloid**2.0)) * (LAMBDAVDW / (LAMBDAVDW + 5.32 * Hasp_colloid))
            else:
                FVDW2 = np.array([0.0])
            # CALCULATE TOTAL INTERACTION
            FVDW = FVDW1 + sum(FVDW2)

        elif RMODE == 2:   # ASPERITIES ON COLLECTOR
             # Determine geometry factor for asperities
            AEFFASP = ASPdomain * AG / (ASPdomain + AG)
            H2 = HS  # SEPARATION DISTANCE BETWEEN UNDERLYING SMOOTH COLLECTOR AND COLLOID
            # CALCULATE VDW INTERACTION BETWEEN COLLOID AND COLLECTOR (SPHERE-SPHERE)
            FVDW1 = -(A132 * AEFF / (6.0 * H2**2.0)) * (LAMBDAVDW / (LAMBDAVDW + 5.32 * H2))
            #  vectorized calculation for array of separation distances
            #  array of distances between asperity centers and colloid center
            RXYZ = np.sqrt((X-xasp_domain)*(X-xasp_domain)+(Y-yasp_domain)*(Y-yasp_domain) + (Z-zasp_domain)*(Z-zasp_domain))
            #  factor of projection on  Y component (array)
            facY =  (Y-AG)/RXYZ
            #  separation distance between asperity and colloid surface
            Hasp_domain = RXYZ-AP-ASPdomain
            # calculate only for asperities inside Hthreshold 
            c=Hasp_domain<=1/LTLT*ASPdomain
            if sum(c)>=1:
                # extract valid separation distances
                Hasp_domain=Hasp_domain[c]
                facY = facY[c]
                FVDW2 = -(A132*AEFFASP/(6*Hasp_domain**2.0))*(LAMBDAVDW/(LAMBDAVDW+5.32*Hasp_domain))
            else:
                FVDW2 = np.array([0.0])
            # CALCULATE TOTAL INTERACTION
            FVDW = FVDW1 + sum(facY*FVDW2)

        # RMODE 3 treatment assumes equivalent fine scale roughness on
        # both surfaces because of fractal nature of roughness
        elif RMODE == 3:    # ASPERITIES ON BOTH SURFACES
            #   determine geometry factor for asperities
            AEFFASP = ASPdomain*ASPcolloid/(ASPdomain+ASPcolloid)
            #  SEPARATION DISTANCE BETWEEN SMOOTH SURFACES
            H2 = np.sqrt((X-0)*(X-0)+(Y-0)*(Y-0)+(Z-0)*(Z-0))-AP-AG
            # CALCULATE VDW INTERACTION BETWEEN COLLOID AND COLLECTOR (SPHERE-SPHERE)
            FVDW1 = -(A132*AEFF/(6*H2**2.0))*(LAMBDAVDW/(LAMBDAVDW+5.32*H2))
            #  CALCULATE VDW INTERACTION BETWEEN ASPERITIES (SPHERE-SPHERE GEOMETRY JUSTifIED BY LINEAR APPROXIMATION) Gregory retarded vdw energy 1981 from Elimelech Part. Dep book
            #  loop through one colloid asperity interacting with
            #  a subdomain of asperities in ZOI
            #  pralocate array of asperities contributions to interaction
            FVDW2 = np.full_like(xcap, np.nan)
            #  define bounds of zoi subset
            Rsubdomain = 2*ASPdomain
            #  determine smaller asperity size
            if ASPdomain<=ASPcolloid:
                ASPsmaller = ASPdomain
            else:
                ASPsmaller = ASPcolloid
            
            for i in range(len(xcap)):
                #  vectorized calculation for array of separation distances
                xcol = xcap[i]
                ycol = ycap[i]
                zcol = zcap[i]
                #  call function to track asperities in subset of ZOI on the collector near projected colloid asperity location
                xasp,yasp,zasp = AFM_asp_tracking_RMODE3(xcol,ycol,zcol,AG,Rsubdomain,ASPdomain)
                Harray = np.sqrt((xcol-xasp)*(xcol-xasp)+(ycol-yasp)*(ycol-yasp)+(zcol-zasp)*(zcol-zasp))-ASPcolloid-ASPdomain
                #  find minnimum separtion distance
                imin = np.argmin(Harray)
                Hmin = Harray[imin]
                #  calculate only for asperities inside Hthreshold

                if Hmin<=1/LTLT*ASPsmaller: 
                    #  array of total interaction of a single colloid asperity with
                    #  all domain asperities
                    FVDWoneasp = -(A132*AEFFASP/(6*Hmin**2.0))*(LAMBDAVDW/(LAMBDAVDW+5.32*Hmin))
                    #  array of distances between colloid asperity center and domain asperities centers
                    RXYZ = np.sqrt((xcol-xasp[imin])*(xcol-xasp[imin])+(ycol-yasp[imin])*(ycol-yasp[imin]) + (zcol-zasp[imin])*(zcol-zasp[imin]))
                    #  calculate unit vectors pointing from domains asperity to
                    #  colloid asperity center. DLVO forces contribution is only in
                    #  Y (laterals cancel each other)
                    unity = (ycol-yasp[imin])/RXYZ
                    #  disp(unity)
                    #  Correct array of interactions to component on Y axis
                    FVDW2[i] = unity*FVDWoneasp
                else:
                    FVDW2[i]=0.0
            #   CALCULATE TOTAL INTERACTION
            FVDW = FVDW1 + sum(FVDW2)
        
    # VDW np.expRESSION DERIVED FROM np.expRESSION DEVELOPED BY Nir 1977 AND Vincent 1973. RETARDATION FACTOR AS SUGGESTED BY Ho AND Higuchi 1968
    elif VDWMODE == 2:
        ACP = AP - T1
        ACG = AG - T2
        COEFH1 = H
        COEFH2 = H + T1
        COEFH3 = H + T2
        COEFH4 = H + T1 + T2
        COEFA1 = ACP + T1
        COEFA2 = ACG + T2
        COEF = ACP + ACG + T1 + T2
        COEF2 = ACP + ACG + T2
        COEF3 = ACP + ACG + T1
        COEF4 = ACP + ACG
        COEF5 = H + ACP + ACG + T1 + T2
        FVDW = -(AC1C2 - AC23 - AC13 + A33) * \
               (LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH1) * \
               (4 * COEFA1 * COEFA2 * COEF5 * (1 / (COEFH1**2 + 2 * COEFH1 * COEF)**2.0 \
               + 1 / (COEFH1**2 + 2 * COEFH1 * COEF + 4 * COEFA1 * COEFA2)**2) \
               - 2 * COEF5 * (1 / (COEFH1**2 + 2 * COEFH1 * COEF) \
               - 1 / (COEFH1**2 + 2 * COEFH1 * COEF + 4 * COEFA1 * COEFA2))) \
               + 11.12 * LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH1)**2 * \
               (2 * COEFA1 * COEFA2 / (COEFH1**2 + 2 * COEFH1 * COEF) \
               + 2 * COEFA1 * COEFA2 / (COEFH1**2 + 2 * COEFH1 * COEF \
               + 4 * COEFA1 * COEFA2) \
               + np.log((COEFH1**2 + 2 * COEFH1 * COEF) / \
               (COEFH1**2 + 2 * COEFH1 * COEF + 4 * COEFA1 * COEFA2)))) / 6.0 \
               -(A1C2 - AC1C2 - A13 + AC13) * \
               (LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH2) * \
               (4 * ACP * COEFA2 * COEF5 * (1 / (COEFH2**2 + 2 * COEFH2 * COEF2)**2.0 \
               + 1 / (COEFH2**2 + 2 * COEFH2 * COEF2 + 4 * ACP * COEFA2)**2) \
               - 2 * COEF5 * (1 / (COEFH2**2 + 2 * COEFH2 * COEF2) \
               - 1 / (COEFH2**2 + 2 * COEFH2 * COEF2 + 4 * ACP * COEFA2))) \
               + 11.12 * LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH2)**2 * \
               (2 * ACP * COEFA2 / (COEFH2**2 + 2 * COEFH2 * COEF2) \
               + 2 * ACP * COEFA2 / (COEFH2**2 + 2 * COEFH2 * COEF2 \
               + 4 * ACP * COEFA2) \
               + np.log((COEFH2**2 + 2 * COEFH2 * COEF2) / \
               (COEFH2**2 + 2 * COEFH2 * COEF2 + 4 * ACP * COEFA2)))) / 6.0 \
               -(AC12 - A23 - AC1C2 + AC23) * \
               (LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH3) * \
               (4 * COEFA1 * ACG * COEF5 * (1 / (COEFH3**2 + 2 * COEFH3 * COEF3)**2.0 \
               + 1 / (COEFH3**2 + 2 * COEFH3 * COEF3 + 4 * COEFA1 * ACG)**2) \
               - 2 * COEF5 * (1 / (COEFH3**2 + 2 * COEFH3 * COEF3) \
               - 1 / (COEFH3**2 + 2 * COEFH3 * COEF3 + 4 * COEFA1 * ACG))) \
               + 11.12 * LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH3)**2 * \
               (2 * COEFA1 * ACG / (COEFH3**2 + 2 * COEFH3 * COEF3) \
               + 2 * COEFA1 * ACG / (COEFH3**2 + 2 * COEFH3 * COEF3 \
               + 4 * COEFA1 * ACG) \
               + np.log((COEFH3**2 + 2 * COEFH3 * COEF3) / \
               (COEFH3**2 + 2 * COEFH3 * COEF3 + 4 * COEFA1 * ACG)))) / 6.0 \
               -(A12 - AC12 - A1C2 + AC1C2) * \
               (LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH4) * \
               (4 * ACP * ACG * COEF5 * (1 / (COEFH4**2 + 2 * COEFH4 * COEF4)**2.0 \
               + 1 / (COEFH4**2 + 2 * COEFH4 * COEF4 + 4 * ACP * ACG)**2) \
               - 2 * COEF5 * (1 / (COEFH4**2 + 2 * COEFH4 * COEF4) \
               - 1 / (COEFH4**2 + 2 * COEFH4 * COEF4 + 4 * ACP * ACG))) \
               + 11.12 * LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH4)**2 * \
               (2 * ACP * ACG / (COEFH4**2 + 2 * COEFH4 * COEF4) \
               + 2 * ACP * ACG / (COEFH4**2 + 2 * COEFH4 * COEF4 \
               + 4 * ACP * ACG) \
               + np.log((COEFH4**2 + 2 * COEFH4 * COEF4) / \
               (COEFH4**2 + 2 * COEFH4 * COEF4 + 4 * ACP * ACG)))) / 6

    elif VDWMODE == 3:
        ACP = AP
        ACG = AG - T2
        COEFH1 = H
        COEFH2 = H + T2
        COEFA2 = ACG + T2
        COEF = ACP + ACG + T2
        COEF2 = ACP + ACG
        COEF3 = H + ACP + ACG + T2
        FVDW = -(A1C2 - AC23 - A13 + A33) * \
               (LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH1) * \
               (4 * ACP * COEFA2 * COEF3 * (1 / (COEFH1**2 + 2 * COEFH1 * COEF)**2.0 \
               + 1 / (COEFH1**2 + 2 * COEFH1 * COEF + 4 * ACP * COEFA2)**2) \
               - 2 * COEF3 * (1 / (COEFH1**2 + 2 * COEFH1 * COEF) \
               - 1 / (COEFH1**2 + 2 * COEFH1 * COEF + 4 * ACP * COEFA2))) \
               + 11.12 * LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH1)**2 * \
               (2 * ACP * COEFA2 / (COEFH1**2 + 2 * COEFH1 * COEF) \
               + 2 * ACP * COEFA2 / (COEFH1**2 + 2 * COEFH1 * COEF \
               + 4 * ACP * COEFA2) \
               + np.log((COEFH1**2 + 2 * COEFH1 * COEF) / \
               (COEFH1**2 + 2 * COEFH1 * COEF + 4 * ACP * COEFA2)))) / 6.0 \
               -(A12 - A23 - A1C2 + AC23) * \
               (LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH2) * \
               (4 * ACP * ACG * COEF3 * (1 / (COEFH2**2 + 2 * COEFH2 * COEF2)**2.0 \
               + 1 / (COEFH2**2 + 2 * COEFH2 * COEF2 + 4 * ACP * ACG)**2) \
               - 2 * COEF3 * (1 / (COEFH2**2 + 2 * COEFH2 * COEF2) \
               - 1 / (COEFH2**2 + 2 * COEFH2 * COEF2 + 4 * ACP * ACG))) \
               + 11.12 * LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH2)**2 * \
               (2 * ACP * ACG / (COEFH2**2 + 2 * COEFH2 * COEF2) \
               + 2 * ACP * ACG / (COEFH2**2 + 2 * COEFH2 * COEF2 \
               + 4 * ACP * ACG) \
               + np.log((COEFH2**2 + 2 * COEFH2 * COEF2) / \
               (COEFH2**2 + 2 * COEFH2 * COEF2 + 4 * ACP * ACG)))) / 6

    elif VDWMODE == 4:
        ACP = AP - T1
        ACG = AG
        COEFH1 = H
        COEFH2 = H + T1
        COEFA1 = ACP + T1
        COEF = ACP + ACG + T1
        COEF2 = ACP + ACG
        COEF3 = H + ACP + ACG + T1
        FVDW = -(AC12 - A23 - AC13 + A33) * \
               (LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH1) * \
               (4 * COEFA1 * ACG * COEF3 * (1 / (COEFH1**2 + 2 * COEFH1 * COEF)**2.0 \
               + 1 / (COEFH1**2 + 2 * COEFH1 * COEF + 4 * COEFA1 * ACG)**2) \
               - 2 * COEF3 * (1 / (COEFH1**2 + 2 * COEFH1 * COEF) \
               - 1 / (COEFH1**2 + 2 * COEFH1 * COEF + 4 * COEFA1 * ACG))) \
               + 11.12 * LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH1)**2 * \
               (2 * COEFA1 * ACG / (COEFH1**2 + 2 * COEFH1 * COEF) \
               + 2 * COEFA1 * ACG / (COEFH1**2 + 2 * COEFH1 * COEF \
               + 4 * COEFA1 * ACG) \
               + np.log((COEFH1**2 + 2 * COEFH1 * COEF) / \
               (COEFH1**2 + 2 * COEFH1 * COEF + 4 * COEFA1 * ACG)))) / 6.0 \
               -(A12 - AC12 - A13 + AC13) * \
               (LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH2) * \
               (4 * ACP * ACG * COEF3 * (1 / (COEFH2**2 + 2 * COEFH2 * COEF2)**2.0 \
               + 1 / (COEFH2**2 + 2 * COEFH2 * COEF2 + 4 * ACP * ACG)**2) \
               - 2 * COEF3 * (1 / (COEFH2**2 + 2 * COEFH2 * COEF2) \
               - 1 / (COEFH2**2 + 2 * COEFH2 * COEF2 + 4 * ACP * ACG))) \
               + 11.12 * LAMBDAVDW / (LAMBDAVDW + 11.12 * COEFH2)**2 * \
               (2 * ACP * ACG / (COEFH2**2 + 2 * COEFH2 * COEF2) \
               + 2 * ACP * ACG / (COEFH2**2 + 2 * COEFH2 * COEF2 \
               + 4 * ACP * ACG) \
               + np.log((COEFH2**2 + 2 * COEFH2 * COEF2) / \
               (COEFH2**2 + 2 * COEFH2 * COEF2 + 4 * ACP * ACG)))) / 6

    # Set FVDW to zero if it is very small
    if abs(FVDW) < 1.0E-30:
        FVDW = 0.0

    return FVDW,FVDW2,Hasp_colloid, Hasp_domain

def AFMFORCEEDL(KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,
                NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,
                zasp_domain, LTLT, AFM_asp_tracking_RMODE3):
    '''SUBROUTINE FORCE EDL (N) (SPHERE-SPHERE GEOMETRY) (DERIVED FROM ENERGY GIVEN BY LIN   WIESNER 2012)'''

    J = 1-(PI/4) # CALCULATE AREA OF SURFACE NOT OCCUPIED BY ASPERITIES USING JAMMING LIMIT FOR CUBIC PACKED SPHERES
    # determine geometry factor for smooth surfaces
    AEFF = AP*AG/(AP+AG)
    if RMODE==0:   # SMOOTH SURFACE ON BOTH (SPHERE-SPHERE GEOMETRY) (DERIVED FROM ENERGY GIVEN BY LIN   WIESNER 2012)
        COEF1 = 64.0*PI*ERE0*AEFF*(KB*T/ZI/ECHG)**2.0*np.tanh(ZI*ECHG*ZETAC/4/KB/T)*np.tanh(ZI*ECHG*ZETAP/4/KB/T)
        FEDL = COEF1*KAPPA*np.exp(-KAPPA*H)

    if RMODE==1:   # ASPERITIES ON COLLOID
        # determine geometry factor for asperities
        AEFFASP = ASPcolloid*AG/(ASPcolloid+AG)
        H2 = H +ASPcolloid #SEPARATION DISTANCE BETWEEN UNDERLYING SMOOTH COLLECTOR AND COLLOID
        #        CALCULATE EDL INTERACTION BETWEEN COLLOID AND COLLECTOR (SPHERE-SPHERE DERIVED FROM ENERGY GIVEN BY LIN   WIESNER 2012)
        COEF1 = 64.0*PI*ERE0*AEFF*(KB*T/ZI/ECHG)**2.0*np.tanh(ZI*ECHG*ZETAC/4/KB/T)*np.tanh(ZI*ECHG*ZETAP/4/KB/T)
        FEDL1 = COEF1*KAPPA*np.exp(-KAPPA*H2)
        #        CALCULATE EDL INTERACITON BETWEEN ASPERTIES AND COLLECTOR (SPHERE-SPHERE)
        COEF2 = 64.0*PI*ERE0*AEFFASP*(KB*T/ZI/ECHG)**2.0*np.tanh(ZI*ECHG*ZETAC/4/KB/T)*np.tanh(ZI*ECHG*ZETAP/4/KB/T)
        # vectorized calculation for array of separation distances
        Hasp_colloid = ycap-AG-ASPcolloid
        # calculate only for asperities inside Hthreshold
        c=Hasp_colloid<=1/LTLT*ASPcolloid
        if sum(c)>=1:
            #extract valid separation distances
            Hasp_colloid=Hasp_colloid[c]

            FEDL2 = COEF2*KAPPA*np.exp(-KAPPA*Hasp_colloid)
        else:
            FEDL2 = np.array([0.0])
        #        CALCULATE TOTAL INTERACTION (MULTIPLY OFFSET SMOOTH SURFACE BY 1-JAMMING LIMIT OF SURFACE COVERED BY ASPERITIES)
        # needed because EDL is a surface, not a volumetric interaction like VDW
        FEDL = J*FEDL1 + sum(FEDL2) 
    
    if RMODE==2:   #ASPERITIES ON COLLECTOR
        # determine geometry factor for asperities
        AEFFASP = ASPdomain*AG/(ASPdomain+AG)
        H2 = HS #SEPARATION DISTANCE BETWEEN UNDERLYING SMOOTH COLLECTOR AND COLLOID
        #        CALCULATE EDL INTERACTION BETWEEN COLLOID AND COLLECTOR (SPHERE-SPHERE DERIVED FROM ENERGY GIVEN BY LIN   WIESNER 2012)
        COEF1 = 64.0*PI*ERE0*AEFF*(KB*T/ZI/ECHG)**2.0*np.tanh(ZI*ECHG*ZETAC/4/KB/T)*np.tanh(ZI*ECHG*ZETAP/4/KB/T)
        FEDL1 = COEF1*KAPPA*np.exp(-KAPPA*H2)
        #        CALCULATE EDL INTERACITON BETWEEN ASPERTIES AND COLLOID (SPHERE-SPHERE)
        COEF2 = 64.0*PI*ERE0*AEFFASP*(KB*T/ZI/ECHG)**2.0*np.tanh(ZI*ECHG*ZETAC/4/KB/T)*np.tanh(ZI*ECHG*ZETAP/4/KB/T)
        # vectorized calculation for array of separation distances
        # array of distances between asperity centers and colloid center
        RXYZ = np.sqrt((X-xasp_domain)*(X-xasp_domain)+(Y-yasp_domain)*(Y-yasp_domain) + (Z-zasp_domain)*(Z-zasp_domain))
        # factor of projection on  Y component (array)
        facY =  (Y-AG)/RXYZ
        # separation distance between asperity and colloid surface
        Hasp_domain = RXYZ-AP-ASPdomain
        # calculate only for asperities inside Hthreshold
        c=Hasp_domain<=1/LTLT*ASPdomain
        if sum(c)>=1:
            #extract valid separation distances
            Hasp_domain=Hasp_domain[c]
            facY = facY[c]
            FEDL2 = COEF2*KAPPA*np.exp(-KAPPA*Hasp_domain)
        else:
            FEDL2 = np.array([0.0])
        #        CALCULATE TOTAL INTERACTION (MULTIPLY OFFSET SMOOTH SURFACE BY 1-JAMMING LIMIT OF SURFACE COVERED BY ASPERITIES)
        FEDL = J*FEDL1 + sum(facY*FEDL2) 

    if RMODE==3:    #ASPERITIES ON BOTH SURFACES
        # determine geometry factor for smooth surfaces
        AEFF = AP*AG/(AP+AG)
        # determine geometry factor for asperities
        AEFFASP = ASPdomain*ASPcolloid/(ASPdomain+ASPcolloid)
        H2 = H+ASPdomain+ASPcolloid #AVERAGE SEPARATION DISTANCE BETWEEN UNDERLYING SMOOTH COLLECTOR AND COLLOID FOR OPPOSED AND COMPLIMENTARY ASPERITY PACKING
        #        CALCULATE EDL INTERACTION BETWEEN COLLOID AND COLLECTOR (SPHERE-SPHERE (DERIVED FROM ENERGY GIVEN BY LIN   WIESNER 2012)
        COEF1 = 64.0*PI*ERE0*AEFF*(KB*T/ZI/ECHG)**2.0*np.tanh(ZI*ECHG*ZETAC/4/KB/T)*np.tanh(ZI*ECHG*ZETAP/4/KB/T)
        FEDL1 = COEF1*KAPPA*np.exp(-KAPPA*H2)
        #        CALCULATE EDL INTERACTION BETWEEN ASPERITIES (SPHERE-SPHERE JUSTifIED BY LINEAR APPROXIMATION)
        COEF2 = 64.0*PI*ERE0*AEFFASP*(KB*T/ZI/ECHG)**2.0*np.tanh(ZI*ECHG*ZETAC/4/KB/T)*np.tanh(ZI*ECHG*ZETAP/4/KB/T) 
        # loop through one colloid asperity interacting with
        # a subdomain of asperities in ZOI
        # pralocate array of asperities contributions to interaction
        FEDL2 = np.full_like(xcap, np.nan)
        # define bounds of zoi subset
        Rsubdomain = 2*ASPdomain
        # determine smaller asperity size
        if ASPdomain<=ASPcolloid:
            ASPsmaller = ASPdomain
        else:
            ASPsmaller = ASPcolloid
        #
        for i in range(len(xcap)):
            # vectorized calculation for array of separation distances
            xcol = xcap[i]
            ycol = ycap[i]
            zcol = zcap[i]
            # call function to track asperities in subset of ZOI on the collector near projected colloid asperity location
            xasp,yasp,zasp = AFM_asp_tracking_RMODE3(xcol,ycol,zcol,AG,Rsubdomain,ASPdomain)
            Harray = np.sqrt((xcol-xasp)*(xcol-xasp)+(ycol-yasp)*(ycol-yasp)+(zcol-zasp)*(zcol-zasp))-ASPcolloid-ASPdomain
            # find minnimum separtion distance
            imin = np.argmin(Harray)
            Hmin = Harray[imin]
            # calculate only for asperities inside Hthreshold

            if Hmin<=1/LTLT*ASPsmaller:
                # array of total interaction of a single colloid asperity with
                # all domain asperities
                FEDLoneasp = COEF2*KAPPA*np.exp(-KAPPA*Hmin)
                # array of distances between colloid asperity center and domain asperities centers
                RXYZ = ((xcol-xasp[imin])*(xcol-xasp[imin])+(ycol-yasp[imin])*(ycol-yasp[imin]) + (zcol-zasp[imin])*(zcol-zasp[imin]))**0.5
                # calculate unit vectors pointing from domains asperity to
                # colloid asperity center. DLVO forces contribution is only in
                # Y (laterals cancel each other)
                unity = (ycol-yasp[imin])/RXYZ
                #disp(unity)
                # Correct array of interactions to component on Y axis
                FEDL2[i] = unity*FEDLoneasp
            else:
                FEDL2[i]=0.0
        #        CALCULATE TOTAL INTERACTION (MULTIPLY OFFSET SMOOTH SURFACE BY 1-JAMMING LIMIT OF SURFACE COVERED BY ASPERITIES)
        FEDL = J*FEDL1 + sum(FEDL2) 
    if abs(FEDL) < 1.0E-30:
        FEDL = 0.0
    return FEDL

def AFMINITIAL(RLIM):
    '''SUBROUTINE TO OBTAIN INITIAL PARTICLE LOCATIONS'''
    RINJ = 2.0*RLIM  # INITIALIZE VALUE TO EXECUTE for WHILE LOOP
    while RINJ>RLIM:
        XINIT = (np.random.rand()*2-1)*RLIM  
        YINIT = (np.random.rand()*2-1)*RLIM 
        RINJ = np.sqrt(XINIT**2.0 + YINIT**2.0)
    return XINIT,YINIT,RINJ

def AFMsphere_capEQ(ap,angasp,angzoi,fzoi,RZOIBULK, ASPcolloid):
    ## zoom in FUNCTIONS
    ##  generate a spherical segment around Equator of colloid sphere centered in origin
    # colloid projection on collector
    # INPUT
    # ap colloid radius
    # angasp: angle that describes 2*asp_colloid projected as arc on colloid surface
    # angzoi: angle that describes 2*RZOIBULK projected as arc on colloid surface

    # RZOIBULK non-deformed zone of interaction

    # accounting only inside zoi
    #OUTPUTS
    # xcapEQEQ,ycapEQEQ,zcapEQEQ: 
    # theta angle with Z+
    # phi angle with X+
    # nang resolution angular grid points for sphere cap array
    # find sphere cap center
    # inrease ZOI projection on colloid by 20# to accomodate nearby asperities
    # angzoi_num =2*angzoi
    # 
    #
    x=0
    y=-ap
    z =0
    r = np.sqrt(x*x+y*y+z*z)
    if r>np.finfo(float).eps:
        unitx = x/r
        unity = y/r
    else:
        unitx = 0.0
        unity = 0.0
    unitz = z/r

    xs = unitx*ap
    ys = unity*ap
    zs = 0.0
    # find cap center point angles relative to sphere
    thetap = np.arccos(zs/ap)
    rxys = np.sqrt(xs*xs+ys*ys)
    if rxys>=np.finfo(float).eps:
        if ys>=0.0:
            phip = np.arccos(xs/rxys)
        else:
            if xs>=0.0:
                phip = np.arcsin(ys/rxys)
            else:
                phip = np.pi-np.arcsin(ys/rxys)      
    else:
        phip = 0.0
    
    ## loop angles to generate cap
    # double the domain initial limits (based on ZOI)
    # the actual asperities will be discriminated below
    angzoi = 2*angzoi
    # calculate limti angle to generate array of asperities.
    numasp = int(np.ceil(angzoi/angasp))
    # because mesh generation needs integer steps, alim is recalculated
    # from nasp to accomodate whole asperities
    if numasp<=3:
        alim = angasp
        numasp = 3
    else:
        alim = (numasp-1)*angasp/2
    
    theta = np.linspace(-alim+thetap,alim+thetap,numasp)
    phi = np.linspace(-alim+phip,alim+phip,numasp)
    # set angle limit as a function of an arc the same lenght as ap
    n=len(theta) # define length of array
    # prealocate x,y,z, array
    xcapEQ=np.full((n,n), np.nan) 
    ycapEQ=xcapEQ.copy() 
    zcapEQ=xcapEQ.copy()
    thetapap = xcapEQ.copy()
    for i in range(n):
        for j in range(n):
            # locate point in z (theta from Z+)
            zcapEQ[i,j]=np.cos(theta[i])*ap
            rxycapEQ = np.sqrt(ap*ap-zcapEQ[i,j]*zcapEQ[i,j])
            # locate point in x y (phi from X+)
            xcapEQ[i,j]=np.cos(phi[j])*rxycapEQ
            ycapEQ[i,j]=np.sin(phi[j])*rxycapEQ
            thetapap[i,j]=theta[i]
        
    
    # discriminate and transforms sphere cap matrix to vector
    xcap = xcapEQ.flatten()
    ycap = ycapEQ.flatten()
    zcap = zcapEQ.flatten()

    # discriminate locations inside fzoi*RZOIBULK
    rxzcap = np.sqrt((xcap)**2+(zcap)**2)
    # obtain logic vector
    c = rxzcap<=fzoi*RZOIBULK+ASPcolloid
    # extract asperities locations inside ZOI
    xcap = xcap[c]
    ycap = ycap[c]
    zcap = zcap[c]

    # #
    return xcap,ycap,zcap

def AFM_asp_tracking(x,y,z,AG,fzoi,RZOIBULK,ASP_domain, concav):
    ''' function to track asperities inside RZOIBULK on the collector'''
    # INPUT:
    # x,y,z colloid location
    # AG collector radius (defines collector plane above origin at collector
    # center)
    # fzoi = factor to discriminate asperities proximal to zoi set to 1 for
    # accounting only inside zoi
    # RZOIBULK non-deformed zone of interaction
    # ASP_domain collector asperities radius
    #
    #OUTPUT:
    # xasp,yasp,zasp array of asperities centers
    #
    # grid step size
    step = 2*ASP_domain
    # find closest node of regular location of asperities to colloid
    # projection
    # determine integer number of steps in grid and fraction of steps
    xn_int = np.fix(x/(step))
    xn_fract = (x/(step))-xn_int
    zn_int = np.fix(z/(step))
    zn_fract = (z/(step))-zn_int
    # update the integer deping of the fraction
    if (xn_fract>0.5) and (xn_fract>=0.0):
        xn_int += 1
    if (xn_fract<-0.5) and (xn_fract<=0.0):
        xn_int -= 1
    if (zn_fract>0.5) and (zn_fract>=0.0):
        zn_int += 1
    if (zn_fract<-0.5) and (zn_fract<=0.0):
        zn_int -= 1
    if concav==0:
        dom=RZOIBULK
    else:
        dom=ASP_domain
    # create array around closest node
    xposr = np.arange(xn_int*step, xn_int*step+2.0*dom, step)
    xnegr = np.flip(np.arange(xn_int*step, xn_int*step-2.0*dom, -step))
    xrange = np.concatenate((xnegr[:-1], xposr))
    #
    zposr = np.arange(zn_int*step, zn_int*step+2.0*dom, step)
    znegr = np.flip(np.arange(zn_int*step, zn_int*step-2.0*dom, -step))
    zrange = np.concatenate((znegr[:-1], zposr))
    # create local mesh using meshgrid
    xasp,zasp = np.meshgrid(xrange,zrange)
    # trasnform matrices to vectors
    xasp=xasp.flatten()
    zasp=zasp.flatten()
    # discriminate locations inside ZOI
    rxzasp = np.sqrt((xasp-x)*(xasp-x)+(zasp-z)*(zasp-z))
    # obtain logic vector
    c = rxzasp<=fzoi*RZOIBULK+ASP_domain
    # extract asperities locations inside ZOI
    xasp = xasp[c]
    zasp = zasp[c]
    # obtain y value (planar)
    yasp = np.ones_like(xasp)*AG

    return xasp,yasp,zasp

def AFMHETTRACKP(X,Y,Z,H,RZOI,AP,HETMODEP,SCOVP,RHETP0,RHETP1):
    '''SUBROUTINE GENERATION AND PROJECTION OF HETERODOMAINS ON COLLOID WRITTEN - CESAR RON'''
    # SUBROUTINE GENERATION AND PROJECTION OF HETERODOMAINS ON COLLOID WRITTEN - CESAR RON 
    #Track probe heterodomains and their projected locations.

    if SCOVP <= 0.0:
        MHETP = np.zeros((1, 4), dtype=float)
        MPRO = np.zeros((1, 4), dtype=float)
        return MHETP, MPRO

    if HETMODEP not in (1, 5):
        raise ValueError(
            f"HETMODEP must be 1 or 5, received {HETMODEP}."
        )
    # ISO CONVENTION USED FOR SPHERICAL COORDINATES [R,THETA,PHI] (RADIAL, POLAR, AZIMUTAHL) 
    PI=3.14159265359

    # DEFINE COLLOID CENTER IN COLLECTOR FRAME OF REFERENCE
    XmP0 = X 
    YmP0 = Y 
    ZmP0 = Z
    # RADIAL LIMIT WITHIN HETERODOMAINS WILL BE PROJECTED
    RPL = RZOI + RHETP0
    # LIMITS IN Z AXIS FOR THE RANGE WITHIN WHICH HETERODOMIANS WILL NOT BE PROJECTED
    ZU = AP + ZmP0
    ZL = ZmP0
    # HETMODEPP TO BE USED IN DOUBLE PRECISION CALCULATIONS
    HMODEREAL = HETMODEP
    # CALCULATE OPENING ANGLE FOR ARC LENGTH OF SINGLE HETDOMAIN
    OMEGA0 = RHETP0/AP
    OMEGA1 = RHETP1/AP 
    #CALCULATE DIFFERENCE BETWEEN AP AND AP'
    DAP = AP*(1-np.cos(OMEGA0))
    # CALCULATE PROJECTED HETDOMAIN MAJOR AXIS
    RPRO0 = AP*np.sin(OMEGA0)
    RPRO1 = AP*np.sin(OMEGA1)
    # EQUIVALENT SURFACE COVERAGE CORRESPONDING TO UNIFORM HETDOMAINS IS USED IN CALCULATION
    if (HETMODEP==1):
        SCOVP0 = SCOVP
    else:
        SCOVP0 = SCOVP*((1.0-np.cos(OMEGA0))/((1.0-np.cos(OMEGA0))+(HMODEREAL-1.0)*(1.0-np.cos(OMEGA1))))
        
    # CALCULATE THEORETICAL NUMBER OF HETDOMAINS
    NHETP0 = np.nan if SCOVP0 ==0 and OMEGA0==0 else round(SCOVP0 * 4.0 / (2.0 * (1.0 - np.cos(OMEGA0))))
    NHETP1 = (HMODEREAL-1.0)*NHETP0
    # INITIALIZE COUNT OF HETERODOMAINS
    HC = -1
    # CALCULATE NUMBER OF RINGS THAT YIELD NHET ASSUMING EVEN SPACING 
    NHETREAL0 = NHETP0
    NRING = np.nan if np.isnan(NHETREAL0) else round(np.sqrt(NHETREAL0/1.3))
    NRINGREAL = NRING
    SCOVP = (NHETREAL0*2.0*(1-np.cos(OMEGA0))+(HMODEREAL-1.0)*NHETREAL0*2.0*(1-np.cos(OMEGA1)))/(4.0)

    #SPHERICAL COORDINATES: RADIUS, THETA (POLAR ANGLE), PHI (AZIMUTHAL ANGLE)
    #AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
    #CALCULATE THETA ANGLE STEP AND CONSTANT ARC LENGTH
    DTHETA =  PI/(NRINGREAL-1.0)
    # INITITIALIZE THETA COLLOID ANGLE
    THETA = 0.0
    # CALCULATE ARCLENGHT CONSTANT 
    ARCL = DTHETA*AP

        # Arrays to hold the results
    XHETP = np.zeros(int(NHETP0*HETMODEP+1)) if NHETP0 > 0 else np.zeros(HETMODEP+1)
    YHETP = np.zeros_like(XHETP)
    ZHETP = np.zeros_like(XHETP)
    RHETP = np.zeros_like(XHETP)
    THETAP = np.zeros_like(XHETP)
    PHIP = np.zeros_like(XHETP)
    XPRO = np.zeros_like(XHETP)
    YPRO = np.zeros_like(XHETP)
    ZPRO = np.zeros_like(XHETP)
    RPRO = np.zeros_like(XHETP)


    # GENERATE HETDOMAINS FROM 0.0 TO PI THETA DOMAIN  
    for I in range(1, NRING + 1) if not np.isnan(NRING) else [np.nan]:
        THETA = (I-1)*DTHETA
        if (I==1 or I==NRING): #AT POLES
            RRING = 0.0 #IN POLE NO RING AND ONLY ONE HETDOMAIN
            NHETRING = 1
            DTHETA1 = 1.0/3.0*DTHETA
            DPHI = 0.0
            if (I==1):   
                THETA = 0.0
            elif (I==NRING):
                THETA = PI
            
            #POPULATE HETERODOMAINS AT POLE
            for J in range(1, HETMODEP + 1):
                HC = HC + 1
                if (J==1): #GENERATE LARGE HETERODOMAIN
                    PHI = 0.0
                    XHET = RRING*np.cos(PHI)+XmP0
                    YHET = RRING*np.sin(PHI)+YmP0
                    ZHET = AP*np.cos(THETA)+ZmP0 
                    RHET = RHETP0
                    BETA = np.arccos((ZmP0-ZHET)/AP) #ELEVATION ANGLE OF THE HETERODOMAIN RESPECT TO PROJECTION PLANE
                    ARG = (ZmP0-ZHET)/AP
                    if (ARG>=1.0):
                        ARG = 1.0
                        BETA = np.arccos(ARG)
                    elif (ARG<=-1.0):
                        ARG = -1.0
                        BETA = np.arccos(ARG)
                    
                    RDHET = np.sqrt((XHET-XmP0)**2+(YHET-YmP0)**2) #RADIAL DISTANCE OF HETERODOMAIN CENTER
                    XHETP[HC] = XHET
                    YHETP[HC] = YHET
                    ZHETP[HC] = ZHET
                    RHETP[HC] = RHET
                    THETAP[HC] = THETA
                    PHIP[HC] = PHI
                    if (ZHET<=ZU and ZHET>=ZL): #NOT TO PROJECT HETDOMAIN IN UPPER HEMISPHERE OF THE COLLOID
                        XPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        YPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        ZPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        RPRO[HC] = 0.0 #EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                    else: #GENERATE PROJECTION OF HETDOMAINS IN LOWER HEMISPHERE OF THE COLLOID
                        if (RDHET>=RPL): #NOT TO PROJECT HETDOMAIN OUTSIDE PROJECTION RADIAL LIMIT
                            XPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                            YPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                            ZPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                            RPRO[HC] = 0.0 #EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT OF PROJECTION
                        else: #GENERATE PROJECTION OF HETDOMAIN INSIDE PROJECTION RADIAL LIMIT AND LOWER HEMISPHERE OF COLLOID
                            DC = DAP*np.sin(BETA) #TOTAL DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-Y PLANE
                            DX = DC*np.cos(PHI) #DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-AXIS
                            DY = DC*np.sin(PHI) #DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN Y-AXIS
                            A = RPRO0 #ELLIPSE MAJOR AXIS
                            B = RPRO0*np.cos(BETA) #!ELLIPSE MINOR AXIS
                            XPRO[HC] = XHET - DX
                            YPRO[HC] = YHET - DY
                            ZPRO[HC] = -(AP + H)
                            RPRO[HC] = np.sqrt(A*B) #EQUIVALENT CIRCLE RADIUS
                        
                    
                else: #GENERATE MEDIUM AND SMALL HETDOMAINS AROUND LARGE HETERODOMAIN 
                    if (HETMODEP==5): #1:4
                        THETA1 = THETA + DTHETA1  
                        PHI = float(J-2)*PI/2.0
                        R1 = AP*np.sin(THETA1)
                        XHET = R1*np.cos(PHI)+XmP0
                        YHET = R1*np.sin(PHI)+YmP0
                        ZHET = AP*np.cos(THETA1)+ZmP0
                        RHET = RHETP1
                        BETA = np.arccos((ZmP0-ZHET)/AP) #ELEVATION ANGLE OF THE HETERODOMAIN RESPECT TO PROJECTION PLANE
                        ARG = (ZmP0-ZHET)/AP
                        if (ARG>=1.0):
                            ARG = 1.0
                            BETA = np.arccos(ARG)
                        elif (ARG<=-1.0):
                            ARG = -1.0
                            BETA = np.arccos(ARG)
                        
                        RDHET = np.sqrt((XHET-XmP0)**2+(YHET-YmP0)**2) #RADIAL DISTANCE OF HETERODOMAIN CENTER
                        XHETP[HC] = XHET
                        YHETP[HC] = YHET
                        ZHETP[HC] = ZHET
                        RHETP[HC] = RHET
                        THETAP[HC] = THETA1
                        PHIP[HC] = PHI
                        if (ZHET<=ZU and ZHET>=ZL): #NOT TO PROJECT HETDOMAIN IN UPPER HEMISPHERE OF THE COLLOID
                            XPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            YPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            ZPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            RPRO[HC] = 0.0 #EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        else: #GENERATE PROJECTION OF HETDOMAINS IN LOWER HEMISPHERE OF THE COLLOID
                            if (RDHET>=RPL): #NOT TO PROJECT HETDOMAIN OUTSIDE PROJECTION RADIAL LIMIT
                                XPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                YPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                ZPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                RPRO[HC] = 0.0 #EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT OF PROJECTION
                            else: #GENERATE PROJECTION OF HETDOMAIN INSIDE PROJECTION RADIAL LIMIT AND LOWER HEMISPHERE OF COLLOID
                                DC = DAP*np.sin(BETA) #TOTAL DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-Y PLANE
                                DX = DC*np.cos(PHI) #DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-AXIS
                                DY = DC*np.sin(PHI) #DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN Y-AXIS
                                A = RPRO1 #ELLIPSE MAJOR AXIS
                                B = RPRO1*np.cos(BETA) #!ELLIPSE MINOR AXIS
                                XPRO[HC] = XHET - DX
                                YPRO[HC] = YHET - DY
                                ZPRO[HC] = -(AP + H)
                                RPRO[HC] = np.sqrt(A*B) #EQUIVALENT CIRCLE RADIUS
                            
                        
                    elif (HETMODEP==9): #1:8
                        THETA1 = THETA + DTHETA1  
                        PHI = float(J-2)*PI/4.0
                        XHET = R1*np.cos(PHI)+XmP0
                        YHET = R1*np.sin(PHI)+YmP0
                        ZHET = AP*np.cos(THETA1)+ZmP0
                        RHET = RHETP1
                        BETA = np.arccos((ZmP0-ZHET)/AP) #ELEVATION ANGLE OF THE HETERODOMAIN RESPECT TO PROJECTION PLANE
                        ARG = (ZmP0-ZHET)/AP
                        if (ARG>=1.0):
                            ARG = 1.0
                            BETA = np.arccos(ARG)
                        elif (ARG<=-1.0):
                            ARG = -1.0
                            BETA = np.arccos(ARG)
                        
                        RDHET = np.sqrt((XHET-XmP0)**2+(YHET-YmP0)**2) #RADIAL DISTANCE OF HETERODOMAIN CENTER
                        XHETP[HC] = XHET
                        YHETP[HC] = YHET
                        ZHETP[HC] = ZHET
                        RHETP[HC] = RHET
                        THETAP[HC] = THETA1
                        PHIP[HC] = PHI
                        if (ZHET<=ZU and ZHET>=ZL): #NOT TO PROJECT HETDOMAIN IN UPPER HEMISPHERE OF THE COLLOID
                            XPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            YPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            ZPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            RPRO[HC] = 0.0 #EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        else: #GENERATE PROJECTION OF HETDOMAINS IN LOWER HEMISPHERE OF THE COLLOID
                            if (RDHET>=RPL): #NOT TO PROJECT HETDOMAIN OUTSIDE PROJECTION RADIAL LIMIT
                                XPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                YPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                ZPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                RPRO[HC] = 0.0 #EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT OF PROJECTION
                            else: #GENERATE PROJECTION OF HETDOMAIN INSIDE PROJECTION RADIAL LIMIT AND LOWER HEMISPHERE OF COLLOID
                                DC = DAP*np.sin(BETA) #TOTAL DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-Y PLANE
                                DX = DC*np.cos(PHI) #DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-AXIS
                                DY = DC*np.sin(PHI) #DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN Y-AXIS
                                A = RPRO1 #ELLIPSE MAJOR AXIS
                                B = RPRO1*np.cos(BETA) #!ELLIPSE MINOR AXIS
                                XPRO[HC] = XHET - DX
                                YPRO[HC] = YHET - DY
                                ZPRO[HC] = -(AP + H)
                                RPRO[HC] = np.sqrt(A*B) #EQUIVALENT CIRCLE RADIUS                                
            
        else: # NOT AT POLES
            RRING = AP*np.sin(THETA) 
            #CALCULATE NUMBER OF HETERODOMAINS IN RING
            NHETRING = round(2.0*PI*RRING/ARCL) if not np.isnan(NHETREAL0) else np.nan
            if (NHETRING<3):  
                NHETRING = 3
            
            NHRINGREAL = NHETRING
            #CALCULATE STEP IN PHI (AZIMUTHAL ANGLE) BASED ON NHETRING
            DPHI = 2.0*PI/NHRINGREAL
            #CALCULATE OFFSET AS 10# OF THE STEP IN PHI IF RING IS ODD OR EVEN
            M = I % 2 if not np.isnan(NRING) else np.nan
            if (M==0):  
                PHIOFF = 0.1*DPHI 
            else:
                PHIOFF = -0.1*DPHI 
            
            #POPULATE HETERODOMAINS ON RINGS
            for K in range(1, NHETRING + 1) if not np.isnan(NHRINGREAL) else [np.nan]:
                #CALCULATE PHI ANGLE
                PHI = (K-1)*DPHI + PHIOFF
                for J in range(1, HETMODEP + 1):
                    HC += 1
                    if (J==1): #GENERATE LARGE HETERODOMAIN
                        XHET = RRING*np.cos(PHI)+XmP0
                        YHET = RRING*np.sin(PHI)+YmP0
                        ZHET = AP*np.cos(THETA)+ZmP0 
                        RHET = RHETP0
                        ARG = (ZmP0-ZHET)/AP
                        BETA = np.arccos(np.clip(ARG,-1.0, 1.0)) #ELEVATION ANGLE OF THE HETERODOMAIN RESPECT TO PROJECTION PLANE
                        
                        RDHET = np.sqrt((XHET-XmP0)**2+(YHET-YmP0)**2) #RADIAL DISTANCE OF HETERODOMAIN CENTER
                        XHETP[HC] = XHET
                        YHETP[HC] = YHET
                        ZHETP[HC] = ZHET
                        RHETP[HC] = RHET
                        THETAP[HC] = THETA
                        PHIP[HC] = PHI
                        if (ZHET<=ZU and ZHET>=ZL): #NOT TO PROJECT HETDOMAIN IN UPPER HEMISPHERE OF THE COLLOID
                            XPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            YPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            ZPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            RPRO[HC] = 0.0 #EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                        else: #GENERATE PROJECTION OF HETDOMAINS IN LOWER HEMISPHERE OF THE COLLOID
                            if (RDHET>=RPL): #NOT TO PROJECT HETDOMAIN OUTSIDE PROJECTION RADIAL LIMIT
                                XPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                YPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                ZPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                RPRO[HC] = 0.0 #EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT OF PROJECTION
                            else: #GENERATE PROJECTION OF HETDOMAIN INSIDE PROJECTION RADIAL LIMIT AND LOWER HEMISPHERE OF COLLOID
                                DC = DAP*np.sin(BETA) #TOTAL DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-Y PLANE
                                DX = DC*np.cos(PHI) #DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-AXIS
                                DY = DC*np.sin(PHI) #DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN Y-AXIS
                                A = RPRO0 #ELLIPSE MAJOR AXIS
                                B = RPRO0*np.cos(BETA) #!ELLIPSE MINOR AXIS
                                XPRO[HC] = XHET - DX
                                YPRO[HC] = YHET - DY
                                ZPRO[HC] = -(AP + H)
                                RPRO[HC] = np.sqrt(A*B) #EQUIVALENT CIRCLE RADIUS                                                       
                    else: #GENERATE MEDIUM AND SMALL HETDOMAINS AROUND LARGE HETERODOMAIN
                        if (HETMODEP==5): #1:4
                            if (J==2):
                                PHI1 = PHI-(1.0/3.0*DPHI)
                                THETA1 = THETA+(1.0/3.0*DTHETA)                           
                            
                            if (J==3):
                                PHI1 = PHI+(1.0/3.0*DPHI)
                                THETA1 = THETA+(1.0/3.0*DTHETA) 
                            
                            if (J==4):
                                PHI1 = PHI+(1.0/3.0*DPHI)
                                THETA1 = THETA-(1.0/3.0*DTHETA) 
                            
                            if (J==5):
                                PHI1 = PHI-(1.0/3.0*DPHI)
                                THETA1 = THETA-(1.0/3.0*DTHETA) 
                            
                            R1 = AP*np.sin(THETA1)
                            XHET = R1*np.cos(PHI1)+XmP0
                            YHET = R1*np.sin(PHI1)+YmP0
                            ZHET = AP*np.cos(THETA1)+ZmP0
                            RHET = RHETP1
                            ARG = (ZmP0-ZHET)/AP
                            BETA = np.arccos(np.clip(ARG, -1.0, 1.0)) #ELEVATION ANGLE OF THE HETERODOMAIN RESPECT TO PROJECTION PLANE
                            
                            RDHET = np.sqrt((XHET-XmP0)**2+(YHET-YmP0)**2)#RADIAL DISTANCE OF HETERODOMAIN CENTER
                            XHETP[HC] = XHET
                            YHETP[HC] = YHET
                            ZHETP[HC] = ZHET
                            RHETP[HC] = RHET
                            THETAP[HC] = THETA1
                            PHIP[HC] = PHI1
                            if (ZHET<=ZU and ZHET>=ZL): #NOT TO PROJECT HETDOMAIN IN UPPER HEMISPHERE OF THE COLLOID
                                XPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                                YPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                                ZPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                                RPRO[HC] = 0.0 #EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            else: #GENERATE PROJECTION OF HETDOMAINS IN LOWER HEMISPHERE OF THE COLLOID
                                if (RDHET>=RPL): #NOT TO PROJECT HETDOMAIN OUTSIDE PROJECTION RADIAL LIMIT
                                    XPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                    YPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                    ZPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                    RPRO[HC] = 0.0 #EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT OF PROJECTION
                                else: #GENERATE PROJECTION OF HETDOMAIN INSIDE PROJECTION RADIAL LIMIT AND LOWER HEMISPHERE OF COLLOID
                                    DC = DAP*np.sin(BETA) #TOTAL DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-Y PLANE
                                    DX = DC*np.cos(PHI1) #DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-AXIS
                                    DY = DC*np.sin(PHI1) #DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN Y-AXIS
                                    A = RPRO1 #ELLIPSE MAJOR AXIS
                                    B = RPRO1*np.cos(BETA) #!ELLIPSE MINOR AXIS
                                    XPRO[HC] = XHET - DX
                                    YPRO[HC] = YHET - DY
                                    ZPRO[HC] = -(AP + H)
                                    RPRO[HC] = np.sqrt(A*B) #EQUIVALENT CIRCLE RADIUS
                                
                            
                        elif (HETMODEP==9): #1:8
                            if (J==2):
                                PHI1 = PHI-(1.0/3.0*DPHI)
                                THETA1 = THETA+(1.0/3.0*DTHETA) 
                            
                            if (J==3):
                                PHI1 = PHI+(1.0/3.0*DPHI)
                                THETA1 = THETA+(1.0/3.0*DTHETA) 
                            
                            if (J==4):
                                PHI1 = PHI+(1.0/3.0*DPHI)
                                THETA1 = THETA-(1.0/3.0*DTHETA) 
                            
                            if (J==5):
                                PHI1 = PHI-(1.0/3.0*DPHI)
                                THETA1 = THETA-(1.0/3.0*DTHETA) 
                            
                            if (J==6):
                                PHI1 = PHI-(1.0/3.0*DPHI)
                                THETA1 = THETA 
                            
                            if (J==7):
                                PHI1 = PHI
                                THETA1 = THETA+(1.0/3.0*DTHETA) 
                            
                            if (J==8):
                                PHI1 = PHI+(1.0/3.0*DPHI)
                                THETA1 = THETA 
                            
                            if (J==9):
                                PHI1 = PHI
                                THETA1 = THETA-(1.0/3.0*DTHETA) 
                            
                            R1 = AP*np.sin(THETA1)
                            XHET = R1*np.cos(PHI1)+XmP0
                            YHET = R1*np.sin(PHI1)+YmP0
                            ZHET = AP*np.cos(THETA1)+ZmP0
                            RHET = RHETP1
                            ARG = (ZmP0-ZHET)/AP
                            BETA = np.arccos(np.clip(ARG, -1.0, 1.0)) #ELEVATION ANGLE OF THE HETERODOMAIN RESPECT TO PROJECTION PLANE
                            
                            RDHET = np.sqrt((XHET-XmP0)**2+(YHET-YmP0)**2) #RADIAL DISTANCE OF HETERODOMAIN CENTER
                            XHETP[HC] = XHET
                            YHETP[HC] = YHET
                            ZHETP[HC] = ZHET
                            RHETP[HC] = RHET
                            THETAP[HC] = THETA1
                            PHIP[HC] = PHI1
                            if (ZHET<=ZU and ZHET>=ZL): #NOT TO PROJECT HETDOMAIN IN UPPER HEMISPHERE OF THE COLLOID
                                XPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                                YPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                                ZPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                                RPRO[HC] = 0.0 #EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED IN UPPER HEMISPHERE OF THE COLLOID
                            else: #GENERATE PROJECTION OF HETDOMAINS IN LOWER HEMISPHERE OF THE COLLOID
                                if (RDHET>=RPL): #NOT TO PROJECT HETDOMAIN OUTSIDE PROJECTION RADIAL LIMIT
                                    XPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                    YPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                    ZPRO[HC] = 0.0 #0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT
                                    RPRO[HC] = 0.0 #EQUIVALENT CIRCLE RADIUS, 0.0 FOR PROJECTION OF HETERODOMAINS LOCATED OUTSIDE RADIAL LIMIT OF PROJECTION
                                else: #GENERATE PROJECTION OF HETDOMAIN INSIDE PROJECTION RADIAL LIMIT AND LOWER HEMISPHERE OF COLLOID
                                    DC = DAP*np.sin(BETA) #TOTAL DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-Y PLANE
                                    DX = DC*np.cos(PHI1) #DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN X-AXIS
                                    DY = DC*np.sin(PHI1) #DISPLACEMENT OF PROJECTION CENTER RESPECT HETDOMAIN CENTER IN Y-AXIS
                                    A = RPRO1 #ELLIPSE MAJOR AXIS
                                    B = RPRO1*np.cos(BETA) #!ELLIPSE MINOR AXIS
                                    XPRO[HC] = XHET - DX
                                    YPRO[HC] = YHET - DY
                                    ZPRO[HC] = -(AP + H)
                                    RPRO[HC] = np.sqrt(A*B) #EQUIVALENT CIRCLE RADIUS

    last_index = HC + 1 # Update last index for the arrays
    XHETP = XHETP[:last_index]
    YHETP = YHETP[:last_index]
    ZHETP = ZHETP[:last_index]
    RHETP = RHETP[:last_index]
    THETAP = THETAP[:last_index]
    PHIP = PHIP[:last_index]
    XPRO = XPRO[:last_index]
    YPRO = YPRO[:last_index]
    ZPRO = ZPRO[:last_index]
    RPRO = RPRO[:last_index]

    # GENERATE MATRIX WITH HETP LOCATIONS AND RADII IN (XmP0,YmP0,ZmP0) FRAME OF REFERENCE
    MHETP = np.zeros((len(XHETP), 4))
    if (SCOVP>0):
        MHETP[:,0] = XHETP
        MHETP[:,1] = YHETP
        MHETP[:,2] = ZHETP
        MHETP[:,3] = RHETP
    else:
        MHETP[:,:] = 0

    
    # GENERATE MATRIX WITH HETP PROJECTION LOCATIONS AND RADII IN (XmP0,YmP0,ZmP0) FRAME OF REFERENCE
    if (SCOVP>0):
        INDEX = np.array(RPRO) != 0
        MPRO = np.column_stack(
            [
            np.array(XPRO)[INDEX],
            np.array(YPRO)[INDEX],
            np.array(ZPRO)[INDEX],
            np.array(RPRO)[INDEX]
            ]
        )
    else:
        MPRO[:,:] = 0
    
    return MHETP, MPRO

def AFMHETP_TRANSFORM(X,Y,Z,XG,YG,ZG,THETA,PHI,MHETP,MPRO, SCOVP):
    ''' FUNCTION TO PERFORM COORDINATE TRANSFORMATION OF HETP TO A GIVEN FRAME OF REFERENCE  - CESAR RON '''
    PI=3.14159265359

    # ROTATE HETP AND PROJECTION LOCATIONS BASED ON COLLOID SPHERICAL COORDINATES 
    # (X-CONVENTION, Z-X-Z SEQUENCE ROTATION IS COUNTER=CLOCKWISE) (GOLDSTEIN, 2001, P.152 AND P.601)
    PHI_R   = 0.5*PI + PHI
    THETA_R = THETA
    PSI_R   = 1.5*PI - PHI
    # ROTATION MATRIX
    MR = ROTATION_HETP(THETA_R,PHI_R,PSI_R)

    # POSITIONS OF HETP ROTATED AND TRANSLATED TO THE COLLECTOR FRAME OF REFERENCE
    if SCOVP>0.0:
        MHETP_RT = MHETP[:,:3]@MR
        MHETP_PLOT = np.zeros((MHETP_RT.shape[0], 4))
        MHETP_PLOT[:,0] = MHETP_RT[:,0] + X
        MHETP_PLOT[:,1] = MHETP_RT[:,1] + Y
        MHETP_PLOT[:,2] = MHETP_RT[:,2] + Z
        MHETP_PLOT[:,3] = MHETP[:,3]
    else:
        MHETP_PLOT = np.zeros((1, 4)) 

    # TRANSFORM HETP PROJECTION POSITIONS TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING 
    # THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER
    # POSITIONS OF HETP PROJECTIONS ROTATED AND TRANSLATED TO THE COLLECTOR FRAME OF REFERENCE 
    MPRO_RT = MPRO[:,:3]@MR
    MPRO_RT[:,0] = MPRO_RT[:,0] + X
    MPRO_RT[:,1] = MPRO_RT[:,1] + Y
    MPRO_RT[:,2] = MPRO_RT[:,2] + Z
    # UNIT VECTORS DEFINING THE COLLECTOR FRAME OF REFERENCE
    EX_C = np.array([1, 0, 0])
    EY_C = np.array([0, 1, 0])
    EZ_C = np.array([0, 0, 1])
    # UNIT VECTOR DEFINING THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT WHERE THE COLLOID CENTER IS PROJECTED
    EX_G = EX_C@MR
    EY_G = EY_C@MR 
    EZ_G = EZ_C@MR 
    # TRANSFORMATION MATRIX BASED ON PREVIOUS UNIT VECTORS
    MT = np.column_stack((EX_G, EY_G, EZ_G))
    # GET POSITION COLUMNS ONLY AND TRASLATE POSITIONS (WHICH IS REQUIRED PREVIOUS TO APPLY THE TRANSFORMATION)
    MPRO_RTT = np.zeros_like(MPRO_RT)  # Initialize MPRO_RTT
    MPRO_RTT[:, 0] = MPRO_RT[:, 0] - XG
    MPRO_RTT[:, 1] = MPRO_RT[:, 1] - YG
    MPRO_RTT[:, 2] = MPRO_RT[:, 2] - ZG
    # APPLY THE TRANSFORMATION
    MPRO_RTT = MPRO_RTT@MT
    # OUTPUT MATRIX WITH RADII
    MPRO_AF = np.zeros((MPRO_RTT.shape[0], 4))  # Initialize MPRO_AF
    MPRO_AF[:, 0] = MPRO_RTT[:, 0]
    MPRO_AF[:, 1] = MPRO_RTT[:, 1]
    MPRO_AF[:, 2] = MPRO_RTT[:, 2]
    MPRO_AF[:, 3] = MPRO[:, 3]

    return MHETP_PLOT,MPRO_AF
        
def ROTATION_HETP(theta,phi,psi):
    ''' FUNCTION TO CALCULATE ROTATION MATRIX FOR HETP BASED ON THETA, PHI AND PSI '''
    #QUATERNIONS FOR ROTATION MATRIX BASED ON THETA, PHI AND PSI
    q0 = np.cos(0.5 * phi + 0.5 * psi) * np.cos(0.5 * theta)
    q1 = np.cos(0.5 * phi - 0.5 * psi) * np.sin(0.5 * theta)
    q2 = np.sin(0.5 * phi - 0.5 * psi) * np.sin(0.5 * theta)
    q3 = np.sin(0.5 * phi + 0.5 * psi) * np.cos(0.5 * theta)
    ROT_MAT = np.array([[1 - 2 * (q2 ** 2 + q3 ** 2), 2 * (q1 * q2 - q0 * q3), 2 * (q1 * q3 - q2 * q0)],
                        [2 * (q1 * q2 - q3 * q0), 1 - 2 * (q1 ** 2 + q3 ** 2), 2 * (q0 * q1 + q2 * q3)],
                        [2 * (q0 * q2 + q1 * q3), 2 * (q2 * q3 - q0 * q1), 1 - 2 * (q1 ** 2 + q2 ** 2)]])
    return ROT_MAT

def AFMHETTRACK(X,Y,Z,Xm0,Ym0,Zm0,AG,HETMODE,SCOV,RHET0,RHET1,RHET2,HETCFLAG):
    ''' FUNCTION TO TRACK COLLECTOR HETERODOMAINS WRITTEN - CESAR RON'''
    # ISO CONVENTION USED FOR SPHERICAL COORDINATES [R,THETA,PHI] (RADIAL, POLAR, AZIMUTAHL)
    PI=3.14159265359

    #EQUIVALENT SURFACE COVERAGE CORRESPONDING TO UNIFORM HETERODOMAINS IS USED IN CALCULATION, EQUALS HALF OF BIMODAL SURFACE COVERAGE
    if (HETMODE==1): #UNIFORM 
        HM1 = 0.0
        HM2 = 0.0
    elif(HETMODE==5): #1:4  
        HM1 = 4.0
        HM2 = 0.0  
    elif(HETMODE==9): #1:8
        HM1 = 8.0
        HM2 = 0.0  
    elif(HETMODE==73): #1:8:64
        HM1 = 8.0
        HM2 = 64.0  
    
    SCOV0 = SCOV*(RHET0**2)/(RHET0**2+HM1*RHET1**2+HM2*RHET2**2)

    #CALCULATE THEORETICAL NUMBER OF HETERODOMAINS REQUIRED
    NHET0 = round(SCOV0*(4.0*AG**2.0)/(RHET0**2.0))
    NHET1 = HM1*NHET0
    NHET2 = HM2*NHET0

    #CALCULATE NUMBER OF RINGS THAT YIELD NHET ASSUMING EVEN SPACING 
    NHETREAL0 = NHET0
    #THE DENOMINATOR 1/1.3 WAS CALIBRATED TO YIELD EVEN SPACING DISTRIBUTION OF HETDOMAINS MATCHING SCOV
    NRING = round((NHETREAL0/1.3)**0.5)
    NRINGREAL = NRING

    #SPHERICAL COORDINATES: RADIUS, THETA (POLAR ANGLE), PHI (AZIMUTHAL ANGLE)
    #AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
    #CALCULATE THETA ANGLE STEP AND CONSTANT ARC LENGTH
    DTHETA =  PI/(NRINGREAL-1)
    ARCL = DTHETA*AG

    #CALCULATE CALCULATE DISTANCE TO COLLOID CENTER
    RO = np.sqrt((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0)+(Z-Zm0)*(Z-Zm0))

    #CALCULATE THETA ANGLE
    THETAP = np.arccos((Z-Zm0)/RO)
    #CALCULATE PROJECTION OF COLLOID POSITION ON XY PLANE
    ROXY = np.sqrt((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0))
    #CALCULATE COLLOID PHI ANGLE
    if (ROXY==0.0):  
        PHIP = 0.0
    else:
        if ((Y-Ym0)>=0.0):  
            PHIP = np.arccos((X-Xm0)/ROXY)
        else:
            PHIP = 2.0*PI-np.arccos((X-Xm0)/ROXY)
        
    last_index = np.nan  # Initialize last index for arrays
    XHET = np.zeros(HETMODE)
    YHET = np.zeros_like(XHET)
    ZHET = np.zeros_like(XHET)
    RHET = np.zeros_like(XHET) 
    THETAT = np.zeros_like(XHET)
    PHIT = np.zeros_like(XHET) 


    if (HETCFLAG==0): # GENERATE HETC FOR AFRACT CALCULATION
        #NTHETAP IS CLOSEST RING TO COLLOID PROJECTION
        NTHETAP = np.round(THETAP / DTHETA).astype(int) + 1
        #AT POLE
        if (NTHETAP==1 or NTHETAP==NRING): 
            DTHETA1 = 1.0/3.0*DTHETA
            DPHI = 0.0
            RRING = 0.0
            THETA = 0.0 if NTHETAP == 1 else PI
        
            #POPULATE HETERODOMAINS AT POLE
            for J in range(1, HETMODE + 1):
                if (J==1): #GENERATE LARGE HETERODOMAIN
                    PHI = 0.0
                    R1 = RRING
                    XHET[J-1] = R1*np.cos(PHI)+Xm0
                    YHET[J-1] = R1*np.sin(PHI)+Ym0
                    ZHET[J-1] = AG*np.cos(THETA)+Zm0 
                    RHET[J-1] = RHET0
                    THETAT[J-1] = THETA
                    PHIT[J-1] = PHI
                else: #GENERATE MEDIUM AND SMALL HETDOMAINS AROUND LARGE HETERODOMAIN 
                    if (HETMODE==5): #1:4
                        THETA1 = THETA + DTHETA1  
                        PHI = float(J-2)*PI/2.0
                        R1 = AG*np.sin(THETA1)
                        XHET[J-1] = R1*np.cos(PHI)+Xm0
                        YHET[J-1] = R1*np.sin(PHI)+Ym0
                        ZHET[J-1] = AG*np.cos(THETA1)+Zm0
                        RHET[J-1] = RHET1
                        THETAT[J-1] = THETA1
                        PHIT[J-1] = PHI
                    elif (HETMODE==9): #1:8
                        THETA1 = THETA + DTHETA1  
                        PHI = float(J-2)*PI/4.0
                        R1 = AG*np.sin(THETA1)
                        XHET[J-1] = R1*np.cos(PHI)+Xm0
                        YHET[J-1] = R1*np.sin(PHI)+Ym0
                        ZHET[J-1] = AG*np.cos(THETA1)+Zm0
                        RHET[J-1] = RHET1
                        THETAT[J-1] = THETA1
                        PHIT[J-1] = PHI
                    elif (HETMODE==73): #1:8:64
                        if (J>=2 and J<=9):
                            THETA1 = THETA + DTHETA1  
                            PHI = float(J-2)*PI/4.0
                            R1 = AG*np.sin(THETA1)
                            XHET[J-1] = R1*np.cos(PHI)+Xm0
                            YHET[J-1] = R1*np.sin(PHI)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA1)+Zm0
                            RHET[J-1] = RHET1
                            THETAT[J-1] = THETA1
                            PHIT[J-1] = PHI
                        elif (J>=10 and J<=17):
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA1 = round(1.155*np.sin(2.094*(J-9)+3.142))
                            THETA2 = THETA1 + F_THETA1*DTHETA2  
                            PHI = (2-2)*PI/4.0
                            DPHI1 = 1.0/3.0*(PI/4.0)
                            F_PHI = round(1.115*np.sin(0.5236*(J-9)+3.927)+0.2989*np.sin(3.665*(J-9)-7.069))
                            PHI1 = PHI + F_PHI*DPHI1
                            R1 = AG*np.sin(THETA2)
                            XHET[J-1] = R1*np.cos(PHI1)+Xm0
                            YHET[J-1] = R1*np.sin(PHI1)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET[J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI1
                        elif (J>=18 and J<=25):
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA1 = round(1.155*np.sin(2.094*(J-17)+3.142))
                            THETA2 = THETA1 + F_THETA1*DTHETA2  
                            PHI = (3-2)*PI/4.0
                            DPHI1 = 1.0/3.0*(PI/4.0)
                            F_PHI = round(1.115*np.sin(0.5236*(J-17)+3.927)+0.2989*np.sin(3.665*(J-17)-7.069))
                            PHI1 = PHI + F_PHI*DPHI1
                            R1 = AG*np.sin(THETA2)
                            XHET[J-1] = R1*np.cos(PHI1)+Xm0
                            YHET[J-1] = R1*np.sin(PHI1)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET[J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI1
                        elif (J>=26 and J<=33):
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA1 = round(1.155*np.sin(2.094*(J-25)+3.142))
                            THETA2 = THETA1 + F_THETA1*DTHETA2  
                            PHI = (4-2)*PI/4.0
                            DPHI1 = 1.0/3.0*(PI/4.0)
                            F_PHI = round(1.115*np.sin(0.5236*(J-25)+3.927)+0.2989*np.sin(3.665*(J-25)-7.069))
                            PHI1 = PHI + F_PHI*DPHI1
                            R1 = AG*np.sin(THETA2)
                            XHET[J-1] = R1*np.cos(PHI1)+Xm0
                            YHET[J-1] = R1*np.sin(PHI1)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET[J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI1
                        elif (J>=34 and J<=41):
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA1 = round(1.155*np.sin(2.094*(J-33)+3.142))
                            THETA2 = THETA1 + F_THETA1*DTHETA2  
                            PHI = (5-2)*PI/4.0
                            DPHI1 = 1.0/3.0*(PI/4.0)
                            F_PHI = round(1.115*np.sin(0.5236*(J-33)+3.927)+0.2989*np.sin(3.665*(J-33)-7.069))
                            PHI1 = PHI + F_PHI*DPHI1
                            R1 = AG*np.sin(THETA2)
                            XHET[J-1] = R1*np.cos(PHI1)+Xm0
                            YHET[J-1] = R1*np.sin(PHI1)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET[J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI1
                        elif (J>=42 and J<=49):
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA1 = round(1.155*np.sin(2.094*(J-41)+3.142))
                            THETA2 = THETA1 + F_THETA1*DTHETA2  
                            PHI = (6-2)*PI/4.0
                            DPHI1 = 1.0/3.0*(PI/4.0)
                            F_PHI = round(1.115*np.sin(0.5236*(J-41)+3.927)+0.2989*np.sin(3.665*(J-41)-7.069))
                            PHI1 = PHI + F_PHI*DPHI1
                            R1 = AG*np.sin(THETA2)
                            XHET[J-1] = R1*np.cos(PHI1)+Xm0
                            YHET[J-1] = R1*np.sin(PHI1)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET[J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI1
                        elif (J>=50 and J<=57):
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA1 = round(1.155*np.sin(2.094*(J-49)+3.142))
                            THETA2 = THETA1 + F_THETA1*DTHETA2  
                            PHI = (7-2)*PI/4.0
                            DPHI1 = 1.0/3.0*(PI/4.0)
                            F_PHI = round(1.115*np.sin(0.5236*(J-49)+3.927)+0.2989*np.sin(3.665*(J-49)-7.069))
                            PHI1 = PHI + F_PHI*DPHI1
                            R1 = AG*np.sin(THETA2)
                            XHET[J-1] = R1*np.cos(PHI1)+Xm0
                            YHET[J-1] = R1*np.sin(PHI1)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET[J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI1
                        elif (J>=58 and J<=65):
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA1 = round(1.155*np.sin(2.094*(J-57)+3.142))
                            THETA2 = THETA1 + F_THETA1*DTHETA2  
                            PHI = (8-2)*PI/4.0
                            DPHI1 = 1.0/3.0*(PI/4.0)
                            F_PHI = round(1.115*np.sin(0.5236*(J-57)+3.927)+0.2989*np.sin(3.665*(J-57)-7.069))
                            PHI1 = PHI + F_PHI*DPHI1
                            R1 = AG*np.sin(THETA2)
                            XHET[J-1] = R1*np.cos(PHI1)+Xm0
                            YHET[J-1] = R1*np.sin(PHI1)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET[J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI1
                        elif (J>=66 and J<=73):
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA1 = round(1.155*np.sin(2.094*(J-65)+3.142))
                            THETA2 = THETA1 + F_THETA1*DTHETA2  
                            PHI = (9-2)*PI/4.0
                            DPHI1 = 1.0/3.0*(PI/4.0)
                            F_PHI = round(1.115*np.sin(0.5236*(J-65)+3.927)+0.2989*np.sin(3.665*(J-65)-7.069))
                            PHI1 = PHI + F_PHI*DPHI1
                            R1 = AG*np.sin(THETA2)
                            XHET[J-1] = R1*np.cos(PHI1)+Xm0
                            YHET[J-1] = R1*np.sin(PHI1)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET[J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI1                     
            
        else: # NOT AT POLES
            #THETA ANGLE
            THETA = (NTHETAP-1)*DTHETA 
            #CALCULATE RING RADIUS
            RRING = AG*np.sin(THETA)
            #CALCULATE NUMBER OF HETERODOMAINS IN RING
            NHETRING = round(2.0*PI*RRING/ARCL)
            NHETRING = max(NHETRING, 3)
            NHRINGREAL = NHETRING
            #RECALCULATE STEP IN PHI BASED ON NHETRING
            DPHI = 2.0*PI/NHRINGREAL
            #CALCULATE OFFSET AS 10# OF THE STEP IN PHI IF RING IS ODD OR EVEN
            M = NTHETAP % 2
            PHIOFF = 0.1 * DPHI if M == 0 else -0.1 * DPHI
            
            #CALCULATE PHI ANGLE BASED ON COLLOID PHI ANGLE
            PHI = DPHI*round((PHIP-PHIOFF)/DPHI)+PHIOFF 

            for J in range(1, HETMODE + 1):
                if (J==1): #GENERATE LARGE HETERODOMAIN
                    XHET[J-1] = RRING*np.cos(PHI)+Xm0
                    YHET[J-1] = RRING*np.sin(PHI)+Ym0
                    ZHET[J-1] = AG*np.cos(THETA)+Zm0 
                    RHET[J-1] = RHET0
                    THETAT[J-1] = THETA
                    PHIT[J-1] = PHI
                else: #GENERATE MEDIUM AND SMALL HETDOMAINS AROUND LARGE HETERODOMAIN
                    if (HETMODE==5): #1:4
                        DTHETA1 = 1.0/3.0*DTHETA
                        DPHI1 = 1.0/3.0*DPHI
                        if (J==2):   
                            PHI1 = PHI - DPHI1
                            THETA1 = THETA + DTHETA1
                        
                        if (J==3):   
                            PHI1 = PHI + DPHI1
                            THETA1 = THETA + DTHETA1 
                        
                        if (J==4):   
                            PHI1 = PHI + DPHI1
                            THETA1 = THETA - DTHETA1 
                        
                        if (J==5):   
                            PHI1 = PHI - DPHI1
                            THETA1 = THETA - DTHETA1
                                                           
                        R1 = AG*np.sin(THETA1)   
                        XHET[J-1] = R1*np.cos(PHI1)+Xm0
                        YHET[J-1] = R1*np.sin(PHI1)+Ym0
                        ZHET[J-1] = AG*np.cos(THETA1)+Zm0
                        RHET [J-1] = RHET1
                        THETAT[J-1] = THETA1
                        PHIT[J-1] = PHI1
                    elif (HETMODE==9): #1:8
                        DTHETA1 = 1.0/3.0*DTHETA
                        F_THETA1 = round(1.155*np.sin(2.094*(J-1)+3.142))
                        THETA1 = THETA + F_THETA1*DTHETA1
                        DPHI1 = 1.0/3.0*DPHI
                        F_PHI1 = round(1.115*np.sin(0.5236*(J-1)+3.927)+0.2989*np.sin(3.665*(J-1)-7.069))
                        PHI1 = PHI + F_PHI1*DPHI1
                        R1 = AG*np.sin(THETA1)   
                        XHET[J-1] = R1*np.cos(PHI1)+Xm0
                        YHET[J-1] = R1*np.sin(PHI1)+Ym0
                        ZHET[J-1] = AG*np.cos(THETA1)+Zm0
                        RHET [J-1] = RHET1
                        THETAT[J-1] = THETA1
                        PHIT[J-1] = PHI1
                    elif (HETMODE==73): #1:8:64
                        if (J>=2 and J<=9):
                            DTHETA1 = 1.0/3.0*DTHETA
                            F_THETA1 = round(1.155*np.sin(2.094*(J-1)+3.142))
                            THETA1 = THETA + F_THETA1*DTHETA1
                            DPHI1 = 1.0/3.0*DPHI
                            F_PHI1 = round(1.115*np.sin(0.5236*(J-1)+3.927)+0.2989*np.sin(3.665*(J-1)-7.069))
                            PHI1 = PHI + F_PHI1*DPHI1
                            R1 = AG*np.sin(THETA1)   
                            XHET[J-1] = R1*np.cos(PHI1)+Xm0
                            YHET[J-1] = R1*np.sin(PHI1)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA1)+Zm0
                            RHET [J-1] = RHET1
                            THETAT[J-1] = THETA1
                            PHIT[J-1] = PHI1    
                        elif (J>=10 and J<=17):
                            DTHETA1 = 1.0/3.0*DTHETA
                            F_THETA1 = round(1.155*np.sin(2.094*(1)+3.142))
                            THETA1 = THETA + F_THETA1*DTHETA1
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA2 = round(1.155*np.sin(2.094*(J-9)+3.142))
                            THETA2 = THETA1 + F_THETA2*DTHETA2
                            DPHI1 = 1.0/3.0*DPHI
                            F_PHI1 = round(1.115*np.sin(0.5236*(1)+3.927)+0.2989*np.sin(3.665*(1)-7.069))
                            PHI1 = PHI + F_PHI1*DPHI1
                            DPHI2 = 1.0/3.0*DPHI1
                            F_PHI2 = round(1.115*np.sin(0.5236*(J-9)+3.927)+0.2989*np.sin(3.665*(J-9)-7.069))
                            PHI2 = PHI1 + F_PHI2*DPHI2
                            R1 = AG*np.sin(THETA2)   
                            XHET[J-1] = R1*np.cos(PHI2)+Xm0
                            YHET[J-1] = R1*np.sin(PHI2)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET [J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI2 
                        elif (J>=18 and J<=25):
                            DTHETA1 = 1.0/3.0*DTHETA
                            F_THETA1 = round(1.155*np.sin(2.094*(2)+3.142))
                            THETA1 = THETA + F_THETA1*DTHETA1
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA2 = round(1.155*np.sin(2.094*(J-17)+3.142))
                            THETA2 = THETA1 + F_THETA2*DTHETA2
                            DPHI1 = 1.0/3.0*DPHI
                            F_PHI1 = round(1.115*np.sin(0.5236*(2)+3.927)+0.2989*np.sin(3.665*(2)-7.069))
                            PHI1 = PHI + F_PHI1*DPHI1
                            DPHI2 = 1.0/3.0*DPHI1
                            F_PHI2 = round(1.115*np.sin(0.5236*(J-17)+3.927)+0.2989*np.sin(3.665*(J-17)-7.069))
                            PHI2 = PHI1 + F_PHI2*DPHI2
                            R1 = AG*np.sin(THETA2)   
                            XHET[J-1] = R1*np.cos(PHI2)+Xm0
                            YHET[J-1] = R1*np.sin(PHI2)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET [J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI2
                        elif (J>=26 and J<=33):
                            DTHETA1 = 1.0/3.0*DTHETA
                            F_THETA1 = round(1.155*np.sin(2.094*(3)+3.142))
                            THETA1 = THETA + F_THETA1*DTHETA1
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA2 = round(1.155*np.sin(2.094*(J-25)+3.142))
                            THETA2 = THETA1 + F_THETA2*DTHETA2
                            DPHI1 = 1.0/3.0*DPHI
                            F_PHI1 = round(1.115*np.sin(0.5236*(3)+3.927)+0.2989*np.sin(3.665*(3)-7.069))
                            PHI1 = PHI + F_PHI1*DPHI1
                            DPHI2 = 1.0/3.0*DPHI1
                            F_PHI2 = round(1.115*np.sin(0.5236*(J-25)+3.927)+0.2989*np.sin(3.665*(J-25)-7.069))
                            PHI2 = PHI1 + F_PHI2*DPHI2
                            R1 = AG*np.sin(THETA2)   
                            XHET[J-1] = R1*np.cos(PHI2)+Xm0
                            YHET[J-1] = R1*np.sin(PHI2)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET [J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI2
                        elif (J>=34 and J<=41):
                            DTHETA1 = 1.0/3.0*DTHETA
                            F_THETA1 = round(1.155*np.sin(2.094*(4)+3.142))
                            THETA1 = THETA + F_THETA1*DTHETA1
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA2 = round(1.155*np.sin(2.094*(J-33)+3.142))
                            THETA2 = THETA1 + F_THETA2*DTHETA2
                            DPHI1 = 1.0/3.0*DPHI
                            F_PHI1 = round(1.115*np.sin(0.5236*(4)+3.927)+0.2989*np.sin(3.665*(4)-7.069))
                            PHI1 = PHI + F_PHI1*DPHI1
                            DPHI2 = 1.0/3.0*DPHI1
                            F_PHI2 = round(1.115*np.sin(0.5236*(J-33)+3.927)+0.2989*np.sin(3.665*(J-33)-7.069))
                            PHI2 = PHI1 + F_PHI2*DPHI2
                            R1 = AG*np.sin(THETA2)   
                            XHET[J-1] = R1*np.cos(PHI2)+Xm0
                            YHET[J-1] = R1*np.sin(PHI2)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET [J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI2
                        elif (J>=42 and J<=49):
                            DTHETA1 = 1.0/3.0*DTHETA
                            F_THETA1 = round(1.155*np.sin(2.094*(5)+3.142))
                            THETA1 = THETA + F_THETA1*DTHETA1
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA2 = round(1.155*np.sin(2.094*(J-41)+3.142))
                            THETA2 = THETA1 + F_THETA2*DTHETA2
                            DPHI1 = 1.0/3.0*DPHI
                            F_PHI1 = round(1.115*np.sin(0.5236*(5)+3.927)+0.2989*np.sin(3.665*(5)-7.069))
                            PHI1 = PHI + F_PHI1*DPHI1
                            DPHI2 = 1.0/3.0*DPHI1
                            F_PHI2 = round(1.115*np.sin(0.5236*(J-41)+3.927)+0.2989*np.sin(3.665*(J-41)-7.069))
                            PHI2 = PHI1 + F_PHI2*DPHI2
                            R1 = AG*np.sin(THETA2)   
                            XHET[J-1] = R1*np.cos(PHI2)+Xm0
                            YHET[J-1] = R1*np.sin(PHI2)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET [J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI2
                        elif (J>=50 and J<=57):
                            DTHETA1 = 1.0/3.0*DTHETA
                            F_THETA1 = round(1.155*np.sin(2.094*(6)+3.142))
                            THETA1 = THETA + F_THETA1*DTHETA1
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA2 = round(1.155*np.sin(2.094*(J-49)+3.142))
                            THETA2 = THETA1 + F_THETA2*DTHETA2
                            DPHI1 = 1.0/3.0*DPHI
                            F_PHI1 = round(1.115*np.sin(0.5236*(6)+3.927)+0.2989*np.sin(3.665*(6)-7.069))
                            PHI1 = PHI + F_PHI1*DPHI1
                            DPHI2 = 1.0/3.0*DPHI1
                            F_PHI2 = round(1.115*np.sin(0.5236*(J-49)+3.927)+0.2989*np.sin(3.665*(J-49)-7.069))
                            PHI2 = PHI1 + F_PHI2*DPHI2
                            R1 = AG*np.sin(THETA2)   
                            XHET[J-1] = R1*np.cos(PHI2)+Xm0
                            YHET[J-1] = R1*np.sin(PHI2)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET [J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI2
                        elif (J>=58 and J<=65):
                            DTHETA1 = 1.0/3.0*DTHETA
                            F_THETA1 = round(1.155*np.sin(2.094*(7)+3.142))
                            THETA1 = THETA + F_THETA1*DTHETA1
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA2 = round(1.155*np.sin(2.094*(J-57)+3.142))
                            THETA2 = THETA1 + F_THETA2*DTHETA2
                            DPHI1 = 1.0/3.0*DPHI
                            F_PHI1 = round(1.115*np.sin(0.5236*(7)+3.927)+0.2989*np.sin(3.665*(7)-7.069))
                            PHI1 = PHI + F_PHI1*DPHI1
                            DPHI2 = 1.0/3.0*DPHI1
                            F_PHI2 = round(1.115*np.sin(0.5236*(J-57)+3.927)+0.2989*np.sin(3.665*(J-57)-7.069))
                            PHI2 = PHI1 + F_PHI2*DPHI2
                            R1 = AG*np.sin(THETA2)   
                            XHET[J-1] = R1*np.cos(PHI2)+Xm0
                            YHET[J-1] = R1*np.sin(PHI2)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET [J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI2
                        elif (J>=66 and J<=73):
                            DTHETA1 = 1.0/3.0*DTHETA
                            F_THETA1 = round(1.155*np.sin(2.094*(8)+3.142))
                            THETA1 = THETA + F_THETA1*DTHETA1
                            DTHETA2 = 1.0/3.0*DTHETA1
                            F_THETA2 = round(1.155*np.sin(2.094*(J-65)+3.142))
                            THETA2 = THETA1 + F_THETA2*DTHETA2
                            DPHI1 = 1.0/3.0*DPHI
                            F_PHI1 = round(1.115*np.sin(0.5236*(8)+3.927)+0.2989*np.sin(3.665*(8)-7.069))
                            PHI1 = PHI + F_PHI1*DPHI1
                            DPHI2 = 1.0/3.0*DPHI1
                            F_PHI2 = round(1.115*np.sin(0.5236*(J-65)+3.927)+0.2989*np.sin(3.665*(J-65)-7.069))
                            PHI2 = PHI1 + F_PHI2*DPHI2
                            R1 = AG*np.sin(THETA2)   
                            XHET[J-1] = R1*np.cos(PHI2)+Xm0
                            YHET[J-1] = R1*np.sin(PHI2)+Ym0
                            ZHET[J-1] = AG*np.cos(THETA2)+Zm0
                            RHET [J-1] = RHET2
                            THETAT[J-1] = THETA2
                            PHIT[J-1] = PHI2       
                last_index = J  
    elif (HETCFLAG==1): # GENERATE HETC FOR GUI FRONT REPRESENTATION 
        #NTHETAP IS CLOSEST RING TO COLLOID PROJECTION
        NTHETAP = round(THETAP/DTHETA)+1
        #M_THETA CONTAINS VALUES OF NTHETA THAT WILL YIELD THETA ANGLE DOMAIN
        if (NTHETAP==1):
            M_NTHETA = np.array([NTHETAP, NTHETAP+1])
        elif (NTHETAP==NRING):
            M_NTHETA = np.array([NTHETAP, NTHETAP-1])
        else:
            M_NTHETA = np.array([NTHETAP, (NTHETAP-1), (NTHETAP+1)])
        
        H = 0 # HETC COUNTER
        #LOOP THROUGH THETA DOMAIN
        for K in range(len(M_NTHETA)):
            NTHETA = M_NTHETA[K]
            #AT POLE
            if (NTHETA==1 or NTHETA==NRING): 
                DTHETA1 = 1.0/3.0*DTHETA
                DPHI = 0.0
                RRING = 0.0
                THETA = 0.0 if NTHETA == 1 else PI
                
                #POPULATE HETERODOMAINS AT POLE
                for J in range(1, HETMODE + 1): 
                    
                    if (J==1): #GENERATE LARGE HETERODOMAIN
                        PHI = 0.0
                        R1 = RRING
                        XHET[H] = R1*np.cos(PHI)+Xm0
                        YHET[H] = R1*np.sin(PHI)+Ym0
                        ZHET[H] = AG*np.cos(THETA)+Zm0 
                        RHET[H] = RHET0
                        THETAT[H] = THETA
                        PHIT[H] = PHI
                    else: #GENERATE MEDIUM AND SMALL HETDOMAINS AROUND LARGE HETERODOMAIN 
                        if (HETMODE==5): #1:4
                            THETA1 = THETA + DTHETA1  
                            PHI = (J-2)*PI/2.0
                            R1 = AG*np.sin(THETA1)
                            XHET[H] = R1*np.cos(PHI)+Xm0
                            YHET[H] = R1*np.sin(PHI)+Ym0
                            ZHET[H] = AG*np.cos(THETA1)+Zm0
                            RHET[H] = RHET1
                            THETAT[H] = THETA1
                            PHIT[H] = PHI
                        elif (HETMODE==9): #1:8
                            THETA1 = THETA + DTHETA1  
                            PHI = (J-2)*PI/4.0
                            R1 = AG*np.sin(THETA1)
                            XHET[H] = R1*np.cos(PHI)+Xm0
                            YHET[H] = R1*np.sin(PHI)+Ym0
                            ZHET[H] = AG*np.cos(THETA1)+Zm0
                            RHET[H] = RHET1
                            THETAT[H] = THETA1
                            PHIT[H] = PHI
                        elif (HETMODE==73): #1:8:64
                            if (J>=2 and J<=9):
                                THETA1 = THETA + DTHETA1  
                                PHI = (J-2)*PI/4.0
                                R1 = AG*np.sin(THETA1)
                                XHET[H] = R1*np.cos(PHI)+Xm0
                                YHET[H] = R1*np.sin(PHI)+Ym0
                                ZHET[H] = AG*np.cos(THETA1)+Zm0
                                RHET[H] = RHET1
                                THETAT[H] = THETA1
                                PHIT[H] = PHI
                            elif (J>=10 and J<=17):
                                DTHETA2 = 1.0/3.0*DTHETA1
                                F_THETA1 = round(1.155*np.sin(2.094*(J-9)+3.142))
                                THETA2 = THETA1 + F_THETA1*DTHETA2  
                                PHI = (2-2)*PI/4.0
                                DPHI1 = 1.0/3.0*(PI/4.0)
                                F_PHI = round(1.115*np.sin(0.5236*(J-9)+3.927)+0.2989*np.sin(3.665*(J-9)-7.069))
                                PHI1 = PHI + F_PHI*DPHI1
                                R1 = AG*np.sin(THETA2)
                                XHET[H] = R1*np.cos(PHI1)+Xm0
                                YHET[H] = R1*np.sin(PHI1)+Ym0
                                ZHET[H] = AG*np.cos(THETA2)+Zm0
                                RHET[H] = RHET2
                                THETAT[H] = THETA2
                                PHIT[H] = PHI1
                            elif (J>=18 and J<=25):
                                DTHETA2 = 1.0/3.0*DTHETA1
                                F_THETA1 = round(1.155*np.sin(2.094*(J-17)+3.142))
                                THETA2 = THETA1 + F_THETA1*DTHETA2  
                                PHI = (3-2)*PI/4.0
                                DPHI1 = 1.0/3.0*(PI/4.0)
                                F_PHI = round(1.115*np.sin(0.5236*(J-17)+3.927)+0.2989*np.sin(3.665*(J-17)-7.069))
                                PHI1 = PHI + F_PHI*DPHI1
                                R1 = AG*np.sin(THETA2)
                                XHET[H] = R1*np.cos(PHI1)+Xm0
                                YHET[H] = R1*np.sin(PHI1)+Ym0
                                ZHET[H] = AG*np.cos(THETA2)+Zm0
                                RHET[H] = RHET2
                                THETAT[H] = THETA2
                                PHIT[H] = PHI1
                            elif (J>=26 and J<=33):
                                DTHETA2 = 1.0/3.0*DTHETA1
                                F_THETA1 = round(1.155*np.sin(2.094*(J-25)+3.142))
                                THETA2 = THETA1 + F_THETA1*DTHETA2  
                                PHI = (4-2)*PI/4.0
                                DPHI1 = 1.0/3.0*(PI/4.0)
                                F_PHI = round(1.115*np.sin(0.5236*(J-25)+3.927)+0.2989*np.sin(3.665*(J-25)-7.069))
                                PHI1 = PHI + F_PHI*DPHI1
                                R1 = AG*np.sin(THETA2)
                                XHET[H] = R1*np.cos(PHI1)+Xm0
                                YHET[H] = R1*np.sin(PHI1)+Ym0
                                ZHET[H] = AG*np.cos(THETA2)+Zm0
                                RHET[H] = RHET2
                                THETAT[H] = THETA2
                                PHIT[H] = PHI1
                            elif (J>=34 and J<=41):
                                DTHETA2 = 1.0/3.0*DTHETA1
                                F_THETA1 = round(1.155*np.sin(2.094*(J-33)+3.142))
                                THETA2 = THETA1 + F_THETA1*DTHETA2  
                                PHI = (5-2)*PI/4.0
                                DPHI1 = 1.0/3.0*(PI/4.0)
                                F_PHI = round(1.115*np.sin(0.5236*(J-33)+3.927)+0.2989*np.sin(3.665*(J-33)-7.069))
                                PHI1 = PHI + F_PHI*DPHI1
                                R1 = AG*np.sin(THETA2)
                                XHET[H] = R1*np.cos(PHI1)+Xm0
                                YHET[H] = R1*np.sin(PHI1)+Ym0
                                ZHET[H] = AG*np.cos(THETA2)+Zm0
                                RHET[H] = RHET2
                                THETAT[H] = THETA2
                                PHIT[H] = PHI1
                            elif (J>=42 and J<=49):
                                DTHETA2 = 1.0/3.0*DTHETA1
                                F_THETA1 = round(1.155*np.sin(2.094*(J-41)+3.142))
                                THETA2 = THETA1 + F_THETA1*DTHETA2  
                                PHI = (6-2)*PI/4.0
                                DPHI1 = 1.0/3.0*(PI/4.0)
                                F_PHI = round(1.115*np.sin(0.5236*(J-41)+3.927)+0.2989*np.sin(3.665*(J-41)-7.069))
                                PHI1 = PHI + F_PHI*DPHI1
                                R1 = AG*np.sin(THETA2)
                                XHET[H] = R1*np.cos(PHI1)+Xm0
                                YHET[H] = R1*np.sin(PHI1)+Ym0
                                ZHET[H] = AG*np.cos(THETA2)+Zm0
                                RHET[H] = RHET2
                                THETAT[H] = THETA2
                                PHIT[H] = PHI1
                            elif (J>=50 and J<=57):
                                DTHETA2 = 1.0/3.0*DTHETA1
                                F_THETA1 = round(1.155*np.sin(2.094*(J-49)+3.142))
                                THETA2 = THETA1 + F_THETA1*DTHETA2  
                                PHI = (7-2)*PI/4.0
                                DPHI1 = 1.0/3.0*(PI/4.0)
                                F_PHI = round(1.115*np.sin(0.5236*(J-49)+3.927)+0.2989*np.sin(3.665*(J-49)-7.069))
                                PHI1 = PHI + F_PHI*DPHI1
                                R1 = AG*np.sin(THETA2)
                                XHET[H] = R1*np.cos(PHI1)+Xm0
                                YHET[H] = R1*np.sin(PHI1)+Ym0
                                ZHET[H] = AG*np.cos(THETA2)+Zm0
                                RHET[H] = RHET2
                                THETAT[H] = THETA2
                                PHIT[H] = PHI1
                            elif (J>=58 and J<=65):
                                DTHETA2 = 1.0/3.0*DTHETA1
                                F_THETA1 = round(1.155*np.sin(2.094*(J-57)+3.142))
                                THETA2 = THETA1 + F_THETA1*DTHETA2  
                                PHI = (8-2)*PI/4.0
                                DPHI1 = 1.0/3.0*(PI/4.0)
                                F_PHI = round(1.115*np.sin(0.5236*(J-57)+3.927)+0.2989*np.sin(3.665*(J-57)-7.069))
                                PHI1 = PHI + F_PHI*DPHI1
                                R1 = AG*np.sin(THETA2)
                                XHET[H] = R1*np.cos(PHI1)+Xm0
                                YHET[H] = R1*np.sin(PHI1)+Ym0
                                ZHET[H] = AG*np.cos(THETA2)+Zm0
                                RHET[H] = RHET2
                                THETAT[H] = THETA2
                                PHIT[H] = PHI1
                            elif (J>=66 and J<=73):
                                DTHETA2 = 1.0/3.0*DTHETA1
                                F_THETA1 = round(1.155*np.sin(2.094*(J-65)+3.142))
                                THETA2 = THETA1 + F_THETA1*DTHETA2  
                                PHI = (9-2)*PI/4.0
                                DPHI1 = 1.0/3.0*(PI/4.0)
                                F_PHI = round(1.115*np.sin(0.5236*(J-65)+3.927)+0.2989*np.sin(3.665*(J-65)-7.069))
                                PHI1 = PHI + F_PHI*DPHI1
                                R1 = AG*np.sin(THETA2)
                                XHET[H] = R1*np.cos(PHI1)+Xm0
                                YHET[H] = R1*np.sin(PHI1)+Ym0
                                ZHET[H] = AG*np.cos(THETA2)+Zm0
                                RHET[H] = RHET2
                                THETAT[H] = THETA2
                                PHIT[H] = PHI1
                    H += 1    
                    last_index = J                                             
            else: # NOT AT POLES
                #THETA ANGLE
                THETA = (NTHETA-1)*DTHETA 
                #CALCULATE RING RADIUS
                RRING = AG*np.sin(THETA)
                #CALCULATE NUMBER OF HETERODOMAINS IN RING
                NHETRING = round(2.0*PI*RRING/ARCL)
                if (NHETRING<3):  
                    NHETRING = 3
                
                NHRINGREAL = NHETRING
                #RECALCULATE STEP IN PHI BASED ON NHETRING
                DPHI = 2.0*PI/NHRINGREAL
                #CALCULATE OFFSET AS 10# OF THE STEP IN PHI IF RING IS ODD OR EVEN
                M = NTHETA % 2
                PHIOFF = 0.1 * DPHI if M == 0 else -0.1 * DPHI

                ##M_PHI CONTAINS VALUES OF NPHI THAT WILL YIELD PHI ANGLE DOMAIN
                NPHI = round((PHIP-PHIOFF)/DPHI)
                if (NTHETA==2):
                    M_NPHI = np.arange(1,NHETRING+1)
                else:
                    if (NPHI==0):
                        M_NPHI = np.array([NPHI, NPHI+1, NHETRING-1])
                    else:
                        M_NPHI = np.array([NPHI, NPHI+1, NPHI-1])


                #LOOP THROUGH PHI DOMAIN
                for M in range(len(M_NPHI)):
                    #CALCULATE PHI ANGLE BASED ON COLLOID PHI ANGLE
                    PHI = M_NPHI[M]*DPHI+PHIOFF
                    for J in range(1, HETMODE+1):
                        if (J==1): #GENERATE LARGE HETERODOMAIN
                            XHET[H] = RRING*np.cos(PHI)+Xm0
                            YHET[H] = RRING*np.sin(PHI)+Ym0
                            ZHET[H] = AG*np.cos(THETA)+Zm0 
                            RHET[H] = RHET0
                            THETAT[H] = THETA
                            PHIT[H] = PHI
                        else: #GENERATE MEDIUM AND SMALL HETDOMAINS AROUND LARGE HETERODOMAIN
                            if (HETMODE==5): #1:4
                                DTHETA1 = 1.0/3.0*DTHETA
                                DPHI1 = 1.0/3.0*DPHI
                                if (J==2):   
                                    PHI1 = PHI - DPHI1
                                    THETA1 = THETA + DTHETA1

                                if (J==3):
                                    PHI1 = PHI + DPHI1
                                    THETA1 = THETA + DTHETA1

                                if (J==4):
                                    PHI1 = PHI + DPHI1
                                    THETA1 = THETA - DTHETA1

                                if (J==5):
                                    PHI1 = PHI - DPHI1
                                    THETA1 = THETA - DTHETA1
                                                                   
                                R1 = AG*np.sin(THETA1)   
                                XHET[H] = R1*np.cos(PHI1)+Xm0
                                YHET[H] = R1*np.sin(PHI1)+Ym0
                                ZHET[H] = AG*np.cos(THETA1)+Zm0
                                RHET[H] = RHET1
                                THETAT[H] = THETA1
                                PHIT[H] = PHI1
                            elif (HETMODE==9): #1:8
                                DTHETA1 = 1.0/3.0*DTHETA
                                F_THETA1 = round(1.155*np.sin(2.094*(J-1)+3.142))
                                THETA1 = THETA + F_THETA1*DTHETA1
                                DPHI1 = 1.0/3.0*DPHI
                                F_PHI1 = round(1.115*np.sin(0.5236*(J-1)+3.927)+0.2989*np.sin(3.665*(J-1)-7.069))
                                PHI1 = PHI + F_PHI1*DPHI1
                                R1 = AG*np.sin(THETA1)   
                                XHET[H] = R1*np.cos(PHI1)+Xm0
                                YHET[H] = R1*np.sin(PHI1)+Ym0
                                ZHET[H] = AG*np.cos(THETA1)+Zm0
                                RHET[H] = RHET1
                                THETAT[H] = THETA1
                                PHIT[H] = PHI1
                            elif (HETMODE==73): #1:8:64
                                if (J>=2 and J<=9):
                                    DTHETA1 = 1.0/3.0*DTHETA
                                    F_THETA1 = round(1.155*np.sin(2.094*(J-1)+3.142))
                                    THETA1 = THETA + F_THETA1*DTHETA1
                                    DPHI1 = 1.0/3.0*DPHI
                                    F_PHI1 = round(1.115*np.sin(0.5236*(J-1)+3.927)+0.2989*np.sin(3.665*(J-1)-7.069))
                                    PHI1 = PHI + F_PHI1*DPHI1
                                    R1 = AG*np.sin(THETA1)   
                                    XHET[H] = R1*np.cos(PHI1)+Xm0
                                    YHET[H] = R1*np.sin(PHI1)+Ym0
                                    ZHET[H] = AG*np.cos(THETA1)+Zm0
                                    RHET[H] = RHET1
                                    THETAT[H] = THETA1
                                    PHIT[H] = PHI1
                                elif (J>=10 and J<=17):
                                    DTHETA1 = 1.0/3.0*DTHETA
                                    F_THETA1 = round(1.155*np.sin(2.094*(1)+3.142))
                                    THETA1 = THETA + F_THETA1*DTHETA1
                                    DTHETA2 = 1.0/3.0*DTHETA1
                                    F_THETA2 = round(1.155*np.sin(2.094*(J-9)+3.142))
                                    THETA2 = THETA1 + F_THETA2*DTHETA2
                                    DPHI1 = 1.0/3.0*DPHI
                                    F_PHI1 = round(1.115*np.sin(0.5236*(1)+3.927)+0.2989*np.sin(3.665*(1)-7.069))
                                    PHI1 = PHI + F_PHI1*DPHI1
                                    DPHI2 = 1.0/3.0*DPHI1
                                    F_PHI2 = round(1.115*np.sin(0.5236*(J-9)+3.927)+0.2989*np.sin(3.665*(J-9)-7.069))
                                    PHI2 = PHI1 + F_PHI2*DPHI2
                                    R1 = AG*np.sin(THETA2)   
                                    XHET[H] = R1*np.cos(PHI2)+Xm0
                                    YHET[H] = R1*np.sin(PHI2)+Ym0
                                    ZHET[H] = AG*np.cos(THETA2)+Zm0
                                    RHET[H] = RHET2
                                    THETAT[H] = THETA2
                                    PHIT[H] = PHI2
                                elif (J>=18 and J<=25):
                                    DTHETA1 = 1.0/3.0*DTHETA
                                    F_THETA1 = round(1.155*np.sin(2.094*(2)+3.142))
                                    THETA1 = THETA + F_THETA1*DTHETA1
                                    DTHETA2 = 1.0/3.0*DTHETA1
                                    F_THETA2 = round(1.155*np.sin(2.094*(J-17)+3.142))
                                    THETA2 = THETA1 + F_THETA2*DTHETA2
                                    DPHI1 = 1.0/3.0*DPHI
                                    F_PHI1 = round(1.115*np.sin(0.5236*(2)+3.927)+0.2989*np.sin(3.665*(2)-7.069))
                                    PHI1 = PHI + F_PHI1*DPHI1
                                    DPHI2 = 1.0/3.0*DPHI1
                                    F_PHI2 = round(1.115*np.sin(0.5236*(J-17)+3.927)+0.2989*np.sin(3.665*(J-17)-7.069))
                                    PHI2 = PHI1 + F_PHI2*DPHI2
                                    R1 = AG*np.sin(THETA2)   
                                    XHET[H] = R1*np.cos(PHI2)+Xm0
                                    YHET[H] = R1*np.sin(PHI2)+Ym0
                                    ZHET[H] = AG*np.cos(THETA2)+Zm0
                                    RHET[H] = RHET2
                                    THETAT[H] = THETA2
                                    PHIT[H] = PHI2
                                elif (J>=26 and J<=33):
                                    DTHETA1 = 1.0/3.0*DTHETA
                                    F_THETA1 = round(1.155*np.sin(2.094*(3)+3.142))
                                    THETA1 = THETA + F_THETA1*DTHETA1
                                    DTHETA2 = 1.0/3.0*DTHETA1
                                    F_THETA2 = round(1.155*np.sin(2.094*(J-25)+3.142))
                                    THETA2 = THETA1 + F_THETA2*DTHETA2
                                    DPHI1 = 1.0/3.0*DPHI
                                    F_PHI1 = round(1.115*np.sin(0.5236*(3)+3.927)+0.2989*np.sin(3.665*(3)-7.069))
                                    PHI1 = PHI + F_PHI1*DPHI1
                                    DPHI2 = 1.0/3.0*DPHI1
                                    F_PHI2 = round(1.115*np.sin(0.5236*(J-25)+3.927)+0.2989*np.sin(3.665*(J-25)-7.069))
                                    PHI2 = PHI1 + F_PHI2*DPHI2
                                    R1 = AG*np.sin(THETA2)   
                                    XHET[H] = R1*np.cos(PHI2)+Xm0
                                    YHET[H] = R1*np.sin(PHI2)+Ym0
                                    ZHET[H] = AG*np.cos(THETA2)+Zm0
                                    RHET[H] = RHET2
                                    THETAT[H] = THETA2
                                    PHIT[H] = PHI2
                                elif (J>=34 and J<=41):
                                    DTHETA1 = 1.0/3.0*DTHETA
                                    F_THETA1 = round(1.155*np.sin(2.094*(4)+3.142))
                                    THETA1 = THETA + F_THETA1*DTHETA1
                                    DTHETA2 = 1.0/3.0*DTHETA1
                                    F_THETA2 = round(1.155*np.sin(2.094*(J-33)+3.142))
                                    THETA2 = THETA1 + F_THETA2*DTHETA2
                                    DPHI1 = 1.0/3.0*DPHI
                                    F_PHI1 = round(1.115*np.sin(0.5236*(4)+3.927)+0.2989*np.sin(3.665*(4)-7.069))
                                    PHI1 = PHI + F_PHI1*DPHI1
                                    DPHI2 = 1.0/3.0*DPHI1
                                    F_PHI2 = round(1.115*np.sin(0.5236*(J-33)+3.927)+0.2989*np.sin(3.665*(J-33)-7.069))
                                    PHI2 = PHI1 + F_PHI2*DPHI2
                                    R1 = AG*np.sin(THETA2)   
                                    XHET[H] = R1*np.cos(PHI2)+Xm0
                                    YHET[H] = R1*np.sin(PHI2)+Ym0
                                    ZHET[H] = AG*np.cos(THETA2)+Zm0
                                    RHET[H] = RHET2
                                    THETAT[H] = THETA2
                                    PHIT[H] = PHI2
                                elif (J>=42 and J<=49):
                                    DTHETA1 = 1.0/3.0*DTHETA
                                    F_THETA1 = round(1.155*np.sin(2.094*(5)+3.142))
                                    THETA1 = THETA + F_THETA1*DTHETA1
                                    DTHETA2 = 1.0/3.0*DTHETA1
                                    F_THETA2 = round(1.155*np.sin(2.094*(J-41)+3.142))
                                    THETA2 = THETA1 + F_THETA2*DTHETA2
                                    DPHI1 = 1.0/3.0*DPHI
                                    F_PHI1 = round(1.115*np.sin(0.5236*(5)+3.927)+0.2989*np.sin(3.665*(5)-7.069))
                                    PHI1 = PHI + F_PHI1*DPHI1
                                    DPHI2 = 1.0/3.0*DPHI1
                                    F_PHI2 = round(1.115*np.sin(0.5236*(J-41)+3.927)+0.2989*np.sin(3.665*(J-41)-7.069))
                                    PHI2 = PHI1 + F_PHI2*DPHI2
                                    R1 = AG*np.sin(THETA2)   
                                    XHET[H] = R1*np.cos(PHI2)+Xm0
                                    YHET[H] = R1*np.sin(PHI2)+Ym0
                                    ZHET[H] = AG*np.cos(THETA2)+Zm0
                                    RHET[H] = RHET2
                                    THETAT[H] = THETA2
                                    PHIT[H] = PHI2
                                elif (J>=50 and J<=57):
                                    DTHETA1 = 1.0/3.0*DTHETA
                                    F_THETA1 = round(1.155*np.sin(2.094*(6)+3.142))
                                    THETA1 = THETA + F_THETA1*DTHETA1
                                    DTHETA2 = 1.0/3.0*DTHETA1
                                    F_THETA2 = round(1.155*np.sin(2.094*(J-49)+3.142))
                                    THETA2 = THETA1 + F_THETA2*DTHETA2
                                    DPHI1 = 1.0/3.0*DPHI
                                    F_PHI1 = round(1.115*np.sin(0.5236*(6)+3.927)+0.2989*np.sin(3.665*(6)-7.069))
                                    PHI1 = PHI + F_PHI1*DPHI1
                                    DPHI2 = 1.0/3.0*DPHI1
                                    F_PHI2 = round(1.115*np.sin(0.5236*(J-49)+3.927)+0.2989*np.sin(3.665*(J-49)-7.069))
                                    PHI2 = PHI1 + F_PHI2*DPHI2
                                    R1 = AG*np.sin(THETA2)   
                                    XHET[H] = R1*np.cos(PHI2)+Xm0
                                    YHET[H] = R1*np.sin(PHI2)+Ym0
                                    ZHET[H] = AG*np.cos(THETA2)+Zm0
                                    RHET[H] = RHET2
                                    THETAT[H] = THETA2
                                    PHIT[H] = PHI2
                                elif (J>=58 and J<=65):
                                    DTHETA1 = 1.0/3.0*DTHETA
                                    F_THETA1 = round(1.155*np.sin(2.094*(7)+3.142))
                                    THETA1 = THETA + F_THETA1*DTHETA1
                                    DTHETA2 = 1.0/3.0*DTHETA1
                                    F_THETA2 = round(1.155*np.sin(2.094*(J-57)+3.142))
                                    THETA2 = THETA1 + F_THETA2*DTHETA2
                                    DPHI1 = 1.0/3.0*DPHI
                                    F_PHI1 = round(1.115*np.sin(0.5236*(7)+3.927)+0.2989*np.sin(3.665*(7)-7.069))
                                    PHI1 = PHI + F_PHI1*DPHI1
                                    DPHI2 = 1.0/3.0*DPHI1
                                    F_PHI2 = round(1.115*np.sin(0.5236*(J-57)+3.927)+0.2989*np.sin(3.665*(J-57)-7.069))
                                    PHI2 = PHI1 + F_PHI2*DPHI2
                                    R1 = AG*np.sin(THETA2)   
                                    XHET[H] = R1*np.cos(PHI2)+Xm0
                                    YHET[H] = R1*np.sin(PHI2)+Ym0
                                    ZHET[H] = AG*np.cos(THETA2)+Zm0
                                    RHET[H] = RHET2
                                    THETAT[H] = THETA2
                                    PHIT[H] = PHI2
                                elif (J>=66 and J<=73):
                                    DTHETA1 = 1.0/3.0*DTHETA
                                    F_THETA1 = round(1.155*np.sin(2.094*(8)+3.142))
                                    THETA1 = THETA + F_THETA1*DTHETA1
                                    DTHETA2 = 1.0/3.0*DTHETA1
                                    F_THETA2 = round(1.155*np.sin(2.094*(J-65)+3.142))
                                    THETA2 = THETA1 + F_THETA2*DTHETA2
                                    DPHI1 = 1.0/3.0*DPHI
                                    F_PHI1 = round(1.115*np.sin(0.5236*(8)+3.927)+0.2989*np.sin(3.665*(8)-7.069))
                                    PHI1 = PHI + F_PHI1*DPHI1
                                    DPHI2 = 1.0/3.0*DPHI1
                                    F_PHI2 = round(1.115*np.sin(0.5236*(J-65)+3.927)+0.2989*np.sin(3.665*(J-65)-7.069))
                                    PHI2 = PHI1 + F_PHI2*DPHI2
                                    R1 = AG*np.sin(THETA2)   
                                    XHET[H] = R1*np.cos(PHI2)+Xm0
                                    YHET[H] = R1*np.sin(PHI2)+Ym0
                                    ZHET[H] = AG*np.cos(THETA2)+Zm0
                                    RHET[H] = RHET2
                                    THETAT[H] = THETA2
                                    PHIT[H] = PHI2
                    H += 1
                    last_index = J                    
    last_index = J + 1 # Update last index for the arrays
    XHET = XHET[:last_index]
    YHET = YHET[:last_index]
    ZHET = ZHET[:last_index]
    RHET = RHET[:last_index]
    THETAT = THETAT[:last_index]
    PHIT = PHIT[:last_index]

    return XHET,YHET,ZHET,RHET                    
                                              
def AFMHETC_TRANSFORM(XG,YG,ZG,THETA,PHI,XHET,YHET,ZHET):
    ''' FUNCTION TO PERFORM COORDINATE TRANSFORMATION OF HETC TO A GIVEN FRAME OF REFERENCE  - CESAR RON '''

    PI=3.14159265359

    # TRANSFORM HETC POSITIONS TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING 
    # THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER

    # ROTATE HETC LOCATIONS BASED ON COLLOID SPHERICAL COORDINATES 
    # (X-CONVENTION, Z-X-Z SEQUENCE ROTATION IS COUNTER=CLOCKWISE) (GOLDSTEIN, 2001, P.152 AND P.601)
    PHI_R   = 0.5*PI + PHI
    THETA_R = THETA
    PSI_R   = 1.5*PI - PHI
    # ROTATION MATRIX
    MR = ROTATION_HETC(THETA_R,PHI_R,PSI_R)

    # UNIT VECTORS DEFINING THE COLLECTOR FRAME OF REFERENCE
    EX_C = np.array([1, 0, 0])
    EY_C = np.array([0, 1, 0])
    EZ_C = np.array([0, 0, 1])
    # UNIT VECTOR DEFINING THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT WHERE THE COLLOID CENTER IS PROJECTED
    EX_G = EX_C @ MR
    EY_G = EY_C @ MR
    EZ_G = EZ_C @ MR
    # TRANSFORMATION MATRIX BASED ON PREVIOUS UNIT VECTORS
    MT = np.column_stack((EX_G, EY_G, EZ_G))
    # GET POSITION COLUMNS ONLY AND TRASLATE POSITIONS (WHICH IS REQUIRED PREVIOUS TO APPLY THE TRANSFORMATION)
    MI = np.zeros((len(XHET), 3))  # Initialize MI with zeros
    MI[:, 0] = XHET - XG
    MI[:, 1] = YHET - YG
    MI[:, 2] = ZHET - ZG
    # APPLY THE TRANSFORMATION
    MI = MI@MT
    # OUTPUT MATRIX WITH RADII
    XHET_AF = MI[:, 0]
    YHET_AF = MI[:, 1]
    ZHET_AF = MI[:, 2]
    return XHET_AF,YHET_AF,ZHET_AF
        
def ROTATION_HETC(theta,phi,psi):
    '''FUNCTION TO CALCULATE ROTATION MATRIX'''

    #QUATERNIONS FOR ROTATION MATRIX BASED ON THETA, PHI AND PSI
    q0 = np.cos(0.5*phi + 0.5*psi)*np.cos(0.5*theta)
    q1 = np.cos(0.5*phi - 0.5*psi)*np.sin(0.5*theta)
    q2 = np.sin(0.5*phi - 0.5*psi)*np.sin(0.5*theta)
    q3 = np.sin(0.5*phi + 0.5*psi)*np.cos(0.5*theta)
    ROT_MAT = np.array([
        [1-2*(q2**2+q3**2), 2*(q1*q2-q0*q3), 2*(q1*q3-q2*q0)], 
        [2*(q1*q2-q3*q0), 1-2*(q1**2+q3**2), 2*(q0*q1+q2*q3)],
        [2*(q0*q2+q1*q3), 2*(q2*q3-q0*q1), 1-2*(q1**2+q2**2)]])
    return ROT_MAT

def AFMAREAFRACT(XP,YP,RZOI,XHET,YHET,RHET,MPRO):
    ''' FUNCTION TO DETERMINE FRACTIONAL AREA WRITTEN - CESAR RON '''


    #DEFINE COLLOID CENTER IN COLLECTOR FRAME OF REFERENCE
    XmP0 = XP 
    YmP0 = YP 

    #DEFINE HETP PROJECTIONS MATRIX AND ZOI-HET MATRIX
    m1 = MPRO #HETP PROJECTIONS
    m2 = np.array([[XmP0, YmP0, RZOI], [XHET, YHET, RHET]])

    # ZOI and HET radii
    rz = m2[0, 2]
    rh = m2[1, 2]

    # distances between ZOI and HET
    dxzh = m2[1, 0]-m2[0, 0]
    dyzh = m2[1, 1]-m2[0, 1]
    dzh = np.sqrt(dxzh**2+dyzh**2)
    sumrzh = rz + rh
    diffrzh = rz - rh
    # number of rows for m1 and m2
    s1 = m1.shape[0]
    s2 = m2.shape[0]

    # distances between PRO and both ZOI and HET
    dx = m1[:, 0, np.newaxis] - m2[:, 0]
    dy = m1[:, 1, np.newaxis] - m2[:, 1]

    # Sum and difference between PRO and both ZOI and HET
    sumr = m1[:, 2, np.newaxis] + m2[:, 2]
    diffr = m1[:, 2, np.newaxis] - m2[:, 2]

    # Distance between PRO and both ZOI and HET
    dist = np.sqrt(dx ** 2 + dy ** 2)

    # Pairs PRO-ZOI and PRO-HET which overlap
    pairs_o_idx = np.where(dist < sumr)
    if pairs_o_idx[0].size > 0:
        pairs_o = np.ravel_multi_index(pairs_o_idx, dist.shape)
    else:
        pairs_o = np.array([], dtype=int)

    p_diffr_idx = np.where(dist > np.abs(diffr))
    if p_diffr_idx[0].size > 0:
        p_diffr = np.ravel_multi_index(p_diffr_idx, dist.shape)
    else:
        p_diffr = np.array([], dtype=int)

    p_diffr2_idx = np.where(dist <= np.abs(diffr))
    if p_diffr2_idx[0].size > 0:
        p_diffr2 = np.ravel_multi_index(p_diffr2_idx, dist.shape)
    else:
        p_diffr2 = np.array([], dtype=int)

    # Pairs PRO-ZOI and PRO-HET that partially overlap
    pairs_po = np.intersect1d(pairs_o, p_diffr)

    # Pairs PRO-ZOI and PRO-HET that completely overlap
    pairs_co = np.intersect1d(pairs_o, p_diffr2)

    # PRO overlap matrix: 1 for partial overlap, -1 for complete overlap, 0 for no overlap
    om_p = np.zeros((s1, s2), dtype=int)
    om_p.flat[pairs_po] = 1
    om_p.flat[pairs_co] = -1

    # ZOI-HET overlap matrix: 1 for partial overlap, -1 for complete overlap, 0 for no overlap
    om_zh = 0
    if dzh > sumrzh:
        om_zh = 0
    else:
        if abs(diffrzh) >= dzh:
            om_zh = -1
        else:
            om_zh = 1

    # Calculate 2 overlap areas for PRO-ZOI and PRO-HET
    c1 = np.tile(np.arange(1, s1 + 1), (s2, 1)).T
    c2 = np.tile(np.arange(1, s2 + 1), (s1, 1))
    r1 = m1[c1.flat[pairs_o]-1, 2]  # Radius from m1 corresponding to value in pairs
    r2 = m2[c2.flat[pairs_o]-1, 2]  # Radius from m2 corresponding to value in pairs
    d = dist.flat[pairs_o]  # Distance from dist corresponding to value in pairs
    Ao2_1 = np.zeros((s1, s2))
    Ao2_1.flat[pairs_o] = overlap2(r1, r2, d)  # Function to calculate overlap area between 2 circles

    # Calculate 2 overlap area for ZOI-HET
    Ao2_2 = overlap2(rz, rh, dzh) if dzh < (rz + rh) else 0.0

    # Initialize matrices for overlap areas
    Ao2_pz = np.zeros((s1,1))  # Matrix for 2 overlap area for PRO-ZOI
    Ao2_ph = np.zeros((s1,1))  # Matrix for 2 overlap area for PRO-HET
    Ao2_zh = np.zeros((s1,1))   # Matrix for 2 overlap area for ZOI-HET
    Ao3_f = np.zeros((s1,1))   # Matrix for 3 overlap area

    # Loop through each PRO
    for i in range(s1):
        azh = om_zh
        apz = om_p[i, 0]
        aph = om_p[i, 1]
        
        if (apz == 1) and (aph == 1):  # PRO-ZOI partial overlap, PRO-HET partial overlap
            if azh == 0:  # No ZOI-HET overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = Ao2_1[i, 0]
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = 0
            elif azh == 1:  # ZOI-HET partial overlap
                izh = intersection(rz, rh, m2[0, 0], m2[0, 1], m2[1, 0], m2[1, 1], 0, 0)
                ipip = inside(m1[i, 0], m1[i, 1], m1[i, 2], izh)
                ipz = intersection(rz, m1[i, 2], m2[0, 0], m2[0, 1], m1[i, 0], m1[i, 1], 0, 0)
                ipih = inside(m2[1, 0], m2[1, 1], m2[1, 2], ipz)
                iph = intersection(rh, m1[i, 2], m2[1, 0], m2[1, 1], m1[i, 0], m1[i, 1], m2[1, 0], m2[1, 1])
                ipiz = inside(m2[0, 0], m2[0, 1], m2[0, 2], iph)
                
                if not any(ipip) and not any(ipih) and not any(ipiz):  # Only 2 overlap area
                    Ao3_f[i, 0] = 0
                    Ao2_pz[i, 0] = Ao2_1[i, 0]
                    Ao2_ph[i, 0] = 0
                    Ao2_zh[i, 0] = Ao2_2
                else:  # 3 overlap area
                    locator_ip = np.where(ipip == 1)[0]
                    locator_ih = np.where(ipih == 1)[0]
                    locator_iz = np.where(ipiz == 1)[0]
                    
                    if len(locator_ih) == 0 and len(locator_ip) > 1 and len(locator_iz) > 1:
                        points_ip = intersection(rz, rh, m2[0, 0], m2[0, 1], m2[1, 0], m2[1, 1], 0, 0)
                        points_iz = intersection(rh, m1[i, 2], m2[1, 0], m2[1, 1], m1[i, 0], m1[i, 1], m2[1, 0], m2[1, 1])
                        points_ih = []
                        Ao3_f[i, 0] = overlap4(points_ip, points_iz, rh, rz, m1[i, 2])
                        Ao2_pz[i, 0] = Ao2_1[i, 0] - Ao3_f[i, 0]
                        Ao2_ph[i, 0] = 0
                        Ao2_zh[i, 0] = Ao2_2 - Ao3_f[i, 0]
                    elif len(locator_iz) == 0 and len(locator_ip) > 1 and len(locator_ih) > 1:
                        points_ip = intersection(rz, rh, m2[0, 0], m2[0, 1], m2[1, 0], m2[1, 1], 0, 0)
                        points_iz = []
                        points_ih = intersection(m1[i, 2], rz, m1[i, 0], m1[i, 1], m2[0, 0], m2[0, 1], m1[i, 0], m1[i, 1])
                        Ao3_f[i, 0] = overlap4(points_ip, points_ih, rz, rh, m1[i, 2])
                        Ao2_pz[i, 0] = Ao2_1[i, 0] - Ao3_f[i, 0]
                        Ao2_ph[i, 0] = 0
                        Ao2_zh[i, 0] = Ao2_2 - Ao3_f[i, 0]
                    elif len(locator_ip) == 0 and len(locator_iz) > 1 and len(locator_ih) > 1:
                        points_ip = []
                        points_iz = intersection(rh, m1[i, 2], m2[1, 0], m2[1, 1], m1[i, 0], m1[i, 1], m2[1, 0], m2[1, 1])
                        points_ih = intersection(m1[i, 2], rz, m1[i, 0], m1[i, 1], m2[0, 0], m2[0, 1], m1[i, 0], m1[i, 1])
                        Ao3_f[i, 0] = overlap4(points_iz, points_ih, m1[i, 2], rh, rz)
                        Ao2_pz[i, 0] = Ao2_1[i, 0] - Ao3_f[i, 0]
                        Ao2_ph[i, 0] = 0
                        Ao2_zh[i, 0] = Ao2_2 - Ao3_f[i, 0]
                    elif len(locator_ip) == 0 and len(locator_ih) == 0 and len(locator_iz) > 1:
                        Ao3_f[i, 0] = Ao2_1[i, 1]
                        Ao2_pz[i, 0] = Ao2_1[i, 0] - Ao3_f[i, 0]
                        Ao2_ph[i, 0] = 0
                        Ao2_zh[i, 0] = Ao2_2 - Ao3_f[i, 0]
                    elif len(locator_ip) == 1 and len(locator_ih) == 1 and len(locator_iz) == 1:
                        points_ih = ipz[locator_ih, :]
                        points_iz = iph[locator_iz, :]
                        points_ip = izh[locator_ip, :]
                        Ao3_f[i, 0] = overlap3(m1[i, 2], rz, rh, points_ih, points_ip, points_iz)
                        Ao2_pz[i, 0] = Ao2_1[i, 0] - Ao3_f[i, 0]
                        Ao2_ph[i, 0] = 0
                        Ao2_zh[i, 0] = Ao2_2 - Ao3_f[i, 0]
                    else:
                        Ao3_f[i, 0] = 0
                        Ao2_pz[i, 0] = Ao2_1[i, 0]
                        Ao2_ph[i, 0] = 0
                        Ao2_zh[i, 0] = Ao2_2
        elif (apz == 1) and (aph == -1):  # PRO-ZOI partial overlap, PRO-HET complete overlap
            if azh == 0:  # No ZOI-HET overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = Ao2_1[i, 0]
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = 0
            elif azh == 1:  # ZOI-HET partial overlap
                if rh >= m1[i, 2]:  # HET >= PRO
                    Ao3_f[i, 0] = Ao2_1[i, 0]
                    Ao2_pz[i, 0] = 0
                    Ao2_ph[i, 0] = 0
                    Ao2_zh[i, 0] = Ao2_2 - Ao3_f[i, 0]
                elif m1[i, 2] > rh:  # PRO > HET
                    Ao3_f[i, 0] = Ao2_2
                    Ao2_pz[i, 0] = Ao2_1[i, 0] - Ao3_f[i, 0]
                    Ao2_ph[i, 0] = 0
                    Ao2_zh[i, 0] = 0
            elif azh == -1:  # ZOI-HET complete overlap
                if rh >= m1[i, 2]:  # HET >= PRO
                    Ao3_f[i, 0] = Ao2_1[i, 0]
                    Ao2_pz[i, 0] = 0
                    Ao2_ph[i, 0] = 0
                    Ao2_zh[i, 0] = Ao2_2 - Ao3_f[i, 0]
                elif m1[i, 2] > rh:  # PRO > HET
                    Ao3_f[i, 0] = Ao2_2
                    Ao2_pz[i, 0] = Ao2_1[i, 0] - Ao3_f[i, 0]
                    Ao2_ph[i, 0] = 0
                    Ao2_zh[i, 0] = 0

        elif (apz == -1) and (aph == 1):  # PRO-ZOI complete overlap, PRO-HET partial overlap
            if azh == 0:  # No ZOI-HET overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = Ao2_1[i, 0]
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = 0
            elif azh == 1:  # ZOI-HET partial overlap
                if rz >= m1[i, 2]:  # ZOI >= PRO
                    Ao3_f[i, 0] = Ao2_1[i, 1]
                    Ao2_pz[i, 0] = Ao2_1[i, 0] - Ao3_f[i, 0]
                    Ao2_ph[i, 0] = 0
                    Ao2_zh[i, 0] = Ao2_2 - Ao3_f[i, 0]
                elif m1[i, 2] > rz:  # PRO > ZOI
                    Ao3_f[i, 0] = Ao2_2
                    Ao2_pz[i, 0] = Ao2_1[i, 0] - Ao3_f[i, 0]
                    Ao2_ph[i, 0] = 0
                    Ao2_zh[i, 0] = 0
            elif azh == -1:  # ZOI-HET complete overlap
                if rz >= rh:  # ZOI >= HET
                    Ao3_f[i, 0] = Ao2_1[i, 1]
                    Ao2_pz[i, 0] = Ao2_1[i, 0] - Ao3_f[i, 0]
                    Ao2_ph[i, 0] = 0
                    Ao2_zh[i, 0] = Ao2_2 - Ao3_f[i, 0]
                elif rh > rz:  # HET > ZOI
                    Ao3_f[i, 0] = Ao2_2
                    Ao2_pz[i, 0] = 0
                    Ao2_ph[i, 0] = 0
                    Ao2_zh[i, 0] = 0

        elif (apz == -1) and (aph == -1):  # PRO-ZOI complete overlap, PRO-HET complete overlap
            if azh == 0:  # No ZOI-HET overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = Ao2_1[i, 0]
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = 0
            elif azh == 1:  # ZOI-HET partial overlap
                if m1[i, 2] >= rz and m1[i, 2] >= rh:
                    Ao3_f[i, 0] = Ao2_2
                    Ao2_pz[i, 0] = Ao2_1[i, 0] - Ao3_f[i, 0]
                    Ao2_ph[i, 0] = 0
                    Ao2_zh[i, 0] = 0
                else:
                    Ao3_f[i, 0] = Ao2_1[i, 1]
                    Ao2_pz[i, 0] = 0
                    Ao2_ph[i, 0] = 0
                    Ao2_zh[i, 0] = Ao2_2 - Ao3_f[i, 0]
            elif azh == -1:  # ZOI-HET complete overlap
                if rz >= rh and rz >= m1[i, 2]:
                    if rh >= m1[i, 2]:
                        Ao3_f[i, 0] = Ao2_1[i, 0]
                        Ao2_pz[i, 0] = 0
                        Ao2_ph[i, 0] = 0
                        Ao2_zh[i, 0] = Ao2_2 - Ao3_f[i, 0]
                    elif m1[i, 2] > rh:
                        Ao3_f[i, 0] = Ao2_2
                        Ao2_pz[i, 0] = Ao2_1[i, 0] - Ao3_f[i, 0]
                        Ao2_ph[i, 0] = 0
                        Ao2_zh[i, 0] = 0
                elif rh >= rz and rh >= m1[i, 2]:
                    if rz >= m1[i, 2]:
                        Ao3_f[i, 0] = Ao2_1[i, 0]
                        Ao2_pz[i, 0] = 0
                        Ao2_ph[i, 0] = 0
                        Ao2_zh[i, 0] = Ao2_2 - Ao3_f[i, 0]
                    elif m1[i, 2] > rz:
                        Ao3_f[i, 0] = Ao2_2
                        Ao2_pz[i, 0] = 0
                        Ao2_ph[i, 0] = 0
                        Ao2_zh[i, 0] = 0
                elif m1[i, 2] >= rz and m1[i, 2] >= rh:
                    if rz >= rh:
                        Ao3_f[i, 0] = Ao2_2
                        Ao2_pz[i, 0] = Ao2_1[i, 0] - Ao3_f[i, 0]
                        Ao2_ph[i, 0] = 0
                        Ao2_zh[i, 0] = 0
                    elif rh > rz:
                        Ao3_f[i, 0] = Ao2_2
                        Ao2_pz[i, 0] = 0
                        Ao2_ph[i, 0] = 0
                        Ao2_zh[i, 0] = 0
        elif (apz == 1) and (aph == 0):  # PRO-ZOI partial overlap, PRO-HET no overlap
            if azh == 0:  # No ZOI-HET overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = Ao2_1[i, 0]
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = 0
            elif azh == 1:  # ZOI-HET partial overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = Ao2_1[i, 0]
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = Ao2_2
            elif azh == -1:  # ZOI-HET complete overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = Ao2_1[i, 0]
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = Ao2_2

        elif (apz == 0) and (aph == 1):  # PRO-ZOI no overlap, PRO-HET partial overlap
            if azh == 0:  # No ZOI-HET overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = 0
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = 0
            elif azh == 1:  # ZOI-HET partial overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = 0
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = Ao2_2
            elif azh == -1:  # ZOI-HET complete overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = Ao2_1[i, 0]
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = Ao2_2

        elif (apz == -1) and (aph == 0):  # PRO-ZOI complete overlap, PRO-HET no overlap
            if azh == 0:  # No ZOI-HET overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = Ao2_1[i, 0]
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = 0
            elif azh == 1:  # ZOI-HET partial overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = Ao2_1[i, 0]
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = Ao2_2
            elif azh == -1:  # ZOI-HET complete overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = Ao2_1[i, 0]
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = Ao2_2

        elif (apz == 0) and (aph == -1):  # PRO-ZOI no overlap, PRO-HET complete overlap
            if azh == 0:  # No ZOI-HET overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = 0
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = 0
            elif azh == 1:  # ZOI-HET partial overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = 0
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = Ao2_2
            elif azh == -1:  # ZOI-HET complete overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = 0
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = Ao2_2

        elif (apz == 0) and (aph == 0):  # PRO-ZOI no overlap, PRO-HET no overlap
            if azh == 0:  # No ZOI-HET overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = 0
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = 0
            elif azh == 1:  # ZOI-HET partial overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = 0
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = Ao2_2
            elif azh == -1:  # ZOI-HET complete overlap
                Ao3_f[i, 0] = 0
                Ao2_pz[i, 0] = 0
                Ao2_ph[i, 0] = 0
                Ao2_zh[i, 0] = Ao2_2

        else:  # Any other case where no overlap occurs
            Ao3_f[i, 0] = 0
            Ao2_pz[i, 0] = 0
            Ao2_ph[i, 0] = 0
            Ao2_zh[i, 0] = 0
    # Final overlapping area
    Ao2_pzf = Ao2_pz
    Ao2_phf = Ao2_ph

    # Check for other scenarios in ZOI-HET overlap
    if np.sum(Ao2_zh) > 0:
        Ao2_zhf = Ao2_2
        for i in range(s1):  # Loop through each PRO
            Ao2_zhf -= Ao3_f[i, 0]
    else:
        Ao2_zhf = 0

    # Calculate attractive fractional area
    AF_PZ = np.sum(Ao2_pzf) / (np.pi * rz**2)
    AF_ZH = np.sum(Ao2_zhf) / (np.pi * rz**2)

    # Calculate repulsive fractional area
    AF_PZH = np.sum(Ao3_f) / (np.pi * rz**2)
    AF_Z = 1 - AF_PZ - AF_ZH - AF_PZH
    return AF_PZ,AF_ZH,AF_PZH,AF_Z

# Function to calculate 2 overlap area
# def overlap2(r1, r2, d):

#     r1 = np.atleast_1d(r1)
#     r2 = np.atleast_1d(r2)
#     d = np.atleast_1d(d)

#     r1_2 = r1 ** 2
#     r2_2 = r2 ** 2
#     d_2 = d ** 2
#     a1 = np.arccos((d_2 + r1_2 - r2_2) / (2 * d * r1))
#     a2 = np.arccos((d_2 + r2_2 - r1_2) / (2 * d * r2))
#     a1 = np.atleast_1d(a1)
#     a2 = np.atleast_1d(a2)
#     Ao2 = r1_2 * a1 + r2_2 * a2 - 0.5 * np.sqrt((-d + r1 + r2) * (d + r1 - r2) * (d - r1 + r2) * (d + r1 + r2))

#     # Fix total overlap situation, r1 - r2 > d
#     f  = np.where(np.isnan(a1) | np.isnan(a2))[0]

#     if f.size > 0:
#         Ao2[f] = np.pi * np.minimum(r1[f], r2[f]) **2
        
#     return Ao2
def overlap2(r1, r2, d):
    """Calculate the overlap area of two circles following MATLAB logic."""

    r1 = np.atleast_1d(
        np.asarray(r1, dtype=float)
    )

    r2 = np.atleast_1d(
        np.asarray(r2, dtype=float)
    )

    d = np.atleast_1d(
        np.asarray(d, dtype=float)
    )

    r1_2 = r1 ** 2
    r2_2 = r2 ** 2
    d_2 = d ** 2

    with np.errstate(
        divide="ignore",
        invalid="ignore",
    ):
        argument_a1 = (
            d_2
            + r1_2
            - r2_2
        ) / (
            2.0
            * d
            * r1
        )

        argument_a2 = (
            d_2
            + r2_2
            - r1_2
        ) / (
            2.0
            * d
            * r2
        )

        a1 = np.lib.scimath.arccos(
            argument_a1
        )

        a2 = np.lib.scimath.arccos(
            argument_a2
        )

        radicand = (
            (-d + r1 + r2)
            * (d + r1 - r2)
            * (d - r1 + r2)
            * (d + r1 + r2)
        )

        ao2 = (
            r1_2 * a1
            + r2_2 * a2
            - 0.5
            * np.lib.scimath.sqrt(
                radicand
            )
        )

    # MATLAB:
    # f = find(abs(imag(a1)) + abs(imag(a2)) > 0);

    complex_overlap = (
        np.abs(np.imag(a1))
        + np.abs(np.imag(a2))
    ) > 0.0

    if np.any(complex_overlap):
        ao2[complex_overlap] = (
            np.pi
            * np.minimum(
                r1[complex_overlap],
                r2[complex_overlap],
            ) ** 2
        )

    return np.real(ao2)

# Function to calculate 3 overlap area with 3 intersection points
def overlap3(r1, r2, r3, points_A, points_B, points_C):
    r1_sq, r2_sq, r3_sq = r1 ** 2, r2 ** 2, r3 ** 2

    # Distance between points forming the polygon
    dAB = np.sqrt(np.sum((points_A - points_B) ** 2, axis=1))
    dBC = np.sqrt(np.sum((points_C - points_B) ** 2, axis=1))
    dAC = np.sqrt(np.sum((points_C - points_A) ** 2, axis=1))

    # Area of the polygon (triangle)
    s = 0.5 * (dAB + dBC + dAC)
    Ap = np.sqrt(s * (s - dAB) * (s - dBC) * (s - dAC))

    # Angle of circular segment
    theta_AB = 2 * np.arcsin(dAB / (2 * r2))
    theta_BC = 2 * np.arcsin(dBC / (2 * r3))
    theta_AC = 2 * np.arcsin(dAC / (2 * r1))

    # Area of circular segment
    Acs_AB = 0.5 * r2_sq * (theta_AB - np.sin(theta_AB))
    Acs_BC = 0.5 * r3_sq * (theta_BC - np.sin(theta_BC))
    Acs_AC = 0.5 * r1_sq * (theta_AC - np.sin(theta_AC))

    # Total 3 overlap area
    Ao3 = Acs_AB + Acs_BC + Acs_AC + Ap
    return Ao3

# Function to calculate 3 overlap area with 4 intersection points
def overlap4(points_ab, points_cd, r1, r2, r3):
    xa, xb, xc, xd = points_ab[0, 0], points_ab[1, 0], points_cd[0, 0], points_cd[1, 0]
    ya, yb, yc, yd = points_ab[0, 1], points_ab[1, 1], points_cd[0, 1], points_cd[1, 1]

    # Distance between points forming the polygon
    d_ab = np.sqrt((xa - xb) ** 2 + (ya - yb) ** 2)
    d_cd = np.sqrt((xc - xd) ** 2 + (yc - yd) ** 2)
    d_ac = np.sqrt((xa - xc) ** 2 + (ya - yc) ** 2)
    d_bd = np.sqrt((xb - xd) ** 2 + (yb - yd) ** 2)
    d_ad = np.sqrt((xa - xd) ** 2 + (ya - yd) ** 2)
    d_bc = np.sqrt((xb - xc) ** 2 + (yb - yc) ** 2)

    # Area of polygon (quadrilateral)
    Ap = 0.25 * np.sqrt(4 * d_ad ** 2 * d_bc ** 2 - (d_ab ** 2 + d_cd ** 2 - d_ac ** 2 - d_bd ** 2) ** 2)

    # Angle of circular segment
    theta_ab = 2 * np.arcsin(d_ab / (2 * r2))
    theta_cd = 2 * np.arcsin(d_cd / (2 * r3))
    theta_ac = 2 * np.arcsin(d_ac / (2 * r1))
    theta_bd = 2 * np.arcsin(d_bd / (2 * r1))

    # Area of circular segment
    Acs_ab = 0.5 * r2 ** 2 * (theta_ab - np.sin(theta_ab))
    Acs_cd = 0.5 * r3 ** 2 * (theta_cd - np.sin(theta_cd))
    Acs_ac = 0.5 * r1 ** 2 * (theta_ac - np.sin(theta_ac))
    Acs_bd = 0.5 * r1 ** 2 * (theta_bd - np.sin(theta_bd))

    # Total 3 overlap area
    Ao3 = Acs_ab + Acs_cd + Acs_ac + Acs_bd + Ap
    return Ao3

# Function to determine intersection points between 2 circles
def intersection(r1, r2, x1, y1, x2, y2, x0, y0):
    intersection_points = []
    dx12 = x2 - x1
    dy12 = y2 - y1
    d12 = np.sqrt(dx12 ** 2 + dy12 ** 2)
    if dy12 < 0:
        phi_12 = 2 * np.pi - np.arccos(dx12 / d12)
    else:
        phi_12 = np.arccos(dx12 / d12)
    psi_12 = np.arccos((r1 ** 2 + d12 ** 2 - r2 ** 2) / (2 * r1 * d12))
    omega1_12 = phi_12 + psi_12
    omega2_12 = phi_12 - psi_12
    x1_12 = np.cos(omega1_12) * r1 + x0
    y1_12 = np.sin(omega1_12) * r1 + y0
    x2_12 = np.cos(omega2_12) * r1 + x0
    y2_12 = np.sin(omega2_12) * r1 + y0
    intersection_points.extend([(x1_12, y1_12), (x2_12, y2_12)])
    return np.array(intersection_points)

# Function to determine intersection points inside a circle
def inside(x3, y3, r3, intersection_points):
    inside_points = np.zeros(intersection_points.shape[0], dtype=int)
    for j, (x, y) in enumerate(intersection_points):
        di = np.sqrt((x - x3) ** 2 + (y - y3) ** 2)
        if di <= r3:
            inside_points[j] = 1
    return inside_points

def AFMGRAVITY(GRAVFACT,AP,G,RHOP,RHOW,PI):
    '''SUBROUTINE GRAVITY
        GRAVITATIONAL FORCE - BECAUSE GRAVFACT IS READ AS -1 FOR CONCURRENT, +1 FOR COUNTERCURRENT FLOW, WE REVERSE THE SIGN BELOW TO REFLECT FLOW COMING FROM -Z DIRECTION'''
    FG = -GRAVFACT*(4.0/3.0)*(PI)*(AP**3)*(RHOP-RHOW)*G
    return FG

def AFMFORCELIFT(RHOW, R, AP, AG, VT, UT, OMEGA):
    ''' LIFT FORCE SUBROUTINE (NORMALIZED TO THE CLOSTEST SURFACE)
    (Yahiaoui & Feuillebois 2010)
    CONSIDER LIFT FORCE IF PARTICLE IS WITHIN 100 RADII OF THE SURFACE'''
    if (R - AG) <= (100.0 * AP):
        KS = VT / (R - AG)  # SHEAR RATE
        LNZAP = math.log((R - AG) / AP)
        LS = math.exp(2.221 + 1.565 * LNZAP + 0.06602 * LNZAP**2.0)  # LIFT FORCE ON FIXED SPHERE IN LINEAR SHEAR FLOW
        LR = math.exp(-1.0 * (0.6390 + 1.408 * LNZAP) / 
                      (1.0 - 0.1036 * LNZAP + 0.01136 * LNZAP**2.0))  # LIFT FORCE ON ROTATING SPHERE IN FLUID AT REST
        LT = (1.751 + 6.147 * LNZAP + 3.299 * LNZAP**2.0 - 2.485 * LNZAP**3.0 +
              1.952 * LNZAP**4.0) / (1.0 + 3.714 * LNZAP + 1.481 * LNZAP**2.0 -
              1.278 * LNZAP**3.0 + 1.0905 * LNZAP**4.0)  # LIFT FORCE ON TRANSLATING SPHERE IN FLUID AT REST
        LRT = -LNZAP * (10.97 + 439.4 * LNZAP + 355.0 * LNZAP**2.0 +
                        171.6 * LNZAP**3.0) / (1.0 + 7.309 * LNZAP + 284.7 * LNZAP**2.0 +
                        86.45 * LNZAP**3.0 + 77.45 * LNZAP**4.0)  # LIFT FORCE COUPLING TERM FOR ROTATING AND TRANSLATING SPHERE IN FLUID AT REST
        LSR = math.exp((-4.723 - 11.11 * LNZAP + 41.76 * LNZAP**2.0) /
                      (1.0 + 20.31 * LNZAP))  # LIFT FORCE COUPLING TERM FOR ROTATING SPHERE IN LINEAR SHEAR FLOW
        LST = (-10.76 - 2.158 * LNZAP - 4.218 * LNZAP**2.0) / (1.0 - 0.1749 * LNZAP)  # LIFT FORCE COUPLING TERM FOR TRANSLATING SPHERE IN LINEAR SHEAR FLOW

        FLIFT = RHOW * AP**2.0 * ((AP * KS)**2.0 * LS + (AP * OMEGA)**2.0 * LR +
                                  (UT)**2.0 * LT + (AP * OMEGA * UT) * LRT +
                                  (AP**2.0 * OMEGA * KS) * LSR + (AP * KS * UT) * LST)
    else:
        FLIFT = 0.0
    
    return FLIFT

def AFMFORCEDRAG (FUN2,FUN3,FUN4,M3,VN,VT):
    '''SUBROUTINE DRIVING DRAG FORCE
    CALCULATE DRAG FORCES (NORMAL AND TANGENTIAL TO COLLECTOR SURFACE).''' 
    FDRGN = FUN2*M3*VN
    FDRGT = FUN3/FUN4*M3*VT
    
    return FDRGN, FDRGT

def AFMFORCEDIFF(DIFFSCALE, PI, VISC, AP, KB, T, dT):
    '''SUBROUTINE DIFFUSION FORCE'''
    # Initialize random numbers to pass while condition below
    randm = np.full(3, 10.0)
    
    # Use only +-2 std from normal distribution
    for i in range(3):
        while randm[i] > 2 or randm[i] < -2:
            randm[i] = np.random.randn()  # Generate normal distribution random number

    # KIM AND ZYDNEY (2004) INDICATE FORMULAS USED IN 2D systems applied TO Z AND R AND ARE ADDITIVE 
    FDIFZ = DIFFSCALE * randm[0] * np.sqrt((12.0 * PI * AP * VISC * KB * T / dT))
    
    # DIFFUSION APPLIED IN 3DIMENSIONS
    FDIFX = DIFFSCALE * randm[1] * np.sqrt((12.0 * PI * AP * VISC * KB * T / dT))
    FDIFY = DIFFSCALE * randm[2] * np.sqrt((12.0 * PI * AP * VISC * KB * T / dT))
    
    return FDIFX, FDIFY, FDIFZ


def _rows_to_dataframe(rows):
    """Create a raw worksheet-like DataFrame without adding headers."""
    width = max(len(row) for row in rows)

    padded_rows = [
        list(row) + [None] * (width - len(row))
        for row in rows
    ]

    return pd.DataFrame(padded_rows)


def _build_force_sheet(h_vector, force_matrix, force_header):
    """Build a MATLAB-style force sheet using only calculated H values."""
    h_vector = np.asarray(h_vector, dtype=float).reshape(-1)
    force_matrix = np.asarray(force_matrix, dtype=float)

    if force_matrix.ndim == 1:
        force_matrix = force_matrix.reshape(-1, 1)

    number_of_points = h_vector.size

    if force_matrix.shape[0] < number_of_points:
        raise ValueError(
            "Force matrix contains fewer rows than H: "
            f"H={number_of_points}, "
            f"forces={force_matrix.shape[0]}"
        )

    # AFM_happel preallocates force arrays with MAXVAL=50000.
    # Only the first len(HVECTOR) rows contain calculated results.
    force_matrix = force_matrix[:number_of_points, :]

    number_of_probes = force_matrix.shape[1]

    header = [
        "H(m)",
        force_header,
        *([None] * max(0, number_of_probes - 1)),
    ]

    data = np.column_stack(
        (
            h_vector,
            force_matrix,
        )
    )

    return pd.DataFrame(
        [header] + data.tolist()
    )


def _build_hist_sheet(
    centers_bar,
    y_bar,
    centers_pri,
    y_pri,
):
    """Build the MATLAB Hist sheet."""
    arrays = [
        np.asarray(centers_bar).reshape(-1),
        np.asarray(y_bar).reshape(-1),
        np.asarray(centers_pri).reshape(-1),
        np.asarray(y_pri).reshape(-1),
    ]

    max_length = max((array.size for array in arrays), default=0)

    rows = [
        [
            "barrier_Force(N)",
            "Frecuency(#)",
            "minimum_Force(N)",
            "Frecuency(#)",
        ]
    ]

    for index in range(max_length):
        rows.append(
            [
                array[index] if index < array.size else None
                for array in arrays
            ]
        )

    return pd.DataFrame(rows)


def _build_raw_bar_min_sheet(
    bar_f_disc,
    h_bar_f_disc,
    lat1_bar_f_disc,
    lat2_bar_f_disc,
    pri_f_disc,
    h_pri_f_disc,
    lat1_pri_f_disc,
    lat2_pri_f_disc,
):
    """Build the MATLAB raw_Bar_Min_data sheet."""
    arrays = [
        np.asarray(bar_f_disc).reshape(-1),
        np.asarray(h_bar_f_disc).reshape(-1),
        np.asarray(lat1_bar_f_disc).reshape(-1),
        np.asarray(lat2_bar_f_disc).reshape(-1),
        np.asarray(pri_f_disc).reshape(-1),
        np.asarray(h_pri_f_disc).reshape(-1),
        np.asarray(lat1_pri_f_disc).reshape(-1),
        np.asarray(lat2_pri_f_disc).reshape(-1),
    ]

    max_length = max((array.size for array in arrays), default=0)

    rows = [
        [
            "barrier_Force(N)",
            "separation_distance(m)",
            "LAT1_location(m)",
            "LAT2_location(m)",
            "minimum_Force(N)",
            "separation_distance(m)",
            "LAT1_location(m)",
            "LAT2_location(m)",
        ]
    ]

    for index in range(max_length):
        rows.append(
            [
                array[index] if index < array.size else None
                for array in arrays
            ]
        )

    return pd.DataFrame(rows)


def _build_matrix_sheet(title, matrix):
    """Build a MATLAB-style sheet containing a raw 2D matrix."""
    matrix = np.asarray(matrix)

    if matrix.ndim == 1:
        matrix = matrix.reshape(1, -1)

    if matrix.ndim != 2:
        raise ValueError(
            f"{title} must contain a 1D or 2D array."
        )

    header = [title] + [None] * max(0, matrix.shape[1] - 1)

    return pd.DataFrame(
        [header] + matrix.tolist()
    )


def build_matlab_output_sheets(
    *,
    # General parameters
    NPART,
    RLIM,
    AP,
    RHOP,
    RHOW,
    VISC,
    ER,
    T,
    IS,
    ZI,
    ZETAPST,
    ZETACST,

    # Domain/probe heterogeneity
    ZETAHET,
    HETMODE,
    RHET0,
    RHET1,
    RHET2,
    SCOV,
    ZETAHETP,
    HETMODEP,
    RHETP0,
    RHETP1,
    SCOVP,

    # van der Waals / roughness
    A132,
    LAMBDAVDW,
    VDWMODE,
    B,
    RMODE,
    asperity_height,

    # Coated systems / non-DLVO / contact
    A11,
    AC1C1,
    A22,
    AC2C2,
    A33,
    T1,
    T2,
    GAMMA0AB,
    LAMBDAAB,
    GAMMA0STE,
    LAMBDASTE,
    KINT,
    W132,
    BETA,

    # Probe positions
    LAT1V,
    LAT2V,

    # Force outputs
    HVECTOR,
    FCOLLOT,
    FVDWOT,
    FEDLOT,
    FABOT,
    FSTEOT,
    FBORNOT,

    # # Histogram
    # centersBar,
    # Ybar,
    # centersPri,
    # Ypri,

    # # Raw barrier/minimum data
    # barFdisc,
    # HbarFdisc,
    # LAT1barFdisc,
    # LAT2barFdisc,
    # priFdisc,
    # HpriFdisc,
    # LAT1priFdisc,
    # LAT2priFdisc,

    # Heterodomain matrices
    mxhetPLOT,
    myhetPLOT,
    mrhetOUT,
):
    """
    Build in-memory worksheets matching MATLAB output_AFM.xlsx.

    The returned DataFrames already contain their MATLAB header rows.
    They must therefore be written with header=False and index=False.
    """

    # ------------------------------------------------------------------
    # Parameters sheet
    #
    # This deliberately reproduces MATLAB's current ordering.
    #
    # In the reference MATLAB file:
    #   Temperature(K)       contains ER
    #   Rel_permittivity(-)  contains T
    #
    # This is preserved here for direct MATLAB/Python comparison.
    # ------------------------------------------------------------------

    parameter_rows = [
        [
            "Locations_per_axis",
            "Domain_length(m)",
            "Probe_radius(m)",
            "Probe_density(kg/m3)",
            "Fluid_density(kg/m3)",
            "Fluid_viscosity(kg/m/s)",
            "Temperature(K)",
            "Rel_permittivity(-)",
            "Ionic_strength(mol/m3)",
            "Electrolyte_valence(-)",
            "Domain_z_potential(V)",
            "Probe_z_potential(V)",
        ],
        [
            NPART,
            RLIM,
            AP,
            RHOP,
            RHOW,
            VISC,

            # Same ordering currently produced by MATLAB.
            ER,
            T,

            IS,
            ZI,

            # Same ordering currently produced by MATLAB.
            ZETAPST,
            ZETACST,
        ],

        [
            "Domain_hetdomain_z_potential(V)",
            "Hetmode_domain(-)",
            "Domain_large_hetdomain_radius(m)",
            "Domain_medium_hetdomain_radius(m)",
            "Domain_small_hetdomain_radius(m)",
            "Domain_fractional_surface_coverage(-)",
            "Probe_hetdomain_z_potential(V)",
            "Hetmode_probe(-)",
            "Probe_large_hetdomain_radius(m)",
            "Probe_small_hetdomain_radius(m)",
            "Probe_fractional_surface_coverage(-)",
            "Combined_Hamaker_constant(J)",
            "van_der_Waals_decay_length(m)",
            "van_der_Waals_mode(-)",
            "Slip_length(m)",
            "Roughness_mode(-)",
            "Asperity_height(m)",
        ],
        [
            ZETAHET,
            HETMODE,

            # MATLAB output ordering.
            RHET1,
            RHET0,
            RHET2,

            SCOV,
            ZETAHETP,
            HETMODEP,
            RHETP0,
            RHETP1,
            SCOVP,
            A132,
            LAMBDAVDW,
            VDWMODE,
            B,
            RMODE,
            asperity_height,
        ],

        [
            "Probe_Hamaker_constant(J)",
            "Probe_Coating_Hamaker_constant(J)",
            "Domain_Hamaker_constant(J)",
            "Domain_coating_Hamaker_constant(J)",
            "Fluid_Hamaker_constant(J)",
            "Probe_Coating_thickness(m)",
            "Domain_Coating_thickness(m)",
            "Acid_base_energy_per_area(J/m2)",
            "Acid_base_decay_length(m)",
            "Steric_energy_per_area(J/m2)",
            "Steric_decay_length(m)",
            "Combined_elastic_modulus(N/m2)",
            "Work_of_adhesion(J/m2)",
            "Contact_radius_factor(-)",
        ],
        [
            A11,
            AC1C1,
            A22,
            AC2C2,
            A33,
            T1,
            T2,
            GAMMA0AB,
            LAMBDAAB,
            GAMMA0STE,
            LAMBDASTE,
            KINT,
            W132,
            BETA,
        ],

        [
            "X_probe_location(m)",
            *np.asarray(LAT1V).reshape(-1).tolist(),
        ],

        [
            "Y_probe_location(m)",
            *np.asarray(LAT2V).reshape(-1).tolist(),
        ],
    ]

    parameters_sheet = _rows_to_dataframe(parameter_rows)

    return {
        "Parameters": parameters_sheet,

        "FCOLL(N)": _build_force_sheet(
            HVECTOR,
            FCOLLOT,
            "FCollTotal(N)_each_column_represents_one_probe_location",
        ),

        "FVDW(N)": _build_force_sheet(
            HVECTOR,
            FVDWOT,
            "FvdW(N)_each_column_represents_one_probe_location",
        ),

        "FEDL(N)": _build_force_sheet(
            HVECTOR,
            FEDLOT,
            "Fedl(N)_each_column_represents_one_probe_location",
        ),

        "FAB(N)": _build_force_sheet(
            HVECTOR,
            FABOT,
            "Facid_base(N)_each_column_represents_one_probe_location",
        ),

        "FSTE(N)": _build_force_sheet(
            HVECTOR,
            FSTEOT,
            "Fsteric(N)_each_column_represents_one_probe_location",
        ),

        "FBORN(N)": _build_force_sheet(
            HVECTOR,
            FBORNOT,
            "FBorn(N)_each_column_represents_one_probe_location",
        ),

        # "Hist": _build_hist_sheet(
        #     centersBar,
        #     Ybar,
        #     centersPri,
        #     Ypri,
        # ),

        # "raw_Bar_Min_data": _build_raw_bar_min_sheet(
        #     barFdisc,
        #     HbarFdisc,
        #     LAT1barFdisc,
        #     LAT2barFdisc,
        #     priFdisc,
        #     HpriFdisc,
        #     LAT1priFdisc,
        #     LAT2priFdisc,
        # ),

        # Do NOT flatten these arrays.
        # MATLAB stores the complete 2D matrices.
        "hetXloc": _build_matrix_sheet(
            "Domain_Heterodomain_X_locations(m)",
            mxhetPLOT,
        ),

        "hetYloc": _build_matrix_sheet(
            "Domain_Heterodomain_Y_locations(m)",
            myhetPLOT,
        ),

        "hetRadii": _build_matrix_sheet(
            "Domain_Heterodomain_radii(m)",
            mrhetOUT,
        ),
    }


def create_folder(path, folder_name):
    """Create a clean output directory and return its full path."""
    full_path = Path(path) / folder_name

    if full_path.exists():
        print(
            f"The folder '{folder_name}' already exists in '{path}'."
        )
        shutil.rmtree(full_path)
        print(
            f"The existing folder '{folder_name}' was removed."
        )

    full_path.mkdir(parents=True, exist_ok=True)

    return full_path


def save_output(output_sheets, filename):
    """
    Save AFM output sheets as a valid MATLAB-compatible XLSX workbook.

    Parameters
    ----------
    output_sheets : dict[str, pandas.DataFrame]
        Dictionary where each key is an Excel sheet name.

    filename : str or pathlib.Path
        Destination .xlsx file.

    Returns
    -------
    pathlib.Path
        Path to the validated XLSX file.
    """
    filename = Path(filename)

    if filename.suffix.lower() != ".xlsx":
        raise ValueError(
            f"Output file must end in '.xlsx': {filename}"
        )

    filename.parent.mkdir(
        parents=True,
        exist_ok=True,
    )

    if filename.exists() and filename.is_dir():
        raise IsADirectoryError(
            f"The XLSX output path is a directory, not a file: "
            f"{filename}"
        )

    temp_file = filename.with_name(
        f"{filename.stem}_temp.xlsx"
    )

    if temp_file.exists():
        temp_file.unlink()

    try:
        with pd.ExcelWriter(
            temp_file,
            engine="openpyxl",
        ) as writer:
            for sheet_name, dataframe in output_sheets.items():
                if not isinstance(dataframe, pd.DataFrame):
                    raise TypeError(
                        f"Sheet {sheet_name!r} is not a DataFrame. "
                        f"Received {type(dataframe).__name__}."
                    )

                dataframe.to_excel(
                    writer,
                    sheet_name=sheet_name,
                    index=False,
                    header=False,
                )

        if not temp_file.exists():
            raise RuntimeError(
                f"Excel file was not created: {temp_file}"
            )

        file_size = temp_file.stat().st_size

        if file_size == 0:
            raise RuntimeError(
                f"Excel file was created but is empty: {temp_file}"
            )

        if not zipfile.is_zipfile(temp_file):
            raise RuntimeError(
                "The generated file is not a valid XLSX/ZIP file: "
                f"{temp_file}"
            )

        workbook = load_workbook(
            temp_file,
            read_only=True,
            data_only=True,
        )

        saved_sheets = workbook.sheetnames
        workbook.close()

        expected_sheets = list(output_sheets.keys())

        if saved_sheets != expected_sheets:
            raise RuntimeError(
                "Workbook sheet validation failed.\n"
                f"Expected: {expected_sheets}\n"
                f"Saved: {saved_sheets}"
            )

        if filename.exists():
            filename.unlink()

        temp_file.replace(filename)

    except Exception:
        if temp_file.exists():
            temp_file.unlink()

        raise

    print("\n--- EXCEL OUTPUT ---")
    print(f"File: {filename}")
    print(f"Size: {filename.stat().st_size:,} bytes")
    print(f"Valid XLSX: {zipfile.is_zipfile(filename)}")
    print(f"Sheets: {list(output_sheets.keys())}")
    print("--------------------\n")

    return filename


AFM_REQUIRED_INPUTS = {
    "NPART",
    "ATTMODE",
    "CLUSTER",
    "VJET",
    "RLIM",
    "POROSITY",
    "AG",
    "TTIME",
    "AP",
    "RHOP",
    "RHOW",
    "VISC",
    "ER",
    "T",
    "IS",
    "ZI",
    "ZETACST",
    "ZETAPST",
    "ZETAHET",
    "HETMODE",
    "RHET0",
    "RHET1",
    "RHET2",
    "SCOV",
    "ZETAHETP",
    "HETMODEP",
    "RHETP0",
    "RHETP1",
    "SCOVP",
    "A132",
    "LAMBDAVDW",
    "VDWMODE",
    "A11",
    "AC1C1",
    "A22",
    "AC2C2",
    "A33",
    "T1",
    "T2",
    "GAMMA0AB",
    "LAMBDAAB",
    "GAMMA0STE",
    "LAMBDASTE",
    "B",
    "RMODE",
    "ASPcolloid",
    "ASPdomain",
    "ASP2",
    "KINT",
    "W132",
    "BETA",
    "DIFFSCALE",
    "GRAVFACT",
    "MULTB",
    "MULTNS",
    "MULTC",
    "DFACTNS",
    "DFACTC",
    "NOUT",
    "PRINTMAX",
    "cbPZ",
    "cbMZ",
    "cbPX",
    "cbMX",
    "workdir",
}


def normalize_file_path(file_path: str | Path) -> Path:
    """Normalize a file path entered manually by the user."""
    if isinstance(file_path, Path):
        return file_path.expanduser()

    cleaned_path = str(file_path).strip()

    if (
        len(cleaned_path) >= 2
        and cleaned_path[0] in {'"', "'"}
        and cleaned_path[-1] == cleaned_path[0]
    ):
        cleaned_path = cleaned_path[1:-1].strip()

    return Path(cleaned_path).expanduser()


def import_parameters(
    filename: str | Path,
    sheet_name: str = "Parameters",
) -> dict:
    """Read AFM parameters from the MATLAB Parameters worksheet."""
    filename = normalize_file_path(filename)

    if not filename.exists():
        raise FileNotFoundError(
            f"AFM file not found: {filename}"
        )

    try:
        dataframe = pd.read_excel(
            filename,
            sheet_name=sheet_name,
            header=None,
            engine="openpyxl",
        )
    except ValueError as exc:
        raise ValueError(
            f"Sheet {sheet_name!r} was not found in "
            f"{filename.name!r}."
        ) from exc

    if dataframe.shape[0] < 6:
        raise ValueError(
            "The Parameters sheet does not contain "
            "the expected six parameter rows."
        )

    parameters = {}

    row_pairs = (
        (0, 1),
        (2, 3),
        (4, 5),
    )

    for header_row, value_row in row_pairs:
        headers = dataframe.iloc[header_row]
        values = dataframe.iloc[value_row]

        for header, value in zip(headers, values):
            if pd.isna(header):
                continue

            parameter_name = str(header).strip()

            if pd.isna(value):
                parameters[parameter_name] = None
            elif isinstance(value, np.generic):
                parameters[parameter_name] = value.item()
            else:
                parameters[parameter_name] = value

    return parameters


def _input_parameter(parameters, name):
    """Return a required AFM parameter."""
    if name not in parameters:
        raise KeyError(
            f"AFM parameter {name!r} was not found."
        )

    value = parameters[name]

    if value is None:
        raise ValueError(
            f"AFM parameter {name!r} has no value."
        )

    return value


def _afm_optional_parameter(
    parameters,
    name,
    default=None,
):
    """Return an optional AFM parameter."""
    value = parameters.get(name)

    if value is None:
        return default

    return value


def _apply_asperity_height(
    dict_input,
    asperity_height,
):
    """
    RMODE 1: colloid asperities
    RMODE 2: collector/domain asperities
    RMODE 3: asperities on both surfaces
    """
    rmode = int(dict_input["RMODE"])

    if asperity_height is None:
        return

    asperity_height = float(asperity_height)

    if rmode == 0:
        return

    if rmode == 1:
        dict_input["ASPcolloid"] = asperity_height
        return

    if rmode == 2:
        dict_input["ASPdomain"] = asperity_height
        return

    if rmode == 3:
        dict_input["ASPcolloid"] = asperity_height
        dict_input["ASPdomain"] = asperity_height
        return

    raise ValueError(
        f"Unsupported RMODE imported from AFM file: {rmode}"
    )


def file_parameters_to_afm_inputs(
    parameters,
    base_inputs,
):
    """
    Convert AFM Parameters into AFM_happel keyword arguments.

    Parameters not present in the AFM output are preserved from
    base_inputs.

    The mapping intentionally reproduces the current AFM output,
    including the known ER/T and zeta-potential header ordering.

    Parameters
    ----------
    parameters : dict
        Output of import_input_parameters().

    base_inputs : dict
        Existing valid AFM_happel input dictionary. Values stored in
        AFM file replace the corresponding values in this dictionary.

    Returns
    -------
    dict
        Dictionary ready for AFM_happel(**dict_input).
    """
    dict_input = dict(base_inputs)

    # General simulation / material parameters.
    dict_input["NPART"] = int(
        _input_parameter(
            parameters,
            "Locations_per_axis",
        )
    )

    dict_input["RLIM"] = float(
        _input_parameter(
            parameters,
            "Domain_length(m)",
        )
    )

    dict_input["AP"] = float(
        _input_parameter(
            parameters,
            "Probe_radius(m)",
        )
    )

    dict_input["RHOP"] = float(
        _input_parameter(
            parameters,
            "Probe_density(kg/m3)",
        )
    )

    dict_input["RHOW"] = float(
        _input_parameter(
            parameters,
            "Fluid_density(kg/m3)",
        )
    )

    dict_input["VISC"] = float(
        _input_parameter(
            parameters,
            "Fluid_viscosity(kg/m/s)",
        )
    )

    # AFM currently writes ER under Temperature(K)
    # and T under Rel_permittivity(-).
    dict_input["ER"] = float(
        _input_parameter(
            parameters,
            "Temperature(K)",
        )
    )

    dict_input["T"] = float(
        _input_parameter(
            parameters,
            "Rel_permittivity(-)",
        )
    )

    dict_input["IS"] = float(
        _input_parameter(
            parameters,
            "Ionic_strength(mol/m3)",
        )
    )

    dict_input["ZI"] = float(
        _input_parameter(
            parameters,
            "Electrolyte_valence(-)",
        )
    )

    # AFM currently writes ZETAPST under Domain_z_potential
    # and ZETACST under Probe_z_potential.
    dict_input["ZETAPST"] = float(
        _input_parameter(
            parameters,
            "Domain_z_potential(V)",
        )
    )

    dict_input["ZETACST"] = float(
        _input_parameter(
            parameters,
            "Probe_z_potential(V)",
        )
    )

    # Domain heterogeneity.
    dict_input["ZETAHET"] = float(
        _input_parameter(
            parameters,
            "Domain_hetdomain_z_potential(V)",
        )
    )

    dict_input["HETMODE"] = int(
        _input_parameter(
            parameters,
            "Hetmode_domain(-)",
        )
    )

    # Preserve AFM's current RHET0/RHET1 output ordering.
    dict_input["RHET1"] = float(
        _input_parameter(
            parameters,
            "Domain_large_hetdomain_radius(m)",
        )
    )

    dict_input["RHET0"] = float(
        _input_parameter(
            parameters,
            "Domain_medium_hetdomain_radius(m)",
        )
    )

    dict_input["RHET2"] = float(
        _input_parameter(
            parameters,
            "Domain_small_hetdomain_radius(m)",
        )
    )

    dict_input["SCOV"] = float(
        _input_parameter(
            parameters,
            "Domain_fractional_surface_coverage(-)",
        )
    )

    # Probe heterogeneity.
    dict_input["ZETAHETP"] = float(
        _input_parameter(
            parameters,
            "Probe_hetdomain_z_potential(V)",
        )
    )

    dict_input["HETMODEP"] = int(
        _input_parameter(
            parameters,
            "Hetmode_probe(-)",
        )
    )

    dict_input["RHETP0"] = float(
        _input_parameter(
            parameters,
            "Probe_large_hetdomain_radius(m)",
        )
    )

    dict_input["RHETP1"] = float(
        _input_parameter(
            parameters,
            "Probe_small_hetdomain_radius(m)",
        )
    )

    dict_input["SCOVP"] = float(
        _input_parameter(
            parameters,
            "Probe_fractional_surface_coverage(-)",
        )
    )

    # van der Waals.
    dict_input["A132"] = float(
        _input_parameter(
            parameters,
            "Combined_Hamaker_constant(J)",
        )
    )

    dict_input["LAMBDAVDW"] = float(
        _input_parameter(
            parameters,
            "van_der_Waals_decay_length(m)",
        )
    )

    dict_input["VDWMODE"] = int(
        _input_parameter(
            parameters,
            "van_der_Waals_mode(-)",
        )
    )

    # Roughness.
    dict_input["B"] = float(
        _input_parameter(
            parameters,
            "Slip_length(m)",
        )
    )

    dict_input["RMODE"] = int(
        _input_parameter(
            parameters,
            "Roughness_mode(-)",
        )
    )

    asperity_height = _afm_optional_parameter(
        parameters,
        "Asperity_height(m)",
    )

    _apply_asperity_height(
        dict_input,
        asperity_height,
    )

    # Coated systems.
    dict_input["A11"] = float(
        _input_parameter(
            parameters,
            "Probe_Hamaker_constant(J)",
        )
    )

    dict_input["AC1C1"] = float(
        _input_parameter(
            parameters,
            "Probe_Coating_Hamaker_constant(J)",
        )
    )

    dict_input["A22"] = float(
        _input_parameter(
            parameters,
            "Domain_Hamaker_constant(J)",
        )
    )

    dict_input["AC2C2"] = float(
        _input_parameter(
            parameters,
            "Domain_coating_Hamaker_constant(J)",
        )
    )

    dict_input["A33"] = float(
        _input_parameter(
            parameters,
            "Fluid_Hamaker_constant(J)",
        )
    )

    dict_input["T1"] = float(
        _input_parameter(
            parameters,
            "Probe_Coating_thickness(m)",
        )
    )

    dict_input["T2"] = float(
        _input_parameter(
            parameters,
            "Domain_Coating_thickness(m)",
        )
    )

    # Acid-base and steric interactions.
    dict_input["GAMMA0AB"] = float(
        _input_parameter(
            parameters,
            "Acid_base_energy_per_area(J/m2)",
        )
    )

    dict_input["LAMBDAAB"] = float(
        _input_parameter(
            parameters,
            "Acid_base_decay_length(m)",
        )
    )

    dict_input["GAMMA0STE"] = float(
        _input_parameter(
            parameters,
            "Steric_energy_per_area(J/m2)",
        )
    )

    dict_input["LAMBDASTE"] = float(
        _input_parameter(
            parameters,
            "Steric_decay_length(m)",
        )
    )

    # Contact / deformation.
    dict_input["KINT"] = float(
        _input_parameter(
            parameters,
            "Combined_elastic_modulus(N/m2)",
        )
    )

    dict_input["W132"] = float(
        _input_parameter(
            parameters,
            "Work_of_adhesion(J/m2)",
        )
    )

    dict_input["BETA"] = float(
        _input_parameter(
            parameters,
            "Contact_radius_factor(-)",
        )
    )

    # AFM_happel currently derives ASP2 from B internally.
    dict_input["ASP2"] = dict_input["B"] / 2.0

    missing = sorted(
        AFM_REQUIRED_INPUTS.difference(dict_input)
    )

    if missing:
        raise ValueError(
            "base_inputs is missing parameters required by "
            "AFM_happel(): "
            + ", ".join(missing)
        )

    return dict_input


def import_afm_inputs(
    filename,
    base_inputs,
    sheet_name="Parameters",
):
    """
    Read an AFM file and return AFM_happel inputs directly.
    """
    parameters = import_parameters(
        filename,
        sheet_name=sheet_name,
    )

    return file_parameters_to_afm_inputs(
        parameters,
        base_inputs,
    )


def add_analysis_output_sheets(
    output_sheets: dict,
    analysis: dict,
) -> dict:
    """Add MATLAB-compatible histogram and extrema sheets."""

    required_keys = (
        "centers_barrier",
        "barrier_counts",
        "centers_primary",
        "primary_counts",
        "barrier_force",
        "barrier_distance",
        "barrier_x",
        "barrier_y",
        "primary_force",
        "primary_distance",
        "primary_x",
        "primary_y",
    )

    missing_keys = [
        key
        for key in required_keys
        if key not in analysis
    ]

    if missing_keys:
        raise KeyError(
            "Missing analysis values: "
            + ", ".join(missing_keys)
        )

    # --------------------------------------------------------
    # Hist
    #
    # Barrier and primary-minimum histograms can legitimately
    # have different lengths when one of them is not detected.
    # Pandas aligns the columns and writes missing values as
    # blank Excel cells.
    # --------------------------------------------------------

    hist_header = pd.DataFrame(
        [[
            "barrier_Force(N)",
            "Frecuency(#)",
            "minimum_Force(N)",
            "Frecuency(#)",
        ]]
    )

    hist_data = pd.concat(
        [
            pd.Series(
                np.asarray(
                    analysis["centers_barrier"],
                    dtype=float,
                ).reshape(-1)
            ),
            pd.Series(
                np.asarray(
                    analysis["barrier_counts"],
                    dtype=float,
                ).reshape(-1)
            ),
            pd.Series(
                np.asarray(
                    analysis["centers_primary"],
                    dtype=float,
                ).reshape(-1)
            ),
            pd.Series(
                np.asarray(
                    analysis["primary_counts"],
                    dtype=float,
                ).reshape(-1)
            ),
        ],
        axis=1,
        ignore_index=True,
    )

    output_sheets["Hist"] = pd.concat(
        [
            hist_header,
            hist_data,
        ],
        axis=0,
        ignore_index=True,
    )

    # --------------------------------------------------------
    # raw_Bar_Min_data
    #
    # Keep this robust too in case one extrema type is absent.
    # --------------------------------------------------------

    raw_header = pd.DataFrame(
        [[
            "barrier_Force(N)",
            "separation_distance(m)",
            "LAT1_location(m)",
            "LAT2_location(m)",
            "minimum_Force(N)",
            "separation_distance(m)",
            "LAT1_location(m)",
            "LAT2_location(m)",
        ]]
    )

    raw_data = pd.concat(
        [
            pd.Series(
                np.asarray(
                    analysis["barrier_force"],
                    dtype=float,
                ).reshape(-1)
            ),
            pd.Series(
                np.asarray(
                    analysis["barrier_distance"],
                    dtype=float,
                ).reshape(-1)
            ),
            pd.Series(
                np.asarray(
                    analysis["barrier_x"],
                    dtype=float,
                ).reshape(-1)
            ),
            pd.Series(
                np.asarray(
                    analysis["barrier_y"],
                    dtype=float,
                ).reshape(-1)
            ),
            pd.Series(
                np.asarray(
                    analysis["primary_force"],
                    dtype=float,
                ).reshape(-1)
            ),
            pd.Series(
                np.asarray(
                    analysis["primary_distance"],
                    dtype=float,
                ).reshape(-1)
            ),
            pd.Series(
                np.asarray(
                    analysis["primary_x"],
                    dtype=float,
                ).reshape(-1)
            ),
            pd.Series(
                np.asarray(
                    analysis["primary_y"],
                    dtype=float,
                ).reshape(-1)
            ),
        ],
        axis=1,
        ignore_index=True,
    )

    output_sheets["raw_Bar_Min_data"] = pd.concat(
        [
            raw_header,
            raw_data,
        ],
        axis=0,
        ignore_index=True,
    )

    return output_sheets
