clear all
close all
clc

%% Cylinder analysis

% Inputs -------------------

FS = 1.2; % factor of safety

% geometrey properties

t = 2.5/1000; % thickness, meters
d = 3; % diameter, meters
r = d/2; % radius, meters
m = 3300; % mass, kilograms
h = 3.5; % meters
c=h/2;
y_cent = 1.6;

% material properties of Aluminim 7075

E=71e9;
v=0.33;
rho=2.7e3;
Ftu=524e6;
Fty=448e6;

%------------------------------

A = pi*((r^2)-(r-t)^2); % cross sectional area
I = (pi/4)*((r^4)-(r-t)^4); % bending moment of inertia

g_axial = 7.9*9.81; % for delta 4 medium
g_lat = 2*9.81; % for delta 4 medium

LF_axial = m*g_axial; % load factor, N
LF_lat = m*g_lat; % load factor, N

DL_axial = FS*LF_axial; % design load, N
DL_lat = FS*LF_lat; % design load, N

P = DL_axial;
M = DL_lat*y_cent;

normal_stress = (P/A)+(M*c/I);

normal_stress_allowable = 276e6;

FS = Fty/normal_stress

%--------Determine Bucking Values----------

phi = (1/16)*sqrt(r/t);
gamma = 1-0.09*(1-exp(-phi));
sigma_c=gamma*(E/sqrt(3*(1-(v^2))))*(t/r);

Pc=sigma_c/A;
Mc=sigma_c*(I/r);

% Evaluation of thickness

Safety_Margin = (1/((P/Pc)+(M/Mc)))-1

disp('Required Thickness is t=3.125mm (~1/8in)')

%% Determination of Natural Frequencies
% Assume cantilevered beam

fnat_axial = 0.250*sqrt(A*E/m*h)

fnat_lat = 0.560*sqrt(E*I/(m*(h^3)))






