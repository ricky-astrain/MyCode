%% Homework 3
%% Ricardo Astrain
%% 1202816259
%% 3/5/2014

clear all
close all
clc

%% Problem 1

x=linspace(0,5,100);

n=1:100;

t=[0 1.5 2.5 3.5 5 9];

for k=1:length(t)

    for j=1:length(x)
        
        for i=1:length(n)
            
            a_n(i)=((-2*((pi*n(i)*cos((n(i)*pi)/5))-(5*sin((n(i)*pi)/5))))/((pi^2)*(n(i)^2)))+((1*((5*sin((n(i)*pi)/5))-(5*sin(pi*n(i)))+((4*pi*n(i))*cos((n(i)*pi)/5))))/(2*((pi^2)*(n(i)^2))));
            
            y(i)=sin(((n(i)*pi)/5)*x(j))*cos(((n(i)*pi)/5)*t(k));
            
            an_y(i)=a_n(i)*y(i);
            
        end
        
        u(j,k)=sum(an_y);
        
    end
end

figure(1)
plot(x,u,'linewidth',2)
legend('t=0','t=1.5','t=2.5','t=3.5','t=5')
xlabel('x')
ylabel('u(x,t)')
title('Solution for Problem 1')

%% Problem 2

x=linspace(0,1,100);

y=linspace(0,1,100);

for k=1:length(y)

    for j=1:length(x)
            
       u(j,k)=((1/2)*(cos(pi*x(j))*cosh(pi*(y(k)-1))))+2;
        
        
        x2d(j,k)=x(j);
        y2d(j,k)=y(k);
        
    end
end

figure(2)
[C,h] = contour(x2d,y2d,u);
clabel(C,h,[-10:0.5:10])
xlabel('x') 
ylabel('y')
title('Solution for Problem 2')

disp('Calculation for u(0.3,0.4)')
format short
u=u(31,41)

disp('This is an estimation as the linspace function does not provide the exact values of x=0.3 & y=0.4')



























