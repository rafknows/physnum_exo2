import numpy as np
import subprocess
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
import pdb
import os

# Parameters
# TODO adapt to what you need (folder path executable input filename)

executable = 'Exercice2_akhmim_sierra.exe'  # Name of the executable (NB: .exe extension is required on Windows)
repertoire = r"C:/Users/elbam/Desktop/EPFL/BA4/Physique numérique/Exercice2_akhmim_sierra/physnum_exo2" #saad path
os.chdir(repertoire)

print("Fichiers dans le répertoire :", os.listdir(repertoire))

"""
executable = 'executable'  # Name of the executable (NB: .exe extension is required on Windows)
repertoire = r"/Users/rafaelsierra/Documents/PHYS-NUM/Exercise_2_oscillationofmagneticfield/exercise2_akhmim_sierra" #rafis path
os.chdir(repertoire)
"""
input_filename = 'config.in'  #Change depending on which methode we use


nsteps = np.array([20, 50, 100, 200, 300, 400, 500, 750, 1e3, 1.25e3, 1.5e3, 1.75e3, 2e3, 3e3, 4e3, 5e3, 7.5e3, 10e3, 20e3, 40e3, 50e3, 60e3, 75e3, 80e3, 90e3, 100e3, 125e3,150e3, 175e3, 200e3])
nsimul = len(nsteps)  # Number of simulations to perform

paramstr = 'nsteps'  # Parameter name to scan
param = nsteps  # Parameter values to scan

# Simulations
outputs = []  # List to store output file names
convergence_list = []
y_list = []
E_th = -1690921.29604419 
for i in range(nsimul):
    output_file = f"{paramstr}={param[i]}_2_3_a.out"
    outputs.append(output_file)
    #Attention partie en dessous il faut peut etre la modifier pour MAC
    cmd = f"{repertoire}\\{executable} {input_filename} {paramstr}={param[i]:.15g} output={output_file}"
    cmd = f"{executable} {input_filename} {paramstr}={param[i]:.15g} output={output_file}"
    print(cmd)
    subprocess.run(cmd, shell=True)
    print('Done.')


"""
Si on n'a pas la solution analytique: on représente la quantite voulue
(ci-dessous v_y, modifier selon vos besoins)
en fonction de (Delta t)^norder, ou norder est un entier.
"""