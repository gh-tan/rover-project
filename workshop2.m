close all; clear; clc

%% import data
data = csvread('WK2_bifilar.csv'); %use csvread instead of readtable
time = data(:,1);
angle = data(:,2);

plot(time,angle)

%% find Izz
m = 0.79; %kg
g = 9.81;
T = 1.425; %sec, from plot
d = 0.108; %m
D = 0.33; %m

Izz = m*g*(T^2)*(d^2)/(16*(pi^2)*D) %in kg*cm^2
Izz_part2 = Izz*10000

%% find Izz for part 1
A = 0.14;
B = 0.165;
Izz_part1 = m/12*(A^2+B^2)*10000 % in kg*cm^2