clear all
clc

%MAE 445, Homework 9
%Problem 2
%Constants
eIR=0.85;
Ar=0.75*0.75;
fluxIR=69.8;
sigma=5.6705e-8;
% Soultion
for i=1 % This is to initialize the tempurature vector
t(i)=i-1;
Qint(i)=55*sin(33929.2*t(i))+155; % Periodic model of heat load from 100 to 210 W
T(i)=(((eIR*fluxIR*Ar)+Qint(i))./(eIR*sigma*Ar)).^(1/4);
end
for i=2:10*5400 % This is the tempurature as a function of the heating system
    if T(i-1)<=285
        t(i)=i-1;
        Qint_norm(i)=55*sin(33929.2*t(i))+155;
        Qint_heat(i)=15;
        Qint(i)=Qint_norm(i)+Qint_heat(i);
        T(i)=(((eIR*fluxIR*Ar)+Qint(i))./(eIR*sigma*Ar)).^(1/4);
        
    else
             t(i)=i-1;
             Qint(i)=55*sin(33929.2*t(i))+155;
             T(i)=(((eIR*fluxIR*Ar)+Qint(i))./(eIR*sigma*Ar)).^(1/4);
    end
end

for i=1:length(T) % 
    if T(i)<=270
        disp('error')
    elseif T(i)>=310
        disp('error')
    else
    end
end