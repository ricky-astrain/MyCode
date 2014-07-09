%% Steady State Thermal Analysis for Capstone Project
clear all; close all; clc

% Calculation of Spacecraft Tempurature

% Hughson White Paint A-276

er = 0.98;  % Parsons Black Paint     % emissivity of radiator [NASApub1121-Absorptance-Emittance.pdf]
Ar = 10.5;                            % area of radiator, m^2 [SolidWorks Model]
sigma=5.670373*10^-8;                 % Stephen-Boltmann Constant, W/(m^2*K^4)
Ts = 2.7;                             % sink tempurature, K [FIND REFERENCE]
Asa = 0;                              % area of solar array, m^2 [SolidWorks Model]
asc = 0.34; % GSFC White Paint NS44-B % absorptivity of satellite facing the sun [NASApub1121-Absorptance-Emittance.pdf]
Asc = Ar;                             % area of satellite facing sun, m^2 [SolidWorks Model]
qs = 1244.844;                        % solar constant with view factor incorporated [SHOW EQUATION]
Q = 484*0.06;                         % Power dissapation assuming %6 of power is dissapated as heat


% Steady State Thermal Equation, [Satellite_TC.pdf]
T_satellite = (((((((asc*Asc))*qs)+Q)/(er*Ar*sigma))-(Ts^4))^(1/4))-273 % Steady State Tempurature, C

% Calculation of Solar Array Tempurature

as = mean([0.78; 0.82; 0.77; 0.86;    % average apsorptiviity of solar cells [NASApub1121-Absorptance-Emittance.pdf]
           0.85; 0.82; 0.77; 0.82; 
           0.91; 0.81; 0.80; 0.75; 
           0.78; 0.78; 0.91; 0.86; 
           0.85; 0.77; 0.81; 0.86; 
           0.79]);
Fp = 0.95;                            % packing factor for solar array, [Spacecraft & Launch Vehicle Design]
n = 0.185;                            % efficiency of sllor cells, [Taken from EPS Subsystem Design]
asa = as-Fp*n;                        % absorptivity of solar array [MAE 445 Thermal Lectures, SHOW ORIGINAL SOURCE]

esa_f = mean([0.82; 0.85; 0.80;       % emissivity of the front of the solar panels,averaged [NASApub1121-Absorptance-Emittance.pdf]
              0.85; 0.85; 0.85;
              0.81; 0.80; 0.81;
              0.80; 0.82; 0.79;
              0.82; 0.81; 0.79;
              0.84; 0.81; 0.81;
              0.80; 0.86; 0.82]);
esa_b = 0.85;                         % emissivity of the back of the solar panels, assumed to be something black [NASApub1121-Absorptance-Emittance.pdf]

T_solar_array = (((asa*qs)/((esa_f+esa_b)*sigma))^(1/4))-273

%% Creation of plots

er = 0:0.01:1;
asc = 0:0.01:1;

for i = 1:length(er)
    for j = 1:length(asc)
        
       T_satellite_plot(i,j) = (((((((asc(j)*Asc))*qs)+Q)/(er(i)*Ar*sigma))-(Ts^4))^(1/4))-273; % Steady State Tempurature, C
        
        if T_satellite_plot(i,j) > -10 & T_satellite_plot(i,j) <= 45
            T(i,j)=T_satellite_plot(i,j);
        else
            T(i,j)=NaN;
        end
    end
end

figure(1)
surf(er,asc,T_satellite_plot,'EdgeColor','interp')
view(2)
colorbar
xlabel('Emissivity of Radiative Surface')
ylabel('Absorptivity of Sun-Facing Surface')
title('Steady State Tempurature of Satellite')

figure(2)
surf(er,asc,T,'EdgeColor','interp')
view(2)
colorbar
axis([0 0.45 0.1 1])
xlabel('Emissivity of Radiative Surface')
ylabel('Absorptivity of Sun-Facing Surface')
title('Steady State Tempurature of Satellite')












