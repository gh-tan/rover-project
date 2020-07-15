close all; clear; clc

%% import data
% data = readtable('WK4_lidar.csv');
rawData = importdata('WK4_lidar.csv');
data = rawData.data;
text = rawData.textdata;
t = str2double(text(:,1)); %time in second
flag = text(:,2); %true/false
quality = data(:,1); % [0,15]
angle = data(:,2); % in degree
range = data(:,3)/1000; % in m

%% extract data

z = zeros(length(t),1);
y = zeros(length(t),1);
x = zeros(length(t),1);

for i = 1:numel(t)
    if angle(i) > 330 || angle(i) < 30
        z(i) = 0.75 - range(i)*cosd(angle(i));
        y(i) = 0.2 * t(i);
        x(i) = range(i)*sind(angle(i));
        allXYZ = [x y z];
    end
end

newXYZ = allXYZ(all(allXYZ,2),:); % remove rows that contains zero; work cross 2nd dimension(row)
% 1st dimention is column

%% plot
figure(1)
scatter3(x,y,z)
xlabel('x-axis, in meter');ylabel('y-axis, in meter');zlabel('z-axis, in meter');
title('LIDAR scan w/ 60 degrees sweep, plotted with raw data')
% ylim([0.8 1.2])
% zlim([0 0.7])
axis equal

figure(2)
scatter3(newXYZ(:,1),newXYZ(:,2),newXYZ(:,3));
axis equal
xlabel('x-axis, in meter');ylabel('y-axis, in meter');zlabel('z-axis, in meter');
title('LIDAR scan w/ 60 degrees sweep, plotted w/o outliers')
