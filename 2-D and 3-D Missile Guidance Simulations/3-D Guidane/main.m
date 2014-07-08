clear all; close all; clc
%------------------
% Given Conditions
%------------------
rm        = [0,0,0];
vm_mag    = 500;
vt        = [0,-150,50]; 
rt        = [5000,5000,5000]; 
N         = 4;
%------------------
% Lead Angles
%------------------
syms t
a         = 500*t-norm([rt+vt*t]);
tf_est    = solve(a);
tf_est    = eval(tf_est);
rt1       = vt*tf_est+rt;
vm1       = vm_mag*(rt1/norm(rt1));
rm1       = vm1*tf_est;
elevation = asind(vm1(3)/norm(vm1));
azimuth   = atan2d(vm1(2),vm1(1));
%------------------
%     USER INPUTS
%------------------
t         = 0:0.001:21.3618;
HE_b      = 10; 
HE_e      = 30;  
%----------------------------------
%  Calculation of Missile Velocity
%----------------------------------
v_m       = vm_mag.*[cosd(elevation+HE_e)*cosd(azimuth+HE_b) cosd(elevation+HE_e)*sind(azimuth+HE_b) sind(elevation+HE_e)];
%-----------------
%     ode45
%-----------------
InitCond  = [rm v_m rt vt];
options   = odeset('Events',@interception,'RelTol',1e-16);
[t,state] = ode45(@GUIDANCEupdate,t,InitCond);
%-----------------
%     Results
%-----------------
tf        = t(length(t))
rt        = [state(length(state),7); state(length(state),8); state(length(state),9)];
rm        = [state(length(state),1); state(length(state),2); state(length(state),3)];
rmin      = rt-rm
vf        = [state(length(state),4); state(length(state),5); state(length(state),6)];
dv        = vf-v_m'
%-----------------
%     Figures
%-----------------
plot3(state(:,1),state(:,2),state(:,3),'LineWidth',2)
hold on;
plot3(state(:,7),state(:,8),state(:,9),'r','LineWidth',2)
grid on
xlabel('x(m)'); ylabel('y(m)'); zlabel('z(m)')
title('Missile Trajectory')
legend('Friendly', 'Enemy')



