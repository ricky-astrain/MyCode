%% Problem 1

clear all
close all
clc

tspan = 0:0.01:10.05;

HE_IC = -20*pi/180;

vmx_IC = 3000*cos(HE_IC);
vmy_IC = 3000*sin(HE_IC);
vm_v_IC = [vmx_IC; vmy_IC];
vm = norm(vm_v_IC);
c1_IC = -vm*HE_IC;

y_dot_IC = c1_IC;

y_IC = 0;

lam_IC = 0;

Rtm_IC = 40000;

ym_IC = 10000;
xm_IC = 0;

yt_IC = 10000;
vty_IC = 0;
xt_IC = 40000;
vtx_IC = -1000;

options = odeset('RelTol',1e-10);
[T, STATE] = ode45(@ (t,state) TPNupdate(t,state),tspan,[ym_IC; vmy_IC; xm_IC; vmx_IC; yt_IC; vty_IC; xt_IC; vtx_IC; lam_IC],options);

disp('The Missile hits the target in approximately 10.065 seconds')

figure(2)
hold on
plot(STATE(:,3),STATE(:,1),'k','Linewidth',2)
plot(STATE(:,7),STATE(:,5),'r','Linewidth',2)
axis([0 4.5e4 7500 11000])
xlabel('Ground Distance (m)')
ylabel('Height (m)')
title('Interception Trajectories of Target by Missle')
legend('Missile Trajectory','Target Trajectory')

