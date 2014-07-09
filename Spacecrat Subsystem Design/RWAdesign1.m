clear all
clc
close all


% MAE 445: Homework #8

% Part B

P = 4.4644*(10^(-6));
A = 15.38;
q=0.4;
Cp_g=1;
w0=7.2922*(10^(-5));
T=2*pi/w0;
t=0:T;

Tr = P.*A.*(1+q).*Cp_g.*cos(w0.*t);

figure(1)
plot(t,Tr,'k','linewidth',2)
xlabel('Time Over 1 Orbit')
ylabel('Solar Pressure Disturbance Torque [N/m^2]')
title('Solar Pressure Torque for 1 Orbit [s]')

% Part K

% Case 1

theta0 = 10*pi/180;
tau = 55;

t = 0:500;

theta = (theta0.*(1+(t./tau)).*exp(-t/tau));

figure(2)
plot(t,180.*theta./pi,'k','linewidth',2)
xlabel('Time [s]')
ylabel('Angle from Target [deg]')
title('Pitch Response for an intitial error of 10deg, no disturbances')

%% Case 2
clear all
clc

theta0=0;
F0 = 0.000085;
Kp = 0.529;
tau = 55;

t=0:300;

for i=1:length(t)


theta_n(i) = (theta0(i)*(1+(t(i)/tau)).*exp(-t(i)/tau));
theta_p(i) = F0/Kp; % This is the particular solution for a step input of a free response

theta(i) = theta_n(i)+theta_p(i);

theta0(i+1) = theta(i);



hold on

end

figure(3)
plot(t,theta*180/pi,'k','linewidth',2)
xlabel('Time [s]')
ylabel('Angle from Target [deg]')
title('Pitch Response for a step input disturbance torque of 8.5e-5 N-m')

%% Case 3
clear all
clc

theta0=0;
P = 4.4644*(10^(-6));
A = 15.38;
q=0.4;
Cp_g=1;
w0=7.2922*(10^(-5));
Kp = 0.529;
t=linspace(0,48*3600,1000);

Tr = P.*A.*(1+q).*Cp_g.*cos(w0.*t);

tau = 55;

for i=1:length(t)


theta_n(i) = (theta0(i)*(1+(t(i)/tau)).*exp(-t(i)/tau));
theta_p(i) = Tr(i)/Kp; % This is the particular solution for a step input of a free response

theta(i) = theta_n(i)+theta_p(i);

theta0(i+1) = theta(i);

hold on

end

figure(5)
plot(t,theta*180/pi,'k','linewidth',2)
xlabel('Time [s]')
ylabel('Angle from Target [deg]')
title('Pitch Response for a solar pressure disturbance torque')

%% Part m

%% Case 1

Kp = 0.529;
Iyy = 400;
tau_p=110;
tau=tau_p/2;


IC=[10*pi/180 0 0];
time=linspace(0,500,1000);
options=odeset('RelTol',1e-6);
[t,state]=ode45(@Hw_dot,time,IC,options);
theta=state(:,1);
theta_dot=state(:,2);
H_w=state(:,3);

P = 4.4644*(10^(-6));
A = 15.38;
q=0.4;
Cp_g=1;
w0=7.2922*(10^(-5));
T=2*pi/w0;
Tr_solar = P.*A.*(1+q).*Cp_g.*cos(w0.*t);
Tr_miss=8.5e-5;
Tr_natural=0;

Tr=Tr_natural;

T_control=Kp.*(theta+tau_p.*theta_dot);
theta_dot_dot=(Tr-T_control)/Iyy;

Torque=0.005*theta_dot_dot+T_control;


figure(6)
plot(t,H_w,'k','linewidth',2)
xlabel('Time [s]')
ylabel('Angular Momentum [N*m*s]')
title('Angular Momentum of Reaction Wheel, 10deg error, free response')

figure(7)
plot(t,Torque,'k','linewidth',2)
xlabel('Time [s]')
ylabel('Torque[N*m*s]')
title('Torque of Reaction Wheel, 10deg error, free response')

%% Case 2

Kp = 0.529;
Iyy = 400;
tau_p=110;
tau=tau_p/2;


IC=[0 0 0];
time=linspace(0,300,1000);
options=odeset('RelTol',1e-6);
[t,state]=ode45(@Hw_dot,time,IC,options);
theta=state(:,1);
theta_dot=state(:,2);
H_w=state(:,3);

P = 4.4644*(10^(-6));
A = 15.38;
q=0.4;
Cp_g=1;
w0=7.2922*(10^(-5));
T=2*pi/w0;
Tr_solar = P.*A.*(1+q).*Cp_g.*cos(w0.*t);
Tr_miss=8.5e-5;
Tr_natural=0;

Tr=Tr_miss;

T_control=Kp.*(theta+tau_p.*theta_dot);
theta_dot_dot=(Tr-T_control)/Iyy;

Torque=0.005*theta_dot_dot+T_control;


figure(6)
plot(t,H_w,'k','linewidth',2)
xlabel('Time [s]')
ylabel('Angular Momentum [N*m*s]')
title('Angular Momentum of Reaction Wheel, Misalignment Disturbance')

figure(7)
plot(t,Torque,'k','linewidth',2)
xlabel('Time [s]')
ylabel('Torque[N*m*s]')
title('Torque of Reaction Wheel, Misalignment Disturbance')

%% Case 3

Kp = 0.529;
Iyy = 400;
tau_p=110;
tau=tau_p/2;


IC=[0 0 0];
time=linspace(0,48*3600,10000);
options=odeset('RelTol',1e-6);
[t,state]=ode45(@Hw_dot,time,IC,options);
theta=state(:,1);
theta_dot=state(:,2);
H_w=state(:,3);

P = 4.4644*(10^(-6));
A = 15.38;
q=0.4;
Cp_g=1;
w0=7.2922*(10^(-5));
T=2*pi/w0;
Tr_solar = P.*A.*(1+q).*Cp_g.*cos(w0.*t);
Tr_miss=8.5e-5;
Tr_natural=0;

Tr=Tr_solar;

T_control=Kp.*(theta+tau_p.*theta_dot);
theta_dot_dot=(Tr-T_control)/Iyy;

Torque=0.005*theta_dot_dot+T_control;


figure(6)
plot(t,H_w,'k','linewidth',2)
xlabel('Time [s]')
ylabel('Angular Momentum [N*m*s]')
title('Angular Momentum of Reaction Wheel, solar pressure disturbance')

figure(7)
plot(t,Torque,'k','linewidth',2)
xlabel('Time [s]')
ylabel('Torque[N*m*s]')
title('Torque of Reaction Wheel, solar pressure disturbance')
axis([0 18e4 -1e-4 1e-4])























