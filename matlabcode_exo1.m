%{
to launch this part we need the multiple .out file created by
python. We should make sure there are created before launching it
clc; clear; close all;
%}

% Définition des paramètres
nsteps = [40.0e3, 50.0e3, 60.0e3, 75.0e3, 80.0e3, 90.0e3, 100.0e3, 125.0e3, 150.0e3, 175.0e3, 200.0e3]; % TODO change
nsimul = length(nsteps);
tfin = 259200;
dt = tfin ./ nsteps;
param = nsteps;
convergence_list = [];
y_list = [];
E_th = -1690921.29604419;
error_E_0 = [];
error_E_1 = [];
error_E = [];
error_P = []; % P majuscule pour x pour semi
error_P_0 = []; % P majuscule pour x pour imp
error_P_1 = []; % P majuscule pour x pour exp
error_p = []; % p minuscule pour y semi
error_p_0 = []; % p minuscule pour y imp
error_p_1 = []; % p minuscule pour y exp

% Charger les données globales
data = load('output_semi_huge.txt');
xf = data(end, 4);
yf = data(end, 5);
% Boucle sur toutes les simulations
for i = 1:nsimul
    filename = sprintf('nsteps=%d.0_semi.out', param(i));  % Générer le nom de fichier
    data = load(filename);  % Charger les données de simulation
    
    t = data(:, 1);  % Temps

    vx = data(end, 2);  % Vitesse finale en x
    vy = data(end, 3);  % Vitesse finale en y
    xx = data(end, 4);  % Position finale en x
    yy = data(end, 5);  % Position finale en y
    En = data(:, 6);  % Énergie finale

    E = abs(E_th - En);

    convergence_list = [convergence_list, xx];
    y_list = [y_list, yy];

    % Calcul des erreurs
    error_E = [error_E, max(E)];
    error_P = [error_P, abs(xx - xf)];
    error_p = [error_p, abs(yy - yf)];
end

data = load('output_imp_huge.txt');
xf = data(end, 4);
yf = data(end,5);
for i = 1:nsimul
    filename = sprintf('nsteps=%d.0_imp.out', param(i));  % Générer le nom de fichier
    data = load(filename);  % Charger les données de simulation
    xx = data(end, 4);
    En = data(:, 6);  % Énergie finale
    E = abs(E_th - En);
    % Calcul des erreurs
    error_E_0 = [error_E_0, max(E)];
    error_P_0 = [error_P_0, abs(xx - xf)];
    error_p_0 = [error_p_0, abs(yy - yf)];
    convergence_list_0 = [convergence_list_0, xx]
end

data = load('output_exp_huge.txt');
xf = data(end, 4);
yf = data(end, 5);
for i = 1:nsimul
    filename = sprintf('nsteps=%d.0_exp.out', param(i));  % Générer le nom de fichier
    data = load(filename);  % Charger les données de simulation
    xx = data(end, 4);
    En = data(:, 6);  % Énergie finale
    E = abs(E_th - En);
    % Calcul des erreurs
    error_E_1 = [error_E_1, max(E)];
    error_P_1 = [error_P_1, abs(xx - xf)];
    error_p_1 = [error_p_1, abs(yy - yf)];
end

lw = 1.5;
fs = 24;

fig1 = figure;
loglog(nsteps, error_E, 'r+-', 'LineWidth', lw, 'Color', 'blue');
xlabel('N_{steps}', 'FontSize', fs);
ylabel('Maximum energy error [J]', 'FontSize', fs);
set(gca, 'FontSize', fs);
legend('\alpha = 0.5', 'Location','best')
grid on;

fig2 = figure;
loglog(nsteps, error_E_0, 'r+-', 'LineWidth', lw, 'Color', 'black');
xlabel('N_{steps}', 'FontSize', fs);
ylabel('Maximum energy error [J]', 'FontSize', fs);
set(gca, 'FontSize', fs);
legend('\alpha = 0', 'Location','best')
grid on;

fig3 = figure;
loglog(nsteps, error_E_1, 'r+-', 'LineWidth', lw);
xlabel('N_{steps}', 'FontSize', fs);
ylabel('Maximum energy error [J]', 'FontSize', fs);
set(gca, 'FontSize', fs);
legend('\alpha = 1', 'Location','best')
grid on;


% Tracé de l'erreur sur la position
fig4 = figure;
loglog(nsteps, error_P, 'r+-', 'LineWidth', lw, 'Color', 'blue');
xlabel('N_{steps}', 'FontSize', fs);
ylabel('Position error on x [m]', 'FontSize', fs);
set(gca, 'FontSize', fs);
legend('\alpha = 0.5', 'Location','best')
grid on;

fig5 = figure;
loglog(nsteps, error_P_0, 'r+-', 'LineWidth', lw, 'Color', 'black');
xlabel('N_{steps}', 'FontSize', fs);
ylabel('Position error on x [m]', 'FontSize', fs);
set(gca, 'FontSize', fs);
legend('\alpha = 0', 'Location','best')
grid on;

fig6 = figure;
loglog(nsteps, error_P_1, 'r+-', 'LineWidth', lw, 'Color', 'red');
xlabel('N_{steps}', 'FontSize', fs);
ylabel('Position error on  x [m]', 'FontSize', fs);
set(gca, 'FontSize', fs);
legend('\alpha = 1', 'Location','best')
grid on;
%}
lw = 1.5;
fs = 24;

% Définition de norder
norder = 2; % Modifier si nécessaire

% Tracé de la convergence de x_final
fig3 = figure;
plot(dt.^norder, convergence_list, 'k+-', 'LineWidth', lw);
title('Convergence order for n = 2 and \alpha = 0.5', 'FontSize', fs);
xlabel('\Delta t^n [s]', 'FontSize', fs);
ylabel('x_{fin} [m]', 'FontSize', fs);
set(gca, 'FontSize', fs);
grid on;

% Tracé de la convergence de y_final
fig4 = figure;
plot(dt.^norder, y_list, 'k+-', 'LineWidth', lw);
title('Convergence order for n = 2 and \alpha = 0.5', 'FontSize', fs);
xlabel('\Delta t^n [s]', 'FontSize', fs);
ylabel('y_{fin} [m]', 'FontSize', fs);
set(gca, 'FontSize', fs);
grid on;