clc;
clear;
% Part A
u=0.012150829235347922;
D=384400; % Distance from the moon to the earth [km]
x_n=0.83691; % Distance from the center of the Earth to the L1 point
% This assumes the orgin of the rotating coordinate system lies at the
% center of the earth.
% The values of x is normalized so the D = 1. (D/D or x/D)
% Thus x*D would equal the distance of the L1 in kilometers
x_km=(x_n+u)*D

% Part B
T=1*0.2787371343*(10^1);
tspan=0:0.01:T;
f_IC=[0.8299403477 0 0.1136910520 0.4773867928*(10^-11) 0.2290393355 -0.3131140468*(10^-10)];

options = odeset('RelTol',1e-10); 
[T,X]=ode45(@hw52b,tspan,f_IC,options);
figure(1)
plot3(X(:,1),X(:,2),X(:,3))

% Part C
T=1*0.2787371343*(10^1);
Tnew=4*T;
tspan=0:0.01:Tnew;
tspan=fliplr(tspan);
e_V4=[0.9621 0.2647 -0.066 -1.9173 -1.0081 0.6328];
alpha=1*(10^-6);
IC_nearby=f_IC-alpha.*e_V4;

options = odeset('RelTol',1e-10); 
[T,X]=ode45(@hw52b,tspan,IC_nearby,options);
figure(2)
plot3(X(:,1),X(:,2),X(:,3))

% Part D
r=sqrt(((X(:,1)+u).^2)+(X(:,2).^2)+(X(:,3).^2));
ans_d=min(r)*384400 % Distance from the moon to the earth [km]

% Part E
% The closest approach point is roughly x=-0.7335, y=-0.3118, z=0.004537
% This corresponds to the r index of 832
t_n=tspan(832);
T_earthmoon=365;
ans_e=t_n*(T_earthmoon/(2*pi))