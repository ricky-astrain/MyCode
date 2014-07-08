%% Homework 2
%% Ricardo Astrain
%% 1202816259
%% 2-26-2014
%% MAE 502

clear all
clc
close all

%% Problem 1
x=linspace(0,1,100);

n=1:200;

t=[0 0.05 0.2 0.5 100];

for k=1:length(t)

    for j=1:length(x)
        
        for i=1:length(n)
            
            a_n(i)=-(12*(((pi*2)*((1-2*n(i))^2)+8)*sin(pi*n(i))-8))/((pi^3)*((2*n(i)-1)^3));
            
            y(i)=sin(((pi/2)-pi*n(i))*x(j))*exp(-(((pi/2)-pi*n(i))^2)*t(k));
            
            v(i)=a_n(i)*y(i);
            
        end
        
        u_E(j)=2*x(j)+2;
        
        u(j,k)=sum(v)+u_E(j);
        
    end
end

figure(1)
plot(x,u,'linewidth',2)
legend('t=0','t=0.05','t=0.2','t=0.5','Steady State')
xlabel('x')
ylabel('u(x,t)')
title('Solution for Problem 1')

%% Problem 2
clear all
close all

x=linspace(0,1,100);

n=[1 3:100];

y=linspace(0,2,100);

for k=1:length(y)

    for j=1:length(x)
        
        for i=1:length(n)
            
            a_n1(i)=((4*cos(n(i)*pi)-4)/(pi*sinh(-2*n(i)*pi)*(n(i)^3-4*n(i))));
            
            y1(i)=sin(n(i)*pi*x(j))*sinh(n(i)*pi*(y(k)-2));
            
            u1(i)=a_n1(i)*y1(i);
            
            a_n2(i)=((-24*cos(n(i)*pi)+24)/(n(i)^3*pi^3*sinh(n(i)*pi/2)));
            
            y2(i)=sinh((n(i)*pi/2)*x(j))*sin((n(i)*pi/2)*y(k));
            
            u2(i)=a_n2(i)*y2(i);
            
        end
        
        u(j,k)=sum(u1)+sum(u2);
        x2d(j,k)=x(j);
        y2d(j,k)=y(k);
        
    end
end

figure(2)
[C,h] = contour(x2d,y2d,u,[0.1:0.1:1.5]);
clabel(C,h,[0.1:0.1:1.5])
xlabel('x') 
ylabel('y')
title('Solution for Problem 2')

disp(u(51,51))

%% Problem 3

x=linspace(0,1,100);

c=[-50 -20 -5 0 5 20 50];

for i=1:length(x)
    
    for j=1:length(c)
        
        if c(j) > 0
            
           G(i,j) = (csch(sqrt(c(j)))*exp(sqrt(c(j))*x(i)))-(csch(sqrt(c(j)))*exp(-sqrt(c(j))*x(i)));
           
        elseif c(j) < 0
            
            G(i,j) = 2*csc(sqrt(-c(j)))*sin(sqrt(-c(j))*x(i));
            
        else 
            
            G(i,j) = 2*x(i);
            
        end
        
    end
    
end

figure(3)
plot(x,G,'linewidth',2)
xlabel('x')
ylabel('y')
title('Solution for Problem 3, Part B')
legend('c=-50','c=-20','c=-5','c=0','c=5','c=20','c=50')

























