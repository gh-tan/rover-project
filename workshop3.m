close all; clear; clc

%% import data
data = csvread('WK3_control.csv'); %use csvread instead of readtable
t = data(:,1); % time
t_before = data(1:38,1); %time before step
t_after = data(38:180,1); %time after step
psi_C = data(:,2); %command heading
psi = data(:,3); %measured heading
ay = data(:,4); %side acceleration
del_t = data(:,5); %throttle input [-1, 1]
del_s = data(:,6); % steering input [-1, 1]

t_c = data(38,1);
psi_i = data(1,2); % 34.2541 deg
psi_f = data(39,2); %106.254 deg
p1 = -0.5; % one of the pole, unit in rad/s

%% find heading angle from time response equations
psi_beforeStep = psi_i * ones(length(t_before),1);
psi_afterStep = rad2deg(deg2rad(psi_f) - (deg2rad(psi_f) - deg2rad(psi_i)).*exp(p1.*(t_after-t_c)));


%% plot
plot(t,psi_C,'b')
hold on
grid on
xlabel("time in seconds");ylabel("heading degree in degrees")
title("Command/Measured/Calculated Heading angle Vs. Time")
plot(t,psi,'g')
plot(t_before, psi_beforeStep,'r',t_after, psi_afterStep,'r')
% plot(t_after, psi_afterStep,'r')
legend("command heading","measured heading","heading from time response equations","location","southeast")
