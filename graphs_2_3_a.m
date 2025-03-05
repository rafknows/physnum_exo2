clc; clear; close all;

nsteps_per = [1e3, 1.25e3, 1.5e3, 1.75e3, 2e3, 3e3, 4e3, 5e3, 7.5e3, 10e3, 20e3, 40e3, 50e3, 60e3, 75e3, 80e3, 90e3, 100e3, 125e3,150e3, 175e3, 200e3];
nsimul = length(nsteps_per);
param = nsteps_per;
filename = 'config.in'; % Nom du fichier
fid = fopen(filename, 'r');
if fid == -1
    error('Impossible d''ouvrir le fichier.');
end
while ~feof(fid)
    line = fgetl(fid); % Lire une ligne
    if contains(line, 'Omega') % Chercher la ligne contenant "Omega"
        values = regexp(line, '[-+]?\d*\.?\d+', 'match'); % Extraire les nombres
        Omega = str2double(values{1}); % Convertir en nombre
    end
    if contains(line, 'Nperiod') % Chercher la ligne contenant "Omega"
        values = regexp(line, '[-+]?\d*\.?\d+', 'match'); % Extraire les nombres
        Nperiod = str2double(values{1}); % Convertir en nombre
    end
    if contains(line, 'N_excit') % Chercher la ligne contenant "Omega"
        values = regexp(line, '[-+]?\d*\.?\d+', 'match'); % Extraire les nombres
        N_excit = str2double(values{1}); % Convertir en nombre
    end
    if contains(line, 'mu') % Chercher la ligne contenant "Omega"
        values = regexp(line, '[-+]?\d*\.?\d+', 'match'); % Extraire les nombres
        mu = str2double(values{1}); % Convertir en nombre
    end
    if contains(line, 'B0') % Chercher la ligne contenant "Omega"
        values = regexp(line, '[-+]?\d*\.?\d+', 'match'); % Extraire les nombres
        B0 = str2double(values{1}); % Convertir en nombre
    end
    if contains(line, 'L') % Chercher la ligne contenant "Omega"
        values = regexp(line, '[-+]?\d*\.?\d+', 'match'); % Extraire les nombres
        L = str2double(values{1}); % Convertir en nombre
    end
    if contains(line, 'm') % Chercher la ligne contenant "Omega"
        values = regexp(line, '[-+]?\d*\.?\d+', 'match'); % Extraire les nombres
        m = str2double(values{1}); % Convertir en nombre
    end
end
fclose(fid);

I = (1/12) * m * L^2;
T = (2 * pi) / Omega;
omega_0 = sqrt((mu / I) * B0);
if N_excit > 0
    tFin = N_excit * T;
else
    tFin = Nperiod * T;
end

theta_a_f = 1e-6 * cos(omega_0 * tFin);
theta_dot_a_f = - omega_0 * 1e-6 * sin(omega_0 * tFin);

delta = [];

for i = 1:nsimul
    filename = sprintf('nsteps=%d.0_2_3_a.out', param(i));  % Générer le nom de fichier
    data = load(filename);  % Charger les données de simulation
    theta_f = data(end, 2);
    theta_dot_f = data(end,3);
    
    ecart = sqrt(omega_0^2 * (theta_f - theta_a_f)^2 + (theta_dot_f - theta_dot_a_f)^2);
    delta =[delta, ecart];
end

dt = T ./ nsteps_per;

lw = 2;
fs = 24;

fig1 = figure;
plot(dt, delta, 'o-', 'LineWidth', lw, 'Color', 'black');
xlabel('\Delta t [s]', 'FontSize', fs)
ylabel('\delta [rad/s]', 'FontSize', fs)

fig2 = figure;
semilogx(nsteps_per, delta, 'o-', 'LineWidth', lw, 'Color', 'black')
xlabel('n_{per}', 'FontSize', fs)
ylabel('\delta [rad/s]', 'FontSize', fs)