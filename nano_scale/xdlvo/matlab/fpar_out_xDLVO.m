function par_cell=fpar_out_xDLVO()
% use same globals as GUI calculate
%% input parameters
global  a1 a2 IS zetac zetap aasp sigmac T 
global lambdaVDW lambdaAB lambdaSTE gammaSTE epsilonR z A132
global SP SS Rmode VDWmode
% global vdw from fundamentals
global ve e1 n1 e2 n2 e3 n3 A132calc
% global vdw coated systems
global T1 T2 A33 %coating thickness and fluid Hamaker
global A12 A12p A13  A1p2  A1p2p A1p3 A23 A2p3 %combined Hamaker
global A12c A12pc A13c  A1p2c  A1p2pc A1p3c A23c A2p3c  %combined Hamaker calculated
global A11 A1p1p A22 A2p2p % single materials Hamaker
global s1A1p2p s1A12p s1A1p2 s1A12 s2A12p s2A12 s3A1p2 s3A12 % hamaker constributions
%acid-base energy fundamentals
global g1pos g1neg g2pos g2neg g3pos g3neg gammaABcalc gammaAB 
%work of adhesion fundamentals
global g1LW g2LW g3LW INDgammaAB W132calc W132
%aconr for steric fundamentals
global E1 E2 v1 v2 INDW132  Kint acontCALC  acont
% checkboxes
global cbCOATED cbA132 cbgammaAB cbW132 cbacont
global cb1 cb2 cb3
% heterogeneity
global cbHET cbHETUSER zetahet rZOI
%% build cell matrix for parameters output
par_cell = ...
{'Geometry',' ',' ',' ';
'Sphere-Sphere',SS,' ',' ';
'Sphere-Plate',SP,' ',' ';
' ',' ',' ',' ';
'Roughness_mode(0_smooth)(1_rough_collector)(2_rough_colloid)(3_rough_colloid_collector)',Rmode,' ',' ';
' ',' ',' ',' ';
'Main_DLVO_Parameters',' ',' ',' ';
'Temperature(K)',T,' ',' ';
'Ionic_strenght(mol/m3)',IS,' ',' ';
'Colloid_radius(m)',a1,' ',' ';
'Collector_radius(m)',a2,' ',' ';
'Colloid_zeta_potential(V)',zetap,' ',' ';
'Collector_zeta_potential(V)',zetac,' ',' ';
'Valence_of_the_symmetric_electrolyte(-)',z,' ',' ';
'Relativity_permitivity_of_water(-)',epsilonR,' ',' ';
'vdW_characteristic_wavelength(m)',lambdaVDW,' ',' ';
'Born_collision_diameter(m)',sigmac,' ',' ';
' ',' ',' ',' ';
'Extended_DLVO_Parameters',' ',' ',' ';
'Lewis_acid-base_decay_length(m)',lambdaAB,' ',' ';
'Steric_decay_length(m)',lambdaSTE,' ',' ';
'Steric_energy_at_minimum_separation_distance(J/m2)',gammaSTE,' ',' ';
'Asperity_height_above_mean_surface(m)',aasp,' ',' ';
' ',' ',' ',' ';
'van_der_Waals',' ',' ',' ';
'Coated_system(0=uncoated)(1=coated,see_end_of_sheet)',cbCOATED,' ',' ';
'Hamaker_constant(J)',A132,'Calculated_from_fundamentals',cbA132;
' ',' ',' ',' ';
'Acid-base_energy',' ',' ',' ';
'Acid-base_energy_at minimum_separation_distance(J)',gammaAB,'Calculated_from_fundamentals',cbgammaAB;
' ',' ',' ',' ';
'Work_of_adhesion',' ',' ',' ';
'Work_of_adhesion(J)',W132,'Calculated_from_fundamentals',cbW132;
' ',' ',' ',' ';
'Contact_radius',' ',' ',' ';
'Contac_radius_for_steric_interaction(m)',acont,'Calculated_from_fundamentals',cbacont;
' ',' ',' ',' ';
' ',' ',' ',' ';
'MAIN_PARAMETERS_CALCULATED_FROM_FUNDAMENTALS',' ',' ',' ';
' ',' ',' ',' ';
'Hamaker_constant_parameters(uncoated_systems)',' ',' ',' ';
'Main_electronic_absorption_frequency(s-1)',ve,' ',' ';
'Colloid_dielectric_constant(-)',e1,' ',' ';
'Colloid_refractive_index(-)',n1,' ',' ';
'Collector_dielectric_constant(-)',e2,' ',' ';
'Collector_refractive_index(-)',n2,' ',' ';
'Fluid_dielectric_constant(-)',e3,' ',' ';
'Fluid_refractive_index(-)',n3,' ',' ';
'Hamaker_constant(J)',A132calc,' ',' ';
' ',' ',' ',' ';
'Acid-base_surface_energy_components',' ',' ',' ';
'Colloid_electron_acceptor(J/m2)',g1pos,' ',' ';
'Colloid_electron_donor(J/m2)',g1neg,' ',' ';
'Collector_electron_acceptor(J/m2)',g2pos,' ',' ';
'Collector_electron_donor(J/m2)',g2neg,' ',' ';
'Fluid_electron_acceptor(J/m2)',g3pos,' ',' ';
'Fluid_electron_donor(J/m2)',g3neg,' ',' ';
'Acid-base_energy_at_minimum_separation(J/m2)',gammaABcalc,' ',' ';
' ',' ',' ',' ';
'Work_of_adhesion(for_contact_area)',' ',' ',' ';
'Colloid_van_der_Waals_free_energy(J/m2)',g1LW,' ',' ';
'Collector_van_der_Waals_free_energy(J/m2)',g2LW,' ',' ';
'Fluid_van_der_Waals_free_energy(J/m2)',g3LW,' ',' ';
'Acid-base_energy_at_minimum_separation(J/m2)',INDgammaAB,' ',' ';
'Work_of_adhesion(J/m2)',W132calc,' ',' ';
' ',' ',' ',' ';
'Contact_radius(for_steric_interaction)',' ',' ',' ';
'Colloid_Young''s_modulus(N/m2)',E1,' ',' ';
'Collector_Young''s_modulus(N/m2)',E2,' ',' ';
'Colloid_Poisson''s ratio(-)',v1,' ',' ';
'Collector_Poisson''s ratio(-)',v2,' ',' ';
'Work_of_adhesion(J/m2)',INDW132,' ',' ';
'Combined_elastic_modulus(N/m2)',Kint,' ',' ';
'Contact_radius(m)',acontCALC,' ',' ';
' ',' ',' ',' ';
' ',' ',' ',' ';
'COATED_SYSTEMS_van_der_Waals_PARAMETERS',' ',' ',' ';
' ',' ',' ',' ';
'Type_of_coated_system',' ',' ',' ';
'Coated_colloid-Coated_collector',cb1,' ',' ';
'Colloid-Coated_Collector',cb2,' ',' ';
'Coated_colloid-Collector',cb3,' ',' ';
' ',' ',' ',' ';
'Coating_thickness_and_fluid_Hamaker_constant',' ',' ',' ';
'Colloid_coating_thickness(m)',T1,' ',' ';
'Collector_coating_thickness(m)',T2,' ',' ';
'Coated_colloid-Collector',A33,' ',' ';
' ',' ',' ',' ';
'Combined_Hamaker_constant_Coated_sytems',' ',' ',' ';
'Colloid-collector(J)',A12,'Calculated_from_single_material_values ',A12c;
'Colloid-collector_coating(J)',A12p,'Calculated_from_single_material_values ',A12pc;
'Colloid-fluid(J)',A13,'Calculated_from_single_material_values ',A13c;
'Colloid_coating-collector(J)',A1p2,'Calculated_from_single_material_values ',A1p2c;
'Colloid_coating-collector_coating(J)',A1p2p,'Calculated_from_single_material_values ',A1p2pc;
'Colloid_coating-fluid(J)',A1p3,'Calculated_from_single_material_values ',A1p3c;
'Collector-fluid(J)',A23,'Calculated_from_single_material_values ',A23c;
'Collector_coating-fluid(J)',A2p3,'Calculated_from_single_material_values ',A2p3c;
' ',' ',' ',' ';
'Hamaker_constants_Single_material_values',' ',' ',' ';
'Colloid_Hamaker_constant_(J)',A11,' ',' ';
'Colloid_coating_Hamaker_constant_(J)',A1p1p,' ',' ';
'Collector_Hamaker_constant_(J)',A22,' ',' ';
'Collector_coating_Hamaker_constant_(J)',A2p2p,' ',' ';
' ',' ',' ',' ';
' ',' ',' ',' ';
'Hamaker_constant_contributions',' ',' ',' ';
' ',' ',' ',' ';
'SYSTEM_Coated_colloid-Coated_collector',' ',' ',' ';
'Colloid_coating-Collector_coating(J)',s1A1p2p,' ',' ';
'Colloid-Collector_coating(J)',s1A12p,' ',' ';
'Colloid_coating-Collector(J)',s1A1p2,' ',' ';
'Colloid-Collector(J)',s1A12,' ',' ';
' ',' ',' ',' ';
'SYSTEM_Colloid-Coated_collector',' ',' ',' ';
'Colloid-Collector_coating(J)',s2A12p,' ',' ';
'Colloid-Collector(J)',s2A12,' ',' ';
' ',' ',' ',' ';
'SYSTEM_Coated_colloid-Collector',' ',' ',' ';
'Colloid_coating-Collector(J)',s3A1p2,' ',' ';
'Colloid-Collector(J)',s3A12,' ',' ';
' ',' ',' ',' ';
'SYSTEM_Heterodomain_influence',' ',' ',' ';
'Calculate_heterodomain_influence_AFRACT_fractions',cbHET,' ',' ';
'Calculate_heterodomain_influence_user_define_rhet',cbHETUSER,' ',' ';
'Heterodomain_zeta_potential(V)',zetahet,' ',' ';
'rZOI_zone_of_influence_radius(m)',rZOI,' ',' ';
};
end