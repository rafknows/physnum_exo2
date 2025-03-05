clc; clear; close all;

data = load('2_3_a.txt');
theta = data(:, 2);
t = data(:, 1);

fig1 = figure;
plot(t, theta, 'LineWidth', 1.5)
grid on;