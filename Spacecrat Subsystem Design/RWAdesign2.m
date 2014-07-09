clear all
clc

Kp = 0.529;
Iyy = 400;
tau_p=110;
tau=tau_p/2;


IC=[0 0 0];
time=linspace(0,3*3600,1000);
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



plot(t,H_w);
figure;
plot(t,Torque)





