close all; clear; clc

%% input data
x1 = 0.7; % in m
y1 = 2.6; % in m
rss1 = 52; %in db

x2 = 4.8;
y2 = 1.2;
rss2 = 55;

x3 = 2.1;
y3 = 8.5;
rss3 = 54;

b1 = [x1;y1];
b2 = [x2;y2];
b3 = [x3;y3];

%% find d1,d2,d3, distance from eqn
d1 = 10^((rss1-45)/15);
d2 = 10^((rss2-45)/15);
d3 = 10^((rss3-45)/15);

%% find alpha_12,alpha_13,alpha_23
alpha_12 = [transpose(b1)*b1-d1^2; transpose(b2)*b2-d2^2];
alpha_13 = [transpose(b1)*b1-d1^2; transpose(b3)*b3-d3^2];
alpha_23 = [transpose(b2)*b2-d2^2; transpose(b3)*b3-d3^2];

%% find P_12,P_13,P_23, or [H]^-1
P_12 = inv(2*[transpose(b1); transpose(b2)]);
P_13 = inv(2*[transpose(b1); transpose(b3)]);
P_23 = inv(2*[transpose(b2); transpose(b3)]);

%% find beta_12, beta_13, beta_23
e = [1;1];

% syms b12 b13 b23 x
% 
% eqn12 = transpose(e)*transpose(P_12)*P_12*e*(b12.^2) ... 
%     + b12*(transpose(alpha_12)*transpose(P_12)*P_12*e + transpose(e)*transpose(P_12)*P_12*alpha_12 - 1) ...
%     + transpose(alpha_12)*transpose(P_12)*P_12*alpha_12 == 0;
% eqn13 = transpose(e)*transpose(P_13)*P_13*e*(b13^2) ... 
%     + b13*(transpose(alpha_13)*transpose(P_13)*P_13*e + transpose(e)*transpose(P_13)*P_13*alpha_13 - 1) ...
%     + transpose(alpha_13)*transpose(P_13)*P_13*alpha_13 == 0;
% eqn23 = transpose(e)*transpose(P_23)*P_23*e*(b23^2) ... 
%     + b23*(transpose(alpha_23)*transpose(P_23)*P_23*e + transpose(e)*transpose(P_23)*P_23*alpha_23 - 1) ...
%     + transpose(alpha_23)*transpose(P_23)*P_23*alpha_23 == 0;
% 
% beta_12 = solve(eqn12, b12);
% beta_13 = solve(eqn13, b13);
% beta_23 = solve(eqn23, b23);

eqn12 = [transpose(e)*transpose(P_12)*P_12*e;
        (transpose(alpha_12)*transpose(P_12)*P_12*e + transpose(e)*transpose(P_12)*P_12*alpha_12 - 1);
        transpose(alpha_12)*transpose(P_12)*P_12*alpha_12];
eqn13 = [transpose(e)*transpose(P_13)*P_13*e;
        (transpose(alpha_13)*transpose(P_13)*P_13*e + transpose(e)*transpose(P_13)*P_13*alpha_13 - 1);
        transpose(alpha_13)*transpose(P_13)*P_13*alpha_13];
eqn23 = [transpose(e)*transpose(P_23)*P_23*e;
    	(transpose(alpha_23)*transpose(P_23)*P_23*e + transpose(e)*transpose(P_23)*P_23*alpha_23 - 1);
        transpose(alpha_23)*transpose(P_23)*P_23*alpha_23];
beta_12 = roots(eqn12);
beta_13 = roots(eqn13);
beta_23 = roots(eqn23);

%% find u, location of user
u12_1 = P_12*(alpha_12 + e*beta_12(1));
u12_2 = P_12*(alpha_12 + e*beta_12(2));

u13_1 = P_13*(alpha_13 + e*beta_13(1));
u13_2 = P_13*(alpha_13 + e*beta_13(2));

u23_1 = P_23*(alpha_23 + e*beta_23(1));
u23_2 = P_23*(alpha_23 + e*beta_23(2));

%% plot possible & estimated rover location, beacon location and RSS distance
allPoints = transpose([u12_1 u12_2 u13_1 u13_2 u23_1 u23_2]);
scatter(allPoints(:,1),allPoints(:,2),'o','m')
grid on;
hold on
estLoc = [(u12_1(1)+u13_1(1)+u23_2(1))/3,(u12_1(2)+u13_1(2)+u23_2(2))/3]; %estimated location
scatter(estLoc(1),estLoc(2),'*','g')
text(7,11,'Estimated Rover Location:');
text(8,10,'x=2.231m; y=4.741m');

allBeacons = transpose([b1 b2 b3]);
scatter(allBeacons(:,1), allBeacons(:,2),'+','b')
text(b1(1),b1(2),'  beacon#1'); %can use  \leftarrow 
text(b2(1),b2(2),'  beacon#2');
text(b3(1),b3(2),'  beacon#3');

rectangle('Position',[b1(1)-d1 b1(2)-d1 2*d1 2*d1],'Curvature',[1,1],'EdgeColor','b')
rectangle('Position',[b2(1)-d2 b2(2)-d2 2*d2 2*d2],'Curvature',[1,1],'EdgeColor','b')
rectangle('Position',[b3(1)-d3 b3(2)-d3 2*d3 2*d3],'Curvature',[1,1],'EdgeColor','b')

title('Rover user position estimation using 3 beacons')
xlabel('x axis (meter)');
ylabel('y axis (meter)');
legend('Potential rover postion','Estimated rover position','Beacon location','location','northeast')
axis equal
xlim([-6 14]);ylim([-4 14])

