## IMPORT LIBRARIES
import customtkinter as ctk
import tkinter as tk  
import numpy as np
import matplotlib.pyplot as plt 
import pandas as pd
from tkinter import filedialog
import matplotlib.ticker as ticker
from tkinter import messagebox


# Tooltip creation
class ToolTip:
    def __init__(self, widget, text = "tooltip"):
        self.widget = widget
        self.text = text
        self.tooltip_window = None
        self.widget.bind("<Enter>", self.show_tooltip)
        self.widget.bind("<Leave>", self.hide_tooltip)

    def show_tooltip(self, event = None):
        if self.tooltip_window or not self.text:
            return
        x, y, _, _ = self.widget.bbox("insert")
        x += self.widget.winfo_rootx() + 30
        y += self.widget.winfo_rooty() + 30

        self.tooltip_window = tw = tk.Toplevel(self.widget)
        tw.wm_overrideredirect(True)
        tw.wm_geometry(f"+{x}+{y}")
        label = tk.Label(
            tw, text = self.text, justify = "left",
            background = "#FFFFE0", relief = "solid", borderwidth = 1,
            font = ("Arial", 10, "normal")
        )
        label.pack(ipadx = 1)

    def hide_tooltip(self, event = None):
        tw = self.tooltip_window
        if tw:
            tw.destroy()
            self.tooltip_window = None

## GLOBAL CONSTANTS   
kB = 1.381e-23        # Boltzmann´s constant [J/K]
g = 9.806             # gravitacional acceleration contant [m/s2]
Autors = ["Rajogapalan and Tien, 1976", "Ma, Pedel, Fife and Johnson, 2015", "Tufenkji and Elimelech, 2004", "Nelson and Ginn, 2011",
         "Long and Hilpert, 2011"]  
                                                            
## ==================================================================================================

## SET RANGE OF COLLECTOR DIAMETER (mm)
def set_range():
    
    global boton_evaluate_range1
    # Active set range frame
    if check_var.get() == 1:                                                   
        color_inicial = "white"
        entry_Ns.configure(state = "normal", fg_color = color_inicial)
        entry_Lv.configure(state = "normal", fg_color = color_inicial)
        entry_Uv.configure(state = "normal", fg_color = color_inicial)
        entry_step.configure(state = "normal")

        # Change of title 
        if Parameter is not None:
            Parameter.destroy()
        Parameter1 = ctk.CTkLabel(frame_constante4, text = "Collector diameter (mm)", font = ("Arial", 14, "bold"))
        Parameter1.grid(row = 1, column = 0, columnspan = 4, sticky = 'w', padx = 5)

        # Warning message 
        lv = float(var_dp.get())*0.5
        uv = float(var_dp.get())*1.5
        ns = 10
        try:
            if lv < 0.01:
                messagebox.showwarning("Warning", "Collector diameter value recommended between\n0.01 - 10 mm")
                lv = 0.01
                var_Lv.set(f"{lv:.2f}")
            else:
                var_Lv.set(f"{lv:.2f}")

            if uv > 10:
                messagebox.showwarning("Warning", "Collector diameter value recommended between\n0.01 - 10 mm")
                uv = 10
                var_Uv.set(f"{uv:.2f}")
            else:
                var_Uv.set(f"{uv:.2f}")

            step1 = (uv - lv)/(ns - 1)
            var_step.set(f"{step1:.5f}")
            var_Ns.set(f"{ns}")

        except ValueError:
            pass

        # Step update function
        def update_step1():

            try:
                lv = float(var_Lv.get())
                uv = float(var_Uv.get())
                ns = int(var_Ns.get())
                if ns > 1:
                    step = (uv - lv)/(ns - 1)
                    var_step.set(f"{step:.5f}")
                    x1 = np.linspace(lv, uv, ns)
                    return x1
            except ValueError:
                pass
            
        var_Lv.trace_add("write", lambda *args: update_step1())
        var_Uv.trace_add("write", lambda *args: update_step1())
        var_Ns.trace_add("write", lambda *args: update_step1())
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB")

        # Graphical update function
        def update_graph1():

            plt.close("all")
            dc = float(var_dc.get())*(1/1000)*(1/1000)   # Colloid diameter (um) a (m)
            U = float(var_U.get())*(1/24)*(1/3600)       # Pore water velocity (m/day) a (m/s)
            pc = float(var_pc.get())                     # Colloid density (kg/m3)
            pf = float(var_pf.get())                     # Fluid density (kg/m3)
            uf = float(var_uf.get())                     # Fluid viscosity (kg m/s)
            T = float(var_T.get())                       # Temperature (K)
            H = float(var_H.get())                       # Mamaker constant(J)
            theta = float(var_theta.get())               # Porosity
            Ui = U*theta

            x1 = update_step1()  
            dp = x1*(1/1000) 
            gamma = (1 - theta)**(1/3)              
            As = (2*(1 - (gamma**5)))/(2 - (3*gamma) + (3*(gamma**5)) - (2*(gamma**6)))
            Kw = (5*(1 - (gamma**3)))/(5 - (9*gamma) + (5*(gamma**3)) - (1*(gamma**6)))
            D = (kB*T)/(6*np.pi*uf*(dc/2)) 

            var_NR3 = dc/dp  
            var_NvdW3 = H/(kB*T) 
            var_NA3 = H/(12*np.pi*uf*((dp/2)**2)*Ui) 
            var_NG3 = (2*((dc/2)**2)*(pc - pf)*g)/(9*uf*Ui)
            var_NGi3 = 1/(1 + var_NG3) 
            var_NLo3 = H/(9*np.pi*uf*((dc/2)**2)*Ui) 
            var_NPe3 = (Ui*(dp))/D   

            n_RT10 = (gamma**2)*(4*As**(1/3))*(var_NPe3**(-2/3)) + As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.00338*As*(var_NG3**(1.2))*(var_NR3**(-0.4))
            n_NG10 = (gamma**(2))*(2.4*((As)**(1/3))*(((var_NPe3)/(var_NPe3 + 16))**(0.75))*((var_NPe3)**(-0.68))*((var_NLo3)**(0.015))*((var_NGi3)**(0.8))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NGi3/(var_NGi3 + 0.9))*var_NG3*((var_NR3)**(-0.05))  
            n_MPFJ10 = (gamma**2)*(((((8 + (4*(1 - gamma)*(As**(1/3))*(var_NPe3**(1/3))))/(8 + (1 - gamma)*(var_NPe3**(0.97))))*(var_NLo3**(0.015))*(var_NGi3**(0.8))*(var_NR3**(0.028))))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NR3**(-0.05))*var_NG3*(var_NGi3/(var_NGi3 + 0.9))
            n_TE10 = (2.4*(As**(1/3))*(var_NR3**(-0.081))*(var_NPe3**(-0.715))*(var_NvdW3**(0.052))) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                        (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            n_LH10 = (15.56)*((gamma**6)/((1 - (gamma**3))**(2)))*((var_NPe3)**(-0.65))*((var_NR3)**(0.19)) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                    (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            
            n_set1 = [n_RT10, n_MPFJ10, n_TE10, n_NG10, n_LH10]

            graphic_set_range1(x1, n_set1)

        check_var2.set(0)
        check_var3.set(0)
        check_var4.set(0)
        check_var5.set(0)
        check_var6.set(0)
        check_var7.set(0)
        check_var8.set(0)
        check_var9.set(0)

        # Creation of the button to plot on the range 
        if boton_evaluate_range1 is None:
            boton_evaluate_range1 = ctk.CTkButton(frame_constante4, text = "Evaluate range", fg_color = "#77DD77", text_color = "black", font = ("Arial", 14, "bold"),
                                                  command = update_graph1)
            boton_evaluate_range1.grid(row = 5, column = 1, columnspan = 4, padx = 2, sticky = "e")

    # Disactive set range frame    
    else:                                                                       
        color_inicial = "#A9A9A9"
        entry_Ns.configure(state = "disabled", fg_color = color_inicial)
        var_Ns.set("enable range")     
        entry_Lv.configure(state = "disabled", fg_color = color_inicial)
        var_Lv.set("enable range") 
        entry_Uv.configure(state = "disabled", fg_color = color_inicial)
        var_Uv.set("enable range")
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB") 
        var_step.set(" ")

        # Title returns
        if Parameter is not None:
            Parameter.destroy()
        Parameter1 = ctk.CTkLabel(frame_constante4, text = "Parameter                            ", font = ("Arial", 14, "bold"))
        Parameter1.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5)

        # Hides the range button 
        if boton_evaluate_range1 is not None:                                   
            boton_evaluate_range1.grid_forget()  
            boton_evaluate_range1.destroy() 
            boton_evaluate_range1 = None                                          

## GRAPHIC OF SET RANGE OF COLLECTOR DIAMETER (mm)
def graphic_set_range1(x1, n_set1):

    plt.close("all")
    fig1, ax1 = plt.subplots(figsize = (6.5, 5.2)) 
    plt.gcf().canvas.manager.set_window_title("Collector Efficiency based on range")
    for j in range(len(Autors)): ax1.plot(x1, n_set1[j], label = Autors[j])
    ax1.set(xlabel = "Collector diameter (mm)", ylabel = "Ƞ")
    ax1.set_xlim([x1[0], x1[-1]]) 
    ax1.yaxis.set_major_formatter(ticker.ScalarFormatter())  
    ax1.ticklabel_format(style = "sci", axis = "y", scilimits = (0,0)) 
    ax1.legend(loc = "upper center", bbox_to_anchor = (0.5, -0.15), shadow = True, ncol = 3,
            fontsize = 8.5, handlelength = 1.4, labelspacing = 0.2, borderpad = 0.3)
    ax1.grid(True)
    plt.tight_layout()
    fig1.show()

## ==================================================================================================

## SET RANGE OF COLLOID DIAMETER (um)
def set_range2():

    global boton_evaluate_range2
    # Active set range frame
    if check_var2.get() == 1:                                                         
        color_inicial = "white"
        entry_Ns.configure(state = "normal", fg_color = color_inicial)
        entry_Lv.configure(state = "normal", fg_color = color_inicial) 
        entry_Uv.configure(state = "normal", fg_color = color_inicial)
        entry_step.configure(state = "normal")

        # Change of title 
        if Parameter is not None:
            Parameter.destroy()
        Parameter2 = ctk.CTkLabel(frame_constante4, text = "Particle size (um)", font = ("Arial", 14, "bold"))
        Parameter2.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5)

        # Warning message 
        lv = float(var_dc.get())*0.5
        uv = float(var_dc.get())*1.5
        ns = 10
        try:
            if lv < 0.1:
                messagebox.showwarning("Warming", "Colloid diameter must be among\n0.1 - 50 um")
                lv = 0.1
                var_Lv.set(f"{lv:.2f}")
            else:
                var_Lv.set(f"{lv:.2f}")

            if uv > 50:
                messagebox.showwarning("Warming", "Colloid diameter must be among\n0.1 - 50 um")
                uv = 50
                var_Uv.set(f"{uv:.2f}")
            else:
                var_Uv.set(f"{uv:.2f}")

            step2 = (uv - lv)/(ns - 1)
            var_step.set(f"{step2:.5f}")
            var_Ns.set(f"{ns}")

        except ValueError:
            pass

        # Step update function
        def update_step2():

            try:
                lv = float(var_Lv.get())
                uv = float(var_Uv.get())
                ns = int(var_Ns.get())
                if ns > 1:
                    step = (uv - lv)/(ns - 1)
                    var_step.set(f"{step:.5f}")
                    x2 = np.linspace(lv, uv, ns)
                    return x2
            except ValueError:
                pass
            
        var_Lv.trace_add("write", lambda *args: update_step2())
        var_Uv.trace_add("write", lambda *args: update_step2())
        var_Ns.trace_add("write", lambda *args: update_step2())
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB")       
        
        # Graphical update function
        def update_graph2():

            plt.close("all")
            dp = float(var_dp.get())*(1/1000)            # Collector diameter (mm) a (m)
            U = float(var_U.get())*(1/24)*(1/3600)       # Pore water velocity (m/day) a (m/s)
            pc = float(var_pc.get())                     # Colloid density (kg/m3)
            pf = float(var_pf.get())                     # Fluid density (kg/m3)
            uf = float(var_uf.get())                     # Fluid viscosity (kg m/s)
            T = float(var_T.get())                       # Temperature (K)
            H = float(var_H.get())                       # Mamaker constant(J)
            theta = float(var_theta.get())               # Porosity
            Ui = U*theta

            x2 = update_step2() 
            dc = x2*(1/1000)*(1/1000)
            gamma = (1 - theta)**(1/3)              
            As = (2*(1 - (gamma**5)))/(2 - (3*gamma) + (3*(gamma**5)) - (2*(gamma**6)))
            Kw = (5*(1 - (gamma**3)))/(5 - (9*gamma) + (5*(gamma**3)) - (1*(gamma**6)))
            D = (kB*T)/(6*np.pi*uf*(dc/2))    

            var_NR3 = dc/dp  
            var_NvdW3 = H/(kB*T) 
            var_NA3 = H/(12*np.pi*uf*((dp/2)**2)*Ui) 
            var_NG3 = (2*((dc/2)**2)*(pc - pf)*g)/(9*uf*Ui)
            var_NGi3 = 1/(1 + var_NG3) 
            var_NLo3 = H/(9*np.pi*uf*((dc/2)**2)*Ui) 
            var_NPe3 = (Ui*(dp))/D   

            n_RT20 = (gamma**2)*(4*As**(1/3))*(var_NPe3**(-2/3)) + As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.00338*As*(var_NG3**(1.2))*(var_NR3**(-0.4))
            n_NG20 = (gamma**(2))*(2.4*((As)**(1/3))*(((var_NPe3)/(var_NPe3 + 16))**(0.75))*((var_NPe3)**(-0.68))*((var_NLo3)**(0.015))*((var_NGi3)**(0.8))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NGi3/(var_NGi3 + 0.9))*var_NG3*((var_NR3)**(-0.05))  
            n_MPFJ20 = (gamma**2)*(((((8 + (4*(1 - gamma)*(As**(1/3))*(var_NPe3**(1/3))))/(8 + (1 - gamma)*(var_NPe3**(0.97))))*(var_NLo3**(0.015))*(var_NGi3**(0.8))*(var_NR3**(0.028))))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NR3**(-0.05))*var_NG3*(var_NGi3/(var_NGi3 + 0.9))
            n_TE20 = (2.4*(As**(1/3))*(var_NR3**(-0.081))*(var_NPe3**(-0.715))*(var_NvdW3**(0.052))) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                        (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            n_LH20 = (15.56)*((gamma**6)/((1 - (gamma**3))**(2)))*((var_NPe3)**(-0.65))*((var_NR3)**(0.19)) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                    (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            
            n_set2 = [n_RT20, n_MPFJ20, n_TE20, n_NG20, n_LH20]

            graphic_set_range2(x2, n_set2)

        check_var.set(0)
        check_var3.set(0)
        check_var4.set(0)
        check_var5.set(0)
        check_var6.set(0)
        check_var7.set(0)
        check_var8.set(0)
        check_var9.set(0)

        # Creation of the button to plot on the range         
        if boton_evaluate_range2 is None:
            boton_evaluate_range2 = ctk.CTkButton(frame_constante4, fg_color = "#77DD77", text = "Evaluate range", text_color = "black", font = ("Arial", 14, "bold"),
                                                  command = update_graph2)
            boton_evaluate_range2.grid(row = 5, column = 1, columnspan = 4, padx = 2, sticky = "e")

    # Disactive set range frame  
    else:                                                                             
        color_inicial = "#A9A9A9"
        entry_Ns.configure(state = "disabled", fg_color = color_inicial)
        var_Ns.set("enable range")     
        entry_Lv.configure(state = "disabled", fg_color = color_inicial)
        var_Lv.set("enable range") 
        entry_Uv.configure(state = "disabled", fg_color = color_inicial)
        var_Uv.set("enable range")  
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB") 
        var_step.set(" ")

        # Title returns
        if Parameter is not None:
            Parameter.destroy()
        Parameter2 = ctk.CTkLabel(frame_constante4, text = "Parameter             ", font = ("Arial", 14, "bold"))
        Parameter2.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5)
   
        # Hides the range button 
        if boton_evaluate_range2 is not None:                                       
            boton_evaluate_range2.grid_forget()  
            boton_evaluate_range2.destroy() 
            boton_evaluate_range2 = None                                               

## GRAPHIC OF SET RANGE OF COLLOID DIAMETER (um)
def graphic_set_range2(x2, n_set2):
 
    plt.close("all")
    fig2, ax2 = plt.subplots(figsize = (6.5, 5.2))
    plt.gcf().canvas.manager.set_window_title("Collector Efficiency based on range")
    for j in range(len(Autors)): ax2.plot(x2, n_set2[j], label = Autors[j])
    ax2.set(xlabel = "Particle size (um)", ylabel = "Ƞ")
    ax2.set_xlim([x2[0], x2[-1]]) 
    ax2.yaxis.set_major_formatter(ticker.ScalarFormatter())  
    ax2.ticklabel_format(style = "sci", axis = "y", scilimits = (0,0)) 
    ax2.legend(loc = "upper center", bbox_to_anchor = (0.5, -0.15), shadow = True, ncol = 3,
            fontsize = 8.5, handlelength = 1.4, labelspacing = 0.2, borderpad = 0.3)
    ax2.grid(True)
    plt.tight_layout()
    fig2.show()

## ==================================================================================================

## SET RANGE OF PORE WATER VELOCITY (m/day)
def set_range3():

    global boton_evaluate_range3
    # Active set range frame
    if check_var3.get() == 1:                                                        
        color_inicial = "white"
        entry_Ns.configure(state = "normal", fg_color = color_inicial)                                     
        entry_Lv.configure(state = "normal", fg_color = color_inicial)
        entry_Uv.configure(state = "normal", fg_color = color_inicial)
        entry_step.configure(state = "normal")

        # Change of title 
        if Parameter is not None:
            Parameter.destroy()
        Parameter3 = ctk.CTkLabel(frame_constante4, text = "Pore water velocity (m/day)", font = ("Arial", 14, "bold"))
        Parameter3.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5)
        
        # Warning message
        lv = float(var_U.get())*0.5
        uv = float(var_U.get())*1.5
        ns = 10
        try:
            if lv < 0.5:
                messagebox.showwarning("Warming", "Pore water velocity must be among\n0.5 - 20 (m/day)")
                lv = 0.5
                var_Lv.set(f"{lv:.2f}")
            else:
                var_Lv.set(f"{lv:.2f}")

            if uv > 20:
                messagebox.showwarning("Warming", "Pore water velocity must be among\n0.5 - 20 (m/day)")
                uv = 20
                var_Uv.set(f"{uv:.2f}")
            else:
                var_Uv.set(f"{uv:.2f}")

            step3 = (uv - lv)/(ns - 1)
            var_step.set(f"{step3:.5f}")
            var_Ns.set(f"{ns}")

        except ValueError:
            pass

        # Step update function
        def update_step3():

            try:
                lv = float(var_Lv.get())
                uv = float(var_Uv.get())
                ns = int(var_Ns.get())
                if ns > 1:
                    step = (uv - lv) / (ns - 1)
                    var_step.set(f"{step:.5f}")
                    x3 = np.linspace(lv, uv, ns)
                    return x3
            except ValueError:
                pass
            
        var_Lv.trace_add("write", lambda *args: update_step3())
        var_Uv.trace_add("write", lambda *args: update_step3())
        var_Ns.trace_add("write", lambda *args: update_step3())
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB")

        # Graphical update function
        def update_graph3():

            plt.close("all")
            dp = float(var_dp.get())*(1/1000)            # Collector diameter (mm) a (m)
            dc = float(var_dc.get())*(1/1000)*(1/1000)   # Colloid diameter (um) a (m)
            pc = float(var_pc.get())                     # Colloid density (kg/m3)
            pf = float(var_pf.get())                     # Fluid density (kg/m3)
            uf = float(var_uf.get())                     # Fluid viscosity (kg m/s)
            T = float(var_T.get())                       # Temperature (K)
            H = float(var_H.get())                       # Mamaker constant(J)
            theta = float(var_theta.get())               # Porosity

            x3 = update_step3()
            U = x3*(1/24)*(1/3600)
            Ui = U*theta
            gamma = (1 - theta)**(1/3)              
            As = (2*(1 - (gamma**5)))/(2 - (3*gamma) + (3*(gamma**5)) - (2*(gamma**6)))
            Kw = (5*(1 - (gamma**3)))/(5 - (9*gamma) + (5*(gamma**3)) - (1*(gamma**6)))
            D = (kB*T)/(6*np.pi*uf*(dc/2))  

            var_NR3 = dc/dp  
            var_NvdW3 = H/(kB*T) 
            var_NA3 = H/(12*np.pi*uf*((dp/2)**2)*Ui)  
            var_NG3 = (2*((dc/2)**2)*(pc - pf)*g)/(9*uf*Ui)
            var_NGi3 = 1/(1 + var_NG3) 
            var_NLo3 = H/(9*np.pi*uf*((dc/2)**2)*Ui) 
            var_NPe3 = (Ui*(dp))/D   

            n_RT30 = (gamma**2)*(4*As**(1/3))*(var_NPe3**(-2/3)) + As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.00338*As*(var_NG3**(1.2))*(var_NR3**(-0.4))
            n_NG30 = (gamma**(2))*(2.4*((As)**(1/3))*(((var_NPe3)/(var_NPe3 + 16))**(0.75))*((var_NPe3)**(-0.68))*((var_NLo3)**(0.015))*((var_NGi3)**(0.8))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NGi3/(var_NGi3 + 0.9))*var_NG3*((var_NR3)**(-0.05))  
            n_MPFJ30 = (gamma**2)*(((((8 + (4*(1 - gamma)*(As**(1/3))*(var_NPe3**(1/3))))/(8 + (1 - gamma)*(var_NPe3**(0.97))))*(var_NLo3**(0.015))*(var_NGi3**(0.8))*(var_NR3**(0.028))))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NR3**(-0.05))*var_NG3*(var_NGi3/(var_NGi3 + 0.9))
            n_TE30 = (2.4*(As**(1/3))*(var_NR3**(-0.081))*(var_NPe3**(-0.715))*(var_NvdW3**(0.052))) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                        (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            n_LH30 = (15.56)*((gamma**6)/((1 - (gamma**3))**(2)))*((var_NPe3)**(-0.65))*((var_NR3)**(0.19)) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                    (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            
            n_set3 = [n_RT30, n_MPFJ30, n_TE30, n_NG30, n_LH30]

            graphic_set_range3(x3, n_set3)

        check_var.set(0)
        check_var2.set(0)      
        check_var4.set(0)
        check_var5.set(0)
        check_var6.set(0)
        check_var7.set(0)
        check_var8.set(0)
        check_var9.set(0)

        # Creation of the button to plot on the range 
        if boton_evaluate_range3 is None:
            boton_evaluate_range3 = ctk.CTkButton(frame_constante4, fg_color = "#77DD77", text = "Evaluate range", text_color = "black", font = ("Arial", 14, "bold"),
                                                  command = update_graph3)
            boton_evaluate_range3.grid(row = 5, column = 1, columnspan = 4, padx = 2, sticky = "e")

    # Disactive set range frame
    else:                                                                             
        color_inicial = "#A9A9A9"
        entry_Ns.configure(state = "disabled", fg_color = color_inicial)
        var_Ns.set("enable range")     
        entry_Lv.configure(state = "disabled", fg_color = color_inicial)
        var_Lv.set("enable range") 
        entry_Uv.configure(state = "disabled", fg_color = color_inicial)
        var_Uv.set("enable range")
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB") 
        var_step.set(" ") 

        # Title returns
        if Parameter is not None:
            Parameter3.destroy()
        Parameter3 = ctk.CTkLabel(frame_constante4, text = "Parameter                             ", font = ("Arial", 14, "bold"))
        Parameter3.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5)

        # Hides the range button
        if boton_evaluate_range3 is not None:                                         
            boton_evaluate_range3.grid_forget()  
            boton_evaluate_range3.destroy() 
            boton_evaluate_range3 = None                                               

## GRAPHIC OF SET RANGE OF PORE WATER VELOCITY (m/day)
def graphic_set_range3(x3, n_set3):

    plt.close("all")  
    fig3, ax3 = plt.subplots(figsize = (6.5, 5.2))
    plt.gcf().canvas.manager.set_window_title("Collector Efficiency based on range")
    for j in range(len(Autors)): ax3.plot(x3, n_set3[j], label = Autors[j])
    ax3.set(xlabel = "Pore water velocity (m/day)", ylabel = "Ƞ")
    ax3.set_xlim([x3[0], x3[-1]])
    ax3.yaxis.set_major_formatter(ticker.ScalarFormatter())  
    ax3.ticklabel_format(style = "sci", axis = "y", scilimits = (0,0))  
    ax3.legend(loc = "upper center", bbox_to_anchor = (0.5, -0.15), shadow = True, ncol = 3,
            fontsize = 8.5, handlelength = 1.4, labelspacing = 0.2, borderpad = 0.3)
    ax3.grid(True)
    plt.tight_layout()
    fig3.show()

## ==================================================================================================

## SET RANGE OF COLLOID DENSITY (kg/m3)
def set_range4():

    global boton_evaluate_range4, update_step4
    # Active set range frame
    if check_var4.get() == 1:                                                      
        color_inicial = "white"
        entry_Ns.configure(state = "normal", fg_color = color_inicial)          
        entry_Lv.configure(state = "normal", fg_color = color_inicial)
        entry_Uv.configure(state = "normal", fg_color = color_inicial)
        entry_step.configure(state = "normal")

        # Change of title 
        if Parameter is not None:
            Parameter.destroy()
        Parameter4 = ctk.CTkLabel(frame_constante4, text = "Colloid density (kg/m3)", font = ("Arial", 14, "bold"))
        Parameter4.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5)

        # Warning message
        lv = float(var_pc.get())*0.5
        uv = float(var_pc.get())*1.5
        ns = 10
        try:
            if lv < 1_000:
                messagebox.showwarning("Warming", "Colloid density must be among\n1000 - 20000 (kg/m3)")
                lv = 1_000
                var_Lv.set(f"{lv:.2f}")
            else:
                var_Lv.set(f"{lv:.2f}")

            if uv > 20_000:
                messagebox.showwarning("Warming", "Colloid density must be among\n1000 - 20000 (kg/m3)")
                uv = 20_000
                var_Uv.set(f"{uv:.2f}")
            else:
                var_Uv.set(f"{uv:.2f}")

            step = (uv - lv)/(ns - 1)
            var_step.set(f"{step:.5f}")
            var_Ns.set(f"{ns}")
        
        except ValueError:
            pass

        # Step update function
        def update_step4():

            try:
                lv = float(var_Lv.get())
                uv = float(var_Uv.get())
                ns = int(var_Ns.get())
                if ns > 1:
                    step4 = (uv - lv)/(ns - 1)
                    var_step.set(f"{step4:.5f}")
                    x4 = np.linspace(lv, uv, ns)
                    return x4
            except ValueError:
                pass
            
        var_Lv.trace_add("write", lambda *args: update_step4())
        var_Uv.trace_add("write", lambda *args: update_step4())
        var_Ns.trace_add("write", lambda *args: update_step4())
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB")  

        # Graphical update function
        def update_graph4():

            plt.close("all")    
            dp = float(var_dp.get())*(1/1000)            # Collector diameter (mm) a (m)
            dc = float(var_dc.get())*(1/1000)*(1/1000)   # Colloid diameter (um) a (m)
            U = float(var_U.get())*(1/24)*(1/3600)       # Pore water velocity (m/day) a (m/s)
            pf = float(var_pf.get())                     # Fluid density (kg/m3)
            uf = float(var_uf.get())                     # Fluid viscosity (kg m/s)
            T = float(var_T.get())                       # Temperature (K)
            H = float(var_H.get())                       # Mamaker constant(J)
            theta = float(var_theta.get())               # Porosity
            Ui = U*theta

            x4 = update_step4() 
            pc = x4
            gamma = (1 - theta)**(1/3)              
            As = (2*(1 - (gamma**5)))/(2 - (3*gamma) + (3*(gamma**5)) - (2*(gamma**6)))
            Kw = (5*(1 - (gamma**3)))/(5 - (9*gamma) + (5*(gamma**3)) - (1*(gamma**6)))
            D = (kB*T)/(6*np.pi*uf*(dc/2))   

            var_NR3 = dc/dp  
            var_NvdW3 = H/(kB*T) 
            var_NA3 = H/(12*np.pi*uf*((dp/2)**2)*Ui) 
            var_NG3 = (2*((dc/2)**2)*(pc - pf)*g)/(9*uf*Ui)
            var_NGi3 = 1/(1 + var_NG3) 
            var_NLo3 = H/(9*np.pi*uf*((dc/2)**2)*Ui) 
            var_NPe3 = (Ui*(dp))/D   

            n_RT4 = (gamma**2)*(4*As**(1/3))*(var_NPe3**(-2/3)) + As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.00338*As*(var_NG3**(1.2))*(var_NR3**(-0.4))
            n_NG4 = (gamma**(2))*(2.4*((As)**(1/3))*(((var_NPe3)/(var_NPe3 + 16))**(0.75))*((var_NPe3)**(-0.68))*((var_NLo3)**(0.015))*((var_NGi3)**(0.8))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NGi3/(var_NGi3 + 0.9))*var_NG3*((var_NR3)**(-0.05))  
            n_MPFJ4 = (gamma**2)*(((((8 + (4*(1 - gamma)*(As**(1/3))*(var_NPe3**(1/3))))/(8 + (1 - gamma)*(var_NPe3**(0.97))))*(var_NLo3**(0.015))*(var_NGi3**(0.8))*(var_NR3**(0.028))))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NR3**(-0.05))*var_NG3*(var_NGi3/(var_NGi3 + 0.9))
            n_TE4 = (2.4*(As**(1/3))*(var_NR3**(-0.081))*(var_NPe3**(-0.715))*(var_NvdW3**(0.052))) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                        (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            n_LH4 = (15.56)*((gamma**6)/((1 - (gamma**3))**(2)))*((var_NPe3)**(-0.65))*((var_NR3)**(0.19)) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                    (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            
            n_set4 = [n_RT4, n_MPFJ4, n_TE4, n_NG4, n_LH4]

            graphic_set_range4(x4, n_set4)

        check_var.set(0)
        check_var2.set(0)
        check_var3.set(0)
        check_var5.set(0)
        check_var6.set(0)
        check_var7.set(0)
        check_var8.set(0)
        check_var9.set(0)

        # Creation of the button to plot on the range         
        if boton_evaluate_range4 is None:
            boton_evaluate_range4 = ctk.CTkButton(frame_constante4, fg_color = "#77DD77", text = "Evaluate range", text_color = "black", font = ("Arial", 14, "bold"),
                                                  command = update_graph4)
            boton_evaluate_range4.grid(row = 5, column = 1, columnspan = 4, padx = 2, sticky = "e")

    # Disactive set range frame
    else:                                                                             
        color_inicial = "#A9A9A9"
        entry_Ns.configure(state = "disabled", fg_color = color_inicial)
        var_Ns.set("enable range")     
        entry_Lv.configure(state = "disabled", fg_color = color_inicial)
        var_Lv.set("enable range") 
        entry_Uv.configure(state = "disabled", fg_color = color_inicial)
        var_Uv.set("enable range") 
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB") 
        var_step.set(" ")

        # Title returns
        if Parameter is not None:
            Parameter4.destroy()
        Parameter4 = ctk.CTkLabel(frame_constante4, text = "Parameter                            ", font = ("Arial", 14, "bold"))
        Parameter4.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5)

        # Hides the range button
        if boton_evaluate_range4 is not None:                                     
            boton_evaluate_range4.grid_forget()  
            boton_evaluate_range4.destroy() 
            boton_evaluate_range4 = None                                                 

## GRAPHIC OF SET RANGE OF COLLOID DENSITY (kg/m3)
def graphic_set_range4(x4, n_set4):

    plt.close("all")
    fig4, ax4 = plt.subplots(figsize = (6.5, 5.2))
    plt.gcf().canvas.manager.set_window_title("Collector Efficiency based on range")
    for j in range(len(Autors)): ax4.plot(x4, n_set4[j], label = Autors[j])
    ax4.set(xlabel = "Coloid density (kg/m3)", ylabel = "Ƞ")
    ax4.set_xlim([x4[0], x4[-1]]) 
    ax4.yaxis.set_major_formatter(ticker.ScalarFormatter())  
    ax4.ticklabel_format(style = "sci", axis = "y", scilimits = (0,0))  
    ax4.legend(loc = "upper center", bbox_to_anchor = (0.5, -0.15), shadow = True, ncol = 3,
            fontsize = 8.5, handlelength = 1.4, labelspacing = 0.2, borderpad = 0.3)
    ax4.grid(True)
    plt.tight_layout()
    fig4.show()

## ==================================================================================================

## SET RANGE OF FLUID DENSITY (kg/m3)
def set_range5():

    global boton_evaluate_range5
    # Active set range frame
    if check_var5.get() == 1:                                                        
        color_inicial = "white"
        entry_Ns.configure(state = "normal", fg_color = color_inicial)                                 
        entry_Lv.configure(state = "normal", fg_color = color_inicial)
        entry_Uv.configure(state = "normal", fg_color = color_inicial)
        entry_step.configure(state = "normal")

        # Change of title 
        if Parameter is not None:
            Parameter.destroy()
        Parameter5 = ctk.CTkLabel(frame_constante4, text = "Fluid density (kg/m3)", font = ("Arial", 14, "bold"))
        Parameter5.grid(row = 1, column = 0, columnspan = 2, sticky = "w", padx = 5)

        # Warning message
        lv = float(var_pf.get())*0.8
        uv = float(var_pf.get())*1.2
        ns = 10
        try:
            if lv < 600:
                messagebox.showwarning("Warming", "Fluid density must be among\n600 - 1400 (kg/m3)")
                lv = 600
                var_Lv.set(f"{lv:.2f}")
            else:
                var_Lv.set(f"{lv:.2f}")

            if uv > 1_400:
                messagebox.showwarning("Warming", "Fluid density must be among\n600 - 1400 (kg/m3)")
                uv = 1_400
                var_Uv.set(f"{uv:.2f}")
            else:
                var_Uv.set(f"{uv:.2f}")

            step5 = (uv - lv)/(ns - 1)
            var_step.set(f"{step5:.5f}")
            var_Ns.set(f"{ns}")
        
        except ValueError:
            pass

        # Step update function
        def update_step5():

            try:
                lv = float(var_Lv.get())
                uv = float(var_Uv.get())
                ns = int(var_Ns.get())
                if ns > 1:
                    step = (uv - lv)/(ns - 1)
                    var_step.set(f"{step:.5f}")
                    x5 = np.linspace(lv, uv, ns)
                    return x5
            except ValueError:
                pass
            
        var_Lv.trace_add("write", lambda *args: update_step5())
        var_Uv.trace_add("write", lambda *args: update_step5())
        var_Ns.trace_add("write", lambda *args: update_step5())
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB")  

        # Graphical update function
        def update_graph5():

            plt.close("all")
            dp = float(var_dp.get())*(1/1000)            # Collector diameter (mm) a (m)
            dc = float(var_dc.get())*(1/1000)*(1/1000)   # Colloid diameter (um) a (m)
            U = float(var_U.get())*(1/24)*(1/3600)       # Pore water velocity (m/day) a (m/s)
            pc = float(var_pc.get())                     # Colloid density (kg/m3)
            uf = float(var_uf.get())                     # Fluid viscosity (kg m/s)
            T = float(var_T.get())                       # Temperature (K)
            H = float(var_H.get())                       # Hamaker constant(J)
            theta = float(var_theta.get())               # Porosity
            Ui = U*theta

            x5 = update_step5()
            pf = x5
            gamma = ((1 - theta)**(1/3))              
            As = (2*(1 - (gamma**5)))/(2 - (3*gamma) + (3*(gamma**5)) - (2*(gamma**6)))
            Kw = (5*(1 - (gamma**3)))/(5 - (9*gamma) + (5*(gamma**3)) - (1*(gamma**6)))
            D = (kB*T)/(6*np.pi*uf*(dc/2))    

            var_NR3 = dc/dp  
            var_NvdW3 = H/(kB*T) 
            var_NA3 = H/(12*np.pi*uf*((dp/2)**2)*Ui) 
            var_NG3 = (2*((dc/2)**2)*(pc - pf)*g)/(9*uf*Ui)
            var_NGi3 = 1/(1 + var_NG3) 
            var_NLo3 = H/(9*np.pi*uf*((dc/2)**2)*Ui) 
            var_NPe3 = (Ui*(dp))/D   

            n_RT5 = (gamma**2)*(4*As**(1/3))*(var_NPe3**(-2/3)) + As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.00338*As*(var_NG3**(1.2))*(var_NR3**(-0.4))
            n_NG5 = (gamma**(2))*(2.4*((As)**(1/3))*(((var_NPe3)/(var_NPe3 + 16))**(0.75))*((var_NPe3)**(-0.68))*((var_NLo3)**(0.015))*((var_NGi3)**(0.8))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NGi3/(var_NGi3 + 0.9))*var_NG3*((var_NR3)**(-0.05))  
            n_MPFJ5 = (gamma**2)*(((((8 + (4*(1 - gamma)*(As**(1/3))*(var_NPe3**(1/3))))/(8 + (1 - gamma)*(var_NPe3**(0.97))))*(var_NLo3**(0.015))*(var_NGi3**(0.8))*(var_NR3**(0.028))))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NR3**(-0.05))*var_NG3*(var_NGi3/(var_NGi3 + 0.9))
            n_TE5 = (2.4*(As**(1/3))*(var_NR3**(-0.081))*(var_NPe3**(-0.715))*(var_NvdW3**(0.052))) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                        (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            n_LH5 = (15.56)*((gamma**6)/((1 - (gamma**3))**(2)))*((var_NPe3)**(-0.65))*((var_NR3)**(0.19)) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                    (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            
            n_set5 = [n_RT5, n_MPFJ5, n_TE5, n_NG5, n_LH5]

            graphic_set_range5(x5, n_set5)

        check_var.set(0)
        check_var2.set(0)
        check_var3.set(0)
        check_var4.set(0)
        check_var6.set(0)
        check_var7.set(0)
        check_var8.set(0)
        check_var9.set(0)
        
        # Creation of the button to plot on the range 
        if boton_evaluate_range5 is None:
            boton_evaluate_range5 = ctk.CTkButton(frame_constante4, fg_color = "#77DD77", text = "Evaluate range", text_color = "black", font = ("Arial", 14, "bold"),
                                                  command = update_graph5)
            boton_evaluate_range5.grid(row = 5, column = 1, columnspan = 4, padx = 2, sticky = "e")

    # Disactive set range frame
    else:                                                                            
        color_inicial = "#A9A9A9"
        entry_Ns.configure(state = "disabled", fg_color = color_inicial)
        var_Ns.set("enable range")     
        entry_Lv.configure(state = "disabled", fg_color = color_inicial)
        var_Lv.set("enable range") 
        entry_Uv.configure(state = "disabled", fg_color = color_inicial)
        var_Uv.set("enable range")
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB") 
        var_step.set(" ")  

        # Title returns
        if Parameter is not None:
            Parameter5.destroy()
        Parameter5 = ctk.CTkLabel(frame_constante4, text = "Parameter                             ", font = ("Arial", 14, "bold"))
        Parameter5.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5)
        
        # Hides the range button
        if boton_evaluate_range5 is not None:                                       
            boton_evaluate_range5.grid_forget()  
            boton_evaluate_range5.destroy() 
            boton_evaluate_range5 = None                                              

## GRAPHIC OF SET RANGE OF FLUID DENSITY (kg/m3)
def graphic_set_range5(x5, n_set5):

    plt.close("all")
    fig5, ax5 = plt.subplots(figsize = (6.5, 5.2))
    plt.gcf().canvas.manager.set_window_title("Collector Efficiency based on range")
    for j in range(len(Autors)): ax5.plot(x5, n_set5[j], label = Autors[j])
    ax5.set(xlabel = "Fluid density (kg/m3)", ylabel = "Ƞ")
    ax5.set_xlim([x5[0], x5[-1]]) 
    ax5.yaxis.set_major_formatter(ticker.ScalarFormatter())  
    ax5.ticklabel_format(style = "sci", axis = "y", scilimits = (0,0))  
    ax5.legend(loc = "upper center", bbox_to_anchor = (0.5, -0.15), shadow = True, ncol = 3,
            fontsize = 8.5, handlelength = 1.4, labelspacing = 0.2, borderpad = 0.3)
    ax5.grid(True)
    plt.tight_layout()
    fig5.show()

## ==================================================================================================

## SET RANGE OF FLUID VISCOSITY (kg m/s)
def set_range6():

    global boton_evaluate_range6
    # Active set range frame
    if check_var6.get() == 1:                                                       
        color_inicial = "white"
        entry_Ns.configure(state = "normal", fg_color = color_inicial)                                    
        entry_Lv.configure(state = "normal", fg_color = color_inicial)
        entry_Uv.configure(state = "normal", fg_color = color_inicial)
        entry_step.configure(state = "normal")

        # Change of title 
        if Parameter is not None:
            Parameter.destroy()
        Parameter6 = ctk.CTkLabel(frame_constante4, text = "Fluid viscosity (kg m/s)", font = ("Arial", 14, "bold"))
        Parameter6.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5)
        
        # Warning message
        lv = float(var_uf.get())*0.5
        uv = float(var_uf.get())*1.5
        ns = 10
        try:
            if lv < 1.00e-4:
                messagebox.showwarning("Warming", "Fluid viscosity must be among\n1e-4 - 1e-3 (kg m/s)")
                lv = 1.00e-4
                var_Lv.set(f"{lv:.2e}")
            else:
                var_Lv.set(f"{lv:.2e}")

            if uv > 1.00e-3:
                messagebox.showwarning("Warming", "Fluid viscosity must be among\n1e-4 - 1e-3 (kg m/s)")
                uv = 1.00e-3
                var_Uv.set(f"{uv:.2e}")
            else:
                var_Uv.set(f"{uv:.2e}")

            step6 = (uv - lv)/(ns - 1)
            var_step.set(f"{step6:.4e}")
            var_Ns.set(f"{ns}")

        except ValueError:
            pass

        # Step update function
        def update_step6():

            try:
                lv = float(var_Lv.get())
                uv = float(var_Uv.get())
                ns = int(var_Ns.get())
                if ns > 1:
                    step = (uv - lv)/(ns - 1)
                    var_step.set(f"{step:.4e}")
                    x6 = np.linspace(lv, uv, ns)
                    return x6
            except ValueError:
                pass
            
        var_Lv.trace_add("write", lambda *args: update_step6())
        var_Uv.trace_add("write", lambda *args: update_step6())
        var_Ns.trace_add("write", lambda *args: update_step6())
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB")  

        # Graphical update function
        def update_graph6():

            plt.close("all")
            dp = float(var_dp.get())*(1/1000)            # Collector diameter (mm) a (m)
            dc = float(var_dc.get())*(1/1000)*(1/1000)   # Colloid diameter (um) a (m)
            U = float(var_U.get())*(1/24)*(1/3600)       # Pore water velocity (m/day) a (m/s)
            pc = float(var_pc.get())                     # Colloid density (kg/m3)
            pf = float(var_pf.get())                     # Fluid density (kg/m3)
            T = float(var_T.get())                       # Temperature (K)
            H = float(var_H.get())                       # Mamaker constant(J)
            theta = float(var_theta.get())               # Porosity
            Ui = U*theta

            x6 = update_step6()
            uf = x6
            gamma = (1 - theta)**(1/3)              
            As = (2*(1 - (gamma**5)))/(2 - (3*gamma) + (3*(gamma**5)) - (2*(gamma**6)))
            Kw = (5*(1 - (gamma**3)))/(5 - (9*gamma) + (5*(gamma**3)) - (1*(gamma**6)))
            D = (kB*T)/(6*np.pi*uf*(dc/2))   

            var_NR3 = dc/dp  
            var_NvdW3 = H/(kB*T) 
            var_NA3 = H/(12*np.pi*uf*((dp/2)**2)*Ui) 
            var_NG3 = (2*((dc/2)**2)*(pc - pf)*g)/(9*uf*Ui)
            var_NGi3 = 1/(1 + var_NG3) 
            var_NLo3 = H/(9*np.pi*uf*((dc/2)**2)*Ui) 
            var_NPe3 = (Ui*(dp))/D   

            n_RT6 = (gamma**2)*(4*As**(1/3))*(var_NPe3**(-2/3)) + As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.00338*As*(var_NG3**(1.2))*(var_NR3**(-0.4))
            n_NG6 = (gamma**(2))*(2.4*((As)**(1/3))*(((var_NPe3)/(var_NPe3 + 16))**(0.75))*((var_NPe3)**(-0.68))*((var_NLo3)**(0.015))*((var_NGi3)**(0.8))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NGi3/(var_NGi3 + 0.9))*var_NG3*((var_NR3)**(-0.05))  
            n_MPFJ6 = (gamma**2)*(((((8 + (4*(1 - gamma)*(As**(1/3))*(var_NPe3**(1/3))))/(8 + (1 - gamma)*(var_NPe3**(0.97))))*(var_NLo3**(0.015))*(var_NGi3**(0.8))*(var_NR3**(0.028))))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NR3**(-0.05))*var_NG3*(var_NGi3/(var_NGi3 + 0.9))
            n_TE6 = (2.4*(As**(1/3))*(var_NR3**(-0.081))*(var_NPe3**(-0.715))*(var_NvdW3**(0.052))) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                        (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            n_LH6 = (15.56)*((gamma**6)/((1 - (gamma**3))**(2)))*((var_NPe3)**(-0.65))*((var_NR3)**(0.19)) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                    (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            n_set6 = [n_RT6, n_MPFJ6, n_TE6, n_NG6, n_LH6]

            graphic_set_range6(x6, n_set6)

        check_var.set(0)
        check_var2.set(0)
        check_var3.set(0)
        check_var4.set(0)
        check_var5.set(0)
        check_var7.set(0)
        check_var8.set(0)
        check_var9.set(0)
        
        # Creation of the button to plot on the range 
        if boton_evaluate_range6 is None:
            boton_evaluate_range6 = ctk.CTkButton(frame_constante4, fg_color = "#77DD77", text = "Evaluate range", text_color = "black", font = ("Arial", 14, "bold"),
                                                  command = update_graph6)
            boton_evaluate_range6.grid(row = 5, column = 1, columnspan = 4, padx = 2, sticky = "e")

    # Disactive set range frame
    else:                                                                             
        color_inicial = "#A9A9A9"
        entry_Ns.configure(state = "disabled", fg_color = color_inicial)
        var_Ns.set("enable range")     
        entry_Lv.configure(state = "disabled", fg_color = color_inicial)
        var_Lv.set("enable range") 
        entry_Uv.configure(state = "disabled", fg_color = color_inicial)
        var_Uv.set("enable range")
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB") 
        var_step.set(" ") 
   
        # Title returns
        if Parameter is not None:
            Parameter6.destroy()
        Parameter6 = ctk.CTkLabel(frame_constante4, text = "Parameter                      ", font = ("Arial", 14, "bold"))
        Parameter6.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5)

        # Hides the range button
        if boton_evaluate_range6 is not None:                                      
            boton_evaluate_range6.grid_forget()  
            boton_evaluate_range6.destroy() 
            boton_evaluate_range6 = None                                                

## GRAPHIC OF SET RANGE OF FLUID VISCOSITY (kg m/s)
def graphic_set_range6(x6, n_set6):

    plt.close("all") 
    fig6, ax6 = plt.subplots(figsize = (6.5, 5.2))
    plt.gcf().canvas.manager.set_window_title("Collector Efficiency based on range")
    for j in range(len(Autors)): ax6.plot(x6, n_set6[j], label = Autors[j])
    ax6.set(xlabel = "Fluid viscosity (kg m/s)", ylabel = "Ƞ")
    ax6.set_xlim([x6[0], x6[-1]]) 
    ax6.yaxis.set_major_formatter(ticker.ScalarFormatter())  
    ax6.ticklabel_format(style = "sci", axis = "y", scilimits = (0,0))
    ax6.ticklabel_format(style = "sci", axis = "x", scilimits = (0,0))    
    ax6.legend(loc = "upper center", bbox_to_anchor = (0.5, -0.15), shadow = True, ncol = 3,
            fontsize = 8.5, handlelength = 1.4, labelspacing = 0.2, borderpad = 0.3)
    ax6.grid(True)
    plt.tight_layout()
    fig6.show()

## ==================================================================================================

## SET RANGE OF TEMPERATURE (K)
def set_range7():

    global boton_evaluate_range7
    # Active set range frame
    if check_var7.get() == 1:                                                        
        color_inicial = "white"
        entry_Ns.configure(state = "normal", fg_color = color_inicial)                                  
        entry_Lv.configure(state = "normal", fg_color = color_inicial)
        entry_Uv.configure(state = "normal", fg_color = color_inicial)
        entry_step.configure(state = "normal")

        # Change of title 
        if Parameter is not None:
            Parameter.destroy()
        Parameter7 = ctk.CTkLabel(frame_constante4, text = "Temperature (K)", font = ("Arial", 14, "bold"))
        Parameter7.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5)
        
        # Warning message
        lv = float(var_T.get())*0.9
        uv = float(var_T.get())*1.1
        ns = 10
        try:
            if lv < 263:
                messagebox.showwarning("Warming", "Temperature must be among\n263 - 333 (K)")
                lv = 263
                var_Lv.set(f"{lv:.2f}")
            else:
                var_Lv.set(f"{lv:.2f}")

            if uv > 333:
                messagebox.showwarning("Warming", "Temperature must be among\n263 - 333 (K)")
                uv = 333
                var_Uv.set(f"{uv:.2f}")
            else:
                var_Uv.set(f"{uv:.2f}")

            step7 = (uv - lv)/(ns - 1)
            var_step.set(f"{step7:.5f}")
            var_Ns.set(f"{ns}")
            
        except ValueError:
            pass

        # Step update function
        def update_step7():

            try:
                lv = float(var_Lv.get())
                uv = float(var_Uv.get())
                ns = int(var_Ns.get())
                if ns > 1:
                    step = (uv - lv)/(ns - 1)
                    var_step.set(f"{step:.5f}")
                    x7 = np.linspace(lv, uv, ns)
                    return x7
            except ValueError:
                pass
            
        var_Lv.trace_add("write", lambda *args: update_step7())
        var_Uv.trace_add("write", lambda *args: update_step7())
        var_Ns.trace_add("write", lambda *args: update_step7())
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB")  

        # Graphical update function
        def update_graph7():

            plt.close("all")
            dp = float(var_dp.get())*(1/1000)            # Collector diameter (mm) a (m)
            dc = float(var_dc.get())*(1/1000)*(1/1000)   # Colloid diameter (um) a (m)
            U = float(var_U.get())*(1/24)*(1/3600)       # Pore water velocity (m/day) a (m/s)
            pc = float(var_pc.get())                     # Colloid density (kg/m3)
            pf = float(var_pf.get())                     # Fluid density (kg/m3)
            uf = float(var_uf.get())                     # Fluid viscosity (kg m/s)
            H = float(var_H.get())                       # Mamaker constant(J)
            theta = float(var_theta.get())               # Porosity
            Ui = U*theta

            x7 = update_step7()
            T = x7
            gamma = (1 - theta)**(1/3)              
            As = (2*(1 - (gamma**5)))/(2 - (3*gamma) + (3*(gamma**5)) - (2*(gamma**6)))
            Kw = (5*(1 - (gamma**3)))/(5 - (9*gamma) + (5*(gamma**3)) - (1*(gamma**6)))
            D = (kB*T)/(6*np.pi*uf*(dc/2))   

            var_NR3 = dc/dp  
            var_NvdW3 = H/(kB*T) 
            var_NA3 = H/(12*np.pi*uf*((dp/2)**2)*Ui) 
            var_NG3 = (2*((dc/2)**2)*(pc - pf)*g)/(9*uf*Ui)
            var_NGi3 = 1/(1 + var_NG3) 
            var_NLo3 = H/(9*np.pi*uf*((dc/2)**2)*Ui) 
            var_NPe3 = (Ui*(dp))/D   

            n_RT7 = (gamma**2)*(4*As**(1/3))*(var_NPe3**(-2/3)) + As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.00338*As*(var_NG3**(1.2))*(var_NR3**(-0.4))
            n_NG7 = (gamma**(2))*(2.4*((As)**(1/3))*(((var_NPe3)/(var_NPe3 + 16))**(0.75))*((var_NPe3)**(-0.68))*((var_NLo3)**(0.015))*((var_NGi3)**(0.8))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NGi3/(var_NGi3 + 0.9))*var_NG3*((var_NR3)**(-0.05))  
            n_MPFJ7 = (gamma**2)*(((((8 + (4*(1 - gamma)*(As**(1/3))*(var_NPe3**(1/3))))/(8 + (1 - gamma)*(var_NPe3**(0.97))))*(var_NLo3**(0.015))*(var_NGi3**(0.8))*(var_NR3**(0.028))))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NR3**(-0.05))*var_NG3*(var_NGi3/(var_NGi3 + 0.9))
            n_TE7 = (2.4*(As**(1/3))*(var_NR3**(-0.081))*(var_NPe3**(-0.715))*(var_NvdW3**(0.052))) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                        (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            n_LH7 = (15.56)*((gamma**6)/((1 - (gamma**3))**(2)))*((var_NPe3)**(-0.65))*((var_NR3)**(0.19)) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                    (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            n_set7 = [n_RT7, n_MPFJ7, n_TE7, n_NG7, n_LH7]

            graphic_set_range7(x7, n_set7)

        check_var.set(0)
        check_var2.set(0)
        check_var3.set(0)
        check_var4.set(0)
        check_var5.set(0)
        check_var6.set(0)
        check_var8.set(0)
        check_var9.set(0)

        # Creation of the button to plot on the range 
        if boton_evaluate_range7 is None:
            boton_evaluate_range7 = ctk.CTkButton(frame_constante4, fg_color = "#77DD77", text = "Evaluate range", text_color = "black", font = ("Arial", 14, "bold"),
                                                  command = update_graph7)
            boton_evaluate_range7.grid(row = 5, column = 1, columnspan = 4, padx = 2, sticky = "e")

    # Disactive set range frame
    else:                                                                            
        color_inicial = "#A9A9A9"
        entry_Ns.configure(state = "disabled", fg_color = color_inicial)
        var_Ns.set("enable range")     
        entry_Lv.configure(state = "disabled", fg_color = color_inicial)
        var_Lv.set("enable range") 
        entry_Uv.configure(state = "disabled", fg_color = color_inicial)
        var_Uv.set("enable range")
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB") 
        var_step.set(" ") 

        # Title returns
        if Parameter is not None:
            Parameter7.destroy()
        Parameter7 = ctk.CTkLabel(frame_constante4, text = "Parameter            ", font = ("Arial", 14, "bold"))
        Parameter7.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5) 

        # Hides the range button
        if boton_evaluate_range7 is not None:                                        
            boton_evaluate_range7.grid_forget()  
            boton_evaluate_range7.destroy() 
            boton_evaluate_range7 = None                                             

## GRAPHIC OF SET RANGE OF TEMPERATURE (K)
def graphic_set_range7(x7, n_set7):
    
    plt.close("all")
    fig7, ax7 = plt.subplots(figsize = (6.5, 5.2))
    plt.gcf().canvas.manager.set_window_title("Collector Efficiency based on range")
    for j in range(len(Autors)): ax7.plot(x7, n_set7[j], label = Autors[j])
    ax7.set(xlabel = "Temperature (K)", ylabel = "Ƞ")
    ax7.set_xlim([x7[0], x7[-1]])
    ax7.yaxis.set_major_formatter(ticker.ScalarFormatter())  
    ax7.ticklabel_format(style = "sci", axis = "y", scilimits = (0,0))   
    ax7.legend(loc = "upper center", bbox_to_anchor = (0.5, -0.15), shadow = True, ncol = 3,
            fontsize = 8.5, handlelength = 1.4, labelspacing = 0.2, borderpad = 0.3)
    ax7.grid(True)
    plt.tight_layout()
    fig7.show()

## ==================================================================================================

## SET RANGE OF HAMAKER CONSTANT (J)
def set_range8():

    global boton_evaluate_range8
    # Active set range frame
    if check_var8.get() == 1:                                                        
        color_inicial = "white"
        entry_Ns.configure(state = "normal", fg_color = color_inicial)                            
        entry_Lv.configure(state = "normal", fg_color = color_inicial)
        entry_Uv.configure(state = "normal", fg_color = color_inicial)
        entry_step.configure(state = "normal")

        # Change of title 
        if Parameter is not None:
            Parameter.destroy()
        Parameter8 = ctk.CTkLabel(frame_constante4, text = "Hamaker constant (J)", font = ("Arial", 14, "bold"))
        Parameter8.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5)

        # Warning message        
        lv = float(var_H.get())*0.5
        uv = float(var_H.get())*1.5
        ns = 10
        try:
            if lv < 1.00e-21:
                messagebox.showwarning("Warming", "Hamaker constant must be among\n1e-21 - 1e-20 (J)")
                lv = 1.00e-21
                var_Lv.set(f"{lv:.2e}")
            else:
                var_Lv.set(f"{lv:.2e}")

            if uv > 1.00e-20:
                messagebox.showwarning("Warming", "Hamaker constant must be among\n1e-21 - 1e-20 (J)")
                uv = 1.00e-20
                var_Uv.set(f"{uv:.2e}")
            else:
                var_Uv.set(f"{uv:.2e}")

            step8 = (uv - lv)/(ns - 1)
            var_step.set(f"{step8:.4e}")
            var_Ns.set(f"{ns}")
            
        except ValueError:
            pass
        
        # Step update function
        def update_step8():

            try:
                lv = float(var_Lv.get())
                uv = float(var_Uv.get())
                ns = int(var_Ns.get())
                if ns > 1:
                    step = (uv - lv)/(ns - 1)
                    var_step.set(f"{step:.4e}")
                    x8 = np.linspace(lv, uv, ns)
                    return x8
            except ValueError:
                pass

        var_Lv.trace_add("write", lambda *args: update_step8())
        var_Uv.trace_add("write", lambda *args: update_step8())
        var_Ns.trace_add("write", lambda *args: update_step8())
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB")  

        # Graphical update function
        def update_graph8():

            plt.close("all")
            dp = float(var_dp.get())*(1/1000)            # Collector diameter (mm) a (m)
            dc = float(var_dc.get())*(1/1000)*(1/1000)   # Colloid diameter (um) a (m)
            U = float(var_U.get())*(1/24)*(1/3600)       # Pore water velocity (m/day) a (m/s)
            pc = float(var_pc.get())                     # Colloid density (kg/m3)
            pf = float(var_pf.get())                     # Fluid density (kg/m3)
            uf = float(var_uf.get())                     # Fluid viscosity (kg m/s)
            T = float(var_T.get())                       # Temperature (K)
            theta = float(var_theta.get())               # Porosity
            Ui = U*theta

            x8 = update_step8()
            H = x8
            gamma = (1 - theta)**(1/3)              
            As = (2*(1 - (gamma**5)))/(2 - (3*gamma) + (3*(gamma**5)) - (2*(gamma**6)))
            Kw = (5*(1 - (gamma**3)))/(5 - (9*gamma) + (5*(gamma**3)) - (1*(gamma**6)))
            D = (kB*T)/(6*np.pi*uf*(dc/2))   

            var_NR3 = dc/dp  
            var_NvdW3 = H/(kB*T) 
            var_NA3 = H/(12*np.pi*uf*((dp/2)**2)*Ui) 
            var_NG3 = (2*((dc/2)**2)*(pc - pf)*g)/(9*uf*Ui)
            var_NGi3 = 1/(1 + var_NG3) 
            var_NLo3 = H/(9*np.pi*uf*((dc/2)**2)*Ui) 
            var_NPe3 = (Ui*(dp))/D   

            n_RT8 = (gamma**2)*(4*As**(1/3))*(var_NPe3**(-2/3)) + As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.00338*As*(var_NG3**(1.2))*(var_NR3**(-0.4))
            n_NG8 = (gamma**(2))*(2.4*((As)**(1/3))*(((var_NPe3)/(var_NPe3 + 16))**(0.75))*((var_NPe3)**(-0.68))*((var_NLo3)**(0.015))*((var_NGi3)**(0.8))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NGi3/(var_NGi3 + 0.9))*var_NG3*((var_NR3)**(-0.05))  
            n_MPFJ8 = (gamma**2)*(((((8 + (4*(1 - gamma)*(As**(1/3))*(var_NPe3**(1/3))))/(8 + (1 - gamma)*(var_NPe3**(0.97))))*(var_NLo3**(0.015))*(var_NGi3**(0.8))*(var_NR3**(0.028))))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NR3**(-0.05))*var_NG3*(var_NGi3/(var_NGi3 + 0.9))
            n_TE8 = (2.4*(As**(1/3))*(var_NR3**(-0.081))*(var_NPe3**(-0.715))*(var_NvdW3**(0.052))) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                        (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            n_LH8 = (15.56)*((gamma**6)/((1 - (gamma**3))**(2)))*((var_NPe3)**(-0.65))*((var_NR3)**(0.19)) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                    (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            n_set8 = [n_RT8, n_MPFJ8, n_TE8, n_NG8, n_LH8]

            graphic_set_range8(x8, n_set8)

        check_var.set(0)
        check_var2.set(0)
        check_var3.set(0)
        check_var4.set(0)
        check_var5.set(0)
        check_var6.set(0)
        check_var7.set(0)
        check_var9.set(0)
        
        # Creation of the button to plot on the range 
        if boton_evaluate_range8 is None:
            boton_evaluate_range8 = ctk.CTkButton(frame_constante4, fg_color = "#77DD77", text = "Evaluate range", text_color = "black", font = ("Arial", 14, "bold"),
                                                  command = update_graph8)
            boton_evaluate_range8.grid(row = 5, column = 1, columnspan = 4, padx = 2, sticky = "e")

    # Disactive set range frame
    else:                                                                             
        color_inicial = "#A9A9A9"
        entry_Ns.configure(state = "disabled", fg_color = color_inicial)
        var_Ns.set("enable range")     
        entry_Lv.configure(state = "disabled", fg_color = color_inicial)
        var_Lv.set("enable range") 
        entry_Uv.configure(state = "disabled", fg_color = color_inicial)
        var_Uv.set("enable range") 
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB") 
        var_step.set(" ")

        # Title returns
        if Parameter is not None:
            Parameter8.destroy()
        Parameter8 = ctk.CTkLabel(frame_constante4, text = "Parameter                          ", font = ("Arial", 14, "bold"))
        Parameter8.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5)

        # Hides the range button
        if boton_evaluate_range8 is not None:                                        
            boton_evaluate_range8.grid_forget()  
            boton_evaluate_range8.destroy() 
            boton_evaluate_range8 = None                                            

## GRAPHIC OF SET RANGE OF HAMAKER CONSTANT (J)
def graphic_set_range8(x8, n_set8):
    
    plt.close("all")
    fig8, ax8 = plt.subplots(figsize = (6.5, 5.2))
    plt.gcf().canvas.manager.set_window_title("Collector Efficiency based on range")
    for j in range(len(Autors)): ax8.plot(x8, n_set8[j], label = Autors[j])
    ax8.set(xlabel = "Hamaker constant (J)", ylabel = "Ƞ")
    ax8.set_xlim([x8[0], x8[-1]]) 
    ax8.yaxis.set_major_formatter(ticker.ScalarFormatter())  
    ax8.ticklabel_format(style = "sci", axis = "y", scilimits = (0,0))
    ax8.legend(loc = "upper center", bbox_to_anchor = (0.5, -0.15), shadow = True, ncol = 3,
            fontsize = 8.5, handlelength = 1.4, labelspacing = 0.2, borderpad = 0.3)
    ax8.grid(True)
    plt.tight_layout()
    fig8.show()

## ==================================================================================================

## SET RANGE OF POROSITY 
def set_range9():

    global boton_evaluate_range9
    # Active set range frame
    if check_var9.get() == 1:                                                      
        color_inicial = "white"
        entry_Ns.configure(state = "normal", fg_color = color_inicial)                            
        entry_Lv.configure(state = "normal", fg_color = color_inicial)
        entry_Uv.configure(state = "normal", fg_color = color_inicial)
        entry_step.configure(state = "normal")

        # Change of title 
        if Parameter is not None:
            Parameter.destroy()
        Parameter9 = ctk.CTkLabel(frame_constante4, text = "Porosity      ", font = ("Arial", 14, "bold"))
        Parameter9.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5)

        # Warning message        
        lv = float(var_theta.get())*0.5
        uv = float(var_theta.get())*1.5
        ns = 10
        try:
            if lv < 0.1:
                messagebox.showwarning("Warming", "Porosity must be among\n0.1 - 0.8")
                lv = 0.1
                var_Lv.set(f"{lv:.2f}")
            else:
                var_Lv.set(f"{lv:.2f}")

            if uv > 0.8:
                messagebox.showwarning("Warming", "Porosity must be among\n0.1 - 0.8")
                uv = 0.8
                var_Uv.set(f"{uv:.2f}")
            else:
                var_Uv.set(f"{uv:.2f}")

            step9 = (uv - lv)/(ns - 1)
            var_step.set(f"{step9:.4e}")
            var_Ns.set(f"{ns}")
            
        except ValueError:
            pass

        # Step update function
        def update_step9():

            try:
                lv = float(var_Lv.get())
                uv = float(var_Uv.get())
                ns = int(var_Ns.get())
                if ns > 1:
                    step = (uv - lv)/(ns - 1)
                    var_step.set(f"{step:.5f}")
                    x9 = np.linspace(lv, uv, ns)
                    return x9
            except ValueError:
                pass
            
        var_Lv.trace_add("write", lambda *args: update_step9())
        var_Uv.trace_add("write", lambda *args: update_step9())
        var_Ns.trace_add("write", lambda *args: update_step9())
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB") 

        # Graphical update function
        def update_graph9(): 

            plt.close("all")
            dp = float(var_dp.get())*(1/1000)            # Collector diameter (mm) a (m)
            dc = float(var_dc.get())*(1/1000)*(1/1000)   # Colloid diameter (um) a (m)
            U = float(var_U.get())*(1/24)*(1/3600)       # Pore water velocity (m/day) a (m/s)
            pc = float(var_pc.get())                     # Colloid density (kg/m3)
            pf = float(var_pf.get())                     # Fluid density (kg/m3)
            uf = float(var_uf.get())                     # Fluid viscosity (kg m/s)
            T = float(var_T.get())                       # Temperature (K)
            H = float(var_H.get())                       # Mamaker constant(J)

            x9 = update_step9()
            theta = x9
            Ui = U*theta
            gamma = (1 - theta)**(1/3)              
            As = (2*(1 - (gamma**5)))/(2 - (3*gamma) + (3*(gamma**5)) - (2*(gamma**6)))
            Kw = (5*(1 - (gamma**3)))/(5 - (9*gamma) + (5*(gamma**3)) - (1*(gamma**6)))
            D = (kB*T)/(6*np.pi*uf*(dc/2))  

            var_NR3 = dc/dp  
            var_NvdW3 = H/(kB*T) 
            var_NA3 = H/(12*np.pi*uf*((dp/2)**2)*Ui) 
            var_NG3 = (2*((dc/2)**2)*(pc - pf)*g)/(9*uf*Ui)
            var_NGi3 = 1/(1 + var_NG3) 
            var_NLo3 = H/(9*np.pi*uf*((dc/2)**2)*Ui) 
            var_NPe3 = (Ui*(dp))/D   

            n_RT9 = (gamma**2)*(4*As**(1/3))*(var_NPe3**(-2/3)) + As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.00338*As*(var_NG3**(1.2))*(var_NR3**(-0.4))
            n_NG9 = (gamma**(2))*(2.4*((As)**(1/3))*(((var_NPe3)/(var_NPe3 + 16))**(0.75))*((var_NPe3)**(-0.68))*((var_NLo3)**(0.015))*((var_NGi3)**(0.8))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NGi3/(var_NGi3 + 0.9))*var_NG3*((var_NR3)**(-0.05))  
            n_MPFJ9 = (gamma**2)*(((((8 + (4*(1 - gamma)*(As**(1/3))*(var_NPe3**(1/3))))/(8 + (1 - gamma)*(var_NPe3**(0.97))))*(var_NLo3**(0.015))*(var_NGi3**(0.8))*(var_NR3**(0.028))))) + \
                    As*(var_NLo3**(1/8))*(var_NR3**(15/8)) + 0.7*(var_NR3**(-0.05))*var_NG3*(var_NGi3/(var_NGi3 + 0.9))
            n_TE9 = (2.4*(As**(1/3))*(var_NR3**(-0.081))*(var_NPe3**(-0.715))*(var_NvdW3**(0.052))) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                    (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            n_LH9 = (15.56)*((gamma**6)/((1 - (gamma**3))**(2)))*((var_NPe3)**(-0.65))*((var_NR3)**(0.19)) + (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125))) + \
                    (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
            n_set9 = [n_RT9, n_MPFJ9, n_TE9, n_NG9, n_LH9]

            graphic_set_range9(x9, n_set9)

        check_var.set(0)
        check_var2.set(0)
        check_var3.set(0)
        check_var4.set(0)
        check_var5.set(0)
        check_var6.set(0)
        check_var7.set(0)
        check_var8.set(0)

        # Creation of the button to plot on the range 
        if boton_evaluate_range9 is None:
            boton_evaluate_range9 = ctk.CTkButton(frame_constante4, fg_color = "#77DD77", text = "Evaluate range", text_color = "black", font = ("Arial", 14, "bold"),
                                                  command = update_graph9)
            boton_evaluate_range9.grid(row = 5, column = 1, columnspan = 4, padx = 0, sticky = "e")

    # Disactive set range frame
    else:                                                                             
        color_inicial = "#A9A9A9"
        entry_Ns.configure(state = "disabled", fg_color = color_inicial)
        var_Ns.set("enable range")     
        entry_Lv.configure(state = "disabled", fg_color = color_inicial)
        var_Lv.set("enable range") 
        entry_Uv.configure(state = "disabled", fg_color = color_inicial)
        var_Uv.set("enable range")
        entry_step.configure(state = "disabled", fg_color = "#EBEBEB") 
        var_step.set(" ") 

        # Title returns
        if Parameter is not None:
            Parameter9.destroy()
        Parameter9 = ctk.CTkLabel(frame_constante4, text = "Parameter  ", font = ("Arial", 14, "bold"))
        Parameter9.grid(row = 1, column = 0, columnspan = 2, sticky = 'w', padx = 5) 

        # Hides the range button
        if boton_evaluate_range9 is not None:                                       
            boton_evaluate_range9.grid_forget()  
            boton_evaluate_range9.destroy() 
            boton_evaluate_range9 = None                                                       

## GRAPHIC OF SET RANGE OF POROSITY 
def graphic_set_range9(x9, n_set9):
    
    plt.close("all")
    fig9, ax9 = plt.subplots(figsize = (6.5, 5.2))
    plt.gcf().canvas.manager.set_window_title("Collector Efficiency based on range")
    for j in range(len(Autors)): ax9.plot(x9, n_set9[j], label = Autors[j])
    ax9.set(xlabel = "Porosity", ylabel = "Ƞ")
    ax9.set_xlim([x9[0], x9[-1]]) 
    ax9.yaxis.set_major_formatter(ticker.ScalarFormatter())  
    ax9.ticklabel_format(style = "sci", axis = "y", scilimits = (0,0))
    ax9.legend(loc = "upper center", bbox_to_anchor = (0.5, -0.15), shadow = True, ncol = 3,
               fontsize = 8.5, handlelength = 1.4, labelspacing = 0.2, borderpad = 0.3)
    ax9.grid(True)
    plt.tight_layout()
    fig9.show()

## ==================================================================================================

## EFFICIENCY AND RATE COEFFICIENT CALCULATION PROCEDURE 
def resolution():

    global InC_Co, C_Co, n_total, n_diffusion, n_interception, n_gravity, D_numbers, kf, xd

    ## MAIN PARAMETERS
    dp = float(var_dp.get())*(1/1000)            # Collector diameter (mm) a (m)
    dc = float(var_dc.get())*(1/1000)*(1/1000)   # Colloid diameter (um) a (m)
    U = float(var_U.get())*(1/24)*(1/3600)       # Pore water velocity (m/day) a (m/s)
    pc = float(var_pc.get())                     # Colloid density (kg/m3)
    pf = float(var_pf.get())                     # Fluid density (kg/m3)
    uf = float(var_uf.get())                     # Fluid viscosity (kg m/s)
    T = float(var_T.get())                       # Temperature (K)
    H = float(var_H.get())                       # Mamaker constant(J)
    theta = float(var_theta.get())               # Porosity
    Sf = float(var_Sf.get())                     # Scale factor
    Cdd = float(var_Cdd.get())                   # Attachment Efficiency 
    Ui = U*theta

    ## VECTOR LENGTH (m)
    default_Lv, default_Ns = 0.001, 108
    xd = np.zeros(default_Ns)
    xd[0] = default_Lv
    for i in range(1, default_Ns): xd[i] = xd[i-1]*(1 + Sf)

    ## COMPLEMENTARY VARIABLES
    gamma = (1 - theta)**(1/3)             
    As = (2*(1 - (gamma**5)))/(2 - (3*gamma) + (3*(gamma**5)) - (2*(gamma**6)))
    Kw = (5*(1 - (gamma**3)))/(5 - (9*gamma) + (5*(gamma**3)) - (1*(gamma**6)))

    # Stkoes-Einstein equation
    D = (kB*T)/(6*np.pi*uf*(dc/2))                                                     

    ## CALCULATION OF DIMENSIONLESS NUMBERS
    texto_azul = "blue"

    # Aspect radio
    var_NR3 = dc/dp                                                                
    var_NR2 = f"{var_NR3:.2e}"
    NR.configure(state = "normal", text_color = texto_azul)                                        
    var_NR.set(var_NR2)
    NR.configure(state = "disabled")                                        

    # Peclet number
    var_NPe3 = (Ui*(dp))/D                                                         
    var_NPe2 = f"{var_NPe3:.2e}"
    NPe.configure(state = "normal", text_color = texto_azul)                                         
    var_NPe.set(var_NPe2)
    NPe.configure(state = "disabled")                                       

    # London number
    var_NLo3 = H/(9*np.pi*uf*((dc/2)**2)*Ui)                                       
    var_NLo2 = f"{var_NLo3:.2e}"
    NLO.configure(state = "normal", text_color = texto_azul)                                         
    var_NLo.set(var_NLo2)
    NLO.configure(state = "disabled")                                      

    # Gravity number
    var_NG3 = (2*((dc/2)**2)*(pc - pf)*g)/(9*uf*Ui)                                
    var_NG2 = f"{var_NG3:.2e}"
    NG.configure(state = "normal", text_color = texto_azul)                                         
    var_NG.set(var_NG2)
    NG.configure(state = "disabled")      

    # Gravity number from Nelson and Ginn, 2011
    var_NGi3 = 1/(1 + var_NG3)                                                    
    var_NGi2 = f"{var_NGi3:.2e}"
    NGi.configure(state = "normal", text_color = texto_azul)                                       
    var_NGi.set(var_NGi2)
    NGi.configure(state = "disabled")   

    # Attraction number
    var_NA3 = H/(12*np.pi*uf*((dp/2)**2)*Ui)                                       
    var_NA2 = f"{var_NA3:.2e}"
    NA.configure(state = "normal", text_color = texto_azul)                                          
    var_NA.set(var_NA2)
    NA.configure(state = "disabled")                                        

    # Van der Waals number
    var_NvdW3 = H/(kB*T)                                                           
    var_NvdW2 = f"{var_NvdW3:.2e}"
    Nvdw.configure(state = "normal", text_color = texto_azul)                                      
    var_Nvdw.set(var_NvdW2)
    Nvdw.configure(state = "disabled")    

    # =====================================================================================================
    ## Rajagopalan and Tien, 1976 in Molnar et al., 2015
                            
    # Diffusion efficiency 
    n_diffusion_RT3 = (gamma**2)*(4*As**(1/3))*(var_NPe3**(-2/3))
    n_diffusion_RT2 = f"{n_diffusion_RT3:.2e}"
    entry_n_RT_diffusion.configure(state = "normal", text_color = texto_azul)                          
    var_RT_diffusion.set(n_diffusion_RT2)
    entry_n_RT_diffusion.configure(state = "disabled") 

    # Interception efficiency
    n_interception_RT3 = As*(var_NLo3**(1/8))*(var_NR3**(15/8))
    n_interception_RT2 = f"{n_interception_RT3:.2e}"
    entry_n_RT_interception.configure(state = "normal", text_color = texto_azul)                          
    var_RT_interception.set(n_interception_RT2)
    entry_n_RT_interception.configure(state = "disabled") 

    # Gravity efficiency
    n_gravity_RT3 = 0.00338*As*(var_NG3**(1.2))*(var_NR3**(-0.4))
    n_gravity_RT2 = f"{n_gravity_RT3:.2e}"
    entry_n_RT_gravity.configure(state = "normal", text_color = texto_azul)                          
    var_RT_gravity.set(n_gravity_RT2)
    entry_n_RT_gravity.configure(state = "disabled") 

    # total efficiency
    n_RT = n_diffusion_RT3 + n_interception_RT3 + n_gravity_RT3
    n_RT2 = f"{n_RT:.2e}"
    entry_n_RT_total.configure(state = "normal", text_color = texto_azul)                          
    var_RT_total.set(n_RT2)
    entry_n_RT_total.configure(state = "disabled")  

    # Rate coefficients
    kf_RT3 = (-3/2)*(((1 - theta)**(1/3))/dp)*U*np.log(1 - n_RT)
    kfd_RT3 = kf_RT3*Cdd
    kf_RT2 = f"{kf_RT3:.2e}"
    kfRT.configure(state = "normal", text_color = texto_azul)                                     
    kf_RT.set(kf_RT2)
    kfRT.configure(state = "disabled")  
                                
    # Equation
    InC_Co_RT = - kfd_RT3*(xd/(U))
    C_Co_RT = np.exp(InC_Co_RT)

    # =====================================================================================================
    ## Nelson and Ginn, 2011

    # Diffusion efficiency 
    n_diffusion_NG3 = (gamma**2)*(2.4*((As)**(1/3))*(((var_NPe3)/(var_NPe3 + 16))**(0.75))*((var_NPe3)**(-0.68))*((var_NLo3)**(0.015))*((var_NGi3)**(0.8)))
    n_diffusion_NG2 = f"{n_diffusion_NG3:.2e}"
    entry_n_NG_diffusion.configure(state = "normal", text_color = texto_azul)                          
    var_NG_diffusion.set(n_diffusion_NG2)
    entry_n_NG_diffusion.configure(state = "disabled") 

    # Interception efficiency
    n_interception_NG3 = As*(var_NLo3**(1/8))*(var_NR3**(15/8))
    n_interception_NG2 = f"{n_interception_NG3:.2e}"
    entry_n_NG_interception.configure(state = "normal", text_color = texto_azul)                          
    var_NG_interception.set(n_interception_NG2)
    entry_n_NG_interception.configure(state = "disabled") 

    # Gravity efficiency
    n_gravity_NG3 = 0.7*(var_NGi3/(var_NGi3 + 0.9))*var_NG3*((var_NR3)**(-0.05))
    n_gravity_GN2 = f"{n_gravity_NG3:.2e}"
    entry_n_NG_gravity.configure(state = "normal", text_color = texto_azul)                          
    var_NG_gravity.set(n_gravity_GN2)
    entry_n_NG_gravity.configure(state = "disabled") 

    # Total efficiency
    n_NG = n_diffusion_NG3 + n_interception_NG3 + n_gravity_NG3                           
    n_NG2 = f"{n_NG:.2e}"
    entry_n_NG_total.configure(state = "normal", text_color = texto_azul)                            
    var_NG_total.set(n_NG2)
    entry_n_NG_total.configure(state = "disabled")   

    # Rate coefficients
    kf_NG3 = (-3/2)*(((1 - theta)**(1/3))/dp)*U*np.log(1 - n_NG)
    kfd_NG3 = kf_NG3*Cdd
    kf_NG2 = f"{kf_NG3:.2e}"
    kfNG.configure(state = "normal", text_color = texto_azul)                                   
    kf_NG.set(kf_NG2)
    kfNG.configure(state = "disabled")   

    # Equation
    InC_Co_NG = - kfd_NG3*(xd/U)
    C_Co_NG = np.exp(InC_Co_NG)

    # =====================================================================================================
    ## MPFJ equation Ma et al., 2009

    # Diffusion efficiency 
    n_diffusion_MPFJ3 = (gamma**2)*(((((8 + (4*(1 - gamma)*(As**(1/3))*(var_NPe3**(1/3))))/(8 + (1 - gamma)*(var_NPe3**(0.97))))*(var_NLo3**(0.015))*(var_NGi3**(0.8))*(var_NR3**(0.028)))))
    n_diffusion_MPFJ2 = f"{n_diffusion_MPFJ3:.2e}"
    entry_n_MPFJ_diffusion.configure(state = "normal", text_color = texto_azul)                          
    var_MPFJ_diffusion.set(n_diffusion_MPFJ2)
    entry_n_MPFJ_diffusion.configure(state = "disabled") 

    # Interception efficiency
    n_interception_MPFJ3 = As*(var_NLo3**(1/8))*(var_NR3**(15/8))
    n_interception_MPFJ2 = f"{n_interception_MPFJ3:.2e}"
    entry_n_MPFJ_interception.configure(state = "normal", text_color = texto_azul)                          
    var_MPFJ_interception.set(n_interception_MPFJ2)
    entry_n_MPFJ_interception.configure(state = "disabled") 

    # Gravity efficiency
    n_gravity_MPFJ3 = 0.7*(var_NR3**(-0.05))*var_NG3*(var_NGi3/(var_NGi3 + 0.9))
    n_gravity_MPFJ2 = f"{n_gravity_MPFJ3:.2e}"
    entry_n_MPFJ_gravity.configure(state = "normal", text_color = texto_azul)                          
    var_MPFJ_gravity.set(n_gravity_MPFJ2)
    entry_n_MPFJ_gravity.configure(state = "disabled") 

    # Total efficiency
    n_MPFJ = n_diffusion_MPFJ3 + n_interception_MPFJ3 + n_gravity_MPFJ3
    n_MPFJ2 = f"{n_MPFJ:.2e}"
    entry_n_MPFJ_total.configure(state = "normal", text_color = texto_azul)                          
    var_MPFJ_total.set(n_MPFJ2)
    entry_n_MPFJ_total.configure(state = "disabled")         

    # Rate coefficients
    B = (3 - theta)/(3 - (3*theta))
    kf_MPFJ3 = (-3/2)*((1 - theta)/dp)*U*np.log(1 - n_MPFJ)*(B - ((2/np.pi)*(B)*(np.arccos((1/B)**(1/2)))) + (2/np.pi)*np.sqrt(2*(B**(0.5)) - 1))
    kfd_MPFJ3 = kf_MPFJ3*Cdd
    kf_MPFJ2 = f"{kf_MPFJ3:.2e}"
    kfMPFJ.configure(state = "normal", text_color = texto_azul)                                    
    kf_MPFJ.set(kf_MPFJ2)
    kfMPFJ.configure(state = "disabled")   

    # Equation
    InC_Co_MPFJ = - kfd_MPFJ3*(xd/U)
    C_Co_MPFJ = np.exp(InC_Co_MPFJ)

    # =====================================================================================================
    ## Tufenkji & Elimelech, 2004 

    # Diffusion efficiency 
    n_diffusion_TE3 = (2.4*(As**(1/3))*(var_NR3**(-0.081))*(var_NPe3**(-0.715))*(var_NvdW3**(0.052)))
    n_diffusion_TE2 = f"{n_diffusion_TE3:.2e}"
    entry_n_TE_diffusion.configure(state = "normal", text_color = texto_azul)                          
    var_TE_diffusion.set(n_diffusion_TE2)
    entry_n_TE_diffusion.configure(state = "disabled") 

    # Interception efficiency
    n_interception_TE3 = (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125)))
    n_interception_TE2 = f"{n_interception_TE3:.2e}"
    entry_n_TE_interception.configure(state = "normal", text_color = texto_azul)                          
    var_TE_interception.set(n_interception_TE2)
    entry_n_TE_interception.configure(state = "disabled") 

    # Gravity efficiency
    n_gravity_TE3 = (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
    n_gravity_TE2 = f"{n_gravity_TE3:.2e}"
    entry_n_TE_gravity.configure(state = "normal", text_color = texto_azul)                          
    var_TE_gravity.set(n_gravity_TE2)
    entry_n_TE_gravity.configure(state = "disabled") 

    # Total efficiency
    n_TE = n_diffusion_TE3 + n_interception_TE3 + n_gravity_TE3
    n_TE2 = f"{n_TE:.2e}"
    entry_n_TE_total.configure(state = "normal", text_color = texto_azul)                        
    var_TE_total.set(n_TE2)
    entry_n_TE_total.configure(state = "disabled")  

    # Rate coefficients
    kf_TE3 = (-3/2)*((1 - theta)/dp)*U*np.log(1 - n_TE)
    kfd_TE3 = kf_TE3*Cdd
    kf_TE2 = f"{kf_TE3:.2e}"
    kfTE.configure(state = "normal", text_color = texto_azul)                                      
    kf_TE.set(kf_TE2)
    kfTE.configure(state = "disabled")                                  

    # Equation
    InC_Co_TE = - kfd_TE3*(xd/U)
    C_Co_TE = np.exp(InC_Co_TE)

    # =====================================================================================================
    # Long and Hilpert, 2009  

    # Diffusion efficiency 
    n_diffusion_LH3 = (15.56)*((gamma**6)/((1 - (gamma**3))**(2)))*((var_NPe3)**(-0.65))*((var_NR3)**(0.19))
    n_diffusion_LH2 = f"{n_diffusion_LH3:.2e}"
    entry_n_LH_diffusion.configure(state = "normal", text_color = texto_azul)                          
    var_LH_diffusion.set(n_diffusion_LH2)
    entry_n_LH_diffusion.configure(state = "disabled") 

    # Interception efficiency
    n_interception_LH3 = (0.55*As*(var_NR3**(1.675))*(var_NA3**(0.125)))
    n_interception_LH2 = f"{n_interception_LH3:.2e}"
    entry_n_LH_interception.configure(state = "normal", text_color = texto_azul)                          
    var_LH_interception.set(n_interception_LH2)
    entry_n_LH_interception.configure(state = "disabled") 

    # Gravity efficiency
    n_gravity_LH3 = (0.22*(var_NR3**(-0.24))*(var_NG3**(1.11))*(var_NvdW3**(0.053)))
    n_gravity_LH2 = f"{n_gravity_LH3:.2e}"
    entry_n_LH_gravity.configure(state = "normal", text_color = texto_azul)                          
    var_LH_gravity.set(n_gravity_LH2)
    entry_n_LH_gravity.configure(state = "disabled") 

    # Total efficiency
    n_LH = n_diffusion_LH3 + n_interception_LH3 + n_gravity_LH3
    n_LH2 = f"{n_LH:.2e}"
    entry_n_LH_total.configure(state = "normal", text_color = texto_azul)                          
    var_LH_total.set(n_LH2)
    entry_n_LH_total.configure(state = "disabled")  

    # Rate coefficients
    kf_LH3 = (-3/2)*((1 - theta)/dp)*U*np.log(1 - n_LH)
    kfd_LH3 = kf_LH3*Cdd
    kf_LH2 = f"{kf_LH3:.2e}"
    kfLH.configure(state = "normal", text_color = texto_azul)                                       
    kf_LH.set(kf_LH2)
    kfLH.configure(state = "disabled")    

    # Equation
    InC_Co_LH = - kfd_LH3*(xd/U)
    C_Co_LH = np.exp(InC_Co_LH)

    # =====================================================================================================
    # Lists of efficiency results 
    n_total = [n_RT, n_MPFJ, n_TE, n_NG, n_LH]
    InC_Co = [InC_Co_RT, InC_Co_MPFJ, InC_Co_TE, InC_Co_NG, InC_Co_LH]
    C_Co = [C_Co_RT, C_Co_MPFJ, C_Co_TE,  C_Co_NG, C_Co_LH]
    n_diffusion = [n_diffusion_RT3, n_diffusion_MPFJ3, n_diffusion_TE3, n_diffusion_NG3, n_diffusion_LH3]
    n_interception = [n_interception_RT3, n_interception_MPFJ3, n_interception_LH3, n_interception_TE3, n_interception_NG3]
    n_gravity = [n_gravity_RT3, n_gravity_MPFJ3, n_gravity_LH3, n_gravity_TE3, n_gravity_NG3]
    D_numbers = [var_NR3, var_NLo3, var_NvdW3, var_NA3, var_NPe3, var_NG3, var_NGi3]
    kf = [kf_RT3, kf_MPFJ3, kf_TE3, kf_NG3, kf_LH3]

    # Activate the save button
    boton3.grid(row = 2, column = 0, padx = 10, pady = 5)

    # Presentation of the graph
    graphics(C_Co, xd)

## ==================================================================================================

## GRAPH OF THE CONCENTRATION RATIO FOR EACH AUTHOR
def graphics(C_Co, xd):

    Sf = float(var_Sf.get()) 

    # Find global minimum and maximum
    all_values = [val for sublist in C_Co for val in sublist]
    ymin = min(all_values)
    ymax = max(all_values)

    fig, ax = plt.subplots(figsize = (7.7, 4.7))
    plt.gcf().canvas.manager.set_window_title("Retained Profile based on main parameters")
    for j in range(len(Autors)): ax.plot(xd, C_Co[j], label = Autors[j])
    ax.set(xlabel = "Column length (m)", ylabel = "C/Co")
    ax.set_ylim(ymin - (Sf/2), ymax + (Sf/2))
    if Sf <= 0.01: 
        ax.ticklabel_format(style = "sci", axis = "x", scilimits = (0,0))
        ax.ticklabel_format(style = "sci", axis = "x", scilimits = (0,0))
    ax.legend(loc = "center left", bbox_to_anchor = (1.05, 0.5), shadow = True, ncol = 1,
               fontsize = 8.5, handlelength = 1.4, labelspacing = 0.2, borderpad = 0.3)
    ax.grid(True)
    plt.tight_layout()
    fig.show()

## ==================================================================================================

## STORE ALL DATA AND CALCULATIONS OBTAINED 
def save_to_file():

    global Input_parameters_table, D_adimensionaless_table, kf_table, Number_Retained_table, n_table
    
    # Entered data 
    dp = float(var_dp.get())*(1/1000)            # Collector diameter (mm) a (m)
    dc = float(var_dc.get())*(1/1000)*(1/1000)   # Colloid diameter (um) a (m)
    U = float(var_U.get())*(1/24)*(1/3600)       # Pore water velocity (m/day) a (m/s)
    pc = float(var_pc.get())                     # Colloid density (kg/m3)
    pf = float(var_pf.get())                     # Fluid density (kg/m3)
    uf = float(var_uf.get())                     # Fluid viscosity (kg m/s)
    T = float(var_T.get())                       # Temperature (K)
    H = float(var_H.get())                       # Mamaker constant(J)
    theta = float(var_theta.get())               # Porosity
    Cdd = float(var_Cdd.get())                      # Attachment Efficiency 

    # Main parameters
    Main_p = ["Collector diameter (mm)", "Colloid diameter (um)", "Pore water velocity (m/day)", "Colloid density (kg/m3)",
              "Fluid density (kg/m3)", "Fluid viscosity (kg m/s)", "Temperature (K)", "Mamaker constant (J)", "Porosity (-)", "Attachment_efficienty (-)"]
    Imput_p = [dp*(1000) , dc*(1000*1000), U*(24*3600) , pc, pf, uf, T, H, theta, Cdd]
    Input_parameters_data  = {"Main_parameters": Main_p,"Input_parameters": Imput_p}
    Input_parameters_table = pd.DataFrame(Input_parameters_data) 

    # Dimensionless numbers
    D_numbers_title = ["NR", "NLo", "Nvdw", "NA", "NPe", "NG", "NGi"]
    D_adimensionaless_data = {"Dimensional numbers": D_numbers_title, " ": D_numbers}   
    D_adimensionaless_table = pd.DataFrame(D_adimensionaless_data)

    # Rate coefficients (1/s)
    kf_data = {"Autors": Autors, "kf (1/s)": kf} 
    kf_table = pd.DataFrame(kf_data) 

    # Total, diffusion, interception and gravity efficiency
    n_data = {"Autors": Autors, "total": n_total, "diffusion": n_diffusion, "interception": n_interception, "gravity": n_gravity}
    n_table = pd.DataFrame(n_data)

    # Number_Retained
    Number_Retained_data = {"x [m]": xd, "Rajagopalan and Tien, 1976": C_Co[0], "MPFJ equation Ma et al., 2009": C_Co[1],
                            "Tufenkji & Elimelech, 2004": C_Co[2], "Nelson and Ginn, 2011": C_Co[3], "Long and Hilpert, 2009": C_Co[4]}
    Number_Retained_table = pd.DataFrame(Number_Retained_data)

    ## SAVE THE INFORMATION IN AN EXCEL FILE  

    # Option for file name and location selection
    file_path = filedialog.asksaveasfilename(defaultextension = ".xlsx", filetypes = [("Excel files", "*.xlsx")],
                                             title = "Guardar archivo", initialfile = "output_CorrEqs.xlsx")
    if file_path:
        with pd.ExcelWriter(file_path) as writer:
            Input_parameters_table.to_excel(writer, sheet_name = "Input_Parameters", index = False)
            D_adimensionaless_table.to_excel(writer, sheet_name = "Dimensional_numbers", index = False)
            n_table.to_excel(writer, sheet_name = "Collector_efficiency", index = False)
            kf_table.to_excel(writer, sheet_name = "Rate_coefficients_(s-1)", index = False)
            Number_Retained_table.to_excel(writer, sheet_name = "Number_Retained", index = False)
       
## ==================================================================================================

## DEVELOPMENT OF THE GRAPHICAL INTERFACE
ctk.set_appearance_mode("Light")             # Appearance: Light, Danrk o System 
ctk.set_default_color_theme("green")         # Theme: green, blue 

# Create the main window 
app = ctk.CTk()
app.title("CorrelationEqs_GUI")
app.geometry(f"{app.winfo_screenwidth()+50}x{app.winfo_screenheight()-50}-10+0")

# Configure rows and columns for main window expansion
app.grid_rowconfigure(0, weight = 1)  
app.grid_columnconfigure(0, weight = 1)

# Create a main frame
main_frame = ctk.CTkFrame(app, corner_radius = 10, width = 800, height = 600, fg_color = "#EBEBEB")
main_frame.grid(row = 0, column = 0, sticky = "nsew")
main_frame.grid_rowconfigure(0, weight = 1)
main_frame.grid_columnconfigure(0, weight = 1)

# Main Parameters
var_dp = ctk.StringVar(value = 0.2)          # Collector diameter (mm)
var_dc = ctk.StringVar(value = 1)            # Colloid diameter (um)
var_U = ctk.StringVar(value = 7.1)           # Pore water velocity (m/day)
var_pc = ctk.StringVar(value = 1055)         # Colloid density (kg/m3)
var_pf = ctk.StringVar(value = 998)          # Fluid density (kg/m3)
var_uf = ctk.StringVar(value = 9.8e-4)       # Fluid viscosity (kg m/s)
var_T = ctk.StringVar(value = 298.2)         # Temperature (K)
var_H = ctk.StringVar(value = 3.84e-21)      # Mamaker constant(J)
var_theta = ctk.StringVar(value = 0.4)       # Porosity

# Distribution Main Parameters
frame_constante = ctk.CTkFrame(main_frame, width = 460, height = 100, fg_color = "#EBEBEB")
ctk.CTkLabel(frame_constante, text = "Main Parameters", font = ("Arial", 16, "bold"), fg_color = "#CFCFCF").grid(row = 0, column = 0, columnspan = 3, sticky = "ew", pady = 10)
Entry_dp = ctk.CTkEntry(frame_constante, textvariable = var_dp, width = 100, justify = "center")
Entry_dp.grid(row = 1, column = 0, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante, text = "Collector diameter (mm)").grid(row = 1, column = 1, sticky = 'w', padx = 10)
check_var = ctk.IntVar(value = 0)
ctk.CTkCheckBox(frame_constante, text = "evalue range", variable = check_var, command = lambda *args: set_range()).grid(row = 1, column = 2, sticky = 'w', padx = 40)
Entry_dc = ctk.CTkEntry(frame_constante, textvariable = var_dc, width = 100, justify = "center")
Entry_dc.grid(row = 2, column = 0, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante, text = "Colloid diameter (um)").grid(row = 2, column = 1, sticky = 'w', padx = 10)
check_var2 = ctk.IntVar(value = 0)
ctk.CTkCheckBox(frame_constante, text = "evalue range", variable = check_var2, command = lambda *args: set_range2()).grid(row = 2, column = 2, sticky = 'w', padx = 40)
Entry_U = ctk.CTkEntry(frame_constante, textvariable = var_U, width = 100, justify = "center")
Entry_U.grid(row = 3, column = 0, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante, text = "Pore water velocity (m/day)").grid(row = 3, column = 1, sticky = 'w', padx = 10)
check_var3 = ctk.IntVar(value = 0)
ctk.CTkCheckBox(frame_constante, text = "evalue range", variable = check_var3, command = lambda *args: set_range3()).grid(row = 3, column = 2, sticky = 'w', padx = 40)
Entry_pc = ctk.CTkEntry(frame_constante, textvariable = var_pc, width = 100, justify = "center")
Entry_pc.grid(row = 4, column = 0, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante, text = "Colloid density (kg/m3)").grid(row = 4, column = 1, sticky = 'w', padx = 10)
check_var4 = ctk.IntVar(value = 0)
ctk.CTkCheckBox(frame_constante, text = "evalue range", variable = check_var4, command = lambda *args: set_range4()).grid(row = 4, column = 2, sticky = 'w', padx = 40)
Entry_pf = ctk.CTkEntry(frame_constante, textvariable = var_pf, width = 100, justify = "center")
Entry_pf.grid(row = 5, column = 0, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante, text = "Fluid density (kg/m3)").grid(row = 5, column = 1, sticky = 'w', padx = 10)
check_var5 = ctk.IntVar(value = 0)
ctk.CTkCheckBox(frame_constante, text = "evalue range", variable = check_var5, command = lambda *args: set_range5()).grid(row = 5, column = 2, sticky = 'w', padx = 40)
Entry_uf = ctk.CTkEntry(frame_constante, textvariable = var_uf, width = 100, justify = "center")
Entry_uf.grid(row = 6, column = 0, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante, text = "Fluid viscosity (kg m/s)").grid(row = 6, column = 1, sticky = 'w', padx = 10)
check_var6 = ctk.IntVar(value = 0)
ctk.CTkCheckBox(frame_constante, text = "evalue range", variable = check_var6, command = lambda *args: set_range6()).grid(row = 6, column = 2, sticky = 'w', padx = 40)
Entry_T = ctk.CTkEntry(frame_constante, textvariable = var_T, width = 100, justify = "center")
Entry_T.grid(row = 7, column = 0, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante, text = "Temperature (K)").grid(row = 7, column = 1, sticky = 'w', padx = 10)
check_var7 = ctk.IntVar(value = 0)
ctk.CTkCheckBox(frame_constante, text = "evalue range", variable = check_var7, command = lambda *args: set_range7()).grid(row = 7, column = 2, sticky = 'w', padx = 40)
Entry_H = ctk.CTkEntry(frame_constante, textvariable = var_H, width = 100, justify = "center")
Entry_H.grid(row = 8, column = 0, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante, text = "Hamaker constant (J)").grid(row = 8, column = 1, sticky = 'w', padx = 10)
check_var8 = ctk.IntVar(value = 0)
ctk.CTkCheckBox(frame_constante, text = "evalue range", variable = check_var8, command = lambda *args: set_range8()).grid(row = 8, column = 2, sticky = 'w', padx = 40)
Entry_theta = ctk.CTkEntry(frame_constante, textvariable = var_theta, width = 100, justify = "center")
Entry_theta.grid(row = 9, column = 0, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante, text = "Porosity").grid(row = 9, column = 1, sticky = 'w', padx = 10)
check_var9 = ctk.IntVar(value = 0)
ctk.CTkCheckBox(frame_constante, text = "evalue range", variable = check_var9, command = lambda *args: set_range9()).grid(row = 9, column = 2, sticky = 'w', padx = 40)
frame_constante.grid(row = 0, column = 0, sticky = 'nsew', pady = 10, padx = 10)

# Profile parameters
var_Sf = ctk.StringVar(value = 0.06)            # Scale factor
var_Cdd = ctk.StringVar(value = 0.08)           # Attachment Efficiency 

# Distribution profile parameters
frame_constante2 = ctk.CTkFrame(main_frame, width = 1000, height = 70, fg_color = "#EBEBEB")
frame_constante2.grid(row = 1, column = 0, columnspan = 2, sticky = 'nsew', pady = 30, padx = 10)
frame_constante2.grid_rowconfigure(2, weight = 1)
frame_constante2.grid_columnconfigure(10, weight = 1)

frame_constante3 = ctk.CTkFrame(frame_constante2, width = 400, height = 30, fg_color = "#EBEBEB")
ctk.CTkLabel(frame_constante3, text = "     Profile Parameters     ", font = ("Arial", 16, "bold"), fg_color = "#CFCFCF").grid(row = 0, column = 0, columnspan = 2, sticky = "ew", pady = 10)
label_scale_factor = ctk.CTkLabel(frame_constante3, text = "     Scale factor")
label_scale_factor.grid(row = 1, column = 0, sticky = 'w', padx = 30)
ToolTip(label_scale_factor, text = "Indicates the length step to follow to generate the C/Co vs column length plot.")
ctk.CTkEntry(frame_constante3, textvariable = var_Sf, width = 100, justify = "center").grid(row = 2, column = 0, sticky = 'w', padx = 30)
label_attachment_efficiency = ctk.CTkLabel(frame_constante3, text = "Attachment Efficiency")
label_attachment_efficiency.grid(row = 3, column = 0, sticky = 'w', padx = 18)
ToolTip(label_attachment_efficiency, text = "Corresponds to Attachment Efficiency that is applied to the Rate coefficients.")
ctk.CTkEntry(frame_constante3, textvariable = var_Cdd, width = 100, justify = "center").grid(row = 4, column = 0, sticky = 'w', padx = 30)
frame_constante3.grid(row = 1, column = 0, sticky = 'nsew', pady = 0)
boton_calcultate = ctk. CTkButton(frame_constante2, command = resolution, text = "Calculate", width = 150, fg_color = "#77DD77", text_color = "black",  font = ("Arial", 16, "bold"))
boton_calcultate.grid(row = 4, column = 1, columnspan = 2, padx = 0, sticky = "w")

# Set Range 
var_Lv = ctk.StringVar(value = "enable range")             # Lower Value
var_Uv = ctk.StringVar(value = "enable range")             # Upper Value
var_Ns = ctk.StringVar(value = "enable range")             # Number of Steps
var_step = ctk.StringVar(value = " ")
color_inicial = "#A9A9A9"

# Distribution Set Range 
frame_constante4 = ctk.CTkFrame(frame_constante2, width = 200, height = 20, fg_color = "#EBEBEB")
ctk.CTkLabel(frame_constante4, text = "Set Range", font = ("Arial", 16, "bold"), fg_color = "#CFCFCF").grid(row = 0, column = 0, columnspan = 3, sticky = "ew", pady = 10)
Parameter = ctk.CTkLabel(frame_constante4, text = "Parameter", font = ("Arial", 14, "bold")).grid(row = 1, column = 0, sticky = 'w', padx = 5)
ctk.CTkLabel(frame_constante4, text = "  Lower Value").grid(row = 2, column = 0, sticky = 'w', padx = 5)
ctk.CTkLabel(frame_constante4, text = "  Step").grid(row = 2, column = 1, sticky = 'w', padx = 33)
entry_step = ctk.CTkEntry(frame_constante4, textvariable = var_step, width = 90, justify = "center", fg_color = "#EBEBEB", border_color = "#EBEBEB", state = "disabled")
entry_step.grid(row = 3, column = 1, sticky = 'w', padx = 10)
ctk.CTkLabel(frame_constante4, text = "Upper Value").grid(row = 2, column = 2, sticky = 'w', padx = 10)
entry_Lv = ctk.CTkEntry(frame_constante4, textvariable = var_Lv, width = 90, justify = "center", fg_color = color_inicial, state = "disabled")
entry_Lv.grid(row = 3, column = 0, sticky = 'w')
entry_Uv = ctk.CTkEntry(frame_constante4, textvariable = var_Uv, width = 90, justify = "center", fg_color = color_inicial, state = "disabled")
entry_Uv.grid(row = 3, column = 2, sticky = 'w', padx = 0)
ctk.CTkLabel(frame_constante4, text = "Number of Steps").grid(row = 4, column = 0, columnspan = 2, sticky = 'w', padx = 5)
entry_Ns = ctk.CTkEntry(frame_constante4, textvariable = var_Ns, width = 90, justify = "center", fg_color = color_inicial, state = "disabled")
entry_Ns.grid(row = 5, column = 0, columnspan = 2, sticky = 'w', padx  = 8)
boton_evaluate_range = ctk. CTkButton(frame_constante4, text = "Evaluate range", fg_color = "#77DD77", text_color = "black", font = ("Arial", 14, "bold"))
boton_evaluate_range.grid_forget()
frame_constante4.grid(row = 1, column = 1, sticky = 'nsew', padx = 5, pady = 0)
boton_evaluate_range1 = None
boton_evaluate_range2 = None
boton_evaluate_range3 = None
boton_evaluate_range4 = None
boton_evaluate_range5 = None
boton_evaluate_range6 = None
boton_evaluate_range7 = None
boton_evaluate_range8 = None
boton_evaluate_range9 = None

# Single Collector Efficiencies
var_RT_total = ctk.StringVar(value = "calculate")                  # Ragojapalan & Tien (1976) total 
var_RT_diffusion = ctk.StringVar(value = "calculate")              # Ragojapalan & Tien (1976) diffusion 
var_RT_interception = ctk.StringVar(value = "calculate")           # Ragojapalan & Tien (1976) interception
var_RT_gravity = ctk.StringVar(value = "calculate")                # Ragojapalan & Tien (1976) gravity
var_TE_total = ctk.StringVar(value = "calculate")                  # Tufenkji and Elimelech (2004) total             
var_TE_diffusion = ctk.StringVar(value = "calculate")              # Tufenkji and Elimelech (2004) diffusion    
var_TE_interception = ctk.StringVar(value = "calculate")           # Tufenkji and Elimelech (2004) interception    
var_TE_gravity = ctk.StringVar(value = "calculate")                # Tufenkji and Elimelech (2004) gravity    
var_MPFJ_total = ctk.StringVar(value = "calculate")                # Ma, Pedel, Fife & Johnson (2015) total 
var_MPFJ_diffusion = ctk.StringVar(value = "calculate")            # Ma, Pedel, Fife & Johnson (2015) diffusion
var_MPFJ_interception = ctk.StringVar(value = "calculate")         # Ma, Pedel, Fife & Johnson (2015) interception
var_MPFJ_gravity = ctk.StringVar(value = "calculate")              # Ma, Pedel, Fife & Johnson (2015) gravity
var_LH_total = ctk.StringVar(value = "calculate")                  # Long & Hilpert (2011) total
var_LH_diffusion = ctk.StringVar(value = "calculate")              # Long & Hilpert (2011) diffusion
var_LH_interception = ctk.StringVar(value = "calculate")           # Long & Hilpert (2011) interception
var_LH_gravity = ctk.StringVar(value = "calculate")                # Long & Hilpert (2011) gravity
var_NG_total = ctk.StringVar(value = "calculate")                  # Nelson & Ginn (2011) total
var_NG_diffusion = ctk.StringVar(value = "calculate")              # Nelson & Ginn (2011) diffusion
var_NG_interception = ctk.StringVar(value = "calculate")           # Nelson & Ginn (2011) interception
var_NG_gravity = ctk.StringVar(value = "calculate")                # Nelson & Ginn (2011) gravity

# Distribution Single Collector Efficiencies
texto_rojo = "red"
frame_constantet = ctk.CTkFrame(main_frame, width = 120, height = 200, fg_color = "#EBEBEB")
ctk.CTkLabel(frame_constantet, text = "Parti-Suite: Correlation Equations", font = ("Arial", 22, "bold"), fg_color = "#CFCFCF", width = 10).grid(row = 0, column = 0, sticky = "ew", columnspan = 5, pady = 10)  
frame_constante5 = ctk.CTkFrame(frame_constantet, width = 80, height = 200, fg_color = "#EBEBEB")
ctk.CTkLabel(frame_constante5, text = "Single Collector Efficiencies", font = ("Arial", 16, "bold")).grid(row = 0, column = 0, columnspan = 5, sticky = "ew")
ctk.CTkLabel(frame_constante5, text = "Ƞ", font = ("Arial", 14, "bold")).grid(row = 1, column = 3, sticky = 'w', padx = 10)
# Total efficiency
ctk.CTkLabel(frame_constante5, text = "total", font = ("Arial", 14, "bold")).grid(row = 2, column = 1, sticky = 'w', padx = 70)
entry_n_RT_total = ctk.CTkEntry(frame_constante5, textvariable = var_RT_total, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_RT_total.grid(row = 3, column = 1, sticky = 'w', padx = 35)
entry_n_TE_total = ctk.CTkEntry(frame_constante5, textvariable = var_TE_total, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_TE_total.grid(row = 4, column = 1, sticky = 'w', padx = 35)
entry_n_MPFJ_total = ctk.CTkEntry(frame_constante5, textvariable = var_MPFJ_total, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_MPFJ_total.grid(row = 5, column = 1, sticky = 'w', padx = 35)
entry_n_LH_total = ctk.CTkEntry(frame_constante5, textvariable = var_LH_total, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_LH_total.grid(row = 6, column = 1, sticky = 'w', padx = 35)
entry_n_NG_total = ctk.CTkEntry(frame_constante5, textvariable = var_NG_total, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_NG_total.grid(row = 7, column = 1, sticky = 'w', padx = 35)
# Diffusion efficiency
ctk.CTkLabel(frame_constante5, text = "diffusion", font = ("Arial", 14, "bold")).grid(row = 2, column = 2, sticky = 'w', padx = 40)
entry_n_RT_diffusion = ctk.CTkEntry(frame_constante5, textvariable = var_RT_diffusion, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_RT_diffusion.grid(row = 3, column = 2, sticky = 'w', padx = 20)
entry_n_TE_diffusion = ctk.CTkEntry(frame_constante5, textvariable = var_TE_diffusion, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_TE_diffusion.grid(row = 4, column = 2, sticky = 'w', padx = 20)
entry_n_MPFJ_diffusion = ctk.CTkEntry(frame_constante5, textvariable = var_MPFJ_diffusion, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_MPFJ_diffusion.grid(row = 5, column = 2, sticky = 'w', padx = 20)
entry_n_LH_diffusion = ctk.CTkEntry(frame_constante5, textvariable = var_LH_diffusion, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_LH_diffusion.grid(row = 6, column = 2, sticky = 'w', padx = 20)
entry_n_NG_diffusion = ctk.CTkEntry(frame_constante5, textvariable = var_NG_diffusion, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_NG_diffusion.grid(row = 7, column = 2, sticky = 'w', padx = 20)
# Interception efficiency
ctk.CTkLabel(frame_constante5, text = "interception", font = ("Arial", 14, "bold")).grid(row = 2, column = 3, sticky = 'w', padx = 45)
entry_n_RT_interception = ctk.CTkEntry(frame_constante5, textvariable = var_RT_interception, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_RT_interception.grid(row = 3, column = 3, sticky = 'w', padx = 35)
entry_n_TE_interception = ctk.CTkEntry(frame_constante5, textvariable = var_TE_interception, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_TE_interception.grid(row = 4, column = 3, sticky = 'w', padx = 35)
entry_n_MPFJ_interception = ctk.CTkEntry(frame_constante5, textvariable = var_MPFJ_interception, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_MPFJ_interception.grid(row = 5, column = 3, sticky = 'w', padx = 35)
entry_n_LH_interception = ctk.CTkEntry(frame_constante5, textvariable = var_LH_interception, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_LH_interception.grid(row = 6, column = 3, sticky = 'w', padx = 35)
entry_n_NG_interception = ctk.CTkEntry(frame_constante5, textvariable = var_NG_interception, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_NG_interception.grid(row = 7, column = 3, sticky = 'w', padx = 35)
# Gravity efficiency
ctk.CTkLabel(frame_constante5, text = "gravity", font = ("Arial", 14, "bold")).grid(row = 2, column = 4, sticky = 'w', padx = 46)
entry_n_RT_gravity= ctk.CTkEntry(frame_constante5, textvariable = var_RT_gravity, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_RT_gravity.grid(row = 3, column = 4, sticky = 'w', padx = 20)
entry_n_TE_gravity = ctk.CTkEntry(frame_constante5, textvariable = var_TE_gravity, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_TE_gravity.grid(row = 4, column = 4, sticky = 'w', padx = 20)
entry_n_MPFJ_gravity = ctk.CTkEntry(frame_constante5, textvariable = var_MPFJ_gravity, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_MPFJ_gravity.grid(row = 5, column = 4, sticky = 'w', padx = 20)
entry_n_LH_gravity = ctk.CTkEntry(frame_constante5, textvariable = var_LH_gravity, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_LH_gravity.grid(row = 6, column = 4, sticky = 'w', padx = 20)
entry_n_NG_gravity = ctk.CTkEntry(frame_constante5, textvariable = var_NG_gravity, text_color = texto_rojo, width = 100, justify = "center", state = "disabled", fg_color = "#EBEBEB", border_color = "#EBEBEB")
entry_n_NG_gravity.grid(row = 7, column = 4, sticky = 'w', padx = 20)
# Autors
ctk.CTkLabel(frame_constante5, text = "Ragojapalan & Tien (1976)").grid(row = 3, column = 0, sticky = 'w', padx = 5)
ctk.CTkLabel(frame_constante5, text = "Tufenkji and Elimelech (2004)").grid(row = 4, column = 0, sticky = 'w', padx = 5)
ctk.CTkLabel(frame_constante5, text = "Ma, Pedel, Fife & Johnson (2015)").grid(row = 5, column = 0, sticky = 'w', padx = 5)
ctk.CTkLabel(frame_constante5, text = "Long & Hilpert (2011)").grid(row = 6, column = 0, sticky = 'w', padx = 5)
ctk.CTkLabel(frame_constante5, text = "Nelson & Ginn (2011)").grid(row = 7, column = 0, sticky = 'w', padx = 5)
ctk.CTkLabel(frame_constante5, text = " ").grid(row = 8, column = 0, sticky = 'w', padx = 5)
frame_constante5.grid(row = 1, column = 0, sticky = 'w', padx = 10)
frame_constantet.grid(row = 0, column = 1, sticky = 'nsew', padx = 10, pady = 10)

# Rate coefficients (1/s)
kf_RT = ctk.StringVar(value="calculate")                     # Rate coefficients by Ragojapalan & Tien (1976) 
kf_TE = ctk.StringVar(value="calculate")                     # Rate coefficients by Tufenkji and Elimelech (2004) 
kf_MPFJ = ctk.StringVar(value="calculate")                   # Rate coefficients by Ma, Pedel, Fife & Johnson (2015) 
kf_LH = ctk.StringVar(value="calculate")                     # Rate coefficients by Long & Hilpert (2011) 
kf_NG = ctk.StringVar(value="calculate")                     # Rate coefficients by Nelson & Ginn (2011) 

# Distribution Rate coefficients (1/s)
frame_constante6 = ctk.CTkFrame(main_frame, width = 150, height = 200, fg_color = "#EBEBEB")
frame_constante6.grid(row = 1, column = 1, columnspan = 3, rowspan = 2, sticky = "nsew", pady = 0, padx = 10)
frame_constante7 = ctk.CTkFrame(frame_constante6, width = 330, height = 200, fg_color = "#EBEBEB")
ctk.CTkLabel(frame_constante7, text = "Rate coefficients (1/s)", font = ("Arial", 16, "bold"), fg_color = "#CFCFCF").grid(row = 0, column = 0, columnspan = 2, sticky = 'ew', pady = 5)
ctk.CTkLabel(frame_constante7, text = "Ragojapalan & Tien (1976)").grid(row = 1, column = 0, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante7, text = "Tufenkji and Elimelech (2004)").grid(row = 2, column = 0, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante7, text = "Ma, Pedel, Fife & Johnson (2015)").grid(row = 3, column = 0, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante7, text = "Long & Hilpert (2011)").grid(row = 4, column = 0, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante7, text = "Nelson & Ginn (2011)").grid(row = 5, column = 0, sticky = 'w', padx = 15)
space7 = 20 
kfRT = ctk.CTkEntry(frame_constante7, textvariable = kf_RT, text_color = texto_rojo, width = 100, justify = "center", fg_color = "#EBEBEB", border_color = "#EBEBEB", state = "disabled")
kfRT.grid(row = 1, column = 1, sticky = 'w', padx = space7)
kfTE = ctk.CTkEntry(frame_constante7, textvariable = kf_TE, text_color = texto_rojo, width = 100, justify = "center", fg_color = "#EBEBEB", border_color = "#EBEBEB", state = "disabled")
kfTE.grid(row = 2, column = 1, sticky = 'w', padx = space7)
kfMPFJ = ctk.CTkEntry(frame_constante7, textvariable = kf_MPFJ, text_color = texto_rojo, width = 100, justify = "center", fg_color = "#EBEBEB", border_color = "#EBEBEB", state = "disabled")
kfMPFJ.grid(row = 3, column = 1, sticky = 'w', padx = space7)
kfLH = ctk.CTkEntry(frame_constante7, textvariable = kf_LH, text_color = texto_rojo, width = 100, justify = "center", fg_color = "#EBEBEB", border_color = "#EBEBEB", state = "disabled")
kfLH.grid(row = 4, column = 1, sticky = 'w', padx = space7)
kfNG = ctk.CTkEntry(frame_constante7, textvariable = kf_NG, text_color = texto_rojo, width = 100, justify = "center", fg_color = "#EBEBEB", border_color = "#EBEBEB", state = "disabled")
kfNG.grid(row = 5, column = 1, sticky = 'w', padx = space7)
frame_constante7.grid(row = 0, column = 0, columnspan = 2, sticky = "nsew", padx = 40, pady = 0)

# Output Directory 
frame_constante8 = ctk.CTkFrame(frame_constante6, width = 300, fg_color = "#EBEBEB")
ctk.CTkLabel(frame_constante8, text = "Output Directory ", font = ("Arial", 16, "bold"), fg_color = "#CFCFCF", width = 200).grid(row = 0, column = 0, sticky = 'ew', pady = 5)
boton3 = ctk.CTkButton(frame_constante8, text = "Save to file", fg_color = "#77DD77", command = save_to_file, text_color = "black", font = ("Arial", 14, "bold"))
boton3.grid_forget()
frame_constante8.grid(row = 1, column = 0, sticky = "nsew", padx = 41, pady = 10)

# Dimensionless numbers
var_NR = ctk.StringVar(value = "calculate")
var_NLo = ctk.StringVar(value = "calculate")
var_Nvdw = ctk.StringVar(value = "calculate")
var_NA = ctk.StringVar(value = "calculate")
var_NPe = ctk.StringVar(value = "calculate")
var_NG = ctk.StringVar(value = "calculate")
var_NGi = ctk.StringVar(value = "calculate")

# Distribution Dimensionless numbers
color_text = "red"
frame_constante9 = ctk.CTkFrame(frame_constante6, width = 400, fg_color = "#EBEBEB")
ctk.CTkLabel(frame_constante9, text = "Dimensionless numbers", font = ("Arial", 16, "bold"), fg_color = "#CFCFCF").grid(row = 0, column = 0, columnspan = 6, sticky = "ew", pady = 5)
NR = ctk.CTkEntry(frame_constante9, textvariable = var_NR, text_color = color_text, width = 100, justify = "center", fg_color = "#EBEBEB", border_color = "#EBEBEB", state = "disabled")
NR.grid(row = 1, column = 1, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante9, text = "NR").grid(row = 1, column = 0, sticky = 'w', padx = 15)
NLO = ctk.CTkEntry(frame_constante9, textvariable = var_NLo, text_color = color_text, width = 100, justify = "center", fg_color = "#EBEBEB", border_color = "#EBEBEB", state = "disabled")
NLO.grid(row = 2, column = 1, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante9, text = "NLo").grid(row = 2, column = 0, sticky = 'w', padx = 15)
Nvdw = ctk.CTkEntry(frame_constante9, textvariable = var_Nvdw, text_color = color_text, width = 100, justify = "center", fg_color = "#EBEBEB", border_color = "#EBEBEB", state = "disabled")
Nvdw.grid(row = 3, column = 1, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante9, text = "Nvdw").grid(row = 3, column = 0, sticky = 'w', padx = 15)
NA = ctk.CTkEntry(frame_constante9, textvariable = var_NA, text_color = color_text, width = 100, justify = "center", fg_color = "#EBEBEB", border_color = "#EBEBEB", state = "disabled")
NA.grid(row = 1, column = 3, sticky = 'w', padx = 0)
ctk.CTkLabel(frame_constante9, text = "NA").grid(row = 1, column = 2, sticky = 'w', padx = 15)
NPe = ctk.CTkEntry(frame_constante9, textvariable = var_NPe, text_color = color_text, width = 100, justify = "center", fg_color = "#EBEBEB", border_color = "#EBEBEB", state = "disabled")
NPe.grid(row = 2, column = 3, sticky = 'w', padx = 0)
ctk.CTkLabel(frame_constante9, text = "NPe").grid(row = 2, column = 2, sticky = 'w', padx = 15)
NG = ctk.CTkEntry(frame_constante9, textvariable = var_NG, text_color = color_text, width = 100, justify = "center", fg_color = "#EBEBEB", border_color = "#EBEBEB", state = "disabled")
NG.grid(row = 3, column = 3, sticky = 'w', padx = 0)
ctk.CTkLabel(frame_constante9, text = "NG").grid(row = 3, column = 2, sticky = 'w', padx = 15)
NGi = ctk.CTkEntry(frame_constante9, textvariable = var_NGi, text_color = color_text, width = 100, justify = "center", fg_color = "#EBEBEB", border_color = "#EBEBEB", state = "disabled")
NGi.grid(row = 4, column = 1, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante9, text = "NGi").grid(row = 4, column = 0, sticky = 'w', padx = 15)
ctk.CTkLabel(frame_constante9, text = "NGi from Nelson and Ginn (2011)").grid(row = 4, column = 2, columnspan = 2, sticky = "w")
ctk.CTkLabel(frame_constante9, text = " ").grid(row = 5, column = 2, columnspan = 2, sticky = "w")
frame_constante9.grid(row = 0, column = 2, sticky = "nsew", padx = 20)

# Authors of the GUI development
frame_constante10 = ctk.CTkFrame(frame_constante6, width = 100, height = 20)
ctk.CTkLabel(frame_constante10, text = "Authors", font = ("Arial", 16, "bold")).grid(row = 0, column = 0, columnspan = 3, sticky = "ew")
ctk.CTkLabel(frame_constante10, text = "Software developed by L. Granda**, S. Marín** & E. Pazmiño**", font = ("Arial", 12, "bold")).grid(row = 1, column = 0, columnspan = 3, sticky = "ew", pady = (0, 0))
ctk.CTkLabel(frame_constante10, text = "Source code developed in W.P. Johnson Research Group:", font = ("Arial", 12, "bold"), height = 1).grid(row = 2, column = 0, columnspan = 3, sticky = "ew",  pady = (0, 0))
ctk.CTkLabel(frame_constante10, text = "K. VanNess*, C. Ron*, A. Rasmuson*", font = ("Arial", 12, "bold"), height = 1).grid(row = 3, column = 0, columnspan = 2, sticky = "ew",  pady = (0, 0))
ctk.CTkLabel(frame_constante10, text = "|", font = ("Arial", 12, "bold")).grid(row = 3, column = 1, sticky = "ew", pady = (0, 0))
ctk.CTkLabel(frame_constante10, text = "W.P. Johnson*, E. Pazmiño**", font = ("Arial", 12, "bold"), height = 1).grid(row = 3, column = 2, sticky = "ew", padx = 0,  pady = (0, 0))
ctk.CTkLabel(frame_constante10, text = "  *University of Utah, Salt Lake City, Utah, USA   ", font = ("Arial", 12, "bold"), height = 1).grid(row = 4, column = 0, sticky = "w", pady = (0, 0))
ctk.CTkLabel(frame_constante10, text = "|", font = ("Arial", 12, "bold"), height = 1).grid(row = 4, column = 1, sticky = "w", padx = 5, pady = (0, 0))
ctk.CTkLabel(frame_constante10, text = "   **Escuela Politécnica Nacional, Quito, Ecuador   ", font = ("Arial", 12, "bold"), height = 1).grid(row = 4, column = 2, sticky = "w", padx = 0, pady = (0, 0))
ctk.CTkLabel(frame_constante10, text = "www.wpjohnsongroup.utah.edu", text_color = "blue", font = ("Arial", 12, "bold")).grid(row = 5, column = 0, sticky = "e")
ctk.CTkLabel(frame_constante10, text = "v 0.1", text_color = "blue", font = ("Arial", 12, "bold")).grid(row = 5, column = 1, columnspan = 2, sticky = "ew", padx = 10)
frame_constante10.grid(row = 1, column = 1, columnspan  = 3, rowspan = 7, sticky = "nsew", padx = 0, pady = 20) 

# Functions to verify that the variables are within range
def range_dp(event = None):
    try:
        dpi = float(var_dp.get())
        if dpi < 0.01:
            messagebox.showwarning("Warming", "Collector diameter value recommended between\n0.01 - 10 mm")
            var_dp.set(f"0.01")
        elif dpi > 10:
            messagebox.showwarning("Warming", "Collector diameter value recommended between\n0.01 - 10 mm")
            var_dp.set(f"10")
    except ValueError:
        pass
Entry_dp.bind("<Return>", range_dp) 

def range_dc(event = None):
    try:
        dci = float(var_dc.get())
        if dci < 0.1:
            messagebox.showwarning("Warming", "Colloid diameter must be among\n0.1 - 50 um")
            var_dc.set(f"0.1")
        elif dci > 50:
            messagebox.showwarning("Warming", "Colloid diameter must be among\n0.1 - 50 um")
            var_dc.set(f"50")
    except ValueError:
        pass
Entry_dc.bind("<Return>", range_dc) 

def range_U(event = None):
    try:
        Ui = float(var_U.get())
        if Ui < 0.5:
            messagebox.showwarning("Warming", "Pore water velocity must be among\n0.5 - 20 (m/day)")
            var_U.set(f"0.5")
        elif Ui > 20:
            messagebox.showwarning("Warming", "Pore water velocity must be among\n0.5 - 20 (m/day)")
            var_U.set(f"20")
    except ValueError:
        pass
Entry_U.bind("<Return>", range_U) 

def range_pc(event = None):
    try:
        pci = float(var_pc.get())
        if pci < 1000:
            messagebox.showwarning("Warming", "Colloid density must be among\n1000 - 20000 (kg/m3)")
            var_pc.set(f"1000")
        elif pci > 20000:
            messagebox.showwarning("Warming", "Colloid density must be among\n1000 - 20000 (kg/m3)")
            var_pc.set(f"20000")
    except ValueError:
        pass
Entry_pc.bind("<Return>", range_pc) 

def range_pf(event = None):
    try:
        pfi = float(var_pf.get())
        if pfi < 600:
            messagebox.showwarning("Warming", "Fluid density must be among\n600 - 1400 (kg/m3)")
            var_pf.set(f"600")
        elif pfi > 1400:
            messagebox.showwarning("Warming", "Fluid density must be among\n600 - 1400 (kg/m3)")
            var_pf.set(f"1400")
    except ValueError:
        pass
Entry_pf.bind("<Return>", range_pf) 

def range_uf(event = None):
    try:
        ufi = float(var_uf.get())
        if ufi < 1e-4:
            messagebox.showwarning("Warming", "Fluid viscosity must be among\n1e-4 - 1e-3 (kg m/s)")
            var_uf.set(f"1e-4")
        elif ufi > 1e-3:
            messagebox.showwarning("Warming", "Fluid viscosity must be among\n1e-4 - 1e-3 (kg m/s)")
            var_uf.set(f"1e-3")
    except ValueError:
        pass
Entry_uf.bind("<Return>", range_uf) 

def range_T(event = None):
    try:
        Ti = float(var_T.get())
        if Ti < 263:
            messagebox.showwarning("Warming", "Temperature must be among\n263 - 333 (K)")
            var_T.set(f"263")
        elif Ti > 333:
            messagebox.showwarning("Warming", "Temperature must be among\n263 - 333 (K)")
            var_T.set(f"333")
    except ValueError:
        pass
Entry_T.bind("<Return>", range_T) 

def range_H(event = None):
    try:
        Hi = float(var_H.get())
        if Hi < 1e-21: 
            messagebox.showwarning("Warming", "Hamaker constant must be among\n1e-21 - 1e-20 (J)")
            var_H.set(f"1e-21")
        elif Hi > 1e-20:
            messagebox.showwarning("Warming", "Hamaker constant must be among\n1e-21 - 1e-20 (J)")
            var_H.set(f"1e-20")
    except ValueError:
        pass
Entry_H.bind("<Return>", range_H) 

def range_theta(event = None):
    try:
        thetai = float(var_theta.get())
        if thetai < 0.1:
            messagebox.showwarning("Warming", "Porosity must be among\n0.1 - 0.8")
            var_theta.set(f"0.1")
        elif thetai > 0.8:
            messagebox.showwarning("Warming", "Porosity must be among\n0.1 - 0.8")
            var_theta.set(f"0.8")
    except ValueError:
        pass
Entry_theta.bind("<Return>", range_theta) 

app.mainloop()