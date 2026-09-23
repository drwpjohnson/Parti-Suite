import tkinter as tk
from tkinter import filedialog
from tkinter import messagebox
import webbrowser
import customtkinter as ctk
from matplotlib.figure import Figure
import pandas as pd
import numpy as np
from matplotlib.patches import Circle
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from pathlib import Path
import queue
import multiprocessing as mp
import traceback

import AFM_functions as af
from AFM_simulator import AFM_happel
import AFM_plotting as afm_plot


ctk.set_appearance_mode("System")
ctk.set_default_color_theme("blue")

def _afm_simulation_process(
    simulation_inputs: dict,
    simulation_queue,
) -> None:
    """Run AFM_happel in an independent process."""

    def report_progress(
        progress: float,
    ) -> None:
        simulation_queue.put(
            (
                "progress",
                float(progress),
            )
        )

    try:
        results = AFM_happel(
            **simulation_inputs,
            progress_callback=report_progress,
        )

        simulation_queue.put(
            (
                "success",
                results,
            )
        )

    except Exception as error:
        simulation_queue.put(
            (
                "error",
                str(error),
                traceback.format_exc(),
            )
        )


class Custom_title(ctk.CTkLabel):
	"""A custom title label with a specific font and default grid padding."""

	def __init__(self, master, font=('Helvetica', 12, 'bold'), **kwargs):
		"""Initialize attributes of the parent class."""
		super().__init__(master, 
				   font=font, 
				   **kwargs)
		self.master = master

	def grid(self, row =0, **kwargs):
		"""Places the widget in the grid layout."""
		super().grid(row=row, column=0, pady=1, padx=5, columnspan=2, sticky='w', **kwargs)

class Link_Label(ctk.CTkLabel):
	""" A custom clickable label that behaves like a hyperlink."""
	
	def __init__(self, master, link, text=None, **kwargs):
		"""Initialize attributes of the parent class."""	
		if text is None:  
			# The text displayed in the label. 
			# If not provided, the link is used as the text.
			text=link
		super().__init__(master, 
				   text=text,
				   text_color='blue',
				   cursor='hand2',
				   **kwargs)
		
		self.master = master
		self.link= link
		self.default_font = self.cget('font')
		self.bind('<Button-1>',self.open_link)
		self.bind('<Enter>', self.mouse_on)
		self.bind('<Leave>', self.mouse_off)

	def mouse_on(self, event):
		""" Adds an underline to the label text when the mouse hovers 
		over it."""
		self.cget("font").configure(underline=True)
	
	def mouse_off(self, event):
		"""Removes the underline when the mouse leaves the label."""
		self.cget("font").configure(underline=False)

	def open_link(self, *args):
		"""Opens the provided link in the default web browser when 
		the label is clicked."""
		webbrowser.open_new(self.link)
		          

class Custom_entry(ctk.CTkEntry):
	"""A custom entry widget for formatted numerical input with error checking."""

	def __init__(self, master, textvariable, **kwargs):
		"""Initialize attributes of the parent class and error-checking 
		methods."""
		super().__init__(master, 
				   width=70, 
				   height=13, 
				   textvariable=textvariable,
				   justify='center', 
				   **kwargs)
		self.master = master
		self.variable = textvariable
		self.error_shown = False
		self.default_fg = self.cget('fg_color')	
		self.default_tc = self.cget('text_color')	

		# self.update_format()
		
		self.bind('<FocusIn>', self.on_focus_in)
		self.bind('<Return>', self.on_enter)
		self.bind('<Tab>', self.on_enter)
		self.bind('<FocusOut>', self.on_focus_out)
		self.trace_id = self.variable.trace_add('write', self.on_external_change)

	def update_format(self, *arg):
		"""Formats the entry's value, either as a normal float or in 
		scientific notation."""
		value = self.variable.get()
		try:
			number = float(value)
			self.error_shown = False
			if abs(number) > 1000 or (0 < abs(number) < 0.001):
				self.variable.set("{:.2e}".format(number))
			else:
				pass
		except ValueError:
			if self.error_shown != True and self.winfo_exists() and value != 'calculate' and value!='N/A':
				messagebox.showerror("Invalid Input", "Please enter a valid number.")
				self.error_shown = True

	def on_external_change(self, *args):
		"""Updates the format when the value is changed externally."""
		if self.error_shown != True:
			self.update_format()
	
	def on_enter(self, event):
		"""Handles the action when the Enter or Tab key is pressed"""
		if self.error_shown != True:
			self.update_format()
			event.widget.tk_focusNext().focus()
			return "break"
	
	def on_focus_out(self, event):
		""" Adds a trace on the variable when focus is lost to detect 
		external changes."""
		if self.error_shown != True:
			if self.trace_id is None:
				self.trace_id = self.variable.trace_add('write', self.on_external_change)
		
	def on_focus_in(self, event):
		"""Removes the trace on the variable when focus is gained."""
		if self.error_shown != True and self.trace_id is not None:
			self.variable.trace_remove('write', self.trace_id)
			self.trace_id = None
	
	def reset_color(self):
		"""Resets the foreground color to its default."""
		if self.winfo_exists():  
			self.configure(fg_color=self.default_fg, text_color=self.default_tc)

	def grid(self, **kwargs):
		"""Places the widget in the grid layout."""
		super().grid(padx=3, **kwargs)


class SectionFrame(ctk.CTkFrame):
    def __init__(
        self, master, title, fields, var_dict, entry_dict, defaults=None, sep=None, **kwargs
    ):
        super().__init__(master, **kwargs)
        self.grid_columnconfigure(1, weight=1)
        Custom_title(self, text=title).grid()
        
        for i, (label, var_name) in enumerate(fields.items(), start=1):
            labelS = ctk.CTkLabel(self, text=label, justify='left')
            default_value = str(defaults.get(var_name, "")) if defaults else ""
            var = tk.StringVar(value=default_value)
            entry = Custom_entry(self, textvariable=var)
            
            var_dict[var_name] = var
            entry_dict[var_name] = entry
			
            if sep == 1:
                if i ==1:
                    Custom_title(self, text='Primary minimum').grid(row=i)
                    entry.grid(row=i+1, column=0, pady=0.5)
                    labelS.grid(row=i+1, column=1, padx=1, pady=0.5, sticky='w')
					
                elif i == 2:
                    Custom_title(self, text='Barrier').grid(row=i+2)
                    entry.grid(row=i+3, column=0, pady=0.5)
                    labelS.grid(row=i+3, column=1, padx=1, pady=0.5, sticky='w')
                else:
                    entry.grid(row=i+3, column=0, pady=0.5)
                    labelS.grid(row=i+3, column=1, padx=1, pady=0.5, sticky='w')
            else:
                entry.grid(row=i, column=0, pady=0.5)
                labelS.grid(row=i, column=1, padx=1, pady=0.5, sticky='w')

class ToolTip:
    """Display a tooltip when the pointer hovers over a widget."""

    def __init__(self, widget, text, delay=500):
        self.widget = widget
        self.text = text
        self.delay = delay
        self.tip_window = None
        self.after_id = None

        self.widget.bind(
            "<Enter>",
            self.schedule,
            add="+",
        )
        self.widget.bind(
            "<Leave>",
            self.hide,
            add="+",
        )

    def schedule(self, event=None):
        """Schedule tooltip display."""
        self.cancel()

        self.after_id = self.widget.after(
            self.delay,
            self.show,
        )

    def cancel(self):
        """Cancel pending tooltip display."""
        if self.after_id is not None:
            self.widget.after_cancel(
                self.after_id
            )
            self.after_id = None

    def show(self):
        """Show the tooltip."""
        self.after_id = None

        if self.tip_window is not None:
            return

        x = (
            self.widget.winfo_rootx()
            + self.widget.winfo_width()
            + 8
        )
        y = self.widget.winfo_rooty()

        self.tip_window = tk.Toplevel(
            self.widget
        )

        self.tip_window.wm_overrideredirect(
            True
        )

        self.tip_window.wm_geometry(
            f"+{x}+{y}"
        )

        label = tk.Label(
            self.tip_window,
            text=self.text,
            justify="left",
            background="#ffffe0",
            relief="solid",
            borderwidth=1,
            font=("Helvetica", 9),
            padx=6,
            pady=4,
        )
        label.pack()

    def hide(self, event=None):
        """Hide the tooltip."""
        self.cancel()

        if self.tip_window is not None:
            self.tip_window.destroy()
            self.tip_window = None

class AFMSimulatorGUI(ctk.CTk):
    def __init__(self):
        super().__init__()
        self.title("Parti-Suite AFM Force-Volume Simulator")
        self.geometry("1170x535")
        self.resizable(False, False)

        self.variables = {}
        self.entries = {}
        self.excel_file_path = None
        # define default entries
        self.defaults = {
            # Force volume domain
            "Locations_per_axis": 20,
            "Domain_length(m)": "5.0e-6",

            # Colloidal probe physical properties
            "Probe_radius(m)": "5.0e-7",
            "Probe_density(kg/m3)": 1050,

            # Fluid physical properties
            "Fluid_density(kg/m3)": 998.0,
            "Fluid_viscosity(kg/m/s)": "9.98e-4",
            "Temperature(K)": 293.2,
            "Rel_permittivity(-)": 80.0,

            "Ionic_strength(mol/m3)": 6.0,
            "Electrolyte_valence(-)": 1.0,
            "Domain_z_potential(V)": -0.065,
            "Probe_z_potential(V)": -0.065,

            "Domain_hetdomain_z_potential(V)": 0.065,
            "Hetmode_domain(-)": 1,
            "Domain_large_hetdomain_radius(m)": 2e-7,
            "Domain_medium_hetdomain_radius(m)": 0.0,
            "Domain_small_hetdomain_radius(m)": 0.0,
            "Domain_fractional_surface_coverage(-)": 0.0,

            "Probe_hetdomain_z_potential(V)": 0.065,
            "Hetmode_probe(-)": 1,
            "Probe_large_hetdomain_radius(m)": 0.0,
            "Probe_small_hetdomain_radius(m)": 0.0,
            "Probe_fractional_surface_coverage(-)": 0.0,

            "Combined_Hamaker_constant(J)": "7.18e-21",
            "van_der_Waals_decay_length(m)": "1.0e-7",
            "van_der_Waals_mode(-)": 1,

            "Roughness_mode(-)": 0,
            "Slip_length(m)": 0.0,
            "Asperity_height(m)": 0.0,
            "Asperity_domain(m)": 0.0,

            "Acid_base_energy_per_area(J/m2)": "-2.7e-2",
            "Acid_base_decay_length(m)": "6.0e-10",
            "Steric_energy_per_area(J/m2)": 0.017,
            "Steric_decay_length(m)": "4.1e-10",

            "Combined_elastic_modulus(N/m2)": "4.36e9",
            "Work_of_adhesion(J/m2)": "-2.9e-2",
            "Contact_radius_factor(-)": 0.5,

            "Primary_minimum_max_separation(m)": 0.0,
            "Barrier_min_separation(m)": 0.0,
            "Barrier_max_separation(m)": 0.0,
			
        }

        sections = [
            (
                "Force Volume Domain",
                {
                    "Locations per axis": "Locations_per_axis",
                    "Domain length (m)": "Domain_length(m)",
                },
            ),
            (
                "Colloidal Probe Physical Properties\n(default = CML-water-silica @ pH 6.7, IS 6 mM)",
                {
                    "Radius (m)": "Probe_radius(m)",
                    "Density (kg/m3)": "Probe_density(kg/m3)",
                },
            ),
            (
                "Fluid Physical Properties",
                {
                    "Density (kg/m3)": "Fluid_density(kg/m3)",
                    "Viscosity (kg/m·s)": "Fluid_viscosity(kg/m/s)",
                    "Temperature (K)": "Temperature(K)",
                    "Rel. permittivity (-)": "Rel_permittivity(-)",
                },
            ),
            (
                "Mean Field Potentials",
                {
                    "Ionic strength (mol/m³)": "Ionic_strength(mol/m3)",
                    "Electrolyte valence (-)": "Electrolyte_valence(-)",
                    "Domain z-potential (V)": "Domain_z_potential(V)",
                    "Probe z-potential (V)": "Probe_z_potential(V)",
                },
            ),
            (
                "Domain Surface Heterogeneity Parameters",
                {
                    "Hetdomain z-potential (V)": "Domain_hetdomain_z_potential(V)",
                    "Hetmode 1, 5, 9, 73": "Hetmode_domain(-)",
                    "Large hetdomain radius (m)": "Domain_large_hetdomain_radius(m)",
                    "Medium hetdomain radius (m)": "Domain_medium_hetdomain_radius(m)",
                    "Small hetdomain radius (m)": "Domain_small_hetdomain_radius(m)",
                    "Fractional surface coverage (-)": "Domain_fractional_surface_coverage(-)",
                },
            ),
            (
                "Colloidal Probe Surface Heterogeneity Parameters",
                {
                    "Hetdomain z-potential (V)": "Probe_hetdomain_z_potential(V)",
                    "Hetmode (1 or 5)": "Hetmode_probe(-)",
                    "Large hetdomain radius (m)": "Probe_large_hetdomain_radius(m)",
                    "Small hetdomain radius (m)": "Probe_small_hetdomain_radius(m)",
                    "Fractional surface coverage (-)": "Probe_fractional_surface_coverage(-)",
                },
            ),
            (
                "Van der Waals Force Parameters",
                {
                    "Combined Hamaker cst. (J)": "Combined_Hamaker_constant(J)",
                    "van der Waals decay length (m)": "van_der_Waals_decay_length(m)",
                    "van der Waals mode (1, 2, 3 or 4)": "van_der_Waals_mode(-)",
                },
            ),
            (
                "Roughness Parameters",
                {
                    "Roughness mode (0, 1, 2 or 3)": "Roughness_mode(-)",
                    "Slip length (m)": "Slip_length(m)",
                    "Colloid asperity radius (m)": "Asperity_height(m)",
                    "Domain asperity radius (m)": "Asperity_domain(m)",
                },
            ),
            (
                "Lewis Acid-Base and Steric Hydration Force Parameters",
                {
                    "Acid-base energy per area (J/m2)": "Acid_base_energy_per_area(J/m2)",
                    "Acid-base decay length (m)": "Acid_base_decay_length(m)",
                    "Steric energy per area (J/m2)": "Steric_energy_per_area(J/m2)",
                    "Steric decay length (m)": "Steric_decay_length(m)",
                },
            ),
            (
                "Deformation Parameters",
                {
                    "Combined elastic modulus (N/m2)": "Combined_elastic_modulus(N/m2)",
                    "Work of adhesion (J/m2)": "Work_of_adhesion(J/m2)",
                    "Contact radius factor (-)": "Contact_radius_factor(-)",
                },
            ),
            (
                "Separation Distance Limits",
                {
                    "Separation distance (m)": "Primary_minimum_max_separation(m)",
                    "Barrier min separation (m)": "Barrier_min_separation(m)",
                    "Barrier max separation (m)": "Barrier_max_separation(m)",
                },
            ),
        ]
		
        # layout frame

        for i, (title, fields) in enumerate(sections):
            section = SectionFrame(
                self,
                title,
                fields,
                self.variables,
                self.entries,
                defaults=self.defaults,

            )
			
            if i == 0:

                section.grid(row=0, column=0, rowspan=3, padx=5, pady=5, ipady=3, sticky="nsew")
            elif i == 1:
                section.grid(row=3, column=0, rowspan=3, padx=5, pady=5, ipady=3, sticky="nsew")
            elif i == 2:
                section.grid(row=6, column=0, rowspan=5, padx=5, pady=5, ipady=3, sticky="nsew")
            elif i == 3:
                section.grid(row=11, column=0, rowspan=5, padx=5, pady=5, ipady=3, sticky="nsew")
            elif i == 4:
                section.grid(row=0, column=1, rowspan=7, padx=5, pady=5, ipady=3, sticky="nsew")
            elif i == 5:
                section.grid(row=0, column=2, rowspan=7, padx=5, pady=5, ipady=3, sticky="nsew")
            elif i == 6:
                section.grid(row=12, column=1, rowspan=4, padx=5, pady=5, ipady=3, sticky="nsew")
            elif i == 7:
                section.grid(row=7, column=1, rowspan=5, padx=5, pady=5, ipady=3, sticky="nsew")
            elif i == 8:
                section.grid(row=7, column=2, rowspan=5, padx=5, pady=5, ipady=3, sticky="nsew")
            elif i == 9:
                section.grid(row=12, column=2, rowspan=4, padx=5, pady=5, ipady=3, sticky="nsew")
            
            # Separation Frame
            elif i == 10:
                section = SectionFrame(
                    self,
                    title,
                    fields,
                    self.variables,
                    self.entries,
                    defaults=self.defaults,
					sep=1
                )
                section.grid(row=3, column=3, rowspan=6, ipady=3, padx=5, sticky="ew")

        separation_entries = (
            "Primary_minimum_max_separation(m)",
            "Barrier_min_separation(m)",
            "Barrier_max_separation(m)",
        )

        for variable_name in separation_entries:

            self.entries[variable_name].configure(
                state=tk.DISABLED,
                fg_color="gray85",
                text_color="gray",
            )
		
        self.entries["Domain_hetdomain_z_potential(V)"].configure(state=tk.DISABLED,fg_color='gray85', text_color='gray')
        self.entries["Hetmode_domain(-)"].configure(state=tk.DISABLED,fg_color='gray85', text_color='gray')
        self.entries["Domain_large_hetdomain_radius(m)"].configure(state=tk.DISABLED,fg_color='gray85', text_color='gray')
        self.entries["Domain_medium_hetdomain_radius(m)"].configure(state=tk.DISABLED,fg_color='gray85', text_color='gray')
        self.entries["Domain_small_hetdomain_radius(m)"].configure(state=tk.DISABLED,fg_color='gray85', text_color='gray')

        self.entries[
            "Domain_fractional_surface_coverage(-)"
        ].bind(
            "<FocusOut>",
            self.Validate_scov,
        )

        self.entries[
            "Domain_fractional_surface_coverage(-)"
        ].bind(
            "<Return>",
            self.Validate_scov,
        )

        self.entries[
            "Hetmode_domain(-)"
        ].bind(
            "<FocusOut>",
            self.hetmode_domain_callback,
        )

        self.entries[
            "Hetmode_domain(-)"
        ].bind(
            "<Return>",
            self.hetmode_domain_callback,
        )
		
        
        self.entries["Asperity_height(m)"].configure(
            state=tk.DISABLED,
            fg_color="gray85",
            text_color="gray",
        )
        self.entries["Slip_length(m)"].configure(
                    state=tk.DISABLED,
                    fg_color="gray85",
                    text_color="gray",
                )

        self.entries["Asperity_domain(m)"].configure(
            state=tk.DISABLED,
            fg_color="gray85",
            text_color="gray",
        )

        self.entries["Roughness_mode(-)"].bind(
            "<FocusOut>",
            self.roughness_mode_callback,
        )
        self.entries["Roughness_mode(-)"].bind(
            "<Return>",
            self.roughness_mode_callback,
        )

        self.entries["Asperity_height(m)"].bind(
            "<FocusOut>",
            self.colloid_asperity_callback,
        )
        self.entries["Asperity_height(m)"].bind(
            "<Return>",
            self.colloid_asperity_callback,
        )

        self.entries["Asperity_domain(m)"].bind(
            "<FocusOut>",
            self.domain_asperity_callback,
        )
        self.entries["Asperity_domain(m)"].bind(
            "<Return>",
            self.domain_asperity_callback,
        )

        self.roughness_mode_callback()

        self.entries["Probe_hetdomain_z_potential(V)"].configure(state=tk.DISABLED,fg_color='gray85', text_color='gray')
        self.entries["Hetmode_probe(-)"].configure(state=tk.DISABLED,fg_color='gray85', text_color='gray')
        self.entries["Probe_large_hetdomain_radius(m)"].configure(state=tk.DISABLED,fg_color='gray85', text_color='gray')
        self.entries["Probe_small_hetdomain_radius(m)"].configure(state=tk.DISABLED,fg_color='gray85', text_color='gray')
        # Action frame
        ctk.CTkButton(self, text="Import Excel File", command=self.import_excel).grid(
			row = 0, column = 3, sticky = 'ew', padx =5
			)
        self.button_simulate = ctk.CTkButton(
            self,
            text="Simulate Force Profiles",
            command=self.callback_profile_forces,
        )

        self.button_simulate.grid(
            row=1,
            column=3,
            sticky="ew",
            padx=5,
        )
        # ctk.CTkButton(action_frame, text="Draw Heterogeneity").pack(
        #     padx=10, pady=10, fill= 'x'
        # )
        ctk.CTkButton(self, text="Save data to file", command=self.savebutton_callback).grid(
            row = 2, column = 3, sticky = 'ew', padx =5
        )

        self.button_generate = ctk.CTkButton(
            self,
            text="Generate heatmaps and histograms",
            command=self.callback_generate,
            state=tk.DISABLED,
        )

        self.button_generate.grid(
            row=9,
            column=3,
            sticky="ew",
			padx=5,
        )
    
                
        about_frame = ctk.CTkFrame(self)
        about_frame.grid(row = 10, column=3, rowspan =9, padx=5, pady=5, sticky="ew")
        Custom_title(about_frame, text='Authors').pack()
        ctk.CTkLabel(about_frame, 
            text='Code developed by\n'
			 'Alison Sango **, Eddy Pazmiño ** \nand William P. Jhonson *\n'
            'Concept by\n' 
			'William P. Jhonson * and Eddy Pazmiño **\n\n'
            '*University of Utah,Salt Lake City, Utah, USA\n'
            '**Escuela Politécnica Nacional - Quito, Ecuador\n'
            ).pack(expand=True)
        Link_Label(about_frame, link='www.wpjohnsongroup.utah.edu').pack(expand=True)
        ctk.CTkLabel(
			about_frame, text='v1.1\n', text_color='blue'
            ).pack(anchor = 'e')

        self.entries[
            "Probe_fractional_surface_coverage(-)"
        ].bind(
            "<FocusOut>",
            self.validate_scovp,
        )

        self.entries[
            "Probe_fractional_surface_coverage(-)"
        ].bind(
            "<Return>",
            self.validate_scovp,
        )

        self.entries[
            "Hetmode_probe(-)"
        ].bind(
            "<FocusOut>",
            self.hetmode_probe_callback,
        )

        self.entries[
            "Hetmode_probe(-)"
        ].bind(
            "<Return>",
            self.hetmode_probe_callback,
        )

        self.results = None

        self.simulation_process = None
        self.simulation_queue = None

        self.progress_window = None
        self.progress_bar = None
        self.progress_percent_label = None

        ToolTip(
            self.entries["Roughness_mode(-)"],
            (
                "RMODE values:\n"
                "0 smooth surfaces\n"
                "1 rough colloid only\n"
                "2 rough domain only\n"
                "3 rough colloid and rough domain"
            ),
        )

        ToolTip(
            self.entries["Asperity_height(m)"],
            (
                "lower limit: 1e-8 (m)\n"
                "upper limit: colloidal probe radius"
            ),
        )

        ToolTip(
            self.entries["Asperity_domain(m)"],
            "lower limit: 1e-8 (m)",
        )

        ToolTip(
            self.entries["Probe_radius(m)"],
            (
                "probe size lower limit of 5.0e-7 (m). "
                "Consistent with AFM practice"
            ),
        )

        ToolTip(
            self.entries["Domain_length(m)"],
            (
                "Spherical domain is approximated as a flat domain "
                "using a sphere a factor of 1e9 times larger than "
                "the spherical colloidal probe"
            ),
        )

        ToolTip(
            self.entries["Ionic_strength(mol/m3)"],
            (
                "working range from\n"
                "1 to 100 mol/m3"
            ),
        )

        self.hetmode_figure_window = None
        self.entries[
            "Hetmode_domain(-)"
        ].bind(
            "<Button-1>",
            self.show_hetmode_figure,
            add="+",
        )

    def build_simulation_inputs(self) -> dict:
        """Build AFM_happel inputs from the current GUI values."""

        gui_to_simulator = {
            "Locations_per_axis": "NPART",
            "Domain_length(m)": "RLIM",

            "Probe_radius(m)": "AP",
            "Probe_density(kg/m3)": "RHOP",

            "Fluid_density(kg/m3)": "RHOW",
            "Fluid_viscosity(kg/m/s)": "VISC",
            "Temperature(K)": "T",
            "Rel_permittivity(-)": "ER",

            "Ionic_strength(mol/m3)": "IS",
            "Electrolyte_valence(-)": "ZI",

            "Domain_z_potential(V)": "ZETACST",
            "Probe_z_potential(V)": "ZETAPST",

            "Domain_hetdomain_z_potential(V)": "ZETAHET",
            "Hetmode_domain(-)": "HETMODE",
            "Domain_large_hetdomain_radius(m)": "RHET0",
            "Domain_medium_hetdomain_radius(m)": "RHET1",
            "Domain_small_hetdomain_radius(m)": "RHET2",
            "Domain_fractional_surface_coverage(-)": "SCOV",

            "Probe_hetdomain_z_potential(V)": "ZETAHETP",
            "Hetmode_probe(-)": "HETMODEP",
            "Probe_large_hetdomain_radius(m)": "RHETP0",
            "Probe_small_hetdomain_radius(m)": "RHETP1",
            "Probe_fractional_surface_coverage(-)": "SCOVP",

            "Combined_Hamaker_constant(J)": "A132",
            "van_der_Waals_decay_length(m)": "LAMBDAVDW",
            "van_der_Waals_mode(-)": "VDWMODE",

            "Roughness_mode(-)": "RMODE",
            "Slip_length(m)": "B",
            "Asperity_height(m)": "ASPcolloid",
            "Asperity_domain(m)": "ASPdomain",

            "Acid_base_energy_per_area(J/m2)": "GAMMA0AB",
            "Acid_base_decay_length(m)": "LAMBDAAB",
            "Steric_energy_per_area(J/m2)": "GAMMA0STE",
            "Steric_decay_length(m)": "LAMBDASTE",

            "Combined_elastic_modulus(N/m2)": "KINT",
            "Work_of_adhesion(J/m2)": "W132",
            "Contact_radius_factor(-)": "BETA",
        }

        integer_parameters = {
            "NPART",
            "HETMODE",
            "HETMODEP",
            "VDWMODE",
            "RMODE",
        }

        # Only parameters that do NOT currently have GUI entries.
        simulation_inputs = {
            "workdir": None,
            "ATTMODE": 1,
            "CLUSTER": 0,
            "VJET": 1.62e-3,
            "POROSITY": 0.35,
            "AG": 2.55e-4,
            "TTIME": 5000,

            "A11": 0.0,
            "AC1C1": 0.0,
            "A22": 0.0,
            "AC2C2": 0.0,
            "A33": 0.0,
            "T1": 0.0,
            "T2": 0.0,

            "ASP2": 0.0,

            "DIFFSCALE": 0.0,
            "GRAVFACT": 1.0,

            "MULTB": 100.0,
            "MULTNS": 2.0,
            "MULTC": 0.01,
            "DFACTNS": 1.0e-3,
            "DFACTC": 1.0e-1,

            "NOUT": 250,
            "PRINTMAX": 10000,

            "cbPZ": 0,
            "cbMZ": 1,
            "cbPX": 0,
            "cbMX": 0,
        }

        for gui_name, simulator_name in gui_to_simulator.items():
            if gui_name not in self.variables:
                raise KeyError(
                    f"GUI variable '{gui_name}' was not found."
                )

            raw_value = self.variables[gui_name].get().strip()

            if raw_value == "":
                raise ValueError(
                    f"Empty value for '{gui_name}'."
                )

            try:
                if simulator_name in integer_parameters:
                    value = int(float(raw_value))
                else:
                    value = float(raw_value)

            except ValueError as error:
                raise ValueError(
                    f"Invalid value for '{gui_name}': {raw_value}"
                ) from error

            simulation_inputs[simulator_name] = value

        return simulation_inputs

    def roughness_mode_callback(self, event=None):
        """Update asperity fields according to the selected roughness mode."""
        try:
            mode = int(float(self.variables["Roughness_mode(-)"].get()))
        except ValueError:
            return

        if mode not in (0, 1, 2, 3):
            messagebox.showinfo(
                title="Notice",
                message="Roughness mode must be 0, 1, 2 or 3. Value reset to 0.",
            )
            self.variables["Roughness_mode(-)"].set(0)
            mode = 0

        colloid_entry = self.entries["Asperity_height(m)"]
        domain_entry = self.entries["Asperity_domain(m)"]

        if mode == 0:
            self.variables["Asperity_height(m)"].set(0)
            self.variables["Asperity_domain(m)"].set(0)

            colloid_entry.configure(
                state=tk.DISABLED,
                fg_color="gray85",
                text_color="gray",
            )
            domain_entry.configure(
                state=tk.DISABLED,
                fg_color="gray85",
                text_color="gray",
            )

        elif mode == 1:
            self.variables["Asperity_domain(m)"].set(0)

            colloid_entry.configure(state=tk.NORMAL)
            colloid_entry.reset_color()

            domain_entry.configure(
                state=tk.DISABLED,
                fg_color="gray85",
                text_color="gray",
            )

        elif mode == 2:
            self.variables["Asperity_height(m)"].set(0)

            colloid_entry.configure(
                state=tk.DISABLED,
                fg_color="gray85",
                text_color="gray",
            )

            domain_entry.configure(state=tk.NORMAL)
            domain_entry.reset_color()

        elif mode == 3:
            colloid_entry.configure(state=tk.NORMAL)
            domain_entry.configure(state=tk.NORMAL)

            colloid_entry.reset_color()
            domain_entry.reset_color()

        self.check_roughness_heterogeneity_warning()

    def colloid_asperity_callback(self, event=None):
        """Validate the colloid asperity radius."""
        try:
            asperity = float(
                self.variables["Asperity_height(m)"].get()
            )
        except ValueError:
            return

        if asperity < 0:
            messagebox.showinfo(
                title="Notice",
                message="Colloid asperity radius cannot be negative. Value reset to 0.",
            )
            self.variables["Asperity_height(m)"].set(0)
            return
        if 0 < asperity < 1.0e-8:
            messagebox.showinfo(
                title="Notice",
                message=(
                    "Asperity roughness <= 1e-8 (m) will require significantly longer calculation times."
                    "Value reset."
                ),
            )
            self.variables["Asperity_height(m)"].set(1.0e-8)
            self.entries["Asperity_height(m)"].configure(
                fg_color=("burlywood1", "#833e5b")
            )
   
    def domain_asperity_callback(self, event=None):
        """Validate the domain asperity radius."""
        try:
            asperity = float(
                self.variables["Asperity_domain(m)"].get()
            )
        except ValueError:
            return

        if asperity < 0:
            messagebox.showinfo(
                title="Notice",
                message="Domain asperity radius cannot be negative. Value reset to 0.",
            )
            self.variables["Asperity_domain(m)"].set(0)
            return

        if 0 < asperity < 1.0e-8:
            messagebox.showinfo(
                title="Notice",
                message=(
                    "Asperity roughness <= 1e-8 (m) will require significantly longer calculation times."
                    "Value reset."
                ),
            )
            self.variables["Asperity_domain(m)"].set(1.0e-8)
            self.entries["Asperity_domain(m)"].configure(
                fg_color=("burlywood1", "#833e5b")
            )

    def check_roughness_heterogeneity_warning(self):
        """Warn when roughness and domain heterogeneity are used together."""
        try:
            roughness_mode = int(
                float(
                    self.variables[
                        "Roughness_mode(-)"
                    ].get()
                )
            )

            surface_coverage = float(
                self.variables[
                    "Domain_fractional_surface_coverage(-)"
                ].get()
            )

        except ValueError:
            return

        if roughness_mode > 0 and surface_coverage > 0:
            messagebox.showwarning(
                title="Notice",
                message=(
                    "For combined roughness and charge heterogeneity impacts:"
                      "Charge heterogeneity impacts are accounted for by the faction " 
                      "of the ZOI occupied by heterodomains (AFRACT) on the equivalent "
                      "smooth surfaces.  The corresponding smooth surface forces are " 
                      "calculated with an offset H2 relative to the actual distance H " 
                      "between each asperity and the other surface (or between asperity " 
                      "pairs for the case where both surfaces have roughness). "
                      "The force contributions from asperities is calculated assuming "
                      "that each asperity has the reported AFRACT such that each "
                      "asperity contributes attractive (AFRACT) and repulsive (1-AFRACT) "
                      "interactions.  The approach is a superposition that does not "
                      "account for the location of the heterogeneity on the asperities. "
                ),
            )



    def update_separation_limits(self):
        """Update separation limits from the latest simulation metadata."""
        if self.results is None:
            return

        metadata = self.results.get("metadata", {})

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

        hmin = float(metadata["HMIN"])
        hfric = float(metadata["HFRIC"])
        hlow = float(metadata["Hlow"])
        hhigh = float(metadata["Hhigh"])

        separation_limit = hlow - hmin + hfric

        self.variables[
            "Primary_minimum_max_separation(m)"
        ].set(separation_limit)

        self.variables[
            "Barrier_min_separation(m)"
        ].set(separation_limit)

        self.variables[
            "Barrier_max_separation(m)"
        ].set(hhigh)

        separation_entries = (
            "Primary_minimum_max_separation(m)",
            "Barrier_min_separation(m)",
            "Barrier_max_separation(m)",
        )

        for variable_name in separation_entries:
            self.entries[variable_name].configure(
                state=tk.NORMAL
            )
            self.entries[variable_name].reset_color()

        self.button_generate.configure(
            state=tk.NORMAL
        )

    def callback_profile_forces(self):
        """Start AFM_happel in a separate process."""

        if (
            self.simulation_process is not None
            and self.simulation_process.is_alive()
        ):
            messagebox.showwarning(
                "Simulation running",
                "An AFM simulation is already running.",
            )
            return

        try:
            simulation_inputs = (
                self.build_simulation_inputs()
            )

        except (ValueError, KeyError) as error:
            messagebox.showerror(
                "Invalid input",
                str(error),
            )
            return

        process_context = mp.get_context(
            "spawn"
        )

        self.simulation_queue = (
            process_context.Queue()
        )

        self.button_simulate.configure(
            state="disabled"
        )

        self.button_generate.configure(
            state="disabled"
        )

        self._show_simulation_progress()

        self.simulation_process = (
            process_context.Process(
                target=_afm_simulation_process,
                args=(
                    simulation_inputs,
                    self.simulation_queue,
                ),
                daemon=True,
            )
        )

        self.simulation_process.start()

        self.after(
            50,
            self._poll_simulation_queue,
        )

    def import_excel(self):
            file_path = filedialog.askopenfilename(
                filetypes=[("Excel files", "*.xlsx *.xls")]
            )
            if file_path:
                self.excel_file_path = file_path
                try:
                    df = pd.read_excel(file_path, header=None, engine="openpyxl")
                    for i in range(0, df.shape[0], 2):
                        if i + 1 >= df.shape[0]:
                            break
                        keys = df.iloc[i].dropna().tolist()
                        values = df.iloc[i + 1].dropna().tolist()
                        for key, value in zip(keys, values):
                            key = str(key).strip()
                            value = str(value).strip()
                            if key in self.variables:
                                self.variables[key].set(value)
                except Exception as e:
                    print(f"Error reading Excel file: {e}")
    
    def Validate_scov(self, *args):
        """Validate domain surface coverage and update heterogeneity controls."""
        surface_coverage_var = self.variables[
            "Domain_fractional_surface_coverage(-)"
        ]

        try:
            surface_coverage = float(surface_coverage_var.get())

        except ValueError:
            messagebox.showinfo(
                title="Notice",
                message=(
                    "Domain fractional surface coverage must be "
                    "a number between 0 and 1. Value reset to 0."
                ),
            )
            surface_coverage_var.set(0)
            surface_coverage = 0

        if not 0 <= surface_coverage <= 1:
            messagebox.showinfo(
                title="Notice",
                message=(
                    "Domain fractional surface coverage must be "
                    "between 0 and 1. Value reset to 0."
                ),
            )
            surface_coverage_var.set(0)
            surface_coverage = 0

        zeta_entry = self.entries[
            "Domain_hetdomain_z_potential(V)"
        ]
        mode_entry = self.entries[
            "Hetmode_domain(-)"
        ]

        radius_names = (
            "Domain_large_hetdomain_radius(m)",
            "Domain_medium_hetdomain_radius(m)",
            "Domain_small_hetdomain_radius(m)",
        )

        if surface_coverage == 0:
            zeta_entry.configure(
                state=tk.DISABLED,
                fg_color="gray85",
                text_color="gray",
            )

            mode_entry.configure(
                state=tk.DISABLED,
                fg_color="gray85",
                text_color="gray",
            )

            for variable_name in radius_names:
                self.variables[variable_name].set(0)

                self.entries[variable_name].configure(
                    state=tk.DISABLED,
                    fg_color="gray85",
                    text_color="gray",
                )

            return

        zeta_entry.configure(state=tk.NORMAL)
        zeta_entry.reset_color()

        mode_entry.configure(state=tk.NORMAL)
        mode_entry.reset_color()

        self.hetmode_domain_callback()
        self.check_roughness_heterogeneity_warning()


    def hetmode_domain_callback(self, event=None):
        """Update domain heterodomain radii according to HETMODE."""
        try:
            surface_coverage = float(
                self.variables[
                    "Domain_fractional_surface_coverage(-)"
                ].get()
            )
        except ValueError:
            return

        if not 0 < surface_coverage <= 1:
            return

        try:
            mode = int(
                float(
                    self.variables[
                        "Hetmode_domain(-)"
                    ].get()
                )
            )
        except ValueError:
            messagebox.showinfo(
                title="Notice",
                message=(
                    "Domain HETMODE must be 1, 5, 9 or 73. "
                    "Value reset to 1."
                ),
            )

            self.variables["Hetmode_domain(-)"].set(1)
            mode = 1

        if mode not in (1, 5, 9, 73):
            messagebox.showinfo(
                title="Notice",
                message=(
                    "Domain HETMODE must be 1, 5, 9 or 73. "
                    "Value reset to 1."
                ),
            )

            self.variables["Hetmode_domain(-)"].set(1)
            mode = 1

        large_name = "Domain_large_hetdomain_radius(m)"
        medium_name = "Domain_medium_hetdomain_radius(m)"
        small_name = "Domain_small_hetdomain_radius(m)"

        large_entry = self.entries[large_name]
        medium_entry = self.entries[medium_name]
        small_entry = self.entries[small_name]

        if mode == 1:
            large_entry.configure(state=tk.NORMAL)
            large_entry.reset_color()

            self.variables[medium_name].set(0)
            self.variables[small_name].set(0)

            medium_entry.configure(
                state=tk.DISABLED,
                fg_color="gray85",
                text_color="gray",
            )

            small_entry.configure(
                state=tk.DISABLED,
                fg_color="gray85",
                text_color="gray",
            )

        elif mode in (5, 9):
            large_entry.configure(state=tk.NORMAL)
            large_entry.reset_color()

            medium_entry.configure(state=tk.NORMAL)
            medium_entry.reset_color()

            self.variables[small_name].set(0)

            small_entry.configure(
                state=tk.DISABLED,
                fg_color="gray85",
                text_color="gray",
            )

        elif mode == 73:
            large_entry.configure(state=tk.NORMAL)
            large_entry.reset_color()

            medium_entry.configure(state=tk.NORMAL)
            medium_entry.reset_color()

            small_entry.configure(state=tk.NORMAL)
            small_entry.reset_color()

    def validate_scovp(self, event=None):
        """Validate probe surface coverage and update heterogeneity controls."""
        surface_coverage_var = self.variables[
            "Probe_fractional_surface_coverage(-)"
        ]

        try:
            surface_coverage = float(surface_coverage_var.get())

        except ValueError:
            messagebox.showinfo(
                title="Notice",
                message=(
                    "Probe fractional surface coverage must be "
                    "a number between 0 and 1. Value reset to 0."
                ),
            )
            surface_coverage_var.set(0)
            surface_coverage = 0

        if not 0 <= surface_coverage <= 1:
            messagebox.showinfo(
                title="Notice",
                message=(
                    "Probe fractional surface coverage must be "
                    "between 0 and 1. Value reset to 0."
                ),
            )
            surface_coverage_var.set(0)
            surface_coverage = 0

        zeta_entry = self.entries[
            "Probe_hetdomain_z_potential(V)"
        ]
        mode_entry = self.entries[
            "Hetmode_probe(-)"
        ]

        radius_names = (
            "Probe_large_hetdomain_radius(m)",
            "Probe_small_hetdomain_radius(m)",
        )

        if surface_coverage == 0:
            zeta_entry.configure(
                state=tk.DISABLED,
                fg_color="gray85",
                text_color="gray",
            )

            mode_entry.configure(
                state=tk.DISABLED,
                fg_color="gray85",
                text_color="gray",
            )

            for variable_name in radius_names:
                self.variables[variable_name].set(0)

                self.entries[variable_name].configure(
                    state=tk.DISABLED,
                    fg_color="gray85",
                    text_color="gray",
                )

            return

        zeta_entry.configure(state=tk.NORMAL)
        zeta_entry.reset_color()

        mode_entry.configure(state=tk.NORMAL)
        mode_entry.reset_color()

        self.hetmode_probe_callback()


    def hetmode_probe_callback(self, event=None):
        """Update probe heterodomain radii according to HETMODEP."""
        try:
            surface_coverage = float(
                self.variables[
                    "Probe_fractional_surface_coverage(-)"
                ].get()
            )
        except ValueError:
            return

        if not 0 < surface_coverage <= 1:
            return

        try:
            mode = int(
                float(
                    self.variables[
                        "Hetmode_probe(-)"
                    ].get()
                )
            )

        except ValueError:
            messagebox.showinfo(
                title="Notice",
                message=(
                    "Probe HETMODE must be 1 or 5. "
                    "Value reset to 1."
                ),
            )

            self.variables["Hetmode_probe(-)"].set(1)
            mode = 1

        if mode not in (1, 5):
            messagebox.showinfo(
                title="Notice",
                message=(
                    "Probe HETMODE must be 1 or 5. "
                    "Value reset to 1."
                ),
            )

            self.variables["Hetmode_probe(-)"].set(1)
            mode = 1

        large_name = "Probe_large_hetdomain_radius(m)"
        small_name = "Probe_small_hetdomain_radius(m)"

        large_entry = self.entries[large_name]
        small_entry = self.entries[small_name]

        if mode == 1:
            large_entry.configure(state=tk.NORMAL)
            large_entry.reset_color()

            self.variables[small_name].set(0)

            small_entry.configure(
                state=tk.DISABLED,
                fg_color="gray85",
                text_color="gray",
            )

        elif mode == 5:
            large_entry.configure(state=tk.NORMAL)
            large_entry.reset_color()

            small_entry.configure(state=tk.NORMAL)
            small_entry.reset_color()



    def get_analysis_limits(self) -> tuple[float, float, float]:
        """Read and validate the current separation-distance limits."""

        try:
            primary_max_h = float(
                self.variables[
                    "Primary_minimum_max_separation(m)"
                ].get()
            )

            barrier_min_h = float(
                self.variables[
                    "Barrier_min_separation(m)"
                ].get()
            )

            barrier_max_h = float(
                self.variables[
                    "Barrier_max_separation(m)"
                ].get()
            )

        except ValueError as error:
            raise ValueError(
                "Separation-distance limits must be numeric."
            ) from error

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


    def update_analysis_results(
        self,
        *,
        show_plots: bool,
    ) -> dict:
        """Recalculate analysis using the current GUI separation limits."""

        if self.results is None:
            raise ValueError(
                "Run the AFM simulation before generating analysis."
            )

        (
            primary_max_h,
            barrier_min_h,
            barrier_max_h,
        ) = self.get_analysis_limits()

        analysis = afm_plot.analyze_force_profiles(
            self.results,
            barrier_min_h=barrier_min_h,
            barrier_max_h=barrier_max_h,
            primary_max_h=primary_max_h,
        )

        self.results["analysis"] = analysis


        if show_plots:
            afm_plot.plot_analysis_data(
                analysis,
                show=True,
            )

        print(
            "\nAnalysis updated:"
            f"\n  Primary max H: {primary_max_h}"
            f"\n  Barrier min H: {barrier_min_h}"
            f"\n  Barrier max H: {barrier_max_h}"
        )

        return analysis

    # def callback_generate(self):
    #     """Generate heatmaps and histograms using the GUI limits."""

    #     if self.results is None:
    #         messagebox.showwarning(
    #             "No simulation",
    #             "Run the AFM simulation first.",
    #         )
    #         return

    #     try:
    #         analysis = self.update_analysis_results(
    #             show_plots=True,
    #         )

    #         if not analysis["has_primary_minimum"]:
    #             messagebox.showwarning(
    #                 "Warning Dialog",
    #                 (
    #                     "No primary minimum detected, "
    #                     "heatmap and histogram disabled"
    #                 ),
    #             )

    #     except (ValueError, KeyError) as error:
    #         print(
    #             f"\nAFM analysis error: {error}"
    #         )

    #         messagebox.showerror(
    #             "Analysis error",
    #             str(error),
    #         )

    #     except Exception as error:
    #         print(
    #             f"\nUnexpected analysis error: {error}"
    #         )

    #         messagebox.showerror(
    #             "Analysis error",
    #             str(error),
    #         )

    def callback_generate(self):
        """Generate heatmaps and histograms using the GUI limits."""

        if self.results is None:
            messagebox.showwarning(
                "No simulation",
                "Run the AFM simulation first.",
            )
            return

        try:
            analysis = self.update_analysis_results(
                show_plots=True,
            )

            if not analysis["has_barrier"]:
                messagebox.showwarning(
                    "Warning Dialog",
                    (
                        "No barrier detected, "
                        "heatmap and histogram disabled"
                    ),
                )

            if not analysis["has_primary_minimum"]:
                messagebox.showwarning(
                    "Warning Dialog",
                    (
                        "No primary minimum detected, "
                        "heatmap and histogram disabled"
                    ),
                )

        except (ValueError, KeyError) as error:
            print(
                f"\nAFM analysis error: {error}"
            )

            messagebox.showerror(
                "Analysis error",
                str(error),
            )

        except Exception as error:
            print(
                f"\nUnexpected analysis error: {error}"
            )

            messagebox.showerror(
                "Analysis error",
                str(error),
            )

    def savebutton_callback(self):
        """Save the latest AFM results and current analysis to Excel."""

        if self.results is None:
            messagebox.showwarning(
                "No simulation",
                "Run the AFM simulation before saving data.",
            )
            return

        if "output_sheets" not in self.results:
            messagebox.showerror(
                "Save error",
                "The current simulation results do not contain "
                "'output_sheets'.",
            )
            return

        try:
            analysis = self.update_analysis_results(
                show_plots=False,
            )

            # Excel
            af.add_analysis_output_sheets(
                self.results["output_sheets"],
                analysis,
            )

        except (ValueError, KeyError) as error:
            messagebox.showerror(
                "Analysis error",
                (
                    "The analysis data could not be generated "
                    "before saving:\n\n"
                    f"{error}"
                ),
            )
            return

        filename = filedialog.asksaveasfilename(
            title="Save AFM simulation results",
            initialfile="output_AFM_python.xlsx",
            defaultextension=".xlsx",
            filetypes=[
                ("Excel files", "*.xlsx"),
            ],
        )

        if not filename:
            return

        output_file = Path(filename)

        try:
            af.save_output(
                self.results["output_sheets"],
                output_file,
            )

            print(
                f"\nAFM data saved successfully:\n{output_file}"
            )

            messagebox.showinfo(
                "Data saved",
                (
                    "AFM simulation and analysis data saved "
                    "successfully:\n\n"
                    f"{output_file}"
                ),
            )

        except Exception as error:
            print(
                f"\nError saving AFM data: {error}"
            )

            messagebox.showerror(
                "Save error",
                f"Could not save the AFM data:\n\n{error}",
            )

    def _show_simulation_progress(self):
        """Open the AFM simulation progress window."""

        self.progress_window = ctk.CTkToplevel(self)

        self.progress_window.title(
            "AFM simulation"
        )

        self.progress_window.geometry(
            "360x130"
        )

        self.progress_window.resizable(
            False,
            False,
        )

        self.progress_window.transient(
            self
        )

        self.progress_window.protocol(
            "WM_DELETE_WINDOW",
            lambda: None,
        )

        ctk.CTkLabel(
            self.progress_window,
            text="Simulating AFM force profiles...",
        ).pack(
            padx=20,
            pady=(20, 8),
        )

        self.progress_bar = ctk.CTkProgressBar(
            self.progress_window,
            width=310,
        )

        self.progress_bar.pack(
            padx=20,
            pady=5,
        )

        self.progress_bar.set(
            0.0
        )

        self.progress_percent_label = ctk.CTkLabel(
            self.progress_window,
            text="0 %",
        )

        self.progress_percent_label.pack(
            pady=(5, 15),
        )

        self.progress_window.lift()


    def _set_simulation_progress(
        self,
        progress: float,
    ):
        """Update the progress bar from Tkinter's main thread."""

        if self.progress_window is None:
            return

        if not self.progress_window.winfo_exists():
            return

        progress = max(
            0.0,
            min(
                1.0,
                float(progress),
            ),
        )

        self.progress_bar.set(
            progress
        )

        self.progress_percent_label.configure(
            text=f"{progress * 100:.0f} %"
        )


    def _close_simulation_progress(self):
        """Close the progress window."""

        if (
            self.progress_window is not None
            and self.progress_window.winfo_exists()
        ):
            self.progress_window.destroy()

        self.progress_window = None
        self.progress_bar = None
        self.progress_percent_label = None


    def _poll_simulation_queue(self):
        """Process simulation messages on Tkinter's main process."""

        finished = False

        while True:
            try:
                message = (
                    self.simulation_queue.get_nowait()
                )

            except queue.Empty:
                break

            message_type = message[0]

            if message_type == "progress":
                self._set_simulation_progress(
                    message[1]
                )

            elif message_type == "success":
                self.results = message[1]

                self._set_simulation_progress(
                    1.0
                )

                finished = True

                self._simulation_completed()

                break

            elif message_type == "error":
                error_message = message[1]
                traceback_text = message[2]

                print(
                    "\n========== AFM SIMULATION ERROR =========="
                )
                print(
                    traceback_text
                )
                print(
                    "==========================================\n"
                )

                finished = True

                self._simulation_failed(
                    error_message
                )

                break

        if not finished:
            self.after(
                50,
                self._poll_simulation_queue,
            )

    def _simulation_completed(self):
        """Handle a successfully completed AFM simulation."""

        self._close_simulation_progress()

        self.button_simulate.configure(
            state="normal"
        )

        self.update_separation_limits()

        print(
            "\nSimulation completed successfully."
        )

        afm_plot.plot_force_profiles(
            self.results,
            show=True,
        )

        afm_plot.plot_probe_locations(
            self.results,
            show=True,
        )

    def _simulation_failed(
        self,
        error_message: str,
    ):
        """Restore the GUI after a simulation error."""

        self._close_simulation_progress()

        self.button_simulate.configure(
            state="normal"
        )

        messagebox.showerror(
            "Simulation error",
            error_message,
        )

    def show_hetmode_figure(self, event=None):
        """Show the available domain HETMODE patterns."""
        if (
            hasattr(self, "hetmode_figure_window")
            and self.hetmode_figure_window is not None
            and self.hetmode_figure_window.winfo_exists()
        ):
            self.hetmode_figure_window.lift()
            self.hetmode_figure_window.focus_force()
            return

        self.hetmode_figure_window = ctk.CTkToplevel(self)
        self.hetmode_figure_window.title("Example heterodomain tiles")

        self.hetmode_figure_window.geometry("600x555")
        self.hetmode_figure_window.resizable(False, False)
        self.hetmode_figure_window.transient(self)

        self.hetmode_figure_window.protocol(
            "WM_DELETE_WINDOW",
            self.close_hetmode_figure,
        )

        figure = Figure(
            figsize=(5.7, 4.9),
            dpi=100,
        )

        figure.suptitle(
            "Hetmode Options",
            fontsize=16,
            y=0.97,
        )

        axes = figure.subplots(
            2,
            2,
        )

        self.draw_hetmode_pattern(
            axes[0, 0],
            mode=1,
            title="Large only\n(HETMODE = 1)",
        )

        self.draw_hetmode_pattern(
            axes[0, 1],
            mode=5,
            title="1 Large, 4 Medium\n(HETMODE = 5)",
        )

        self.draw_hetmode_pattern(
            axes[1, 0],
            mode=9,
            title="1 Large, 8 Medium\n(HETMODE = 9)",
        )

        self.draw_hetmode_pattern(
            axes[1, 1],
            mode=73,
            title="1 Large, 8 Medium, 64 Small\n(HETMODE = 73)",
        )

        figure.subplots_adjust(
            left=0.09,
            right=0.97,
            bottom=0.09,
            top=0.86,
            wspace=0.30,
            hspace=0.48,
        )

        canvas = FigureCanvasTkAgg(
            figure,
            master=self.hetmode_figure_window,
        )

        canvas.draw()

        canvas.get_tk_widget().pack(
            padx=8,
            pady=(4, 8),
        )

        self.hetmode_canvas = canvas
        self.hetmode_matplotlib_figure = figure

    def draw_hetmode_pattern(self, ax, mode, title):
        """Draw one HETMODE hierarchical arrangement."""
        ax.set_xlim(-0.52, 0.52)
        ax.set_ylim(-0.52, 0.52)

        ax.set_aspect(
            "equal",
            adjustable="box",
        )

        ax.set_title(
            title,
            fontsize=9.5,
            fontweight="bold",
            pad=5,
        )

        ax.set_xticks(
            [-0.5, 0.0, 0.5]
        )
        ax.set_yticks(
            [-0.5, 0.0, 0.5]
        )

        ax.tick_params(
            labelsize=8,
        )

        large_radius = 0.050
        medium_radius = 0.022
        small_radius = 0.008

        self.add_hetmode_circle(
            ax,
            x=0.0,
            y=0.0,
            radius=large_radius,
        )

        if mode == 1:
            return

        if mode == 5:
            medium_distance = 0.32

            medium_positions = (
                (-medium_distance, 0.0),
                (medium_distance, 0.0),
                (0.0, medium_distance),
                (0.0, -medium_distance),
            )

            for x, y in medium_positions:
                self.add_hetmode_circle(
                    ax,
                    x=x,
                    y=y,
                    radius=medium_radius,
                )

            return

        medium_positions = self.generate_ring_positions(
            count=8,
            radius=0.30,
        )

        for x, y in medium_positions:
            self.add_hetmode_circle(
                ax,
                x=x,
                y=y,
                radius=medium_radius,
            )

        if mode == 9:
            return

        if mode == 73:
            small_positions = (
                self.generate_power_law_small_domains(
                    medium_positions
                )
            )

            for x, y in small_positions:
                self.add_hetmode_circle(
                    ax,
                    x=x,
                    y=y,
                    radius=small_radius,
                )


    @staticmethod
    def generate_ring_positions(count, radius, angular_offset=0.0):
        """Generate equally spaced coordinates around a circular ring."""
        angles = np.linspace(
            0.0,
            2.0 * np.pi,
            count,
            endpoint=False,
        )

        angles += angular_offset

        return [
            (
                radius * np.cos(angle),
                radius * np.sin(angle),
            )
            for angle in angles
        ]


    def generate_power_law_small_domains(self, medium_positions):
        """
        Generate the 64 small domains for HETMODE 73.

        The hierarchy follows:

            1 large
            8 medium  = 8^1
            64 small  = 8^2

        Each medium domain therefore produces eight small domains.
        """
        small_positions = []

        children_per_medium = 8
        child_distance = 0.070

        for parent_index, (parent_x, parent_y) in enumerate(
            medium_positions
        ):
            angular_offset = (
                np.pi / 8
                if parent_index % 2
                else 0.0
            )

            local_positions = self.generate_ring_positions(
                count=children_per_medium,
                radius=child_distance,
                angular_offset=angular_offset,
            )

            for local_x, local_y in local_positions:
                small_positions.append(
                    (
                        parent_x + local_x,
                        parent_y + local_y,
                    )
                )

        return small_positions


    @staticmethod
    def add_hetmode_circle(ax, x, y, radius):
        """Add one heterodomain marker."""
        circle = Circle(
            (x, y),
            radius,
            facecolor="lime",
            edgecolor="black",
            linewidth=0.7,
        )

        ax.add_patch(circle)


    def close_hetmode_figure(self):
        """Close the HETMODE reference window."""
        if (
            hasattr(self, "hetmode_figure_window")
            and self.hetmode_figure_window is not None
        ):
            self.hetmode_figure_window.destroy()
            self.hetmode_figure_window = None


if __name__ == "__main__":
    mp.freeze_support()
    app = AFMSimulatorGUI()
    
    app.mainloop()

