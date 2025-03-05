import numpy as np
import subprocess
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import pdb
import os

# Parameters
# TODO adapt to what you need (folder path executable input filename)
""""
executable = 'executableexe'  # Name of the executable (NB: .exe extension is required on Windows)
repertoire = r"C:/Users/elbam/Downloads/Limasse" #saad path
os.chdir(repertoire)
"""

executable = 'executable'  # Name of the executable (NB: .exe extension is required on Windows)
repertoire = r"/Users/rafaelsierra/Documents/PHYS-NUM/Exercise_2_oscillationofmagneticfield/exercise2_akhmim_sierra" #rafis path
os.chdir(repertoire)

input_filename = 'config.in'  #Change depending on which methode we use


nsteps = np.array([40e3, 50e3, 60e3, 75e3, 80e3, 90e3, 100e3, 125e3,150e3, 175e3, 200e3, ])
nsimul = len(nsteps)  # Number of simulations to perform

tfin = 259200 

dt = tfin / nsteps


paramstr = 'nsteps'  # Parameter name to scan
param = nsteps  # Parameter values to scan

# Simulations
outputs = []  # List to store output file names
convergence_list = []
y_list = []
E_th = -1690921.29604419 
for i in range(nsimul):
    output_file = f"{paramstr}={param[i]}_imp.out" #Change "_imp" "_semi" or "_exp" depending on which methode we use
    outputs.append(output_file)
    cmd = f"{repertoire}/{executable} {input_filename} {paramstr}={param[i]:.15g} output={output_file}"
    cmd = f"{executable} {input_filename} {paramstr}={param[i]:.15g} output={output_file}" ####DIFFERENT FOR MAC OR WINDOWS
    print(cmd)
    subprocess.run(cmd, shell=True)
    print('Done.')

error_E = []
error_P = []

for i in range(nsimul):  # Iterate through the results of all simulations
    data = np.loadtxt('output_imp_huge.txt') #Simulation with nsteps = 1e6, modify for the needed method
    xf = data[-1, 3]
    
    data = np.loadtxt(outputs[i])  # Load the output file of the i-th simulation
    t = data[:, 0]
    

    vx = data[-1, 1]  # final position, velocity, energy
    vy = data[-1, 2]
    xx = data[-1, 3]
    yy = data[-1, 4]
    En = data[-1, 5]
    convergence_list.append(xx)
    y_list.append(yy)
    # TODO compute the error for each simulation
    error_E.append(np.abs(En - E_th))
    error_P.append(np.abs(xx -xf))
print(convergence_list)
lw = 1.5
fs = 16


data = np.loadtxt("output_semi.txt") #Semi for nsteps = 4000, modify for the needed method

fig, ax = plt.subplots(constrained_layout=True)
ax.plot(data[:, 3], data[:, 4])
ax.set_xlabel('x [m]', fontsize=fs)
ax.set_ylabel('y [m]', fontsize=fs)

fig, ax = plt.subplots(constrained_layout=True)
ax.plot(data[:, 0], data[:, -1])
ax.set_xlabel('T [s]', fontsize=fs)
ax.set_ylabel('E [J]', fontsize=fs)

data = np.loadtxt("output_exp.txt") #Exp for nsteps = 4000, modify for the needed method

fig, ax = plt.subplots(constrained_layout=True)
ax.plot(data[:, 3], data[:, 4])
ax.set_xlabel('x [m]', fontsize=fs)
ax.set_ylabel('y [m]', fontsize=fs)

fig, ax = plt.subplots(constrained_layout=True)
ax.plot(data[:, 0], data[:, -1])
ax.set_xlabel('T [s]', fontsize=fs)
ax.set_ylabel('E [J]', fontsize=fs)

data = np.loadtxt("output_imp.txt") #Imp for nsteps = 4000, modify for the needed method

fig, ax = plt.subplots(constrained_layout=True)
ax.plot(data[:, 3], data[:, 4])
ax.set_xlabel('x [m]', fontsize=fs)
ax.set_ylabel('y [m]', fontsize=fs)

fig, ax = plt.subplots(constrained_layout=True)
ax.plot(data[:, 0], data[:, -1])
ax.set_xlabel('T [s]', fontsize=fs)
ax.set_ylabel('E [J]', fontsize=fs)

data = np.loadtxt("output_semi_40000.txt") #Semi for nsteps = 40000, modify for the needed method

fig, ax = plt.subplots(constrained_layout=True)
ax.plot(data[:, 3], data[:, 4])
ax.set_xlabel('x [m]', fontsize=fs)
ax.set_ylabel('y [m]', fontsize=fs)

fig, ax = plt.subplots(constrained_layout=True)
ax.plot(data[:, 0], data[:, -1])
ax.set_xlabel('T [s]', fontsize=fs)
ax.set_ylabel('E [J]', fontsize=fs)

data = np.loadtxt("output_exp_40000.txt") #Exp for nsteps = 40000, modify for the needed method

fig, ax = plt.subplots(constrained_layout=True)
ax.plot(data[:, 3], data[:, 4])
ax.set_xlabel('x [m]', fontsize=fs)
ax.set_ylabel('y [m]', fontsize=fs)

fig, ax = plt.subplots(constrained_layout=True)
ax.plot(data[:, 0], data[:, -1])
ax.set_xlabel('T [s]', fontsize=fs)
ax.set_ylabel('E [J]', fontsize=fs)

data = np.loadtxt("output_imp_40000.txt") #Imp for nsteps = 40000, modify for the needed method

fig, ax = plt.subplots(constrained_layout=True)
ax.plot(data[:, 3], data[:, 4])
ax.set_xlabel('x [m]', fontsize=fs)
ax.set_ylabel('y [m]', fontsize=fs)

fig, ax = plt.subplots(constrained_layout=True)
ax.plot(data[:, 0], data[:, -1])
ax.set_xlabel('T [s]', fontsize=fs)
ax.set_ylabel('E [J]', fontsize=fs)

# uncomment the following if you want debug
#import pdb
#pbd.set_trace()

plt.figure()
plt.loglog(nsteps, error_E, 'r+-', linewidth=lw)
plt.xlabel(r'$N_{steps}$', fontsize=fs)
plt.ylabel('Energy error [J]', fontsize=fs)
plt.xticks(fontsize=fs)
plt.yticks(fontsize=fs)
plt.grid(True)

plt.figure()
plt.loglog(nsteps, error_P, 'r+-', linewidth=lw)
plt.xlabel(r'$N_{steps}$', fontsize=fs)
plt.ylabel('Position error [m]', fontsize=fs)
plt.xticks(fontsize=fs)
plt.yticks(fontsize=fs)
plt.grid(True)

"""
Si on n'a pas la solution analytique: on représente la quantite voulue
(ci-dessous v_y, modifier selon vos besoins)
en fonction de (Delta t)^norder, ou norder est un entier.
"""

norder = 2# Modify if needed

plt.figure()
plt.plot(dt**norder, convergence_list, 'k+-', linewidth=lw)
ax = plt.gca()
ax.yaxis.set_major_formatter(ticker.ScalarFormatter(useMathText=True))
ax.yaxis.get_offset_text().set_size(12)  # Modifier la taille du texte
ax.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
plt.title(r'Convergence order for $n = 2$ and $\alpha = 0.5$') #Change manually depending of value of alpha and norder
plt.xlabel(r'$\Delta t^n$ [s]', fontsize=fs)
plt.ylabel(r'$x_{fin}$ [m]', fontsize=fs)
plt.xticks(fontsize=fs)
plt.yticks(fontsize=fs)
plt.grid(True)

plt.figure()
plt.plot(dt**norder, y_list, 'k+-', linewidth=lw)
ax = plt.gca()
ax.yaxis.set_major_formatter(ticker.ScalarFormatter(useMathText=True))
ax.yaxis.get_offset_text().set_size(12)  # Modifier la taille du texte
ax.ticklabel_format(style='sci', axis='y', scilimits=(0,0))
plt.title(r'Convergence order for $n = 2$ and $\alpha = 0.5$') #Change manually depending of value of alpha and norder
plt.xlabel(r'$\Delta t^n$ [s]', fontsize=fs)
plt.ylabel(r'$y_{fin}$ [m]', fontsize=fs)
plt.xticks(fontsize=fs)
plt.yticks(fontsize=fs)
plt.grid(True)

plt.show()
