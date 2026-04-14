import matplotlib.pyplot as plt 
import tkinter as tk
from tkinter import ttk
from tkinter import filedialog
from tkinter import messagebox
import customtkinter as ctk
import numpy as np 
import pandas as pd 
import webbrowser
import openpyxl 
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg, NavigationToolbar2Tk
import functions_xDLVO as fn
import Compare as cm
# use pip install xlrd in the terminal for creating and reading excel files

'''Graphical User Interface'''

# Activate dark mode
# ctk.set_appearance_mode("dark")

# -----------------------------	CUSTOM WIDGETS ---------------------------------
class Custom_rb(ctk.CTkRadioButton):
	"""A custom radio button with predefined width, height, and default grid padding."""

	def __init__(self, master, **kwargs):
		"""Initialize attributes of the parent class."""
		super().__init__(master, 
				   radiobutton_width=20, 
				   radiobutton_height=20, 
				   **kwargs) 
		self.master = master

	def grid(self, **kwargs):
		"""Places the widget in the grid layout."""
		super().grid(padx=5, **kwargs)
	
class Custom_cb(ctk.CTkCheckBox):
	"""A custom checkbox with predefined 'on' and 'off' states and default grid padding."""
	def __init__(self, master, **kwargs):
		"""Initialize attributes of the parent class."""
		super().__init__(master, 
				   onvalue=True,
				   offvalue=False,
				   **kwargs) 
		self.master = master
		self.default_bc = self.cget('border_color')

	def reset_color(self):
		"""Resets the border color to its default."""
		if self.winfo_exists():  
			self.configure(border_color=self.default_bc)

	def grid(self, **kwargs):
		"""Places the widget in the grid layout."""
		super().grid(pady=1, padx=5, sticky='w', **kwargs)

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

		self.update_format()
		
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

class Custom_title(ctk.CTkLabel):
	"""A custom title label with a specific font and default grid padding."""

	def __init__(self, master, **kwargs):
		"""Initialize attributes of the parent class."""
		super().__init__(master, 
				   font=('Helvetica', 12, 'bold'), 
				   **kwargs)
		self.master = master

	def grid(self, row=0, **kwargs):
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
		
class Custom_LabeledEntry():
	"""Creates a grid of labeled entry widgets, optionally excluding specified variables."""

	def __init__(self, master, dict, initial_row, exclude_variables=None):
		
		if exclude_variables == None:
			exclude_variables = []

		# Create entry widgets for the variables
		for i, variable in enumerate(dict['variables']):
			if variable in exclude_variables:
				continue
			Custom_entry(master, textvariable=variable).grid(row=i+initial_row, column=0)
			
			# Create labels for the variables if provided
			if len(dict)>1 and variable not in exclude_variables:
				for i, label in enumerate(dict['labels']):
					ctk.CTkLabel(master, text=label, justify='left').grid(row=i+initial_row, column=1, sticky='w')
			
			# Update variables
			if len(dict)>2:
				for (variable, value) in zip(dict['variables'], dict['default_values']):
					if variable not in exclude_variables:
						variable.set(value=value)

class New_Window(ctk.CTkToplevel):
	"""Creates a new top-level window which stays on top of the master window."""

	def __init__(self, master, title, dim, **kwargs):
		"""Initialize attributes of the parent class."""
		super().__init__(master, **kwargs)
		self.master = master
		self.geometry(f'{dim[0]}x{dim[1]}+{dim[2]}+{dim[3]}') 
		self.title(title)
		self.wm_transient(master) # Make the new window stay always on top
		self.minsize(width=dim[0], height=dim[1])
		# self.focus()
		
class New_window_for_fundamentals(ctk.CTkToplevel):
	"""A custom top-level window with result variable handling and a callback."""

	def __init__(self, master, title, dim, dict=None, cb=None, **kwargs):
		"""Initialize attributes of the parent class."""
		super().__init__(master, **kwargs)
		
		self.master = master
		self.geometry(f'{dim[0]}x{dim[1]}+{dim[2]}+{dim[3]}') 
		self.title(title)
		self.wm_transient(master) # Make the new window stay always on top
		
		self.protocol("WM_DELETE_WINDOW", self.close_window)
		self.result_variables = dict['result_variables']
		self.cb = cb
					
	def close_window(self):
		""" Close the window and update the checkbox if the calculate botton is not pressed."""
		if any(variable.get() == 'calculate' for variable in self.result_variables):
			self.cb.set(value=False)
		self.destroy()
		
class Custom_Toolbar(NavigationToolbar2Tk):
	"""A custom toolbar for Matplotlib that removes the configure subplots button."""
    
	def __init__(self, *args, **kwargs):
		"""Initialize attributes of the parent class."""
		super().__init__(*args, **kwargs)
		self.remove_configure_subplots_button()

	def remove_configure_subplots_button(self):
		""" Remove the 7th button (configure subplots) from the toolbar."""
		buttons = self.winfo_children()
		if len(buttons) > 6:  
			buttons[6].pack_forget()

class Graph(ctk.CTkFrame):
	"""A custom frame that embeds a Matplotlib figure and provides tools for manipulating graph axes."""

	def __init__(self, master, fig, ax, hmax, limY, type_graph, **kwargs):
		"""Initialize attributes of the parent class and add others."""
		super().__init__(master, 
				   **kwargs) 
		self.master = master
		self.type_graph = type_graph
		self.hmax = hmax
		self.limY = limY
		self.ax = ax
		
		# Create canvas for the Matplotlib figure
		self.canvas = FigureCanvasTkAgg(fig, self)  

		self.ax.tick_params(axis='both', labelsize=14)

		self.ax.set_xlabel(self.ax.get_xlabel(), fontsize=14)
		self.ax.set_ylabel(self.ax.get_ylabel(), fontsize=14)

		self.ax.legend(fontsize=10)


		self.canvas.draw()
		self.canvas.get_tk_widget().pack()

		# Adjust figure layout
		fig.tight_layout()
		fig.subplots_adjust(left=0.15, bottom=0.15)
		
		# Set frames for layout
		self.frame_toolbar = ctk.CTkFrame(master=self, fg_color='transparent')
		self.frame_toolbar.pack(fill=tk.X)
		self.scale_panel = ctk.CTkFrame(master=self, fg_color='transparent')
		self.scale_panel.pack()
		self.axisY_panel = ctk.CTkFrame(master=self, fg_color='transparent')
		self.axisY_panel.pack()

		# Navigation toolbar
		self.toolbar = Custom_Toolbar(self.canvas, self.frame_toolbar)
		self.toolbar.update()
		self.toolbar.pack(fill=tk.X)

        # Create variables for axis limits
		self.var_Xmax = tk.StringVar(value=f'{self.hmax:.2f}')
		self.var_Ymin = tk.StringVar()
		self.var_Ymax = tk.StringVar()
		
		# Set initial Y-axis values based on graph type
		if type_graph == 'energy':
			self.var_Ymin.set(value=f'{-self.limY:.2f}')
			self.var_Ymax.set(value=f'{self.limY:.2f}')
		if type_graph == 'force':
			self.var_Ymin.set(value=f'{-self.limY:.2e}')
			self.var_Ymax.set(value=f'{self.limY:.2e}')
       
        # WIDGET CREATION
        # Entries for axis limits
		self.e_Ymin = Custom_entry(self.axisY_panel, textvariable=self.var_Ymin)
		self.e_Ymin.grid(row=0, column=1)
		self.e_Ymax = Custom_entry(self.axisY_panel, textvariable=self.var_Ymax)
		self.e_Ymax.grid(row=1, column=1)
		self.e_Xmax = Custom_entry(self.scale_panel, textvariable=self.var_Xmax)
		self.e_Xmax.grid(row=1, column=1)
		
		# Slider for X-axis control
		self.scale_Xmax = ctk.CTkSlider(self.scale_panel, from_=1, to=1000, orientation='horizontal', 
						width=300, command=self.scale_bar)
		self.scale_Xmax.grid(row=0, column=0, columnspan=2)
		self.scale_Xmax.set(float(self.var_Xmax.get()))

		# Labels for axis settings
		ctk.CTkLabel(self.scale_panel, text='Set Xaxis max value (nm)').grid(row=1, column=0)
		if type_graph == 'energy':
			ctk.CTkLabel(self.axisY_panel, text='Set Yaxis min value (kt)').grid(row=0, column=0)
			ctk.CTkLabel(self.axisY_panel, text='Set Yaxis max value (kt)').grid(row=1, column=0)
		if type_graph == 'force':
			ctk.CTkLabel(self.axisY_panel, text='Set Yaxis min value (N)').grid(row=0, column=0)
			ctk.CTkLabel(self.axisY_panel, text='Set Yaxis max value (N)').grid(row=1, column=0)

		# Bind callbacks for axis limit changes
		self.e_Ymin.bind("<Return>", self.Ymin_callback)
		self.e_Ymax.bind("<Return>", self.Ymax_callback)
		self.e_Xmax.bind("<Return>", self.Xmax_callback)

		self.e_Ymin.bind('<FocusOut>', self.Ymin_callback)
		self.e_Ymax.bind('<FocusOut>', self.Ymax_callback)
		self.e_Xmax.bind('<FocusOut>', self.Xmax_callback)

		# Connect axis limit change callbacks
		self.ax.callbacks.connect('xlim_changed', self.on_xlim_changed)
		self.ax.callbacks.connect('ylim_changed', self.on_ylim_changed)

	def scale_bar(self, value):
		"""Adjust the X-axis limits based on the slider's value."""
		if self.master.winfo_exists():
			self.ax.set_xlim(0, float(value))
			self.var_Xmax.set(value)
			self.canvas.draw()
	
	def on_xlim_changed(self, event_ax):
		"""Update the X-axis variable when limits change."""
		xmin, xmax = event_ax.get_xlim()
		self.update_variable_safely(self.var_Xmax, f"{xmax:.2f}")

	def on_ylim_changed(self, event_ax):
		"""Update the Y-axis variables when limits change."""
		ymin, ymax = event_ax.get_ylim()
		if self.type_graph == 'energy':
			self.update_variable_safely(self.var_Ymin, f"{ymin:.2f}")
			self.update_variable_safely(self.var_Ymax, f"{ymax:.2f}")
		if self.type_graph == 'force':
			self.update_variable_safely(self.var_Ymin, f"{ymin:.2e}")
			self.update_variable_safely(self.var_Ymax, f"{ymax:.2e}")

	def update_variable_safely(self, var, value):
		"""Update a tkinter variable without triggering traces."""
		current_value = var.get()
		if current_value != value:
			var.set(value)

	def Xmax_callback(self, *args):
		"""Ensures the value is within the range [1, 1000] and redraws the canvas."""
		try:
			if float(self.var_Xmax.get()) < 1: 
				self.var_Xmax.set(value=1)

			elif float(self.var_Xmax.get()) > 1000: 
				self.var_Xmax.set(value=1000)
			self.ax.set_xlim([0, float(self.var_Xmax.get())])
			self.canvas.draw()

		except ValueError:
			self.var_Xmax.set(value=self.hmax)		

	def Ymax_callback(self, *arg):
		"""Ensures proper handling when Ymax equals Ymin or invalid input, and redraws the canvas."""
		try:
			if float(self.var_Ymax.get())==0 and float(self.var_Ymin.get())==0:
				self.var_Ymax.set(value=self.limY)
				self.var_Ymin.set(value=-self.limY)
			else:
				if float(self.var_Ymax.get()) <= float(self.var_Ymin.get()):
					ymax = float(self.var_Ymax.get())
					self.var_Ymax.set(value=abs(ymax))
					self.var_Ymin.set(value=-ymax)
			self.ax.set_ylim([float(self.var_Ymin.get()), float(self.var_Ymax.get())])
			self.canvas.draw()
		except ValueError:
			self.var_Ymax.set(value=self.limY)

	def Ymin_callback(self, *arg):
		"""Ensures proper handling when Ymax equals Ymin or invalid input, and redraws the canvas."""
		try:
			if float(self.var_Ymax.get())==0 and float(self.var_Ymin.get())==0:
				self.var_Ymax.set(value=self.limY)
				self.var_Ymin.set(value=-self.limY)
			else:
				if float(self.var_Ymax.get()) <= float(self.var_Ymin.get()):
					ymax = float(self.var_Ymax.get())
					self.var_Ymax.set(value=abs(ymax))
					self.var_Ymin.set(value=-ymax)
			self.ax.set_ylim([float(self.var_Ymin.get()), float(self.var_Ymax.get())])
			self.canvas.draw()
		except ValueError:
			self.var_Ymin.set(value=-self.limY)

# ------------------------------- ROOT WINDOW ----------------------------------
class GUI(ctk.CTk):
	"""A custom GUI for the calculation of xDLVO interactions"""

	def __init__(self, title, size):
		"""Initializes the GUI. Sets up variables and frames."""

		# main setup
		super().__init__()
		self.title(title)
		self.geometry(f'{size[0]}x{size[1]}+0+0')
		self.minsize(size[0],size[1])
		# ---------------------- DEFINING VARIABLES ----------------------------
		# String variables

		# Main Parameters
		self.var_T = tk.StringVar(value=293.15)# temperature(K)  
		self.var_IS = tk.StringVar(value=6.0)# Ionic strength (IS) (mol/m3)   
		self.var_a1 = tk.StringVar(value=2.2e-6)# Colloid radius (a1) (m)   
		self.var_a2 = tk.StringVar(value=2.55e-4)# Collector radius (a2) (m)  
		self.var_z1 = tk.StringVar(value=-0.065)# Colloid zeta potential (z1) (V)     
		self.var_z2 = tk.StringVar(value=-0.070)# Collector zeta potential (z2) (V)   
		self.var_z = tk.StringVar(value=1)# Valence of the symmetric electrolyte (z) (-)   
		self.var_epsilonR = tk.StringVar(value=80.0)# Relative permittivity of water (epsilonR) (-)  
		self.var_lambdaVDW = tk.StringVar(value=1.0e-7)# vdW characterisitic wavelength (lambdaVDW) (m)  
		self.var_sigmac = tk.StringVar(value=3.0e-10)# Born collision diameter (sigmac) (m)   
		
		self.dict_MP = {
			'labels': ['Temperature(K)', 'Ionic strength (IS) (mol/m3)', 'Colloid radius (a1) (m)', 
			  	 'Collector radius (a2) (m)', 'Colloid zeta potential (z1) (V)', 'Collector zeta potential (z2) (V)', 
				 'Valence of the symmetric electrolyte (z) (-)', 'Relative permittivity of water (epsilonR) (-)', 
				 'vdW characteristic wavelength (lambdaVDW) (m)', 'Born collision diameter (sigmac) (m)'], 
			'variables': [self.var_T, self.var_IS, self.var_a1, self.var_a2, self.var_z1, self.var_z2, self.var_z, 
				 self.var_epsilonR, self.var_lambdaVDW, self.var_sigmac] 
			}

		# Extended xDLVO parameters
		self.var_lambdaAB = tk.StringVar(value=6.0e-10)  # Lewis acid-base decay length (lambdaAB) (m)
		self.var_lambdaSTE = tk.StringVar(value=4.1e-10)  # Steric decay length (lambdaSTE) (m)
		self.var_gammaSTE = tk.StringVar(value=1.7e-2)  # Steric energy at minimum separation distance (gammaSTE) (J/m2)
		self.var_aasp = tk.StringVar(value=0)  # Asperity height above mean surface (aasp) (m)
		
		self.dict_extP = {
			'labels': ['Lewis acid-base decay length (lambdaAB) (m)', 'Steric decay length (lambdaSTE) (m)',
                 'Steric energy at minimum separation distance (gammaSTE) (J/m2)'],
			'variables': [self.var_lambdaAB, self.var_lambdaSTE, self.var_gammaSTE]
			}

		# Hamaker constant
		self.var_A132 = tk.StringVar(value=7.17e-21)
		self.var_ve = tk.StringVar(value='N/A')
		self.var_e1 = tk.StringVar(value='N/A')
		self.var_n1 = tk.StringVar(value='N/A')
		self.var_e2 = tk.StringVar(value='N/A')
		self.var_n2 = tk.StringVar(value='N/A')
		self.var_e3 = tk.StringVar(value='N/A')
		self.var_n3 = tk.StringVar(value='N/A')
		self.var_A132_result = tk.StringVar(value='N/A')
		
		self.dict_A132 = {
			'labels':['Main electronic absorption frequency (ve) (s-1)', 'Colloid dielectric constant (e1) (-)',
				 'Colloid refractive index (n1) (-)', 'Collector dielectric constant (e2) (-)', 
				 'Collector refractive index (n2) (-)','Fluid dielectric constant (e3) (-)', 'Fluid refractive index (n3) (-)'], 
			'variables':[self.var_ve, self.var_e1, self.var_n1, self.var_e2, self.var_n2, self.var_e3, self.var_n3], 
			'default_values':[2.04e15, 2.55, 1.557, 3.8, 1.448, 80, 1.333],
			'result_variables':[self.var_A132_result], 
			'result_labels':['Hamaker constant (ve  equivalent)  (J)']
			}
		
		# Acid-Base energy
		self.var_gammaAB = tk.StringVar(value=-0.0270305)
		self.var_g1pos = tk.StringVar(value='N/A')
		self.var_g1neg = tk.StringVar(value='N/A')
		self.var_g2pos = tk.StringVar(value='N/A')
		self.var_g2neg = tk.StringVar(value='N/A')
		self.var_g3pos = tk.StringVar(value='N/A')
		self.var_g3neg = tk.StringVar(value='N/A')
		self.var_AB_result = tk.StringVar(value='N/A')

		self.dict_AB = {'labels':['Colloid electron acceptor (g1pos) (J/m2)', 'Colloid electron donor (g1neg) (J/m2)', 'Colloid electron acceptor (g2pos) (J/m2)',
             'Colloid electron donor (g2neg) (J/m2)', 'Colloid electron acceptor (g3pos) (J/m2)', 'Colloid electron donor (g3neg) (J/m2)'], 
			   'variables':[self.var_g1pos, self.var_g1neg, self.var_g2pos, self.var_g2neg, self.var_g3pos, self.var_g3neg], 
			   'default_values':[0.0, 1.10e-3, 1.00e-4, 37.50e-3, 25.50e-3, 25.50e-3],
			   'result_variables':[self.var_AB_result], 
			   'result_labels':['Acid-base energy at minimum separation distance (J/m2)']}
		
		# Work of adhesion
		self.var_W132 = tk.StringVar(value=-0.029)
		self.var_g1LW = tk.StringVar(value='N/A')
		self.var_g2LW = tk.StringVar(value='N/A')
		self.var_g3LW = tk.StringVar(value='N/A')
		self.var_INDgammaAB = tk.StringVar(value='N/A')
		self.var_W132_result = tk.StringVar(value='N/A')

		self.dict_W132 = {
			'labels':['Colloid van der Waals free energy (g1LW) (J/m2)', 'Collector van der Waals free energy (g2LW) (J/m2)',
                 'Fluid van der Waals free energy (g3LW) (J/m2)', 'Acid-base energy at minimum separation distance (J/m2)'], 
			'variables':[self.var_g1LW, self.var_g2LW, self.var_g3LW, self.var_INDgammaAB], 
			'default_values':[42.00e-3, 27.30e-3, 21.80e-3, self.var_gammaAB.get()],
			'result_variables':[self.var_W132_result], 
			'result_labels':['Work of adhesion (W132) (J/m2)']
			
			}
		# Contact radius
		self.var_acont = tk.StringVar(value=5.0e-8)
		self.var_E1 = tk.StringVar(value='N/A')   
		self.var_E2 = tk.StringVar(value='N/A')
		self.var_v1 = tk.StringVar(value='N/A')
		self.var_v2 = tk.StringVar(value='N/A')
		self.var_INDW132 = tk.StringVar(value='N/A')
		self.var_Kint_result = tk.StringVar(value='N/A')
		self.var_aCont_result = tk.StringVar(value='N/A')

		self.dict_acont = {
			'labels':['Colloid Young\'s modulus (E1) (N/m2)', 'Collector Young\'s modulus (E2) (N/m2)', 'Colloid Poison\'s ratio (v1) (-)',
                 'Collector Poison\'s ratio (v2) (-)', 'Work of adhesion (W132) (J/m2)'], 
			'variables':[self.var_E1, self.var_E2, self.var_v1, self.var_v2, self.var_INDW132], 
			'default_values':[3.0e9, 7.3e10, 0.33, 0.22, self.var_W132.get()],
			'result_variables':[self.var_Kint_result, self.var_aCont_result], 
			'result_labels':['Combined elastic modulus (Kint) (N/m2)', 'Contact Radius (acont) (m)']
			}
		
		# xDLVO profiles
		self.var_rZOI = tk.StringVar(value='calculate')
		self.var_rhet1 = tk.StringVar(value='calculate')
		self.var_rhet2 = tk.StringVar(value='calculate')
		self.var_rhet3 = tk.StringVar(value='calculate')
		self.var_rhet4 = tk.StringVar(value='calculate')
		self.var_rhet1USER = tk.StringVar(value='calculate')
		self.var_rhet2USER = tk.StringVar(value='calculate')
		self.var_rhet3USER = tk.StringVar(value='calculate')
		self.var_rhet4USER = tk.StringVar(value='calculate')
		self.var_zetahet = tk.StringVar(value=0.051)

		self.dict_HET = {
			'variables':[self.var_rhet1, self.var_rhet2, self.var_rhet3, self.var_rhet4], 
			'labels':['0.25 ZOI', '0.5 ZOI', '0.75 ZOI', '1.0 ZOI']
			}
		self.dict_HETUSER = {
			'variables':[self.var_rhet1USER, self.var_rhet2USER, self.var_rhet3USER, self.var_rhet4USER]
			}
		
		# Coated System
		self.var_T1 = tk.StringVar(value='N/A')
		self.var_T2 = tk.StringVar(value='N/A')
		self.var_A33 = tk.StringVar(value='N/A')

		self.dict_CSType = {
			'labels': ['Colloid coating thickness (T1) (m)', 'Collector coating thickness (T2) (m)', 
							'Fluid Hamaker Constant (A33) (J)'],
			'variables': [self.var_T1, self.var_T2, self.var_A33],
			'default_values':[2.30e-9, 1.0e-7, 3.70e-20]
			}

		# Single material values
		self.var_A11 = tk.StringVar(value='N/A')
		self.var_A1p1p = tk.StringVar(value='N/A')
		self.var_A22 = tk.StringVar(value='N/A')
		self.var_A2p2p = tk.StringVar(value='N/A')

		self.dict_single = {
			'labels': ['Colloid Hamaker constant (A11) (J)', 'Colloid coating Hamaker constant (A1p1p) (J)', 
				 'Collector Hamaker constant (A22) (J))', 'Collector coating Hamaker constant (A2p2p) (J)'],
			'variables': [self.var_A11, self.var_A1p1p, self.var_A22, self.var_A2p2p],
			'default_values':[6.50e-20, 7.00e-20, 6.30e-20, 1.51e-19]
			}

		# Combined Hamaker constants
		self.var_A12 = tk.StringVar(value='N/A')
		self.var_A12p = tk.StringVar(value='N/A')
		self.var_A13 = tk.StringVar(value='N/A')
		self.var_A1p2 = tk.StringVar(value='N/A')
		self.var_A1p2p = tk.StringVar(value='N/A')
		self.var_A1p3 = tk.StringVar(value='N/A')
		self.var_A23 = tk.StringVar(value='N/A')
		self.var_A2p3 = tk.StringVar(value='N/A')

		# Combined Hamaker constants
		self.cbA12 = tk.BooleanVar()
		self.cbA12p = tk.BooleanVar()
		self.cbA13 = tk.BooleanVar()
		self.cbA1p2 = tk.BooleanVar()
		self.cbA1p2p = tk.BooleanVar()
		self.cbA1p3 = tk.BooleanVar()
		self.cbA23 = tk.BooleanVar()
		self.cbA2p3 = tk.BooleanVar()
		
		self.dict_combine = {
			'labels': ['Colloid - Collector (A12) (J)', 'Colloid - Collector Coating (A12p) (J)',
				 'Colloid - Fluid (A13) (J)', 'Colloid Coating - Collector  (A1p2) (J)', 
				 'Colloid Coating - Collector Coating (A1p2p) (J)', 'Colloid Coating - Fluid  (A1p3) (J)', 
				 'Collector - Fluid  (A23) (J)', 'Collector Coating - Fluid  (A2p3) (J)'],
			'variables': [self.var_A12, self.var_A12p, self.var_A13, self.var_A1p2, self.var_A1p2p, 
				 self.var_A1p3, self.var_A23, self.var_A2p3],
			'default_values':[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
			'cb_variables':[self.cbA12, self.cbA12p, self.cbA13, self.cbA1p2, self.cbA1p2p, self.cbA1p3, 
				   self.cbA23, self.cbA2p3]
				   }

		# Hamaker constant contributions
		self.var_S1A1p2p = tk.StringVar(value='N/A')
		self.var_S1A12p = tk.StringVar(value='N/A')
		self.var_S1A1p2 = tk.StringVar(value='N/A')
		self.var_S1A12 = tk.StringVar(value='N/A')

		self.dict_CSC1 = {
			'labels': ['Colloid coating - Collector Coating','Colloid - Collector Coating',
				 'Colloid coating - Collector', 'Colloid - Collector'],
			'variables': [self.var_S1A1p2p, self.var_S1A12p, self.var_S1A1p2, self.var_S1A12]
			}
		
		self.var_S2A12p = tk.StringVar(value='N/A')
		self.var_S2A12 = tk.StringVar(value='N/A')

		self.dict_CSC2 = {
			'labels': ['Colloid - Collector Coating', 'Colloid - Collector'],
			'variables': [self.var_S2A12p, self.var_S2A12]
					  }
		
		self.var_S3A1p2 = tk.StringVar(value='N/A')
		self.var_S3A12 = tk.StringVar(value='N/A') 

		self.dict_CSC3 = {
			'labels': ['Colloid coating - Collector', 'Colloid - Collector'],
			'variables': [self.var_S3A1p2, self.var_S3A12 ]
			} 

		#Variables for checkboxes and radiobuttons
		# Geometry type
		self.rbSS = tk.BooleanVar(value=True)

		# Rougness type
		self.rbRmode = tk.IntVar(value=0)

		# Parameters calculated from fundamentals
		self.cbA132 = tk.BooleanVar()
		self.cbgammaAB = tk.BooleanVar()
		self.cbW132 = tk.BooleanVar()
		self.cbacont = tk.BooleanVar()
		self.cA132 = float(self.var_A132.get())
		self.cgammaAB = float(self.var_gammaAB.get())
		self.cW132 = float(self.var_W132.get())
		self.cacont = float(self.var_acont.get())

		#Coated system
		self.cbCOATED = tk.BooleanVar(value=False)
		self.rbCStype = tk.IntVar(value=1)

		# xDLVO profile
		self.rbProfile = tk.StringVar(value='MEAN')
		
		# Initialize windows
		self.graph_window = None
		self.graph_window2 = None
		self.cs_window = None
		self.window_A132 = None
		self.window_AB = None
		self.window_W132 = None
		self.window_acont = None

		# Initialize figures
		self.fig1 = None
		self.fig2 = None
		self.fig3 = None
		self.fig4 = None
		
		# Setup all frames 
		self.parameters_frame(self)
	
		# Run the GUI main loop
		self.mainloop()
	
	def parameters_frame(self, master):
		"""Creates the frames for the main window."""
		
		# Geometry frame
		self.frame_G = ctk.CTkFrame(master)
		Custom_title(self.frame_G, text='Geometry').grid()
		Custom_rb(self.frame_G, text='Sphere Sphere', value=True, variable=self.rbSS, command=self.a2_callback).grid(sticky='w')
		Custom_rb(self.frame_G, text='Sphere Plate', value=False, variable=self.rbSS, command=self.a2_callback).grid(sticky='w')
		
		# Roughness frame
		self.frame_R = ctk.CTkFrame(master)
		Custom_title(self.frame_R, text='Roughness').grid()
		Custom_rb(self.frame_R, text='Smooth surfaces', value=0, command=self.Rmode_callback, 
				  variable=self.rbRmode).grid(sticky='w')
		Custom_rb(self.frame_R, text='Rough Colloid', value=1, command=self.Rmode_callback, 
				  variable=self.rbRmode).grid(sticky='w')
		Custom_rb(self.frame_R, text='Rough Collector', value=2, command=self.Rmode_callback,  
				  variable=self.rbRmode).grid(sticky='w')
		Custom_rb(self.frame_R, text='Rough Colloid & Collector', value=3, command=self.Rmode_callback,   
				  variable=self.rbRmode).grid(sticky='w')
		
		# Main Parameter (MP) frame
		self.frame_MP = ctk.CTkFrame(master)
		Custom_title(self.frame_MP, text='Main Parameters (default = CML-water-silica @ pH 6.7, IS 6 mM)').grid()
		Custom_LabeledEntry(self.frame_MP, self.dict_MP, initial_row=1, exclude_variables=[self.var_a2])
		self.entry_a2 = Custom_entry(self.frame_MP, self.var_a2)
		self.entry_a2.grid(row=4, column=0)
		ctk.CTkLabel(self.frame_MP, text='Collector radius (a2) (m)', justify='left').grid(row=4, column=1, sticky='w')
		
		# Extended DLVO Parameter (extP) frame
		self.frame_extP = ctk.CTkFrame(master)
		Custom_title(self.frame_extP, text='Extended DLVO parameters').grid()
		Custom_LabeledEntry(self.frame_extP, self.dict_extP, initial_row=1)
		self.entry_aasp = Custom_entry(self.frame_extP, self.var_aasp)
		self.entry_aasp.grid(row=4, column=0)
		ctk.CTkLabel(self.frame_extP, text='Asperity height above mean surface (aasp) (m)', justify='left').grid(row=4, column=1, sticky='w')
		self.entry_aasp.bind("<FocusOut>", self.aasp_callback)
		self.entry_aasp.bind("<Return>", self.aasp_callback)
		
		# var der Waals Frame
		self.frame_vdW = ctk.CTkFrame(master)
		self.entry_A132 = Custom_entry(self.frame_vdW, self.var_A132)
		self.entry_A132.grid(row=3, column=0, pady=1, sticky='ew')
		Custom_title(self.frame_vdW, text='van der Waals').grid()
		self.calc_from_Funda_frame(self.frame_vdW, self.cbA132, 2, 'Hamaker constant (A132) (J)',
							 command=self.cbA132_callback)
		Custom_cb(self.frame_vdW, text='Coated System', variable=self.cbCOATED, command=self.cbCOATED_callback).grid(row=0, column=1)
		if self.cbA132.get():
			self.cbCOATED.set(value=False)

		# Acid-Base Frame
		self.frame_AB = ctk.CTkFrame(master)
		self.entry_AB = Custom_entry(self.frame_AB, self.var_gammaAB) 
		self.entry_AB.grid(row=2, column=0, pady=1, sticky='ew')
		self.calc_from_Funda_frame(self.frame_AB, self.cbgammaAB, 1, 'Acid-Base energy at minimum separation distance (gammaAB) (J/m2)', command= self.cbAB_callback)
		
		 # Work of adhesion Frame
		self.frame_W132 = ctk.CTkFrame(master)
		self.entry_W132 = Custom_entry(self.frame_W132, self.var_W132) 
		self.entry_W132.grid(row=2, column=0, pady=1, sticky='ew')
		self.calc_from_Funda_frame(self.frame_W132, self.cbW132, 1, 
							 'Work of adhesion (W132) (J/m2)', 
							command=self.cbW132_callback)
		
		# Contact Radius Frame
		self.frame_acont = ctk.CTkFrame(master)
		self.entry_acont = Custom_entry(self.frame_acont, self.var_acont) 
		self.entry_acont.grid(row=2, column=0, pady=1, sticky='ew')
		self.calc_from_Funda_frame(self.frame_acont, self.cbacont, 1, 
							 'Contact Radius (acont) (m)', 
							 command=self.cbacont_callback)

		# xDLVO profile Frame
		self.frame_Pro = ctk.CTkFrame(master)
		Custom_title(self.frame_Pro, text='xDLVO Profiles').place(relx=0.01, rely=0)
		
		# Main field
		Custom_rb(self.frame_Pro, text='Over mean-field surface', value='MEAN', command=self.mean_callback, 
				  variable=self.rbProfile).place(relx=0.01, rely=0.1) 
		Custom_entry(self.frame_Pro, textvariable=self.var_rZOI, state= tk.DISABLED).place(relx=0.42, rely=0.1)
		ctk.CTkLabel(self.frame_Pro, text='ZOI radius (rZOI) (m)', justify='left').place(relx=0.62, rely=0.1)
		
		# Heterodomains
		Custom_rb(self.frame_Pro, text='Over heterodomain radii (m) for ZOI areal fractions (AFRACT)', 
					 value='HET', command=self.HET_callback, variable=self.rbProfile).place(relx=0.01, rely=0.25)
		# Entries
		self.entry_rhet1 = Custom_entry(self.frame_Pro, textvariable=self.var_rhet1, state=tk.DISABLED)
		self.entry_rhet1.place(relx=0.045, rely=0.37)
		self.entry_rhet2 = Custom_entry(self.frame_Pro, textvariable=self.var_rhet2, state=tk.DISABLED)
		self.entry_rhet2.place(relx=0.295, rely=0.37)
		self.entry_rhet3 = Custom_entry(self.frame_Pro, textvariable=self.var_rhet3, state=tk.DISABLED)
		self.entry_rhet3.place(relx=0.545, rely=0.37)
		self.entry_rhet4 = Custom_entry(self.frame_Pro, textvariable=self.var_rhet4, state=tk.DISABLED)
		self.entry_rhet4.place(relx=0.795, rely=0.37)
		# Labels
		ctk.CTkLabel(self.frame_Pro, text="0.25 ZOI", justify='left').place(relx=0.075, rely=0.48, relheight=0.05)
		ctk.CTkLabel(self.frame_Pro, text="0.5 ZOI", justify='left').place(relx=0.325, rely=0.48, relheight=0.05)
		ctk.CTkLabel(self.frame_Pro, text="0.75 ZOI", justify='left').place(relx=0.575, rely=0.48, relheight=0.05)
		ctk.CTkLabel(self.frame_Pro, text="1.0 ZOI", justify='left').place(relx=0.825, rely=0.48, relheight=0.05)

		# User-specified Heterodomains
		Custom_rb(self.frame_Pro, text='Over user-specified heterodomain radii (m)', 
					 value='HETUSER', command=self.HETUSER_callback, variable=self.rbProfile).place(relx=0.01, rely=0.6)
		# Entries
		self.entry_rhet1USER = Custom_entry(self.frame_Pro, textvariable=self.var_rhet1USER)
		self.entry_rhet2USER = Custom_entry(self.frame_Pro, textvariable=self.var_rhet2USER)
		self.entry_rhet3USER = Custom_entry(self.frame_Pro, textvariable=self.var_rhet3USER)
		self.entry_rhet4USER = Custom_entry(self.frame_Pro, textvariable=self.var_rhet4USER)
		self.entry_rhet1USER.place(relx=0.045, rely=0.7)
		self.entry_rhet2USER.place(relx=0.295, rely=0.7)
		self.entry_rhet3USER.place(relx=0.545, rely=0.7)
		self.entry_rhet4USER.place(relx=0.795, rely=0.7)

		# Heterodomain zeta potential 		
		self.entry_zhet = Custom_entry(self.frame_Pro, textvariable=self.var_zetahet)
		self.entry_zhet.place(relx=0.15, rely=0.85)
		ctk.CTkLabel(self.frame_Pro, text='Heterodomain zeta potential (zhet) (V)', justify='left').place(relx=0.34, rely=0.85)

		#Buttons
		ctk.CTkButton(master, text='Upload from file',command=self.upload_callback).place(relx=0.01, rely=0.0, relwidth=0.24, relheight=0.05)
		self.button_calculate_profiles = ctk.CTkButton(master, text='Calculate Profiles', command=self.calculateProfiles_callback)
		self.button_calculate_profiles.place(relx=0.54, rely=0.89, relwidth=0.215, relheight=0.05)
		self.button_save = ctk.CTkButton(master, text='Save As', command=self.savebutton_callback, state=tk.DISABLED)
		self.button_save.place(relx=0.775, rely=0.89, relwidth=0.215, relheight=0.05)
		self.button_calculate_profiles.bind('<Enter>', lambda event: self.calculateButtonState_callback())
		ctk.CTkButton(master, text='About',command=self.about_callback).place(relx=0.54, rely=0.95, relwidth=0.45, relheight=0.04)
		
		# Frame location
		self.frame_G.place(relx=0.01, rely=0.06, relwidth=0.24, relheight=0.14)
		self.frame_R.place(relx=0.27, rely=0.00, relwidth=0.25, relheight=0.20)
		self.frame_MP.place(relx=0.01, rely=0.22, relwidth=0.51, relheight=0.5)
		self.frame_extP.place(relx=0.01, rely=0.74, relwidth=0.51, relheight=0.25)
		
		self.frame_vdW.place(relx=0.54, rely=0.0, relwidth=0.45, relheight=0.15)
		self.frame_AB.place(relx=0.54, rely=0.17, relwidth=0.45, relheight=0.1)
		self.frame_W132.place(relx=0.54, rely=0.29, relwidth=0.45, relheight=0.1)
		self.frame_acont.place(relx=0.54, rely=0.41, relwidth=0.45, relheight=0.1)
		self.frame_Pro.place(relx=0.54, rely=0.53, relwidth=0.45, relheight=0.34)
		
	def calc_from_Funda_frame(self, master, cb_variable, initial_row, title, command):
		"""Creates the frames for calculated from fundamentals window."""
		master.columnconfigure(0, weight=1)
		master.columnconfigure(1, weight=3)
		Custom_title(master, text=title).grid(row=initial_row)
		Custom_cb(master, text='Calculate from fundamentals', variable=cb_variable, 
				  command=command).grid(row=initial_row+1, column=1)
	
	# --------------------------- POP UP WINDOWS ------------------------------
	def coated_system_frame(self, master): 
		'''Create the widgets of the coated system tab'''
		self.var_T1.set(value=2.30e-9)
		self.var_T2.set(value=1.0e-7)
		self.var_A33.set(value=3.70e-20)
		self.var_A12.set(value=0.0)
		self.var_A12p.set(value=0.0)
		self.var_A13.set(value=0.0)
		self.var_A1p2.set(value=0.0)
		self.var_A1p2p.set(value=0.0)
		self.var_A1p3.set(value=0.0)
		self.var_A23.set(value=0.0)
		self.var_A2p3.set(value=0.0)
		self.var_A11.set(value=6.50e-20)
		self.var_A1p1p.set(value=7.00e-20)
		self.var_A22.set(value=6.30e-20)
		self.var_A2p2p.set(value=1.51e-19)
		self.var_S1A1p2p.set(value='calculate')
		self.var_S1A12p.set(value='calculate')
		self.var_S1A1p2.set(value='calculate')
		self.var_S1A12.set(value='calculate')
		self.var_S2A12p.set(value='N/A')
		self.var_S2A12.set(value='N/A')
		self.var_S3A1p2.set(value='N/A')
		self.var_S3A12.set(value='N/A')
	
		# Type of coated system frame
		self.frame_type = ctk.CTkFrame(master)
		Custom_title(self.frame_type, text='Type of Coated System').grid()
		Custom_rb(
			self.frame_type, 
			text='Coated Colloid - Coated Collector', 
			value=1, 
			variable=self.rbCStype, 
			command=self.rb1_callback
			).grid(sticky='w')
		Custom_rb(
			self.frame_type, 
			text='Colloid - Coated Collector', 
			value=2, 
			variable=self.rbCStype, 
			command=self.rb2_callback
			).grid(sticky='w')

		Custom_rb(
			self.frame_type, 
			text='Coated Colloid -  Collector', 
			value=3, 
			variable=self.rbCStype, 
			command=self.rb3_callback
			).grid(sticky='w')

		# Coating thickness frame 
		self.frame_thick = ctk.CTkFrame(master)
		Custom_title(self.frame_thick, text='Coating thickness and Fluid Hamaker constant').grid()
		#Labels
		ctk.CTkLabel(self.frame_thick, text='Colloid coating thickness (T1) (m)', justify='left').grid(row=1, column=1, sticky='w')
		ctk.CTkLabel(self.frame_thick, text='Collector coating thickness (T2) (m)', justify='left').grid(row=2, column=1, sticky='w')
		ctk.CTkLabel(self.frame_thick, text='Fluid Hamaker Constant (A33) (J)', justify='left').grid(row=3, column=1, sticky='w')
		# Entries
		self.entry_T1 = Custom_entry(self.frame_thick, textvariable=self.var_T1)
		self.entry_T1.grid(row=1, column=0)
		self.entry_T2 = Custom_entry(self.frame_thick, textvariable=self.var_T2)
		self.entry_T2.grid(row=2, column=0)
		self.entry_A33 = Custom_entry(self.frame_thick, textvariable=self.var_A33)
		self.entry_A33.grid(row=3, column=0)

		# Single material values frame 
		self.frame_Sing = ctk.CTkFrame(master)
		Custom_title(self.frame_Sing, text='Hamaker constants - Single material values').grid()
		#Labels
		ctk.CTkLabel(self.frame_Sing, text='Colloid Hamaker constant (A11) (J)', justify='left').grid(row=1, column=1, sticky='w')
		ctk.CTkLabel(self.frame_Sing, text='Colloid coating Hamaker constant (A1p1p) (J)', justify='left').grid(row=1, column=3, sticky='w')
		ctk.CTkLabel(self.frame_Sing, text='Collector Hamaker constant (A22) (J)', justify='left').grid(row=2, column=1, sticky='w')
		ctk.CTkLabel(self.frame_Sing, text='Collector coating Hamaker constant (A2p2p) (J)', justify='left').grid(row=2, column=3, sticky='w')
		# Entries
		self.entry_A11 = Custom_entry(self.frame_Sing, textvariable=self.var_A11)
		self.entry_A11.grid(row=1, column=0)
		self.entry_A1p1p = Custom_entry(self.frame_Sing, textvariable=self.var_A1p1p)
		self.entry_A1p1p.grid(row=1, column=2)
		self.entry_A22 = Custom_entry(self.frame_Sing, textvariable=self.var_A22)
		self.entry_A22.grid(row=2, column=0)
		self.entry_A2p2p = Custom_entry(self.frame_Sing, textvariable=self.var_A2p2p)
		self.entry_A2p2p.grid(row=2, column=2)
		
		# Combined Hamaker constant frame 
		self.frame_Comb = ctk.CTkFrame(master)
		Custom_title(self.frame_Comb, text='Combined Hamaker constant - Coated system').grid()
		ctk.CTkLabel(self.frame_Comb, text='Colloid - Collector (A12) (J)', justify='left').grid(row=1, column=1, sticky='w')
		ctk.CTkLabel(self.frame_Comb, text='Colloid - Collector Coating (A12p) (J)', justify='left').grid(row=2, column=1, sticky='w')
		ctk.CTkLabel(self.frame_Comb, text='Colloid - Fluid (A13) (J)', justify='left').grid(row=3, column=1, sticky='w')
		ctk.CTkLabel(self.frame_Comb, text='Colloid Coating - Collector (A1p2) (J)', justify='left').grid(row=4, column=1, sticky='w')
		ctk.CTkLabel(self.frame_Comb, text='Colloid Coating - Collector Coating (A1p2p) (J)', justify='left').grid(row=5, column=1, sticky='w')
		ctk.CTkLabel(self.frame_Comb, text='Colloid Coating - Fluid (A1p3) (J)', justify='left').grid(row=6, column=1, sticky='w')
		ctk.CTkLabel(self.frame_Comb, text='Collector - Fluid (A23) (J)', justify='left').grid(row=7, column=1, sticky='w')
		ctk.CTkLabel(self.frame_Comb, text='Collector Coating - Fluid (A2p3) (J)', justify='left').grid(row=8, column=1, sticky='w')

		# Entries
		self.entry_A12 = Custom_entry(self.frame_Comb, textvariable=self.var_A12)
		self.entry_A12.grid(row=1, column=0)
		self.entry_A12p = Custom_entry(self.frame_Comb, textvariable=self.var_A12p)
		self.entry_A12p.grid(row=2, column=0)
		self.entry_A13 = Custom_entry(self.frame_Comb, textvariable=self.var_A13)
		self.entry_A13.grid(row=3, column=0)
		self.entry_A1p2 = Custom_entry(self.frame_Comb, textvariable=self.var_A1p2)
		self.entry_A1p2.grid(row=4, column=0)
		self.entry_A1p2p = Custom_entry(self.frame_Comb, textvariable=self.var_A1p2p)
		self.entry_A1p2p.grid(row=5, column=0)
		self.entry_A1p3 = Custom_entry(self.frame_Comb, textvariable=self.var_A1p3)
		self.entry_A1p3.grid(row=6, column=0)
		self.entry_A23 = Custom_entry(self.frame_Comb, textvariable=self.var_A23)
		self.entry_A23.grid(row=7, column=0)
		self.entry_A2p3 = Custom_entry(self.frame_Comb, textvariable=self.var_A2p3)
		self.entry_A2p3.grid(row=8, column=0)

		# Checkboxes
		self.cb_single1 = Custom_cb(self.frame_Comb, text='Calculate from single material values', command=self.calculate_A12, variable=self.cbA12)
		self.cb_single1.grid(row=1, column=2)
		self.cb_single2 = Custom_cb(self.frame_Comb, text='Calculate from single material values', command=self.calculate_A12p, variable=self.cbA12p)
		self.cb_single2.grid(row=2, column=2)
		self.cb_single3 = Custom_cb(self.frame_Comb, text='Calculate from single material values', command=self.calculate_A13, variable=self.cbA13)
		self.cb_single3.grid(row=3, column=2)
		self.cb_single4 = Custom_cb(self.frame_Comb, text='Calculate from single material values', command=self.calculate_A1p2, variable=self.cbA1p2)
		self.cb_single4.grid(row=4, column=2)
		self.cb_single5 = Custom_cb(self.frame_Comb, text='Calculate from single material values', command=self.calculate_A1p2p, variable=self.cbA1p2p)
		self.cb_single5.grid(row=5, column=2)
		self.cb_single6 = Custom_cb(self.frame_Comb, text='Calculate from single material values', command=self.calculate_A1p3, variable=self.cbA1p3)
		self.cb_single6.grid(row=6, column=2)
		self.cb_single7 = Custom_cb(self.frame_Comb, text='Calculate from single material values', command=self.calculate_A23, variable=self.cbA23)
		self.cb_single7.grid(row=7, column=2)
		self.cb_single8 = Custom_cb(self.frame_Comb, text='Calculate from single material values', command=self.calculate_A2p3, variable=self.cbA2p3)
		self.cb_single8.grid(row=8, column=2)

		# Hamaker constant contributions 
		self.frame_contr = ctk.CTkFrame(master)
		Custom_title(self.frame_contr, text='Hamaker constant contributions').grid()
		self.frame_contr.rowconfigure(0, weight=1)
		self.frame_contr.rowconfigure(1, weight=9)

		# Hamaker constant contributions 1 
		self.frame_C1 = ctk.CTkFrame(self.frame_contr, fg_color='transparent')
		Custom_title(self.frame_C1, text='Coated Colloid - Coated Collector').grid()
		Custom_LabeledEntry(self.frame_C1, self.dict_CSC1, 1)

		# Hamaker constant contributions 2 
		self.frame_C2 = ctk.CTkFrame(self.frame_contr, fg_color='transparent')
		Custom_title(self.frame_C2, text='Colloid - Coated Collector').grid()
		Custom_LabeledEntry(self.frame_C2, self.dict_CSC2, 1)

		# Hamaker constant contributions 3 
		self.frame_C3 = ctk.CTkFrame(self.frame_contr, fg_color='transparent')
		Custom_title(self.frame_C3, text='Coated Colloid - Collector').grid()
		Custom_LabeledEntry(self.frame_C3, self.dict_CSC3, 1)

		#Buttons
		ctk.CTkButton(self.frame_contr, text='Calculate', command=self.calculate_CS).grid(row=1, column=1, padx=20)
		

		# Frame location
		self.frame_type.place(relx=0.01, rely=0.0, relwidth=0.43, relheight=0.18)
		self.frame_thick.place(relx=0.45, rely=0.0, relwidth=0.54, relheight=0.18)
		self.frame_Sing.place(relx=0.01, rely=0.19, relwidth=0.98, relheight=0.14)
		self.frame_Comb.place(relx=0.01, rely=0.34, relwidth=0.98, relheight=0.39)
		self.frame_contr.place(relx=0.01, rely=0.74, relwidth=0.98, relheight=0.26)
		self.frame_C1.grid(row=1, column=0)
		# self.frame_C2.grid()
		# self.frame_C3.grid()
		if self.rbRmode.get()==1 or self.rbRmode.get()==2 or self.rbRmode.get()==3:
			messagebox.showwarning(title='Notice', message='Coating systems only applicable to smooth surfaces. Reset to smooth surfaces')
			# Change to smooth mode
			self.rbRmode.set(value=0)
			self.var_aasp.set(value=0)

		if self.rbCStype.get()==1:
			self.rb1_callback()
		if self.rbCStype.get()==2:
			self.rb2_callback()
		if self.rbCStype.get()==3:	
			self.rb3_callback()

	def about_callback(self):
		"""Opens an 'About' window displaying software information"""
		window_about = New_Window(self, 'About', [380, 230, 700, 30])
		ctk.CTkLabel(window_about, 
			   text='\nPartiSuite xDLVO v1.0\n\n'
			   'Software developed by A. Sango** & E. Pazmiño**\n\n'
			   'Source code developed  in W.P. Johnson Research Group:\n'
				'W.P. Johnson* E. Pazmiño**\n' 
				'K. VanNess* C. Ron * A. Rasmuson*\n\n'
				'*University of Utah,Salt Lake City, Utah, USA\n\n'
				'**Escuela Politécnica Nacional - Quito, Ecuador\n'
				).pack(expand=True)
		Link_Label(window_about, link='www.wpjohnsongroup.utah.edu').pack(expand=True)

	def cbA132_callback(self):
		"""Callback to handle the state of cbA132 checkbox."""
		if self.cbA132.get():
			self.open_window_A132()
		
		else:
			self.close_window_A132()
			self.cbA132.set(False)
			self.entry_A132.reset_color()
			self.dict_A132['result_variables'][0].set(value='N/A')
			for variable in self.dict_A132['variables']:
				variable.set(value='N/A')

	def open_window_A132(self):
		"""Opens the A132 window for Hamaker constant parameters."""
		if self.window_A132 is None or not tk.Toplevel.winfo_exists(self.window_A132): 
			self.window_A132 = New_window_for_fundamentals(self,'Hamaker constant parameters', [380, 260, 700, 30], self.dict_A132,  self.cbA132)
			self.window_A132.protocol("WM_DELETE_WINDOW", self.close_window_A132)
			
			Custom_LabeledEntry(self.window_A132, self.dict_A132, initial_row=0)
			ctk.CTkButton(self.window_A132, text='Calculate', command=self.calculate_A132).grid(column=0, row=len(self.dict_A132['labels'])+1, columnspan=2)
			
			self.dict_A132['result_variables'][0].set(value='calculate')
			self.entry_A132calc = Custom_entry(self.window_A132, textvariable=self.dict_A132['result_variables'][0], state='readonly')
			self.entry_A132calc.grid(column=0, row=len(self.dict_A132['labels'])+2)
			ctk.CTkLabel(self.window_A132, text=self.dict_A132['result_labels'][0], justify='left').grid(column=1, row=len(self.dict_A132['labels'])+2, sticky='w')		

		if self.cbCOATED.get():
			self.cbCOATED.set(value=False)
			self.cs_window.destroy()

	def close_window_A132(self):
		"""Closes the A132 window if it exists and resets the A132 checkbox."""
		if self.window_A132 is not None:
			self.window_A132.destroy()
			self.window_A132 = None
			if any(variable.get() == 'calculate' for variable in self.dict_A132['result_variables']):
				self.cbA132.set(value=False)
				self.dict_A132['result_variables'][0].set(value='N/A')
				self.entry_A132.reset_color()
				for variable in self.dict_A132['variables']:
					variable.set(value='N/A')

	def cbAB_callback(self):
		"""Callback to handle the state of cbAB checkbox."""
		if self.cbgammaAB.get():
			self.open_window_AB()
		else:
			self.close_window_AB()
			self.cbgammaAB.set(False)
			self.entry_AB.reset_color()
			self.dict_AB['result_variables'][0].set(value='N/A')
			for variable in self.dict_AB['variables']:
				variable.set(value='N/A')

	def open_window_AB(self):
		"""Opens the AB window for Hamaker constant parameters."""
		if self.window_AB is None or not tk.Toplevel.winfo_exists(self.window_AB): 
			self.window_AB = New_window_for_fundamentals(self,'Acid-base surface', [410, 230, 700, 350], self.dict_AB,  self.cbgammaAB)
			self.window_AB.protocol("WM_DELETE_WINDOW", self.close_window_AB)
			
			
			Custom_LabeledEntry(self.window_AB, self.dict_AB, initial_row=0)
			ctk.CTkButton(self.window_AB, text='Calculate', command=self.calculate_gammaAB).grid(column=0, row=len(self.dict_AB['labels'])+1, columnspan=2)
			self.dict_AB['result_variables'][0].set(value='calculate')
			self.entry_ABcalc = Custom_entry(self.window_AB, textvariable=self.dict_AB['result_variables'][0], state='readonly')
			self.entry_ABcalc.grid(column=0, row=len(self.dict_AB['labels'])+2)
			ctk.CTkLabel(self.window_AB, text=self.dict_AB['result_labels'][0], justify='left').grid(column=1, row=len(self.dict_AB['labels'])+2, sticky='w')		

	def close_window_AB(self):
		"""Closes the A132 window if it exists and resets the A132 checkbox."""
		if self.window_AB is not None:
			self.window_AB.destroy()
			self.window_AB = None
			if any(variable.get() == 'calculate' for variable in self.dict_AB['result_variables']):
				self.cbgammaAB.set(value=False)
				self.dict_AB['result_variables'][0].set(value='N/A')
				self.cbgammaAB.set(False)
				self.entry_AB.reset_color()
				for variable in self.dict_AB['variables']:
					variable.set(value='N/A')

	def cbW132_callback(self):
		"""Callback to handle the state of cbW132 checkbox."""
		if self.cbW132.get():
			self.open_window_W132()
		else:
			self.close_window_W132()
			self.cbW132.set(False)
			self.entry_W132.reset_color()
			self.dict_W132['result_variables'][0].set(value='N/A')
			for variable in self.dict_W132['variables']:
				variable.set(value='N/A')

	def open_window_W132(self):
		"""Opens the AB window for Hamaker constant parameters."""
		if self.window_W132 is None or not tk.Toplevel.winfo_exists(self.window_W132): 
			self.window_W132 = New_window_for_fundamentals(self, 'Work of adhesion (for contact area)', [405, 175, 50, 80], self.dict_W132,  self.cbW132)
			self.window_W132.protocol("WM_DELETE_WINDOW", self.close_window_W132)
			
			Custom_LabeledEntry(self.window_W132, self.dict_W132, initial_row=0)
			ctk.CTkButton(self.window_W132, text='Calculate', command=self.calculate_W132).grid(column=0, row=len(self.dict_W132['labels'])+1, columnspan=2)
			
			self.dict_W132['result_variables'][0].set(value='calculate')
			self.entry_W132calc = Custom_entry(self.window_W132, textvariable=self.dict_W132['result_variables'][0], state='readonly')
			self.entry_W132calc.grid(column=0, row=len(self.dict_W132['labels'])+2)
			ctk.CTkLabel(self.window_W132, text=self.dict_W132['result_labels'][0], justify='left').grid(column=1, row=len(self.dict_W132['labels'])+2, sticky='w')		

	def close_window_W132(self):
		"""Closes the A132 window if it exists and resets the A132 checkbox."""
		if self.window_W132 is not None:
			self.window_W132.destroy()
			self.window_W132 = None
			if any(variable.get() == 'calculate' for variable in self.dict_W132['result_variables']):
				self.cbW132.set(value=False)
				self.dict_W132['result_variables'][0].set(value='N/A')
				for variable in self.dict_W132['variables']:
					variable.set(value='N/A')	
				self.cbW132.set(False)
				self.entry_W132.reset_color()
			
	def cbacont_callback(self):
		"""Callback to handle the state of cbacont checkbox."""
		if self.cbacont.get():
			self.open_window_acont()
		else:
			self.close_window_acont()
			self.cbacont.set(False)
			self.entry_acont.reset_color()
			self.dict_acont['result_variables'][0].set(value='N/A')
			self.dict_acont['result_variables'][1].set(value='N/A')
			for variable in self.dict_acont['variables']:
				variable.set(value='N/A')

	def open_window_acont(self):
		"""Opens the acont window for Hamaker constant parameters."""
		if self.window_acont is None or not tk.Toplevel.winfo_exists(self.window_acont): 
			self.window_acont = New_window_for_fundamentals(self, 'Contact Radius (for steric interaction)', [410, 230, 50, 350], self.dict_acont,  self.cbacont)
			self.window_acont.protocol("WM_DELETE_WINDOW", self.close_window_acont)
			
			Custom_LabeledEntry(self.window_acont, self.dict_acont, initial_row=0)
			ctk.CTkButton(self.window_acont, text='Calculate', command=self.calculate_acont).grid(column=0, row=len(self.dict_acont['labels'])+1, columnspan=2)
			
			self.dict_acont['result_variables'][0].set(value='calculate')
			self.dict_acont['result_variables'][1].set(value='calculate')
			Custom_entry(self.window_acont, textvariable=self.dict_acont['result_variables'][0], state='readonly').grid(column=0, row=len(self.dict_acont['labels'])+2)
			self.entry_acontcalc = Custom_entry(self.window_acont, textvariable=self.dict_acont['result_variables'][1], state='readonly')
			self.entry_acontcalc.grid(column=0, row=len(self.dict_acont['labels'])+3)
			ctk.CTkLabel(self.window_acont, text=self.dict_acont['result_labels'][0], justify='left').grid(column=1, row=len(self.dict_acont['labels'])+2, sticky='w')		
			ctk.CTkLabel(self.window_acont, text=self.dict_acont['result_labels'][1], justify='left').grid(column=1, row=len(self.dict_acont['labels'])+3, sticky='w')		

	def close_window_acont(self):
		"""Closes the A132 window if it exists and resets the A132 checkbox."""
		if self.window_acont is not None:
			self.window_acont.destroy()
			self.window_acont = None
			if any(variable.get() == 'calculate' for variable in self.dict_acont['result_variables']):
				self.cbacont.set(value=False)
				self.dict_acont['result_variables'][0].set(value='N/A')
				self.dict_acont['result_variables'][1].set(value='N/A')
				self.cbacont.set(False)
				self.entry_acont.reset_color()
				for variable in self.dict_acont['variables']:
					variable.set(value='N/A')

	def cbCOATED_callback(self):
		"""Callback to handle the state of cbCOATED checkbox."""
		if self.cbCOATED.get():
			# if self.cs_window is not None:
			# 	self.cs_window.destroy()
			# self.rbCStype.set(value=1)
			self.open_window_CS()
		else:
			self.close_window_CS()
			# Return to default state: Hamaker value and Hamaker entry
			self.var_A132.set(value=7.17e-21)
			self.entry_A132.configure(state=tk.NORMAL)
			# Restart variables
			self.var_T1.set(value='N/A')
			self.var_T2.set(value='N/A')
			self.var_A33.set(value='N/A')

			self.var_A11.set(value='N/A')
			self.var_A1p1p.set(value='N/A')
			self.var_A22.set(value='N/A')
			self.var_A2p2p.set(value='N/A')

			self.var_A12.set(value='N/A')
			self.var_A12p.set(value='N/A')
			self.var_A13.set(value='N/A')
			self.var_A1p2.set(value='N/A')
			self.var_A1p2p.set(value='N/A')
			self.var_A1p3.set(value='N/A')
			self.var_A23.set(value='N/A')
			self.var_A2p3.set(value='N/A')
			
			self.var_S1A1p2p.set(value='N/A')
			self.var_S1A12p.set(value='N/A')
			self.var_S1A1p2.set(value='N/A')
			self.var_S1A12.set(value='N/A')
			self.var_S2A12p.set(value='N/A')
			self.var_S2A12.set(value='N/A')
			self.var_S3A1p2.set(value='N/A')
			self.var_S3A12.set(value='N/A')

	def open_window_CS(self):
		"""Opens the Coated System window, and configures some widgets"""
		self.cs_window = New_Window(self, 'Coated System', [650, 660, 550, 0])
		self.coated_system_frame(self.cs_window)
		self.cs_window.protocol("WM_DELETE_WINDOW", self.CSclosing_callback)
		
		# entry Hamaker constant is disabled
		self.var_A132.set(value='N/A')
		self.entry_A132.configure(state=tk.DISABLED)
		#disable hamaker calculated fron fundamentals
		self.cbA132.set(value=False)
		#close Hamaker window
		self.close_window_A132()

	def close_window_CS(self):
		"""Closes the Coated System window and restores default Hamaker values"""
		self.cs_window.destroy()
		dicts = [self.dict_CSC1, self.dict_CSC2, self.dict_CSC3]

		if any(variable.get() == 'calculate' for d in dicts for variable in d['variables']):
			self.cbCOATED.set(value=False)
			for d in dicts:
				for variable in d['variables']:
					variable.set(value='N/A')

			# Return to default state: Hamaker value and Hamaker entry
			self.var_A132.set(value=7.17e-21)
			self.entry_A132.configure(state=tk.NORMAL)
			# Restart variables
			self.var_T1.set(value='N/A')
			self.var_T2.set(value='N/A')
			self.var_A33.set(value='N/A')

			self.var_A11.set(value='N/A')
			self.var_A1p1p.set(value='N/A')
			self.var_A22.set(value='N/A')
			self.var_A2p2p.set(value='N/A')

			self.var_A12.set(value='N/A')
			self.var_A12p.set(value='N/A')
			self.var_A13.set(value='N/A')
			self.var_A1p2.set(value='N/A')
			self.var_A1p2p.set(value='N/A')
			self.var_A1p3.set(value='N/A')
			self.var_A23.set(value='N/A')
			self.var_A2p3.set(value='N/A')
			
			self.var_S1A1p2p.set(value='N/A')
			self.var_S1A12p.set(value='N/A')
			self.var_S1A1p2.set(value='N/A')
			self.var_S1A12.set(value='N/A')
			self.var_S2A12p.set(value='N/A')
			self.var_S2A12.set(value='N/A')
			self.var_S3A1p2.set(value='N/A')
			self.var_S3A12.set(value='N/A')
		
	def calculateProfiles_callback(self):
		"""Opens new windows to display energy and force plots"""
		
		#Calculate the energy and force profiles
		self.calculate_profiles()
		
		if self.fig1 is not None:
			plt.close(self.fig1)

		if self.fig2 is not None:
			plt.close(self.fig2)

		if self.fig3 is not None:
			plt.close(self.fig3)

		if self.fig4 is not None:
			plt.close(self.fig4)

		#Create the energy and force plots

		# set limits for y axis Ekt and force
		limvekt= 1.5*abs(min(self.Ekt[:, 5]))
		limvf = 1.5*abs(min(self.F[:, 5]))
		# set max limit for x axis (nm)
		hmaxdef = 100
		# get separation distance in nm
		Hnm = self.H/(1.0e-9) #Distance in nm

		#Energy plot
		self.fig1, ax1 = plt.subplots(1,1) #figsize= [12, 6])
		ax1.plot(Hnm, self.Ekt[:, 0], color='b', label='van der Waals')
		ax1.plot(Hnm, self.Ekt[:, 1], color='r', label='EDL')
		ax1.plot(Hnm, self.Ekt[:, 2], color='lime', label='Acid-Base')
		ax1.plot(Hnm, self.Ekt[:, 3], color='magenta', label='Born')
		ax1.plot(Hnm, self.Ekt[:, 4], color='tab:orange', label='Steric')
		ax1.plot(Hnm, self.Ekt[:, 5], color='k', label='Total', linestyle='dashed')
		ax1.set_xlabel('Separation Distance (nm)')
		ax1.set_ylabel('Energy (kT)')
		ax1.set_xlim([0, hmaxdef])
		ax1.set_ylim([-limvekt, limvekt])
		ax1.legend()

		# Force plot
		self.fig2, ax2 = plt.subplots(1,1)
		ax2.plot(Hnm, self.F[:, 0], color='b', label='van der Waals')
		ax2.plot(Hnm, self.F[:, 1], color='r', label='EDL')
		ax2.plot(Hnm, self.F[:, 2], color='lime', label='Acid-Base')
		ax2.plot(Hnm, self.F[:, 3], color='magenta', label='Born')
		ax2.plot(Hnm, self.F[:, 4], color='tab:orange', label='Steric')
		ax2.plot(Hnm, self.F[:, 5], color='k', label='Total', linestyle='dashed')
		ax2.set_xlabel('Separation Distance (nm)')
		ax2.set_ylabel('Force (N)')
		ax2.set_xlim([0, hmaxdef/5])
		ax2.set_ylim([-limvf, limvf])
		ax2.legend()
		ax1.set_position([0.15, 0.2, 0.8, 0.7])
		ax2.set_position([0.15, 0.2, 0.8, 0.7])
		
		# Create new window for graphs
		if self.graph_window is not None and tk.Toplevel.winfo_exists(self.graph_window):
			self.graph_window.destroy() # Ensure that the window does not open twice.

		# Create the energy and force window
		self.graph_window = New_Window(self, 'Energy and Force Profiles', dim=[900,550,0,50])
		# Create the figures for the plots
		Graph(self.graph_window, self.fig1, ax1, hmaxdef, limvekt, 'energy').place(relx=0.01, rely=0, relwidth=0.485, relheight=0.99)
		Graph(self.graph_window, self.fig2, ax2, hmaxdef/5, limvf, 'force').place(relx=0.51, rely=0, relwidth=0.485, relheight=0.99)

		# For heterodomains
		if self.rbProfile.get() == 'HET' or self.rbProfile.get() == 'HETUSER':
			self.fig3, ax3 = plt.subplots(1, 1) 
			ax3.plot(Hnm, self.E_HET_T[:, 0], color='b', label=f'rhet = {self.rhetv[0]:.3e} m  AFRACT = {self.afvector[0]:.2} ZOI')
			ax3.plot(Hnm, self.E_HET_T[:, 1], color='r', label=f'rhet = {self.rhetv[1]:.3e} m  AFRACT = {self.afvector[1]:.2} ZOI')
			ax3.plot(Hnm, self.E_HET_T[:, 2], color='lime', label=f'rhet = {self.rhetv[2]:.3e} m  AFRACT = {self.afvector[2]:.2} ZOI')
			ax3.plot(Hnm, self.E_HET_T[:, 3], color='magenta', label=f'rhet = {self.rhetv[3]:.3e} m  AFRACT = {self.afvector[3]:.2} ZOI')
			ax3.plot(Hnm, self.Ekt[:, 5], color='k', label='Mean Field', linestyle='dashed')
			ax3.set_xlabel('Separation Distance (nm)')
			ax3.set_ylabel('Total Energy (kT)')
			ax3.set_xlim([0, hmaxdef])
			ax3.set_ylim([-limvekt, limvekt])
			ax3.legend(fontsize=6)
			self.fig4, ax4 = plt.subplots(1, 1) 
			ax4.plot(Hnm, self.F_HET_T[:, 0], color='b', label=f'rhet = {self.rhetv[0]:.3e} m  AFRACT = {self.afvector[0]:.2} ZOI')
			ax4.plot(Hnm, self.F_HET_T[:, 1], color='r', label=f'rhet = {self.rhetv[1]:.3e} m  AFRACT = {self.afvector[1]:.2} ZOI')
			ax4.plot(Hnm, self.F_HET_T[:, 2], color='lime', label=f'rhet = {self.rhetv[2]:.3e} m  AFRACT = {self.afvector[2]:.2} ZOI')
			ax4.plot(Hnm, self.F_HET_T[:, 3], color='magenta', label=f'rhet = {self.rhetv[3]:.3e} m  AFRACT = {self.afvector[3]:.2} ZOI')
			ax4.plot(Hnm, self.F[:, 5], color='k', label='Mean Field', linestyle='dashed')
			ax4.set_xlabel('Separation Distance (nm)')
			ax4.set_ylabel('Force (N)')
			ax4.set_xlim([0, hmaxdef/5])
			ax4.set_ylim([-limvf, limvf])
			ax4.legend(fontsize=6)

			# Create new window for heterodomain graphs
			if self.graph_window2 is not None and tk.Toplevel.winfo_exists(self.graph_window2):
				self.graph_window2.destroy()

			self.graph_window2 = New_Window(self, 'Energy and Force profiles for Heterodomain radii and ZOI areal fractions', dim=[1000,550,500,50])

			Graph(self.graph_window2, self.fig3, ax3, hmaxdef, limvekt, 'energy').place(relx=0.01, rely=0, relwidth=0.485, relheight=0.99)
			Graph(self.graph_window2, self.fig4, ax4, hmaxdef/5, limvf, 'force').place(relx=0.51, rely=0, relwidth=0.485, relheight=0.99)
		
		# Activate the save button
		self.button_save.configure(state=tk.NORMAL)
	
	# ------------------------- CALCULATION FUNCTIONS ----------------------------
	def calculate_A132(self):
		"""Calculate Hamaker constant"""
		T = float(self.var_T.get())  # Temperature (T) (Kelvin)
		ve = float(self.var_ve.get())  # Main electronic absorption frequency (ve) (s-1)
		e1 = float(self.var_e1.get())  # Colloid dielectric constant (e1) (-)
		n1 = float(self.var_n1.get())  # Colloid refractive index (n1) (-)
		e2 = float(self.var_e2.get())  # Collector dielectric constant (e2) (-)
		n2 = float(self.var_n2.get())  # Collector refractive index (n2) (-)
		e3 = float(self.var_e3.get())  # Fluid dielectric constant (e3) (-)
		n3 = float(self.var_n3.get())  # Fluid refractive index (n3) (-)
		# calculate A132
		self.cA132 = fn.fcalcA132(ve, e1, n1, e2, n2, e3, n3, T)  # Hamaker constant (ve  equivalent)  (J)
		# Replace calculated value in entries
		self.var_A132_result.set(f'{self.cA132:.2e}')
		self.var_A132.set(f'{self.cA132:.2e}')
		# Change entry color
		self.entry_A132calc.configure(fg_color=('pale turquoise', '#174e73'))
		self.entry_A132.configure(state='readonly', fg_color=('pale turquoise', '#174e73'))
	
	def calculate_gammaAB(self):
		"""Calculate Acid-base energy at minimum separation distance"""
		# Acid-base surface energy components 
		g1pos = float(self.var_g1pos.get())  # Colloid electron acceptor (g1pos) (J/m2)
		g1neg = float(self.var_g1neg.get())  # Colloid electron donor (g1neg) (J/m2)
		g2pos = float(self.var_g2pos.get())  # Colloid electron acceptor (g2pos) (J/m2)
		g2neg = float(self.var_g2neg.get())  # Colloid electron donor (g2neg) (J/m2)
		g3pos = float(self.var_g3pos.get())  # Colloid electron acceptor (g3pos) (J/m2)
		g3neg = float(self.var_g3neg.get())  # Colloid electron donor (g2neg) (J/m2)
		# calculate AB
		self.cgammaAB = fn.fcalcgammaAB(g1pos, g1neg, g2pos, g2neg, g3pos, g3neg)  # Acid-Base energy at minimum separation distance (gammaAB) (J/m2)
		# Replace calculated value in entries
		self.var_AB_result.set(f'{self.cgammaAB:.6f}')
		self.var_gammaAB.set(f'{self.cgammaAB:.6f}')
		# Change entry color
		self.entry_ABcalc.configure(fg_color=('pale green', '#365e0b'))
		self.entry_AB.configure(state='readonly', fg_color=('pale green', '#365e0b'))
	
	def calculate_W132(self):
		"""Calculate Work of adhesion"""
		# Work of adhesion parameters
		g1LW = float(self.var_g1LW.get())  # Colloid van der Waals free energy (g1LW) (J/m2)
		g2LW = float(self.var_g2LW.get())  # Collector van der Waals free energy (g2LW) (J/m2)
		g3LW = float(self.var_g3LW.get())  # Fluid van der Waals free energy (g3LW) (J/m2)
		gammaAB = float(self.var_INDgammaAB.get())   # Acid-base energy at minimum separation distance (J/m2)
		# calculate W132
		self.cW132 = fn.fcalcW132(g1LW, g2LW, g3LW, gammaAB)  # Work of adhesion (for contact area) (J/m2)
		# Replace calculated value in entries
		self.var_W132_result.set(f'{self.cW132:.6f}')
		self.var_W132.set(f'{self.cW132:.6f}')
		# Change entry color
		self.entry_W132calc.configure(fg_color=('cornsilk2', 'gray8'))
		self.entry_W132.configure(state='readonly', fg_color=('cornsilk2', 'gray8'))
	
	def calculate_acont(self):
		"""Calculate Contact Radius"""
		# Contact Radius parameters
		E1 = float(self.var_E1.get())  # Colloid Young's modulus (E1) (N/m2)
		E2 = float(self.var_E2.get())  # Collector Young's modulus (E2) (N/m2)
		v1 = float(self.var_v1.get())  # Colloid Poison's ratio (v1) (-)
		v2 = float(self.var_v2.get())  # Collector Poison's ratio (v2) (-))
		W132 = float(self.var_INDW132.get())  # Work of adhesion (W132) (J/m2))
		a1 = float(self.var_a1.get())  # Colloid radius (a1) (m)   
		# calculate contact radius and Combined elastic modulus 
		[self.cacont, self.kint] = fn.fcalcacont(E1, v1, E2, v2, W132, a1)  # Contact Radius (for steric interaction)(acont) (m) 
																# and Combined elastic modulus (self.kint) (N/m2)
		# Replace calculated value in entries
		self.var_aCont_result.set(f'{self.cacont:.2e}')
		self.var_Kint_result.set(f'{self.kint:.2e}')
		self.var_acont.set(f'{self.cacont:.2e}')
		# Change entry color
		self.entry_acontcalc.configure(fg_color=('coral1', '#c32727'))
		self.entry_acont.configure(state='readonly', fg_color=('coral1', 'brown4'))
	
	def calculate_profiles(self):
		"""Calculates the interaction profiles (energy and force)"""

		#DEFINE CONDITIONS
		# Geometry
		if self.rbSS.get(): # SS sphere-sphere, SP sphere-plate
			self.SS = 1
			self.SP = 0
		else:
			self.SP = 1
			self.SS = 0

		# Roughness mode
		if self.rbRmode.get() == 0:  # Rmode0 = Smooth
			self.Rmode = 0
		if self.rbRmode.get() == 1:  # Rmode1 = Rough Colloid
			self.Rmode = 1
		if self.rbRmode.get() == 2:  # Rmode=2 Rough Collector
			self.Rmode = 2
		if self.rbRmode.get() == 3:  #  Rmode=3 Rough Colloid and Collector
			self.Rmode = 3

		# Heterodomain properties
		if self.rbProfile.get() == 'HET' or self.rbProfile.get() == 'HETUSER':
			zetahet = float(self.var_zetahet.get())
			
		# Main parameters
		T = float(self.var_T.get())  # temperature(K)                                  
		IS = float(self.var_IS.get())  # Ionic strength (IS) (mol/m3)      
		a1 = float(self.var_a1.get()) # Colloid radius (a1) (m)         
		a2 = float(self.var_a2.get()) if not self.var_a2.get()=='N/A' else 'N/A' # Collector radius (a2) (m)      
		zetac = float(self.var_z1.get())  # Colloid zeta potential (z1) (V)                    
		zetap = float(self.var_z2.get())  # Collector zeta potential (z2) (V)                  
		z = float(self.var_z.get())  # Valence of the symmetric electrolyte (z) (-)
		epsilonR = float(self.var_epsilonR.get())  # Relative permittivity of water (epsilonR) (-)
		lambdavdW = float(self.var_lambdaVDW.get())  # vdW characterisitic wavelength (lambdaVDW) (m)
		sigmaC = float(self.var_sigmac.get())  # Born collision diameter (sigmac) (m)

		# Extended DLVO parameter
		lambdaAB = float(self.var_lambdaAB.get())  # Lewis acid-base decay length (lambdaAB) (m)
		lambdaSTE = float(self.var_lambdaSTE.get())  # Steric decay length (lambdaSTE) (m)
		gammaSTE = float(self.var_gammaSTE.get())  # Steric energy at minimum separation distance (gammaSTE) (J/m2)
		aasp = float(self.var_aasp.get())  # Asperity height above mean surface (aasp) (m)

		# Interaction constants
		A132 = float(self.cA132) if not self.cA132=='N/A' else 'N/A'
		gammaAB = float(self.cgammaAB)
		W132 = float(self.cW132)
		acont = float(self.cacont)

		#Coated system
		# coating thickness and Fluid Hamaker constant
		T1 = float(self.var_T1.get()) if not self.var_T1.get()=='N/A' else 'N/A'  # Colloid coated thickness (m)
		T2 = float(self.var_T2.get()) if not self.var_T2.get()=='N/A' else 'N/A'  # Collector coated thickness (m)
		# A33 = float(self.var_A33.get()) if not self.var_A33.get()=='N/A' else 'N/A'  # Fluid Hamaker Constant (A33) (J)
		
		# Hamaker contributions values
		s1A1p2p = float(self.var_S1A1p2p.get()) if self.var_S1A1p2p.get() not in ['calculate', 'N/A'] else 'N/A'
		s1A12p = float(self.var_S1A12p.get()) if self.var_S1A12p.get() not in ['calculate', 'N/A'] else 'N/A'
		s1A1p2 = float(self.var_S1A1p2.get()) if self.var_S1A1p2.get() not in ['calculate', 'N/A'] else 'N/A'
		s1A12 = float(self.var_S1A12.get()) if self.var_S1A12.get() not in ['calculate', 'N/A'] else 'N/A'
		s2A12p = float(self.var_S2A12p.get()) if self.var_S2A12p.get() not in ['calculate', 'N/A'] else 'N/A'
		s2A12 = float(self.var_S2A12.get()) if self.var_S2A12.get() not in ['calculate', 'N/A'] else 'N/A'
		s3A1p2 = float(self.var_S3A1p2.get()) if self.var_S3A1p2.get() not in ['calculate', 'N/A'] else 'N/A'
		s3A12 = float(self.var_S3A12.get()) if self.var_S3A12.get() not in ['calculate', 'N/A'] else 'N/A'

		# Van der Waals mode
		self.cb1=0
		self.cb2=0
		self.cb3=0
		
		if self.cbCOATED.get():
			# set combined Hamnaker to N/A (not used in coated systems)
			A132 = 'N/A'

			# load corresponding hamaker contributions depending on type of coated
			if self.rbCStype.get()==1:
				self.cb1=1
				self.cb2=0
				self.cb3=0
				VDWmode = 1  # 1 coated colloid - coated collector
				# set corresponding combined Hamaker constant aproximated from
				# coating contributions
				aproxA132 = s1A1p2p

			if self.rbCStype.get()==2:
				self.cb1=0
				self.cb2=1
				self.cb3=0
				VDWmode = 2
				#set corresponding combined Hamaker constant aproximated from
				#coating contributions
				aproxA132 = s2A12p

			if self.rbCStype.get()==3:
				self.cb1=0
				self.cb2=0
				self.cb3=1
				VDWmode = 3
				#set corresponding combined Hamaker constant aproximated from
				#coating contributions
				aproxA132 = s3A1p2
			
		
		# CALCULATE PROFILES

		# define constants
		kb =1.3806485E-23  # Boltzmann constant J/K
		kt = kb*T  # (J)
		hp = 6.62607004E-34  # Planck constant J.s
		e_charge = 1.602176621e-19  # elementary charge (C)
		Na = 6.02214086e+23  # avogadro number (-)
		epsilon0 = 8.85418781762e-12  # Vacuum permitivity (C2/(N.m2))
		epsilonW = epsilon0*epsilonR  # Water permitivity (C2/(N.m2))

		# Number of interactions per asperity
		# Ranges from 1-4 for opposed and complimentary packed asperities, respectively.
		# Recommended value is 2.5
		Nco = 2.5

		# Calculated parameters
		# Inverse Debye lenght
		k = 1/(epsilonW*kb*T/2/Na/z**2/e_charge**2/IS)**0.5 #inverse Debye lenght

		# Radius of zone of influence (rZOI) for EDL
		rZOI = 2*(a1*k**-1)**0.5
		self.var_rZOI.set(f'{rZOI:.2e}')
		# Radius of zone of influence (rZOIAB) for Acid-base
		rZOIAB = 2*(a1*lambdaAB)**0.5

		# heterodomain parameters
		# Initialize vectors
		rhetv = np.zeros(4)
		afvector = np.zeros(4)
		self.rhetv = rhetv
		self.afvector = afvector

		if self.rbProfile.get() == 'HET':
			# Calculate rhetvector corresponding to 0.25 0.5 0.75 and 1.0 ZOI
			afvector = np.array([0.25, 0.5,  0.75,  1.0])  # ZOI area fractional vector
			rhetv = (afvector*rZOI**2)**0.5  # heterodomain radii vector
			self.var_rhet1.set(f'{rhetv[0]:.4e}')  # heterodomain radii (m) for 0.25 ZOI
			self.var_rhet2.set(f'{rhetv[1]:.4e}')  # heterodomain radii (m) for 0.5 ZOI
			self.var_rhet3.set(f'{rhetv[2]:.4e}')  # heterodomain radii (m) for 0.75 ZOI
			self.var_rhet4.set(f'{rhetv[3]:.4e}')  # heterodomain radii (m) for 1.0 ZOI
			self.rhetv = rhetv
			self.afvector = afvector

			# Correct the entry format
			self.entry_rhet1.update_format()
			self.entry_rhet2.update_format()
			self.entry_rhet3.update_format()
			self.entry_rhet4.update_format()

		if self.rbProfile.get() == 'HETUSER':
			# obtain rhetvector corresponding to user specified rhets
			rhetv[0] = float(self.var_rhet1USER.get())  # heterodomain radii vector (m) for 0.25 ZOI
			rhetv[1] = float(self.var_rhet2USER.get())  # heterodomain radii vector (m) for 0.5 ZOI
			rhetv[2] = float(self.var_rhet3USER.get())  # heterodomain radii vector (m) for 0.75 ZOI
			rhetv[3] = float(self.var_rhet4USER.get())  # heterodomain radii vector (m) for 0.1 ZOI
			# hetdomain area vector
			ahetv = rhetv**2*np.pi  # hetdomain area vector
			afvector = ahetv/(rZOI**2*np.pi) # ZOI area fractional vector
			afvector[afvector>1]=1  # bound fractional area to maximum coverage
			self.rhetv = rhetv
			self.afvector = afvector

			# Correct the entry format
			self.entry_rhet1USER.update_format()
			self.entry_rhet2USER.update_format()
			self.entry_rhet3USER.update_format()
			self.entry_rhet4USER.update_format()
		
		if self.Rmode > 0:
			# Set number of asperities in zone of influence EDL and vdw
			asplim = 0.5*(np.pi**0.5)*rZOI
			if (aasp>=asplim):
				n = 1  # number of asperities in ZOI EDL and VDW
			else:
				n = rZOI**2/(aasp**2)*(np.pi/4)  # number of asperities in ZOI EDL and VDW

			# Calculate number of asperities in zone of influence for AB
			asplimAB = 0.5*(np.pi**0.5)*rZOIAB
			if (aasp>=asplimAB):
				nAB = 1  # number of asperities in ZOI ABL
			else:
				nAB = (rZOIAB**2)/(aasp**2)*(np.pi/4)  # number of asperities in ZOI ABL

		# Smooth surface coverage for EDL
		if self.Rmode>0 and aasp>0.0:
			theta = 1.0-np.pi/4
		else:
			theta = 1.0

		# Radius of steric hydration contact
		aSte = (acont**2+2*lambdaSTE*(a1+(a1**2-acont**2)**0.5))**0.5 #radius of steric hydration contact

		# DISTANCE VECTOR
		sf = 0.01  # step factor
		hmax = 1.0e-6
		hmin = 1.0e-10
		# Generate vector
		H = np.array([hmin])
		i = 0
		while H[i] < hmax:
			new_distance = H[i] * (1 + sf)
			H = np.append(H, new_distance)
			i += 1

		# Separation distance for offset smooth surface (Rmode > 0)
		if self.Rmode == 1 or self.Rmode == 2:
			Hoff = aasp  # complimentary offset surface distance
			H2 = H + Hoff
		if self.Rmode == 3:
			Hoff = 0.5*(2*aasp + np.sqrt(3)*aasp)  # complimentary offset surface distance
			H2 = H + Hoff

		#CALCULATION OF INTERACTIONS

		# Sphere - sphere geometry
		if self.SS == 1:
			# Interactions independent of coating and roughness (assumed)
			# Hamaker calculation
			if self.cbCOATED.get():
				A132c = aproxA132  # Hamaker depending of VDWmode
			else:
				A132c = A132  # Hamaker calculated from fundamentals
			# Born interaction
			E_Born = fn.EBorn_SS(H, A132c, sigmaC, a1)
			F_Born = fn.F_Born_SS(H, A132c, sigmaC, a1)
			# Steric interaction
			E_Ste = fn.E_Ste_SS(H, lambdaSTE, gammaSTE, aSte)
			F_Ste = fn.F_Ste_SS(H, lambdaSTE, gammaSTE, aSte)
			# Smooth surface
			if self.Rmode == 0:
			# Van der Waals interactions
				if self.cbCOATED.get(): # coated systems
					if VDWmode == 1:  # coated colloid - coated collector
						E_vDW = fn.E_vdW_SS_coated_systems(H, a1, a2, lambdavdW, T1, T2, s1A1p2p, s1A12p, s1A1p2, s1A12, VDWmode)
						F_vDW = fn.F_vdW_SS_coated_systems(H, a1, a2, lambdavdW, T1, T2, s1A1p2p, s1A12p, s1A1p2, s1A12, VDWmode)
					if VDWmode == 2:  # colloid - coated collector
						E_vDW = fn.E_vdW_SS_coated_systems(H, a1, a2, lambdavdW, T1, T2, 0.0, s2A12p, 0.0 , s2A12, VDWmode)
						F_vDW = fn.F_vdW_SS_coated_systems(H, a1, a2, lambdavdW, T1, T2, 0.0, s2A12p, 0.0 , s2A12, VDWmode)
					if VDWmode == 3:  # coated colloid - collector
						E_vDW = fn.E_vdW_SS_coated_systems(H, a1, a2, lambdavdW, T1, T2, 0.0, 0.0, s3A1p2, s3A12, VDWmode)
						F_vDW = fn.F_vdW_SS_coated_systems(H, a1, a2, lambdavdW, T1, T2, 0.0, 0.0, s3A1p2, s3A12, VDWmode)
				else: # not coated smooth
					E_vDW = fn.E_vdW_SS_colloid_plate(H, A132, a1, a2, lambdavdW)
					F_vDW = fn.F_vdW_SS_colloid_plate(H, A132, a1, a2, lambdavdW)
				# EDL smooth
				E_EDL = fn.E_EDL_SS_colloid_plate(H, 1.0, epsilonW, k, kb, T, z, zetap, e_charge, zetac, a1, a2)
				F_EDL = fn.F_EDL_SS_colloid_plate(H, 1.0, epsilonW, k, kb, T, z, zetap, e_charge, zetac, a1, a2)
				if self.rbProfile.get() == 'HET' or self.rbProfile.get() == 'HETUSER':
					E_EDL_HET = fn.E_EDL_SS_colloid_plate(H, 1.0, epsilonW, k, kb, T, z, zetap, e_charge, zetahet, a1, a2)
					F_EDL_HET = fn.F_EDL_SS_colloid_plate(H, 1.0, epsilonW, k, kb, T, z, zetap, e_charge, zetahet, a1, a2)
				# ABL smooth
				ho = fn.calculation_ho(E_vDW, E_Born, A132, H)  # ho calculation for ABL interaction
				E_ABL = fn.E_AB_SS_colloid_plate(H,lambdaAB, a1, gammaAB, ho, a2)
				F_ABL = fn.F_AB_SS_colloid_collector(H, lambdaAB, a1, gammaAB, ho, a2)

			else: # Rmode1 = Rough Colloid rmode=2 Rough Collector Rmode=3 Rough Colloid and Collector
				# VdW rough
				E_vDW = (fn.E_vdW_SS_colloid_plate(H2, A132, a1, a2, lambdavdW)
						+ fn.E_vdW_SS_RMODE(n, H, A132, aasp, a2, lambdavdW, a1, self.Rmode, Nco))
				F_vDW = (fn.F_vdW_SS_colloid_plate(H2,A132, a1, a2, lambdavdW)
						+ fn.F_vdW_SS_RMODE(n, H, a2, A132, aasp, lambdavdW, a1, self.Rmode, Nco))
				# EDL rough
				E_EDL = (theta*fn.E_EDL_SS_colloid_plate(H2, 1.0, epsilonW, k, kb, T, z, zetap, e_charge, zetac, a1, a2)
						+ fn.E_EDL_SS_RMODE(H, a2, epsilonW, k, kb, T, z, zetap, e_charge, zetac, aasp, a1, self.Rmode, n, Nco))
				F_EDL = (theta*fn.F_EDL_SS_colloid_plate(H2, 1.0, epsilonW, k, kb, T, z, zetap, e_charge, zetac, a1, a2)
						+ fn.F_EDL_SS_RMODE(H, a2, epsilonW, k, kb, T, z, zetap, e_charge, zetac, aasp, a1, self.Rmode, n, Nco))
				if self.rbProfile.get() == 'HET' or self.rbProfile.get() == 'HETUSER':
					E_EDL_HET = (theta*fn.E_EDL_SS_colloid_plate(H2, 1.0, epsilonW, k, kb, T, z, zetap, e_charge, zetahet, a1, a2)
								+fn.E_EDL_SS_RMODE(H, a2, epsilonW, k, kb, T, z, zetap, e_charge, zetahet, aasp, a1, self.Rmode, n, Nco))
					F_EDL_HET = (theta*fn.F_EDL_SS_colloid_plate(H2, 1.0, epsilonW, k, kb, T, z, zetap, e_charge, zetahet, a1, a2)
								+ fn.F_EDL_SS_RMODE(H, a2, epsilonW, k, kb, T, z, zetap, e_charge, zetahet, aasp, a1, self.Rmode, n, Nco))
				# AB rough
				ho = fn.calculation_ho(E_vDW, E_Born, A132, H)
				E_ABL = fn.E_AB_SS_RMODE(H, lambdaAB, aasp, nAB, gammaAB, ho, self.Rmode, a1, a2, Nco)
				F_ABL = fn.F_AB_SS_RMODE(H, lambdaAB, aasp, nAB, gammaAB, ho, self.Rmode, a1, a2, Nco)

		# Sphere - plate geometry
		if self.SP == 1:
			# Interactions independent of coating
			# Hamaker calculation
			if self.cbCOATED.get():
				A132c = aproxA132  # Hamaker depending of VDWmode
			else:
				A132c = A132  # Hamaker calculated from fundamentals

			# Born interaction
			E_Born = fn.E_Born_SP_colloid_plate(H, A132c, sigmaC, a1)
			F_Born = fn.F_Born_SP_colloid_plate(H, A132c, sigmaC, a1)
			# Steric interaction
			E_Ste = fn.E_Ste_SP_colloid_plate(H, lambdaSTE, gammaSTE, aSte)
			F_Ste = fn.F_Ste_SP_colloid_plate(H, lambdaSTE, gammaSTE, aSte)
			# Smooth interaction
			if self.Rmode == 0:
				# Van der Waals interactions
				if self.cbCOATED.get():
					if VDWmode == 1:  # coated colloid - coated collector
						E_vDW = fn.E_vdW_SP_coated_systems(H, a1, lambdavdW, T1, T2, s1A1p2p, s1A12p, s1A1p2, s1A12, VDWmode)
						F_vDW = fn.F_vdW_SP_coated_systems(H, a1, lambdavdW, T1, T2, s1A1p2p, s1A12p, s1A1p2, s1A12, VDWmode)
					elif VDWmode == 2:   # colloid - coated collector
						E_vDW =  fn.E_vdW_SP_coated_systems(H, a1, lambdavdW, T1, T2, 0.0, s2A12p, 0.0 , s2A12, VDWmode)
						F_vDW =  fn.F_vdW_SP_coated_systems(H, a1, lambdavdW, T1, T2, 0.0, s2A12p, 0.0 , s2A12, VDWmode)
					elif VDWmode == 3:  # coated colloid - collector
						E_vDW =  fn.E_vdW_SP_coated_systems(H, a1, lambdavdW, T1, T2, 0.0, 0.0, s3A1p2, s3A12, VDWmode)
						F_vDW =  fn.F_vdW_SP_coated_systems(H, a1, lambdavdW, T1, T2, 0.0, 0.0, s3A1p2, s3A12, VDWmode)
				else: # not coated smooth
					E_vDW = fn.E_vdW_SP_Colloid_Plate(H, A132, a1, lambdavdW)
					F_vDW = fn.F_vdW_SP_colloid_plate(H, A132, a1, lambdavdW)
				# EDL smooth
				E_EDL = fn.E_EDL_SP_colloid_plate(H, 1.0, epsilonW, k, kb, T, z, zetac, e_charge, zetap, a1)
				F_EDL = fn.F_EDL_SP_colloid_plate(H, 1.0, epsilonW, k, kb, T, z, zetac, e_charge, zetap, a1)
				if self.rbProfile.get() == 'HET' or self.rbProfile.get() == 'HETUSER':
					E_EDL_HET = fn.E_EDL_SP_colloid_plate(H, 1.0, epsilonW, k, kb, T, z, zetap, e_charge, zetahet, a1)
					F_EDL_HET = fn.F_EDL_SP_colloid_plate(H, 1.0, epsilonW, k, kb, T, z, zetap, e_charge, zetahet, a1)
				# ABL smooth
				ho = fn.calculation_ho(E_vDW, E_Born, A132, H)  # ho calculation for ABL interaction
				E_ABL = fn.E_AB_SP_colloid_plate(H, lambdaAB, a1, gammaAB, ho)
				F_ABL = fn.F_AB_SP_colloid_plate(H, lambdaAB, a1, gammaAB, ho)

			else: # Rmode1 = Rough Colloid rmode=2 Rough Collector Rmode=3 Rough Colloid and Collector
				#VdW rough
				E_vDW = (fn.E_vdW_SP_Colloid_Plate(H2, A132, a1, lambdavdW)
						+ fn.E_vdW_SP_RMODE(H, n, A132, aasp, a1, lambdavdW, self.Rmode, Nco))
				F_vDW = (fn.F_vdW_SP_colloid_plate(H2, A132, a1, lambdavdW)
						+ fn.F_vdW_SP_RMODE(H, n, A132, aasp, a1, lambdavdW, self.Rmode, Nco))
				# EDL rough
				E_EDL = (theta*fn.E_EDL_SP_colloid_plate(H2, 1, epsilonW, k, kb, T, z, zetap, e_charge, zetac, a1)
						+ fn.E_EDL_SP_RMODE(H, n, epsilonW, k, kb, T, z, zetap, e_charge, zetac, aasp, a1, self.Rmode, Nco))
				F_EDL = (theta*fn.F_EDL_SP_colloid_plate(H2, 1, epsilonW, k, kb, T, z, zetap, e_charge, zetac, a1)
						+ fn.F_EDL_SP_RMODE(H, n, epsilonW, k, kb, T, z, zetap, e_charge, zetac, aasp, a1, self.Rmode, Nco))
				
				if self.rbProfile.get() == 'HET' or self.rbProfile.get() == 'HETUSER':
					E_EDL_HET = (theta*fn.E_EDL_SP_colloid_plate(H2, 1.0, epsilonW, k, kb, T, z, zetap, e_charge, zetahet, a1)
								+fn.E_EDL_SP_RMODE(H, n, epsilonW, k, kb, T, z, zetap, e_charge, zetahet, aasp, a1, self.Rmode, Nco))
					F_EDL_HET = (theta*fn.F_EDL_SP_colloid_plate(H2, 1.0, epsilonW, k, kb, T, z, zetap, e_charge, zetahet, a1)
								+fn.F_EDL_SP_RMODE(H, n, epsilonW, k, kb, T, z, zetap, e_charge, zetahet, aasp, a1, self.Rmode, Nco))
				# ABL rough
				ho = fn.calculation_ho(E_vDW, E_Born, A132, H)  # ho calculation for ABL interaction
				E_ABL = fn.E_AB_SP_RMODE(H, lambdaAB, aasp, nAB, gammaAB, ho, self.Rmode, a1, Nco)
				F_ABL = fn.F_AB_SP_RMODE(H, lambdaAB, aasp, nAB, gammaAB, ho, self.Rmode, a1, Nco)
		
		# remove insignificant values (<abs(10e-30))
		tol = 1e-30
		# Energy
		E_vDW[abs(E_vDW) < tol] = 0
		E_EDL[abs(E_EDL) < tol] = 0
		E_ABL[abs(E_ABL) < tol] = 0
		E_Born[abs(E_Born) < tol] = 0
		E_Ste[abs(E_Ste) < tol] = 0

		if self.rbProfile.get() == 'HET' or self.rbProfile.get() == 'HETUSER':
			E_EDL_HET[abs(E_EDL_HET) < tol] = 0
		
		# Force
		F_vDW[abs(F_vDW) < tol] = 0
		F_EDL[abs(F_EDL) < tol] = 0
		F_ABL[abs(F_ABL) < tol] = 0
		F_Born[abs(F_Born) < tol] = 0
		F_Ste[abs(F_Ste) < tol] = 0
		if self.rbProfile.get() == 'HET' or self.rbProfile.get() == 'HETUSER':
			F_EDL_HET[abs(F_EDL_HET) < tol] = 0

		# Calculate matrix for heterodomain influence
		E_HET_T = np.zeros((len(H), 4))
		F_HET_T = np.zeros((len(H), 4))
		self.E_HET_T = E_HET_T
		self.F_HET_T = F_HET_T

		if self.rbProfile.get() == 'HET' or self.rbProfile.get() == 'HETUSER':
			E_EDL_HET_M = np.zeros((len(H), len(afvector)))
			F_EDL_HET_M = np.zeros((len(H), len(afvector)))

			for i in range(len(afvector)):
				#calculate combine EDL energy and force
				E_EDL_HET_M[:, i] = (1 - afvector[i])*E_EDL + afvector[i]*E_EDL_HET
				F_EDL_HET_M[:, i] = (1 - afvector[i])*F_EDL + afvector[i]*F_EDL_HET
				E_HET_T[:, i] = E_vDW.T + E_EDL_HET_M[:, i] + E_ABL.T + E_Born.T + E_Ste.T
				F_HET_T[:, i] = F_vDW.T + F_EDL_HET_M[:, i] + F_ABL.T + F_Born.T + F_Ste.T
			E_HET_T = E_HET_T * 1/kt
			self.E_HET_T = E_HET_T
			self.F_HET_T = F_HET_T

		'''TOTAL MATRIX CONSTRUCTION'''
		# Energy matrix
		E_total = E_vDW + E_EDL + E_ABL + E_Born + E_Ste
		F_total = F_vDW + F_EDL + F_ABL + F_Born + F_Ste
		EJ = np.array([E_vDW, E_EDL, E_ABL, E_Born, E_Ste, E_total]).T
		self.Ekt = EJ * 1/kt
		# force matrix
		self.F = np.array([F_vDW, F_EDL, F_ABL, F_Born, F_Ste, F_total]).T
		self.H = H
		self.EJ = EJ
		
	def calculate_CS(self):
		"""Calculate coated system parameters"""
		# VDW coated systems
		# coating thickness and Fluid Hamaker constant
		T1 = float(self.var_T1.get()) if not self.var_T1.get()=='N/A' else 'N/A'  # Colloid coated thickness (m)
		T2 = float(self.var_T2.get()) if not self.var_T2.get()=='N/A' else 'N/A'  # Collector coated thickness (m)
		A33 = float(self.var_A33.get())  # Fluid Hamaker Constant (A33) (J)
		# combined Hamaker
		A12 = float(self.var_A12.get())  # Colloid - Collector (A12) (J)
		A12p = float(self.var_A12p.get()) if not self.var_A12p.get()=='N/A' else 'N/A'  # Colloid - Collector Coating (A12p) (J)
		A13 = float(self.var_A13.get())  # Colloid - Fluid (A13) (J)
		A1p2 = float(self.var_A1p2.get()) if not self.var_A1p2.get()=='N/A' else 'N/A'  # Colloid Coating - Collector  (A1p2) (J)
		A1p2p = float(self.var_A1p2p.get()) if not self.var_A1p2p.get()=='N/A' else 'N/A'  # Colloid Coating - Collector Coating (A1p2p) (J)
		A1p3 = float(self.var_A1p3.get()) if not self.var_A1p3.get()=='N/A' else 'N/A'  # Colloid Coating - Fluid  (A1p3) (J)
		A23 = float(self.var_A23.get())  # Collector - Fluid  (A23) (J)
		A2p3 = float(self.var_A2p3.get()) if not self.var_A2p3.get()=='N/A' else 'N/A'  # Collector Coating - Fluid  (A2p3) (J)
		# single materials Hamaker
		A11 = float(self.var_A11.get())  # Colloid Hamaker constant (A11) (J)
		A1p1p = float(self.var_A1p1p.get()) if not self.var_A1p1p.get()=='N/A' else 'N/A'  # Colloid coating Hamaker constant (A1p1p) (J)
		A22 = float(self.var_A22.get())  # Collector Hamaker constant (A22) (J))
		A2p2p = float(self.var_A2p2p.get()) if not self.var_A2p2p.get()=='N/A' else 'N/A'  # Collector coating Hamaker constant (A2p2p) (J)
		# Initialize Hamaker contributions
		s1A1p2p = 'N/A'
		s1A12p = 'N/A'
		s1A1p2 = 'N/A'
		s1A12 = 'N/A'
		s2A12p = 'N/A'
		s2A12 = 'N/A'
		s3A1p2 = 'N/A'
		s3A12 = 'N/A'

		# Coated colloid - Coated collector       
		if self.rbCStype.get()==1:
			# Calculate hamaker constant contributions
			s1A1p2p = A1p2p-A2p3-A1p3+A33
			s1A12p = A12p-A1p2p-A13+A1p3
			s1A1p2 = A1p2-A23-A1p2p+A2p3
			s1A12 = A12-A1p2-A12p+A1p2p
			# Update fields
			self.var_S1A1p2p.set(f'{s1A1p2p:.2e}')
			self.var_S1A12p.set(f'{s1A12p:.2e}')
			self.var_S1A1p2.set(f'{s1A1p2:.2e}')
			self.var_S1A12.set(f'{s1A12:.2e}')

		# colloid - coated collector
		if self.rbCStype.get()==2:
			# Calculate hamaker constant contributions
			s2A12p = A12p-A2p3-A13+A33
			s2A12 = A12-A23-A12p+A33
			# Update fields
			self.var_S2A12p.set(f'{s2A12p:.2e}')
			self.var_S2A12.set(f'{s2A12:.2e}')
			
		# Coated colloid - collector
		if self.rbCStype.get()==3:
			# calculate hamaker constant contribution
			s3A1p2 = A1p2-A23-A1p3+A33
			s3A12 = A12-A1p2-A13+A1p3
			# update fields
			self.var_S3A1p2.set(f'{s3A1p2:.2e}')
			self.var_S3A12.set(f'{s3A12:.2e}')

	def calculate_A12(self):
		if self.cbA12.get():
			# Hamaker single material values
			A11 = float(self.var_A11.get())
			A22 = float(self.var_A22.get())
			# Calculate combined Hamaker constant
			A12 = (A11**0.5)*(A22**0.5)  # Colloid - Collector (A12) (J)
			# Update fields
			self.var_A12.set(f'{A12:.4e}')
		else:
			self.var_A12.set(0.0)

	def calculate_A12p(self):
		if self.cbA12p.get():
			# Hamaker single material values
			A11 = float(self.var_A11.get())
			A2p2p = float(self.var_A2p2p.get())
			# Calculate combined Hamaker constant
			A12p = (A11**0.5)*(A2p2p**0.5)  # Colloid - Collector Coating (A12p) (J)
			# Update fields
			self.var_A12p.set(f'{A12p:.4e}')
		else:
			self.var_A12p.set(0.0)

	def calculate_A13(self):
		if self.cbA13.get():
			# Hamaker single material values
			A11 = float(self.var_A11.get())
			A33 = float(self.var_A33.get())
			# Calculate combined Hamaker constant
			A13 = (A11**0.5)*(A33**0.5)  # Colloid - Fluid (A13) (J)
			# Update fields
			self.var_A13.set(f'{A13:.4e}')
		else:
			self.var_A13.set(0.0)

	def calculate_A1p2(self):
		if self.cbA1p2.get():
			# Hamaker single material values 
			A22 = float(self.var_A22.get())
			A1p1p = float(self.var_A1p1p.get())
			# Calculate combined Hamaker constant
			A1p2 = (A1p1p**0.5)*(A22**0.5)  # Colloid Coating - Collector  (A1p2) (J)
			# Update fields
			self.var_A1p2.set(f'{A1p2:.4e}')
		else:
			self.var_A1p2.set(0.0)

	def calculate_A1p2p(self):
		if self.cbA1p2p.get():
			# Hamaker single material values
			A1p1p = float(self.var_A1p1p.get())
			A2p2p = float(self.var_A2p2p.get())
			# Calculate combined Hamaker constant
			A1p2p = (A1p1p**0.5)*(A2p2p**0.5)  # Colloid Coating - Collector Coating (A1p2p) (J)
			# Update fields
			self.var_A1p2p.set(f'{A1p2p:.4e}')
		else:
			self.var_A1p2p.set(0.0)

	def calculate_A1p3(self):      
		if self.cbA1p3.get():
			# Hamaker single material values
			A1p1p = float(self.var_A1p1p.get())
			A33 = float(self.var_A33.get())
			# Calculate combined Hamaker constant
			A1p3 = (A1p1p**0.5)*(A33**0.5)  # Colloid Coating - Fluid  (A1p3) (J)
			# Update fields
			self.var_A1p3.set(f'{A1p3:.4e}')
		else:
			self.var_A1p3.set(0.0)

	def calculate_A23(self):
		if self.cbA23.get():
			# Hamaker single material values
			A22 = float(self.var_A22.get())
			A33 = float(self.var_A33.get())
			# Calculate combined Hamaker constant
			A23 = (A22**0.5)*(A33**0.5)  # Collector - Fluid  (A23) (J)
			# Update fields
			self.var_A23.set(f'{A23:.4e}')
		else:
			self.var_A23.set(0.0)

	def calculate_A2p3(self):
		if self.cbA2p3.get():
			# Hamaker single material values
			A2p2p = float(self.var_A2p2p.get())
			A33 = float(self.var_A33.get())
			# Calculate combined Hamaker constant
			A2p3 = (A2p2p**0.5)*(A33**0.5)  # Collector Coating - Fluid  (A2p3) (J)
			# Update fields
			self.var_A2p3.set(f'{A2p3:.4e}')
		else:
			self.var_A2p3.set(0.0)
	
	# --------------------------- CALLBACK FUNCTIONS ------------------------------
	def rb1_callback(self):  # Coated Colloid - Coated Collector 
		"""Handles the callback when the 'Coated Colloid - Coated Collector' option is selected."""
		if self.rbCStype.get()==1:
			# Enable single material fields
			self.entry_A1p1p.configure(state=tk.NORMAL)
			self.entry_A2p2p.configure(state=tk.NORMAL)
			self.entry_A1p1p.reset_color()
			self.entry_A2p2p.reset_color()
			# Activate corresponding edit fields coating thickness
			self.entry_T1.configure(state=tk.NORMAL)
			self.entry_T2.configure(state=tk.NORMAL)
			self.entry_T1.reset_color()
			self.entry_T2.reset_color()
			# Activate corresponding combined Hamaker entries
			self.entry_A12.configure(state=tk.NORMAL)
			self.entry_A12p.configure(state=tk.NORMAL)
			self.entry_A13.configure(state=tk.NORMAL)
			self.entry_A1p2.configure(state=tk.NORMAL)
			self.entry_A1p2p.configure(state=tk.NORMAL)
			self.entry_A1p3.configure(state=tk.NORMAL)
			self.entry_A23.configure(state=tk.NORMAL)
			self.entry_A2p3.configure(state=tk.NORMAL)
			self.entry_A12.reset_color()
			self.entry_A12p.reset_color()
			self.entry_A13.reset_color()
			self.entry_A1p2.reset_color()
			self.entry_A1p2p.reset_color()
			self.entry_A1p3.reset_color()
			self.entry_A23.reset_color()
			self.entry_A2p3.reset_color()
			# Activate corresponding combined Hamaker checkboxes
			self.cb_single1.configure(state=tk.NORMAL)
			self.cb_single2.configure(state=tk.NORMAL)
			self.cb_single3.configure(state=tk.NORMAL)
			self.cb_single4.configure(state=tk.NORMAL)
			self.cb_single5.configure(state=tk.NORMAL)
			self.cb_single6.configure(state=tk.NORMAL)
			self.cb_single7.configure(state=tk.NORMAL)
			self.cb_single8.configure(state=tk.NORMAL)
			self.cb_single1.reset_color()
			self.cb_single2.reset_color()
			self.cb_single3.reset_color()
			self.cb_single4.reset_color()
			self.cb_single5.reset_color()
			self.cb_single6.reset_color()
			self.cb_single7.reset_color()
			self.cb_single8.reset_color()
			# Reset values corresponding combined Hamaker entries
			self.var_A12.set(value=0.0)
			self.var_A12p.set(value=0.0)
			self.var_A13.set(value=0.0)
			self.var_A1p2.set(value=0.0)
			self.var_A1p2p.set(value=0.0)
			self.var_A1p3.set(value=0.0)
			self.var_A23.set(value=0.0)
			self.var_A2p3.set(value=0.0)
			# Reset corresponding check boxes combined Hamaker
			self.cbA12.set(False)
			self.cbA12p.set(False)
			self.cbA13.set(False)
			self.cbA1p2.set(False)
			self.cbA1p2p.set(False)
			self.cbA1p3.set(False)
			self.cbA23.set(False)
			self.cbA2p3.set(False)
			# Reset calculate fields in hamaker contributions
			self.var_S1A1p2p.set(value='calculate')
			self.var_S1A12p.set(value='calculate')
			self.var_S1A1p2.set(value='calculate')
			self.var_S1A12.set(value='calculate')
			self.var_S2A12p.set(value='N/A')
			self.var_S2A12.set(value='N/A')
			self.var_S3A1p2.set(value='N/A')
			self.var_S3A12.set(value='N/A')
			# Activate Hamaker constant contribution 
			self.frame_C1.grid(row=1, column=0)
			# Deactivate other panels
			self.frame_C2.grid_forget()
			self.frame_C3.grid_forget()

	def rb2_callback(self):  # Colloid - Coated Collector
		"""Handles the callback when the 'Colloid - Coated Collector' option is selected."""
		if self.rbCStype.get()==2:
			# Deactivate other checkboxes
			# Activate corresponding edit fields coating thickness
			self.entry_T1.configure(state=tk.DISABLED)
			self.entry_T1.configure(fg_color='gray85', text_color='gray')
			self.entry_T2.configure(state=tk.NORMAL)
			self.entry_T2.reset_color()
			# Deactivate corresponding entries
			self.entry_A1p2.configure(state=tk.DISABLED)
			self.entry_A1p2p.configure(state=tk.DISABLED)
			self.entry_A1p3.configure(state=tk.DISABLED)
			self.entry_A1p2.configure(fg_color='gray85', text_color='gray')
			self.entry_A1p2p.configure(fg_color='gray85', text_color='gray')
			self.entry_A1p3.configure(fg_color='gray85', text_color='gray')
			# Activate corresponding combined Hamaker entries
			self.entry_A12.configure(state=tk.NORMAL)
			self.entry_A12p.configure(state=tk.NORMAL)
			self.entry_A13.configure(state=tk.NORMAL)
			self.entry_A23.configure(state=tk.NORMAL)
			self.entry_A2p3.configure(state=tk.NORMAL)
			self.entry_A12.reset_color()
			self.entry_A12p.reset_color()
			self.entry_A13.reset_color()
			self.entry_A23.reset_color()
			self.entry_A2p3.reset_color()
			# Reset values
			self.var_A1p2.set(value='N/A')
			self.var_A1p2p.set(value='N/A')
			self.var_A1p3.set(value='N/A')
			self.var_A12.set(value=0.0)
			self.var_A12p.set(value=0.0)
			self.var_A13.set(value=0.0)
			self.var_A23.set(value=0.0)
			self.var_A2p3.set(value=0.0)
			# Deactivate corresponding cb fields and values
			self.cb_single4.configure(state=tk.DISABLED)
			self.cb_single5.configure(state=tk.DISABLED)
			self.cb_single6.configure(state=tk.DISABLED)
			self.cb_single4.configure(border_color='gray64')
			self.cb_single5.configure(border_color='gray64')
			self.cb_single6.configure(border_color='gray64')
			# Activate corresponding combined Hamaker checkboxes
			self.cb_single1.configure(state=tk.NORMAL)
			self.cb_single2.configure(state=tk.NORMAL)
			self.cb_single3.configure(state=tk.NORMAL)
			self.cb_single7.configure(state=tk.NORMAL)
			self.cb_single8.configure(state=tk.NORMAL)
			self.cb_single1.reset_color()
			self.cb_single2.reset_color()
			self.cb_single3.reset_color()
			self.cb_single7.reset_color()
			self.cb_single8.reset_color()
			# Reset calculate fields in hamaker contributions
			self.var_S1A1p2p.set(value='N/A')
			self.var_S1A12p.set(value='N/A')
			self.var_S1A1p2.set(value='N/A')
			self.var_S1A12.set(value='N/A')
			self.var_S2A12p.set(value='calculate')
			self.var_S2A12.set(value='calculate')
			self.var_S3A1p2.set(value='N/A')
			self.var_S3A12.set(value='N/A')
			# Reset values of corresponding checkboxes
			self.cbA12.set(False)
			self.cbA12p.set(False)
			self.cbA13.set(False)
			self.cbA1p2.set(False)
			self.cbA1p2p.set(False)
			self.cbA1p3.set(False)
			self.cbA23.set(False)
			self.cbA2p3.set(False)
			# Disable corresponding single material
			self.entry_A1p1p.configure(state=tk.DISABLED)
			self.entry_A1p1p.configure(fg_color='gray85', text_color='gray')
			# Enable corresponding single material
			self.entry_A2p2p.configure(state=tk.NORMAL)
			self.entry_A2p2p.reset_color()
			# Activate Hamaker constant contribution 
			self.frame_C2.grid(row=1, column=0)
			# Deactivate other panels
			self.frame_C1.grid_forget()
			self.frame_C3.grid_forget()

	def rb3_callback(self):  # Coated Colloid - Collector
		"""Handles the callback when the 'Coated Colloid - Collector' option is selected."""
		if 	self.rbCStype.get()==3:
			# Activate corresponding edit fields coating thickness
			self.entry_T1.configure(state=tk.NORMAL)
			self.entry_T1.reset_color()
			self.entry_T2.configure(state=tk.DISABLED)
			self.entry_T2.configure(fg_color='gray85', text_color='gray')
			# Deactivate corresponding entries
			self.entry_A12p.configure(state=tk.DISABLED)
			self.entry_A1p2p.configure(state=tk.DISABLED)
			self.entry_A2p3.configure(state=tk.DISABLED)
			self.entry_A12p.configure(fg_color='gray85', text_color='gray')
			self.entry_A1p2p.configure(fg_color='gray85', text_color='gray')
			self.entry_A2p3.configure(fg_color='gray85', text_color='gray')
			# Activate corresponding combined Hamaker entries
			self.entry_A12.configure(state=tk.NORMAL)
			self.entry_A13.configure(state=tk.NORMAL)
			self.entry_A1p2.configure(state=tk.NORMAL)
			self.entry_A1p3.configure(state=tk.NORMAL) 
			self.entry_A23.configure(state=tk.NORMAL)
			self.entry_A12.reset_color()
			self.entry_A13.reset_color()
			self.entry_A1p2.reset_color()
			self.entry_A1p3.reset_color() 
			self.entry_A23.reset_color()
			# Reset values
			self.var_A12p.set(value='N/A')
			self.var_A1p2p.set(value='N/A')
			self.var_A2p3.set(value='N/A')
			self.var_A12.set(value=0.0)
			self.var_A13.set(value=0.0)
			self.var_A1p2.set(value=0.0)
			self.var_A1p3.set(value=0.0)
			self.var_A23.set(value=0.0)
			# Activate corresponding check boxes combined Hamaker
			self.cb_single1.configure(state=tk.NORMAL)
			self.cb_single3.configure(state=tk.NORMAL)
			self.cb_single4.configure(state=tk.NORMAL)
			self.cb_single6.configure(state=tk.NORMAL)
			self.cb_single7.configure(state=tk.NORMAL)
			self.cb_single1.reset_color()
			self.cb_single3.reset_color()
			self.cb_single4.reset_color()
			self.cb_single6.reset_color()
			self.cb_single7.reset_color()
			# Deactivate corresponding check boxes combined Hamaker and values
			self.cb_single2.configure(state=tk.DISABLED)
			self.cb_single5.configure(state=tk.DISABLED)
			self.cb_single8.configure(state=tk.DISABLED)
			self.cb_single2.configure(border_color='gray64')
			self.cb_single5.configure(border_color='gray64')
			self.cb_single8.configure(border_color='gray64')
			# Reset calculate fields in hamaker contributions
			self.var_S1A1p2p.set(value='N/A')
			self.var_S1A12p.set(value='N/A')
			self.var_S1A1p2.set(value='N/A')
			self.var_S1A12.set(value='N/A')
			self.var_S2A12p.set(value='N/A')
			self.var_S2A12.set(value='N/A')
			self.var_S3A1p2.set(value='calculate')
			self.var_S3A12.set(value='calculate')
			# Reset values of corresponding checkboxes
			self.cbA12.set(False)
			self.cbA12p.set(False)
			self.cbA13.set(False)
			self.cbA1p2.set(False)
			self.cbA1p2p.set(False)
			self.cbA1p3.set(False)
			self.cbA23.set(False)
			self.cbA2p3.set(False)
			# Disable corresponding single material
			self.entry_A2p2p.configure(state=tk.DISABLED)
			# enable corresponding single material
			self.entry_A1p1p.configure(state=tk.NORMAL)
			# Activate Hamaker constant contribution 
			self.frame_C3.grid(row=1, column=0)
			# Deactivate other panels
			self.frame_C1.grid_forget()
			self.frame_C2.grid_forget()

	def mean_callback(self):
		"""Handles the callback when the mean field approach is selected."""
		# Deactivate entries
		self.entry_zhet.configure(state=tk.DISABLED)  # if state else tk.NORMAL
		self.entry_rhet1USER.configure(state=tk.DISABLED)  # if state else tk.NORMAL
		self.entry_rhet2USER.configure(state=tk.DISABLED)  # if state else tk.NORMAL
		self.entry_rhet3USER.configure(state=tk.DISABLED)  # if state else tk.NORMAL
		self.entry_rhet4USER.configure(state=tk.DISABLED)  # if state else tk.NORMAL
		# Reset the user-defined heterodomain radii values to 'calculate'
		self.var_rhet1USER.set('calculate')
		self.var_rhet2USER.set('calculate')
		self.var_rhet3USER.set('calculate')
		self.var_rhet4USER.set('calculate')
		self.var_rhet1.set('calculate')
		self.var_rhet2.set('calculate')
		self.var_rhet3.set('calculate')
		self.var_rhet4.set('calculate')

	def HET_callback(self):
		"""Handles the callback when the heterodomain approach is selected."""
		# Enable the input field for heterodomain zeta potential
		self.entry_zhet.configure(state=tk.NORMAL)  # if state else tk.DISABLED
		# Disable the input fields for user-defined heterodomain radii
		self.entry_rhet1USER.configure(state=tk.DISABLED)  # if state else tk.NORMAL
		self.entry_rhet2USER.configure(state=tk.DISABLED)  # if state else tk.NORMAL
		self.entry_rhet3USER.configure(state=tk.DISABLED)  # if state else tk.NORMAL
		self.entry_rhet4USER.configure(state=tk.DISABLED)  # if state else tk.NORMAL
		# Reset the user-defined heterodomain radii values to 'calculate'
		self.var_rhet1USER.set('calculate')
		self.var_rhet2USER.set('calculate')
		self.var_rhet3USER.set('calculate')
		self.var_rhet4USER.set('calculate')

	def  HETUSER_callback(self):
		"""Callback to handle the user-defined heterodomain radii for the heterodomain profile."""
		# Activate o deactivate entries
		self.entry_rhet1USER.configure(state=tk.NORMAL) # if state else tk.DISABLED
		self.entry_rhet2USER.configure(state=tk.NORMAL) # if state else tk.DISABLED
		self.entry_rhet3USER.configure(state=tk.NORMAL) # if state else tk.DISABLED
		self.entry_rhet4USER.configure(state=tk.NORMAL) # if state else tk.DISABLED
		# Enable the input field for heterodomain zeta potential
		self.entry_zhet.configure(state=tk.NORMAL)  # if state else tk.DISABLED
		# Set entry values
		self.var_rhet1USER.set(f'{3.3e-08:.2e}')
		self.var_rhet2USER.set(f'{6.6e-08:.2e}')
		self.var_rhet3USER.set(f'{1.32e-07:.2e}')
		self.var_rhet4USER.set(f'{2.64e-07:.2e}')
		# Reset the calculated heterodomain radii values to 'calculate'
		self.var_rhet1.set('calculate')
		self.var_rhet2.set('calculate')
		self.var_rhet3.set('calculate')
		self.var_rhet4.set('calculate')

	def Rmode_callback(self):
		"""Callback to handle the selection of the roughness mode."""
		# Check if the roughness mode is set to 'Smooth'
		if self.rbRmode.get()==0:
			# Set asperity height to zero and reset the color of the entry field
			self.var_aasp.set(value=0)
			self.entry_aasp.reset_color()
		
		# Check if the roughness mode is set to 'Rough Colloid', 'Rough Collector', or 'Rough Colloid and Collector'
		if self.rbRmode.get()==1 or self.rbRmode.get()==2 or self.rbRmode.get()==3:
			# Deactivate coated system
			if self.cbCOATED.get():
				self.cbCOATED.set(value=False)
				self.cs_window.destroy()
				messagebox.showwarning(title='Notice', message='Roughness not applicable to coated systems. Reset to uncoated system')
				self.entry_A132.configure(state=tk.NORMAL)
				self.var_A132.set(value=7.17e-21)
			# Ensure the asperity height is at least 5 nm (minimum allowed value)
			if float(self.var_aasp.get()) < 5.0e-9:
				messagebox.showinfo(title='Notice', message='Asperity height was set at zero, changed by default to 10 nm.  Minimum value allowed is 5 nm')
				self.entry_aasp.configure(fg_color=('burlywood1', '#833e5b'))
				self.var_aasp.set(value=1.0e-8)

	def aasp_callback(self, event):
		"""Callback function to handle changes in the asperity height value."""
		aasp = float(self.var_aasp.get())
		if aasp <= 0:
			self.var_aasp.set(value=0)
			self.rbRmode.set(value=0)
		else: 
			if self.rbRmode.get()==0:
				self.rbRmode.set(value=1)
				if self.cbCOATED.get():
					messagebox.showwarning(title='Notice', message='Roughness not supported for coated system. System reset')
				else:
					messagebox.showwarning(title='Notice', message='Type of roughness reset to rough collector by default. Select type of rough system')
			if aasp<5.0e-9:
				messagebox.showinfo(title='Notice', message='Minimum asperity height allowed is 5 nm. Value reset')
				self.var_aasp.set(value=5.0e-9)
				self.entry_aasp.configure(fg_color=('burlywood1', '#833e5b'))
			if aasp>1.0e-5:
				messagebox.showinfo(title='Notice', message='Roughness algorithm designed for <10 µm asperity height,for which generation of new impinging surfaces is limited')
				self.var_aasp.set(value=1.0e-5)
				self.entry_aasp.configure(fg_color=('burlywood1', '#833e5b'))
			if self.cbCOATED.get():
				self.cbCOATED.set(value=False)

	def a2_callback(self):
		"""Callback function to enable or disable the entry field for the collector radius (a2)"""
		# If sphere-sphere (SS) mode is selected
		if self.rbSS.get():
			self.entry_a2.configure(state=tk.NORMAL)
			self.var_a2.set(value=2.55e-4)
		else:
			self.entry_a2.configure(state=tk.DISABLED)
			self.var_a2.set(value='N/A')

	def CSclosing_callback(self):
		"""Callback function for handling the closing of the 'Coated System' window."""
		# Retrieve the values of coating parameters
		c1=self.var_S1A1p2p.get()
		c2=self.var_S2A12p.get()
		c3=self.var_S3A1p2.get()
		## Check if the calculate button was pressed
		if (c1=='calculate' or c1=='N/A') and (c2=='calculate' or c2=='N/A') and (c3=='calculate' or c3=='N/A'):
			self.cs_window.destroy()
			self.cbCOATED.set(value=False)
			messagebox.showwarning(title='Notice', message='No coating parameters calculated. Reset to uncoated system.')
			self.entry_A132.configure(state=tk.NORMAL)
			self.var_A132.set(value=7.17e-21)
		else:
			self.cs_window.destroy()
			self.cbCOATED.set(value=True)
		# If the system is reset to uncoated, close the coated system window completely
		if self.cbCOATED.get()==False:
			self.close_window_CS()

	def savebutton_callback(self):
		""" Callback function for handling the save operation to an Excel file."""
		
		try:
			 # Open a file dialog to save the Excel file
			file = filedialog.asksaveasfile(mode='wb', initialfile='output_xDLVO', defaultextension='.xlsx', filetypes=[("Excel file (*.xlsx)", "*.xlsx")])
			if file:
				# Set the heterogeneity flag based on the profile selected
				self.cbHET = tk.BooleanVar(value=False)
				self.cbHETUSER = tk.BooleanVar(value=False)
				if self.rbProfile.get() == 'HET':
					self.cbHET.set(True)
					self.cbHETUSER.set(False)

				if self.rbProfile.get() == 'HETUSER':
					self.cbHET.set(False)
					self.cbHETUSER.set(True)

				# Gather all parameters to be saved in the Excel file
				par_cell = fn.fpar_out_xDLVO(
				# input parameters
				self.var_a1, self.var_a2, self.var_IS, self.var_z1, self.var_z2, self.var_aasp, self.var_sigmac, self.var_T,
				self.var_lambdaVDW, self.var_lambdaAB, self.var_lambdaSTE, self.var_gammaSTE, self.var_epsilonR, self.var_z, self.var_A132,
				self.SP, self.SS, self.Rmode,
				#  vdw from fundamentals
				self.var_ve, self.var_e1, self.var_n1, self.var_e2, self.var_n2, self.var_e3, self.var_n3, self.var_A132_result,
				# vdw coated systems
				self.var_T1, self.var_T2, self.var_A33,  # coating thickness and fluid Hamaker
				self.var_A12, self.var_A12p, self.var_A13, self.var_A1p2, self.var_A1p2p, self.var_A1p3, self.var_A23, self.var_A2p3,  # combined Hamaker
				self.cbA12, self.cbA12p, self.cbA13, self.cbA1p2, self.cbA1p2p, self.cbA1p3, self.cbA23, self.cbA2p3,  # combined Hamaker calculated
				self.var_A11, self.var_A1p1p, self.var_A22, self.var_A2p2p,  # single materials Hamaker
				self.var_S1A1p2p, self.var_S1A12p, self.var_S1A1p2, self.var_S1A12, self.var_S2A12p, self.var_S2A12, self.var_S3A1p2, self.var_S3A12,  # hamaker constributions
				# acid-base energy fundamentals
				self.var_g1pos, self.var_g1neg, self.var_g2pos, self.var_g2neg, self.var_g3pos, self.var_g3neg, self.var_AB_result, self.var_gammaAB,
				# work of adhesion fundamentals
				self.var_g1LW, self.var_g2LW, self.var_g3LW, self.var_INDgammaAB, self.var_W132_result, self.var_W132,
				# aconr for steric fundamentals
				self.var_E1, self.var_E2, self.var_v1, self.var_v2, self.var_INDW132, self.var_Kint_result, self.var_aCont_result, self.var_acont,
				# checkboxes
				self.cbCOATED, self.cbA132, self.cbgammaAB, self.cbW132, self.cbacont,
				self.cb1, self.cb2, self.cb3,
				# heterogeneity
				self.cbHET, self.cbHETUSER, self.var_zetahet, self.var_rZOI)

				headlines_energy = ['H(m)', 'E_van_der_Waals', 'E_EDL', 'E_AB', 'E_Born', 'E_Steric', 'E_total']
				headlines_force = ['H(m)',  'F_van_der_Waals', 'F_EDL', 'F_AB', 'F_Born', 'F_Steric', 'F_total']

				fn.create_excel(file, self.H, self.EJ, self.Ekt, self.F, self.cbHET,self.cbHETUSER, self.E_HET_T, self.F_HET_T, headlines_energy, headlines_force, self.rhetv, self.afvector, par_cell)
				fn.create_csv(file, self.H, self.EJ, self.Ekt, self.F, self.cbHET,self.cbHETUSER, self.E_HET_T, self.F_HET_T, headlines_energy, headlines_force, self.rhetv, self.afvector, par_cell)
				messagebox.showinfo(title='Notice', message='The Excel file was successfully created')
				# Close the file after writing
				file.close()
		except PermissionError:
			# Handle the case where the user doesn't have permission to write to the file
			messagebox.showerror("Error", "Unable to create the file: Permission denied.")
		except FileNotFoundError:
			# Handle the case where the file path is not found
			messagebox.showerror("Error", "Path not found to create the file.")
		except Exception as e:
			# Handle any other exceptions that might occur during file creation
			messagebox.showerror("Error", f"An error occurred while creating the file: {str(e)}")

	def upload_callback(self):
		"""Callback function to upload an Excel file containing input parameters and update the GUI values accordingly."""
		# Open dialog box to search for the required file and recover its route
		route = filedialog.askopenfilename(initialdir='/', title='Select input file', filetypes=(('Excel files', '*.xls;*.xlsx'), ('csv', '*.csv')))
		try:
			if not '.csv' in route:
				input_dataframe = pd.read_excel(route, sheet_name='Input_Parameters', index_col=0)
			else: 
				input_dataframe = pd.read_csv(route, index_col=0)
			# Name the DataFrame columns
			input_dataframe.columns = [' ', '.1', '.2']
			input_dataframe[' '] = pd.to_numeric(input_dataframe[' '], errors='coerce')
			#upload GUI values according to the input
			if int(input_dataframe.loc['Sphere-Sphere', ' ']) == 1:
				self.rbSS.set(1)
			else:
				self.rbSS.set(0) 

			if int(input_dataframe.loc['Roughness_mode(0_smooth)(1_rough_collector)(2_rough_colloid)(3_rough_colloid_collector)', ' ']) == 0:
				self.rbRmode.set(value=0)
			elif int(input_dataframe.loc['Roughness_mode(0_smooth)(1_rough_collector)(2_rough_colloid)(3_rough_colloid_collector)', ' ']) == 1:
				self.rbRmode.set(value=1)
			elif int(input_dataframe.loc['Roughness_mode(0_smooth)(1_rough_collector)(2_rough_colloid)(3_rough_colloid_collector)', ' ']) == 2:
				self.rbRmode.set(value=2)
			elif int(input_dataframe.loc['Roughness_mode(0_smooth)(1_rough_collector)(2_rough_colloid)(3_rough_colloid_collector)', ' ']) == 3:
				self.rbRmode.set(value=3)
			# Main_DLVO_Parameters
			self.var_T.set(value=input_dataframe.loc['Temperature(K)', ' '])
			self.var_IS.set(value=input_dataframe.loc['Ionic_strenght(mol/m3)', ' '])
			self.var_a1.set(value=input_dataframe.loc['Colloid_radius(m)', ' '])
			self.var_a2.set(value=input_dataframe.loc['Collector_radius(m)', ' '])
			self.var_z1.set(value=input_dataframe.loc['Colloid_zeta_potential(V)', ' '])
			self.var_z2.set(value=input_dataframe.loc['Collector_zeta_potential(V)', ' '])
			self.var_z.set(value=input_dataframe.loc['Valence_of_the_symmetric_electrolyte(-)', ' '])
			self.var_epsilonR.set(value=input_dataframe.loc['Relativity_permitivity_of_water(-)', ' '])
			self.var_lambdaVDW.set(value=input_dataframe.loc['vdW_characteristic_wavelength(m)', ' '])
			self.var_sigmac.set(value=input_dataframe.loc['Born_collision_diameter(m)', ' '])
			# Extended_DLVO_Parameters
			self.var_lambdaAB.set(value=input_dataframe.loc['Lewis_acid-base_decay_length(m)', ' '])
			self.var_lambdaSTE.set(value=input_dataframe.loc['Steric_decay_length(m)', ' '])
			self.var_gammaSTE.set(value=input_dataframe.loc['Steric_energy_at_minimum_separation_distance(J/m2)', ' '])
			self.var_aasp.set(value=input_dataframe.loc['Asperity_height_above_mean_surface(m)', ' '])
			# Van der Waals
			self.cbA132.set(value=bool(int(input_dataframe.iloc[25, 2])))
			self.cA132 = input_dataframe.iloc[25, 0]
			self.var_A132.set(value=input_dataframe.iloc[25, 0])
			if self.cbA132.get():
				self.open_window_A132()
				self.var_ve.set(value=input_dataframe.loc['Main_electronic_absorption_frequency(s-1)', ' '])
				self.var_e1.set(value=input_dataframe.loc['Colloid_dielectric_constant(-)', ' '])
				self.var_n1.set(value=input_dataframe.loc['Colloid_refractive_index(-)', ' '])
				self.var_e2.set(value=input_dataframe.loc['Collector_dielectric_constant(-)', ' '])
				self.var_n2.set(value=input_dataframe.loc['Collector_refractive_index(-)', ' '])
				self.var_e3.set(value=input_dataframe.loc['Fluid_dielectric_constant(-)', ' '])
				self.var_n3.set(value=input_dataframe.loc['Fluid_refractive_index(-)', ' '])
				self.var_A132_result.set(value=input_dataframe.iloc[47,0])
			else:
				if self.window_A132 is not None:
					self.window_A132.destroy()
					self.entry_A132.reset_color()
			# Acid Base
			self.cbgammaAB.set(value=bool(int(input_dataframe.iloc[28, 2])))
			self.var_gammaAB.set(value=input_dataframe.iloc[28, 0])
			self.cgammaAB = input_dataframe.iloc[28, 0]
			if self.cbgammaAB.get():
				self.open_window_AB()
				self.var_g1pos.set(value=input_dataframe.loc['Colloid_electron_acceptor(J/m2)', ' '])
				self.var_g1neg.set(value=input_dataframe.loc['Colloid_electron_donor(J/m2)', ' '])
				self.var_g2pos.set(value=input_dataframe.loc['Collector_electron_acceptor(J/m2)', ' '])
				self.var_g2neg.set(value=input_dataframe.loc['Collector_electron_donor(J/m2)', ' '])
				self.var_g3pos.set(value=input_dataframe.loc['Fluid_electron_acceptor(J/m2)', ' '])
				self.var_g3neg.set(value=input_dataframe.loc['Fluid_electron_donor(J/m2)', ' '])
				self.var_AB_result.set(value=input_dataframe.iloc[56, 0])
			else:
				if self.window_AB is not None:
					self.window_AB.destroy()
					self.entry_AB.reset_color()
			# Work of adhesion
			self.cbW132.set(value=bool(int(input_dataframe.iloc[31, 2])))
			self.var_W132.set(value=input_dataframe.iloc[31, 0])
			self.cW132 = input_dataframe.iloc[31, 0]
			if self.cbW132.get():
				self.open_window_W132()
				self.var_g1LW.set(value=input_dataframe.loc['Colloid_van_der_Waals_free_energy(J/m2)', ' '])
				self.var_g2LW.set(value=input_dataframe.loc['Collector_van_der_Waals_free_energy(J/m2)', ' '])
				self.var_g3LW.set(value=input_dataframe.loc['Fluid_van_der_Waals_free_energy(J/m2)', ' '])
				self.var_INDgammaAB.set(value=input_dataframe.iloc[62,0])
				self.var_W132_result.set(value=input_dataframe.iloc[63, 0])
			else:
				if self.window_W132 is not None:
					self.window_W132.destroy()
					self.entry_W132.reset_color()
			# Contact radius
			self.cbacont.set(value=bool(int(input_dataframe.iloc[34, 2])))
			self.var_acont.set(value=input_dataframe.iloc[34, 0])
			self.cacont = input_dataframe.iloc[34, 0]
			if self.cbacont.get():
				self.open_window_acont()
				self.var_E1.set(value=input_dataframe.iloc[66, 0])
				self.var_E2.set(value=input_dataframe.iloc[67, 0])
				self.var_v1.set(value=input_dataframe.iloc[68, 0])
				self.var_v2.set(value=input_dataframe.iloc[69, 0])
				self.var_INDW132.set(value=input_dataframe.iloc[70, 0])
				self.var_Kint_result.set(value=input_dataframe.iloc[71, 0])
				self.var_aCont_result.set(value=input_dataframe.iloc[72, 0])
			else: 
				if self.window_acont is not None:
					self.window_acont.destroy()
					self.entry_acont.reset_color()
			# Coated system
			self.cbCOATED.set(value=bool(int(input_dataframe.loc['Coated_system(0=uncoated)(1=coated,see_end_of_sheet)', ' '])))
			if self.cbCOATED.get():	
				if self.cs_window is not None:
					self.cs_window.destroy()
				self.open_window_CS()
				# Type of coated system
				if int(input_dataframe.iloc[78, 0]) == 1:
					self.rbCStype.set(value=1)
				elif int(input_dataframe.iloc[79, 0]) == 1:
					self.rbCStype.set(value=2)
				elif int(input_dataframe.iloc[80, 0]) == 1: 
					self.rbCStype.set(value=3)
				# Coating thickness and fluid Hamaker constant
				self.var_T1.set(value=input_dataframe.iloc[83, 0])
				self.var_T2.set(value=input_dataframe.iloc[84, 0])
				self.var_A33.set(value=input_dataframe.iloc[85, 0])
				# Hamaker constants single material values
				self.var_A11.set(value=input_dataframe.iloc[98, 0])
				self.var_A1p1p.set(value=input_dataframe.iloc[99, 0])
				self.var_A22.set(value=input_dataframe.iloc[100, 0])
				self.var_A2p2p.set(value=input_dataframe.iloc[101, 0])
				# Combined Hamaker constant 
				self.var_A12.set(value=input_dataframe.iloc[88, 0])
				self.var_A12p.set(value=input_dataframe.iloc[89, 0])
				self.var_A13.set(value=input_dataframe.iloc[90, 0])
				self.var_A1p2.set(value=input_dataframe.iloc[91, 0])
				self.var_A1p2p.set(value=input_dataframe.iloc[92, 0])
				self.var_A1p3.set(value=input_dataframe.iloc[93, 0])
				self.var_A23.set(value=input_dataframe.iloc[94, 0])
				self.var_A2p3.set(value=input_dataframe.iloc[95, 0])

				self.cbA12.set(value=bool(int(input_dataframe.iloc[88, 2])))
				self.cbA12p.set(value=bool(int(input_dataframe.iloc[89, 2])))
				self.cbA13.set(value=bool(int(input_dataframe.iloc[90, 2])))
				self.cbA1p2.set(value=bool(int(input_dataframe.iloc[91, 2])))
				self.cbA1p2p.set(value=bool(int(input_dataframe.iloc[92, 2])))
				self.cbA1p3.set(value=bool(int(input_dataframe.iloc[93, 2])))
				self.cbA23.set(value=bool(int(input_dataframe.iloc[94, 2])))
				self.cbA2p3.set(value=bool(int(input_dataframe.iloc[95, 2])))
				#Hamaker constant contributions
				# Coated colloid - coated collector
				if self.rbCStype.get() == 1:
					self.var_S1A1p2p.set(value=input_dataframe.iloc[107, 0])
					self.var_S1A12p.set(value=input_dataframe.iloc[108, 0])
					self.var_S1A1p2.set(value=input_dataframe.iloc[109, 0])
					self.var_S1A12.set(value=input_dataframe.iloc[110,  0])
				# Colloid - coated collector
				elif self.rbCStype.get() == 2:
					self.rb2_callback()
					self.var_S2A12p.set(value=input_dataframe.iloc[113, 0])
					self.var_S2A12.set(value=input_dataframe.iloc[114, 0])
				# Coated colloid - collector
				elif self.rbCStype.get() == 3:
					self.rb3_callback()
					self.var_S3A1p2.set(value=input_dataframe.iloc[117, 0])
					self.var_S3A12.set(value=input_dataframe.iloc[118, 0])
			else:
				if self.cs_window is not None:
					self.cs_window.destroy()	
			# Profiles
			if int(input_dataframe.iloc[121, 0]) == 1: 
				self.rbProfile.set(value='HET')
			elif int(input_dataframe.iloc[122, 0]) == 1: 
				self.rbProfile.set(value='HETUSER')
				messagebox.showwarning(title='Warning', message='Not enough data for user-specified heterodomains')
			else:
				self.rbProfile.set(value='MEAN')
			
			# Set Zone of Influence radius
			self.var_rZOI.set(value=input_dataframe.loc['rZOI_zone_of_influence_radius(m)', ' '])
		
		except FileNotFoundError as e:
			messagebox.showerror("Error", f"File not found: {e}")
		return route

	def calculateButtonState_callback(self):
		""" Callback to enable or disable the 'Calculate Profiles' button based on the state of certain variables."""
		variables = [
			self.var_A132_result.get(), 
			self.var_AB_result.get(), 
			self.var_W132_result.get(), 
			self.var_aCont_result.get(), 
			   self.var_S1A1p2p.get(), 
			   self.var_S2A12p.get(), 
			   self.var_S3A1p2.get()
			   ]
		
		if any(var=='calculate' for var in variables):
			self.button_calculate_profiles.configure(state=tk.DISABLED)
		else:
			self.button_calculate_profiles.configure(state=tk.NORMAL)

# Create the GUI
App = GUI('PartiSuite xDLVO v1.0',(915,660))  
  