function readAFMinputs()
    global NPART RLIM
    global AP RHOP
    global RHOW VISC ER T
    global IS ZI ZETAPST ZETACST
    global ZETAHET HETMODE RHET1 RHET0 RHET2 SCOV
    global ZETAHETP HETMODEP RHETP1 RHETP0 SCOVP
    global B RMODE ASP
    global A132 LAMBDAVDW VDWMODE
    global GAMMA0AB LAMBDAAB GAMMA0STE LAMBDASTE
    global A11 AC1C1 A22 AC2C2 A33 T1 T2
    global KINT W132 BETA
    % get number of locations
    NPART = str2double(get(app.nloc,'Value'));
    % get domain radius (m)
    RLIM = str2double(get(app.adom,'Value'));
    %
    % get probe physical properties
    % get probe radius (m)
    AP = str2double(get(app.ap,'Value'));
    % probe density (kg/m3)
    RHOP = str2double(get(app.rhop,'Value'));
    %
    % get fluid physical properties
    % fluid viscosity
    RHOW = str2double(get(app.rhow,'Value'));
    % fluid density (kg/m3)
    VISC = str2double(get(app.visc,'Value'));
    % relative permitivitty
    ER = str2double(get(app.er,'Value'));
    % temperature (K)
    T = str2double(get(app.T,'Value'));
    %
    % get mean field potentials
    %ionic strength (mol/m3)
    IS = str2double(get(app.is,'Value'));
    % electolyte valenece(-)
    ZI = str2double(get(app.zi,'Value'));
    % probe zeta potential (V)
    ZETAPST = str2double(get(app.zetapst,'Value'));
    % domain zeta potential (V)
    ZETACST = str2double(get(app.zetacst,'Value'));
    %
    % domain surface heterogeneity
    % domain heterogeneity zeta potential (V)
    ZETAHET = str2double(get(app.zetahet,'Value'));
    % domain hetmode(-)
    HETMODE = str2double(get(app.hetmode,'Value'));
    % large hetdomain radius (m)
    RHET0 = str2double(get(app.rhet0,'Value'));
    % medium hetdomain radius (m)
    RHET1 = str2double(get(app.rhet1,'Value'));
    % small hetdomain radius (m)
    RHET2 = str2double(get(app.rhet2,'Value'));
    % hetdomain domain surface coverage
    SCOV = str2double(get(app.scov,'Value'));
    %
    % colloidal probe surface heterogeneity
    % probe heterogeneity zeta potential (V)
    ZETAHETP = str2double(get(app.zetahetp,'Value'));
    % probe hetmode(-)
    HETMODEP = str2double(get(app.hetmodep,'Value'));
    % large hetdomain radius (m)
    RHETP0 = str2double(get(app.rhetp0,'Value'));
    % small hetdomain radius (m)
    RHETP1 = str2double(get(app.rhetp1,'Value'));
    %hetdomain probe surface coverage
    SCOVP = str2double(get(app.scovp,'Value'));
    %
    % van der Waals force
    % combined Hamaker constant (J)
    A132 = str2double(get(app.a132,'Value'));
    % vdw characteristic decay length (m)
    LAMBDAVDW = str2double(get(app.lambdavdw,'Value'));
    % vdw mode (1 2 3 4, layer options)
    VDWMODE = str2double(get(app.vdwmode,'Value'));
    %
    % roughness

    % slip length (m)
    B = str2double(get(app.b,'Value'));
    % roughnes mode (1 2 3)
    RMODE = str2double(get(app.rmode,'Value'));
    % asperity height(m)
    ASP = str2double(get(app.asp,'Value'));
    %
    % van der Waals COated systems
    % probe Hamaker constant (J)
    A11 = str2double(get(app.a11,'Value'));
    % probe coating Hamaker constant (J)
    AC1C1 = str2double(get(app.ac1c1,'Value'));
    % domain Hamaker constant (J)
    A22 = str2double(get(app.a22,'Value'));
    % domain coating Hamaker constant (J)
    AC2C2 = str2double(get(app.ac2c2,'Value'));
    % fluid Hamaker constant (J)
    A33 = str2double(get(app.a33,'Value'));
    % probe coating thickness (m)
    T1 = str2double(get(app.t1,'Value'));
    % domain coating thickness (m)
    T2 = str2double(get(app.t2,'Value'));
    %
    %Lewis acid-base and steric hydration force parameters
    % acid-base energy per unit area (J/m2)
    GAMMA0AB = str2double(get(app.gamma0ab,'Value'));
    % acid-base decay length(m)
    LAMBDAAB = str2double(get(app.lambdaab,'Value'));
    % steric energy per unit area (J/m2)
    GAMMA0STE = str2double(get(app.gamma0ste,'Value'));
    % steric decay length(m)
    LAMBDASTE = str2double(get(app.lambdaste,'Value'));
    %
    % deformation parameters
    % combined elastic modulus (N/m2)
    KINT = str2double(get(app.kint,'Value'));
    %work of adhesion (J/m2)
    W132 = str2double(get(app.w132,'Value'));
    %contact radius factor (-)
    BETA = str2double(get(app.beta,'Value'));
end