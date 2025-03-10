clc; clear; close all;

data = load('2_3_b.txt');

t = data(:, 1);
theta = data(:, 2);
thetadot = data(:, 3);

lw = 1.5;
fs = 24;

fig1 = figure;
plot(t, theta, 'LineWidth', lw, 'Color', 'blue');
xlabel('\it{t} \rm [s]', 'FontSize', fs);
ylabel('\theta', 'FontSize', fs);
%legend('\alpha = 0.5', 'Location','best')
grid on;

fig2 = figure;
plot(theta, thetadot, 'LineWidth', lw, 'Color', 'blue');
xlabel('\theta', 'FontSize', fs);
ylabel('\Dot{\theta} [s^{-1}]', 'FontSize', fs);
%legend('\alpha = 0.5', 'Location','best')
grid on;