%% Homework 5 MatLab Code and Results
clear all; close all; clc
%% Problem 1
% Part A
x = 0:0.01:1;
for i = 1:length(x)
    if x(i) <= 0.5
        f(i) = 1;
    else
        f(i) = 1-x(i);
    end
end
for j = 1:length(x)
for n = 1:5
       
    b1_5(n) = (2/(n*pi))*(1-cos(n*pi));
    b2_5(n) = -((1/n^2)*(-0.202642*sin((pi/2)*n)+0.202642*sin(pi*n)+0.31831*n*cos((pi/2)*n)-0.63662*n*cos(pi*n)));
    
    b_5(n) = b1_5(n)+b2_5(n);
    
    y_5(n) = b_5(n)*sin(n*pi*x(j));
end
    u_5(1,j) = sum(y_5);
end
for j = 1:length(x)
for n = 1:10
       
    b1_10(n) = (2/(n*pi))*(1-cos(n*pi));
    b2_10(n) = -((1/n^2)*(-0.202642*sin((pi/2)*n)+0.202642*sin(pi*n)+0.31831*n*cos((pi/2)*n)-0.63662*n*cos(pi*n)));
    
    b_10(n) = b1_10(n)+b2_10(n);
    
    y_10(n) = b_10(n)*sin(n*pi*x(j));
end
    u_10(1,j) = sum(y_10);
end
for j = 1:length(x)
for n = 1:30
       
    b1_30(n) = (2/(n*pi))*(1-cos(n*pi));
    b2_30(n) = -((1/n^2)*(-0.202642*sin((pi/2)*n)+0.202642*sin(pi*n)+0.31831*n*cos((pi/2)*n)-0.63662*n*cos(pi*n)));
    
    b_30(n) = b1_30(n)+b2_30(n);
    
    y_30(n) = b_30(n)*sin(n*pi*x(j));
end
    u_30(1,j) = sum(y_30);
end
figure(1)
plot(x,f,'-',x,u_5,':',x,u_10,'-.',x,u_30,'--')
axis([0 1 -0.2 1.2])
xlabel('x'); ylabel('f(x), F_s(x)'); title('Solution for Problem 1 Part A')
legend('f(x)','F_s(x), n=5','F_s(x), n=10','F_s(x), n=30')
% Part B
disp('Values of F_s(0.75) at n = 5, 10, 30')
disp('    ')
disp('F_s(0.75) at n=5')
u_5(76)
disp('F_s(0.75) at n=10')
u_10(76)
disp('F_s(0.75) at n=30')
u_30(76)
disp('    ')
disp('    ')
disp('Comparison of F_s(x) Values at x=0.75 with original function')
disp('    ')
disp('Percent Difference at n=5')
abs((f(76)-u_5(76))/f(76))*100
disp('Percent Difference at n=10')
abs((f(76)-u_10(76))/f(76))*100
disp('Percent Difference at n=30')
abs((f(76)-u_30(76))/f(76))*100
disp('    ')
disp('    ')
disp('Values of F_s(0.51) at n = 5, 10, 30')
disp('    ')
disp('F_s(0.51) at n=5')
u_5(52)
disp('F_s(0.51) at n=10')
u_10(52)
disp('F_s(0.51) at n=30')
u_30(52)
disp('    ')
disp('    ')
disp('Comparison of F_s(x) Values at x=0.51 with original function')
disp('    ')
disp('Percent Difference at n=5')
abs((f(52)-u_5(52))/f(52))*100
disp('Percent Difference at n=10')
abs((f(52)-u_10(52))/f(52))*100
disp('Percent Difference at n=30')
abs((f(52)-u_30(52))/f(52))*100
% Part C
n_v = 1:30;
for i = 1:length(n_v)
for n = 1:n_v(i)
       
    b1(n) = (2/(n*pi))*(1-cos(n*pi));
    b2(n) = -((1/n^2)*(-0.202642*sin((pi/2)*n)+0.202642*sin(pi*n)+0.31831*n*cos((pi/2)*n)-0.63662*n*cos(pi*n)));
    
    b(n) = b1(n)+b2(n);
    
    y(n) = b(n)*sin(n*pi*0.5);
end
    Fs(i) = sum(y);
end
figure(2)
plot(n_v,Fs)
% Part D
x = 0:0.01:1;
a0 = 5/8;
for i = 1:length(x)
    if x(i) <= 0.5
        f(i) = 1;
    else
        f(i) = 1-x(i);
    end
end
for j = 1:length(x)
for n = 1:5
       
    a1_5(n) = (0.31831*sin(1.5708*n))/n;
    a2_5(n) = (-0.159155*n*sin(1.5708*n)+0.101321*cos(1.5708*n)-0.101321*cos(3.14159*n))/(n^2);
    
    a_5(n) = 2*(a1_5(n)+a2_5(n));
    
    z_5(n) = a_5(n)*cos(n*pi*x(j));
end
    F_5(1,j) = a0+sum(z_5);
end
for j = 1:length(x)
for n = 1:10
       
    a1_10(n) = (0.31831*sin(1.5708*n))/n;
    a2_10(n) = (-0.159155*n*sin(1.5708*n)+0.101321*cos(1.5708*n)-0.101321*cos(3.14159*n))/(n^2);
    
    a_10(n) = 2*(a1_10(n)+a2_10(n));
    
    z_10(n) = a_10(n)*cos(n*pi*x(j));
end
    F_10(1,j) = a0+sum(z_10);
end
for j = 1:length(x)
for n = 1:30
       
    a1_30(n) = (0.31831*sin(1.5708*n))/n;
    a2_30(n) = (-0.159155*n*sin(1.5708*n)+0.101321*cos(1.5708*n)-0.101321*cos(3.14159*n))/(n^2);
    
    a_30(n) = 2*(a1_30(n)+a2_30(n));
    
    z_30(n) = a_30(n)*cos(n*pi*x(j));
end
    F_30(1,j) = a0+sum(z_30);
end
figure(3)
plot(x,f,'-',x,F_5,':',x,F_10,'-.',x,F_30,'--')
axis([0 1 -0.2 1.2])
xlabel('x'); ylabel('f(x), F_s(x)'); title('Solution for Problem 1 Part D')
legend('f(x)','F_c(x), n=5','F_c(x), n=10','F_c(x), n=30')
%% Problem 2
x = 1;
t = 0.0001;
disp('u(x,t) @ x = 1. t = 0.01')
u = 5+2*cos(3*x-27*t)*exp(81*t)
%% Problem 3
% Part A
w = 0:0.01:30;
F_w = (1-cos(w))./(2*pi.*w);
figure(4)
plot(w,F_w)
xlabel('w'); ylabel('F'); title('Solution for Problem 3, Part A')
% Part B
L = [2; 5; 100];
n_v = [60/pi 150/pi 3000/pi];
for i = 1:length(L)
    for n = 1:n_v(i)
        c(i,n) = (2/(pi*n))*(1-cos((n*pi)/L(i)));
    end
end
n1 = linspace(1,n_v(1),length(c(1,1:20)));
figure(5)
plot(n1,c(1,1:20))
xlabel('n'); ylabel('a_n'); title('Solution for Problem 3, Part B, where 1<=n<60/pi & L=2')
n2 = linspace(1,n_v(2),length(c(1,1:48)));
figure(6)
plot(n2,c(2,1:48))
xlabel('n'); ylabel('a_n'); title('Solution for Problem 3, Part B, where 1<=n<100/pi & L=5')
n2 = linspace(1,n_v(3),length(c(1,1:954)));
figure(7)
plot(n2,c(3,1:954))
xlabel('n'); ylabel('a_n'); title('Solution for Problem 3, Part B, where 1<=n<3000/pi & L=100')





























