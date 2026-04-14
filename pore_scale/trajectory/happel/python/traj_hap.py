#!/usr/bin/env python3
"""
traj_hap.py — Python port of TRAJ-HAP.for (HAPHETLN)
Happel sphere-in-cell colloid trajectory simulation.
Ported from Fortran by Claude, validated against Fortran reference output.

Usage (CLUSTER=1):
    python3 traj_hap.py NPART IPART [DATADIR] [XINIT_override] [YINIT_override]

Usage (CLUSTER=0, serial):
    python3 traj_hap.py
"""

import sys
import math
import random
import os

# ── Physical constants ─────────────────────────────────────────────────────────
PI    = 3.14159265359
G_G   = 9.80665          # m/s^2
E0    = 8.85418781762e-12 # C^2/N m^2
ECHG  = 1.602176634e-19   # C
KB    = 1.380649e-23      # J/K
NA    = 6.02214076e23     # mol^-1

# ── Hardwired ─────────────────────────────────────────────────────────────────
H0     = 0.158e-9    # minimum separation distance (m)
SIGMAC = 5.0e-10     # Born collision diameter (m)
OUTMAX = 50000       # maximum output array length


# ── Random helpers ────────────────────────────────────────────────────────────
def generate_unif():
    """Generate 6 uniform random numbers as (sign, magnitude) pairs."""
    v = [random.random() for _ in range(6)]
    signs = [1.0 if x >= 0.5 else -1.0 for x in v]
    mags  = [abs(2.0*x - 1.0) for x in v]
    return signs[0],mags[0], signs[1],mags[1], signs[2],mags[2]


def calc_ni(p):
    """Inverse normal CDF (rational approximation)."""
    bigni = p
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

def force_vdw(A132, AG, AP, ASP, NASP, RMODE, H, LAMBDAVDW,
              A11, A22, A33, AC1C1, AC2C2, T1, T2, VDWMODE):
    """VDW force — sphere-sphere geometry (hap)."""
    A12   = A11**0.5 * A22**0.5
    A1C2  = A11**0.5 * AC2C2**0.5
    A13   = A11**0.5 * A33**0.5
    AC12  = AC1C1**0.5 * A22**0.5
    AC1C2 = AC1C1**0.5 * AC2C2**0.5
    AC13  = AC1C1**0.5 * A33**0.5
    A23   = A22**0.5 * A33**0.5
    AC23  = AC2C2**0.5 * A33**0.5

    # Effective sphere-sphere radius
    AEFF = AP * AG / (AP + AG)

    if VDWMODE == 1:
        if RMODE == 0:
            return -(A132*AEFF/(6.0*H**2)) * (LAMBDAVDW/(LAMBDAVDW + 5.32*H))
        elif RMODE == 1:
            H2    = H + ASP
            FVDW1 = -(A132*AEFF/(6.0*H2**2)) * (LAMBDAVDW/(LAMBDAVDW + 5.32*H2))
            FVDW2 = (-(A132*ASP/(6.0*H**2)) * (LAMBDAVDW/(LAMBDAVDW + 5.32*H))
                     if H <= ASP else 0.0)
            return FVDW1 + NASP*FVDW2
        elif RMODE == 2:
            H2    = H + ASP
            FVDW1 = -(A132*AEFF/(6.0*H2**2)) * (LAMBDAVDW/(LAMBDAVDW + 5.32*H2))
            FVDW2 = (-(A132*ASP*AP/(6.0*(ASP+AP)*H**2)) * (LAMBDAVDW/(LAMBDAVDW + 5.32*H))
                     if H <= ASP else 0.0)
            return FVDW1 + NASP*FVDW2
        else:  # RMODE==3
            H2    = H + 0.5*(2*ASP + 3**0.5*ASP)
            FVDW1 = -(A132*AEFF/(6.0*H2**2)) * (LAMBDAVDW/(LAMBDAVDW + 5.32*H2))
            FVDW2 = (-(A132*ASP*ASP/(6.0*(ASP+ASP)*H**2)) * (LAMBDAVDW/(LAMBDAVDW + 5.32*H))
                     if H <= ASP else 0.0)
            return FVDW1 + 2.5*NASP*FVDW2

    lam = LAMBDAVDW
    # For layered systems use sphere-sphere effective radius AEFF in place of AP
    if VDWMODE == 2:
        f  = -(AC1C2-AC23-AC13+A33) * (
               (lam/(lam+11.12*H) *
               ((AEFF+T1)/H**2 - 1/H + (AEFF+T1)/(H+2*T1+2*AEFF)**2 + 1/(H+2*T1+2*AEFF))
               + 11.12*lam/(lam+11.12*H)**2 *
               ((AEFF+T1)/H + (AEFF+T1)/(H+2*T1+2*AEFF) + math.log(H/(H+2*T1+2*AEFF))))/6)
        f -= (A1C2-AC1C2-A13+AC13) * (
               (lam/(lam+11.12*(H+T1)) *
               (AEFF/(H+T1)**2 - 1/(H+T1) + AEFF/(H+T1+2*AEFF)**2 + 1/(H+T1+2*AEFF))
               + 11.12*lam/(lam+11.12*(H+T1))**2 *
               (AEFF/(H+T1) + AEFF/(H+T1+2*AEFF) + math.log((H+T1)/(H+T1+2*AEFF))))/6)
        f -= (AC12-A23-AC1C2+AC23) * (
               (lam/(lam+11.12*(H+T2)) *
               ((AEFF+T1)/(H+T2)**2 - 1/(H+T2) + (AEFF+T1)/(H+2*T1+T2+2*AEFF)**2 + 1/(H+2*T1+T2+2*AEFF))
               + 11.12*lam/(lam+11.12*(H+T2)**2) *
               ((AEFF+T1)/(H+T2) + (AEFF+T1)/(H+2*T1+T2+2*AEFF) + math.log((H+T2)/(H+2*T1+T2+2*AEFF))))/6)
        f -= (A12-AC12-A1C2+AC1C2) * (
               (lam/(lam+11.12*(H+T1+T2)) *
               (AEFF/(H+T1+T2)**2 - 1/(H+T1+T2) + AEFF/(H+T1+T2+2*AEFF)**2 + 1/(H+T1+T2+2*AEFF))
               + 11.12*lam/(lam+11.12*(H+T1+T2))**2 *
               (AEFF/(H+T1+T2) + AEFF/(H+T1+T2+2*AEFF) + math.log((H+T1)/(H+T1+2*AEFF))))/6)
        return f
    if VDWMODE == 3:
        f  = -(A1C2-AC23-A13+A33) * (
               (lam/(lam+11.12*H) *
               (AEFF/H**2 - 1/H + AEFF/(H+2*AEFF)**2 + 1/(H+2*AEFF))
               + 11.12*lam/(lam+11.12*H)**2 *
               (AEFF/H + AEFF/(H+2*AEFF) + math.log(H/(H+2*AEFF))))/6)
        f -= (A12-A23-A1C2+AC23) * (
               (lam/(lam+11.12*(H+T2)) *
               (AEFF/(H+T2)**2 - 1/(H+T2) + AEFF/(H+T2+2*AEFF)**2 + 1/(H+T2+2*AEFF))
               + 11.12*lam/(lam+11.12*(H+T2))**2 *
               (AEFF/(H+T2) + AEFF/(H+T2+2*AEFF) + math.log((H+T2)/(H+T2+2*AEFF))))/6)
        return f
    if VDWMODE == 4:
        f  = -(AC12-A23-AC13+A33) * (
               (lam/(lam+11.12*H) *
               ((AEFF+T1)/H**2 - 1/H + (AEFF+T1)/(H+2*T1+2*AEFF)**2 + 1/(H+2*T1+2*AEFF))
               + 11.12*lam/(lam+11.12*H)**2 *
               ((AEFF+T1)/H + (AEFF+T1)/(H+2*T1+2*AEFF) + math.log(H/(H+2*T1+2*AEFF))))/6)
        f -= (A12-AC12-A13+AC13) * (
               (lam/(lam+11.12*(H+T1)) *
               (AEFF/(H+T1)**2 - 1/(H+T1) + AEFF/(H+T1+2*AEFF)**2 + 1/(H+T1+2*AEFF))
               + 11.12*lam/(lam+11.12*(H+T1))**2 *
               (AEFF/(H+T1) + AEFF/(H+T1+2*AEFF) + math.log((H+T1)/(H+T1+2*AEFF))))/6)
        return f
    return 0.0


def force_edl(KAPPA, KB_, ERE0_, T_, ZI, ECHG_, ZETAC, ZETAP,
              AG, AP, ASP, NASP, RMODE, H):
    """EDL force — sphere-sphere geometry (hap)."""
    J_ = 1.0 - (PI/4.0)
    AEFF = AP * AG / (AP + AG)
    def coef_ss(zc, zp, r1, r2):
        return (64.0*PI*ERE0_*r1*r2/(r1+r2)*(KB_*T_/ZI/ECHG_)**2
                * math.tanh(ZI*ECHG_*zc/4/KB_/T_)
                * math.tanh(ZI*ECHG_*zp/4/KB_/T_)
                * KAPPA*math.exp(-KAPPA*H))
    def coef_asp_ss(zc, zp, r1, r2):
        """Sphere-sphere for asperity-collector."""
        return (64.0*PI*ERE0_*r1*r2/(r1+r2)*(KB_*T_/ZI/ECHG_)**2
                * math.tanh(ZI*ECHG_*zc/4/KB_/T_)
                * math.tanh(ZI*ECHG_*zp/4/KB_/T_)
                * KAPPA*math.exp(-KAPPA*H))

    if RMODE == 0:
        FEDL = coef_ss(ZETAC, ZETAP, AG, AP)
    elif RMODE == 1:
        H2    = H + ASP
        FEDL1 = (64.0*PI*ERE0_*AG*AP/(AG+AP)*(KB_*T_/ZI/ECHG_)**2
                 * math.tanh(ZI*ECHG_*ZETAC/4/KB_/T_)
                 * math.tanh(ZI*ECHG_*ZETAP/4/KB_/T_)
                 * KAPPA*math.exp(-KAPPA*H2))
        FEDL2 = (coef_asp_ss(ZETAC, ZETAP, AG, ASP) if H <= ASP else 0.0)
        FEDL  = J_*FEDL1 + NASP*FEDL2
    elif RMODE == 2:
        H2    = H + ASP
        FEDL1 = (64.0*PI*ERE0_*AG*AP/(AG+AP)*(KB_*T_/ZI/ECHG_)**2
                 * math.tanh(ZI*ECHG_*ZETAC/4/KB_/T_)
                 * math.tanh(ZI*ECHG_*ZETAP/4/KB_/T_)
                 * KAPPA*math.exp(-KAPPA*H2))
        FEDL2 = (coef_asp_ss(ZETAC, ZETAP, AP, ASP) if H <= ASP else 0.0)
        FEDL  = J_*FEDL1 + NASP*FEDL2
    else:  # RMODE==3
        H2    = H + 0.5*(2*ASP + 3**0.5*ASP)
        FEDL1 = (64.0*PI*ERE0_*AG*AP/(AG+AP)*(KB_*T_/ZI/ECHG_)**2
                 * math.tanh(ZI*ECHG_*ZETAC/4/KB_/T_)
                 * math.tanh(ZI*ECHG_*ZETAP/4/KB_/T_)
                 * KAPPA*math.exp(-KAPPA*H2))
        FEDL2 = (coef_asp_ss(ZETAC, ZETAP, ASP, ASP) if H <= ASP else 0.0)
        FEDL  = J_*FEDL1 + 2.5*NASP*FEDL2
    if abs(FEDL) < 1.0e-30:
        FEDL = 0.0
    return FEDL


def force_ab(AG, AP, ASP, NASPAB, RMODE, LAMBDAAB, GAMMA0AB, H):
    """Lewis acid-base force — sphere-sphere geometry (hap)."""
    AEFF = AP * AG / (AP + AG)
    if RMODE == 0:
        return (2*PI*AEFF*GAMMA0AB*math.exp(-(H-H0)/LAMBDAAB)
                * (1 - LAMBDAAB/AEFF + (1 + LAMBDAAB/AEFF)*math.exp(-2*AEFF/LAMBDAAB)))
    elif RMODE == 1:
        if H <= ASP:
            AEFF2 = ASP*AG/(ASP+AG)
            FAB1 = (2*PI*AEFF2*GAMMA0AB*math.exp(-(H-H0)/LAMBDAAB)
                    * (1 - LAMBDAAB/AEFF2 + (1 + LAMBDAAB/AEFF2)*math.exp(-2*AEFF2/LAMBDAAB)))
        else:
            FAB1 = 0.0
        return NASPAB*FAB1
    elif RMODE == 2:
        AEFF2 = ASP*AP/(ASP+AP)
        LOWG  = 1 - LAMBDAAB/AEFF2 + (1 + LAMBDAAB/AEFF2)*math.exp(-2*AEFF2/LAMBDAAB)
        HIGHG = (1 - LAMBDAAB/AEFF2 + LAMBDAAB**2/(2*AEFF2**2)
                 - (4*AEFF2/(3*LAMBDAAB))*math.exp(-2*AEFF2/LAMBDAAB)
                 - (1 + LAMBDAAB/AEFF2 + LAMBDAAB**2/(2*AEFF2**2))*math.exp(-4*AEFF2/LAMBDAAB))
        COEFF = (1 - ASP/AP)*LOWG + ASP/AP*HIGHG
        FAB1  = (COEFF*PI*AEFF2*GAMMA0AB*math.exp(-(H-H0)/LAMBDAAB) if H <= ASP else 0.0)
        return NASPAB*FAB1
    else:  # RMODE==3
        COEFF = (1 - LAMBDAAB/ASP + LAMBDAAB**2/(2*ASP**2)
                 - (4*ASP/(3*LAMBDAAB))*math.exp(-2*ASP/LAMBDAAB)
                 - (1 + LAMBDAAB/ASP + LAMBDAAB**2/(2*ASP**2))*math.exp(-4*ASP/LAMBDAAB))
        FAB1  = (COEFF*PI*ASP*GAMMA0AB*math.exp(-(H-H0)/LAMBDAAB) if H <= ASP else 0.0)
        return 2.5*NASPAB*FAB1


def force_born(A132, AP, H, A11, A22, A33, AC1C1, AC2C2, VDWMODE):
    """Born repulsion force (same as jet — sphere-plate approximation)."""
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
    """Steric repulsion force."""
    return GAMMA0STE/LAMBDASTE * math.exp(-H/LAMBDASTE) * PI * ASTE**2


def force_drag(FUN2, FUN3, FUN4, M3, VN, VT):
    """Hydrodynamic drag forces — normal and tangential."""
    FDRGT = FUN3/FUN4 * M3 * VT
    FDRGN = FUN2 * M3 * VN
    return FDRGT, FDRGN


def force_diff(DIFFSCALE, VISC, AP, T_, dT):
    """Brownian diffusion force."""
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
    """Gravity force magnitude."""
    return GRAVFACT * (4.0/3.0)*PI*(AP**3)*(RHOP - RHOW)*G_G


def gravvect(FG, EGX, EGY, EGZ, ENX, ENY, ENZ, ETX, ETY, ETZ):
    """Decompose gravity into normal and tangential components."""
    FGN  = FG * (EGX*ENX + EGY*ENY + EGZ*ENZ)
    FGNX = FGN * ENX
    FGNY = FGN * ENY
    FGNZ = FGN * ENZ
    FGT  = FG * (EGX*ETX + EGY*ETY + EGZ*ETZ)
    FGTX = FGT * ETX
    FGTY = FGT * ETY
    FGTZ = FGT * ETZ
    return FGN, FGNX, FGNY, FGNZ, FGT, FGTX, FGTY, FGTZ


def force_lift(RHOW, R, AP, AG, VT, UT, OMEGA):
    """Lift force (Yahiaoui & Feuillebois 2010) — sphere-sphere geometry."""
    # Distance from collector surface
    H_surf = R - AG - AP
    Z_eff  = AG + AP + H_surf   # distance from collector centre
    if Z_eff > 100.0*AP:
        return 0.0
    KS    = VT/Z_eff if Z_eff != 0 else 0.0
    lnzap = math.log(Z_eff/AP)
    LS  = math.exp(2.221 + 1.565*lnzap + 0.06602*lnzap**2)
    LR  = math.exp(-1.0*(0.6390 + 1.408*lnzap)/(1.0 - 0.1036*lnzap + 0.01136*lnzap**2))
    LT  = ((1.751 + 6.147*lnzap + 3.299*lnzap**2 - 2.485*lnzap**3 + 1.952*lnzap**4)
           / (1.0 + 3.714*lnzap + 1.481*lnzap**2 - 1.278*lnzap**3 + 1.0905*lnzap**4))
    LRT = (-lnzap*(10.97 + 439.4*lnzap + 355.0*lnzap**2 + 171.6*lnzap**3)
           / (1.0 + 7.309*lnzap + 284.7*lnzap**2 + 86.45*lnzap**3 + 77.45*lnzap**4))
    LSR = math.exp((-4.723 - 11.11*lnzap + 41.76*lnzap**2)/(1.0 + 20.31*lnzap))
    LST = (-10.76 - 2.158*lnzap - 4.218*lnzap**2)/(1.0 - 0.1749*lnzap)
    return RHOW*AP**2 * ((AP*KS)**2*LS + (AP*OMEGA)**2*LR + UT**2*LT
                          + (AP*OMEGA*UT)*LRT + (AP**2*OMEGA*KS)*LSR
                          + (AP*KS*UT)*LST)


# ── Happel flow field ─────────────────────────────────────────────────────────
def happel_ff(X, Y, Z, AG, B, K1, K2, K3, K4):
    """
    Happel sphere-in-cell flow field.
    Returns dimensionless velocity components (multiply by VSUP for physical).
    Ported from SUBROUTINE HAPPELFF — flow is from +Z to -Z.
    """
    RO   = (X**2 + Y**2 + Z**2)**0.5
    if RO == 0.0:
        return 0.0, 0.0, 0.0
    RDIS      = RO / AG
    RDISSLIP  = (RO + B) / AG
    ROXY = (X**2 + Y**2)**0.5
    FT = (-K1/(2.0*RDISSLIP**3) + K2/(2.0*RDISSLIP)
          + K3 + 2.0*K4*RDISSLIP**2)
    FN = K1/RDIS**3 + K2/RDIS + K3 + K4*RDIS**2
    VxH1 = (X*Z/RO**2) * (-FN + FT)
    VyH1 = (Y*Z/RO**2) * (-FN + FT)
    VzH1 = (Z/RO)**2 * (-FN) + (ROXY/RO)**2 * (-FT)
    return VxH1, VyH1, VzH1


# ── Initial position ──────────────────────────────────────────────────────────
def initial(RLIM, AG, AP, ASP, RMODE, RB):
    """Generate random initial particle position on fluid shell envelope."""
    RINJ = 2.0*RLIM
    while RINJ > RLIM:
        rs1,rn1,rs2,rn2,_,_ = generate_unif()
        XINIT = rs1*rn1*RLIM
        YINIT = rs2*rn2*RLIM
        RINJ  = (XINIT**2 + YINIT**2)**0.5
    RINIT = RB
    ZINIT = (RINIT**2 - XINIT**2 - YINIT**2)**0.5
    if   RMODE == 0: HINIT = RINIT - AG - AP
    elif RMODE in (1,2): HINIT = RINIT - AG - AP - ASP
    else: HINIT = RINIT - AG - AP - 0.5*(2*ASP + 3**0.5*ASP)
    return XINIT, YINIT, RINJ, ZINIT, RINIT, HINIT


# ── HFRIC and HMIN scan ────────────────────────────────────────────────────────
def find_hfric_hmin(AG, AP, ASP, ASTE, GAMMA0AB, LAMBDAAB, GAMMA0STE, LAMBDASTE,
                    A132, SIGMAC, A11, A22, A33, AC1C1, AC2C2, VDWMODE, LAMBDAVDW,
                    KAPPA, KB_, ERE0_, T_, ZI, ECHG_, ZETACST, ZETAPST):
    """Scan from H0 upward to find HFRIC and HMIN — sphere-sphere geometry."""
    ASP0, NASP0, RMODE0 = 0.0, 0.0, 0
    H = H0
    FBORN0 = force_born(A132, AP, H, A11, A22, A33, AC1C1, AC2C2, VDWMODE)
    FSTE0  = force_ste(GAMMA0STE, LAMBDASTE, ASTE, H)
    FAB0   = force_ab(AG, AP, ASP0, NASP0, RMODE0, LAMBDAAB, GAMMA0AB, H)
    FBORNFRIC = 0.0001 * FBORN0
    FSTEFRIC  = 0.0001 * FSTE0
    FABFRIC   = 0.0001 * FAB0
    HFRIC = H0
    while (force_born(A132, AP, H, A11, A22, A33, AC1C1, AC2C2, VDWMODE) > FBORNFRIC
           or force_ste(GAMMA0STE, LAMBDASTE, ASTE, H) > FSTEFRIC
           or abs(force_ab(AG, AP, ASP0, NASP0, RMODE0, LAMBDAAB, GAMMA0AB, H)) > abs(FABFRIC)):
        H += 1.0e-12
        HFRIC = H

    H     = H0
    FCOLL = 1.0
    HMIN  = H0
    while FCOLL > 0.0:
        HMIN = H
        H   += 1.0e-12
        FVDW = min(0.0, force_vdw(A132, AG, AP, ASP0, NASP0, RMODE0, H, LAMBDAVDW,
                                   A11, A22, A33, AC1C1, AC2C2, 0.0, 0.0, VDWMODE))
        FEDL = min(0.0, force_edl(KAPPA, KB_, ERE0_, T_, ZI, ECHG_, ZETACST, ZETAPST,
                                   AG, AP, ASP0, NASP0, RMODE0, H))
        FAB  = min(0.0, force_ab(AG, AP, ASP0, NASP0, RMODE0, LAMBDAAB, GAMMA0AB, H))
        FBORN= force_born(A132, AP, H, A11, A22, A33, AC1C1, AC2C2, VDWMODE)
        FCOLL = FVDW + FEDL + FAB + FBORN
    return HFRIC, HMIN



def read_input(fname):
    """Read INPUT.IN for hap code. Only lines whose first token is numeric."""
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

    # Matches Fortran READ sequence exactly (TRAJ-HAP.for lines 144-172)
    v = nxt_line(); NPART=int(v[0]); HNS=float(v[1]); ATTMODE=int(v[2]); CLUSTER=int(v[3])
    v = nxt_line(); VSUP=float(v[0]); RLIM=float(v[1]); POROSITY=float(v[2]); AG=float(v[3]); TTIME=float(v[4])
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
    v = nxt_line(); DIFFSCALE=float(v[0]); GRAVFACT=float(v[1]); CBGRAV=int(v[2])
    v = nxt_line(); MULTB=float(v[0]); MULTNS=float(v[1]); MULTC=float(v[2]); DFACTNS=float(v[3]); DFACTC=float(v[4])
    v = nxt_line(); NOUT=int(v[0]); PRINTMAX=int(v[1])

    return dict(NPART=NPART, HNS=HNS, ATTMODE=ATTMODE, CLUSTER=CLUSTER,
                VSUP=VSUP, RLIM=RLIM, POROSITY=POROSITY, AG=AG, TTIME=TTIME,
                AP=AP, RHOP=RHOP, RHOW=RHOW, VISC=VISC, ER=ER, T=T_,
                IS=IS_, ZI=ZI, ZETAPST=ZETAPST, ZETACST=ZETACST,
                ZETAHET=ZETAHET, HETMODE=HETMODE, RHET0=RHET0, RHET1=RHET1,
                SCOV=SCOV,
                ZETAHETP=ZETAHETP, HETMODEP=HETMODEP, RHETP0=RHETP0,
                RHETP1=RHETP1, SCOVP=SCOVP,
                A132=A132, LAMBDAVDW=LAMBDAVDW, VDWMODE=VDWMODE,
                A11=A11, AC1C1=AC1C1, A22=A22, AC2C2=AC2C2, A33=A33,
                T1=T1, T2=T2,
                GAMMA0AB=GAMMA0AB, LAMBDAAB=LAMBDAAB,
                GAMMA0STE=GAMMA0STE, LAMBDASTE=LAMBDASTE,
                B=B, RMODE=RMODE, ASP=ASP, ASP2=ASP2,
                KINT=KINT, W132=W132, BETA=BETA,
                DIFFSCALE=DIFFSCALE, GRAVFACT=GRAVFACT, CBGRAV=CBGRAV,
                MULTB=MULTB, MULTNS=MULTNS, MULTC=MULTC,
                DFACTNS=DFACTNS, DFACTC=DFACTC,
                NOUT=NOUT, PRINTMAX=PRINTMAX)


# ── Heterodomain subroutines ──────────────────────────────────────────────────

def _rotation_matrix(PHI, THETA):
    """Rotation matrix for colloid spherical coordinates (ROTATION subroutine)."""
    PHI_R   = 0.5*PI + PHI
    THETA_R = THETA
    PSI_R   = 1.5*PI - PHI
    q0 = math.cos(0.5*PHI_R + 0.5*PSI_R)*math.cos(0.5*THETA_R)
    q1 = math.cos(0.5*PHI_R - 0.5*PSI_R)*math.sin(0.5*THETA_R)
    q2 = math.sin(0.5*PHI_R - 0.5*PSI_R)*math.sin(0.5*THETA_R)
    q3 = math.sin(0.5*PHI_R + 0.5*PSI_R)*math.cos(0.5*THETA_R)
    MR = [[1-2*(q2**2+q3**2), 2*(q1*q2-q0*q3), 2*(q1*q3-q2*q0)],
          [2*(q1*q2-q3*q0),   1-2*(q1**2+q3**2), 2*(q0*q1+q2*q3)],
          [2*(q0*q2+q1*q3),   2*(q2*q3-q0*q1), 1-2*(q1**2+q2**2)]]
    return MR


def _transformation(XG, YG, ZG, PHI, THETA, points):
    """
    Transform points to frame with XY plane parallel to Happel sphere at colloid
    projection. points is list of [x,y,z] rows. Returns transformed list.
    (TRANSFORMATION subroutine)
    """
    PHI_R   = 0.5*PI + PHI
    THETA_R = THETA
    PSI_R   = 1.5*PI - PHI
    q0 = math.cos(0.5*PHI_R + 0.5*PSI_R)*math.cos(0.5*THETA_R)
    q1 = math.cos(0.5*PHI_R - 0.5*PSI_R)*math.sin(0.5*THETA_R)
    q2 = math.sin(0.5*PHI_R - 0.5*PSI_R)*math.sin(0.5*THETA_R)
    q3 = math.sin(0.5*PHI_R + 0.5*PSI_R)*math.cos(0.5*THETA_R)
    MR = [[1-2*(q2**2+q3**2), 2*(q1*q2-q0*q3), 2*(q1*q3-q2*q0)],
          [2*(q1*q2-q3*q0),   1-2*(q1**2+q3**2), 2*(q0*q1+q2*q3)],
          [2*(q0*q2+q1*q3),   2*(q2*q3-q0*q1), 1-2*(q1**2+q2**2)]]
    # Unit vectors of collector frame rotated
    EX_G = [MR[0][0], MR[0][1], MR[0][2]]
    EY_G = [MR[1][0], MR[1][1], MR[1][2]]
    EZ_G = [MR[2][0], MR[2][1], MR[2][2]]
    MT = [[EX_G[0], EY_G[0], EZ_G[0]],
          [EX_G[1], EY_G[1], EZ_G[1]],
          [EX_G[2], EY_G[2], EZ_G[2]]]
    result = []
    for p in points:
        dx = p[0]-XG; dy = p[1]-YG; dz = p[2]-ZG
        tx = dx*MT[0][0] + dy*MT[1][0] + dz*MT[2][0]
        ty = dx*MT[0][1] + dy*MT[1][1] + dz*MT[2][1]
        tz = dx*MT[0][2] + dy*MT[1][2] + dz*MT[2][2]
        result.append([tx, ty, tz])
    return result



    RDHET = ((XHET-XmP0)**2 + (YHET-YmP0)**2)**0.5
    # Upper hemisphere of colloid — no projection
    if ZL <= ZHET <= ZU:
        return 0.0, 0.0, 0.0, 0.0
    # Outside radial limit
    if RDHET >= RPL:
        return 0.0, 0.0, 0.0, 0.0
    DC   = DAP * math.sin(BETA)
    DX   = DC  * math.cos(PHI_)
    DY   = DC  * math.sin(PHI_)
    A    = RPRO
    B_   = RPRO * math.cos(BETA)
    return XHET-DX, YHET-DY, -(AP+H), (A*B_)**0.5


def _project_hetdomain(XHET, YHET, ZHET, RHET_val, XmP0, YmP0, ZmP0,
                        AP, H, RPL, ZU, ZL, RPRO, DAP):
    """
    Project a single heterodomain on colloid surface onto collector plane.
    Returns (XPRO, YPRO, ZPRO, RPRO_val) — zeros if outside limits.
    """
    arg = (ZmP0-ZHET)/AP
    arg = max(-1.0, min(1.0, arg))
    BETA  = math.acos(arg)
    PHI_  = math.atan2(YHET-YmP0, XHET-XmP0)
    RDHET = ((XHET-XmP0)**2 + (YHET-YmP0)**2)**0.5
    # Upper hemisphere of colloid — no projection
    if ZL <= ZHET <= ZU:
        return 0.0, 0.0, 0.0, 0.0
    # Outside radial limit
    if RDHET >= RPL:
        return 0.0, 0.0, 0.0, 0.0
    DC   = DAP * math.sin(BETA)
    DX   = DC  * math.cos(PHI_)
    DY   = DC  * math.sin(PHI_)
    A    = RPRO
    B_   = RPRO * math.cos(BETA)
    return XHET-DX, YHET-DY, -(AP+H), (A*B_)**0.5


def hettrackp(XmP0, YmP0, ZmP0, H, RZOIBULK, AP, HETMODEP, SCOVP,
              RHETP0, RHETP1):
    """
    Generate colloid heterodomain projections onto Happel sphere.
    Returns (NPRO, XPRO_list, YPRO_list, ZPRO_list, RPRO_list)
    (HETTRACKP subroutine — HETMODEP=1 and 9 only)
    """
    RPL   = RZOIBULK + RHETP0
    ZU    = AP + ZmP0
    ZL    = ZmP0
    OMEGA0 = RHETP0/AP
    OMEGA1 = RHETP1/AP if RHETP1 > 0 else 0.0
    DAP   = AP*(1 - math.cos(OMEGA0))
    RPRO0 = AP*math.sin(OMEGA0)
    RPRO1 = AP*math.sin(OMEGA1) if RHETP1 > 0 else 0.0
    HMODEREAL = float(HETMODEP)

    if HETMODEP == 1:
        SCOVP0 = SCOVP
    else:
        SCOVP0 = SCOVP*((1-math.cos(OMEGA0))
                        /((1-math.cos(OMEGA0))
                          +(HMODEREAL-1)*(1-math.cos(OMEGA1))))

    NHETP0 = round(SCOVP0*4.0/(2.0*(1-math.cos(OMEGA0))))
    if NHETP0 == 0:
        return 0, [], [], [], []

    NHETREAL0 = float(NHETP0)
    NRING = round((NHETREAL0/1.3)**0.5)
    if NRING < 2: NRING = 2
    NRINGREAL = float(NRING)
    DTHETA = PI/(NRINGREAL-1.0)
    ARCL   = DTHETA*AP

    XPRO_list=[]; YPRO_list=[]; ZPRO_list=[]; RPRO_list=[]

    for i in range(1, NRING+1):
        THETA = (i-1)*DTHETA
        if i == 1 or i == NRING:
            # Poles
            THETA = 0.0 if i==1 else PI
            for j in range(1, HETMODEP+1):
                if j == 1:
                    PHI_ = 0.0
                    XHET = ZmP0  # at pole, RRING=0 so X=XmP0 but Fortran uses XmP0
                    XHET = XmP0
                    YHET = YmP0
                    ZHET = AP*math.cos(THETA)+ZmP0
                    xp,yp,zp,rp = _project_hetdomain(XHET,YHET,ZHET,RHETP0,
                        XmP0,YmP0,ZmP0,AP,H,RPL,ZU,ZL,RPRO0,DAP)
                    if rp > 0:
                        XPRO_list.append(xp); YPRO_list.append(yp)
                        ZPRO_list.append(zp); RPRO_list.append(rp)
                elif HETMODEP == 9:
                    DTHETA1 = 1.0/3.0*DTHETA
                    THETA1 = THETA + DTHETA1
                    R1 = AP*math.sin(THETA1)
                    PHI_ = (j-2)*PI/4.0
                    XHET = R1*math.cos(PHI_)+XmP0
                    YHET = R1*math.sin(PHI_)+YmP0
                    ZHET = AP*math.cos(THETA1)+ZmP0
                    xp,yp,zp,rp = _project_hetdomain(XHET,YHET,ZHET,RHETP1,
                        XmP0,YmP0,ZmP0,AP,H,RPL,ZU,ZL,RPRO1,DAP)
                    if rp > 0:
                        XPRO_list.append(xp); YPRO_list.append(yp)
                        ZPRO_list.append(zp); RPRO_list.append(rp)
        else:
            # Off-pole rings
            RRING = AP*math.sin(THETA)
            NHETRING = round(2.0*PI*RRING/ARCL)
            if NHETRING < 3: NHETRING = 3
            NHRINGREAL = float(NHETRING)
            DPHI = 2.0*PI/NHRINGREAL
            M = i % 2
            PHIOFF = 0.1*DPHI if M==0 else -0.1*DPHI
            for k in range(1, NHETRING+1):
                PHI_ = (k-1)*DPHI + PHIOFF
                if PHI_ > 2.0*PI:
                    PHI_ = 2.0*PI*((PHI_/(2.0*PI)) - int(PHI_/(2.0*PI)))
                for j in range(1, HETMODEP+1):
                    if j == 1:
                        XHET = RRING*math.cos(PHI_)+XmP0
                        YHET = RRING*math.sin(PHI_)+YmP0
                        ZHET = AP*math.cos(THETA)+ZmP0
                        xp,yp,zp,rp = _project_hetdomain(XHET,YHET,ZHET,RHETP0,
                            XmP0,YmP0,ZmP0,AP,H,RPL,ZU,ZL,RPRO0,DAP)
                        if rp > 0:
                            XPRO_list.append(xp); YPRO_list.append(yp)
                            ZPRO_list.append(zp); RPRO_list.append(rp)
                    elif HETMODEP == 9:
                        DTHETA1 = 1.0/3.0*DTHETA
                        DPHI1   = 1.0/3.0*DPHI
                        phi_offsets  = {2:-1,3:+1,4:+1,5:-1,6:-1,7:0,8:+1,9:0}
                        theta_offsets= {2:+1,3:+1,4:-1,5:-1,6:-1,7:+1,8:0, 9:-1}
                        PHI1   = PHI_ + phi_offsets[j]*DPHI1
                        THETA1 = THETA + theta_offsets[j]*DTHETA1
                        R1 = AP*math.sin(THETA1)
                        XHET = R1*math.cos(PHI1)+XmP0
                        YHET = R1*math.sin(PHI1)+YmP0
                        ZHET = AP*math.cos(THETA1)+ZmP0
                        xp,yp,zp,rp = _project_hetdomain(XHET,YHET,ZHET,RHETP1,
                            XmP0,YmP0,ZmP0,AP,H,RPL,ZU,ZL,RPRO1,DAP)
                        if rp > 0:
                            XPRO_list.append(xp); YPRO_list.append(yp)
                            ZPRO_list.append(zp); RPRO_list.append(rp)

    NPRO = len(RPRO_list)
    return NPRO, XPRO_list, YPRO_list, ZPRO_list, RPRO_list


def mpro_transformation(X, Y, Z, XG, YG, ZG, THETA, PHI, NPRO,
                         MPRO_x, MPRO_y, MPRO_z, MPRO_r):
    """
    Transform colloid heterodomain projections to collector frame.
    Returns (MPRO_T_x, MPRO_T_y, MPRO_T_r) lists.
    (MPRO_TRANSFORMATION subroutine)
    """
    MR = _rotation_matrix(PHI, THETA)
    # Rotate projections
    MI = []
    for i in range(NPRO):
        x_ = MPRO_x[i]; y_ = MPRO_y[i]; z_ = MPRO_z[i]
        rx = x_*MR[0][0] + y_*MR[1][0] + z_*MR[2][0]
        ry = x_*MR[0][1] + y_*MR[1][1] + z_*MR[2][1]
        rz = x_*MR[0][2] + y_*MR[1][2] + z_*MR[2][2]
        MI.append([rx+X, ry+Y, rz+Z])
    # Transform to collector frame
    MI_T = _transformation(XG, YG, ZG, PHI, THETA, MI)
    MPRO_T_x = [p[0] for p in MI_T]
    MPRO_T_y = [p[1] for p in MI_T]
    MPRO_T_r = list(MPRO_r)
    return MPRO_T_x, MPRO_T_y, MPRO_T_r


def hettrack(X, Y, Z, Xm0, Ym0, Zm0, AG, RZOI, HETMODE, SCOV,
             RHET0, RHET1):
    """
    Generate collector heterodomain positions closest to colloid.
    Returns (XHET, YHET, ZHET, RHET) as lists of length HETMODE.
    (HETTRACK subroutine — HETMODE=1 and 9 only)
    """
    HMODEREAL = float(HETMODE)
    if HETMODE == 9:
        HM1 = 8.0
    else:
        HM1 = 0.0

    SCOV0 = SCOV*(RHET0**2)/(RHET0**2 + HM1*RHET1**2) if (RHET0**2 + HM1*RHET1**2) > 0 else SCOV
    NHET0 = round(SCOV0*(4.0*AG**2)/RHET0**2) if RHET0 > 0 else 0
    if NHET0 == 0:
        XHET=[Xm0]*HETMODE; YHET=[Ym0]*HETMODE
        ZHET=[AG+Zm0]*HETMODE; RHET_=[RHET0]*HETMODE
        return XHET, YHET, ZHET, RHET_

    NHETREAL0 = float(NHET0)
    NRING = round((NHETREAL0/1.3)**0.5)
    if NRING < 2: NRING = 2
    NRINGREAL = float(NRING)
    DTHETA = PI/(NRINGREAL-1.0)
    ARCL   = DTHETA*AG

    # Colloid spherical coordinates
    RO    = ((X-Xm0)**2+(Y-Ym0)**2+(Z-Zm0)**2)**0.5
    THETAP = math.acos(max(-1.0,min(1.0,(Z-Zm0)/RO)))
    ROXY  = ((X-Xm0)**2+(Y-Ym0)**2)**0.5
    if ROXY == 0.0:
        PHIP = 0.0
    elif (Y-Ym0) >= 0.0:
        PHIP = math.acos(max(-1.0,min(1.0,(X-Xm0)/ROXY)))
    else:
        PHIP = 2.0*PI - math.acos(max(-1.0,min(1.0,(X-Xm0)/ROXY)))

    NTHETAP = round(THETAP/DTHETA) + 1

    XHET=[]; YHET=[]; ZHET=[]; RHET_=[]

    if NTHETAP == 1 or NTHETAP == NRING:
        # Poles
        DTHETA1 = 1.0/3.0*DTHETA
        THETA = 0.0 if NTHETAP==1 else PI
        for j in range(1, HETMODE+1):
            if j == 1:
                PHI_ = 0.0
                XHET.append(Xm0); YHET.append(Ym0)
                ZHET.append(AG*math.cos(THETA)+Zm0); RHET_.append(RHET0)
            elif HETMODE == 9:
                THETA1 = THETA + DTHETA1
                R1 = AG*math.sin(THETA1)
                PHI_ = (j-2)*PI/4.0
                XHET.append(R1*math.cos(PHI_)+Xm0)
                YHET.append(R1*math.sin(PHI_)+Ym0)
                ZHET.append(AG*math.cos(THETA1)+Zm0)
                RHET_.append(RHET1)
            else:
                XHET.append(Xm0); YHET.append(Ym0)
                ZHET.append(AG*math.cos(THETA)+Zm0); RHET_.append(RHET0)
    else:
        # Off-pole ring
        THETA = (NTHETAP-1)*DTHETA
        RRING = AG*math.sin(THETA)
        NHETRING = round(2.0*PI*RRING/ARCL)
        if NHETRING < 3: NHETRING = 3
        NHRINGREAL = float(NHETRING)
        DPHI = 2.0*PI/NHRINGREAL
        M = NTHETAP % 2
        PHIOFF = 0.1*DPHI if M==0 else -0.1*DPHI
        PHI_ = DPHI*round((PHIP-PHIOFF)/DPHI) + PHIOFF
        if PHI_ > 2.0*PI:
            PHI_ = 2.0*PI*((PHI_/(2.0*PI)) - int(PHI_/(2.0*PI)))
        for j in range(1, HETMODE+1):
            if j == 1:
                XHET.append(RRING*math.cos(PHI_)+Xm0)
                YHET.append(RRING*math.sin(PHI_)+Ym0)
                ZHET.append(AG*math.cos(THETA)+Zm0); RHET_.append(RHET0)
            elif HETMODE == 9:
                DTHETA1 = 1.0/3.0*DTHETA
                F_THETA1 = round(1.155*math.sin(2.094*(j-1)+3.142))
                THETA1 = THETA + F_THETA1*DTHETA1
                DPHI1  = 1.0/3.0*DPHI
                F_PHI1 = round(1.115*math.sin(0.5236*(j-1)+3.927)
                               + 0.2989*math.sin(3.665*(j-1)-7.069))
                PHI1   = PHI_ + F_PHI1*DPHI1
                R1 = AG*math.sin(THETA1)
                XHET.append(R1*math.cos(PHI1)+Xm0)
                YHET.append(R1*math.sin(PHI1)+Ym0)
                ZHET.append(AG*math.cos(THETA1)+Zm0); RHET_.append(RHET1)
            else:
                XHET.append(RRING*math.cos(PHI_)+Xm0)
                YHET.append(RRING*math.sin(PHI_)+Ym0)
                ZHET.append(AG*math.cos(THETA)+Zm0); RHET_.append(RHET0)

    return XHET, YHET, ZHET, RHET_


def hetc_transformation(XG, YG, ZG, XHET, YHET, ZHET, RHET_, HETMODE, THETA, PHI):
    """
    Transform collector heterodomain positions to colloid projection frame.
    (HETC_TRANSFORMATION subroutine)
    """
    points = [[XHET[k], YHET[k], ZHET[k]] for k in range(HETMODE)]
    pts_t  = _transformation(XG, YG, ZG, PHI, THETA, points)
    XHET_T = [p[0] for p in pts_t]
    YHET_T = [p[1] for p in pts_t]
    ZHET_T = [p[2] for p in pts_t]
    RHET_T = list(RHET_)
    return XHET_T, YHET_T, ZHET_T, RHET_T


# ── fractional_area (ported from jet — identical logic) ───────────────────────
def circle_overlap_area(R1, R2, D):
    if D >= R1+R2: return 0.0
    if D <= abs(R1-R2): return PI*min(R1,R2)**2
    R1_2=R1**2; R2_2=R2**2; D_2=D**2
    def ca(arg): return math.acos(max(-1.0,min(1.0,arg)))
    A1=ca((D_2+R1_2-R2_2)/(2*D*R1))
    A2=ca((D_2+R2_2-R1_2)/(2*D*R2))
    return R1_2*A1+R2_2*A2-0.5*((-D+R1+R2)*(D+R1-R2)*(D-R1+R2)*(D+R1+R2))**0.5


def fractional_area(XP, YP, RZOI, XHET, YHET, RHET_val, NPRO, MPRO_T_x, MPRO_T_y, MPRO_T_r):
    """
    Calculate fractional overlap areas between ZOI, heterodomain, and projections.
    Returns (AF_PZ, AF_ZH, AF_PZH, AF_Z).
    """
    RZ = RZOI; RH = RHET_val
    DXZH = XHET-XP; DYZH = YHET-YP
    DZH   = (DXZH**2+DYZH**2)**0.5
    SUMRZH  = RZ+RH
    DIFFRZH = RZ-RH

    if DZH >= SUMRZH:    AZH = 0
    elif abs(DIFFRZH) >= DZH: AZH = -1
    else:                AZH = 1

    S1 = NPRO
    Ao2_1_pz = [0.0]*S1
    Ao2_1_ph = [0.0]*S1
    for i in range(S1):
        rr = MPRO_T_r[i]
        dx_pz = MPRO_T_x[i]-XP;   dy_pz = MPRO_T_y[i]-YP
        dx_ph = MPRO_T_x[i]-XHET; dy_ph = MPRO_T_y[i]-YHET
        D_pz  = (dx_pz**2+dy_pz**2)**0.5
        D_ph  = (dx_ph**2+dy_ph**2)**0.5
        Ao2_1_pz[i] = circle_overlap_area(rr, RZ, D_pz)
        Ao2_1_ph[i] = circle_overlap_area(rr, RH, D_ph)

    Ao2_2 = circle_overlap_area(RZ, RH, DZH)

    Ao2_PZ = [0.0]*S1; Ao2_ZH_per=[0.0]*S1; Ao3_F=[0.0]*S1

    for i in range(S1):
        rr = MPRO_T_r[i]
        dx_pz=MPRO_T_x[i]-XP; dy_pz=MPRO_T_y[i]-YP; D_pz=(dx_pz**2+dy_pz**2)**0.5
        dx_ph=MPRO_T_x[i]-XHET; dy_ph=MPRO_T_y[i]-YHET; D_ph=(dx_ph**2+dy_ph**2)**0.5
        if D_pz < RZ+rr:
            APZ = -1 if D_pz <= abs(RZ-rr) else 1
        else:
            APZ = 0
        if D_ph < RH+rr:
            APH = -1 if D_ph <= abs(RH-rr) else 1
        else:
            APH = 0
        pz=Ao2_1_pz[i]; ph=Ao2_1_ph[i]

        if APZ==1 and APH==1:
            if AZH==0:
                Ao2_PZ[i]=pz
            elif AZH==1:
                Ao3_F[i]=min(pz,ph,Ao2_2)
                Ao2_PZ[i]=pz-Ao3_F[i]; Ao2_ZH_per[i]=Ao2_2-Ao3_F[i]
            else:
                if RZ>=RH:
                    Ao3_F[i]=ph; Ao2_PZ[i]=pz-ph; Ao2_ZH_per[i]=Ao2_2-ph
                else:
                    Ao3_F[i]=pz; Ao2_ZH_per[i]=Ao2_2-pz
        elif APZ==1 and APH==-1:
            if AZH==0:
                Ao2_PZ[i]=pz
            else:
                if RH>=rr:
                    Ao3_F[i]=pz; Ao2_ZH_per[i]=Ao2_2-pz
                else:
                    Ao3_F[i]=Ao2_2; Ao2_PZ[i]=pz-Ao2_2
        elif APZ==-1 and APH==1:
            if AZH==0:
                Ao2_PZ[i]=pz
            elif AZH==1:
                if RZ>=rr:
                    Ao3_F[i]=ph; Ao2_PZ[i]=pz-ph; Ao2_ZH_per[i]=Ao2_2-ph
                else:
                    Ao3_F[i]=Ao2_2; Ao2_PZ[i]=pz-Ao2_2
            else:
                if RZ>=RH:
                    Ao3_F[i]=ph; Ao2_PZ[i]=pz-ph; Ao2_ZH_per[i]=Ao2_2-ph
                else:
                    Ao3_F[i]=Ao2_2
        elif APZ==-1 and APH==-1:
            if AZH==0:
                Ao2_PZ[i]=pz; Ao2_ZH_per[i]=Ao2_2
            elif AZH==1:
                if rr>=RZ and rr>=RH:
                    Ao3_F[i]=Ao2_2; Ao2_PZ[i]=pz-Ao2_2
                else:
                    Ao3_F[i]=ph; Ao2_ZH_per[i]=Ao2_2-ph
            else:
                if RZ>=RH and RZ>=rr:
                    if RH>=rr:
                        Ao3_F[i]=pz; Ao2_ZH_per[i]=Ao2_2-pz
                    else:
                        Ao3_F[i]=Ao2_2; Ao2_PZ[i]=pz-Ao2_2
                elif RH>=RZ and RH>=rr:
                    if RZ>=rr:
                        Ao3_F[i]=pz; Ao2_ZH_per[i]=Ao2_2-pz
                    else:
                        Ao3_F[i]=Ao2_2
                elif rr>=RZ and rr>=RH:
                    if RZ>=RH:
                        Ao3_F[i]=Ao2_2; Ao2_PZ[i]=pz-Ao2_2
                    else:
                        Ao3_F[i]=Ao2_2
        else:
            Ao2_PZ[i] = pz if APZ!=0 else 0.0
            if APZ==0 and APH==-1 and AZH==-1:
                Ao2_PZ[i] = pz
            Ao2_ZH_per[i] = Ao2_2 if AZH!=0 else 0.0

    sum_Ao3=sum(Ao3_F); sum_ZH=sum(Ao2_ZH_per)
    Ao2_ZHF=(Ao2_2-sum_Ao3) if sum_ZH>0.0 else 0.0
    denom=PI*RZ**2
    AF_PZ  = sum(Ao2_PZ)/denom
    AF_ZH  = Ao2_ZHF/denom
    AF_PZH = sum_Ao3/denom
    AF_Z   = 1.0-AF_PZ-AF_ZH-AF_PZH
    return AF_PZ, AF_ZH, AF_PZH, AF_Z


def calc_hetero_afract(X, Y, Z, XG, YG, ZG, THETA, PHI,
                       Xm0, Ym0, Zm0, H, RZOIBULK, RZOI,
                       AP, AG, KAPPA, KB_, ERE0_, T_, ZI, ECHG_,
                       ZETACST, ZETAPST, ZETAHET, ZETAHETP,
                       ASP, NASP, RMODE, HETMODE, SCOV, RHET0, RHET1,
                       HETMODEP, SCOVP, RHETP0, RHETP1):
    """
    Compute AFRACT and net FEDL using heterodomain system.
    Returns (AFRACT, FEDL, HETTYPE, HETFLAG,
             MPRO_T_x, MPRO_T_y, MPRO_T_r, NPRO)
    """
    HETTYPE = 0; HETFLAG = 0

    # Colloid heterodomains (HETP)
    if SCOVP > 0.0:
        NPRO, XPRO, YPRO, ZPRO, RPRO = hettrackp(
            Xm0, Ym0, Zm0, H, RZOIBULK, AP, HETMODEP, SCOVP, RHETP0, RHETP1)
        if NPRO == 0:
            NPRO = 1
            MPRO_T_x=[0.0]; MPRO_T_y=[0.0]; MPRO_T_r=[0.0]
        else:
            MPRO_T_x, MPRO_T_y, MPRO_T_r = mpro_transformation(
                X, Y, Z, XG, YG, ZG, THETA, PHI, NPRO, XPRO, YPRO, ZPRO, RPRO)
    else:
        NPRO = 1
        MPRO_T_x=[0.0]; MPRO_T_y=[0.0]; MPRO_T_r=[0.0]

    # Collector heterodomains (HETC)
    if SCOV > 0.0:
        XHET, YHET, ZHET, RHET_ = hettrack(
            X, Y, Z, Xm0, Ym0, Zm0, AG, RZOI, HETMODE, SCOV, RHET0, RHET1)
        XHET_T, YHET_T, ZHET_T, RHET_T = hetc_transformation(
            XG, YG, ZG, XHET, YHET, ZHET, RHET_, HETMODE, THETA, PHI)
    else:
        XHET_T = [0.0]*HETMODE; YHET_T=[0.0]*HETMODE
        ZHET_T = [0.0]*HETMODE; RHET_T=[0.0]*HETMODE

    # Fractional areas
    AFRACT=0.0; AFRACT_PZ=0.0; AFRACT_ZH=0.0; AFRACT_PZH=0.0

    AF_PZ,AF_ZH,AF_PZH,AF_Z = fractional_area(
        0.0, 0.0, RZOIBULK, 0.0, 0.0, 0.0, NPRO, MPRO_T_x, MPRO_T_y, MPRO_T_r)
    AFRACT    = AF_PZ
    AFRACT_PZ = AF_PZ

    for k in range(HETMODE):
        AF_PZ,AF_ZH,AF_PZH,AF_Z = fractional_area(
            0.0, 0.0, RZOIBULK, XHET_T[k], YHET_T[k], RHET_T[k],
            NPRO, MPRO_T_x, MPRO_T_y, MPRO_T_r)
        AFRACT    += AF_ZH
        if AF_ZH > 0.0:
            AFRACT    -= AF_PZH
            AFRACT_PZ -= AF_PZH
        AFRACT_ZH  += AF_ZH
        AFRACT_PZH += AF_PZH
        if AF_ZH > 0.0:
            if HETMODE == 1 or k == 0:
                HETTYPE = 1
            else:
                HETTYPE = 2
            HETFLAG = 1

    if AFRACT > 0.0:
        AFRACT_Z = 1 - AFRACT_PZ - AFRACT_ZH - AFRACT_PZH
        # Net EDL: 4-component weighted sum
        FEDL_PZ  = force_edl(KAPPA,KB_,ERE0_,T_,ZI,ECHG_,ZETACST, ZETAHETP,AG,AP,ASP,NASP,RMODE,H)
        FEDL_ZH  = force_edl(KAPPA,KB_,ERE0_,T_,ZI,ECHG_,ZETAHET,  ZETAPST, AG,AP,ASP,NASP,RMODE,H)
        FEDL_PZH = force_edl(KAPPA,KB_,ERE0_,T_,ZI,ECHG_,ZETAHET,  ZETAHETP,AG,AP,ASP,NASP,RMODE,H)
        FEDL_Z   = force_edl(KAPPA,KB_,ERE0_,T_,ZI,ECHG_,ZETACST, ZETAPST, AG,AP,ASP,NASP,RMODE,H)
        FEDL = (AFRACT_PZ*FEDL_PZ + AFRACT_ZH*FEDL_ZH
                + AFRACT_PZH*FEDL_PZH + AFRACT_Z*FEDL_Z)
    else:
        FEDL = force_edl(KAPPA,KB_,ERE0_,T_,ZI,ECHG_,ZETACST,ZETAPST,AG,AP,ASP,NASP,RMODE,H)

    return AFRACT, FEDL, HETTYPE, HETFLAG, MPRO_T_x, MPRO_T_y, MPRO_T_r, NPRO


# ── Flux file helpers ──────────────────────────────────────────────────────────
def write_header_hap(fh, p, KAPPA, RZOIBULK, dTMRT, RB, ACONTMAX,
                     HFRIC, HMIN, ASTE, K1, K2, K3, K4):
    """Write flux file header matching Fortran FORMAT 206."""
    fh.write(f"NPART= {p['NPART']:6d}  "
             f"VSUP(m/s)= {p['VSUP']:.8E}  "
             f"RLIM(m)= {p['RLIM']:.8E}  "
             f"AG(m)= {p['AG']:.8E}  "
             f"RB(m)= {RB:.8E}  "
             f"TTIME(s)= {p['TTIME']:.8E}  "
             f"ATTMODE= {p['ATTMODE']:2d}  "
             f"HNS(m)= {p['HNS']:.8E}  "
             f"RMODE= {p['RMODE']:2d}  "
             f"ASP(m)= {p['ASP']:.8E}  "
             f"ASP2(m)= {p['ASP2']:.8E}\n")
    fh.write(f"AP(m)= {p['AP']:.8E}  "
             f"IS(mol/m3)= {p['IS']:.8E}  "
             f"ZI= {p['ZI']:.8E}  "
             f"ZETAPST(V)= {p['ZETAPST']:.8E}  "
             f"ZETACST(V)= {p['ZETACST']:.8E}  "
             f"RHOP(kg/m3)= {p['RHOP']:.8E}  "
             f"RHOW(kg/m3)= {p['RHOW']:.8E}  "
             f"VISC(kg/m/s)= {p['VISC']:.8E}  "
             f"ER= {p['ER']:.8E}  "
             f"T(K)= {p['T']:.8E}  "
             f"DIFFSCALE= {p['DIFFSCALE']:.8E}  "
             f"GRAVFACT= {p['GRAVFACT']:.8E}\n")
    fh.write(f"SCOV= {p['SCOV']:.8E}  "
             f"ZETAHET(V)= {p['ZETAHET']:.8E}  "
             f"HETMODE= {p['HETMODE']:2d}  "
             f"RHET0(m)= {p['RHET0']:.8E}  "
             f"RHET1(m)= {p['RHET1']:.8E}  "
             f"SCOVP= {p['SCOVP']:.8E}  "
             f"ZETAHETP(V)= {p['ZETAHETP']:.8E}  "
             f"HETMODEP= {p['HETMODEP']:2d}  "
             f"RHETP0(m)= {p['RHETP0']:.8E}  "
             f"RHETP1(m)= {p['RHETP1']:.8E}  "
             f"RZOIBULK(m)= {RZOIBULK:.8E}  "
             f"dTMRT(s)= {dTMRT:.8E}  "
             f"MULTB= {p['MULTB']:.8E}  "
             f"MULTNS= {p['MULTNS']:.8E}  "
             f"MULTC= {p['MULTC']:.8E}  "
             f"VDWMODE= {p['VDWMODE']:6d}\n")
    fh.write(f"A132(J)= {p['A132']:.8E}  "
             f"LAMBDAVDW(m)= {p['LAMBDAVDW']:.8E}  "
             f"GAMMA0AB(J/m2)= {p['GAMMA0AB']:.8E}  "
             f"LAMBDAAB(m)= {p['LAMBDAAB']:.8E}  "
             f"GAMMA0STE(J/m2)= {p['GAMMA0STE']:.8E}  "
             f"LAMBDASTE(m)= {p['LAMBDASTE']:.8E}  "
             f"KINT(N/m2)= {p['KINT']:.8E}  "
             f"W132(J/m2)= {p['W132']:.8E}  "
             f"ACONTMAX(m)= {ACONTMAX:.8E}  "
             f"BETA= {p['BETA']:.8E}  "
             f"DFACTNS= {p['DFACTNS']:.8E}  "
             f"DFACTC= {p['DFACTC']:.8E}  "
             f"A11(J)= {p['A11']:.8E}  "
             f"A22(J)= {p['A22']:.8E}  "
             f"A33(J)= {p['A33']:.8E}  "
             f"AC1C1(J)= {p['AC1C1']:.8E}  "
             f"AC2C2(J)= {p['AC2C2']:.8E}  "
             f"T1(m)= {p['T1']:.8E}  "
             f"T2(m)= {p['T2']:.8E}\n")

FLUX_HDR_HAP = ('PARTICLE  ATTACHK XINIT(m)            YINIT(m)            '
                'RINJ(m)             ZINIT(m)            RINIT(m)            '
                'HINIT(m)            XOUT(m)             YOUT(m)             '
                'ZOUT(m)             ROUT(m)             HOUT(m)             '
                'ETIME(s)            PTIMEIN(s)          PTIMEOUT(s)         '
                'TBULK(s)            TNEAR(s)            TFRIC(s)            '
                'NSVISIT             FRICVISIT           ACONT(m)            '
                'RZOI(m)             AFRACT              HETTYPE HETFLAG '
                'NSVEL(m/s)          HAVE(m)             '
                'XINNS(m)            YINNS(m)            ZINNS(m)            '
                'XEXNS(m)            YEXNS(m)            ZEXNS(m)\n')


def write_flux_row_hap(fh, J, ATTACHK, XINIT, YINIT, RINJ, ZINIT, RINIT, HINIT,
                       X, Y, Z, R, H, ETIME, PTIMEIN, PTIMEOUT,
                       TBULK, TNEAR, TFRIC, NSVISIT, FRICVISIT,
                       ACONT, RZOI, AFRACT, HETTYPE, HETFLAG, NSVEL, HAVE,
                       XINNS, YINNS, ZINNS, XEXNS, YEXNS, ZEXNS):
    fh.write(f'{J:06d}     {ATTACHK:1d}       ')
    for v in [XINIT,YINIT,RINJ,ZINIT,RINIT,HINIT,X,Y,Z,R,H,ETIME,PTIMEIN,PTIMEOUT,
               TBULK,TNEAR,TFRIC]:
        fh.write(f'{v:15.8E}     ')
    fh.write(f'{NSVISIT:15d}     {FRICVISIT:15d}     ')
    for v in [ACONT,RZOI,AFRACT]:
        fh.write(f'{v:15.8E}     ')
    fh.write(f'{HETTYPE:1d}       {HETFLAG:1d}       ')
    for v in [NSVEL,HAVE,XINNS,YINNS,ZINNS,XEXNS,YEXNS,ZEXNS]:
        fh.write(f'{v:15.8E}     ')
    fh.write('\n')


# ── Main ───────────────────────────────────────────────────────────────────────
def main():
    # ── Argument parsing ──────────────────────────────────────────────────────
    if len(sys.argv) >= 3:
        NPART_arg      = int(sys.argv[1])
        ipart          = int(sys.argv[2])
        DATADIR        = sys.argv[3] if len(sys.argv) >= 4 else '.'
        CLUSTER        = 1
        XINIT_override = float(sys.argv[4]) if len(sys.argv) >= 5 else None
        YINIT_override = float(sys.argv[5]) if len(sys.argv) >= 6 else None
    else:
        ipart          = None
        DATADIR        = '.'
        CLUSTER        = 0
        XINIT_override = None
        YINIT_override = None

    p = read_input(os.path.join(DATADIR, 'INPUT_hap.IN'))

    NPART    = p['NPART']
    ATTMODE  = p['ATTMODE']
    if CLUSTER == 0:
        CLUSTER = p['CLUSTER']
        ipart   = None  # serial mode

    VSUP     = p['VSUP'];    RLIM     = p['RLIM']
    POROSITY = p['POROSITY']; AG      = p['AG']
    TTIME    = p['TTIME'];   HNS      = p['HNS']
    AP       = p['AP'];      RHOP     = p['RHOP']
    RHOW     = p['RHOW'];    VISC     = p['VISC']
    ER       = p['ER'];      T_       = p['T']
    IS_      = p['IS'];      ZI       = p['ZI']
    ZETAPST  = p['ZETAPST']; ZETACST  = p['ZETACST']
    ZETAHET  = p['ZETAHET']; HETMODE  = p['HETMODE']
    RHET0    = p['RHET0'];   RHET1    = p['RHET1']
    SCOV     = p['SCOV']
    ZETAHETP = p['ZETAHETP']; HETMODEP = p['HETMODEP']
    RHETP0   = p['RHETP0'];  RHETP1   = p['RHETP1'];  SCOVP  = p['SCOVP']
    A132     = p['A132'];    LAMBDAVDW= p['LAMBDAVDW']; VDWMODE=p['VDWMODE']
    A11      = p['A11'];     AC1C1    = p['AC1C1']
    A22      = p['A22'];     AC2C2    = p['AC2C2'];  A33    = p['A33']
    T1       = p['T1'];      T2       = p['T2']
    GAMMA0AB = p['GAMMA0AB']; LAMBDAAB= p['LAMBDAAB']
    GAMMA0STE= p['GAMMA0STE']; LAMBDASTE=p['LAMBDASTE']
    B        = p['B'];       RMODE    = p['RMODE']
    ASP      = p['ASP'];     ASP2     = p['ASP2']
    KINT     = p['KINT'];    W132     = p['W132'];   BETA   = p['BETA']
    DIFFSCALE= p['DIFFSCALE']; GRAVFACT=p['GRAVFACT']; CBGRAV=p['CBGRAV']
    MULTB    = p['MULTB'];   MULTNS   = p['MULTNS']; MULTC  = p['MULTC']
    DFACTNS  = p['DFACTNS']; DFACTC   = p['DFACTC']
    NOUT     = p['NOUT'];    PRINTMAX = p['PRINTMAX']

    # ── Physical constants and derived quantities ──────────────────────────────
    ERE0  = ER*E0
    NIO   = IS_*2*NA
    KAPPA = ((ECHG**2)*NIO*(ZI**2)/(ERE0*KB*T_))**0.5
    MP    = (4.0/3.0)*PI*(AP**3)*RHOP
    dTMRT = MP/(6.0*PI*VISC*AP)
    VM    = (2.0/3.0)*PI*(AP**3)*RHOW
    M3    = 6.0*PI*VISC*AP
    RB    = AG/((1-POROSITY)**(1.0/3.0))
    PP    = AG/RB
    WW    = 2.0 - 3.0*PP + 3.0*PP**5 - 2.0*PP**6
    K1    = 1.0/WW
    K2    = -(3.0+2.0*PP**5)/WW
    K3    = (2.0+3.0*PP**5)/WW
    K4    = -PP**5/WW
    RZOIBULK = 2.0*((1.0/KAPPA)*AP)**0.5
    TINJ  = TTIME/6.0
    Xm0=0.0; Ym0=0.0; Zm0=0.0

    if W132 > 0.0: W132 = 0.0
    if VDWMODE != 1: A132 = 0.0
    ACONTMAX = (-6.0*PI*W132*(AP**2)/KINT)**(1.0/3.0)
    DELTAMAX = AP - (AP**2-ACONTMAX**2)**0.5
    ASTE     = (ACONTMAX**2+2*LAMBDASTE*(AP+(AP**2-ACONTMAX**2)**0.5))**0.5

    # Gravity unit vectors
    if   CBGRAV == 1: EGX=0.0;  EGY=0.0;  EGZ=-1.0
    elif CBGRAV == 2: EGX=0.0;  EGY=0.0;  EGZ=+1.0
    elif CBGRAV == 3: EGX=-1.0; EGY=0.0;  EGZ=0.0
    else:             EGX=+1.0; EGY=0.0;  EGZ=0.0

    # Hydrodynamic retardation coefficients (GCB 1967)
    A1=0.9267; B1=-0.3990; C1=0.1487; D1=-0.601;  E1=1.202
    A2=0.5695; B2=1.355;  C2=1.36;   D2=0.875;   E2=0.525
    A3=0.2803; B3=-0.1430; C3=1.472; D3=-0.6772; E3=2.765
    A4=0.2607; B4=-0.3015; C4=0.9006; D4=-0.5942; E4=1.292

    HFRIC, HMIN = find_hfric_hmin(
        AG, AP, ASP, ASTE, GAMMA0AB, LAMBDAAB, GAMMA0STE, LAMBDASTE,
        A132, SIGMAC, A11, A22, A33, AC1C1, AC2C2, VDWMODE, LAMBDAVDW,
        KAPPA, KB, ERE0, T_, ZI, ECHG, ZETACST, ZETAPST)

    # ── File setup ─────────────────────────────────────────────────────────────
    XINNS=0.0; YINNS=0.0; ZINNS=0.0
    XEXNS=0.0; YEXNS=0.0; ZEXNS=0.0

    if CLUSTER == 0:
        f_att = open('HAPHETFLUXATT.OUT','w')
        f_ex  = open('HAPHETFLUXEX.OUT', 'w')
        f_rem = open('HAPHETFLUXREM.OUT','w')
        hdr_written = {f_att:False, f_ex:False, f_rem:False}

    # ── SCOV favorable zeroing (applied once before particle loop) ─────────────
    SCOV_orig  = SCOV
    SCOVP_orig = SCOVP
    if ((ZETACST >= 0.0 and ZETAPST <= 0.0) or
        (ZETACST <= 0.0 and ZETAPST >= 0.0)):
        SCOV  = 0.0
        SCOVP = 0.0

    # ── Particle loop ──────────────────────────────────────────────────────────
    NPARTLOOP = NPART_arg if CLUSTER == 1 else NPART
    for J in ([ipart] if CLUSTER == 1 else range(1, NPART+1)):

        # Output arrays
        IOT   =[0]*OUTMAX;  XOT=[0.0]*OUTMAX; YOT=[0.0]*OUTMAX
        ZOT   =[0.0]*OUTMAX; ROT=[0.0]*OUTMAX; HOT=[0.0]*OUTMAX
        ETIMEOT=[0.0]*OUTMAX; PTIMEFOT=[0.0]*OUTMAX
        FCOLLOT=[0.0]*OUTMAX; FVDWOT=[0.0]*OUTMAX; FEDLOT=[0.0]*OUTMAX
        FABOT =[0.0]*OUTMAX; FSTEOT=[0.0]*OUTMAX; FBORNOT=[0.0]*OUTMAX
        UTOT  =[0.0]*OUTMAX; UNOT=[0.0]*OUTMAX; VTOT=[0.0]*OUTMAX; VNOT=[0.0]*OUTMAX
        FDRGTOT=[0.0]*OUTMAX; FDRGNOT=[0.0]*OUTMAX
        FDIFXOT=[0.0]*OUTMAX; FDIFYOT=[0.0]*OUTMAX; FDIFZOT=[0.0]*OUTMAX
        FGTOT =[0.0]*OUTMAX; FGNOT=[0.0]*OUTMAX; FLIFTOT=[0.0]*OUTMAX
        ACONTOT=[0.0]*OUTMAX; RZOIOT=[0.0]*OUTMAX; AFRACTOT=[0.0]*OUTMAX

        # ── Initialization ─────────────────────────────────────────────────────
        XINIT,YINIT,RINJ,ZINIT,RINIT,HINIT = initial(RLIM, AG, AP, ASP, RMODE, RB)
        if XINIT_override is not None: XINIT = XINIT_override
        if YINIT_override is not None: YINIT = YINIT_override
        RINIT = RB
        ZINIT = (RINIT**2 - XINIT**2 - YINIT**2)**0.5
        if   RMODE == 0: HINIT = RINIT - AG - AP
        elif RMODE in(1,2): HINIT = RINIT - AG - AP - ASP
        else: HINIT = RINIT - AG - AP - 0.5*(2*ASP + 3**0.5*ASP)

        X=XINIT; Y=YINIT; Z=ZINIT; R=RINIT; H=HINIT
        # Fortran initializes VX=VY=0, VZ=-VSUP at injection
        VX=0.0; VY=0.0; VZ=-VSUP

        ENX=(X-Xm0)/R; ENY=(Y-Ym0)/R; ENZ=(Z-Zm0)/R

        UX=0.0; UY=0.0; UZ=VZ
        UN = UX*ENX+UY*ENY+UZ*ENZ
        UNX=UN*ENX; UNY=UN*ENY; UNZ=UN*ENZ
        UTX=UX-UNX; UTY=UY-UNY; UTZ=UZ-UNZ
        UT = (UTX**2+UTY**2+UTZ**2)**0.5
        OMEGA = UT/AP*(0.5518+117.4*(H/AP))/(1+232.1*(H/AP)+237.7*(H/AP)**2)
        VN = VX*ENX+VY*ENY+VZ*ENZ
        VNX=VN*ENX; VNY=VN*ENY; VNZ=VN*ENZ
        VTX=VX-VNX; VTY=VY-VNY; VTZ=VZ-VNZ
        VT = (VTX**2+VTY**2+VTZ**2)**0.5
        if VT != 0.0: ETX=VTX/VT; ETY=VTY/VT; ETZ=VTZ/VT
        else:         ETX=0.0;     ETY=0.0;     ETZ=0.0

        PTIMEF = (J-1)*TINJ/NPART
        dT     = MULTB*dTMRT
        HFLAG  = 1
        ACONT=0.0; DELTA=0.0
        ATTACHK=0; ARRESTFLAG=0
        IREF1=0; IREF2=0
        NSVISIT=0; FRICVISIT=0
        TBULK=0.0; TNEAR=0.0; TFRIC=0.0; ETIME=0.0
        HSUM=0.0; HAVE=0.0; L=0; NSDIST=0.0; NSVEL=0.0
        HETTYPE=0; HETFLAG=0
        XINNS=0.0; YINNS=0.0; ZINNS=0.0; XEXNS=0.0; YEXNS=0.0; ZEXNS=0.0
        ENXENTER=ENX; ENYENTER=ENY; ENZENTER=ENZ; RENTER=R

        RZOI   = (ACONT**2+2/KAPPA*(AP+(AP**2-ACONT**2)**0.5))**0.5
        RZOIAB = (ACONT**2+2*LAMBDAAB*(AP+(AP**2-ACONT**2)**0.5))**0.5
        NASP=0.0; NASPAB=0.0
        ASPLIM   = 0.5*PI**0.5*RZOI
        ASPLIMAB = 0.5*PI**0.5*RZOIAB
        if RMODE > 0:
            NASP   = 1.0 if ASP>ASPLIM   else (RZOI**2/ASP**2)*(PI/4)
            NASPAB = 1.0 if ASP>ASPLIMAB else (RZOIAB**2/ASP**2)*(PI/4)

        # Initial forces
        FVDW = force_vdw(A132,AG,AP,ASP,NASP,RMODE,H,LAMBDAVDW,
                          A11,A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE)
        FG   = gravity(GRAVFACT, AP, RHOP, RHOW)
        FGN,FGNX,FGNY,FGNZ,FGT,FGTX,FGTY,FGTZ = gravvect(
            FG,EGX,EGY,EGZ,ENX,ENY,ENZ,ETX,ETY,ETZ)
        FLIFT = force_lift(RHOW,R,AP,AG,VT,UT,OMEGA)
        HBAR = (H+B)/AP
        FUN1=1.0+B1*math.exp(-C1*HBAR)+D1*math.exp(-E1*HBAR**A1)
        FUN2=1.0+B2*math.exp(-C2*HBAR)+D2*math.exp(-E2*HBAR**A2)
        FUN3=1.0+B3*math.exp(-C3*HBAR)+D3*math.exp(-E3*HBAR**A3)
        FUN4=1.0+B4*math.exp(-C4*HBAR)+D4*math.exp(-E4*HBAR**A4)
        FDRGT,FDRGN = force_drag(FUN2,FUN3,FUN4,M3,VN,VT)
        FDIFX=0.0; FDIFY=0.0; FDIFZ=0.0

        # Heterodomain system — initial setup
        MPRO_T_x=[0.0]; MPRO_T_y=[0.0]; MPRO_T_r=[0.0]; NPRO=1
        if (SCOV > 0.0 or SCOVP > 0.0) and HFLAG > 1:
            XG=Xm0+ENX*AG; YG=Ym0+ENY*AG; ZG=Zm0+ENZ*AG
            RO_ = ((X-Xm0)**2+(Y-Ym0)**2+(Z-Zm0)**2)**0.5
            THETA_ = math.acos(max(-1.0,min(1.0,(Z-Zm0)/RO_)))
            ROXY_  = ((X-Xm0)**2+(Y-Ym0)**2)**0.5
            if ROXY_ == 0.0: PHI_ = 0.0
            elif (Y-Ym0) >= 0.0: PHI_ = math.acos(max(-1.0,min(1.0,(X-Xm0)/ROXY_)))
            else: PHI_ = 2.0*PI - math.acos(max(-1.0,min(1.0,(X-Xm0)/ROXY_)))
            AFRACT, FEDL, HETTYPE, HETFLAG, MPRO_T_x, MPRO_T_y, MPRO_T_r, NPRO = \
                calc_hetero_afract(X,Y,Z,XG,YG,ZG,THETA_,PHI_,
                    Xm0,Ym0,Zm0,H,RZOIBULK,RZOI,AP,AG,KAPPA,KB,ERE0,T_,ZI,ECHG,
                    ZETACST,ZETAPST,ZETAHET,ZETAHETP,ASP,NASP,RMODE,
                    HETMODE,SCOV,RHET0,RHET1,HETMODEP,SCOVP,RHETP0,RHETP1)
        else:
            AFRACT=-1.0
            FEDL = force_edl(KAPPA,KB,ERE0,T_,ZI,ECHG,ZETACST,ZETAPST,
                              AG,AP,ASP,NASP,RMODE,H)

        FAB   = force_ab(AG,AP,ASP,NASPAB,RMODE,LAMBDAAB,GAMMA0AB,H)
        FBORN = force_born(A132,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE)
        FSTE  = force_ste(GAMMA0STE,LAMBDASTE,ASTE,H)
        FCOLL = FVDW+FEDL+FAB+FBORN+FSTE

        I=0; PCOUNT=1; OUTCOUNT=1; OUTFLAG=1

        def store(oc):
            IOT[oc]=I; XOT[oc]=X; YOT[oc]=Y; ZOT[oc]=Z; ROT[oc]=R; HOT[oc]=H
            ETIMEOT[oc]=ETIME; PTIMEFOT[oc]=PTIMEF
            FCOLLOT[oc]=FCOLL; FVDWOT[oc]=FVDW; FEDLOT[oc]=FEDL
            FABOT[oc]=FAB; FSTEOT[oc]=FSTE; FBORNOT[oc]=FBORN
            UTOT[oc]=UT; UNOT[oc]=UN; VTOT[oc]=VT; VNOT[oc]=VN
            FDRGTOT[oc]=FDRGT; FDRGNOT[oc]=FDRGN
            FDIFXOT[oc]=FDIFX; FDIFYOT[oc]=FDIFY; FDIFZOT[oc]=FDIFZ
            FGTOT[oc]=FGT; FGNOT[oc]=FGN; FLIFTOT[oc]=FLIFT
            ACONTOT[oc]=ACONT; RZOIOT[oc]=RZOI; AFRACTOT[oc]=AFRACT

        # ── Trajectory loop ────────────────────────────────────────────────────
        while ATTACHK == 0:

            if PCOUNT == NOUT or I == 0:
                PCOUNT = 0
                store(OUTCOUNT-1)
                OUTCOUNT += 1
                if OUTCOUNT > OUTMAX:
                    OUTFLAG += 1
                    if OUTFLAG == OUTMAX: OUTFLAG -= 1
                    OUTCOUNT = OUTFLAG
                if CLUSTER == 0:
                    print(f'J= {J:6d} I= {I:15d} R= {R:11.4E} '
                          f'Z= {Z:15.8E} H= {R-AG-AP:11.4E} AFRACT= {AFRACT:11.4E}')
                elif I % 10000 == 0:
                    print(f'  step={I:12d}  H={H:.3E}  HFLAG={HFLAG}  '
                          f'R={R:.4E}  AFRACT={AFRACT:.4f}', flush=True)

            I      += 1
            PCOUNT += 1
            PTIMEF += dT
            ETIME   = PTIMEF - PTIMEFOT[0]

            XO=X; YO=Y; ZO=Z
            X = XO + UX*dT
            Y = YO + UY*dT
            Z = ZO + UZ*dT
            R = ((X-Xm0)**2+(Y-Ym0)**2+(Z-Zm0)**2)**0.5

            # Deformation
            if   RMODE == 0: ref = R-AG-AP-HFRIC
            elif RMODE in(1,2): ref = R-AG-AP-HFRIC-ASP
            else: ref = R-AG-AP-HFRIC-0.5*(2*ASP+3**0.5*ASP)
            DELTA = DELTAMAX*ref/(HMIN-HFRIC-DELTAMAX)
            DELTA = max(0.0, min(DELTAMAX, DELTA))
            ACONT = BETA*(2.0*AP*DELTA-DELTA**2)**0.5 if (2*AP*DELTA-DELTA**2)>=0 else 0.0

            RZOI   = (ACONT**2+2/KAPPA*(AP+(AP**2-ACONT**2)**0.5))**0.5
            RZOIAB = (ACONT**2+2*LAMBDAAB*(AP+(AP**2-ACONT**2)**0.5))**0.5
            ASPLIM   = 0.5*PI**0.5*RZOI
            ASPLIMAB = 0.5*PI**0.5*RZOIAB
            if RMODE > 0:
                NASP   = 1.0 if ASP>ASPLIM   else (RZOI**2/ASP**2)*(PI/4)
                NASPAB = 1.0 if ASP>ASPLIMAB else (RZOIAB**2/ASP**2)*(PI/4)

            if   RMODE == 0: H = R-AG-AP+DELTA
            elif RMODE in(1,2): H = R-AG-AP+DELTA-ASP
            else: H = R-AG-AP+DELTA-0.5*(2*ASP+3**0.5*ASP)

            ENX=(X-Xm0)/R; ENY=(Y-Ym0)/R; ENZ=(Z-Zm0)/R

            # Zone transitions and time accounting
            if H > HNS:
                if HFLAG == 2:
                    TNEAR += dT
                    XEXNS=X; YEXNS=Y; ZEXNS=Z
                    if IREF1 > 200:
                        ENXEP=Xm0+ENXENTER*AG; ENYEP=Ym0+ENYENTER*AG; ENZEP=Zm0+ENZENTER*AG
                        ENXP =Xm0+ENX*AG;      ENYP =Ym0+ENY*AG;      ENZP =Zm0+ENZ*AG
                        CHORD = ((ENXEP-ENXP)**2+(ENYEP-ENYP)**2+(ENZEP-ENZP)**2)**0.5
                        NSTHETA = 2.0*math.asin(max(-1.0,min(1.0,CHORD/(2.0*AG))))
                        NSARC   = AG*NSTHETA
                        NSDIST += NSARC
                        NSVEL   = NSDIST/TNEAR if TNEAR > 0 else 0.0
                    dT = MULTB*dTMRT
                    HFLAG = 1
                    IREF1 = 0
                elif HFLAG == 1:
                    TBULK += dT
                    L += 1; HSUM += H; HAVE = HSUM/L
            elif H > HFRIC:  # near surface
                if HFLAG == 1:
                    if NSVISIT == 0: XINNS=X; YINNS=Y; ZINNS=Z
                    TBULK += dT
                    dT = MULTNS*dTMRT
                    HFLAG = 2
                    ENXENTER=ENX; ENYENTER=ENY; ENZENTER=ENZ; RENTER=R
                    NSVISIT += 1
                elif HFLAG == 3:
                    TFRIC += dT
                    dT = MULTNS*dTMRT
                    HFLAG = 2
                    IREF2 = 0
                    ENXENTER=ENX; ENYENTER=ENY; ENZENTER=ENZ; RENTER=R
                elif HFLAG == 2:
                    TNEAR += dT
                    L += 1; HSUM += H; HAVE = HSUM/L

                if IREF1 == 0:
                    XREF1=X; YREF1=Y; ZREF1=Z; TREF1=0.0; IREF1=1
                else:
                    IREF1 += 1; TREF1 += dT
                    if IREF1 > 1000:
                        DREF1 = ((X-XREF1)**2+(Y-YREF1)**2+(Z-ZREF1)**2)**0.5
                        DCOEF = FUN1 if VN > VT else FUN4
                        DIND1 = DFACTNS*(6.0*DCOEF*KB*T_*TREF1/M3)**0.5
                        if ((DREF1 < DIND1 and H > 5*HFRIC) or
                                abs(Z+R) <= AP/2):
                            ATTACHK = 5
                        else:
                            IREF1 = 0
            else:  # contact
                if HFLAG == 2:
                    TNEAR += dT
                    if IREF1 > 200:
                        ENXEP=Xm0+ENXENTER*AG; ENYEP=Ym0+ENYENTER*AG; ENZEP=Zm0+ENZENTER*AG
                        ENXP =Xm0+ENX*AG;      ENYP =Ym0+ENY*AG;      ENZP =Zm0+ENZ*AG
                        CHORD = ((ENXEP-ENXP)**2+(ENYEP-ENYP)**2+(ENZEP-ENZP)**2)**0.5
                        NSTHETA = 2.0*math.asin(max(-1.0,min(1.0,CHORD/(2.0*AG))))
                        NSARC   = AG*NSTHETA
                        NSDIST += NSARC
                        NSVEL   = NSDIST/TNEAR if TNEAR > 0 else 0.0
                    dT = MULTC*dTMRT
                    HFLAG = 3
                    FRICVISIT += 1
                elif HFLAG == 3:
                    TFRIC += dT
                if H < H0:
                    ATTACHK = 6
                if ATTMODE == 0:
                    ATTACHK = 2
                else:
                    if UT == 0.0 and ARRESTFLAG == 1:
                        ATTACHK = 2
                    if IREF2 == 0:
                        XREF2=X; YREF2=Y; ZREF2=Z; TREF2=0.0; IREF2=1
                    else:
                        IREF2 += 1; TREF2 += dT
                        if IREF2 > 1000:
                            # Tangential-only DREF2 (Bug 2 fix)
                            DX2=X-XREF2; DY2=Y-YREF2; DZ2=Z-ZREF2
                            DN2=DX2*ENX+DY2*ENY+DZ2*ENZ
                            DREF2=((DX2-DN2*ENX)**2+(DY2-DN2*ENY)**2+(DZ2-DN2*ENZ)**2)**0.5
                            DCOEF = FUN1 if VN > VT else FUN4
                            DIND2 = DFACTC*(6.0*DCOEF*KB*T_*TREF2/M3)**0.5
                            if DREF2 < DIND2:
                                ATTACHK = 4
                            else:
                                IREF2 = 0

            # Exit conditions
            if ((R > RB and Z < 0.0) and CBGRAV in (1,2)):
                ATTACHK = 1
            if ((R > RB and Z >= 0.0) and CBGRAV in (1,2)):
                X=XO; Y=YO; Z=ZO
            if ((R > RB and Z < ZINIT*0.95) and CBGRAV in (3,4)):
                ATTACHK = 1
            if PTIMEF > TTIME:
                ATTACHK = 3

            if ATTACHK != 0:
                ETIME = PTIMEF - PTIMEFOT[0]
                store(OUTCOUNT-1)
                break

            # ── Forces ────────────────────────────────────────────────────────
            FVDW = force_vdw(A132,AG,AP,ASP,NASP,RMODE,H,LAMBDAVDW,
                              A11,A22,A33,AC1C1,AC2C2,T1,T2,VDWMODE)

            # Heterodomain / EDL
            if (SCOV > 0.0 or SCOVP > 0.0) and I == 1:
                XG=Xm0+ENX*AG; YG=Ym0+ENY*AG; ZG=Zm0+ENZ*AG
                RO_=((X-Xm0)**2+(Y-Ym0)**2+(Z-Zm0)**2)**0.5
                THETA_=math.acos(max(-1.0,min(1.0,(Z-Zm0)/RO_)))
                ROXY_=((X-Xm0)**2+(Y-Ym0)**2)**0.5
                if ROXY_==0.0: PHI_=0.0
                elif (Y-Ym0)>=0.0: PHI_=math.acos(max(-1.0,min(1.0,(X-Xm0)/ROXY_)))
                else: PHI_=2.0*PI-math.acos(max(-1.0,min(1.0,(X-Xm0)/ROXY_)))
                AFRACT,FEDL,HETTYPE,HETFLAG,MPRO_T_x,MPRO_T_y,MPRO_T_r,NPRO=\
                    calc_hetero_afract(X,Y,Z,XG,YG,ZG,THETA_,PHI_,
                        Xm0,Ym0,Zm0,H,RZOIBULK,RZOI,AP,AG,KAPPA,KB,ERE0,T_,ZI,ECHG,
                        ZETACST,ZETAPST,ZETAHET,ZETAHETP,ASP,NASP,RMODE,
                        HETMODE,SCOV,RHET0,RHET1,HETMODEP,SCOVP,RHETP0,RHETP1)
            elif (SCOV > 0.0 or SCOVP > 0.0) and HFLAG > 1:
                XG=Xm0+ENX*AG; YG=Ym0+ENY*AG; ZG=Zm0+ENZ*AG
                RO_=((X-Xm0)**2+(Y-Ym0)**2+(Z-Zm0)**2)**0.5
                THETA_=math.acos(max(-1.0,min(1.0,(Z-Zm0)/RO_)))
                ROXY_=((X-Xm0)**2+(Y-Ym0)**2)**0.5
                if ROXY_==0.0: PHI_=0.0
                elif (Y-Ym0)>=0.0: PHI_=math.acos(max(-1.0,min(1.0,(X-Xm0)/ROXY_)))
                else: PHI_=2.0*PI-math.acos(max(-1.0,min(1.0,(X-Xm0)/ROXY_)))
                AFRACT,FEDL,HETTYPE,HETFLAG,MPRO_T_x,MPRO_T_y,MPRO_T_r,NPRO=\
                    calc_hetero_afract(X,Y,Z,XG,YG,ZG,THETA_,PHI_,
                        Xm0,Ym0,Zm0,H,RZOIBULK,RZOI,AP,AG,KAPPA,KB,ERE0,T_,ZI,ECHG,
                        ZETACST,ZETAPST,ZETAHET,ZETAHETP,ASP,NASP,RMODE,
                        HETMODE,SCOV,RHET0,RHET1,HETMODEP,SCOVP,RHETP0,RHETP1)
            else:
                AFRACT=-1.0
                FEDL=force_edl(KAPPA,KB,ERE0,T_,ZI,ECHG,ZETACST,ZETAPST,
                                AG,AP,ASP,NASP,RMODE,H)

            FAB   = force_ab(AG,AP,ASP,NASPAB,RMODE,LAMBDAAB,GAMMA0AB,H)
            FBORN = force_born(A132,AP,H,A11,A22,A33,AC1C1,AC2C2,VDWMODE)
            FSTE  = force_ste(GAMMA0STE,LAMBDASTE,ASTE,H)
            FCOLL = FVDW+FEDL+FAB+FBORN+FSTE

            FDIFX=FDIFY=FDIFZ=0.0
            if H > HFRIC:
                FDIFX,FDIFY,FDIFZ = force_diff(DIFFSCALE,VISC,AP,T_,dT)

            FG = gravity(GRAVFACT,AP,RHOP,RHOW)

            FLIFT = force_lift(RHOW,R,AP,AG,VT,UT,OMEGA)
            HBAR = (H+B)/AP
            FUN1=1.0+B1*math.exp(-C1*HBAR)+D1*math.exp(-E1*HBAR**A1)
            FUN2=1.0+B2*math.exp(-C2*HBAR)+D2*math.exp(-E2*HBAR**A2)
            FUN3=1.0+B3*math.exp(-C3*HBAR)+D3*math.exp(-E3*HBAR**A3)
            FUN4=1.0+B4*math.exp(-C4*HBAR)+D4*math.exp(-E4*HBAR**A4)

            # Flow field
            VxH1,VyH1,VzH1 = happel_ff(X,Y,Z,AG,B,K1,K2,K3,K4)
            VX=VxH1*VSUP; VY=VyH1*VSUP; VZ=VzH1*VSUP
            VN=VX*ENX+VY*ENY+VZ*ENZ
            VNX=VN*ENX; VNY=VN*ENY; VNZ=VN*ENZ
            VTX=VX-VNX; VTY=VY-VNY; VTZ=VZ-VNZ
            VT=(VTX**2+VTY**2+VTZ**2)**0.5
            if VT != 0.0: ETX=VTX/VT; ETY=VTY/VT; ETZ=VTZ/VT
            else:         ETX=0.0;    ETY=0.0;     ETZ=0.0

            FDRGT,FDRGN = force_drag(FUN2,FUN3,FUN4,M3,VN,VT)
            FGN,FGNX,FGNY,FGNZ,FGT,FGTX,FGTY,FGTZ = gravvect(
                FG,EGX,EGY,EGZ,ENX,ENY,ENZ,ETX,ETY,ETZ)

            # Cartesian force components
            FCOLLX=FCOLL*ENX; FCOLLY=FCOLL*ENY; FCOLLZ=FCOLL*ENZ
            FDRGNX=FDRGN*ENX; FDRGNY=FDRGN*ENY; FDRGNZ=FDRGN*ENZ
            FDRGTX=FDRGT*ETX; FDRGTY=FDRGT*ETY; FDRGTZ=FDRGT*ETZ
            FLIFTX=FLIFT*ENX; FLIFTY=FLIFT*ENY; FLIFTZ=FLIFT*ENZ
            FDIFN=FDIFX*ENX+FDIFY*ENY+FDIFZ*ENZ
            FDIFNX=FDIFN*ENX; FDIFNY=FDIFN*ENY; FDIFNZ=FDIFN*ENZ
            FDIFTX=FDIFX-FDIFNX; FDIFTY=FDIFY-FDIFNY; FDIFTZ=FDIFZ-FDIFNZ

            # Velocity integration
            UXO=UNX+UTX; UYO=UNY+UTY; UZO=UNZ+UTZ
            UNO=UXO*ENX+UYO*ENY+UZO*ENZ
            UNXO=UNO*ENX; UNYO=UNO*ENY; UNZO=UNO*ENZ
            UTXO=UXO-UNXO; UTYO=UYO-UNYO; UTZO=UZO-UNZO

            denom_n = MP+VM+M3/FUN1*dT
            UNX = ((MP+VM)*UNXO+(FGNX+FCOLLX+FDIFNX+FLIFTX+FDRGNX)*dT)/denom_n
            UNY = ((MP+VM)*UNYO+(FGNY+FCOLLY+FDIFNY+FLIFTY+FDRGNY)*dT)/denom_n
            UNZ = ((MP+VM)*UNZO+(FGNZ+FCOLLZ+FDIFNZ+FLIFTZ+FDRGNZ)*dT)/denom_n
            UN_mag = (UNX**2+UNY**2+UNZ**2)**0.5
            UN = math.copysign(UN_mag, ENX*UNX+ENY*UNY+ENZ*UNZ)

            if H > HFRIC:
                denom_t = MP+VM+M3/FUN4*dT
                UTX = ((MP+VM)*UTXO+(FGTX+FDIFTX+FDRGTX)*dT)/denom_t
                UTY = ((MP+VM)*UTYO+(FGTY+FDIFTY+FDRGTY)*dT)/denom_t
                UTZ = ((MP+VM)*UTZO+(FGTZ+FDIFTZ+FDRGTZ)*dT)/denom_t
                UT_mag = (UTX**2+UTY**2+UTZ**2)**0.5
                UT = math.copysign(UT_mag, -UTZ)
                OMEGA = abs(UT)/AP*(0.5518+117.4*(H/AP))/(1+232.1*(H/AP)+237.7*(H/AP)**2)
            else:
                # Contact zone tangential velocity
                FADH = FVDW+FEDL+FGN+FLIFT+FDRGN
                FREP = FBORN
                if FAB < 0.0: FADH += FAB
                else:         FREP += FAB
                if FSTE < 0.0: FADH += FSTE
                else:          FREP += FSTE
                if FADH > 0.0: FADH = 0.0
                else:          FADH = -FADH
                RLEV = AP*ASP2/(AP+ASP2) if ASP2 > 0 else 0.0
                if RLEV <= ACONT: RLEV = ACONT
                FSHRT=1.7005; TSHRY=0.9440
                FTRT  = (8.0/15.0)*math.log(H/AP)-0.9588
                FROT  = -(2.0/15.0)*math.log(H/AP)-0.2526
                TTRY  = -(1.0/10.0)*math.log(H/AP)-0.1895
                TROY  =  (2.0/5.0)*math.log(H/AP) -0.3817
                UTO   = (UTXO**2+UTYO**2+UTZO**2)**0.5
                denom_c = (1.4*(MP+VM)-6.0*PI*VISC*(AP-DELTA)*dT*(FTRT+FROT+4.0/3.0*(TTRY+TROY)))
                if denom_c != 0:
                    UT = (1.4*(MP+VM)*UTO
                          - FADH*RLEV/AP*(AP-DELTA)/AP*dT
                          + 6.0*PI*VISC*(AP-DELTA)*VT*dT*(FSHRT+2.0/3.0*AP/(H+AP)*TSHRY))/denom_c
                if UT < 0.0:
                    UT=0.0; ARRESTFLAG=1
                if (FADH < 0.995*FREP) or (FADH > 1.005*FREP):
                    ARRESTFLAG=0
                UTX=ETX*UT; UTY=ETY*UT; UTZ=ETZ*UT
                OMEGA = UT/AP

            UX=UNX+UTX; UY=UNY+UTY; UZ=UNZ+UTZ

        # ── End trajectory loop ────────────────────────────────────────────────
        if CLUSTER == 0:
            print(f'J= {J:6d} DONE  I= {I:15d}  ATTACHK={ATTACHK}  '
                  f'H={H:.4E}  ETIME={ETIME:.3E}s')
        else:
            print(f'  DONE   steps={I:12d}  ATTACHK={ATTACHK}  '
                  f'H={H:.3E}  ETIME={ETIME:.3E}s', flush=True)

        # Attached particles: XEXNS = last position
        if ATTACHK in (2,4,6,3,5):
            XEXNS=X; YEXNS=Y; ZEXNS=Z

        # Write flux
        flux_args = (J, ATTACHK,
                     XINIT,YINIT,RINJ,ZINIT,RINIT,HINIT,
                     X,Y,Z,R,H,ETIME,PTIMEFOT[0],PTIMEF,
                     TBULK,TNEAR,TFRIC,NSVISIT,FRICVISIT,
                     ACONT,RZOI,AFRACT,HETTYPE,HETFLAG,
                     NSVEL,HAVE,XINNS,YINNS,ZINNS,XEXNS,YEXNS,ZEXNS)

        if CLUSTER == 1:
            if   ATTACHK == 1: fname=os.path.join(DATADIR,f'HAPHETFLUXEX.{ipart}.OUT')
            elif ATTACHK in(2,4,6): fname=os.path.join(DATADIR,f'HAPHETFLUXATT.{ipart}.OUT')
            else: fname=os.path.join(DATADIR,f'HAPHETFLUXREM.{ipart}.OUT')
            with open(fname,'w') as fh:
                write_header_hap(fh,p,KAPPA,RZOIBULK,dTMRT,RB,ACONTMAX,HFRIC,HMIN,ASTE,K1,K2,K3,K4)
                fh.write(FLUX_HDR_HAP)
                write_flux_row_hap(fh, *flux_args)

            # Trajectory file (written for small runs NPART<10, matching Fortran validation behaviour)
            if NPART < 10:
                if   ATTACHK == 1: tfname=os.path.join(DATADIR,f'HAPHETTRAJEX.{ipart}.OUT')
                elif ATTACHK in(2,4,6): tfname=os.path.join(DATADIR,f'HAPHETTRAJATT.{ipart}.OUT')
                else: tfname=os.path.join(DATADIR,f'HAPHETTRAJREM.{ipart}.OUT')
                TRAJ_HDR = ('I                   X                   Y                   '
                            'Z                   R                   H                   '
                            'ETIME               PTIMEF              FCOLL               '
                            'FVDW                FEDL                FAB                 '
                            'FSTE                FBORN               UT                  '
                            'UN                  VT                  VN                  '
                            'FDRGT               FDRGN               FDIFX               '
                            'FDIFY               FDIFZ               FGT                 '
                            'FGN                 FLIFT               ACONT               '
                            'RZOI                AFRACT\n')
                with open(tfname,'w') as tf:
                    write_header_hap(tf,p,KAPPA,RZOIBULK,dTMRT,RB,ACONTMAX,HFRIC,HMIN,ASTE,K1,K2,K3,K4)
                    tf.write(f'ATTACHK= {ATTACHK:5d}\n')
                    tf.write(TRAJ_HDR)
                    nrows = min(OUTCOUNT-1, OUTMAX)
                    for k in range(nrows):
                        tf.write(f'{IOT[k]:015d}'
                                 + ''.join(f' {v:20.8E}' for v in [
                                     XOT[k],YOT[k],ZOT[k],ROT[k],HOT[k],
                                     ETIMEOT[k],PTIMEFOT[k],
                                     FCOLLOT[k],FVDWOT[k],FEDLOT[k],
                                     FABOT[k],FSTEOT[k],FBORNOT[k],
                                     UTOT[k],UNOT[k],VTOT[k],VNOT[k],
                                     FDRGTOT[k],FDRGNOT[k],
                                     FDIFXOT[k],FDIFYOT[k],FDIFZOT[k],
                                     FGTOT[k],FGNOT[k],FLIFTOT[k],
                                     ACONTOT[k],RZOIOT[k],AFRACTOT[k]])
                                 + '\n')
        else:
            if   ATTACHK == 1: fh=f_ex
            elif ATTACHK in(2,4,6): fh=f_att
            else: fh=f_rem
            if not hdr_written[fh]:
                write_header_hap(fh,p,KAPPA,RZOIBULK,dTMRT,RB,ACONTMAX,HFRIC,HMIN,ASTE,K1,K2,K3,K4)
                fh.write(FLUX_HDR_HAP)
                hdr_written[fh]=True
            write_flux_row_hap(fh, *flux_args)

    if CLUSTER == 0:
        f_ex.close(); f_att.close(); f_rem.close()

    print('Simulation complete.')


if __name__ == '__main__':
    main()
