from pathlib import Path
import numpy as np
import matplotlib.pyplot as plt
import time
import AFM_functions as af
import AFM_plotting as afm_plot

def get_default_inputs(
    workdir: str | Path | None = None,
    ) -> dict[str, object]:
    """Return the default AFM simulation input parameters."""

    return {
        "workdir": workdir,

        # Simulation parameters
        "NPART": 20,
        "ATTMODE": 1,
        "CLUSTER": 0,

        # Flow and simulation geometry
        "VJET": 1.62e-3,
        "RLIM": 1.0e-5,
        "POROSITY": 0.35,
        "AG": 2.55e-4,
        "TTIME": 5000,

        # Colloid and fluid properties
        "AP": 5.0e-7,
        "RHOP": 1050.0,
        "RHOW": 998.0,
        "VISC": 9.98e-4,
        "ER": 80.0,
        "T": 293.2,

        # Mean-field potentials
        "IS": 6.0,
        "ZI": 1.0,
        "ZETACST": -0.065,
        "ZETAPST": -0.065,

        # Collector heterogeneity
        "ZETAHET": 0.065,
        "HETMODE": 1,
        "RHET0": 0.0,
        "RHET1": 0.0,
        "RHET2": 0.0,
        "SCOV": 0.0,

        # Probe heterogeneity
        "ZETAHETP": 0.065,
        "HETMODEP": 1,
        "RHETP0": 0.0,
        "RHETP1": 0.0,
        "SCOVP": 0.0,

        # van der Waals
        "A132": 7.18e-21,
        "LAMBDAVDW": 1.0e-7,
        "VDWMODE": 1,

        # Coated systems
        "A11": 0.0,
        "AC1C1": 0.0,
        "A22": 0.0,
        "AC2C2": 0.0,
        "A33": 0.0,
        "T1": 0.0,
        "T2": 0.0,

        # Lewis acid-base and steric hydration
        "GAMMA0AB": -2.7e-2,
        "LAMBDAAB": 6.0e-10,
        "GAMMA0STE": 0.017,
        "LAMBDASTE": 4.1e-10,

        # Roughness
        "B": 0.0,
        "RMODE": 0,
        "ASPcolloid": 0.0,
        "ASPdomain": 0.0,
        "ASP2": 0.0,

        # Deformation
        "KINT": 4.36e9,
        "W132": -2.9e-2,
        "BETA": 0.5,

        # Diffusion and gravity
        "DIFFSCALE": 0.0,
        "GRAVFACT": 1.0,

        # Time-step multipliers
        "MULTB": 100.0,
        "MULTNS": 2.0,
        "MULTC": 0.01,
        "DFACTNS": 1.0e-3,
        "DFACTC": 1.0e-1,

        # Output
        "NOUT": 250,
        "PRINTMAX": 10000,

        # Gravity alignment
        "cbPZ": 0,
        "cbMZ": 1,
        "cbPX": 0,
        "cbMX": 0,
    }

def AFM_happel(**kwargs):
    # PROGRAM TO SIMULATE PARTICLE TRAJECTORIES IN HAPPEL CELL GEOMETRY

    # for the progress bar
    progress_callback = kwargs.pop(
        "progress_callback",
        None,
    )

    if (
        progress_callback is not None
        and not callable(progress_callback)
    ):
        raise TypeError(
            "progress_callback must be callable or None."
        )

    if progress_callback is not None:
        progress_callback(0.0)

    last_progress_percent = -1


    # set switch to single calc for afract for heterogeneity
    # single_afract = 1 single calculation calculation of afract entering near
    # surface
    # single_afract = 0 calculation of afract on every translation on near
    # surface
    # works in combination with variable het_afract_calculated, to indicate
    # that one calculaton of afract was performed in the trajecotry loop
    # do not delete single_afract or het_afract_calculated
    single_afract = 1

    # Get variables
    # Simulation parameters (integer values)
    NPART = kwargs.get('NPART')  # Number of colloids simulated
    ATTMODE = kwargs.get('ATTMODE')  # Perfect sink(0) or Contact(1) mode
    CLUSTER = kwargs.get('CLUSTER')  # Cluster mode (0 or 1)
    # Flow and simulation geometry parameters
    VJET = kwargs.get('VJET')  # Superficial velocity (m/s)
    RLIM = kwargs.get('RLIM')  # Injection radius (m)
    POROSITY = kwargs.get('POROSITY')  # Happel porosity
    AG = kwargs.get('AG')  # Grain radius (m)
    TTIME = kwargs.get('TTIME')  # Total Simulation Time (s)
    # Colloid and fluid properties (default = CML-water-silica @ pH 6.7, IS 6mM)
    AP = kwargs.get('AP')  # Colloid radius (m)
    RHOP = kwargs.get('RHOP')  # Colloid density (kg/m3)
    RHOW = kwargs.get('RHOW')  # Fluid density (kg/m3)
    VISC = kwargs.get('VISC')  # Fluid viscosity (kg/m/s)
    ER = kwargs.get('ER')  # Rel. permittivity (-)
    T = kwargs.get('T')  # Temperature (K)
    # Mean field potentials
    IS = kwargs.get('IS')  # Ionic strength (mol/m3)
    ZI = kwargs.get('ZI')  # Electrolyte valence (-)
    ZETACST = kwargs.get('ZETACST')  # Collector z-potential (V)
    ZETAPST = kwargs.get('ZETAPST')  # Colloid z-potential (V)
    # Collector heterogeneity parameters
    ZETAHET = kwargs.get('ZETAHET')  # Hetdomain z-potential (V)
    HETMODE = kwargs.get('HETMODE')  # Hetmode1,5,9,73       
    RHET0 = kwargs.get('RHET0')  # Large hetdomain radius (m)     
    RHET1 = kwargs.get('RHET1')  # Medium hetdomain radius (m)
    RHET2 = kwargs.get('RHET2')  # Small hetdomain radius (m)
    SCOV = kwargs.get('SCOV')  # Fractional surface coverage
    # Colloid heterogeneity parameters.
    ZETAHETP = kwargs.get('ZETAHETP')  # Hetdomain z-potential (V)
    HETMODEP = kwargs.get('HETMODEP')  # Hetmode (1 or 5)
    RHETP0 = kwargs.get('RHETP0')  # Large hetdomain radius (m) 
    RHETP1 = kwargs.get('RHETP1')  # Small hetdomain radius (m)
    SCOVP = kwargs.get('SCOVP')  # Fractional surface coverage
    # van der Waals force parameters
    A132 = kwargs.get('A132')  # Combined Hamaker constant (J)
    LAMBDAVDW = kwargs.get('LAMBDAVDW')  # van der Waals decay length (m)
    VDWMODE = kwargs.get('VDWMODE')  # van der Waals mode (1, 2, 3 or 4)
    # van der Waals force parameters - Coated systems
    A11 = kwargs.get('A11')  # Colloid Hamaker cst. (J)
    AC1C1 = kwargs.get('AC1C1')  # Colloid coating H. cst. (J)
    A22 = kwargs.get('A22')  # Collector Hamaker cst. (J)
    AC2C2 = kwargs.get('AC2C2')  # Collector coating H. cst. (J)
    A33 = kwargs.get('A33')  # Fluid Hamaker cst. (J)
    T1 = kwargs.get('T1')  # Colloid coating thickness (m)
    T2 = kwargs.get('T2')  # Collector coating thickness (m)
    # Lewis acid-base and steric hydration force parameters
    GAMMA0AB = kwargs.get('GAMMA0AB')  # Acid-base energy per area (J/m2)
    LAMBDAAB = kwargs.get('LAMBDAAB')  # Acid-base decay length (m)
    GAMMA0STE = kwargs.get('GAMMA0STE')  # Steric energy per area (J/m2)
    LAMBDASTE = kwargs.get('LAMBDASTE')  # Steric decay length (m)
    # Roughness parameters# Single(0) or Parallel(1) simulation
    B = kwargs.get('B')  # Slip length (m)   
    RMODE = kwargs.get('RMODE')  # Roughness mode(0,1,2 or 3)
    ASPcolloid = kwargs.get('ASPcolloid')  # Asperity height (m) Modes 1  2  3 
    ASPdomain = kwargs.get('ASPdomain')  # Asperity height (m) Modes 1  2  3     
    ASP2 = kwargs.get('ASP2')  # Asperity height (m) Modes 1  2  3  
    # Deformation parameters
    KINT = kwargs.get('KINT')  # Combined elastic modulus (N/m2)
    W132 = kwargs.get('W132')  # Work of adhesion (J/m2)
    BETA = kwargs.get('BETA')  # Contact radius factor (-)
    # Diffusion and Gravity factors
    DIFFSCALE = kwargs.get('DIFFSCALE')  # Multiplier of diffusion force (-)
    GRAVFACT = kwargs.get('GRAVFACT')  # Multiplier of gravity force (-)
    # Simulation time step and Slow motion parameters
    MULTB = kwargs.get('MULTB')  # Bulk time muliplier (-)
    MULTNS = kwargs.get('MULTNS')  # Near surface  time multipier (-)
    MULTC = kwargs.get('MULTC')  # Contact time multiplier (-)
    DFACTNS = kwargs.get('DFACTNS')  # Near-surface displacement factor (-)
    DFACTC = kwargs.get('DFACTC')  # Contact displacement factor (-)
    # Output parameters (integer values)
    NOUT = kwargs.get('NOUT')  # Output interval factor
    PRINTMAX = kwargs.get('PRINTMAX')  # Maximum output array length
    # Gravity alignment
    cbPZ = kwargs.get('cbPZ')  # +Z
    cbMZ = kwargs.get('cbMZ')  # -Z
    cbPX = kwargs.get('cbPX')  # +X
    cbMX = kwargs.get('cbMX')  # -X
    # Enable simultaneous plots
    workdir = kwargs.get('workdir')  # Output folder

    ## factor to limit aspetities contributions based on H threshold
    # Hthreshold = 1/LTLT*ASP ( asperity on collector or domain)
    # LTLT represents the threshold factor between H and a (where a equals the
    # smaller radius among AP AG and ASP)
    LTLT = 1

    # save asperity arrays if there are not too many
    asp_max_number = 100

    # Initialize etas and eta counters
    '''global eta2, eta4, eta5, eta6, RB'''
    ceta2 = 0
    ceta4 = 0
    ceta5 = 0
    ceta6 = 0


    # Set maximum number of values per vector
    MAXVAL = 50000  # Maximum number of values in arrays

    # DEFINE OTHER VARIABLES (FLOAT)
    X = 0.0

    Y = Z = H = R = XO = YO = ZO = HO = Xm0 = Ym0 = Zm0 = JX = JY = X   # SPATIAL COORDINATES
    XINIT = YINIT = ZINIT = HINIT = RINJ = RJET = ZMAX = X  # INITIAL COORDINATES
    ETX = ETY = ETZ = ENX = ENY = ENZ = X  # TANGENTIAL AND NORMAL UNIT VECTORS
    FCOLL = FVDW = FEDL = FAB = FSTE = FBORN = X  # FORCES
    MP = NIO = KAPPA = ZETAC = ERE0 = X  # MASS AND EDL PARAMETERS
    RZOI = RZOIBULK = RZOICONT = X  # ZONE OF INFLUENCE
    FDRGX = FDRGY = FDRGZ = FDRGR = X  # DRAG FORCES
    FDIFX = FDIFY = FDIFZ = X   # DIFFUSION FORCES
    FDifT = FDifTX = FDifTY = FDifTZ = X# DIFFUSION TANGENTIAL FORCES
    FDifN = FDifNX = FDifNY = FDifNZ = X  # DIFFUSION NORMAL FORCES
    FLifT = FLifTX = FLifTY = FLifTZ = X  # LIFT FORCE
    FG = FGN = FGNX = FGNY = FGNZ = FGTX = FGTY = FGTZ = X   # GRAVITY FORCE    
    dTMRT = dT = TBULK = TNEAR = TFRIC = X  # TIME
    TINJ = PTIMEF = ETIME = X  # SIMULATION TIME
    VxH1 = VyH1 = VzH1 = VX = VY = VZ = VT = VN = X  # FLUID VELOCITIES
    VTX = VTY = VTZ = VNX = VNY = VNZ = X  # TANGENTIAL AND NORMAL
    UX = UXO = UY = UYO = UZ = UZO = UT = UTO = UN = OMEGA = X  # COLLOID VELOCITIES
    UTX = UTXO = UTY = UTYO = UTZ = UTZO = X  # COLLOID TANGENTIAL VELOCITIES
    UNX = UNXO = UNY = UNYO = UNZ = UNZO = X  # COLLOID NORMAL VELOCITIES
    PP = WW = K1 = K2 = K3 = K4 = RB = SHELL = X  # HAPPEL POROSITY AND FLOW FIELD PARAMETERS
    # [VX,VY,VZ,VR,UX,UXO,UY,UYO,UR,UZ,UZO,OMEGA]=deal(X)  #VELOCITIES JET
    # [c2R,p0R,q1R,q2R,q3R,q4R]=deal(X)                    #CONTINUUM JET FLOW FIELD PARAMETERS
    # [c2Z,p0Z,q1Z,q2Z,q3Z,q4Z]=deal(X)                    #CONTINUUM JET FLOW FIELD PARAMETERS
    # HYDRODYNAMIC RETARDATION
    VM = HBAR = M3 = M4 = M5 = X  # HYDRODYNAMIC RETARDATION
    A1 = B1 = C1 = D1 = E1 = A2 = B2 = C2 = D2 = E2 = A3 = B3 = C3 = D3 = E3 = X  # HYDRODYNAMIC RETARDATION
    A4 = B4 = C4 = D4 = E4 = FUN1 = FUN2 = FUN3 = FUN4 = X  # HYDRODYNAMIC RETARDATION
    FCOLLO = HFRIC = HMIN = FMIN = X  # CONTACT SEPARATION DISTANCE VARIABLES
    ACONT = CORF = FCOLFRIC = ASTE = X   # DEFORMATION VARIABLES
    XREF1 = YREF1 = ZREF1 = TREF1 = DREF1 = DIND1 = X   # SLOW MOTION IN NEAR SURFACE 
    XREF2 = YREF2 = ZREF2 = TREF2 = DREF2 = DIND2 = DIND3 = X  # SLOW MOTION IN CONTACT
    XP = YP = ZP = AFRACT = AF = X  # HETERODOMAIN PARAMETERS
    FEDLCST = FEDLHET = X  # EDL PARAMETERS
    MOB = X  # DETACHMENT PARAMETER
    EVDW = EEDL = X  # DLVO ENERGY
    PI = G = E0 = ECHG = KB = H0 = SIGMAC = DELTASEP = X  # CONSTANTS
    ROXY = RTSUM = RSUM = TSQSUM = TSUM = HSUM = NSVEL = HAVE = X  # AVERAGE NS VELOCITY AND SEP DISTANCE
    RARC = RARC1 = THETA = THETAINIT = PHI = PHIINIT = X  # ARCLENGTH CALCULATION

    # DEFINE OTHER VARIABLES (STRINGS)
    # DUMMY = 'dummy'
    # FILESINGLE = 'filename'

    # DEFINE OTHER VARIABLES (INTEGERS)
    I = np.int16(0)

    J = K = N = L = IO = I  # LOOP PARAMETERS
    PCOUNT = OUTCOUNT = OUTMAX = OUTFLAG = NPRINT = I  # OUTPUT FILE PARAMETERS
    ATTACHK = HFLAG = NSVISIT = FRICVISIT = I  # PARTICLE INDICATORS 
    IREF1 = IREF2 = HETTYPE = NPARTLOOP = I  # MISCELLANEOUS PARAMETERS  
    nrand = RMULT = I  # RANDOM NUMBER PARAMETERS

    #   DEFINE PHYSICAL CONSTANTS
    PI=3.14159265359          #PIE (CHERRY,STRAWBERRY RHUBARB, ETC.)
    G=9.80665                 #ACCELERATION DUE TO GRAVITY (M/S**2)
    E0=8.85418781762E-12      #VACUUM PERMITTIVITY (C**2/N M**2)
    ECHG=1.602176621E-19      #ELEMENTARY CHARGE (C)
    KB=1.3806485E-23          #BOLTZMANN CONSTANT (J/K)

    # Define hardwired values (not read from the input file)
    H0 = 0.158E-9  # Minimum separation distance (m)
    SIGMAC = 5.0E-10  # Born collision diameter (m)
    DELTASEP = 5.0E-10  # Buffer outward from H0 (m)
    OUTMAX = PRINTMAX  # Largest output array length

    # The max asperity height defines the slip length (B).
    # In torque balances, the max asperity height was important only for detachment
    # wherein it increases the arresting torque lever arm.
    # Approximate collector max surface roughness as B/2. Need to update to
    # allow either or both surfaces to contribute coarse roughness.
    ASP2 = B/2
    # CALCULATE ADHESIVE TORQUE LEVER ARM
    RLEV = AP*ASP2/(AP+ASP2)

    # hardwire AG  for AFM mode as a 10**9 factor of AP
    AG = 1e9*AP
    # other hardwire parameters
    NOUT = 5000
    simplot = 0
    detplot = 0
    VJET = 0.0
    GRAVFACT = 1.0
    cbMZ = 1.0
    cbPZ = 0.0
    cbMX = 0.0
    cbPX = 0.0
    DIFFSCALE = 1.35
    MULTB = 1.0
    MULTNS = 1.0
    MULTC = 1.0
    ATTMODE = 1.0

    # # CHECK superficial velocity sign (read as VJET from main GUI code)
    # model is set for -Z flow direction
    if VJET>0.0:
        VSUP = VJET
    else:
        VSUP = -VJET

    # INITIALIZE RANDOM NUMBER GENERATOR SEED (for rand and randn) injection and diffusion calcs
    #    If a non common seed  is requiered, make seed depent
    #    of machine clock different results per execution ( for parallel
    #    version this seed may need to be initialized inside particle loop and
    #    include particle number+clock in seed)
    # 
    #  initializae seed based on clock
    np.random.seed(None)  

    ## Surface colors based on charge
    # set collector color based on charge sign
    if ZETACST < 0.0:
        collecolor = 'r'
    else:
        collecolor = 'g'

    # set colloid color based on charge sign
    if ZETAPST < 0.0:
        colcolor = [0.9290, 0.6940, 0.1250]
    else:
        colcolor = 'b'

    # display trajectory info during runtime
    # set showout to 1 to display during simulation info matchin output interval
    # set showout to 0 (default) to avoid display and speed up code
    showout = 0

    # SET CENTER OF COLLECTOR
    Xm0, Ym0, Zm0 = 0.0, 0.0, 0.0
    # SET NULL HETTYPE 0=NONE, 1=LARGE, 2=SMALL, 3=BOTH
    HETTYPE = 0
    # SET NULL HETFLAG, 0=NOT OVER HETERODOMAIN, 1=PASSED OVER HETERODOMAIN
    HETFLAG = 0
    # Calculate mass of particle
    MP = (4.0 / 3.0) * (PI) * (AP ** 3) * RHOP
    # Calculate momentum relaxation time
    dTMRT = MP / (6.0 * PI * VISC * AP)
    # Set time step
    dT = MULTB * dTMRT
    # Set virtual mass coefficient
    VM = (2.0 / 3.0) * PI * (AP ** 3) * RHOW
    # Set torque and drag force coefficient
    M3 = 6.0 * PI * VISC * AP
    # Calculate Happel sphere-in-cell model streamline parameters (from Rajagopalan & Tien, 1976)
    # PP = (1 - POROSITY) ** (1.0 / 3.0)
    # WW = 2.0 - 3.0 * PP + 3.0 * PP ** 5.0 - 2.0 * PP ** 6.0
    # K1 = 1 / WW
    # K2 = -(3.0 + 2.0 * PP ** 5.0) / WW
    # K3 = (2.0 + 3.0 * PP ** 5.0) / WW
    # K4 = -PP ** 5.0 / WW
    # Fluid shell radius
    RB = AG / ((1 - POROSITY) ** (1.0 / 3.0))
    # # Fluid shell thickness
    # SHELL = RB - AG
    # Calculate KAPPA: for 1:1 electrolyte only
    ERE0 = ER * E0  # Absolute permittivity
    NIO = IS * 2 * 6.02214086E23
    KAPPA = ((ECHG ** 2.0) * NIO * (ZI ** 2.0) / (ERE0 * KB * T)) ** 0.5
    # CALCULATE RZOIBULK: RADIUS OF ZONE OF INFLUENCE WITHOUT DEFORMATION
    RZOIBULK = 2.0 * ((1 / KAPPA) * AP) ** 0.5

    # activate flag to indicate small colloid relative to collector asperities
    concav = 0
    if RZOIBULK<=2*ASPdomain:
        concav=1

    # Calculate ACONTMAX: maximum radius of contact using JKR (negative sign added to make contact area positive for attractive work of adhesion, W132 < 0)
    if W132 > 0.0:
        W132 = 0.0
    ACONTMAX = (-6.0 * PI * W132 * (AP ** 2.0) / KINT) ** (1.0 / 3.0)
    # Calculate maximum vertical deformation of the colloid
    DELTAMAX = AP - (AP ** 2 - ACONTMAX ** 2) ** 0.5
    # Calculate steric interaction radius
    ASTE = (ACONTMAX ** 2 + 2 * LAMBDASTE * (AP + (AP ** 2 - ACONTMAX ** 2) ** 0.5)) ** 0.5
    # Set A132 = 0 for layered systems to show in output that A132 is not used
    if VDWMODE != 1:
        A132 = 0.0

    # initialize empty arrays for roughness asperities locations
    # colloid asperities
    xcap = np.empty(0)
    ycap = np.empty(0)
    zcap = np.empty(0)
    # domain asperities
    xasp_domain = np.empty(0)
    yasp_domain = np.empty(0)
    zasp_domain = np.empty(0)

    HS = np.empty(0)

    # Calculate HFRIC - Separation at which we consider contact to occur and zero slip
    # DEFORMATION STARTS TO OCCUR FOR SEPARATION DISTANCES SMALLER
    # THAN THIS VALUE. WE DEFINE THIS DISTANCE TO BE THAT WHERE EACH OF THE CONTACT FORCES HAVE REACHED 0.01 #   OF THEIR VALUE AT
    # VACUUM MINIMUM SEPARATION OF 0.158 NM
    H = H0
    ASP0 = 0.0
    NASP0 = 0.0
    RMODE0 = 0
    FBORN = af.AFMFORCEBORN(A132, SIGMAC, AP, H, A11, A22, A33, AC1C1, AC2C2, VDWMODE)
    FSTE = af.AFMFORCESTE(PI, GAMMA0STE, LAMBDASTE, ASTE, H)
    FAB = af.AFMFORCEAB(PI, AG, AP, ASP0, NASP0, RMODE0, LAMBDAAB, GAMMA0AB, H, H0,
                        X, Y, Z, xcap, ycap, zcap, xasp_domain, yasp_domain, zasp_domain, LTLT,
                        af.AFM_asp_tracking_RMODE3)

    FBORNFRIC = 0.0001 * FBORN
    FSTEFRIC = 0.0001 * FSTE
    FABFRIC = 0.0001 * FAB

    while (FBORN > FBORNFRIC) or (FSTE > FSTEFRIC) or (abs(FAB) > abs(FABFRIC)):
        H += 1.0E-12
        FBORN = af.AFMFORCEBORN(A132, SIGMAC, AP, H, A11, A22, A33, AC1C1, AC2C2, VDWMODE)
        FSTE = af.AFMFORCESTE(PI, GAMMA0STE, LAMBDASTE, ASTE, H)
        FAB = af.AFMFORCEAB(PI, AG, AP, ASP0, NASP0, RMODE0, LAMBDAAB, GAMMA0AB, H, H0,
                            X, Y, Z, xcap, ycap, zcap, xasp_domain, yasp_domain, zasp_domain, LTLT,
                            af.AFM_asp_tracking_RMODE3)
        HFRIC = H
    
    # CALCULATE HMIN - SEPARATION DISTANCE AT WHICH WE CONSIDER MAXIMUM DEFORMATION TO BE ACHIEVED. SEPARATION DISTANCES SMALLER THAN THIS VALUE CONTINUE
    #                      TO HAVE MAXIMUM DEFORMATION. WE DEFINE THIS VALUE TO BE THE LOCATION OF THE ENERGY MINIMUM (CALCULATED FOR SMOOTH SURFACES) FOR ALL
    #                      ATTRACTIVE INTERACTIONS WITH BORN AS THE BACKSTOP
    # if VDW EDL and AB interactions are all repulsive hardwire HMIN
    # otherwise find the minimum
    if (A132 < 0.0 and GAMMA0AB > 0.0) and (ZETACST * ZETAPST > 0.0):
        HMIN = H0
    else:
        H = H0
        FCOLL = 1.0
        # Ignore roughness
        while FCOLL > 0.0:
            HMIN = H
            H += 1.0E-12
            FVDW, FVDW2, Hasp_colloid, Hasp_domain = af.AFMFORCEVDW(X, Y, Z, A132, AG, AP, ASPcolloid, ASPdomain, NASP0, RMODE0, 
                                                                    xcap, ycap, zcap, xasp_domain, yasp_domain, zasp_domain, H, HS,
                                                                    LAMBDAVDW, A11, A22, A33, AC1C1, AC2C2, T1, T2, VDWMODE, LTLT, af.AFM_asp_tracking_RMODE3)
                                                              
            FEDL = af.AFMFORCEEDL(KAPPA, KB, ERE0, T, ZI, ECHG, ZETACST, ZETAPST, AG, AP, ASPcolloid, ASPdomain, NASP0, RMODE0, H, HS, PI,
                                  X, Y, Z, xcap, ycap, zcap, xasp_domain, yasp_domain, zasp_domain, LTLT, af.AFM_asp_tracking_RMODE3)
            FAB = af.AFMFORCEAB(PI, AG, AP, ASPcolloid, ASPdomain, RMODE, LAMBDAAB, GAMMA0AB, H, H0, X, Y, Z, xcap, ycap, zcap, xasp_domain, 
                                yasp_domain, zasp_domain, LTLT, af.AFM_asp_tracking_RMODE3)
            FBORN = af.AFMFORCEBORN(A132, SIGMAC, AP, H, A11, A22, A33, AC1C1, AC2C2, VDWMODE)
            if (FVDW>0.0):
                FVDW = 0.0
            if (FEDL>0.0):
                FEDL = 0.0
            if (FAB>0.0):
                FAB = 0.0
            FCOLL = FVDW + FEDL + FAB + FBORN

    ## -------------------------TRAJECTORY LOOP -----------------------------
    ##  SET NUMBER OF PARTICLES deping on parallel or single computer version
    # hardwire cluster and pert to 0 for initial MATLAB ported code
    CLUSTER = 0
    NPARTLOOP = NPART*NPART

    # Format definitions for all flux, traj files and run-time messages
    # Common headers for flux and trajectory files
    format101 = (
        "NPART= {:d} VSUP(ms-1)= {:15.8E} RLIM(m)= {:15.8E} "
        "POROSITY= {:15.8E} AG(m)= {:15.8E} RB(m)= {:15.8E} "
        "TTIME(s)= {:15.8E} ATTMODE= {:d} SLIP(m)= {:15.8E} "
        "RMODE= {:d} ASP(m)= {:15.8E} ASP2(m)= {:15.8E} \n"
    )

    format102 = (
        "AP(m)= {:15.8E} IS(mol/m3)= {:15.8E} ZI= {:15.8E} "
        "ZETAPST(V)= {:15.8E} ZETACST(V)= {:15.8E} RHOP(kg/m3)= {:15.8E} "
        "RHOW(kg/m3)= {:15.8E} VISC(kg/m/s)= {:15.8E} ER= {:15.8E} "
        "T(K)= {:15.8E} DIFFSCALE= {:15.8E} GRAVFACT= {:15.8E} "
        "cbPZ= {:d} cbMZ= {:d} cbPX= {:d} cbMX= {:d} simplotCHECK= {:d} detplotCHECK= {:d} \n"
    )

    format103 = (
        "SCOV= {:15.8E} ZETAHET(V)= {:15.8E} HETMODE= {:d} "
        "RHET0(m)= {:15.8E} RHET1(m)= {:15.8E} RHET2(m)= {:15.8E} "
        "SCOVP= {:15.8E} ZETAHETP(V)= {:15.8E} HETMODEP= {:15.8E} "
        "RHETP0(m)= {:15.8E} RHETP1(m)= {:15.8E} "
        "RZOIBULK(m)= {:15.8E} dTMRT(s)= {:15.8E} MULTB= {:15.8E} "
        "MULTNS= {:15.8E} MULTC= {:15.8E} VDWMODE= {:15.8E}\n"
    )

    format104 = (
        "A132(J)= {:15.8E} LAMBDAVDW(m)= {:15.8E} GAMMA0AB(J/m2)= {:15.8E} "
        "LAMBDAAB(m)= {:15.8E} GAMMA0STE(J/m2)= {:15.8E} LAMBDASTE(m)= {:15.8E} KINT(N/m2)= {:15.8E} "
        "W132(J/m2)= {:15.8E} ACONTMAX(m)= {:15.8E} BETA= {:15.8E} "
        "DFACTNS= {:15.8E} DFACTC= {:15.8E} A11(J)= {:15.8E} A22(J)= {:15.8E} "
        "A33(J)= {:15.8E} AC1C1(J)= {:15.8E} AC2C2(J)= {:15.8E} "
        "T1= {:15.8E} T2= {:15.8E}\n"
    )
        
    # Extra headers for trajectory files only

    format105 = 'ATTACHK= {}\r\n'

    format106 = (
        'I                 X                Y               Z           '
        'R                 H                ETIME           PIMEF       '
        'FCOLL             FVDW             FEDL            FAB         '
        'FSTE              FBORN            UT              UN          '
        'VT                VN               FDRGT           FDRGN       '
        'FDIFX             FDIFY            FDIFZ           FGT         '
        'FGN               FLIFT            ACONT           RZOI        '
        'AFRACT\r\n'
    )

    format107 = (
        '{} {:15.8E} {:15.8E} {:15.8E}  '
        '{:11.8E} {:11.8E} {:11.8E} {:11.8E} '
        '{:11.8E} {:11.8E} {:11.8E} {:11.8E} '
        '{:11.8E} {:11.8E} {:11.8E} {:11.8E} '
        '{:11.8E} {:11.8E} {:11.8E} {:11.8E} '
        '{:11.8E} {:11.8E} {:11.8E} {:11.8E} '
        '{:11.8E} {:11.8E} {:11.8E} {:11.8E} '
        '{:11.8E}\r\n'
    )

    # Extra headers for flux files only
    format110 = (
        'ATTACHK1=EXIT,'
        'ATTACHK2=ATTACHED-BY-PERFECT-SINK-OR-TORQUE,'
        'ATTACHK3=REMAINING-UNRESOLVED-WHEN-SIMULATION-S,'
        'ATTACHK4=TORQUE-WITH-SLOW-MOTION,'
        'ATTACHK5=IN-NEAR-SURFACE-WITH-SLOW-MOTION,'
        'ATTACHK6=CRASHED \r\n'
    )

    format206 = (
        'PARTICLE               ATTACHK             XINIT(m)            '
        'YINIT(m)               RINJ(m)             ZINIT(m)            '
        'RINIT(m)               HINIT(m)            XOUT(m)             '
        'YOUT(m)                ZOUT(m)             ROUT(m)             '
        'HOUT(m)                ETIME(s)            PTIMEIN(s)          '
        'PTIMEOUT(s)            TBULK(s)            TNEAR(s)            '
        'TFRIC(s)               NSVISIT             FRICVISIT           '
        'ACONT(m)               RZOI(m)             AFRACT              '
        'HETTYPE                HETFLAG             NSVEL(m/s)          '
        'HAVE(m)\r\n'
    )

    format207 = (
        '{} {:15.8E} {:15.8E} '
        '{:15.8E} {:15.8E} {:15.8E} '
        '{:15.8E} {:15.8E} {:15.8E} '
        '{:15.8E} {:15.8E} {:15.8E} '
        '{:15.8E} {:15.8E} {:15.8E} '
        '{:15.8E} {:15.8E} {:15.8E} '
        '{:15.8E} {:15d} {:15d} '
        '{:15.8E} {:15.8E} {:15.8E} '
        '{:15.8E} {:15.8E} {:15.8E} '
        '{:15.8E} \r\n'
    )

    # Runtime message display format for loading mode
    format6001 = 'J= {} I= {} Z= {:8.4E}  H= {:8.4E}  AFRACT= {:8.4E}'
    format6002 = 'J= {} I= {} Z= {:8.4E}  H= {:8.4E}  AFRACT= {:8.4E} ATTACHK = {}'

    # Runtime message display format for perturbation mode
    format7001 = 'J= {} oldJ= {} I= {} Z= {:8.4E}  H= {:8.4E}  AFRACT= {:8.4E}'
    format7002 = 'J= {} oldJ= {} I= {} Z= {:8.4E}  H= {:8.4E}  AFRACT= {:8.4E} ATTACHK = {} oldATTACHK = {}'

    # Flux files and trajectory files names defined here
    fluxfname = ['FLUXEX_HAP.OUT', 'FLUXATT_HAP.OUT', 'FLUXREM_HAP.OUT']
    trajfname = ['HAP_TRAJEX.', 'HAP_TRAJATT.', 'HAP_TRAJREM.']

    # Original naming, kept for cluster version if needed
    # trajfname = ['HAPHETTRAJEX.', 'HAPHETTRAJATT.', 'HAPHETTRAJREM.']

    #Add button where user specifies the axis on which to drive the colloid
    #toward the collector (x,y,or z)!!!!
    #AXstring = get handle!!!!
    AXstring = 'y'
    ## initialize array size
    # Z range parameters
    HSPAN = 5.0e-7 #maximum separation distance (m)
    # HMIN is calculated above as the minimum separation due to atractive
    # forces were deformation is maximal
    # Hlow is  + ROUGHNESS
    # Hhigh is Hlow+HSPAN
    # geometric factor to step size from ZMAX to ZMIN
    # has to be >1.0
    GFACT = 1.01
    # # define range,
    Hlow = HMIN
    Hhigh = Hlow+HSPAN
    # create locations vector in H
    nmax = int(np.ceil(np.log(Hhigh / Hlow) / np.log(GFACT))) + 2
    HVECTOR = np.empty(nmax, dtype=np.float64)

    HVECTOR[0]=Hhigh
    i=0
    while HVECTOR[i]>Hlow:
        i=i+1
        HVECTOR[i]=HVECTOR[i-1]/GFACT
    
    HVECTOR[i]=Hlow
    HVECTOR = HVECTOR[:i + 1]
    
    HSMOOTH = HVECTOR # keep data estructure only, HSMOOTH AND HVECTOR are recalculated below if needed 
    #number of locations
    nsteps =len(HVECTOR)

    # initialize vector arrays based on nsteps
    # DEFINE ARRAYS FIRST, PREALLOCATE FOR SPEED

    XOT = np.full_like(np.zeros((MAXVAL,NPARTLOOP)), np.nan)  # PARTICLE POSITION
    YOT = XOT.copy()
    ZOT = XOT.copy()
    ROT = XOT.copy()
    
    IOT = XOT.copy()  # STEP NUMBER
    HOT = XOT.copy()  # SEPARATION DISTANCE
    HSOT = XOT.copy()  # SMOOTHING LENGTH
    ETIMEOT = XOT.copy()  
    FCOLLOT = XOT.copy()  # DLVO FORCES
    FVDWOT = XOT.copy()
    FEDLOT = XOT.copy()  
    FABOT = XOT.copy()
    FSTEOT = XOT.copy()
    FBORNOT = XOT.copy()  # ACID BASE STERIC AND BORN FORCES
    FDRGXOT = XOT.copy()
    FDRGYOT = XOT.copy()
    FDRGZOT = XOT.copy()  # DRAG FORCE CARTESIAN
    FDRGTOT = XOT.copy()
    FDRGNOT = XOT.copy()  # DRAG FORCE NORMAL-TANGENTIAL
    FDIFXOT = XOT.copy()
    FDIFYOT = XOT.copy()
    FDIFZOT = XOT.copy()  # Diffusion FORCE
    FGTOT = XOT.copy()
    FGNOT = XOT.copy()
    FLIFTOT = XOT.copy()  # GRAVITY AND LIFT
    UXOT = XOT.copy()
    UYOT = XOT.copy()
    UZOT = XOT.copy()  # PARTICLE VELOCITY CARTESIAN
    UTOT = XOT.copy()
    UNOT = XOT.copy()  # PARTICLE VELOCITY NORMAL-TANGENTIAL
    VXOT = XOT.copy()
    VYOT = XOT.copy()
    VZOT = XOT.copy()  # FLUID VELOCITY CARTESIAN
    VTOT = XOT.copy()
    VNOT = XOT.copy()  # FLUID VELOCITY NORMAL-TANGENTIAL
    PTIMEFOT = XOT.copy()
    AFRACTOT = XOT.copy()  # TRAJ TIME AND FRACTION OF HET/ZOI OVERLAP
    ACONTOT = XOT.copy()
    RZOIOT = XOT.copy()  # CONTACT AREA ZONE OF INFLUENCE RADIUS
    XHET = np.zeros(100)  # COLLECTOR HET LOCATIONS
    YHET = XHET.copy()
    ZHET = XHET.copy()
    RHET = XHET.copy()  # COLLECTOR HET LOCATIONS
    XHETP = np.zeros(10000000)  # COLLOID HET LOCATIONS
    YHETP = XHETP.copy()
    ZHETP = XHETP.copy()
    RHETP = XHETP.copy()  # COLLOID HET LOCATIONS

    ## define probe locations in a regular grid
    # intialize location vectors
    # changed XINITV,YINITV to LAT1V,LAT2V !!!!
    LAT1V = np.full(NPARTLOOP, np.nan)
    LAT2V = np.full(NPARTLOOP, np.nan)
    RINJV = np.full(NPARTLOOP, np.nan)
    ugrid = 1
    # random probe locations (circle)
    if ugrid ==0:
        for j in range(NPARTLOOP):
            # changed x,y to lat1,lat2 !!!!
            LAT1V[j],LAT2V[j],RINJV[j]=af.AFMINITIAL(RLIM)
    # uniform probe locations (square)
    if ugrid==1:
        # changed x,y to lat1,lat2 !!!!
        LAT1lim = np.linspace(-RLIM/2,RLIM/2,NPART)
        LAT2lim = np.linspace(-RLIM/2,RLIM/2,NPART)
        #     LAT1lim = linspace(-RLIM,0,NPART)
        #     LAT2lim = linspace(-RLIM,0,NPART)
        LAT1loc,LAT2loc=np.meshgrid(LAT1lim,LAT2lim)
        nr,nc= LAT1loc.shape
        j=0
        for im in range(nr):
            for jm in range(nc):
                # changed x,y to lat1,lat2 !!!!
                LAT1V[j] = LAT1loc[im,jm]
                LAT2V[j] = LAT2loc[im,jm]
                j=j+1

        # changed x,y to lat1,lat2 !!!!
        RINJV = np.sqrt(LAT1V*LAT1V+LAT2V*LAT2V)

    # initialize hetdomains on AFMdomain output matrices
    nhetDOM = 100
    rangeHetV = np.full(NPARTLOOP, np.nan)
    mxhetOUT = np.full((nhetDOM,NPARTLOOP), np.nan)
    myhetOUT = mxhetOUT.copy()
    mzhetOUT = mxhetOUT.copy()
    mrhetOUT = mxhetOUT.copy()

    ##  set parameters for ROUGH surfaces
    if RMODE>0:
        fzoi = 1
    else:
        if RMODE==1 or RMODE==3:
            # calculate fzoi as a function of asperities and zoi
            ratio_asp_colloid = (RZOIBULK/ASPcolloid)
            #
            if ratio_asp_colloid<3:
                fzoi = 2.0
            else:
                fzoi = 1.0
        
        if RMODE==2 or RMODE==3:
            # calculate fzoi as a function of asperities and zoi
            ratio_asp_domain = (RZOIBULK/ASPdomain)
            #
            if ratio_asp_domain<3:
                fzoi = 2.0
            else:
                fzoi = 1.0
        
    # generate colloid asperities for RMODE 1 and 3
    if RMODE ==1 or RMODE==3:
        # asperity generation COLLOID
        # uniform asperities locations
        # single size
        #use arc lenght to describe uniform grid spaced on spherical (colloid)
        # the chord formed on the colloid surface with 2 adjacent asperities equals
        # to 2*ASP
        # calculate 2 asp arc from chord
        angasp = 2*np.arcsin(ASPcolloid/AP)
        #arc = angasp/2/pi*AP
        # calculate aproximate zoi arc valid only across range of  ZOI
        # corresponding to 1 to 100 mM IS
        angzoi = (2*np.arcsin(RZOIBULK/AP))
        #ARCZOI = angzoi/2/pi*AP
        xcap0,ycap0,zcap0 = af.AFMsphere_capEQ(AP,angasp,angzoi,fzoi,RZOIBULK, ASPcolloid)
    
    # prealocate array for visual representation of asperities
    if RMODE==2 or RMODE==3:
        mat_asp_domx = np.full((asp_max_number,NPARTLOOP), np.nan)
        mat_asp_domy = mat_asp_domx.copy()
        mat_asp_domz = mat_asp_domx.copy()
        range_mat_asp = np.full(NPARTLOOP, np.nan)
    
    ## LOOP THROUGH PARTICLES  #############################
    # NPARTLOOP = 6 #test debug
    #initialize release data vectors for loading and perturbation mode
    perTIME=0.0 
    perREL=0.0 
    perREM=0.0

    #Initialize vectors
    YcrashVEC = np.full(NPARTLOOP,np.nan)

    for J in range(NPARTLOOP):

        seed = np.int32(0)  # RANDOM NUMBER PARAMETER                                    #RANDOM NUMBER PARAMETER
        if CLUSTER == 0:
            ipart = J
        ## Particle intial set up prior to injection, differentiate between loading and perturbation simulation
        # test debug
        FADH=1e-10 
        FREP=1e-10
        ## SET INITIAL PARTICLE TIME (EVENLY DISTRIBUTED THROUGH TIME FOR FLUX) SET MAXIMUM INJECTION TIME HALF OF TOTAL SIMULATION TIME
        HFLAG =1
        ACONT = 0.0
        ## convert HVECTOR TO XYZ coordinates (AXVECTOR)
        # define range, updating the coordinates to collector center
        HINIT =Hlow
        if RMODE==0: #smooth surfaces
            AXVECTOR = HVECTOR+AP+AG
            AXMAX=np.max(AXVECTOR)
        
        if RMODE==1: #roughnes on one surface colloid(1)
            # minimum separation distance corresponds to asperities on
            # colloid relative to flat domain
            AXVECTOR = HVECTOR+AP+AG+ASPcolloid
            AXMAX=np.max(AXVECTOR)
        
        if RMODE==2: #roughnes on one surface domain(2)
            # set probe location in XZ plane
            X = LAT1V[J]
            Z = LAT2V[J]
            # for this RMODE2 actual local separation distances are considered to
            # allow colloid translation in between domain asperities.
            # same strategy needs to be properly set for all other RMODEs
            # generate domain asperities array
            xasp_domain,yasp_domain,zasp_domain=af.AFM_asp_tracking(X,Y,Z,AG,fzoi,RZOIBULK,ASPdomain, concav)
            ## calculation of HVECTOR for  a given location. Translate colloid towards
            # surface following y axis until crash occurs on rough domain for a given xz position
            # HVECTOR parallel to the axis of translation.
            # i.e. from 200nm to H0
            # HVECTOR is the separation distance along the axis of trasnlation
            # H = 0 occurs at actual contact with the asperity
            # AXVECTOR is the correspongin colloid positions with HVECTOR
            #Hasp_domain is the array of
            # local actual separation distances between surfaces
            ntest = 2000  #number of translations for testing crash
            HSPAN = 2e-7
            HVECTOR = np.linspace(HSPAN,H0,nsteps)
            # RSPAN is the added maximummheight of asperities
            # RSPAN = ASPcolloid # for RMODE 1
            RSPAN = ASPdomain # for RMODE 2
            # RSPAN = ASPdomain+ASPcolloid # for RMODE 3
            # plane of efective contact (highest asperity height)
            AXVECTORtest = np.linspace(HSPAN+RSPAN,H0,ntest)+AP+AG
            # set crash_flag = 0 no crash
            crash_flag = 0
            # reset crash index in array as minimum separatioin distance position
            cindex = ntest
            for i in range(ntest):
                Y=AXVECTORtest[i]
                # calculate separation distances colloid to asperities
                # vectorized calculation for array of separation distances
                # array of distances between asperity centers and colloid center
                RXYZ = np.sqrt((X-xasp_domain)*(X-xasp_domain)+(Y-yasp_domain)*(Y-yasp_domain) + (Z-zasp_domain)*(Z-zasp_domain))
                # factor of projection on  Y component (array)
                facY =  (Y-AG)/RXYZ
                # separation distance between asperity and colloid surface
                Hasp_domain = RXYZ-AP-ASPdomain
                c=Hasp_domain<=H0
                # seapration distance between asperity and smooth surface in between
                # asperities
                cs = Y-AP-AG<=H0
                if cs==0:
                    # check for crash
                    if np.sum(c)>=1 and crash_flag==0:
                        # reset flag
                        crash_flag = 1
                        cindex = i-1
                        # disp(ycrash-AP-AG)
                        # save crash distance array
                        crash_Hasp_domain = Hasp_domain
                    
                    if crash_flag==0:
                        # save domain before crash
                        precrash_Hasp_domain=Hasp_domain     
            
            # produce array of AXVECTOR with corrected bounds to prevent crash
            if crash_flag == 1:
                # minimum sep distance with no crash is calculate from asperity at
                # which crash occurs
                # find minimun sep in array
                iminasp = np.argmin(precrash_Hasp_domain)
                hminasp = precrash_Hasp_domain[iminasp]
                # calculate crash point on asperity surface
                # asperity coordinate
                xad = xasp_domain[iminasp]
                yad = yasp_domain[iminasp]
                zad = zasp_domain[iminasp]
                # calculate Y colloid coordinate at crash X,Z are fixed in AFM
                Xcrash = X
                Zcrash = Z
                Ycrash = np.sqrt((AP+ASPdomain)**2-((xad-Xcrash)*(xad-Xcrash)+(zad-Zcrash)*(zad-Zcrash)))+yad
                # calculate contact point on asperity surface
                #     d=((xad-Xcrash)*(xad-Xcrash)+(yad-Ycrash)*(yad-Ycrash)+(zad-Zcrash)*(zad-Zcrash))**0.5
                d = AP+ASPdomain
                xcont = AP*(xad-Xcrash)/d+Xcrash
                ycont = AP*(yad-Ycrash)/d+Ycrash
                zcont = AP*(zad-Zcrash)/d+Zcrash
                # determinbe HSMOOTH
                HSMOOTH = Ycrash-AP-AG+HVECTOR
                # if HSMOOTH reports crash with smooth surface then  recalculate
                if np.min(HSMOOTH)<=H0:
                    HSMOOTH = HVECTOR
                    Ycrash = AG+AP+H0
                    #disp('no crash')
                # else:
                    #disp('crash')
                # determine AXVECTOR
                AXVECTOR = Ycrash+HVECTOR
            else:
                # if no crash with asperities occurs means that colloid tranlation is
                # aligned in between 4 large domain asperities,in a SCP array. Not likely but
                # possible
                #minimum sep distance is H0
                Xcrash = X
                Zcrash = Z
                Ycrash = AG+AP+H0
                xcont = X
                ycont = Ycrash
                zcont = Z
                #HSMOOTH = HVECTOR
                HSMOOTH = HVECTOR
                # determine AXVECTOR
                AXVECTOR = Ycrash+HVECTOR
                #disp('no crash')
            
            # calcualte Hsmooth(separation distance distance to smooth collector)
            HminSMOOTH = Ycrash-AG-AP
            # disp(HminSMOOTH)
            #  calculation of crash estimation in translation
            AXMAX=np.max(AXVECTOR)
            # savea YCRASH vector
            YcrashVEC[J]=Ycrash
        
        if RMODE == 3: #roughness on both surfaces colloid and collector
            # in the case that asperities are of different size,determined by
            # the smaller one
            AXVECTOR = HVECTOR+AP+AG+ASPcolloid+ASPdomain
            AXMAX = np.max(AXVECTOR)

        ## INITIALIZE LOCATION OF PARTICLES
        RINJ = RINJV[J]
        # changed to ifs setting XINIT,YINIT,ZINIT to LAT1,LAT2, or AXMAX deping on which axis is
        # normal AXstring!!!!
        if AXstring== 'x':
            YINIT = LAT1V[J]
            ZINIT = LAT2V[J]
            XINIT = AXMAX
        
        if AXstring== 'y':
            XINIT = LAT1V[J]
            ZINIT = LAT2V[J]
            YINIT = AXMAX
        
        if AXstring=='z':
            XINIT = LAT1V[J]
            YINIT = LAT2V[J]
            ZINIT = AXMAX
        
        ## Intialize locations in cartesian system
        # no change here!!!!
        X = XINIT
        Y = YINIT
        Z = ZINIT
        H = HVECTOR[0]
        HS = HSMOOTH[0]
        R = np.sqrt((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0)+(Z-Zm0)*(Z-Zm0))
        # Rxy for 2D plot only
        Rxy = np.sqrt((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0))
        # alternate displayed trajectory directions in 2D circle
        if J % 2==0:
            Rxy = -Rxy
                
        #SET FLUID VELOCITY COMPONENTS AND COLLOID NORMAL VELOCITY
        VX = 0.0
        VY = 0.0
        VZ = -VSUP
        UZ = VZ
        
        ## UPDATED INITIALIZATION
        #   CALCULATE UNIT VECTORS
        ENX = (X-Xm0)/R
        ENY = (Y-Ym0)/R
        ENZ = (Z-Zm0)/R 
        #   INITIALIZE VELOCITIES
        UX = 0.0
        UY = 0.0
        UN = UX*ENX+UY*ENY+UZ*ENZ
        UNX = UN*ENX
        UNY = UN*ENY
        UNZ = UN*ENZ
        UTX = UX-UNX
        UTY = UY-UNY
        UTZ = UZ-UNZ
        UT = np.sqrt(UTX**2+UTY**2+UTZ**2)
        #   FIT OMEGA*AP/UT AS FUNCTION OF H/AP USING GCB 1967b TABLES 2&3
        OMEGA = UT/AP*(0.5518+117.4*(H/AP))/(1+232.1*(H/AP)+237.7*(H/AP)**2.0)
        VN = VX*ENX+VY*ENY+VZ*ENZ
        VNX = VN*ENX
        VNY = VN*ENY
        VNZ = VN*ENZ
        VTX = VX-VNX
        VTY = VY-VNY
        VTZ = VZ-VNZ
        VT = np.sqrt(VTX*VTX+VTY*VTY+VTZ*VTZ)
        #   CALCULATE RZOI AND RZOIAB
        RZOI = np.sqrt(ACONT**2+2/KAPPA*(AP+np.sqrt(AP**2-ACONT**2)))
        RZOIAB = np.sqrt(ACONT**2+2*LAMBDAAB*(AP+np.sqrt(AP**2-ACONT**2)))
        #   CALCULATE THE NUMBER OF ASPERITIES WITHIN EACH ZOI
        NASP = 0.0
        NASPAB = 0.0
        ASPLIM = 0.5*np.sqrt(PI)*RZOI
        ASPLIMAB = 0.5*np.sqrt(PI)*RZOIAB

        if RMODE==1 or RMODE==3:
            # translaste colloid asperities array relative to colloid position
            xcap = xcap0+X
            ycap = ycap0+Y
            zcap = zcap0+Z
        
        if RMODE==2 or RMODE==3:
            # generate domain asperities
            xasp_domain,yasp_domain,zasp_domain=af.AFM_asp_tracking(X,Y,Z,AG,fzoi,RZOIBULK,ASPdomain, concav)

            n_asp = len(xasp_domain)

            if n_asp<=asp_max_number:
                # save to array
                range_mat_asp[J] =n_asp
                mat_asp_domx[:n_asp,J] = xasp_domain
                mat_asp_domy[:n_asp,J] = yasp_domain
                mat_asp_domz[:n_asp,J] = zasp_domain

        # CALCULATE COLLOIDAL FORCES
        # CALCULATE FVDW
        FVDW,FVDW2,Hasp_colloid,Hasp_domain=af.AFMFORCEVDW(X,Y,Z,A132,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,xcap,ycap,zcap,xasp_domain,
                                                           yasp_domain,zasp_domain,H,HS,LAMBDAVDW,A11,A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE,
                                                           LTLT, af.AFM_asp_tracking_RMODE3) 

        #   FAVORABLE CONDITIONS IF BULK ZETAC AND ZETAP ARE OPPOSITE IN SIGN, THEN SET SCOV = 0.0 AND SCOVP = 0.0
        if (ZETACST>=0.0 and ZETAPST<=0.0) or (ZETACST<=0.0 and ZETAPST>=0.0):
            SCOV = 0.0
            SCOVP = 0.0
        
        #   UNDER UNFAVORABLE CONDITIONS HETERODOMIANS WILL BE SIMULATED IN EITHER COLLECTOR (HETC), OR COLLOID (HETP), OR BOTH
        #   TO CALCULATE HETC AND HETP FRACTIONAL AREAS WITHIN ZOI, HETERODOMAINS WILL BE PROJECTED ONTO THE FRAME OF REFERENCE
        #   WITH X-Y PLANE MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER
        if SCOV>0.0 or SCOVP>0.0: 
            #   CALCULATE PROJECTION OF COLLOID CENTER ON HAPPEL SPHERE
            XG = Xm0+ENX*AG
            YG = Ym0+ENY*AG
            ZG = Zm0+ENZ*AG
            AFRACT = 0.0
            #   CALCULATE COLLOID RADIAL POSITION - SPHERICAL COORDINATES AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
            RO = np.sqrt((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0)+(Z-Zm0)*(Z-Zm0))
            #   CALCULATE COLLOID THETA ANGLE - SPHERICAL COORDINATES AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
            THETA = np.arccos((Z-Zm0)/RO)
            #   CALCULATE PROJECTION OF COLLOID POSITION ON XY PLANE
            ROXY = np.sqrt((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0))
            #   CALCULATE COLLOID PHI ANGLE - SPHERICAL COORDINATES AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
            if (ROXY==0.0):
                PHI = 0.0
            else:
                if (Y-Ym0)>=0.0:
                    PHI = np.arccos((X-Xm0)/ROXY)
                else:
                    PHI = 2.0*np.pi-np.arccos((X-Xm0)/ROXY)
  
            #   HETEROGENEITY ON COLLOID (HETP) SUBROUTINE TO DETERMINE HETERODOMAIN PROJECTIONS
            #   HETP PROJECTIONS WILL BE GENERATED ASSUMING THAT THE COLLOID CENTER COINCIDES WITH THE HAPPEL SPHERE CENTER
            #   MHETP CONTAINS HETP COORDINATES AND RADII(FORMAT: [XHETP YHETP ZHET RHETP])
            #   MPRO CONTAINS HETP PROJECTION COORDINATES AND RADII(FORMAT: [XPRO YPRO ZPRO RPRO])
            MHETP, MPRO=af.AFMHETTRACKP(Xm0,Ym0,Zm0,H,RZOIBULK,AP,HETMODEP,SCOVP,RHETP0,RHETP1)
            #   HETP WILL BE TRANSLATED TO THE COLLECTOR FRAME OF REFERENCE AND
            #   ROTATED BASED ON COLLOID SPHERICAL COORDINATES, FOR FRONT- PLOTTING
            #   HETP PROJECTIONS WILL BE TRANSLATED AND ROTATED TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING
            #   THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER, TO CALCULATE AFRACT
            
            '''af.AFMHETP_TRANSFORM is different fron happel in line 1270 af and 944 hf, reshape'''
            MHETP_PLOT,MPRO_AF = af.AFMHETP_TRANSFORM(X,Y,Z,XG,YG,ZG,THETA,PHI,MHETP,MPRO, SCOVP)

    
        #   CALCULATE HETERODOMAINS INFLUENCE IN EDL
        if ((SCOV>0.0 or SCOVP>0.0) and HFLAG>1):
            #   HETEROGENEITY ON COLLECTOR (HETC) SUBROUTINE TO DETERMINE CLOSEST HETERODOMAIN TO COLLOID
            #   HETC WILL BE TRANSLATED TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER
            if (SCOV>0.0):
                
                XHET,YHET,ZHET,RHET = af.AFMHETTRACK(X,Y,Z,Xm0,Ym0,Zm0,AG,HETMODE,SCOV,RHET0,RHET1,RHET2,0)
                XHET_AF,YHET_AF,ZHET_AF = af.AFMHETC_TRANSFORM(XG,YG,ZG,THETA,PHI,XHET,YHET,ZHET)
                RHET_AF = RHET
            else:
                XHET_AF = 0.0
                YHET_AF = 0.0
                ZHET_AF = 0.0
                RHET_AF = 0.0
            
            #   INITIALIZE FRACTIONAL AREAS
            AFRACT = 0.0 #TOTAL ATTRACTIVE FRACTIONAL AREA
            AFRACT_PZ = 0.0 #PRO-ZOI FRACTIONAL AREA
            AFRACT_ZH = 0.0 #ZOI-HET FRACTIONAL AREA
            AFRACT_PZH = 0.0 #PRO-ZOI-HET FRACTIONAL AREA
            AFRACT_Z = 0.0 #ZOI FRACTIONAL AREA NON-OVERLAPPED
            #   CALCULATE OVERLAPING AREA OF HETERODOMAINS AND ZOI
            #   GIVEN THAT THE PROJECTION OF COLLOID CENTER CORRESPONDS TO THE ORIGIN OF THE FRAME OF REFERENCE WITH X-Y PLANE
            #   MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER, VARIABLES
            #   EQUAL TO 0.0 MUST BE PASSED TO THE FIRST TWO POSITIONS OF SUBROUTINE FRACTIONAL_AREA
            AF_PZ,AF_ZH,AF_PZH,AF_Z = af.AFMAREAFRACT(Xm0,Ym0,RZOI,Xm0,Ym0,Zm0,MPRO_AF[:, [0, 1, 3]])
            AFRACT = AF_PZ
            AFRACT_PZ = AF_PZ
            for K in range(HETMODE):
                AF_PZ,AF_ZH,AF_PZH,AF_Z = af.AFMAREAFRACT(Xm0,Ym0,RZOI,XHET_AF[K],YHET_AF[K],RHET_AF[K],MPRO_AF[:, [0, 1, 3]])
                AFRACT += AF_ZH #TOTAL ATTRACTIVE FRACTIONAL AREA
                if (AF_ZH >= 0.0):
                    AFRACT -= AF_PZH #TOTAL ATTRACTIVE FRACTIONAL AREA
                    AFRACT_PZ -= AF_PZH #PRO-ZOI FRACTIONAL AREA
                
                AFRACT_ZH += AF_ZH #ZOI-HET FRACTIONAL AREA
                AFRACT_PZH += AF_PZH #PRO-ZOI-HET FRACTIONAL AREA
                AFRACT_Z = 1 - AFRACT_PZ - AFRACT_ZH - AFRACT_PZH #ZOI FRACTIONAL AREA NON-OVERLAPPED
            
            if (AFRACT>0.0):
                #CALCULATE PRO-ZOI ATTRACTIVE CONTRIBUTION TO EDL FORCE
                ZETAC = ZETACST
                ZETAP = ZETAHETP
                #FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI)
                FEDL=af.AFMFORCEEDL(KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,HS,PI,X,Y,Z,xcap,
                                  ycap,zcap,xasp_domain,yasp_domain,zasp_domain, LTLT, af.AFM_asp_tracking_RMODE3)
                FEDL_PZ = FEDL
                #CALCULATE ZOI-HET ATTRACTIVE CONTRIBUTION TO EDL FORCE
                ZETAC = ZETAHET
                ZETAP = ZETAPST
                #FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI)
                FEDL=af.AFMFORCEEDL(KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,HS,PI,X,Y,Z,xcap,
                                  ycap,zcap,xasp_domain,yasp_domain,zasp_domain, LTLT, af.AFM_asp_tracking_RMODE3)
                FEDL_ZH = FEDL
                #CALCULATE PRO-ZOI-HET REPULSIVE CONTRIBUTION TO EDL FORCE
                ZETAC = ZETAHET
                ZETAP = ZETAHETP
                #FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI)
                FEDL=af.AFMFORCEEDL(KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,HS,PI,X,Y,Z,xcap,
                                  ycap,zcap,xasp_domain,yasp_domain,zasp_domain, LTLT, af.AFM_asp_tracking_RMODE3)
                FEDL_PZH = FEDL
                #CALCULATE ZOI REPULSIVE CONTRIBUTION TO EDL FORCE
                ZETAC = ZETACST
                ZETAP = ZETAPST
                #FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI)
                FEDL=af.AFMFORCEEDL(KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,HS,PI,X,Y,Z,xcap,
                                  ycap,zcap,xasp_domain,yasp_domain,zasp_domain, LTLT, af.AFM_asp_tracking_RMODE3)
                FEDL_Z = FEDL

                #CALCULATE NET EDL FORCE
                FEDL =  AFRACT_PZ*FEDL_PZ + AFRACT_ZH*FEDL_ZH + AFRACT_PZH*FEDL_PZH + AFRACT_Z*FEDL_Z
            else: #(AFRACT>0.0)
                ZETAC = ZETACST
                ZETAP = ZETAPST
                #FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI)
                FEDL=af.AFMFORCEEDL(KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,HS,PI,X,Y,Z,xcap,
                                    ycap,zcap,xasp_domain,yasp_domain,zasp_domain, LTLT, af.AFM_asp_tracking_RMODE3)
            
        else: #and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
            AFRACT = -1.0
            ZETAC = ZETACST
            ZETAP = ZETAPST
            #FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI)
            
            FEDL=af.AFMFORCEEDL(KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,NASP,RMODE,H,HS,PI,X,Y,Z,xcap,
                                ycap,zcap,xasp_domain,yasp_domain,zasp_domain, LTLT, af.AFM_asp_tracking_RMODE3)
            
            
         #and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
        

        #FAB= AFMFORCEAB (PI,AG,AP,ASP,NASPAB,RMODE,LAMBDAAB,GAMMA0AB,H,H0)
        FAB= af.AFMFORCEAB(PI,AG,AP,ASPcolloid,ASPdomain,RMODE,LAMBDAAB,GAMMA0AB,H,H0,X,Y,Z,xcap,
                        ycap,zcap,xasp_domain,yasp_domain,zasp_domain, LTLT, af.AFM_asp_tracking_RMODE3)  
        #         FAB = 0.0 # !!debugEP
        
        FBORN=af.AFMFORCEBORN(A132,SIGMAC,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE)
        
        FSTE=af.AFMFORCESTE(PI,GAMMA0STE,LAMBDASTE,ASTE,H)

        FCOLL = FVDW + FEDL + FAB + FBORN + FSTE
        FDIFX = 0.0
        FDIFY = 0.0
        FDIFZ = 0.0
        FG=af.AFMGRAVITY(GRAVFACT,AP,G,RHOP,RHOW,PI)
        FGN=FG*ENZ
        FGT=np.sqrt(FG*FG-FGN*FGN)
        FLifT=af.AFMFORCELIFT(RHOW,R,AP,AG,VT,UT,OMEGA)
        HBAR = (H+B)/AP #REDUCED RETARDATION DUE TO ROUGHNESS
        FUN2=1.0+B2*np.exp(-C2*HBAR)+D2*np.exp(-E2*HBAR**A2)
        FUN3=1.0+B3*np.exp(-C3*HBAR)+D3*np.exp(-E3*HBAR**A3)
        FUN4=1.0+B4*np.exp(-C4*HBAR)+D4*np.exp(-E4*HBAR**A4)
        FDRGN,FDRGT =af.AFMFORCEDRAG(FUN2,FUN3,FUN4,M3,VN,VT) 

        #   RESTART TRANSLATION AND OUTPUT COUNTERS
        I = 0
        PCOUNT = 0
        PCOUNT2 = 0
        NSplot = 0
        NSplotVAR = 30
        PARRAY=0
        OUTCOUNT = 0
        OUTFLAG = 1
        ATTACHK = 0 #INITIALIZE ATTACHK FLAG
        ARRESTFLAG = 0 #USED TO ALLOW COLLOID REACH EQUILIBRIUM SEPARATION DISTANCE
        #   RESET STAGNANT PARTICLE INDICATOR
        IREF1 = 0
        IREF2 = 0
        #   RESET CUMULATIVE BULK,NEAR-SURFACE, AND FRICTION TIMES
        TBULK = 0.0
        TNEAR = 0.0
        TFRIC = 0.0
        ETIME = 0.0
        #   RESET NEAR-SURFACE AND FRICTION VISIT COUNTERS
        NSVISIT = 0
        FRICVISIT = 0
        #   RESET AVERAGE SEPARATION DISTANCE AND NEAR-SURFACE VELOCITY PARAMETERS
        L = 0
        HSUM = 0
        HAVE = 0.0
        NSDIST = 0.0
        NSVEL = 0.0
        #restart Happel circle for transport plots
        drawcircle =1
        ## INITIALIZE simplot figures
        # calculate output interval as a function of dTMRT
        NOUTinterval=1/dTMRT/NOUT
        
        ##    cccccccccccccccccc TRANSLATION LOOP cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc**
        # intialize afract calc reset flag, indepent of single_afract,
        # dont change value
        het_afract_calculated = 0
        # prealocate FSTEVEC for testing
        FSTEVEC=np.full(nsteps, np.nan)
        DELTAV = np.full(nsteps, np.nan)
        # change while to for loop to lop through disances predefined above
        for i in range (nsteps):

            ## DETAILED SURFACE VISUALIZATION
            # near surface visualization
            # scale near surface plot based on colloid size
            nang=500 # resolution angular grid points for collector sphere cap array
            fsurf = 5 # factor of sphere cap (as amultiple of the arc of length AP)
            # set factor to axis limits around center of plot (as a factor of AP)
            axsc = 1.3*fsurf/2
            nsplotH = 2.0e-7 # default near surface visualization distance
            if axsc*AP<2.0e-7:
                nsplotH = axsc*AP  
            
            ##             Display simulation progress in  MATLAB command window
            if CLUSTER==0 and showout==1:
                msg = format6001 % (J,I,Z,H,AFRACT)
                print(msg)
            
            ##
            I = I + 1 #COUNT THE NUMBER OF TRANSLATIONS
            PTIMEF = PTIMEF + dT #ADD TIME STEP TO TOTAL TIME
            #         CALCULATE ELAPSED TIME
            ETIME = ETIME + dT
            ##         RECORD PREVIOUS VALUES
            # No change here!!!!
            XO = X
            YO = Y
            ZO = Z
            HO = H
            IO = I - 1
            # TRANSLATE PARTICLE
            #         X = XO + UX*dT
            #         Y = YO + UY*dT
            #         Z = ZO + UZ*dT
            # define particle positions to simulate AFM approach
            # changed to ifs setting X,Y,Z to XO,YO,ZO or AXVECTOR deping on which axis is
            # normal via AXstring!!!!
            if AXstring=='x':
                Y = YO
                Z = ZO
                X = AXVECTOR[i]

            if AXstring=='y':
                X = XO
                Z = ZO
                Y = AXVECTOR[i]

            if AXstring=='z':
                X = XO
                Y = YO
                Z = AXVECTOR[i]

            # translaste colloid asperities array relative to colloid posiotion
            if RMODE==1 or RMODE==3:
                xcap = xcap0+X
                ycap = ycap0+Y
                zcap = zcap0+Z
            
            
            # CALCULATE RADIAL DISTANCE
            R = np.sqrt((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0)+(Z-Zm0)*(Z-Zm0))
            
            #   CALCULATE VERTICAL DEFORMATION AS FUNCTION OF R
            #   EQUATION OF LINE CONNECTING POINTS DELTA=0,Z=AP+HFRIC AND DELTA=DELTAMAX,Z=AP-DELTAMAX+HMIN (ADJUST TO INCLUDE ASPERITIES)
            if (RMODE==0):   #SMOOTH-SMOOTH INTERACTION
                DELTA = DELTAMAX*(R-AG-AP-HFRIC)/(HMIN-HFRIC-DELTAMAX)
            elif ((RMODE==1) or (RMODE==2)):  #SMOOTH-ROUGH INTERACTION
                if RMODE==1:
                    ASP = ASPcolloid
                else:
                    ASP = ASPdomain
                
                DELTA = DELTAMAX*(R-AG-AP-HFRIC-ASP)/(HMIN-HFRIC-DELTAMAX)
            elif (RMODE==3):  #ROUGH-ROUGH INTERACTION
                #             DELTA = DELTAMAX*(R-AG-AP-HFRIC-0.5*(2*ASP+3**0.5*ASP))/(HMIN-HFRIC-DELTAMAX)
                DELTA = DELTAMAX*(R-AG-AP-HFRIC-ASPcolloid-ASPdomain)/(HMIN-HFRIC-DELTAMAX)
            
            if (DELTA>DELTAMAX):
                DELTA = DELTAMAX
            
            if (DELTA<0.0):
                DELTA = 0.0
            
            #         CALCULATE CONTACT AREA
            ACONT = BETA*np.sqrt(2.0*AP*DELTA-DELTA**2.0)
            RZOI = np.sqrt(ACONT**2+2/KAPPA*(AP+np.sqrt(AP**2-ACONT**2)))
            RZOIAB = np.sqrt(ACONT**2+2*LAMBDAAB*(AP+np.sqrt(AP**2-ACONT**2)))
            ASPLIM = 0.5*np.sqrt(PI)*RZOI
            ASPLIMAB = 0.5*np.sqrt(PI)*RZOIAB
            # assing H from HVECTOR
            H = HVECTOR[i]
            # assing HS from HSMOOTH (smooth underlying surfce sep distance)
            HS = HSMOOTH[i]
            #
            DELTAV[i] = DELTA
            #         DETERMINE UNIT VECTORS
            ENX = (X-Xm0)/R
            ENY = (Y-Ym0)/R
            ENZ = (Z-Zm0)/R
            
        
            ##         INCREMENT BULK OR NEAR SURFACE TRAJECTORY TIME, TRACK PARTICLE TO STUCK INDICATOR if IN NEAR SURFACE DOMAIN
            if (H>2.0E-7):
                AFRACT = -1 #reset AFRACT if away from surface
                if (HFLAG==2):    #particle coming from near surface
                    TNEAR = TNEAR + dT
                    dT = MULTB*dTMRT #change dT after accumulating timestep from near surface
                    HFLAG = 1 #flag particle in bulk
                    if (IREF1>200): #calc NSVEL if near surf. res. time signific.
                        #         		  CALCULATE ENTRY AND EXIT PROJECTION ON GRAIN
                        ENXEP = Xm0+ENXENTER*AG
                        ENYEP = Ym0+ENYENTER*AG
                        ENZEP = Zm0+ENZENTER*AG
                        ENXP = Xm0+ENX*AG
                        ENYP = Ym0+ENY*AG
                        ENZP = Zm0+ENZ*AG
                        #DETERMINE CHORD TRAVELED IN NEAR SURFACE VISIT
                        CHORD = np.sqrt((ENXEP-ENXP)**2.0+(ENYEP-ENYP)**2.0+(ENZEP-ENZP)**2.0)
                        #DETERMINE ANGLE (THETA) BETWEEN PROJECTED ENTRY AND EXIT (RADIANS)
                        #= 2arcsin(c/2AG) where c is the chord and AG is the grain radius
                        #our chord is already normalized to AG so remove AG in above formula
                        #https://en.wikipedia.org/wiki/Circular_segment
                        NSTHETA =  2.0*(np.arcsin(CHORD/(2.0*AG))) # ANGLE IN RADIANS
                        NSARC = AG*NSTHETA
                        #ACCUMULATE DISTANCE TRAVELED IN NEAR SURFACE VISIT
                        NSDIST = NSDIST+NSARC
                        #CALCULATE AVERAGE NEAR SURFACE VELOCITY
                        NSVEL = NSDIST/TNEAR
                    
                    IREF1 = 0 #reset IREF1 if particle leaves near surface
                elif (HFLAG==1):
                    TBULK = TBULK+dT
                
            elif ((H<=2.0E-7) and (H>HFRIC)):   #H IS IN NEAR SURFACE
                if (HFLAG==1):    #particle is coming from bulk
                    TBULK = TBULK + dT
                    dT = MULTNS*dTMRT #change dT after accumulating timestep from bulk
                    HFLAG = 2 #flag particle in near surface
                    NSVISIT = NSVISIT + 1 #COUNT NUMBER OF VISITS TO NEAR SURFACE FROM BULK
                    #SET NORMAL UNIT VECTOR FOR ENTRANCE TO NEAR SURFACE FOR CALCULATING AVERAGE VELOCITY
                    ENXENTER = ENX
                    ENYENTER = ENY
                    ENZENTER = ENZ
                    RENTER = R
                    # activate near surface detailed plot only once
                    if NSplot==0:
                        NSplot = 1

                elif (HFLAG==3):    #particle is coming from friction
                    TFRIC = TFRIC + dT
                    dT = MULTNS*dTMRT #change dT after accumulating timestep from friction
                    HFLAG = 2 #flag particle in near surface
                    IREF2 = 0 #reset friction IREF
                    #SET NORMAL UNIT VECTOR FOR ENTRANCE TO NEAR SURFACE FOR CALCULATING AVERAGE VELOCITY
                    ENXENTER = ENX
                    ENYENTER = ENY
                    ENZENTER = ENZ
                    RENTER = R
                elif (HFLAG==2):    #particle is coming from near surface
                    TNEAR = TNEAR + dT #NEAR SURFACE RESIDENCE TIME
                    #                 NUMBER OF CONSECUTIVE TIME STEPS IN NEAR SURFACE
                    L = L+1
                    #                 CALCULATE AVERAGE NEAR-SURFACE SEPARATION DISTANCE
                    HSUM = H + HSUM
                    HAVE = HSUM/L
                    #CALCULATE AVERAGE NEAR SURFACE VELOCITY
                    #NOTE: BULK TANGENTIAL VELOCITY IS NOT INCLUDED EVEN if COLLOID CROSSES NEAR-SURFACE BOUNDARY MULTIPLE TIMES
                    #                  NSVEL = (NSDIST+0.5*(RENTER+R)*2*asin(0.5*((ENXENTER-ENX)**2.0+(ENYENTER-ENY)**2.0+(ENZENTER-ENZ)**2.0)**0.5))/TNEAR
                
                
                if (IREF1==0):    #IDENTifY REFERENCE POINT AND TIME
                    XREF1 = X
                    YREF1 = Y
                    ZREF1 = Z
                    TREF1 = 0.0
                    IREF1 = 1
                else:
                    IREF1 = IREF1 + 1
                    TREF1 = TREF1 + dT
                    if (IREF1>1000):
                        DREF1 = np.sqrt((X-XREF1)*(X-XREF1)+(Y-YREF1)*(Y-YREF1)+(Z-ZREF1)*(Z-ZREF1))  #COMPARE REFERENCE DISTANCE TO DifFUSION ONLY DISPLACEMENT
                        if (VN>VT):
                            DCOEF = FUN1
                        else:
                            DCOEF = FUN4
                        
                        DIND3 = np.sqrt(6.0*DCOEF*KB*T*TREF1/M3)
                        DIND1 = DFACTNS*np.sqrt(6.0*DCOEF*KB*T*TREF1/M3) #SCALE DISPLACEMENT TO DifFUSION (WITHOUT DIFFSCALE)
                        if ((DREF1<DIND1) and (H>5*HFRIC)) or (abs(Z+R)<=AP/2): #DON'T FORCE REMAIN DURING DETACH OR TAG AS REMAIN IF AT REAR FLOW STAG ZONE

                            ATTACHK = 5 #RETENTION WITHOUT CONTACT IN NEAR SURFACE
                        else:
                            IREF1 = 0

            elif ((H<=2.0E-7) and (H<=HFRIC)):    #particle is in friction
                if (HFLAG==2):   #particle coming from near surface
                    TNEAR = TNEAR + dT
                    dT = MULTC*dTMRT #change dT after accumulating timestep from near surface
                    HFLAG = 3 #flag particle in friction
                    if (IREF1>200):
                        #         		  CALCULATE ENTRY AND EXIT PROJECTION ON GRAIN
                        ENXEP = Xm0+ENXENTER*AG
                        ENYEP = Ym0+ENYENTER*AG
                        ENZEP = Zm0+ENZENTER*AG
                        ENXP = Xm0+ENX*AG
                        ENYP = Ym0+ENY*AG
                        ENZP = Zm0+ENZ*AG
                        #DETERMINE CHORD TRAVELED IN NEAR SURFACE VISIT
                        CHORD = np.sqrt((ENXEP-ENXP)**2.0+(ENYEP-ENYP)**2.0+(ENZEP-ENZP)**2.0)
                        #DETERMINE ANGLE (THETA) BETWEEN PROJECTED ENTRY AND EXIT (RADIANS)
                        #= 2arcsin(c/2AG) where c is the chord and AG is the grain radius
                        #our chord is already normalized to AG so remove AG in above formula
                        #https://en.wikipedia.org/wiki/Circular_segment
                        NSTHETA =  2.0*(np.arcsin(CHORD/(2.0*AG))) # ANGLE IN RADIANS
                        NSARC = AG*NSTHETA
                        #ACCUMULATE DISTANCE TRAVELED IN NEAR SURFACE VISIT
                        NSDIST = NSDIST+NSARC
                        #CALCULATE AVERAGE NEAR SURFACE VELOCITY
                        NSVEL = NSDIST/TNEAR
                    
                    FRICVISIT = FRICVISIT + 1 #count number of visits to friction
                elif (HFLAG==3):
                    TFRIC = TFRIC + dT #friction residence time

                if (H<H0):
                    ATTACHK = 6 #Flag if particle runs into surface

                if (ATTMODE==0):   #attachment by perfect sink
                    ATTACHK = 2
                else: #TORQUE BALANCE MODE FOR ATTACHMENT AND DETACHMENT
                    if ((UT==0.0) and (ARRESTFLAG==1)):   #UR=0.0 AND COLLOID HAS REACHED EQUILIBRIUM SEPARATION (FADH~FREP)
                        ATTACHK = 2 #PARTICLE ARRESTS

                    if (IREF2==0):    #IDENTifY REFERENCE POINT AND TIME
                        XREF2 = X
                        YREF2 = Y
                        ZREF2 = Z
                        TREF2 = 0.0
                        IREF2 = 1
                    else:
                        IREF2 = IREF2 + 1
                        TREF2 = TREF2 + dT
                        if (IREF2>30):    #COMPARE REFERENCE DISTANCE TO DifFUSION ONLY DISPLACEMENT
                            DREF2 = np.sqrt((X-XREF2)*(X-XREF2)+(Y-YREF2)*(Y-YREF2)+(Z-ZREF2)*(Z-ZREF2))
                            if (VN>VT):
                                DCOEF = FUN1
                            else:
                                DCOEF = FUN4

                            DIND2 = DFACTC*np.sqrt(6.0*DCOEF*KB*T*TREF2/M3) #SCALE DISPLACEMENT TO DifFUSION (WITHOUT DIFFSCALE)
                            if (DREF2<DIND2):
                                ATTACHK = 4 #RETENTION WITH CONTACT
                            else:
                                IREF2 = 0                  
                     #FOR if IREF2==0
                 #FOR ATTMODE==0
             #FOR H<2.0E-7


            ##         EXIT CONDITION if PARTICLE IS IN BULK FLUID
            # Exit only lower hemisphere if gravity align with flow
            if (R>RB)and(Z<0.0)and(cbPZ==1 or cbMZ==1):
                ATTACHK = 1
            
            # reflect if in upper hemisphere
            # if (R>RB)and(Z>=0.0)and(cbPZ==1orcbMZ==1)
            #     X=XO
            #     Y=YO
            #     Z=ZO
            
            # Exit any hemisphere after 5# of ZINIT if gravity orthogonal to flow
            if (R>RB)and(Z<ZINIT*0.95)and(cbPX==1 or cbMX==1):
                ATTACHK = 1
            
            #         FINISH TRAJECTORY if PARTICLE STILL IN THE SYSTEM WHEN TOTAL TIME IS REACHED (NO STAGNANT)
            if (PTIMEF>TTIME):
                ATTACHK = 3
            
            #         SKIP FORCE AND INTEGRATION if PARTICLE RESOLVES
            #         if (ATTACHK==0)
            #             DETERMINE UNIT VECTORS
            ENX = (X-Xm0)/R
            ENY = (Y-Ym0)/R
            ENZ = (Z-Zm0)/R
            #             DETERMINE FORCES
            #             CALCULATE GRAVITATIONAL FORCE
            FG=af.AFMGRAVITY(GRAVFACT,AP,G,RHOP,RHOW,PI)
            #
            ##            CALCULATE COLLOIDAL FORCE
            #             USED SPHERE-SPHERE GEOMETRY (VIOLATES LINEAR APROXIMATION APPROACH,
            #             REASONABLE FOR LARGE COLLECTOR RADII)
            #             CALCULATE EDL
            
            #   FAVORABLE CONDITIONS IF BULK ZETAC AND ZETAP ARE OPPOSITE IN SIGN, THEN SET SCOV = 0.0 AND SCOVP = 0.0
            if ((ZETACST>=0.0 and ZETAPST<=0.0) or (ZETACST<=0.0 and ZETAPST>=0.0)):
                SCOV = 0.0
                SCOVP = 0.0
            
            #   UNDER UNFAVORABLE CONDITIONS HETERODOMIANS WILL BE SIMULATED IN EITHER COLLECTOR (HETC), OR COLLOID (HETP), OR BOTH
            #   TO CALCULATE HETC AND HETP FRACTIONAL AREAS WITHIN ZOI, HETERODOMAINS WILL BE PROJECTED ONTO THE FRAME OF REFERENCE
            #   WITH X-Y PLANE MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER
            if ((SCOV>0.0 or SCOVP>0.0) and I==1):
                #   CALCULATE PROJECTION OF COLLOID CENTER ON HAPPEL SPHERE
                XG = Xm0+ENX*AG
                YG = Ym0+ENY*AG
                ZG = Zm0+ENZ*AG
                AFRACT = 0.0
                #   CALCULATE COLLOID RADIAL POSITION - SPHERICAL COORDINATES AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
                RO = np.sqrt((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0)+(Z-Zm0)*(Z-Zm0))
                #   CALCULATE COLLOID THETA ANGLE - SPHERICAL COORDINATES AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
                THETA = np.arccos((Z-Zm0)/RO)
                #   CALCULATE PROJECTION OF COLLOID POSITION ON XY PLANE
                ROXY = np.sqrt((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0))
                #   CALCULATE COLLOID PHI ANGLE - SPHERICAL COORDINATES AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
                if (ROXY==0.0):
                    PHI = 0.0
                else:
                    if ((Y-Ym0)>=0.0):
                        PHI = np.arccos((X-Xm0)/ROXY)
                    else:
                        PHI = 2.0*np.pi-np.arccos((X-Xm0)/ROXY)


                #   HETEROGENEITY ON COLLOID (HETP) SUBROUTINE TO DETERMINE HETERODOMAIN PROJECTIONS
                #   HETP PROJECTIONS WILL BE GENERATED ASSUMING THAT THE COLLOID CENTER COINCIDES WITH THE HAPPEL SPHERE CENTER
                #   MHETP CONTAINS HETP COORDINATES AND RADII(FORMAT: [XHETP YHETP ZHET RHETP])
                #   MPRO CONTAINS HETP PROJECTION COORDINATES AND RADII(FORMAT: [XPRO YPRO ZPRO RPRO])
                MHETP, MPRO=af.AFMHETTRACKP(Xm0,Ym0,Zm0,H,RZOIBULK,AP,HETMODEP,SCOVP,RHETP0,RHETP1)
                #   HETP WILL BE TRANSLATED TO THE COLLECTOR FRAME OF REFERENCE AND
                #   ROTATED BASED ON COLLOID SPHERICAL COORDINATES, FOR FRONT-END PLOTTING
                #   HETP PROJECTIONS WILL BE TRANSLATED AND ROTATED TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING
                #   THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER, TO CALCULATE AFRACT
                MHETP_PLOT,MPRO_AF = af.AFMHETP_TRANSFORM(X,Y,Z,XG,YG,ZG,THETA,PHI,MHETP,MPRO, SCOVP)
            elif ((SCOV>0.0 or SCOVP>0.0) and I>1): #and(or(SCOV>0.0,SCOVP>0.0),I==1)
                #   CALCULATE PROJECTION OF COLLOID CENTER ON HAPPEL SPHERE
                XG = Xm0+ENX*AG
                YG = Ym0+ENY*AG
                ZG = Zm0+ENZ*AG
                # reste afract value only if single_afract is deactivated
                if het_afract_calculated==0:
                    AFRACT = 0.0
                
                #   CALCULATE COLLOID RADIAL POSITION - SPHERICAL COORDINATES AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
                RO = np.sqrt((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0)+(Z-Zm0)*(Z-Zm0))
                #   CALCULATE COLLOID THETA ANGLE - SPHERICAL COORDINATES AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
                THETA = np.arccos((Z-Zm0)/RO)
                #   CALCULATE PROJECTION OF COLLOID POSITION ON XY PLANE
                ROXY = np.sqrt((X-Xm0)*(X-Xm0)+(Y-Ym0)*(Y-Ym0))
                #   CALCULATE COLLOID PHI ANGLE - SPHERICAL COORDINATES AS USED IN PHYSICS (ISO 80000-2:2019 CONVENTION)
                if (ROXY==0.0):
                    PHI = 0.0
                else:
                    if ((Y-Ym0)>=0.0):
                        PHI = np.arccos((X-Xm0)/ROXY)
                    else:
                        PHI = 2.0*np.pi-np.arccos((X-Xm0)/ROXY)


                #   HETEROGENEITY ON COLLOID (HETP) SUBROUTINE TO DETERMINE HETERODOMAIN PROJECTIONS
                #   HETP PROJECTIONS WILL BE GENERATED ASSUMING THAT THE COLLOID CENTER COINCIDES WITH THE HAPPEL SPHERE CENTER
                #   HETP WILL BE TRANSLATED TO THE COLLECTOR FRAME OF REFERENCE AND
                #   ROTATED BASED ON COLLOID SPHERICAL COORDINATES, FOR FRONT-END PLOTTING
                #   HETP PROJECTIONS WILL BE TRANSLATED AND ROTATED TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING
                #   THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER, TO CALCULATE AFRAC
                MHETP_PLOT,MPRO_AF = af.AFMHETP_TRANSFORM(X,Y,Z,XG,YG,ZG,THETA,PHI,MHETP,MPRO, SCOVP)
             #and(or(SCOV>0.0,SCOVP>0.0),I==1)
            #   CALCULATE HETERODOMAINS INFLUENCE
            if ((SCOV>0.0 or SCOVP>0.0) and HFLAG>1):
                # if single calculation fro afract is toggled, calculate afract
                # once -  AFM simulation
                if het_afract_calculated ==0:
                    #   HETEROGENEITY ON COLLECTOR (HETC) SUBROUTINE TO DETERMINE CLOSEST HETERODOMAIN TO COLLOID
                    #   HETC WILL BE TRANSLATED TO THE FRAME OF REFERENCE WITH X-Y PLANE MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER
                    if (SCOV>0.0):
                        #                     if J==10
                        #                         disp('stop')
                        #                     
                        XHET,YHET,ZHET,RHET = af.AFMHETTRACK(X,Y,Z,Xm0,Ym0,Zm0,AG,HETMODE,SCOV,RHET0,RHET1,RHET2,0)
                        XHET_AF,YHET_AF,ZHET_AF = af.AFMHETC_TRANSFORM(XG,YG,ZG,THETA,PHI,XHET,YHET,ZHET)
                        RHET_AF = RHET
                    else:
                        XHET_AF = 0.0
                        YHET_AF = 0.0
                        ZHET_AF = 0.0
                        RHET_AF = 0.0
                    
                    #   INITIALIZE FRACTIONAL AREAS
                    AFRACT = 0.0 #TOTAL ATTRACTIVE FRACTIONAL AREA
                    AFRACT_PZ = 0.0 #PRO-ZOI FRACTIONAL AREA
                    AFRACT_ZH = 0.0 #ZOI-HET FRACTIONAL AREA
                    AFRACT_PZH = 0.0 #PRO-ZOI-HET FRACTIONAL AREA
                    AFRACT_Z = 0.0 #ZOI FRACTIONAL AREA NON-OVERLAPPED
                    #   CALCULATE OVERLAPING AREA OF HETERODOMAINS AND ZOI
                    #   GIVEN THAT THE PROJECTION OF COLLOID CENTER CORRESPONDS TO THE ORIGIN OF THE FRAME OF REFERENCE WITH X-Y PLANE
                    #   MATCHING THE PLANE PARALLEL TO THE HAPPEL SPHERE AT THE POINT OF PROJECTION OF THE COLLOID CENTER, VARIABLES
                    #   EQUAL TO 0.0 MUST BE PASSED TO THE FIRST TWO POSITIONS OF SUBROUTINE FRACTIONAL_AREA
                    AF_PZ,AF_ZH,AF_PZH,AF_Z = af.AFMAREAFRACT(Xm0,Ym0,RZOI,Xm0,Ym0,Zm0,MPRO_AF[:,[0,1,3]])
                    AFRACT = AF_PZ
                    AFRACT_PZ = AF_PZ
                    for K in range(HETMODE):
                        matlab_k = K + 1
                        AF_PZ,AF_ZH,AF_PZH,AF_Z = af.AFMAREAFRACT(Xm0,Ym0,RZOI,XHET_AF[K],YHET_AF[K],RHET_AF[K],MPRO_AF[:,[0,1,3]])
                        AFRACT = AFRACT + AF_ZH #TOTAL ATTRACTIVE FRACTIONAL AREA
                        if (AF_ZH >= 0.0):
                            AFRACT = AFRACT - AF_PZH #TOTAL ATTRACTIVE FRACTIONAL AREA
                            AFRACT_PZ = AFRACT_PZ - AF_PZH #PRO-ZOI FRACTIONAL AREA
                        
                        AFRACT_ZH = AFRACT_ZH + AF_ZH #ZOI-HET FRACTIONAL AREA
                        AFRACT_PZH = AFRACT_PZH + AF_PZH #PRO-ZOI-HET FRACTIONAL AREA
                        AFRACT_Z = 1 - AFRACT_PZ - AFRACT_ZH - AFRACT_PZH #ZOI FRACTIONAL AREA NON-OVERLAPPED
                        if (AF_ZH>0.0 and matlab_k==1):
                            HETTYPE = 1
                        
                        if (HETMODE==5 or HETMODE==9):
                            if ((AF_ZH>0.0) and (HETTYPE==0) and (matlab_k>1)):
                                HETTYPE = 2

                            if ((AF_ZH>0.0) and (HETTYPE==1) and (matlab_k>1)):
                                HETTYPE = 4
                            
                        elif (HETMODE==73):
                            if ((AF_ZH>0.0) and (HETTYPE==0) and (matlab_k>1 and matlab_k<=9)):
                                HETTYPE = 2
                            
                            if ((AF_ZH>0.0) and (HETTYPE==0) and (matlab_k>9)):
                                HETTYPE = 3

                            if ((AF_ZH>0.0) and (HETTYPE==1) and (matlab_k>1 and matlab_k<=9)):
                                HETTYPE = 4

                            if ((AF_ZH>0.0) and (HETTYPE==1) and (matlab_k>9)):
                                HETTYPE = 5

                            if ((AF_ZH>0.0) and (HETTYPE==2) and (matlab_k>9)):
                                HETTYPE = 6
                    
                    # allow afract calculation only to happens once
                    # reset flag
                    if single_afract==1:
                        het_afract_calculated =1

                if (AFRACT>0.0):
                    #CALCULATE PRO-ZOI ATTRACTIVE CONTRIBUTION TO EDL FORCE
                    ZETAC = ZETACST
                    ZETAP = ZETAHETP
                    #FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI)
                    FEDL=af.AFMFORCEEDL(KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,
                                        NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,
                                        zasp_domain,LTLT, af.AFM_asp_tracking_RMODE3)
                    
                    FEDL_PZ = FEDL
                    #CALCULATE ZOI-HET ATTRACTIVE CONTRIBUTION TO EDL FORCE
                    ZETAC = ZETAHET
                    ZETAP = ZETAPST
                    #FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI)
                    FEDL=af.AFMFORCEEDL(KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,
                                        NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,
                                        zasp_domain, LTLT, af.AFM_asp_tracking_RMODE3)
                    FEDL_ZH = FEDL
                    #CALCULATE PRO-ZOI-HET REPULSIVE CONTRIBUTION TO EDL FORCE
                    ZETAC = ZETAHET
                    ZETAP = ZETAHETP
                    #FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI)
                    FEDL=af.AFMFORCEEDL(KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,
                                        NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,
                                        zasp_domain, LTLT, af.AFM_asp_tracking_RMODE3)
                    FEDL_PZH = FEDL
                    #CALCULATE ZOI REPULSIVE CONTRIBUTION TO EDL FORCE
                    ZETAC = ZETACST
                    ZETAP = ZETAPST
                    #FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI)
                    FEDL=af.AFMFORCEEDL(KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,
                                        NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,
                                        zasp_domain, LTLT, af.AFM_asp_tracking_RMODE3)
                    FEDL_Z = FEDL
                    #CALCULATE NET EDL FORCE
                    FEDL =  AFRACT_PZ*FEDL_PZ + AFRACT_ZH*FEDL_ZH + AFRACT_PZH*FEDL_PZH + AFRACT_Z*FEDL_Z
                else: #(AFRACT>0.0)
                    ZETAC = ZETACST
                    ZETAP = ZETAPST
                    #FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI)
                    FEDL=af.AFMFORCEEDL(KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,
                                         NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,
                                         zasp_domain,LTLT, af.AFM_asp_tracking_RMODE3)


                 #(AFRACT>0.0)
            else: #and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
                ZETAC = ZETACST
                ZETAP = ZETAPST
                #FEDL= AFMFORCEEDL (KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASP,NASP,RMODE,H,PI)
                FEDL=af.AFMFORCEEDL(KAPPA,KB,ERE0,T,ZI,ECHG,ZETAC,ZETAP,AG,AP,ASPcolloid,ASPdomain,
                                    NASP,RMODE,H,HS,PI,X,Y,Z,xcap,ycap,zcap,xasp_domain,yasp_domain,
                                    zasp_domain, LTLT,af.AFM_asp_tracking_RMODE3)

             #and(or(SCOV>0.0,SCOVP>0.0),HFLAG>1)
            #
            #   CALCULATE VDW
            #         FVDW=AFMFORCEVDW (A132,AG,AP,ASP,NASP,RMODE,H,LAMBDAVDW,A11,...
            #             A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE)
            FVDW,FVDW2,Hasp_colloid,Hasp_domain= af.AFMFORCEVDW(X,Y,Z,A132,AG,AP,ASPcolloid,ASPdomain,
                                                                NASP,RMODE,xcap,ycap,zcap,xasp_domain,
                                                                yasp_domain,zasp_domain,H,HS,LAMBDAVDW,
                                                                A11,A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE,
                                                                LTLT, af.AFM_asp_tracking_RMODE3)

            #   CALCULATE ACID-BASE, BORN, AND STERIC REPULSION
            #         FAB= AFMFORCEAB (PI,AG,AP,ASP,NASPAB,RMODE,LAMBDAAB,GAMMA0AB,H,H0)
            FAB= af.AFMFORCEAB(PI,AG,AP,ASPcolloid,ASPdomain,RMODE,LAMBDAAB,GAMMA0AB,H,H0,X,Y,Z,xcap,ycap,
                               zcap,xasp_domain,yasp_domain,zasp_domain, LTLT, af.AFM_asp_tracking_RMODE3)

            #             FAB = 0.0 #!!debugEP
            #   CALCULATE BORN FORCE
            FBORN=af. AFMFORCEBORN(A132,SIGMAC,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE)
            FSTE=af.AFMFORCESTE(PI,GAMMA0STE,LAMBDASTE,ASTE,H)
            FSTEVEC[i]=FSTE
            #   CALCULATE COLLOIDAL FORCE
            FCOLL = FVDW + FEDL + FAB + FSTE + FBORN


            ##             CALCULATE DifFUSION FORCE
            [FDIFX,FDIFY,FDIFZ]=af.AFMFORCEDIFF(DIFFSCALE,PI,VISC,AP,KB,T,dT)
            if (H<=HFRIC):
                # DifFUSION FORCES EQUAL TO ZERO IN CONTACT
                FDIFX=0.0
                FDIFY=0.0
                FDIFZ=0.0
            
            ##          CALCULATE LifT FORCE
            FLifT=af.AFMFORCELIFT(RHOW,R,AP,AG,VT,UT,OMEGA)
            ##          BREAK FORCES INTO CARTESIAN COMPONENTS
            #           WHEN EXAMINING NORMAL AND TANGENTIAL: POSITIVE NORMAL IS AWAY FROM THE SURFACE,
            #           NEGATIVE NORMAL IS TOWARDS THE SURFACE
            #           GRAVITATIONAL
            # Gravity counter-current with flow
            if cbPZ==1:
                FGN=-FG*abs(ENZ)
                FGNX=FGN*abs(ENX)
                FGNY=FGN*ENY
                FGNZ=FGN*ENZ
                FGTX=0.0-FGNX
                FGTY=0.0-FGNY
                FGTZ=-FG-FGNZ     
            
            # Gravity concurrent with flow
            if cbMZ==1:
                FGN=FG*abs(ENZ)
                FGNX=FGN*abs(ENX)
                FGNY=FGN*ENY
                FGNZ=FGN*ENZ
                FGTX=0.0-FGNX
                FGTY=0.0-FGNY
                FGTZ=FG-FGNZ
            
            # Gravity orthogonal to flow (+x)
            if cbPX==1:
                FGN=-FG*abs(ENX)
                FGNX=FGN*abs(ENX)
                FGNY=FGN*ENY
                FGNZ=FGN*ENZ
                FGTX=-FG-FGNX
                FGTY=0.0-FGNY
                FGTZ=0.0-FGNZ
            
            # Gravity orthogonal to flow (-x)
            if cbMX==1:
                FGN=FG*abs(ENX)
                FGNX=FGN*abs(ENX)
                FGNY=FGN*ENY
                FGNZ=FGN*ENZ
                FGTX=FG-FGNX
                FGTY=0.0-FGNY
                FGTZ=0.0-FGNZ
            
            #             COLLOIDAL
            FCOLLX=FCOLL*ENX
            FCOLLY=FCOLL*ENY
            FCOLLZ=FCOLL*ENZ
            #             DRIVING DRAG FORCE
            #             FDRGNX=FDRGN*ENX
            #             FDRGNY=FDRGN*ENY
            #             FDRGNZ=FDRGN*ENZ
            #             FDRGTX=FDRGT*ETX
            #             FDRGTY=FDRGT*ETY
            #             FDRGTZ=FDRGT*ETZ
            #             FDRGX = FDRGNX + FDRGTX
            #             FDRGY = FDRGNY + FDRGTY
            #             FDRGZ = FDRGNZ + FDRGTZ
            #            LifT
            FLifTX=FLifT*ENX
            FLifTY=FLifT*ENY
            FLifTZ=FLifT*ENZ
            #           DifFUSION FORCES OPERATE WHEN NOT IN CONTACT
            FDifN=FDIFX*ENX+FDIFY*ENY+FDIFZ*ENZ
            FDifNX=FDifN*ENX
            FDifNY=FDifN*ENY
            FDifNZ=FDifN*ENZ
            FDifTX=(FDIFX-FDifNX)
            FDifTY=(FDIFY-FDifNY)
            FDifTZ=(FDIFZ-FDifNZ)
            
            ## save forces to matrices
            OUTCOUNT = i
            IOT[OUTCOUNT,J] = I
            XOT[OUTCOUNT,J] = X
            YOT[OUTCOUNT,J] = Y
            ZOT[OUTCOUNT,J] = Z
            ROT[OUTCOUNT,J] = R
            HOT[OUTCOUNT,J] = H
            HSOT[OUTCOUNT,J] = HS
            ETIMEOT[OUTCOUNT,J] = ETIME
            PTIMEFOT[OUTCOUNT,J] = PTIMEF
            FCOLLOT[OUTCOUNT,J] = FCOLL
            FVDWOT[OUTCOUNT,J] = FVDW
            FEDLOT[OUTCOUNT,J] = FEDL
            FDRGXOT[OUTCOUNT,J] = FDRGX
            FDRGYOT[OUTCOUNT,J] = FDRGY
            FDRGZOT[OUTCOUNT,J] = FDRGZ
            FDIFXOT[OUTCOUNT,J] = FDIFX
            FDIFYOT[OUTCOUNT,J] = FDIFY
            FDIFZOT[OUTCOUNT,J] = FDIFZ
            FABOT[OUTCOUNT,J] = FAB
            FSTEOT[OUTCOUNT,J] = FSTE
            FBORNOT[OUTCOUNT,J] = FBORN
            FDRGTOT[OUTCOUNT,J] = FDRGT
            UTOT[OUTCOUNT,J] = UT
            UNOT[OUTCOUNT,J] = UN
            VTOT[OUTCOUNT,J] = VT
            VNOT[OUTCOUNT,J] = VN
            FDRGNOT[OUTCOUNT,J] = FDRGN
            FGTOT[OUTCOUNT,J] = FGT
            FGNOT[OUTCOUNT,J] = FGN
            FLIFTOT[OUTCOUNT,J] = FLifT
            ACONTOT[OUTCOUNT,J] = ACONT
            RZOIOT[OUTCOUNT,J] = RZOI
            UXOT[OUTCOUNT,J] = UX
            UYOT[OUTCOUNT,J] = UY
            UZOT[OUTCOUNT,J] = UZ
            VXOT[OUTCOUNT,J] = VX
            VYOT[OUTCOUNT,J] = VY
            VZOT[OUTCOUNT,J] = VZ
            AFRACTOT[OUTCOUNT,J] = AFRACT

            completed_steps = (
                J * nsteps
                + i
                + 1
            )

            total_steps = (
                NPARTLOOP
                * nsteps
            )

            progress = (
                completed_steps
                / total_steps
            )

            progress_percent = int(
                progress * 100
            )

            if (
                progress_callback is not None
                and progress_percent
                != last_progress_percent
            ):
                progress_callback(
                    progress
                )

                last_progress_percent = (
                    progress_percent
                )
                        
        ##       WRITE ARRAY TO FILES
        
        ## save  hetdomains in AFMdomain to matrices
        rangeHetV[J] = len(XHET)
        mxhetOUT[:int(rangeHetV[J]),J]=XHET
        myhetOUT[:int(rangeHetV[J]),J]=YHET
        mzhetOUT[:int(rangeHetV[J]),J]=ZHET
        mrhetOUT[:int(rangeHetV[J]),J]=RHET

    if progress_callback is not None:
        progress_callback(1.0)
       
    ## calculate etas
    eta2 = ceta2/((NPARTLOOP)*RB**2/RLIM**2)
    eta4 = ceta4/((NPARTLOOP)*RB**2/RLIM**2)
    eta5 = ceta5/((NPARTLOOP)*RB**2/RLIM**2)
    eta6 = ceta6/((NPARTLOOP)*RB**2/RLIM**2)

    ## probe and hetdomain locations
    # get rzoi vector
    rzoiaux =RZOIOT[-1,:]
    #
    # changed xaux and yaux to LAT1aux and LAT2aux to separate from x and y!!!!
    # changed ifs to use AXstring to obtain correct xaux and yaux!!!!
    if AXstring=='x':
        LAT1aux = YOT[0,:]
        LAT2aux = ZOT[0,:]
    if AXstring=='y':
        LAT1aux = XOT[0,:]
        LAT2aux = ZOT[0,:]
    if AXstring=='z':
        LAT1aux = XOT[0,:]
        LAT2aux = YOT[0,:]

    afaux = AFRACTOT[-1,:]
    # convert any negative afract to zero
    afaux[afaux<0]=0

    # plot hetdomains on AFMdomain
    if AXstring=='x':
        mxhetPLOT = myhetOUT
        myhetPLOT = mzhetOUT
    if AXstring=='y':
        mxhetPLOT = mxhetOUT
        myhetPLOT = mzhetOUT
    if AXstring=='z':
        mxhetPLOT= mxhetOUT
        myhetPLOT = myhetOUT

    ## OUTPUTS
    if RMODE in (2, 3):
        roughness_results = {
            "RMODE": int(RMODE),
            "ASPdomain": float(ASPdomain),
            "X": mat_asp_domx[:, :NPARTLOOP].copy(),
            "Y": mat_asp_domy[:, :NPARTLOOP].copy(),
            "Z": mat_asp_domz[:, :NPARTLOOP].copy(),
            "count": range_mat_asp[:NPARTLOOP].copy(),
        }
    else:
        roughness_results = {
            "RMODE": int(RMODE),
            "ASPdomain": float(ASPdomain),
            "X": np.empty((0, NPARTLOOP), dtype=float),
            "Y": np.empty((0, NPARTLOOP), dtype=float),
            "Z": np.empty((0, NPARTLOOP), dtype=float),
            "count": np.zeros(NPARTLOOP, dtype=int),
        }



    output_sheets = af.build_matlab_output_sheets(
    # General parameters
        NPART=NPART,
        RLIM=RLIM,
        AP=AP,
        RHOP=RHOP,
        RHOW=RHOW,
        VISC=VISC,
        ER=ER,
        T=T,
        IS=IS,
        ZI=ZI,
        ZETAPST=ZETAPST,
        ZETACST=ZETACST,

        # Domain/probe heterogeneity
        ZETAHET=ZETAHET,
        HETMODE=HETMODE,
        RHET0=RHET0,
        RHET1=RHET1,
        RHET2=RHET2,
        SCOV=SCOV,
        ZETAHETP=ZETAHETP,
        HETMODEP=HETMODEP,
        RHETP0=RHETP0,
        RHETP1=RHETP1,
        SCOVP=SCOVP,

        # van der Waals / roughness
        A132=A132,
        LAMBDAVDW=LAMBDAVDW,
        VDWMODE=VDWMODE,
        B=B,
        RMODE=RMODE,

        # Keep this explicit until we confirm MATLAB RMODE 1/2/3 behavior.
        asperity_height=(
            None
            if RMODE == 0
            else ASPcolloid
        ),

        # Coated systems
        A11=A11,
        AC1C1=AC1C1,
        A22=A22,
        AC2C2=AC2C2,
        A33=A33,
        T1=T1,
        T2=T2,

        # Acid-base / steric / contact
        GAMMA0AB=GAMMA0AB,
        LAMBDAAB=LAMBDAAB,
        GAMMA0STE=GAMMA0STE,
        LAMBDASTE=LAMBDASTE,
        KINT=KINT,
        W132=W132,
        BETA=BETA,

        # Probe locations
        LAT1V=LAT1V,
        LAT2V=LAT2V,

        # Force profiles
        HVECTOR=HVECTOR,
        FCOLLOT=FCOLLOT,
        FVDWOT=FVDWOT,
        FEDLOT=FEDLOT,
        FABOT=FABOT,
        FSTEOT=FSTEOT,
        FBORNOT=FBORNOT,

        # # Histograms
        # centersBar=centersBar,
        # Ybar=Ybar,
        # centersPri=centersPri,
        # Ypri=Ypri,

        # # Raw barrier / minimum data
        # barFdisc=barFdisc,
        # HbarFdisc=HbarFdisc,
        # LAT1barFdisc=LAT1barFdisc,
        # LAT2barFdisc=LAT2barFdisc,
        # priFdisc=priFdisc,
        # HpriFdisc=HpriFdisc,
        # LAT1priFdisc=LAT1priFdisc,
        # LAT2priFdisc=LAT2priFdisc,

        # Heterodomain matrices
        mxhetPLOT=mxhetPLOT,
        myhetPLOT=myhetPLOT,
        mrhetOUT=mrhetOUT,
    )

    results = {
        "metadata": {
            "NPART": int(NPART),
            "NPARTLOOP": int(NPARTLOOP),
            "RLIM": float(RLIM),
            "RMODE": int(RMODE),
            "SCOV": float(SCOV),
            "AXstring": AXstring,
            "HMIN": float(HMIN),
            "HFRIC": float(HFRIC),
            "Hlow": float(Hlow),
            "Hhigh": float(Hhigh),
        },

        "force": {
            "H": HOT[:nsteps, :NPARTLOOP].copy(),
            "H_reference": HVECTOR.copy(),
            "FCOLL": FCOLLOT[:nsteps, :NPARTLOOP].copy(),
            "FVDW": FVDWOT[:nsteps, :NPARTLOOP].copy(),
            "FEDL": FEDLOT[:nsteps, :NPARTLOOP].copy(),
            "FAB": FABOT[:nsteps, :NPARTLOOP].copy(),
            "FSTE": FSTEOT[:nsteps, :NPARTLOOP].copy(),
            "FBORN": FBORNOT[:nsteps, :NPARTLOOP].copy(),
        },
        "probes": {
            "LAT1": LAT1aux[:NPARTLOOP].copy(),
            "LAT2": LAT2aux[:NPARTLOOP].copy(),
            "LAT1_initial": LAT1V[:NPARTLOOP].copy(),
            "LAT2_initial": LAT2V[:NPARTLOOP].copy(),

            # Why: arrays are preallocated beyond the calculated rows.
            "RZOI": RZOIOT[nsteps - 1, :NPARTLOOP].copy(),
            "AFRACT": AFRACTOT[nsteps - 1, :NPARTLOOP].copy(),
        },
        "heterodomains": {
            "X": mxhetPLOT[:, :NPARTLOOP].copy(),
            "Y": myhetPLOT[:, :NPARTLOOP].copy(),
            "radius": mrhetOUT[:, :NPARTLOOP].copy(),
            "count": rangeHetV[:NPARTLOOP].copy(),
        },
        "roughness": roughness_results,
        "output_sheets": output_sheets,
    }
    return results


def get_default_analysis_limits(
    results: dict,
) -> tuple[float, float, float]:
    """Return the same initial analysis limits used by the GUI."""

    if "metadata" not in results:
        raise KeyError(
            "results does not contain the 'metadata' section."
        )

    metadata = results["metadata"]

    required_keys = (
        "HMIN",
        "HFRIC",
        "Hlow",
        "Hhigh",
    )

    missing_keys = [
        key
        for key in required_keys
        if key not in metadata
    ]

    if missing_keys:
        raise KeyError(
            "Missing simulation metadata: "
            + ", ".join(missing_keys)
        )

    hmin = float(
        metadata["HMIN"]
    )

    hfric = float(
        metadata["HFRIC"]
    )

    hlow = float(
        metadata["Hlow"]
    )

    hhigh = float(
        metadata["Hhigh"]
    )

    separation_limit = (
        hlow
        - hmin
        + hfric
    )

    primary_max_h = separation_limit
    barrier_min_h = separation_limit
    barrier_max_h = hhigh

    return (
        primary_max_h,
        barrier_min_h,
        barrier_max_h,
    )


def resolve_analysis_limits(
    results: dict,
    *,
    primary_max_h: float | None = None,
    barrier_min_h: float | None = None,
    barrier_max_h: float | None = None,
) -> tuple[float, float, float]:
    """Resolve optional standalone analysis limits."""

    (
        default_primary_max_h,
        default_barrier_min_h,
        default_barrier_max_h,
    ) = get_default_analysis_limits(
        results
    )

    if primary_max_h is None:
        primary_max_h = (
            default_primary_max_h
        )

    if barrier_min_h is None:
        barrier_min_h = (
            default_barrier_min_h
        )

    if barrier_max_h is None:
        barrier_max_h = (
            default_barrier_max_h
        )

    primary_max_h = float(
        primary_max_h
    )

    barrier_min_h = float(
        barrier_min_h
    )

    barrier_max_h = float(
        barrier_max_h
    )

    if primary_max_h <= 0.0:
        raise ValueError(
            "Primary minimum maximum separation "
            "must be greater than zero."
        )

    if barrier_min_h <= 0.0:
        raise ValueError(
            "Barrier minimum separation "
            "must be greater than zero."
        )

    if barrier_max_h <= barrier_min_h:
        raise ValueError(
            "Barrier maximum separation must be greater "
            "than barrier minimum separation."
        )

    return (
        primary_max_h,
        barrier_min_h,
        barrier_max_h,
    )


def console_progress(
    progress: float,
) -> None:
    """Display AFM simulation progress in the console."""

    progress = max(
        0.0,
        min(
            1.0,
            float(progress),
        ),
    )

    print(
        f"\rSimulation progress: "
        f"{progress * 100:5.1f} %",
        end="",
        flush=True,
    )


def run_standalone(
    *,
    base_output_path: str | Path,
    folder_name: str = "AFM_run",
    import_from_file: bool = True,
    input_file: str | Path | None = None,
    primary_max_h: float | None = None,
    barrier_min_h: float | None = None,
    barrier_max_h: float | None = None,
    save_excel: bool = True,
    show_figures: bool = True,
    show_analysis_figures: bool = True,
) -> tuple[dict, dict, dict, Path]:
    """
    Run the complete AFM workflow without the GUI.

    The workflow includes simulation, force-extrema analysis,
    Excel output, force profiles, ZOI geometry, histograms,
    and heatmaps.
    """

    # --------------------------------------------------------
    # Output directory
    # --------------------------------------------------------

    workdir = af.create_folder(
        base_output_path,
        folder_name,
    )

    output_file = (
        workdir
        / "output_AFM_python.xlsx"
    )

    # --------------------------------------------------------
    # Simulation inputs
    # --------------------------------------------------------

    dict_input = get_default_inputs(
        workdir=workdir
    )

    if import_from_file:
        if input_file is None:
            input_file = input(
                "Enter the path to the input file: "
            )

        dict_input = af.import_afm_inputs(
            input_file,
            base_inputs=dict_input,
        )

    # --------------------------------------------------------
    # AFM simulation
    # --------------------------------------------------------

    print(
        "\nStarting AFM simulation..."
    )

    start_time = time.perf_counter()

    results = AFM_happel(
        **dict_input,
        progress_callback=console_progress,
    )

    elapsed_time = (
        time.perf_counter()
        - start_time
    )

    print()

    print(
        f"Simulation completed in "
        f"{elapsed_time:.2f} seconds."
    )

    # --------------------------------------------------------
    # Analysis limits
    # --------------------------------------------------------

    (
        primary_max_h,
        barrier_min_h,
        barrier_max_h,
    ) = resolve_analysis_limits(
        results,
        primary_max_h=primary_max_h,
        barrier_min_h=barrier_min_h,
        barrier_max_h=barrier_max_h,
    )

    print(
        "\nAnalysis limits:"
        f"\n  Primary maximum H: {primary_max_h:.6e} m"
        f"\n  Barrier minimum H: {barrier_min_h:.6e} m"
        f"\n  Barrier maximum H: {barrier_max_h:.6e} m"
    )

    # --------------------------------------------------------
    # Barrier / primary-minimum analysis
    # --------------------------------------------------------

    analysis = (
        afm_plot.analyze_force_profiles(
            results,
            barrier_min_h=barrier_min_h,
            barrier_max_h=barrier_max_h,
            primary_max_h=primary_max_h,
        )
    )

    results["analysis"] = analysis

    has_barrier = analysis.get(
        "has_barrier",
        bool(
            np.any(
                np.isfinite(
                    analysis[
                        "barrier_force"
                    ]
                )
            )
        ),
    )

    has_primary_minimum = analysis.get(
        "has_primary_minimum",
        bool(
            np.any(
                np.isfinite(
                    analysis[
                        "primary_force"
                    ]
                )
            )
        ),
    )

    if not has_barrier:
        print(
            "\nWARNING: No barrier detected. "
            "Barrier heatmap and histogram are disabled."
        )

    if not has_primary_minimum:
        print(
            "\nWARNING: No primary minimum detected. "
            "Primary-minimum heatmap and histogram "
            "are disabled."
        )

    # Add analysis data to Excel output
  
    af.add_analysis_output_sheets(
        results["output_sheets"],
        analysis,
    )

    # Save Excel
    if save_excel:
        af.save_output(
            results["output_sheets"],
            output_file,
        )

        print(
            f"\nAFM data saved to:\n"
            f"{output_file}"
        )

    # Figures
    figures = {}

    matplotlib_figures_created = False


    # ------------------------------------------------------------
    # Force profiles + ZOI
    # ------------------------------------------------------------

    if show_figures:
        print(
            "\nGenerating force-profile and ZOI figures..."
        )

        # Plotly figure.
        # This opens in the browser and does not control
        # Matplotlib's event loop.
        figures["force_profiles"] = (
            afm_plot.plot_force_profiles(
                results,
                show=True,
            )
        )

        # Create the ZOI figure, but DO NOT call plt.show() yet.
        figures["probe_locations"] = (
            afm_plot.plot_probe_locations(
                results,
                show=False,
            )
        )

        matplotlib_figures_created = True


    # ------------------------------------------------------------
    # Histograms + heatmaps
    # ------------------------------------------------------------

    if show_analysis_figures:
        print(
            "\nGenerating histograms and heatmaps..."
        )

        # Create all Matplotlib analysis figures first.
        analysis_figures = (
            afm_plot.plot_analysis_data(
                analysis,
                show=False,
            )
        )

        figures.update(
            analysis_figures
        )

        # Some analysis figures can legitimately be None
        # when no barrier or primary minimum was detected.
        if any(
            figure is not None
            for figure in analysis_figures.values()
        ):
            matplotlib_figures_created = True


    # ------------------------------------------------------------
    # Show all Matplotlib figures together
    # ------------------------------------------------------------

    if matplotlib_figures_created:
        plt.show()


    return (
        results,
        analysis,
        figures,
        output_file,
    )
        
    

if __name__ == "__main__":

    # --------------------------------------------------------
    # Input source
    #--------------------------------------------------------
    # True:
    #     read simulation parameters from an Excel file.
    #
    # False:
    #     use/change the default parameters stablished in get_default_inputs() method in line 10.

    IMPORT_FROM_FILE = False
    # --------------------------------------------------------
    
    # None asks for the path in the terminal.
    #
    # Or write it directly:
    #
    # INPUT_FILE = (
    #     r"C:\Users\001_output_AFM.xlsx"
    # )

    INPUT_FILE = None

    # --------------------------------------------------------
    # OUTPUTS
    # --------------------------------------------------------
    # excel output with all the data and analysis
    SAVE_EXCEL = False
    # Force profiles + ZOI
    SHOW_FIGURES = True
    # Histograms + heatmaps
    SHOW_ANALYSIS_FIGURES = False

    # --------------------------------------------------------
    # Output path and folder name
    # --------------------------------------------------------

    BASE_OUTPUT_PATH = (
        r"C:\Users\aliso\OneDrive\Desktop\hap-py\AFM"
    )

    FOLDER_NAME = "AFM_run"

    # --------------------------------------------------------
    # Analysis separation limits
    # --------------------------------------------------------
    # None = use the calculated default limits based on the simulation parameters.
    #
    # primary/barrier minimum =
    #     Hlow - HMIN + HFRIC
    #
    # barrier maximum =
    #     Hhigh
    #
    # To override them, write a float instead.

    PRIMARY_MAX_H = None
    BARRIER_MIN_H = None
    BARRIER_MAX_H = None

    # Example:
    #
    # PRIMARY_MAX_H = 5.685e-9
    # BARRIER_MIN_H = 5.685e-9
    # BARRIER_MAX_H = 5.0021e-7

    # --------------------------------------------------------
    # Complete standalone workflow
    # --------------------------------------------------------

    (
        results,
        analysis,
        figures,
        output_file,
    ) = run_standalone(
        base_output_path=BASE_OUTPUT_PATH,
        folder_name=FOLDER_NAME,
        import_from_file=IMPORT_FROM_FILE,
        input_file=INPUT_FILE,
        primary_max_h=PRIMARY_MAX_H,
        barrier_min_h=BARRIER_MIN_H,
        barrier_max_h=BARRIER_MAX_H,
        save_excel=SAVE_EXCEL,
        show_figures=SHOW_FIGURES,
        show_analysis_figures=SHOW_ANALYSIS_FIGURES
    )



