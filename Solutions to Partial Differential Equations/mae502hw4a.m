clear all
close all
clc

t = [0 0.01 0.05 0.2 100];

x=0:0.1:1;

n = 1:100;

for i = 1:length(t)
    
    for j = 1:length(x)
        
        for k = 1:length(n)
            
            %an0(k) = 2*(((((4*sin(pi*n(k)*0.5))-((4*pi*0.5*n(k))*cos(pi*n(k)*0.5)))/((pi^2)*(n(k)^2)))+((cos(pi*n(k)*0.5))/(pi*n(k))))-((((4*sin(pi*n(k)*0.25))-((4*pi*0.25*n(k))*cos(pi*n(k)*0.25)))/((pi^2)*(n(k)^2)))+((cos(pi*n(k)*0.25))/(pi*n(k)))))-((((3*cos(pi*n(k)*0.75))/(pi*n(k)))+((4*sin(pi*n(k)*0.75))-(4*pi*n(k)*0.75*cos(pi*n(k)*0.75)))/((pi^2)*(n(k)^2)))-(((3*cos(pi*n(k)*0.5))/(pi*n(k)))+((4*sin(pi*n(k)*0.5))-(4*pi*n(k)*0.5*cos(pi*n(k)*0.5)))/((pi^2)*(n(k)^2))));
            
            %qn(k) = 2*((-(((20*cos(pi*n(k)*0.75))/(pi*n(k)))+(40*sin(pi*n(k)*0.75))-(40*pi*0.75*n(k)*cos(pi*n(k)*0.75))))-(-(((20*cos(pi*n(k)*0.5))/(pi*n(k)))+(40*sin(pi*n(k)*0.5))-(40*pi*0.5*n(k)*cos(pi*n(k)*0.5)))))+(((((40*sin(pi*n(k)*1))-(40*pi*1*n(k)*cos(pi*n(k)*1)))/((pi^2)*(n(k)^2)))+((40*cos(pi*n(k)*1))/(pi*n(k))))-(((40*sin(pi*n(k)*0.75))-(40*pi*0.75*n(k)*cos(pi*n(k)*0.75)))/((pi^2)*(n(k)^2))+((40*cos(pi*n(k)*0.75))/(pi*n(k)))));                
            
            an01(k) = 2*((((4*sin(pi*n(k)*0.5))/((pi^2)*(n(k)^2)))-((4*0.5*cos(pi*n(k)*0.5))/(pi*n(k)))+((cos(pi*n(k)*0.5))/(pi*n(k))))-(((4*sin(pi*n(k)*0.25))/((pi^2)*(n(k)^2)))-((4*0.25*cos(pi*n(k)*0.25))/(pi*n(k)))+((cos(pi*n(k)*0.25))/(pi*n(k)))));
            an02(k) = 2*((((-4*sin(pi*n(k)*0.75))/((pi*n(k))^2))+((4*0.75*cos(pi*n(k)*0.75))/(pi*n(k)))-((3*cos(pi*n(k)*0.75))/(pi*n(k))))-(((-4*sin(pi*n(k)*0.5))/((pi*n(k))^2))+((4*0.5*cos(pi*n(k)*0.5))/(pi*n(k)))-((3*cos(pi*n(k)*0.5))/(pi*n(k)))));
            an0(k) = an01(k)+an02(k);
            
            qn1(k) = 2*(((-40*sin(pi*n(k)*0.75))/((pi^2)*(n(k)^2)))+((40*0.75*cos(pi*n(k)*0.5))/(pi*n(k)))-((20*cos(pi*n(k)*0.75))/(pi*n(k))));
            qn2(k) = 2*(((40*sin(pi*n(k)*1))/((pi^2)*(n(k)^2)))-((40*1*cos(pi*n(k)*1))/(pi*n(k)))+((40*cos(pi*n(k)*1))/(pi*n(k))));
            qn(k) = qn1(k)+qn2(k);
            
            an(k) = an0(k)*exp(((pi*n(k))^2)*t(i))+exp(((pi*n(k))^2)*t(i))*qn(k)*((exp(((pi*n(k))^2)*t(i))/((pi^2)*(n(k)^2)))-(exp(((pi*n(k))^2)*0)/((pi^2)*(n(k)^2))));
            
            y(k) = sin(pi*n(k)*x(j));
            
            up(k) = an(k)*y(k);
        end
        
            u(i,j) = sum(up(k));
        
    end
    
    
    
    
end