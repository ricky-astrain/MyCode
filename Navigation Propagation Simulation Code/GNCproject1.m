clear all
close all
clc

% Part A

% syms L lam theta alpha

L=45*(pi/180);
lam=45*(pi/180);
theta=60*(pi/180);

% Body to NED
C_nb = [0 sin(theta) cos(theta); 0 cos(theta) -sin(theta); -1 0 0];

C_BODYtoNED = C_nb

C_f1 = [cos(lam) -sin(lam) 0; sin(lam) cos(lam) 0; 0 0 1];
C_12 = [-sin(L) 0 -cos(L); 0 1 0; cos(L) 0 -sin(L)];
C_2n = [1 0 0; 0 cos(0) -sin(0); 0 sin(0) cos(0)];

% NED to ECEF
C_fn = C_f1*C_12*C_2n; 

% BODY to ECEF

C_BODYtoECEF = C_fn*C_nb;

C_if = eye(3,3);

% NED to ECI
C_in = C_if*C_fn;

C_NEDtoECI = C_in

% Body to ECI
C_BODYtoECI = C_in*C_nb 

% Part B

euler_ECEF = [60; -45; 45].*pi/180

euler_ECI = euler_ECEF

euler_NED = [0; 90; -60].*pi/180 

q_ECEF = [0.6661; 0.5534; -0.1295; 0.4830]

q_ECI = [0.6661; 0.5534; -0.1295; 0.4830]

q_NED = [-0.6124; -0.3536; -0.6124; 0.3526]

% Part C

tspan = 0:0.1:560;

u=398600e9;
r_e = 6378e3;
J2=1.082e-3;

w_e=7.2921159e-5;

C_BODYtoECI_initcond = [C_BODYtoECI(1,1); C_BODYtoECI(1,2); C_BODYtoECI(1,3); 
                        C_BODYtoECI(2,1); C_BODYtoECI(2,2); C_BODYtoECI(2,3); 
                        C_BODYtoECI(3,1); C_BODYtoECI(3,2); C_BODYtoECI(3,3)];

C_BODYtoECEF_initcond = [C_BODYtoECEF(1,1); C_BODYtoECEF(1,2); C_BODYtoECEF(1,3); 
                         C_BODYtoECEF(2,1); C_BODYtoECEF(2,2); C_BODYtoECEF(2,3); 
                         C_BODYtoECEF(3,1); C_BODYtoECEF(3,2); C_BODYtoECEF(3,3)];                    

C_BODYtoNED_initcond = [C_BODYtoNED(1,1); C_BODYtoNED(1,2); C_BODYtoNED(1,3); 
                        C_BODYtoNED(2,1); C_BODYtoNED(2,2); C_BODYtoNED(2,3); 
                        C_BODYtoNED(3,1); C_BODYtoNED(3,2); C_BODYtoNED(3,3)];                     
                     
h = 0;
f = 0.00335;

e = sqrt(2*f-(f^2));
r_lam = r_e/sqrt(1-((e^2)*(sind(L)^2)));

w_e_v = [0; 0; w_e];

r_ECEF_initcond = [((r_lam+h)*cos(L)*cos(lam)); 
                  ((r_lam+h)*cos(L)*sin(lam)); 
                  (((r_lam*(1-(e^2)))+h)*sin(L))];
              
v_ECEF_initcond = zeros(3,1);              
 
r_ECI_initcond = r_ECEF_initcond;              
              
v_ECI_initcond = cross(w_e_v,r_ECI_initcond);

v_NED_initcond = v_ECEF_initcond;

h_NED_initcond = 0;

lam_NED_initcond = lam;

L_NED_initcond = L;
              
options = odeset('RelTol',1e-10);

[T, ECI_DCM] = ode45(@ (t,C) ECIDCMupdate(t,C,u,r_e,J2), tspan, [C_BODYtoECI_initcond; r_ECI_initcond;  v_ECI_initcond], options);

C1_ECI = ECI_DCM(:,1);
C2_ECI = ECI_DCM(:,2);
C3_ECI = ECI_DCM(:,3);
C4_ECI = ECI_DCM(:,4);
C5_ECI = ECI_DCM(:,5);
C6_ECI = ECI_DCM(:,6);
C7_ECI = ECI_DCM(:,7);
C8_ECI = ECI_DCM(:,8);
C9_ECI = ECI_DCM(:,9);

C_ECI = [C1_ECI C2_ECI C3_ECI C4_ECI C5_ECI C6_ECI C7_ECI C8_ECI C9_ECI];

rx_ECI = ECI_DCM(:,10);
ry_ECI = ECI_DCM(:,11);
rz_ECI = ECI_DCM(:,12);

r_ECI = [rx_ECI ry_ECI rz_ECI];

LLA_ECI_DCM = ecef2lla(r_ECI);

figure(1)
plot3(r_ECI(:,1),r_ECI(:,2),r_ECI(:,3))
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
title('Missle Trajectory in ECI Frame Using DCM Method')

figure(2)
plot(tspan,C_ECI)
xlabel('Time of Flight (s)')
ylabel('DCM Elements')
title('Propogation of DCM Rotation Matrices for ECI Frame')
legend('C11','C12','C13','C21','C22','C23','C31','C32','C33')

figure(3)
plot(tspan,LLA_ECI_DCM(:,1))
xlabel('Time of Flight (s)')
ylabel('Latitude (deg)')
title('Propogation of Latitude for ECI Frame using DCM Method')

figure(4)
plot(tspan,LLA_ECI_DCM(:,2))
xlabel('Time of Flight (s)')
ylabel('Longitude (deg)')
title('Propogation of Longitude for ECI Frame using DCM Method')

figure(5)
plot(tspan,LLA_ECI_DCM(:,3)+10000)
xlabel('Time of Flight (s)')
ylabel('Height (m)')
title('Propogation of Height for ECI Frame using DCM Method')

[T, ECEF_DCM] = ode45(@ (t,C) ECEFDCMupdate(t,C,w_e_v,u,r_e,J2), tspan, [C_BODYtoECEF_initcond; r_ECEF_initcond;  v_ECEF_initcond], options);

C1_ECEF = ECEF_DCM(:,1);
C2_ECEF = ECEF_DCM(:,2);
C3_ECEF = ECEF_DCM(:,3);
C4_ECEF = ECEF_DCM(:,4);
C5_ECEF = ECEF_DCM(:,5);
C6_ECEF = ECEF_DCM(:,6);
C7_ECEF = ECEF_DCM(:,7);
C8_ECEF = ECEF_DCM(:,8);
C9_ECEF = ECEF_DCM(:,9);

C_ECEF = [C1_ECEF C2_ECEF C3_ECEF C4_ECEF C5_ECEF C6_ECEF C7_ECEF C8_ECEF C9_ECEF];

rx_ECEF = ECEF_DCM(:,10);
ry_ECEF = ECEF_DCM(:,11);
rz_ECEF = ECEF_DCM(:,12);

r_ECEF = [rx_ECEF ry_ECEF rz_ECEF];

LLA_ECEF_DCM = ecef2lla(r_ECEF);

figure(6)
plot3(r_ECEF(:,1),r_ECEF(:,2),r_ECEF(:,3))
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
title('Missle Trajectory in ECEF Frame Using DCM Method')

figure(7)
plot(tspan,C_ECEF)
xlabel('Time of Flight (s)')
ylabel('DCM Elements')
title('Propogation of DCM Rotation Matrices for ECEF Frame')
legend('C11','C12','C13','C21','C22','C23','C31','C32','C33')

figure(8)
plot(tspan,LLA_ECEF_DCM(:,1))
xlabel('Time of Flight (s)')
ylabel('Latitude (deg)')
title('Propogation of Latitude for ECEF Frame using DCM Method')

figure(9)
plot(tspan,LLA_ECEF_DCM(:,2))
xlabel('Time of Flight (s)')
ylabel('Longitude (deg)')
title('Propogation of Longitude for ECEF Frame using DCM Method')

figure(10)
plot(tspan,LLA_ECEF_DCM(:,3)+10000)
xlabel('Time of Flight (s)')
ylabel('Height (m)')
title('Propogation of Height for ECEF Frame using DCM Method')
 
[T, ECI_QUAT] = ode45(@ (t,C) ECIQUATupdate(t,C,u,r_e,J2), tspan, [q_ECI; r_ECI_initcond;  v_ECI_initcond], options);

C1_ECI_QUAT = ECI_QUAT(:,1);
C2_ECI_QUAT = ECI_QUAT(:,2);
C3_ECI_QUAT = ECI_QUAT(:,3);
C4_ECI_QUAT = ECI_QUAT(:,4);

C_ECI_QUAT = [C1_ECI_QUAT C2_ECI_QUAT C3_ECI_QUAT C4_ECI_QUAT];

rx_ECI_Q = ECI_QUAT(:,5);
ry_ECI_Q = ECI_QUAT(:,6);
rz_ECI_Q = ECI_QUAT(:,7);

r_ECI_Q = [rx_ECI_Q ry_ECI_Q rz_ECI_Q];

LLA_ECI_Q = ecef2lla(r_ECI_Q);

figure(11)
plot3(r_ECI_Q(:,1),r_ECI_Q(:,2),r_ECI_Q(:,3))
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
title('Missle Trajectory in ECI Frame Using Quaternion Method')

figure(12)
plot(tspan,C_ECI_QUAT)
xlabel('Time of Flight (s)')
ylabel('Quaternion Elements')
title('Propogation of Quaternions for ECI Frame')
legend('q1','q2','q3','q4')

figure(13)
plot(tspan,LLA_ECI_Q(:,1))
xlabel('Time of Flight (s)')
ylabel('Latitude (deg)')
title('Propogation of Latitude for ECI Frame using Quaternion Method')

figure(14)
plot(tspan,LLA_ECI_Q(:,2))
xlabel('Time of Flight (s)')
ylabel('Longitude (deg)')
title('Propogation of Longitude for ECI Frame using Quaternion Method')

figure(15)
plot(tspan,LLA_ECI_Q(:,3)+10000)
xlabel('Time of Flight (s)')
ylabel('Height (m)')
title('Propogation of Height for ECI Frame using Quaternion Method')

[T, ECI_Euler] = ode45(@ (t,C) ECIEULERupdate(t,C,u,r_e,J2), tspan, [euler_ECI; r_ECI_initcond;  v_ECI_initcond], options);

C1_ECI_Euler = ECI_Euler(:,1);
C2_ECI_Euler = ECI_Euler(:,2);
C3_ECI_Euler = ECI_Euler(:,3);

C_ECI_Euler = [C1_ECI_Euler C2_ECI_Euler C3_ECI_Euler];

rx_ECI_Euler = ECI_Euler(:,4);
ry_ECI_Euler = ECI_Euler(:,5);
rz_ECI_Euler = ECI_Euler(:,6);

r_ECI_Euler = [rx_ECI_Euler ry_ECI_Euler rz_ECI_Euler];

LLA_ECI_Euler = ecef2lla(r_ECI_Euler);

figure(16)
plot3(r_ECI_Euler(:,1),r_ECI_Euler(:,2),r_ECI_Euler(:,3))
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
title('Missle Trajectory in ECI Frame Using Euler Angles Method')

figure(17)
plot(tspan,C_ECI_Euler)
xlabel('Time of Flight (s)')
ylabel('Euler Angle Elements')
title('Propogation of Euler Angles Rotation Matrices for ECI Frame')
legend('phi','theta','psi')

figure(18)
plot(tspan,LLA_ECI_Euler(:,1))
xlabel('Time of Flight (s)')
ylabel('Latitude (deg)')
title('Propogation of Latitude for ECI Frame using Euler Angles Method')

figure(19)
plot(tspan,LLA_ECI_Euler(:,2))
xlabel('Time of Flight (s)')
ylabel('Longitude (deg)')
title('Propogation of Longitude for ECI Frame using Euler Angles Method')

figure(20)
plot(tspan,LLA_ECI_Euler(:,3)+10000)
xlabel('Time of Flight (s)')
ylabel('Height (m)')
title('Propogation of Height for ECI Frame using Euler Angles Method')

[T, ECEF_QUAT] = ode45(@ (t,C) ECEFQUATupdate(t,C,w_e_v,u,r_e,J2), tspan, [q_ECEF; r_ECEF_initcond;  v_ECEF_initcond], options);

C1_ECEF_QUAT = ECEF_QUAT(:,1);
C2_ECEF_QUAT = ECEF_QUAT(:,2);
C3_ECEF_QUAT = ECEF_QUAT(:,3);
C4_ECEF_QUAT = ECEF_QUAT(:,4);

C_ECEF_QUAT = [C1_ECEF_QUAT C2_ECEF_QUAT C3_ECEF_QUAT C4_ECEF_QUAT];

rx_ECEF_QUAT = ECEF_QUAT(:,5);
ry_ECEF_QUAT = ECEF_QUAT(:,6);
rz_ECEF_QUAT = ECEF_QUAT(:,7);

r_ECEF_QUAT = [rx_ECEF_QUAT ry_ECEF_QUAT rz_ECEF_QUAT];

LLA_ECEF_QUAT = ecef2lla(r_ECEF_QUAT);

figure(21)
plot3(r_ECEF_QUAT(:,1),r_ECEF_QUAT(:,2),r_ECEF_QUAT(:,3))
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
title('Missle Trajectory in ECEF Frame Using Quaternion Method')

figure(22)
plot(tspan,C_ECEF_QUAT)
xlabel('Time of Flight (s)')
ylabel('Quaternion Elements')
title('Propogation of Quaternions for ECEF Frame')
legend('q1','q2','q3','q4')

figure(23)
plot(tspan,LLA_ECEF_QUAT(:,1))
xlabel('Time of Flight (s)')
ylabel('Latitude (deg)')
title('Propogation of Latitude for ECEF Frame using Quaternion Method')

figure(24)
plot(tspan,LLA_ECEF_QUAT(:,2))
xlabel('Time of Flight (s)')
ylabel('Longitude (deg)')
title('Propogation of Longitude for ECEF Frame using Quaternion Method')

figure(25)
plot(tspan,LLA_ECEF_QUAT(:,3)+10000)
xlabel('Time of Flight (s)')
ylabel('Height (m)')
title('Propogation of Height for ECEF Frame using Quaternion Method')

[T, ECEF_Euler] = ode45(@ (t,C) ECEFEULERupdate(t,C,w_e_v,u,r_e,J2), tspan, [euler_ECEF; r_ECEF_initcond;  v_ECEF_initcond], options);

C1_ECEF_Euler = ECEF_Euler(:,1);
C2_ECEF_Euler = ECEF_Euler(:,2);
C3_ECEF_Euler = ECEF_Euler(:,3);

C_ECEF_Euler = [C1_ECEF_Euler C2_ECEF_Euler C3_ECEF_Euler];

rx_ECEF_Euler = ECEF_Euler(:,4);
ry_ECEF_Euler = ECEF_Euler(:,5);
rz_ECEF_Euler = ECEF_Euler(:,6);

r_ECEF_Euler = [rx_ECEF_Euler ry_ECEF_Euler rz_ECEF_Euler];

LLA_ECEF_Euler = ecef2lla(r_ECEF_Euler);

figure(26)
plot3(r_ECEF_Euler(:,1),r_ECEF_Euler(:,2),r_ECEF_Euler(:,3))
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
title('Missle Trajectory in ECEF Frame Using Euler Angles Method')

figure(27)
plot(tspan,C_ECEF_Euler)
xlabel('Time of Flight (s)')
ylabel('Euler Angle Elements')
title('Propogation of Euler Angles Rotation Matrices for ECEF Frame')
legend('phi','theta','psi')

figure(28)
plot(tspan,LLA_ECEF_Euler(:,1))
xlabel('Time of Flight (s)')
ylabel('Latitude (deg)')
title('Propogation of Latitude for ECEF Frame using Euler Angles Method')

figure(29)
plot(tspan,LLA_ECEF_Euler(:,2))
xlabel('Time of Flight (s)')
ylabel('Longitude (deg)')
title('Propogation of Longitude for ECEF Frame using Euler Angles Method')

figure(30)
plot(tspan,LLA_ECEF_Euler(:,3)+10000)
xlabel('Time of Flight (s)')
ylabel('Height (m)')
title('Propogation of Height for ECEF Frame using Euler Angles Method')

[T, NED_DCM] = ode45(@ (t,C) NEDDCMupdate(t,C,w_e_v,u,r_e,J2,f,C_fn), tspan, [C_BODYtoNED_initcond; v_NED_initcond; h_NED_initcond; lam_NED_initcond; L_NED_initcond], options);

C1_NED = NED_DCM(:,1);
C2_NED = NED_DCM(:,2);
C3_NED = NED_DCM(:,3);
C4_NED = NED_DCM(:,4);
C5_NED = NED_DCM(:,5);
C6_NED = NED_DCM(:,6);
C7_NED = NED_DCM(:,7);
C8_NED = NED_DCM(:,8);
C9_NED = NED_DCM(:,9);

C_NED = [C1_NED C2_NED C3_NED C4_NED C5_NED C6_NED C7_NED C8_NED C9_NED];

h_NED_DCM = NED_DCM(:,13);
lam_NED_DCM = NED_DCM(:,14).*180/pi;
L_NED_DCM = NED_DCM(:,15).*180/pi;

figure(31)
plot(tspan,C_NED)
xlabel('Time of Flight (s)')
ylabel('DCM Elements')
title('Propogation of DCM Rotation Matrices for NED Frame')
legend('C11','C12','C13','C21','C22','C23','C31','C32','C33')

figure(32)
plot(tspan,h_NED_DCM)
xlabel('Trajectory Duration (s)')
ylabel('Height of Missle (m)')
title('Height of Missle, NED frame using DCM')

figure(33)
plot(tspan,lam_NED_DCM)
xlabel('Trajectory Duration (s)')
ylabel('Longitude of Missle (deg)')
title('Longitude of Missle, NED frame using DCM')

figure(34)
plot(tspan,L_NED_DCM)
xlabel('Trajectory Duration (s)')
ylabel('Latitude of Missle (deg)')
title('Latitude of Missle, NED frame using DCM')

[T, NED_QUAT] = ode45(@ (t,C) NEDQUATupdate(t,C,w_e_v,u,r_e,J2,f,C_fn), tspan, [q_NED; v_NED_initcond; h_NED_initcond; lam_NED_initcond; L_NED_initcond], options);

C1_NED_QUAT = NED_QUAT(:,1);
C2_NED_QUAT = NED_QUAT(:,2);
C3_NED_QUAT = NED_QUAT(:,3);
C4_NED_QUAT = NED_QUAT(:,4);

C_NED_QUAT = [C1_NED_QUAT C2_NED_QUAT C3_NED_QUAT C4_NED_QUAT];

h_NED_QUAT = NED_QUAT(:,8);
lam_NED_QUAT = NED_QUAT(:,9).*180/pi;
L_NED_QUAT = NED_QUAT(:,10).*180/pi;

figure(35)
plot(tspan,C_NED_QUAT)
xlabel('Time of Flight (s)')
ylabel('Quaternion Elements')
title('Propogation of Quaternions for NED Frame')
legend('q1','q2','q3','q4')

figure(36)
plot(tspan,h_NED_QUAT)
xlabel('Trajectory Duration (s)')
ylabel('Height of Missle (m)')
title('Height of Missle, NED frame using Quaternions')

figure(37)
plot(tspan,lam_NED_QUAT)
xlabel('Trajectory Duration (s)')
ylabel('Longitude of Missle (deg)')
title('Longitude of Missle, NED frame using Quaternions')

figure(38)
plot(tspan,L_NED_QUAT)
xlabel('Trajectory Duration (s)')
ylabel('Latitude of Missle (deg)')
title('Latitude of Missle, NED frame using Quaternions')

figure(39)
hold on
[x,y,z]=sphere(40);
surf(r_e*x,r_e*y,r_e*z)
plot3(r_ECI(:,1),r_ECI(:,2),r_ECI(:,3))
axis equal
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
title('Missle Trajectory in ECI Frame Using DCM Method')























