"""
traj_jet2.py  —  Fresh port of TRAJ-JET.for (HAPHETLN / 3DJETLN)
Minimal, faithful translation.  No added infrastructure beyond what
the Fortran does.  Single-file, no Numba, no status hooks.
Reads INPUT_jet.IN (same format as Fortran INPUT.IN).
"""

import math
import random
import sys
import os

# ── Physical constants ────────────────────────────────────────────────────────
PI    = math.pi
G_G   = 9.80665
E0    = 8.85418781762e-12
ECHG  = 1.602176634e-19
KB    = 1.380649e-23
NA    = 6.02214076e23

# ── Hardwired ─────────────────────────────────────────────────────────────────
RJET   = 5.0e-4
ZMAX   = 1.25e-3
H0     = 0.158e-9
SIGMAC = 5.0e-10
OUTMAX = 50000
HNS    = 2.0e-7    # Near-surface zone threshold (hardwired for jet; read from input for hap)

# ── Random helpers ────────────────────────────────────────────────────────────
def generate_unif():
    v = [random.random() for _ in range(6)]
    rs1 = 1.0 if v[0] >= 0.5 else -1.0
    rs2 = 1.0 if v[2] >= 0.5 else -1.0
    rs3 = 1.0 if v[4] >= 0.5 else -1.0
    return rs1, v[1], rs2, v[3], rs3, v[5]

def calc_ni(bigni):
    """Piecewise polynomial Gaussian quantile (ported from Fortran)."""
    p = bigni - 0.5
    if abs(p) <= 0.42:
        r = p * p
        return (p * ((((-25.4410604963*r + 41.3911977353)*r
                       - 18.6150006252)*r + 2.5066282388))
                / ((((3.13082909833*r - 21.0622410182)*r
                     + 23.0833674374)*r - 8.47351093090)*r + 1.0))
    else:
        r = bigni if p < 0.0 else 1.0 - bigni
        r = math.sqrt(-math.log(r))
        result = (((2.32121276858*r + 4.85014127135)*r
                   - 2.29796479134)*r - 2.78718931138) \
                 / ((1.63706781897*r + 3.54388924762)*r + 1.0)
        return -result if p < 0.0 else result

# ── Force subroutines ─────────────────────────────────────────────────────────

def force_vdw(A132, AP, ASP, NASP, RMODE, H, LAMBDAVDW,
              A11, A22, A33, AC1C1, AC2C2, T1, T2, VDWMODE):
    A12   = A11**0.5 * A22**0.5
    A1C2  = A11**0.5 * AC2C2**0.5
    A13   = A11**0.5 * A33**0.5
    AC12  = AC1C1**0.5 * A22**0.5
    AC1C2 = AC1C1**0.5 * AC2C2**0.5
    AC13  = AC1C1**0.5 * A33**0.5
    A23   = A22**0.5 * A33**0.5
    AC23  = AC2C2**0.5 * A33**0.5

    if VDWMODE == 1:
        if RMODE == 0:
            return -(A132*AP/(6.0*H**2)) * (LAMBDAVDW/(LAMBDAVDW + 5.32*H))
        elif RMODE == 1:
            H2    = H + ASP
            FVDW1 = -(A132*AP/(6.0*H2**2)) * (LAMBDAVDW/(LAMBDAVDW + 5.32*H2))
            FVDW2 = (-(A132*ASP/(6.0*H**2)) * (LAMBDAVDW/(LAMBDAVDW + 5.32*H))
                     if H <= ASP else 0.0)
            return FVDW1 + NASP*FVDW2
        elif RMODE == 2:
            H2    = H + ASP
            FVDW1 = -(A132*AP/(6.0*H2**2)) * (LAMBDAVDW/(LAMBDAVDW + 5.32*H2))
            FVDW2 = (-(A132*ASP*AP/(6.0*(ASP+AP)*H**2)) * (LAMBDAVDW/(LAMBDAVDW + 5.32*H))
                     if H <= ASP else 0.0)
            return FVDW1 + NASP*FVDW2
        else:  # RMODE==3
            H2    = H + 0.5*(2*ASP + 3**0.5*ASP)
            FVDW1 = -(A132*AP/(6.0*H2**2)) * (LAMBDAVDW/(LAMBDAVDW + 5.32*H2))
            FVDW2 = (-(A132*ASP*ASP/(6.0*(ASP+ASP)*H**2)) * (LAMBDAVDW/(LAMBDAVDW + 5.32*H))
                     if H <= ASP else 0.0)
            return FVDW1 + 2.5*NASP*FVDW2

    lam = LAMBDAVDW
    if VDWMODE == 2:
        f  = -(AC1C2-AC23-AC13+A33)
        f *= ((lam/(lam+11.12*H) *
               ((AP+T1)/H**2 - 1/H + (AP+T1)/(H+2*T1+2*AP)**2 + 1/(H+2*T1+2*AP))
               + 11.12*lam/(lam+11.12*H)**2 *
               ((AP+T1)/H + (AP+T1)/(H+2*T1+2*AP) + math.log(H/(H+2*T1+2*AP))))/6)
        f -= (A1C2-AC1C2-A13+AC13) * (
               (lam/(lam+11.12*(H+T1)) *
               (AP/(H+T1)**2 - 1/(H+T1) + AP/(H+T1+2*AP)**2 + 1/(H+T1+2*AP))
               + 11.12*lam/(lam+11.12*(H+T1))**2 *
               (AP/(H+T1) + AP/(H+T1+2*AP) + math.log((H+T1)/(H+T1+2*AP))))/6)
        f -= (AC12-A23-AC1C2+AC23) * (
               (lam/(lam+11.12*(H+T2)) *
               ((AP+T1)/(H+T2)**2 - 1/(H+T2) + (AP+T1)/(H+2*T1+T2+2*AP)**2 + 1/(H+2*T1+T2+2*AP))
               + 11.12*lam/(lam+11.12*(H+T2)**2) *
               ((AP+T1)/(H+T2) + (AP+T1)/(H+2*T1+T2+2*AP) + math.log((H+T2)/(H+2*T1+T2+2*AP))))/6)
        f -= (A12-AC12-A1C2+AC1C2) * (
               (lam/(lam+11.12*(H+T1+T2)) *
               (AP/(H+T1+T2)**2 - 1/(H+T1+T2) + AP/(H+T1+T2+2*AP)**2 + 1/(H+T1+T2+2*AP))
               + 11.12*lam/(lam+11.12*(H+T1+T2))**2 *
               (AP/(H+T1+T2) + AP/(H+T1+T2+2*AP) + math.log((H+T1)/(H+T1+2*AP))))/6)
        return f
    if VDWMODE == 3:
        f  = -(A1C2-AC23-A13+A33) * (
               (lam/(lam+11.12*H) *
               (AP/H**2 - 1/H + AP/(H+2*AP)**2 + 1/(H+2*AP))
               + 11.12*lam/(lam+11.12*H)**2 *
               (AP/H + AP/(H+2*AP) + math.log(H/(H+2*AP))))/6)
        f -= (A12-A23-A1C2+AC23) * (
               (lam/(lam+11.12*(H+T2)) *
               (AP/(H+T2)**2 - 1/(H+T2) + AP/(H+T2+2*AP)**2 + 1/(H+T2+2*AP))
               + 11.12*lam/(lam+11.12*(H+T2))**2 *
               (AP/(H+T2) + AP/(H+T2+2*AP) + math.log((H+T2)/(H+T2+2*AP))))/6)
        return f
    if VDWMODE == 4:
        f  = -(AC12-A23-AC13+A33) * (
               (lam/(lam+11.12*H) *
               ((AP+T1)/H**2 - 1/H + (AP+T1)/(H+2*T1+2*AP)**2 + 1/(H+2*T1+2*AP))
               + 11.12*lam/(lam+11.12*H)**2 *
               ((AP+T1)/H + (AP+T1)/(H+2*T1+2*AP) + math.log(H/(H+2*T1+2*AP))))/6)
        f -= (A12-AC12-A13+AC13) * (
               (lam/(lam+11.12*(H+T1)) *
               (AP/(H+T1)**2 - 1/(H+T1) + AP/(H+T1+2*AP)**2 + 1/(H+T1+2*AP))
               + 11.12*lam/(lam+11.12*(H+T1))**2 *
               (AP/(H+T1) + AP/(H+T1+2*AP) + math.log((H+T1)/(H+T1+2*AP))))/6)
        return f
    return 0.0


def force_edl(KAPPA, KB_, ERE0_, T_, ZI, ECHG_, ZETAC, ZETAP,
              AP, ASP, NASP, RMODE, H):
    J_ = 1.0 - (PI/4.0)
    def coef_sp(zc, zp, r):
        return (64.0*PI*ERE0_*(KB_*T_/ZI/ECHG_)**2
                * math.tanh(ZI*ECHG_*zc/4/KB_/T_)
                * math.tanh(ZI*ECHG_*zp/4/KB_/T_)
                * ((KAPPA*r - 1)*math.exp(-KAPPA*H)
                   + (KAPPA*r + 1)*math.exp(-KAPPA*(H + 2*r))))
    def coef_ss(zc, zp, r1, r2):
        return (64.0*PI*ERE0_*r1*r2/(r1+r2)*(KB_*T_/ZI/ECHG_)**2
                * math.tanh(ZI*ECHG_*zc/4/KB_/T_)
                * math.tanh(ZI*ECHG_*zp/4/KB_/T_)
                * KAPPA*math.exp(-KAPPA*H))
    if RMODE == 0:
        FEDL = coef_sp(ZETAC, ZETAP, AP)
    elif RMODE == 1:
        H2    = H + ASP
        FEDL1 = (64.0*PI*ERE0_*(KB_*T_/ZI/ECHG_)**2
                 * math.tanh(ZI*ECHG_*ZETAC/4/KB_/T_)
                 * math.tanh(ZI*ECHG_*ZETAP/4/KB_/T_)
                 * ((KAPPA*AP - 1)*math.exp(-KAPPA*H2)
                    + (KAPPA*AP + 1)*math.exp(-KAPPA*(H2 + 2*AP))))
        FEDL2 = (coef_sp(ZETAC, ZETAP, ASP) if H <= ASP else 0.0)
        FEDL  = J_*FEDL1 + NASP*FEDL2
    elif RMODE == 2:
        H2    = H + ASP
        FEDL1 = (64.0*PI*ERE0_*(KB_*T_/ZI/ECHG_)**2
                 * math.tanh(ZI*ECHG_*ZETAC/4/KB_/T_)
                 * math.tanh(ZI*ECHG_*ZETAP/4/KB_/T_)
                 * ((KAPPA*AP - 1)*math.exp(-KAPPA*H2)
                    + (KAPPA*AP + 1)*math.exp(-KAPPA*(H2 + 2*AP))))
        FEDL2 = (coef_ss(ZETAC, ZETAP, ASP, AP) if H <= ASP else 0.0)
        FEDL  = J_*FEDL1 + NASP*FEDL2
    else:  # RMODE==3
        H2    = H + 0.5*(2*ASP + 3**0.5*ASP)
        FEDL1 = (64.0*PI*ERE0_*(KB_*T_/ZI/ECHG_)**2
                 * math.tanh(ZI*ECHG_*ZETAC/4/KB_/T_)
                 * math.tanh(ZI*ECHG_*ZETAP/4/KB_/T_)
                 * ((KAPPA*AP - 1)*math.exp(-KAPPA*H2)
                    + (KAPPA*AP + 1)*math.exp(-KAPPA*(H2 + 2*AP))))
        FEDL2 = (coef_ss(ZETAC, ZETAP, ASP, ASP) if H <= ASP else 0.0)
        FEDL  = J_*FEDL1 + 2.5*NASP*FEDL2
    if abs(FEDL) < 1.0e-30:
        FEDL = 0.0
    return FEDL


def force_ab(AP, ASP, NASPAB, RMODE, LAMBDAAB, GAMMA0AB, H):
    if RMODE == 0:
        return (2*PI*AP*GAMMA0AB*math.exp(-(H-H0)/LAMBDAAB)
                * (1 - LAMBDAAB/AP + (1 + LAMBDAAB/AP)*math.exp(-2*AP/LAMBDAAB)))
    elif RMODE == 1:
        if H <= ASP:
            FAB1 = (2*PI*ASP*GAMMA0AB*math.exp(-(H-H0)/LAMBDAAB)
                    * (1 - LAMBDAAB/ASP + (1 + LAMBDAAB/ASP)*math.exp(-2*ASP/LAMBDAAB)))
        else:
            FAB1 = 0.0
        return NASPAB*FAB1
    elif RMODE == 2:
        AEFF  = 2*(ASP*AP)/(ASP+AP)
        LOWG  = 1 - LAMBDAAB/AEFF + (1 + LAMBDAAB/AEFF)*math.exp(-2*AEFF/LAMBDAAB)
        HIGHG = (1 - LAMBDAAB/AEFF + LAMBDAAB**2/(2*AEFF**2)
                 - (4*AEFF/(3*LAMBDAAB))*math.exp(-2*AEFF/LAMBDAAB)
                 - (1 + LAMBDAAB/AEFF + LAMBDAAB**2/(2*AEFF**2))*math.exp(-4*AEFF/LAMBDAAB))
        COEFF = (1 - ASP/AP)*LOWG + ASP/AP*HIGHG
        FAB1  = (COEFF*PI*AEFF*GAMMA0AB*math.exp(-(H-H0)/LAMBDAAB) if H <= ASP else 0.0)
        return NASPAB*FAB1
    else:  # RMODE==3
        COEFF = (1 - LAMBDAAB/ASP + LAMBDAAB**2/(2*ASP**2)
                 - (4*ASP/(3*LAMBDAAB))*math.exp(-2*ASP/LAMBDAAB)
                 - (1 + LAMBDAAB/ASP + LAMBDAAB**2/(2*ASP**2))*math.exp(-4*ASP/LAMBDAAB))
        FAB1  = (COEFF*PI*ASP*GAMMA0AB*math.exp(-(H-H0)/LAMBDAAB) if H <= ASP else 0.0)
        return 2.5*NASPAB*FAB1


def force_born(A132, AP, H, A11, A22, A33, AC1C1, AC2C2, VDWMODE):
    A1C2  = A11**0.5 * AC2C2**0.5
    A13   = A11**0.5 * A33**0.5
    AC12  = AC1C1**0.5 * A22**0.5
    AC1C2 = AC1C1**0.5 * AC2C2**0.5
    AC13  = AC1C1**0.5 * A33**0.5
    A23   = A22**0.5 * A33**0.5
    AC23  = AC2C2**0.5 * A33**0.5
    base  = (SIGMAC**6/1260) * ((7*AP - H)/H**8 + (9*AP + H)/(2*AP + H)**8)
    if   VDWMODE == 1: return A132 * base
    elif VDWMODE == 2: return (AC1C2 - AC23 - AC13 + A33) * base
    elif VDWMODE == 3: return (A1C2  - AC23 - A13  + A33) * base
    else:              return (AC12  - A23  - AC13 + A33) * base


def force_ste(GAMMA0STE, LAMBDASTE, ASTE, H):
    return GAMMA0STE/LAMBDASTE * math.exp(-H/LAMBDASTE) * PI * ASTE**2


def force_drag(FUN2, FUN3, FUN4, M3, VZ, VR):
    FDRGR = FUN3/FUN4 * M3 * VR
    FDRGZ = FUN2 * M3 * VZ
    return FDRGR, FDRGZ


def force_diff(DIFFSCALE, VISC, AP, T_, dT):
    rs1,rn1,rs2,rn2,rs3,rn3 = generate_unif()
    rn1 = rn1*0.4771 + 0.5
    rn2 = rn2*0.4771 + 0.5
    rn3 = rn3*0.4771 + 0.5
    scale = DIFFSCALE * (12.0*PI*AP*VISC*KB*T_/dT)**0.5
    FDIFZ = scale * calc_ni(rn1) * rs1
    FDIFX = scale * calc_ni(rn2) * rs2
    FDIFY = scale * calc_ni(rn3) * rs3
    return FDIFX, FDIFY, FDIFZ


def gravity(GRAVFACT, AP, RHOP, RHOW):
    return GRAVFACT * (4.0/3.0)*PI*(AP**3)*(RHOP - RHOW)*G_G


def force_lift(RHOW, Z, AP, VR, UR, OMEGA):
    if Z > 100.0*AP:
        return 0.0
    KS    = VR/Z if Z != 0 else 0.0
    lnzap = math.log(Z/AP)
    LS  = math.exp(2.221 + 1.565*lnzap + 0.06602*lnzap**2)
    LR  = math.exp(-1.0*(0.6390 + 1.408*lnzap)/(1.0 - 0.1036*lnzap + 0.01136*lnzap**2))
    LT  = ((1.751 + 6.147*lnzap + 3.299*lnzap**2 - 2.485*lnzap**3 + 1.952*lnzap**4)
           / (1.0 + 3.714*lnzap + 1.481*lnzap**2 - 1.278*lnzap**3 + 1.0905*lnzap**4))
    LRT = (-lnzap*(10.97 + 439.4*lnzap + 355.0*lnzap**2 + 171.6*lnzap**3)
           / (1.0 + 7.309*lnzap + 284.7*lnzap**2 + 86.45*lnzap**3 + 77.45*lnzap**4))
    LSR = math.exp((-4.723 - 11.11*lnzap + 41.76*lnzap**2)/(1.0 + 20.31*lnzap))
    LST = (-10.76 - 2.158*lnzap - 4.218*lnzap**2)/(1.0 - 0.1749*lnzap)
    return RHOW*AP**2 * ((AP*KS)**2*LS + (AP*OMEGA)**2*LR + UR**2*LT
                          + (AP*OMEGA*UR)*LRT + (AP**2*OMEGA*KS)*LSR
                          + (AP*KS*UR)*LST)


# ── Heterodomain helpers ──────────────────────────────────────────────────────

def clamp_acos(arg):
    return math.acos(max(-1.0, min(1.0, arg)))

def clamp_asin(arg):
    return math.asin(max(-1.0, min(1.0, arg)))

def circle_overlap_area(R1, R2, D):
    if D >= R1 + R2: return 0.0
    if D <= abs(R1 - R2): return PI * min(R1, R2)**2
    R1_2=R1**2; R2_2=R2**2; D_2=D**2
    A1 = clamp_acos((D_2+R1_2-R2_2)/(2*D*R1))
    A2 = clamp_acos((D_2+R2_2-R1_2)/(2*D*R2))
    return R1_2*A1 + R2_2*A2 - 0.5*((-D+R1+R2)*(D+R1-R2)*(D-R1+R2)*(D+R1+R2))**0.5


def hettrack(X, Y, RZOI, HETMODE, SCOV, RHET0, RHET1):
    """Determine heterodomain positions on collector surface near colloid.
    Supports HETMODE=1 (uniform, large only) and HETMODE=9 (1 large + 8 medium).
    Faithfully ported from Fortran HETTRACK subroutine.
    """
    XHET=[0.0]*100; YHET=[0.0]*100; RHET=[0.0]*100
    HM1 = 8.0 if HETMODE==9 else 0.0
    SCOV0 = SCOV*(RHET0**2)/(RHET0**2 + HM1*RHET1**2) if HM1>0 else SCOV
    NHET0 = round(SCOV0*(RJET**2)/(RHET0**2))
    NHETREAL0 = float(NHET0)
    NRING = round((NHETREAL0/3.1)**0.5)
    NRINGREAL = float(NRING)
    DTHETA = RJET/(NRINGREAL-1.0) if NRINGREAL > 1 else RJET
    ARCL = DTHETA
    ROXY = (X**2+Y**2)**0.5
    THETAP = ROXY
    if ROXY == 0.0:
        PHIP = 0.0
    else:
        PHIP = clamp_acos(X/ROXY) if Y >= 0.0 else 2.0*PI - clamp_acos(X/ROXY)
    NTHETA = round(THETAP/DTHETA) + 1

    if NTHETA == 1:
        # At axis
        for J in range(1, HETMODE+1):
            if J == 1:
                XHET[J-1]=0.0; YHET[J-1]=0.0; RHET[J-1]=RHET0
            else:
                # HETMODE=9: 8 medium domains at axis at PI/4 spacing
                THETA1 = 1.0/3.0*DTHETA
                PHI1 = (J-2)/4.0*PI
                XHET[J-1] = THETA1*math.cos(PHI1)
                YHET[J-1] = THETA1*math.sin(PHI1)
                RHET[J-1] = RHET1
    else:
        # Not at axis — match Fortran exactly
        THETA  = (NTHETA-1)*DTHETA
        RRING  = THETA
        NHETRING_raw = round(2.0*PI*RRING/ARCL)
        NHRINGREAL   = float(NHETRING_raw)
        NHETRING     = max(NHETRING_raw, 3)
        DPHI  = 2.0*PI/NHRINGREAL
        # PHIOFF: alternating ±10% of DPHI based on odd/even ring number
        M_ = NTHETA % 2
        PHIOFF = 0.1*DPHI if M_ == 0 else -0.1*DPHI
        # Snap PHI to nearest grid point including offset
        PHI = DPHI*(round((PHIP - PHIOFF)/DPHI)) + PHIOFF
        DTHETA1 = 1.0/9.0*DTHETA

        for J in range(1, HETMODE+1):
            if J == 1:
                XHET[J-1] = RRING*math.cos(PHI)
                YHET[J-1] = RRING*math.sin(PHI)
                RHET[J-1] = RHET0
            elif HETMODE == 9:
                # 8 medium domains with J-dependent radial/azimuthal offsets (Fortran HETMODE=9)
                M = J % 2
                if M != 0:
                    RRING1 = RRING + math.cos((J-1)/2*PI) * (1.0/3.0*DTHETA)
                    PHI1   = PHI   + math.cos((1.0/16.0*J**2 - 9.0/16.0)*PI) * (1.0/3.0*DPHI)
                else:
                    RRING1 = RRING + math.cos((1.0/24.0*J**3 - 9.0/16.0*J**2 + 65.0/24.0*J - 2.5)*PI) * (1.0/3.0*DTHETA)
                    PHI1   = PHI   + math.cos(J/2*PI) * (1.0/3.0*DPHI)
                XHET[J-1] = RRING1*math.cos(PHI1)
                YHET[J-1] = RRING1*math.sin(PHI1)
                RHET[J-1] = RHET1
    return XHET, YHET, RHET


def hettrackp(X, Y, Z, RZOI, AP, HETMODEP, SCOVP, RHETP0, RHETP1):
    """Generate and project heterodomains on colloid surface."""
    XmP0=X; YmP0=Y; ZmP0=Z
    RPL=RZOI+RHETP0; ZU=AP+ZmP0; ZL=ZmP0
    HMODEREAL=float(HETMODEP)
    OMEGA0=RHETP0/AP; OMEGA1=RHETP1/AP if RHETP1>0 else 0.0
    DAP=AP*(1-math.cos(OMEGA0))
    RPRO0=AP*math.sin(OMEGA0)
    RPRO1=AP*math.sin(OMEGA1) if OMEGA1>0 else 0.0
    if HETMODEP==1:
        SCOVP0=SCOVP
    else:
        SCOVP0=SCOVP*((1.0-math.cos(OMEGA0))/
                      ((1.0-math.cos(OMEGA0))+(HMODEREAL-1.0)*(1.0-math.cos(OMEGA1))))
    NHETP0=round(SCOVP0*4.0/(2.0*(1.0-math.cos(OMEGA0))))
    NHETREAL0=float(NHETP0)
    NRING=max(round((NHETREAL0/1.3)**0.5),2)
    NRINGREAL=float(NRING)
    DTHETA=PI/(NRINGREAL-1.0)
    ARCL=DTHETA*AP
    XPRO_list=[]; YPRO_list=[]; RPRO_list=[]

    def add_het(XHET,YHET,ZHET,RHET_h,THETA,PHI,RPRO_val):
        RDHET=((XHET-XmP0)**2+(YHET-YmP0)**2)**0.5
        ARG=max(-1.0,min(1.0,(ZmP0-ZHET)/AP))
        BETA=math.acos(ARG)
        if ZL<=ZHET<=ZU or RDHET>=RPL:
            XPRO_list.append(0.0); YPRO_list.append(0.0); RPRO_list.append(0.0)
        else:
            DC=DAP*math.sin(BETA)
            XPRO_list.append(XHET-DC*math.cos(PHI))
            YPRO_list.append(YHET-DC*math.sin(PHI))
            A_e=RPRO_val; B_e=RPRO_val*math.cos(BETA)
            RPRO_list.append((A_e*B_e)**0.5)

    for i in range(1,NRING+1):
        THETA=(i-1)*DTHETA
        if i==1 or i==NRING:
            THETA=0.0 if i==1 else PI
            for j in range(1,HETMODEP+1):
                if j==1:
                    XHET=XmP0; YHET=YmP0; ZHET=AP*math.cos(THETA)+ZmP0
                    add_het(XHET,YHET,ZHET,RHETP0,THETA,0.0,RPRO0)
                else:
                    THETA1=THETA+1.0/3.0*DTHETA; R1=AP*math.sin(THETA1)
                    PHI1=(j-2)*PI/4.0  # HETMODEP=9: 8 medium domains at PI/4 spacing
                    XHET=R1*math.cos(PHI1)+XmP0; YHET=R1*math.sin(PHI1)+YmP0
                    ZHET=AP*math.cos(THETA1)+ZmP0
                    add_het(XHET,YHET,ZHET,RHETP1,THETA1,PHI1,RPRO1)
        else:
            RRING=AP*math.sin(THETA)
            NHETRING=max(round(2*PI*RRING/ARCL),1)
            DPHI=2.0*PI/NHETRING
            for k in range(NHETRING):
                PHI=k*DPHI
                for j in range(1,HETMODEP+1):
                    if j==1:
                        XHET=RRING*math.cos(PHI)+XmP0; YHET=RRING*math.sin(PHI)+YmP0
                        ZHET=AP*math.cos(THETA)+ZmP0
                        add_het(XHET,YHET,ZHET,RHETP0,THETA,PHI,RPRO0)
                    else:
                        THETA1=THETA+1.0/3.0*DTHETA; R1=AP*math.sin(THETA1)
                        PHI1=PHI+(j-2)*PI/4.0  # HETMODEP=9: 8 medium domains at PI/4 spacing
                        XHET=R1*math.cos(PHI1)+XmP0; YHET=R1*math.sin(PHI1)+YmP0
                        ZHET=AP*math.cos(THETA1)+ZmP0
                        add_het(XHET,YHET,ZHET,RHETP1,THETA1,PHI1,RPRO1)

    NPRO_idx=[i for i,r in enumerate(RPRO_list) if r!=0.0]
    NPRO=len(NPRO_idx)
    if NPRO==0:
        M_PRO=[[0.0,0.0,0.0]]
    else:
        M_PRO=[[XPRO_list[i],YPRO_list[i],RPRO_list[i]] for i in NPRO_idx]
    return NPRO, M_PRO


def fractional_area(XP, YP, RZOI, XHET, YHET, RHET_h, M_PRO):
    """Calculate fractional overlap areas for EDL heterogeneity weighting."""
    RZ=RZOI; RH=RHET_h
    DZH=((XHET-XP)**2+(YHET-YP)**2)**0.5
    SUMRZH=RZ+RH; DIFFRZH=RZ-RH
    NPRO=len(M_PRO)
    if DZH>SUMRZH: OM_ZH=0
    elif abs(DIFFRZH)>=DZH: OM_ZH=-1
    else: OM_ZH=1
    Ao2_2=circle_overlap_area(RZ,RH,DZH)
    Ao2_PZ=[0.0]*NPRO; Ao3_F=[0.0]*NPRO; Ao2_ZH_per=[0.0]*NPRO
    for i in range(NPRO):
        rx=M_PRO[i][0]; ry=M_PRO[i][1]; rr=M_PRO[i][2]
        dist_pz=((rx-XP)**2+(ry-YP)**2)**0.5
        dist_ph=((rx-XHET)**2+(ry-YHET)**2)**0.5
        def otype(d,sR,dR):
            if d>=sR: return 0
            elif d>abs(dR): return 1
            else: return -1
        APZ=otype(dist_pz,rr+RZ,rr-RZ)
        APH=otype(dist_ph,rr+RH,rr-RH)
        AZH=OM_ZH
        Ao2_1_pz=circle_overlap_area(rr,RZ,dist_pz)
        Ao2_1_ph=circle_overlap_area(rr,RH,dist_ph)
        if APZ==1 and APH==1:
            if AZH==0:
                Ao2_PZ[i]=Ao2_1_pz
            elif AZH==1:
                Ao3_F[i]=min(Ao2_1_pz,Ao2_1_ph,Ao2_2)
                Ao2_PZ[i]=Ao2_1_pz-Ao3_F[i]; Ao2_ZH_per[i]=Ao2_2-Ao3_F[i]
            else:  # AZH==-1
                if RZ>=RH:
                    Ao3_F[i]=Ao2_1_ph; Ao2_PZ[i]=Ao2_1_pz-Ao3_F[i]; Ao2_ZH_per[i]=Ao2_2-Ao3_F[i]
                else:
                    Ao3_F[i]=Ao2_1_pz; Ao2_ZH_per[i]=Ao2_2-Ao3_F[i]
        elif APZ==1 and APH==-1:
            if AZH==0:
                Ao2_PZ[i]=Ao2_1_pz
            else:
                if RH>=rr:
                    Ao3_F[i]=Ao2_1_pz; Ao2_ZH_per[i]=Ao2_2-Ao3_F[i]
                else:
                    Ao3_F[i]=Ao2_2; Ao2_PZ[i]=Ao2_1_pz-Ao3_F[i]
        elif APZ==-1 and APH==1:
            if AZH==0:
                Ao2_PZ[i]=Ao2_1_pz
            elif AZH==1:
                if RZ>=rr:
                    Ao3_F[i]=Ao2_1_ph; Ao2_PZ[i]=Ao2_1_pz-Ao3_F[i]; Ao2_ZH_per[i]=Ao2_2-Ao3_F[i]
                else:
                    Ao3_F[i]=Ao2_2; Ao2_PZ[i]=Ao2_1_pz-Ao3_F[i]
            else:  # AZH==-1
                if RZ>=RH:
                    Ao3_F[i]=Ao2_1_ph; Ao2_PZ[i]=Ao2_1_pz-Ao3_F[i]; Ao2_ZH_per[i]=Ao2_2-Ao3_F[i]
                else:
                    Ao3_F[i]=Ao2_2; Ao2_PZ[i]=0.0
        elif APZ==-1 and APH==-1:
            if AZH==0:
                Ao2_PZ[i]=Ao2_1_pz; Ao2_ZH_per[i]=Ao2_2
            elif AZH==1:
                if rr>=RZ and rr>=RH:
                    Ao3_F[i]=Ao2_2; Ao2_PZ[i]=Ao2_1_pz-Ao3_F[i]
                else:
                    Ao3_F[i]=Ao2_1_ph; Ao2_ZH_per[i]=Ao2_2-Ao3_F[i]
            else:  # AZH==-1
                # 5-way split based on relative sizes of RZ, RH, rr
                if RZ>=RH and RZ>=rr:
                    if RH>=rr:
                        Ao3_F[i]=Ao2_1_pz; Ao2_ZH_per[i]=Ao2_2-Ao3_F[i]
                    else:
                        Ao3_F[i]=Ao2_2; Ao2_PZ[i]=Ao2_1_pz-Ao3_F[i]
                elif RH>=RZ and RH>=rr:
                    if RZ>=rr:
                        Ao3_F[i]=Ao2_1_pz; Ao2_ZH_per[i]=Ao2_2-Ao3_F[i]
                    else:
                        Ao3_F[i]=Ao2_2
                elif rr>=RZ and rr>=RH:
                    if RZ>=RH:
                        Ao3_F[i]=Ao2_2; Ao2_PZ[i]=Ao2_1_pz-Ao3_F[i]
                    else:
                        Ao3_F[i]=Ao2_2
        else:
            # Cases: (APZ=1/0/-1, APH=0), (APZ=0, APH=1/-1/0)
            Ao2_PZ[i]=Ao2_1_pz if APZ!=0 else 0.0
            # Special case: (0,1,-1) — PRO outside ZOI, PRO inside HET, ZOI inside HET
            # Fortran sets Ao2_PZ=Ao2_1_pz (PRO-ZOI overlap) even though APZ==0
            # because ZOI is completely inside HET so any PRO overlap with ZOI counts
            if APZ==0 and APH==-1 and AZH==-1:
                Ao2_PZ[i]=Ao2_1_pz
            Ao2_ZH_per[i]=Ao2_2 if AZH!=0 else 0.0
    sum_Ao3=sum(Ao3_F); sum_ZH=sum(Ao2_ZH_per)
    Ao2_ZHF=(Ao2_2-sum_Ao3) if sum_ZH>0.0 else 0.0
    denom=PI*RZ**2
    AF_PZ =sum(Ao2_PZ)/denom
    AF_ZH =Ao2_ZHF/denom
    AF_PZH=sum_Ao3/denom
    AF_Z  =1.0-AF_PZ-AF_ZH-AF_PZH
    return AF_PZ, AF_ZH, AF_PZH, AF_Z


# ── Jet flow field and initial position ──────────────────────────────────────
def jet_ff(R, Z, VJET, B,
           c2R, p0R, q1R, q2R, q3R, q4R,
           c2Z, c3Z, p0Z, q1Z, q2Z, q3Z, q4Z):
    ZR = Z + B
    VR = (VJET*(R/RJET)*(ZR/ZMAX)*(1 + c2R*(R/RJET)**2)
          * p0R / (1 + q1R*(ZR/ZMAX) + q2R*(ZR/ZMAX)**2
                   + q3R*(ZR/ZMAX)**3 + q4R*(ZR/ZMAX)**4))
    VZ = (-VJET*(Z/ZMAX)**2*(1 + c2Z*(R/RJET)**2 + c3Z*(R/RJET)**3)
          * p0Z / (1 + q1Z*(Z/ZMAX) + q2Z*(Z/ZMAX)**2
                   + q3Z*(Z/ZMAX)**3 + q4Z*(Z/ZMAX)**4))
    return VR, VZ


def initial(RLIM, AP, ASP, RMODE):
    RINIT = 2.0*RLIM
    while RINIT > RLIM:
        rs1,rn1,rs2,rn2,_,_ = generate_unif()
        XINIT = rs1*rn1*RLIM
        YINIT = rs2*rn2*RLIM
        RINIT = (XINIT**2 + YINIT**2)**0.5
    ZINIT = ZMAX
    if   RMODE == 0: HINIT = ZINIT - AP
    elif RMODE in (1,2): HINIT = ZINIT - AP - ASP
    else: HINIT = ZINIT - AP - 0.5*(2*ASP + 3**0.5*ASP)
    return XINIT, YINIT, RINIT, ZINIT, HINIT


def find_hfric_hmin(AP, ASP, ASTE, GAMMA0AB, LAMBDAAB, GAMMA0STE, LAMBDASTE,
                    A132, SIGMAC, A11, A22, A33, AC1C1, AC2C2, VDWMODE, LAMBDAVDW,
                    KAPPA, KB_, ERE0_, T_, ZI, ECHG_, ZETACST, ZETAPST):
    """Scan from H0 upward to find HFRIC and HMIN."""
    ASP0, NASP0, RMODE0 = 0.0, 0.0, 0
    H = H0
    FBORN0 = force_born(A132, AP, H, A11, A22, A33, AC1C1, AC2C2, VDWMODE)
    FSTE0  = force_ste(GAMMA0STE, LAMBDASTE, ASTE, H)
    FAB0   = force_ab(AP, ASP0, NASP0, RMODE0, LAMBDAAB, GAMMA0AB, H)
    FBORNFRIC = 0.0001 * FBORN0
    FSTEFRIC  = 0.0001 * FSTE0
    FABFRIC   = 0.0001 * FAB0
    HFRIC = H0
    while (force_born(A132, AP, H, A11, A22, A33, AC1C1, AC2C2, VDWMODE) > FBORNFRIC
           or force_ste(GAMMA0STE, LAMBDASTE, ASTE, H) > FSTEFRIC
           or abs(force_ab(AP, ASP0, NASP0, RMODE0, LAMBDAAB, GAMMA0AB, H)) > abs(FABFRIC)):
        H += 1.0e-12
        HFRIC = H

    H     = H0
    FCOLL = 1.0
    HMIN  = H0
    while FCOLL > 0.0:
        HMIN = H
        H   += 1.0e-12
        FVDW = min(0.0, force_vdw(A132, AP, ASP0, NASP0, RMODE0, H, LAMBDAVDW,
                                   A11, A22, A33, AC1C1, AC2C2, 0.0, 0.0, VDWMODE))
        FEDL = min(0.0, force_edl(KAPPA, KB_, ERE0_, T_, ZI, ECHG_, ZETACST, ZETAPST,
                                   AP, ASP0, NASP0, RMODE0, H))
        FAB  = min(0.0, force_ab(AP, ASP0, NASP0, RMODE0, LAMBDAAB, GAMMA0AB, H))
        FBORN= force_born(A132, AP, H, A11, A22, A33, AC1C1, AC2C2, VDWMODE)
        FCOLL = FVDW + FEDL + FAB + FBORN
    return HFRIC, HMIN


# ── Input reader ──────────────────────────────────────────────────────────────
def read_input(fname):
    """Read INPUT_jet.IN.  Only lines whose first token is numeric are data."""
    def is_data_line(line):
        tok = line.strip().split()
        if not tok:
            return False
        first = tok[0].replace('E','').replace('e','').replace('+','').replace('-','').replace('.','')
        return first.lstrip('-').isdigit()

    def parse(line):
        tokens = []
        for x in line.split():
            xu = x.upper()
            if '.' in x or 'E' in xu:
                tokens.append(float(x))
            else:
                tokens.append(int(x))
        return tokens

    with open(fname) as f:
        data_lines = [l.strip() for l in f if is_data_line(l)]

    idx = 0
    def nxt_line():
        nonlocal idx
        v = parse(data_lines[idx]); idx += 1
        return v

    v = nxt_line(); NPART=int(v[0]); ATTMODE=int(v[1]); CLUSTER=int(v[2])
    v = nxt_line(); VJET=float(v[0]); RLIM=float(v[1]); POROSITY=float(v[2]); AG=float(v[3]); REXIT=float(v[4]); TTIME=float(v[5])
    v = nxt_line(); AP=float(v[0]); RHOP=float(v[1]); RHOW=float(v[2]); VISC=float(v[3]); ER=float(v[4]); T_=float(v[5])
    v = nxt_line(); IS_=float(v[0]); ZI=float(v[1]); ZETAPST=float(v[2]); ZETACST=float(v[3])
    v = nxt_line(); ZETAHET=float(v[0]); HETMODE=int(v[1]); RHET0=float(v[2]); RHET1=float(v[3]); SCOV=float(v[4])
    v = nxt_line(); ZETAHETP=float(v[0]); HETMODEP=int(v[1]); RHETP0=float(v[2]); RHETP1=float(v[3]); SCOVP=float(v[4])
    v = nxt_line(); A132=float(v[0]); LAMBDAVDW=float(v[1]); VDWMODE=int(v[2])
    v = nxt_line(); A11=float(v[0]); AC1C1=float(v[1]); A22=float(v[2]); AC2C2=float(v[3]); A33=float(v[4])
    v = nxt_line(); T1=float(v[0]); T2=float(v[1])
    v = nxt_line(); GAMMA0AB=float(v[0]); LAMBDAAB=float(v[1]); GAMMA0STE=float(v[2]); LAMBDASTE=float(v[3])
    v = nxt_line(); B=float(v[0]); RMODE=int(v[1]); ASP=float(v[2]); ASP2=float(v[3])
    v = nxt_line(); KINT=float(v[0]); W132=float(v[1]); BETA=float(v[2])
    v = nxt_line(); DIFFSCALE=float(v[0]); GRAVFACT=float(v[1])
    v = nxt_line(); MULTB=float(v[0]); MULTNS=float(v[1]); MULTC=float(v[2]); DFACTNS=float(v[3]); DFACTC=float(v[4])
    v = nxt_line(); NOUT=int(v[0]); PRINTMAX=int(v[1])

    return dict(NPART=NPART,ATTMODE=ATTMODE,CLUSTER=CLUSTER,
                VJET=VJET,RLIM=RLIM,POROSITY=POROSITY,AG=AG,REXIT=REXIT,TTIME=TTIME,
                AP=AP,RHOP=RHOP,RHOW=RHOW,VISC=VISC,ER=ER,T=T_,
                IS=IS_,ZI=ZI,ZETAPST=ZETAPST,ZETACST=ZETACST,
                ZETAHET=ZETAHET,HETMODE=HETMODE,RHET0=RHET0,RHET1=RHET1,SCOV=SCOV,
                ZETAHETP=ZETAHETP,HETMODEP=HETMODEP,RHETP0=RHETP0,RHETP1=RHETP1,SCOVP=SCOVP,
                A132=A132,LAMBDAVDW=LAMBDAVDW,VDWMODE=VDWMODE,
                A11=A11,AC1C1=AC1C1,A22=A22,AC2C2=AC2C2,A33=A33,
                T1=T1,T2=T2,
                GAMMA0AB=GAMMA0AB,LAMBDAAB=LAMBDAAB,GAMMA0STE=GAMMA0STE,LAMBDASTE=LAMBDASTE,
                B=B,RMODE=RMODE,ASP=ASP,ASP2=ASP2,
                KINT=KINT,W132=W132,BETA=BETA,
                DIFFSCALE=DIFFSCALE,GRAVFACT=GRAVFACT,
                MULTB=MULTB,MULTNS=MULTNS,MULTC=MULTC,DFACTNS=DFACTNS,DFACTC=DFACTC,
                NOUT=NOUT,PRINTMAX=PRINTMAX)


# ── Main ──────────────────────────────────────────────────────────────────────
def main():
    # Parse cluster arguments
    if len(sys.argv) >= 3:
        NPART_arg = int(sys.argv[1])
        ipart     = int(sys.argv[2])
        DATADIR   = sys.argv[3] if len(sys.argv) >= 4 else '.'
        CLUSTER   = 1
        # Optional fixed injection point for validation (args 4 and 5)
        XINIT_override = float(sys.argv[4]) if len(sys.argv) >= 5 else None
        YINIT_override = float(sys.argv[5]) if len(sys.argv) >= 6 else None
    else:
        ipart          = None
        DATADIR        = '.'
        CLUSTER        = 0
        XINIT_override = None
        YINIT_override = None

    p = read_input('INPUT_jet.IN')

    NPART    = p['NPART']
    ATTMODE  = p['ATTMODE']
    if CLUSTER == 0:
        CLUSTER = p['CLUSTER']

    VJET     = p['VJET'];    RLIM     = p['RLIM']
    POROSITY = p['POROSITY']; AG      = p['AG']
    REXIT    = p['REXIT'];   TTIME    = p['TTIME']
    AP       = p['AP'];      RHOP     = p['RHOP']
    RHOW     = p['RHOW'];    VISC     = p['VISC']
    ER       = p['ER'];      T_       = p['T']
    IS_      = p['IS'];      ZI       = p['ZI']
    ZETAPST  = p['ZETAPST']; ZETACST  = p['ZETACST']
    ZETAHET  = p['ZETAHET']; HETMODE  = p['HETMODE']
    RHET0    = p['RHET0'];   RHET1    = p['RHET1'];  SCOV     = p['SCOV']
    ZETAHETP = p['ZETAHETP'];HETMODEP = p['HETMODEP']
    RHETP0   = p['RHETP0'];  RHETP1   = p['RHETP1']; SCOVP = p['SCOVP']
    A132     = p['A132'];    LAMBDAVDW= p['LAMBDAVDW']; VDWMODE= p['VDWMODE']
    A11      = p['A11'];     AC1C1    = p['AC1C1']
    A22      = p['A22'];     AC2C2    = p['AC2C2'];  A33 = p['A33']
    T1       = p['T1'];      T2       = p['T2']
    GAMMA0AB = p['GAMMA0AB'];LAMBDAAB = p['LAMBDAAB']
    GAMMA0STE= p['GAMMA0STE'];LAMBDASTE=p['LAMBDASTE']
    B        = p['B'];       RMODE    = p['RMODE']
    ASP      = p['ASP'];     ASP2     = p['ASP2']
    KINT     = p['KINT'];    W132     = p['W132'];   BETA= p['BETA']
    DIFFSCALE= p['DIFFSCALE'];GRAVFACT= p['GRAVFACT']
    MULTB    = p['MULTB'];   MULTNS   = p['MULTNS']
    MULTC    = p['MULTC'];   DFACTNS  = p['DFACTNS']; DFACTC= p['DFACTC']
    NOUT     = p['NOUT'];    PRINTMAX = p['PRINTMAX']

    if VDWMODE != 1:
        A132 = 0.0

    # Derived quantities
    MP   = (4.0/3.0)*PI*(AP**3)*RHOP
    dTMRT= MP/(6.0*PI*VISC*AP)
    TINJ = TTIME/6.0
    VM   = (2.0/3.0)*PI*(AP**3)*RHOW
    M3   = 6.0*PI*VISC*AP
    ERE0_= ER*E0
    NIO  = IS_*2*NA
    KAPPA= ((ECHG**2)*NIO*(ZI**2)/(ERE0_*KB*T_))**0.5

    if W132 > 0.0: W132 = 0.0
    ACONTMAX = (-6.0*PI*W132*(AP**2)/KINT)**(1.0/3.0)
    DELTAMAX = AP - (AP**2 - ACONTMAX**2)**0.5
    ASTE     = (ACONTMAX**2 + 2*LAMBDASTE*(AP + (AP**2 - ACONTMAX**2)**0.5))**0.5

    # Flow field coefficients
    V = VJET
    c2R = ((-1.3898e-6)+(4.8896e-5)*V+(-2.8162e-3)*V**2+(0.043987)*V**3+(-0.26763)*V**4) / \
          ((4.5569e-6)+(-2.9837e-4)*V+(0.012018)*V**2+(-0.17771)*V**3+V**4)
    p0R = ((6.1234e-6)+(1.7407e-4)*V+(0.027330)*V**2+(0.99184)*V**3+(116.47)*V**4+(704.97)*V**5) / \
          ((5.5905e-6)+(-2.3819e-4)*V+(0.011179)*V**2+(-7.9484e-3)*V**3+(2.5822)*V**4+V**5)
    q1R = ((-4.4571e-4)+(0.017318)*V+(-0.95759)*V**2+(2.1143)*V**3+(23.569)*V**4+(-75.908)*V**5) / \
          ((-2.1185e-4)+(0.011745)*V+(-0.34782)*V**2+(2.0706)*V**3+(-4.8446)*V**4+V**5)
    q2R = ((1.1675e-4)+(0.010177)*V+(0.23060)*V**2+(-97.157)*V**3+(2967.4)*V**4+(8551.9)*V**5) / \
          ((4.7391e-5)+(-2.6817e-3)*V+(0.11518)*V**2+(-0.13887)*V**3+(4.5144)*V**4+V**5)
    q3R = ((-6.7901e-4)+(5.4559e-3)*V+(-0.76940)*V**2+(408.71)*V**3+(1390.5)*V**4+(-62159.0)*V**5) / \
          ((4.8220e-5)+(-2.6240e-3)*V+(0.096243)*V**2+(-0.61526)*V**3+(4.4357)*V**4+V**5)
    q4R = ((2.8122e-4)+(-1.9761e-3)*V+(1.6559)*V**2+(-355.30)*V**3+(6262.7)*V**4+(30037.0)*V**5) / \
          ((2.6282e-5)+(-1.2146e-3)*V+(0.037943)*V**2+(-0.10236)*V**3+V**4)
    c2Z = ((-3.0419e-4)+(-8.6247e-3)*V+(-1.1791)*V**2+(2.8177)*V**3+(-5.9877)*V**4+(2.8049)*V**5) / \
          ((3.9460e-4)+(-4.3045e-3)*V+(0.63027)*V**2+V**3)
    c3Z = ((2.8682e-6)+(2.4859e-4)*V+(0.029452)*V**2+(-0.17092)*V**3+(0.23433)*V**4) / \
          ((1.1301e-5)+(2.8487e-4)*V+(7.9955e-3)*V**2+(0.28130)*V**3+(-0.91690)*V**4+V**5)
    p0Z = ((5.5463e-6)+(6.0097e-4)*V+(0.048917)*V**2+(1.7357)*V**3+(405.62)*V**4+(370.08)*V**5) / \
          ((2.0039e-6)+(7.2434e-5)*V+(1.8753e-4)*V**2+(0.20316)*V**3+V**4)
    q1Z = ((1.8277)+(4.1911)*V+(-1327.7)*V**2+(17226.0)*V**3+(-2680.0)*V**4) / \
          ((1.1784)+(-37.051)*V+(355.86)*V**2+(86.723)*V**3+(-58.002)*V**4+V**5)
    q2Z = ((4.7092e-6)+(1.1471e-3)*V+(0.25466)*V**2+(-5.1617)*V**3+(161.60)*V**4+(100.60)*V**5) / \
          ((2.4519e-5)+(-4.1523e-4)*V+(5.5477e-4)*V**2+(0.14417)*V**3+V**4)
    q3Z = ((9.7112e-5)+(-8.6404e-3)*V+(0.16443)*V**2+(-0.32979)*V**3+(-13.557)*V**4+(-45.113)*V**5) / \
          ((-2.7886e-5)+(2.9851e-3)*V+(-0.099424)*V**2+(0.79149)*V**3+(-2.8532)*V**4+V**5)
    q4Z = ((5.3839e-6)+(-2.3158e-4)*V+(-0.012945)*V**2+(0.58265)*V**3+(-7.0627)*V**4+(12.977)*V**5) / \
          ((2.3241e-6)+(-1.6087e-4)*V+(1.2951e-3)*V**2+(0.084146)*V**3+(-0.40532)*V**4+V**5)

    FF_ARGS = (B, c2R, p0R, q1R, q2R, q3R, q4R,
               c2Z, c3Z, p0Z, q1Z, q2Z, q3Z, q4Z)

    HFRIC, HMIN = find_hfric_hmin(
        AP, ASP, ASTE, GAMMA0AB, LAMBDAAB, GAMMA0STE, LAMBDASTE,
        A132, SIGMAC, A11, A22, A33, AC1C1, AC2C2, VDWMODE, LAMBDAVDW,
        KAPPA, KB, ERE0_, T_, ZI, ECHG, ZETACST, ZETAPST)

    # Hydrodynamic coefficients (Masliyah & Bhattacharjee 2005 / GCB 1967)
    A1,B1,C1,D1,E1 = 0.9267,-0.3990,0.1487,-0.601,1.202
    A2,B2,C2,D2,E2 = 0.5695, 1.355, 1.36,  0.875,0.525
    A3,B3,C3,D3,E3 = 0.2803,-0.1430,1.472,-0.6772,2.765
    A4,B4,C4,D4,E4 = 0.2607,-0.3015,0.9006,-0.5942,1.292

    # Favorable conditions → zero heterodomains
    if ((ZETACST >= 0.0 and ZETAPST <= 0.0) or
        (ZETACST <= 0.0 and ZETAPST >= 0.0)):
        SCOV  = 0.0
        SCOVP = 0.0

    # Output files
    NPARTLOOP = 1 if CLUSTER == 1 else NPART
    if CLUSTER == 0:
        f_ex  = open('JETFLUXEX.OUT',  'w')
        f_att = open('JETFLUXATT.OUT', 'w')
        f_rem = open('JETFLUXREM.OUT', 'w')
        hdr_written = {f_ex: False, f_att: False, f_rem: False}

    RZOIBULK = 2.0*((1.0/KAPPA)*AP)**0.5

    def write_header(fh):
        fh.write(f"NPART= {NPART:6d}  VJET(m/s)= {VJET:.8E}  RLIM(m)= {RLIM:.8E}  "
                 f"REXIT(m)= {REXIT:.8E}  RJET(m)= {RJET:.8E}  ZMAX(m)= {ZMAX:.8E}  "
                 f"TTIME(s)= {TTIME:.8E}  ATTMODE= {ATTMODE:2d}  "
                 f"SLIP(m)= {B:.8E}  RMODE= {RMODE:2d}  "
                 f"ASP(m)= {ASP:.8E}  ASP2(m)= {ASP2:.8E}\n")
        fh.write(f"AP(m)= {AP:.8E}  IS(mol/m3)= {IS_:.8E}  ZI= {ZI:.8E}  "
                 f"ZETAPST(V)= {ZETAPST:.8E}  ZETACST(V)= {ZETACST:.8E}  "
                 f"RHOP(kg/m3)= {RHOP:.8E}  RHOW(kg/m3)= {RHOW:.8E}  "
                 f"VISC(kg/m/s)= {VISC:.8E}  ER= {ER:.8E}  T(K)= {T_:.8E}  "
                 f"DIFFSCALE= {DIFFSCALE:.8E}  GRAVFACT= {GRAVFACT:.8E}\n")
        fh.write(f"SCOV= {SCOV:.8E}  ZETAHET(V)= {ZETAHET:.8E}  HETMODE= {HETMODE:2d}  "
                 f"RHET0(m)= {RHET0:.8E}  RHET1(m)= {RHET1:.8E}  "
                 f"SCOVP= {SCOVP:.8E}  ZETAHETP(V)= {ZETAHETP:.8E}  HETMODEP= {HETMODEP:2d}  "
                 f"RHETP0(m)= {RHETP0:.8E}  RHETP1(m)= {RHETP1:.8E}  "
                 f"RZOIBULK(m)= {RZOIBULK:.8E}  dTMRT(s)= {dTMRT:.8E}  "
                 f"MULTB= {MULTB:.8E}  MULTNS= {MULTNS:.8E}  MULTC= {MULTC:.8E}  "
                 f"VDWMODE= {VDWMODE:6d}\n")
        fh.write(f"A132(J)= {A132:.8E}  LAMBDAVDW(m)= {LAMBDAVDW:.8E}  "
                 f"GAMMA0AB(J/m2)= {GAMMA0AB:.8E}  LAMBDAAB(m)= {LAMBDAAB:.8E}  "
                 f"GAMMA0STE(J/m2)= {GAMMA0STE:.8E}  LAMBDASTE(m)= {LAMBDASTE:.8E}  "
                 f"KINT(N/m2)= {KINT:.8E}  W132(J/m2)= {W132:.8E}  "
                 f"ACONTMAX(m)= {ACONTMAX:.8E}  BETA= {BETA:.8E}  "
                 f"DFACTNS= {DFACTNS:.8E}  DFACTC= {DFACTC:.8E}  "
                 f"A11(J)= {A11:.8E}  A22(J)= {A22:.8E}  A33(J)= {A33:.8E}  "
                 f"AC1C1(J)= {AC1C1:.8E}  AC2C2(J)= {AC2C2:.8E}  "
                 f"T1(m)= {T1:.8E}  T2(m)= {T2:.8E}\n")
        fh.write("ATTACHK1=EXIT,ATTACHK2=ATTACHED-BY-PERFECT-SINK-OR-TORQUE,"
                 "ATTACHK3=REMAINING-UNRESOLVED-WHEN-SIMULATION-ENDS,"
                 "ATTACHK4=TORQUE-WITH-SLOW-MOTION,ATTACHK5=IN-NEAR-SURFACE-WITH-SLOW-MOTION,"
                 "ATTACHK6=CRASHED\n")

    FLUX_HDR = ('J      ATTACHK       XINIT(m)       YINIT(m)       RINIT(m)'
                '       ZINIT(m)       HINIT(m)       XOUT(m)        YOUT(m)'
                '       ROUT(m)        ZOUT(m)        HOUT(m)        ETIME(s)'
                '       PTIMEIN(s)     PTIMEOUT(s)    TBULK(s)       TNEAR(s)'
                '       TFRIC(s)       NSVISIT        FRICVISIT      ACONT(m)'
                '       RZOI(m)        AFRACT         HETTYPE HETFLAG'
                '       NSVEL(m/s)     HAVE(m)'
                '       XINNS(m)       YINNS(m)       ZINNS(m)\n')

    def write_flux_row(fh, jp, AK, xi,yi,ri,zi,hi, xo,yo,ro,zo,ho,
                       etime,ptin,ptout,tbulk,tnear,tfric,
                       nsv,frv,acont,rzoi,afract,htype,hflag,nsvel,have,
                       xinns,yinns,zinns):
        fh.write(f'{jp:<6d} {AK:1d} '
                 + ' '.join(f'{v:15.8E}' for v in [
                     xi,yi,ri,zi,hi,xo,yo,ro,zo,ho,
                     etime,ptin,ptout,tbulk,tnear,tfric])
                 + f' {nsv:15d} {frv:15d}'
                 + ' '.join(f'{v:15.8E}' for v in [acont,rzoi,afract])
                 + f' {htype:1d} {hflag:1d}'
                 + ' '.join(f'{v:15.8E}' for v in [nsvel,have,xinns,yinns,zinns])
                 + '\n')

    for J_idx in range(NPARTLOOP):
        J = ipart if CLUSTER == 1 else J_idx + 1

        # Initial position
        XINIT,YINIT,RINIT,ZINIT,HINIT = initial(RLIM, AP, ASP, RMODE)
        if XINIT_override is not None:
            XINIT = XINIT_override
        if YINIT_override is not None:
            YINIT = YINIT_override
        RINIT = (XINIT**2 + YINIT**2)**0.5
        if   RMODE == 0: HINIT = ZINIT - AP
        elif RMODE in (1,2): HINIT = ZINIT - AP - ASP
        else: HINIT = ZINIT - AP - 0.5*(2*ASP + 3**0.5*ASP)
        X,Y,Z,R,H = XINIT,YINIT,ZINIT,RINIT,HINIT
        # Initialization matches Fortran: VR=0, simplified VZ at injection
        VR = 0.0
        VZ = -VJET*(1.994 - 9.952e-4/(3.977e-3 + 3.307**math.log(VJET))) * (1-(R/RJET)**2)
        UZ = VZ; UX = 0.0; UY = 0.0; UR = 0.0; OMEGA = 0.0

        PTIMEF = (J-1)*TINJ/NPART
        dT     = MULTB*dTMRT
        HFLAG  = 1
        ACONT  = 0.0; DELTA = 0.0
        ATTACHK= 0; ARRESTFLAG=0
        IREF1=0; IREF2=0
        NSVISIT=0; FRICVISIT=0
        TBULK=0.0; TNEAR=0.0; TFRIC=0.0; ETIME=0.0
        HSUM=0.0; HAVE=0.0; L=0; NSDIST=0.0; NSVEL=0.0
        XENTER=X; YENTER=Y
        XINNS=0.0; YINNS=0.0; ZINNS=0.0
        HETTYPE=0; HETFLAG=0; AFRACT=-1.0

        # Local SCOV — favorable conditions override
        SCOV_loc  = SCOV
        SCOVP_loc = SCOVP

        RZOI    = (ACONT**2 + 2/KAPPA*(AP + (AP**2 - ACONT**2)**0.5))**0.5
        RZOIBULK= RZOI

        # Initialise colloid heterodomain projection matrix
        M_PRO = None; NPRO = 0
        if SCOV_loc > 0.0 or SCOVP_loc > 0.0:
            NPRO, M_PRO = hettrackp(X, Y, Z, RZOIBULK, AP, HETMODEP,
                                    SCOVP_loc, RHETP0, RHETP1)
            if NPRO == 0:
                M_PRO = [[0.0, 0.0, 0.0]]

        # Asperity counts
        NASP=0.0; NASPAB=0.0
        if RMODE > 0:
            ASPLIM = 0.5*PI**0.5*RZOI
            NASP   = 1.0 if ASP > ASPLIM else (RZOI**2/ASP**2)*(PI/4)
            NASPAB = NASP

        # Initial forces
        FVDW = force_vdw(A132,AP,ASP,NASP,RMODE,H,LAMBDAVDW,
                         A11,A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE)
        FEDL = force_edl(KAPPA,KB,ERE0_,T_,ZI,ECHG,ZETACST,ZETAPST,
                         AP,ASP,NASP,RMODE,H)
        FAB  = force_ab(AP,ASP,NASPAB,RMODE,LAMBDAAB,GAMMA0AB,H)
        FBORN= force_born(A132,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE)
        FSTE = force_ste(GAMMA0STE,LAMBDASTE,ASTE,H)
        FCOLL= FVDW+FEDL+FAB+FBORN+FSTE
        FG   = gravity(GRAVFACT,AP,RHOP,RHOW)
        FLIFT= force_lift(RHOW,Z,AP,VR,UR,OMEGA)
        HBAR = (H+B)/AP
        FUN1 = 1+B1*math.exp(-C1*HBAR)+D1*math.exp(-E1*HBAR**A1)
        FUN2 = 1+B2*math.exp(-C2*HBAR)+D2*math.exp(-E2*HBAR**A2)
        FUN3 = 1+B3*math.exp(-C3*HBAR)+D3*math.exp(-E3*HBAR**A3)
        FUN4 = 1+B4*math.exp(-C4*HBAR)+D4*math.exp(-E4*HBAR**A4)
        FDRGR,FDRGZ = force_drag(FUN2,FUN3,FUN4,M3,VZ,VR)
        FDIFX=FDIFY=FDIFZ=0.0

        # Output arrays
        IOT=[0]*OUTMAX; XOT=[0.0]*OUTMAX; YOT=[0.0]*OUTMAX
        ROT=[0.0]*OUTMAX; ZOT=[0.0]*OUTMAX; HOT=[0.0]*OUTMAX
        ETIMEOT=[0.0]*OUTMAX; PTIMEFOT=[0.0]*OUTMAX
        FCOLLOT=[0.0]*OUTMAX; FVDWOT=[0.0]*OUTMAX; FEDLOT=[0.0]*OUTMAX
        FABOT=[0.0]*OUTMAX; FSTEOT=[0.0]*OUTMAX; FBORNOT=[0.0]*OUTMAX
        UTOT=[0.0]*OUTMAX; UNOT=[0.0]*OUTMAX; VTOT=[0.0]*OUTMAX; VNOT=[0.0]*OUTMAX
        FDRGTOT=[0.0]*OUTMAX; FDRGNOT=[0.0]*OUTMAX
        FDIFXOT=[0.0]*OUTMAX; FDIFYOT=[0.0]*OUTMAX; FDIFZOT=[0.0]*OUTMAX
        FGOT=[0.0]*OUTMAX; FLIFTOT=[0.0]*OUTMAX
        ACONTOT=[0.0]*OUTMAX; RZOIOT=[0.0]*OUTMAX; AFRACTOT=[0.0]*OUTMAX

        I=0; PCOUNT=1; OUTCOUNT=1; OUTFLAG=1

        def store(oc):
            IOT[oc]=I; XOT[oc]=X; YOT[oc]=Y; ROT[oc]=R; ZOT[oc]=Z
            HOT[oc]=H; ETIMEOT[oc]=ETIME; PTIMEFOT[oc]=PTIMEF
            FCOLLOT[oc]=FCOLL; FVDWOT[oc]=FVDW; FEDLOT[oc]=FEDL
            FABOT[oc]=FAB; FSTEOT[oc]=FSTE; FBORNOT[oc]=FBORN
            UTOT[oc]=UR; UNOT[oc]=UZ; VTOT[oc]=VR; VNOT[oc]=VZ
            FDRGTOT[oc]=FDRGR; FDRGNOT[oc]=FDRGZ
            FDIFXOT[oc]=FDIFX; FDIFYOT[oc]=FDIFY; FDIFZOT[oc]=FDIFZ
            FGOT[oc]=FG; FLIFTOT[oc]=FLIFT
            ACONTOT[oc]=ACONT; RZOIOT[oc]=RZOI; AFRACTOT[oc]=AFRACT

        # ── Trajectory loop ───────────────────────────────────────────────────
        while ATTACHK == 0:

            if PCOUNT == NOUT or I == 0:
                PCOUNT = 0
                store(OUTCOUNT - 1)
                OUTCOUNT += 1
                if OUTCOUNT > OUTMAX:
                    OUTFLAG += 1
                    if OUTFLAG == OUTMAX:
                        OUTFLAG -= 1
                    OUTCOUNT = OUTFLAG
                if CLUSTER == 0:
                    print(f'J= {J:6d} I= {I:15d} R= {R:11.4E} '
                          f'H= {H:11.4E} UR= {UR:12.5E} AFRACT= {AFRACT:11.4E}')
                elif I % 10000 == 0:
                    print(f'  step={I:12d}  H={H:.3E}  HFLAG={HFLAG}  R={R:.4E}  AFRACT={AFRACT:.4f}', flush=True)

            I      += 1
            PCOUNT += 1
            PTIMEF += dT
            ETIME   = PTIMEF - PTIMEFOT[0]

            XO,YO,ZO = X,Y,Z
            X = XO + UX*dT
            Y = YO + UY*dT
            Z = ZO + UZ*dT
            R = (X**2 + Y**2)**0.5

            # Deformation
            if   RMODE == 0: DELTA = DELTAMAX*(Z - AP - HFRIC)/(HMIN - HFRIC - DELTAMAX)
            elif RMODE in (1,2): DELTA = DELTAMAX*(Z - AP - HFRIC - ASP)/(HMIN - HFRIC - DELTAMAX)
            else: DELTA = DELTAMAX*(Z - AP - HFRIC - 0.5*(2*ASP + 3**0.5*ASP))/(HMIN - HFRIC - DELTAMAX)
            DELTA = max(0.0, min(DELTAMAX, DELTA))
            ACONT = BETA*(max(0.0, 2.0*AP*DELTA - DELTA**2))**0.5
            RZOI  = (ACONT**2 + 2/KAPPA*(AP + (AP**2 - ACONT**2)**0.5))**0.5
            if RMODE > 0:
                ASPLIM = 0.5*PI**0.5*RZOI
                NASP   = 1.0 if ASP > ASPLIM else (RZOI**2/ASP**2)*(PI/4)
                NASPAB = NASP

            if   RMODE == 0: H = Z - AP + DELTA
            elif RMODE in (1,2): H = Z - AP + DELTA - ASP
            else: H = Z - AP + DELTA - 0.5*(2*ASP + 3**0.5*ASP)

            # Zone logic
            if H > HNS:
                if HFLAG == 2:
                    TNEAR += dT
                    dT     = MULTB*dTMRT
                    HFLAG  = 1
                    if IREF1 > 200:
                        NSDIST += ((X-XENTER)**2 + (Y-YENTER)**2)**0.5
                        NSVEL   = NSDIST/TNEAR if TNEAR > 0 else 0.0
                    IREF1 = 0
                elif HFLAG == 1:
                    TBULK += dT

            elif H > HFRIC:  # near-surface
                if HFLAG == 1:
                    TBULK += dT; dT = MULTNS*dTMRT; HFLAG = 2
                    NSVISIT += 1; XENTER=X; YENTER=Y; XINNS=X; YINNS=Y
                    # Diagnostic: report NPRO on first near-surface visit
                    if NSVISIT == 1:
                        NPRO_diag = len(M_PRO) if M_PRO is not None else 0
                        print(f'J={J} first NS entry: NSVISIT=1 NPRO={NPRO_diag} H={H:.3E} AFRACT={AFRACT:.4f}', flush=True)
                elif HFLAG == 3:
                    TFRIC += dT; dT = MULTNS*dTMRT; HFLAG = 2; IREF2 = 0
                    XENTER=X; YENTER=Y
                elif HFLAG == 2:
                    TNEAR += dT; L += 1; HSUM += H; HAVE = HSUM/L

                if IREF1 == 0:
                    XREF1=X; YREF1=Y; ZREF1=Z; TREF1=0.0; IREF1=1
                else:
                    IREF1 += 1; TREF1 += dT
                    if IREF1 > 1000:
                        DREF1 = ((X-XREF1)**2+(Y-YREF1)**2+(Z-ZREF1)**2)**0.5
                        DCOEF = FUN1 if VZ > VR else FUN4
                        DIND1 = DFACTNS*(6.0*DCOEF*KB*T_*TREF1/M3)**0.5
                        if DREF1 < DIND1 and H > 5*HFRIC:
                            ATTACHK = 5
                        else:
                            IREF1 = 0

            else:  # contact
                if HFLAG == 2:
                    TNEAR += dT; dT = MULTC*dTMRT; HFLAG = 3
                    NSDIST += ((X-XENTER)**2+(Y-YENTER)**2)**0.5
                    NSVEL   = NSDIST/TNEAR if TNEAR > 0 else 0.0
                    FRICVISIT += 1; ZINNS = Z
                elif HFLAG == 3:
                    TFRIC += dT

                if H < H0:
                    ATTACHK = 6
                if ATTMODE == 0:
                    ATTACHK = 2
                else:
                    if UR == 0.0 and ARRESTFLAG == 1:
                        ATTACHK = 2
                    if IREF2 == 0:
                        XREF2=X; YREF2=Y; ZREF2=Z; TREF2=0.0; IREF2=1
                    else:
                        IREF2 += 1; TREF2 += dT
                        if IREF2 > 1000:
                            DREF2 = ((X-XREF2)**2+(Y-YREF2)**2+(Z-ZREF2)**2)**0.5
                            DCOEF = FUN1 if VZ > VR else FUN4
                            DIND2 = DFACTC*(6.0*DCOEF*KB*T_*TREF2/M3)**0.5
                            if DREF2 < DIND2:
                                ATTACHK = 4
                            else:
                                IREF2 = 0

            if R > REXIT:
                ATTACHK = 1
            if PTIMEF > TTIME:
                ATTACHK = 3

            if ATTACHK != 0:
                ETIME = PTIMEF - PTIMEFOT[0]
                store(OUTCOUNT - 1)
                continue

            # Forces
            FVDW = force_vdw(A132,AP,ASP,NASP,RMODE,H,LAMBDAVDW,
                             A11,A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE)

            # EDL with full heterodomain support
            if (SCOV_loc > 0.0 or SCOVP_loc > 0.0) and I == 1:
                # Re-initialise projection matrix on first step
                NPRO, M_PRO = hettrackp(X, Y, Z, RZOIBULK, AP, HETMODEP,
                                        SCOVP_loc, RHETP0, RHETP1)
                if NPRO == 0:
                    M_PRO = [[0.0, 0.0, 0.0]]
            elif (SCOV_loc > 0.0 or SCOVP_loc > 0.0) and I > 1 and M_PRO is not None:
                # Translate projection matrix with colloid movement
                dX = X - XO; dY = Y - YO
                M_PRO = [[row[0]+dX, row[1]+dY, row[2]] for row in M_PRO]

            if (SCOV_loc > 0.0 or SCOVP_loc > 0.0) and HFLAG > 1:
                if SCOV_loc > 0.0:
                    XHET_list, YHET_list, RHET_list = hettrack(
                        X, Y, RZOIBULK, HETMODE, SCOV_loc, RHET0, RHET1)
                else:
                    XHET_list=[0.0]*100; YHET_list=[0.0]*100; RHET_list=[0.0]*100
                AFRACT=0.0; AFRACT_PZ=0.0; AFRACT_ZH=0.0; AFRACT_PZH=0.0
                AF_PZ,AF_ZH,AF_PZH,AF_Z = fractional_area(X,Y,RZOIBULK,0.0,0.0,0.0,M_PRO)
                AFRACT=AF_PZ; AFRACT_PZ=AF_PZ
                for K in range(HETMODE):
                    AF_PZ2,AF_ZH2,AF_PZH2,AF_Z2 = fractional_area(
                        X,Y,RZOIBULK,XHET_list[K],YHET_list[K],RHET_list[K],M_PRO)
                    AFRACT += AF_ZH2
                    if AF_ZH2 > 0.0:
                        AFRACT -= AF_PZH2; AFRACT_PZ -= AF_PZH2
                    AFRACT_ZH += AF_ZH2; AFRACT_PZH += AF_PZH2
                    AFRACT_Z = 1 - AFRACT_PZ - AFRACT_ZH - AFRACT_PZH
                    if AF_ZH2 > 0.0 and K == 0:
                        HETTYPE = 1  # large heterodomain
                    if HETMODE == 9:
                        if AF_ZH2 > 0.0 and HETTYPE == 0 and K > 0:
                            HETTYPE = 2  # medium heterodomain
                        if AF_ZH2 > 0.0 and HETTYPE == 1 and K > 0:
                            HETTYPE = 4  # large and medium heterodomain
                if AFRACT > 0.0:
                    HETFLAG = 1
                    FEDL_PZ  = force_edl(KAPPA,KB,ERE0_,T_,ZI,ECHG,ZETACST, ZETAHETP,AP,ASP,NASP,RMODE,H)
                    FEDL_ZH  = force_edl(KAPPA,KB,ERE0_,T_,ZI,ECHG,ZETAHET, ZETAPST, AP,ASP,NASP,RMODE,H)
                    FEDL_PZH = force_edl(KAPPA,KB,ERE0_,T_,ZI,ECHG,ZETAHET, ZETAHETP,AP,ASP,NASP,RMODE,H)
                    FEDL_Z   = force_edl(KAPPA,KB,ERE0_,T_,ZI,ECHG,ZETACST, ZETAPST, AP,ASP,NASP,RMODE,H)
                    FEDL = AFRACT_PZ*FEDL_PZ + AFRACT_ZH*FEDL_ZH + AFRACT_PZH*FEDL_PZH + AFRACT_Z*FEDL_Z
                else:
                    FEDL = force_edl(KAPPA,KB,ERE0_,T_,ZI,ECHG,ZETACST,ZETAPST,AP,ASP,NASP,RMODE,H)
            else:
                AFRACT = -1.0
                FEDL   = force_edl(KAPPA,KB,ERE0_,T_,ZI,ECHG,ZETACST,ZETAPST,AP,ASP,NASP,RMODE,H)
            FAB   = force_ab(AP,ASP,NASPAB,RMODE,LAMBDAAB,GAMMA0AB,H)
            FBORN = force_born(A132,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE)
            FSTE  = force_ste(GAMMA0STE,LAMBDASTE,ASTE,H)
            FCOLL = FVDW+FEDL+FAB+FBORN+FSTE

            VR,VZ = jet_ff(R,Z,VJET,*FF_ARGS)
            HBAR  = (H+B)/AP
            FUN1  = 1+B1*math.exp(-C1*HBAR)+D1*math.exp(-E1*HBAR**A1)
            FUN2  = 1+B2*math.exp(-C2*HBAR)+D2*math.exp(-E2*HBAR**A2)
            FUN3  = 1+B3*math.exp(-C3*HBAR)+D3*math.exp(-E3*HBAR**A3)
            FUN4  = 1+B4*math.exp(-C4*HBAR)+D4*math.exp(-E4*HBAR**A4)
            FDRGR,FDRGZ = force_drag(FUN2,FUN3,FUN4,M3,VZ,VR)

            if HFLAG < 3:
                FDIFX,FDIFY,FDIFZ = force_diff(DIFFSCALE,VISC,AP,T_,dT)
            else:
                FDIFX=FDIFY=FDIFZ=0.0

            FG    = gravity(GRAVFACT,AP,RHOP,RHOW)
            FLIFT = force_lift(RHOW,Z,AP,VR,UR,OMEGA)

            JX = X/R if R > 0 else 0.0
            JY = Y/R if R > 0 else 0.0
            FDRGX = FDRGR*JX; FDRGY = FDRGR*JY

            UXO,UYO,UZO = UX,UY,UZ
            UZ = ((MP+VM)*UZO + (FG+FCOLL+FDIFZ+FLIFT+FDRGZ)*dT) / \
                 (MP+VM + M3*dT/FUN1)

            if H > HFRIC:
                UX = ((MP+VM)*UXO + (FDIFX+FDRGX)*dT)/(MP+VM + M3*dT/FUN4)
                UY = ((MP+VM)*UYO + (FDIFY+FDRGY)*dT)/(MP+VM + M3*dT/FUN4)
                UR = math.copysign((UX**2+UY**2)**0.5, X*UX+Y*UY)
                OMEGA = abs(UR)/AP * (0.5518+117.4*(H/AP)) / \
                        (1+232.1*(H/AP)+237.7*(H/AP)**2)
            else:
                FADH = FVDW+FEDL+FG+FLIFT+FDRGZ
                FREP = FBORN
                if FAB  < 0.0: FADH += FAB
                else:          FREP += FAB
                if FSTE < 0.0: FADH += FSTE
                else:          FREP += FSTE
                FADH = -FADH if FADH < 0.0 else 0.0
                RLEV = AP*ASP2/(AP+ASP2) if ASP2 > 0 else 0.0
                if RLEV <= ACONT: RLEV = ACONT
                FSHRT=1.7005; TSHRY=0.9440
                FTRT = (8.0/15.0)*math.log(H/AP) - 0.9588
                FROT = -(2.0/15.0)*math.log(H/AP) - 0.2526
                TTRY = -(1.0/10.0)*math.log(H/AP) - 0.1895
                TROY =  (2.0/5.0)*math.log(H/AP)  - 0.3817
                URO  = (UXO**2+UYO**2)**0.5
                denom = (1.4*(MP+VM) - 6.0*PI*VISC*(AP-DELTA)*dT*(FTRT+FROT+4.0/3.0*(TTRY+TROY)))
                if denom != 0:
                    UR = (1.4*(MP+VM)*URO
                          - FADH*RLEV/AP*(AP-DELTA)/AP*dT
                          + 6.0*PI*VISC*(AP-DELTA)*VR*dT*(FSHRT+2.0/3.0*AP/(H+AP)*TSHRY)) / denom
                if UR < 0.0:
                    UR = 0.0; ARRESTFLAG = 1
                if (FADH < 0.995*FREP) or (FADH > 1.005*FREP):
                    ARRESTFLAG = 0
                UX = JX*UR; UY = JY*UR
                OMEGA = UR/(AP-DELTA) if (AP-DELTA) != 0 else 0.0

        # ── End trajectory loop ───────────────────────────────────────────────
        if CLUSTER == 0:
            print(f'J= {J:6d} DONE  I= {I:15d}  ATTACHK={ATTACHK}  '
                  f'H={H:.4E}  ETIME={ETIME:.3E}s')
        else:
            print(f'  DONE   steps={I:12d}  ATTACHK={ATTACHK}  '
                  f'H={H:.3E}  ETIME={ETIME:.3E}s', flush=True)

        # Write flux
        flux_row_args = (J, ATTACHK,
                         XINIT,YINIT,RINIT,ZINIT,HINIT,
                         X,Y,R,Z,H,ETIME,PTIMEFOT[0],PTIMEF,
                         TBULK,TNEAR,TFRIC,NSVISIT,FRICVISIT,
                         ACONT,RZOI,AFRACT,HETTYPE,HETFLAG,
                         NSVEL,HAVE,XINNS,YINNS,ZINNS)

        if CLUSTER == 1:
            if   ATTACHK == 1: fname = f'JETFLUXEX.{ipart}.OUT'
            elif ATTACHK in (2,4,6): fname = f'JETFLUXATT.{ipart}.OUT'
            else: fname = f'JETFLUXREM.{ipart}.OUT'
            with open(fname,'w') as fh:
                write_header(fh)
                fh.write(FLUX_HDR)
                write_flux_row(fh, *flux_row_args)

            # Write trajectory file for small runs (NPART<10) — diagnostic/validation mode
            if NPART < 10:
                if   ATTACHK == 1: tfname = os.path.join(DATADIR, f'JETTRAJEX.{ipart}.OUT')
                elif ATTACHK in (2,4,6): tfname = os.path.join(DATADIR, f'JETTRAJATT.{ipart}.OUT')
                else: tfname = os.path.join(DATADIR, f'JETTRAJREM.{ipart}.OUT')
                TRAJ_HDR = ('I                   X                   Y                   '
                            'R                   Z                   H                   '
                            'ETIME               PTIMEF              FCOLL               '
                            'FVDW                FEDL                FAB                 '
                            'FSTE                FBORN               UT                  '
                            'UN                  VT                  VN                  '
                            'FDRGT               FDRGN               FDIFX               '
                            'FDIFY               FDIFZ               FG                  '
                            'FLIFT               ACONT               RZOI                '
                            'AFRACT\n')
                with open(tfname,'w') as tf:
                    write_header(tf)
                    tf.write(f'ATTACHK= {ATTACHK:5d}\n')
                    tf.write(TRAJ_HDR)
                    nrows = min(OUTCOUNT-1, OUTMAX)
                    for k in range(nrows):
                        oc = k
                        tf.write(f'{IOT[oc]:015d}'
                                 + ''.join(f' {v:20.8E}' for v in [
                                     XOT[oc], YOT[oc], ROT[oc], ZOT[oc], HOT[oc],
                                     ETIMEOT[oc], PTIMEFOT[oc],
                                     FCOLLOT[oc], FVDWOT[oc], FEDLOT[oc],
                                     FABOT[oc], FSTEOT[oc], FBORNOT[oc],
                                     UTOT[oc], UNOT[oc], VTOT[oc], VNOT[oc],
                                     FDRGTOT[oc], FDRGNOT[oc],
                                     FDIFXOT[oc], FDIFYOT[oc], FDIFZOT[oc],
                                     FGOT[oc], FLIFTOT[oc],
                                     ACONTOT[oc], RZOIOT[oc], AFRACTOT[oc]])
                                 + '\n')
        else:
            if   ATTACHK == 1: fh = f_ex
            elif ATTACHK in (2,4,6): fh = f_att
            else: fh = f_rem
            if not hdr_written[fh]:
                write_header(fh)
                fh.write(FLUX_HDR)
                hdr_written[fh] = True
            write_flux_row(fh, *flux_row_args)

    if CLUSTER == 0:
        f_ex.close(); f_att.close(); f_rem.close()

    print('Simulation complete.')


if __name__ == '__main__':
    main()
