clear all; close all; clc
dx = 0.01; 
x = 0:dx:1; 
N = length(x); 
v = zeros(N,N-2);
c = zeros(N-2); 
V = zeros(N-2,N-2); 
D = zeros(N-2,N-2); 
S = zeros(N-2,N-2);
cs = zeros(N-2); 
vs = zeros(N,N-2);
% -- costruct K & dK/dx & D
K = 5*(x.^2)+0.01;
dK = 10.*x;
D = 50.*x;
% -- construct the main matrix for the eigenvalue problem 
S(1,1) = ((-2*K(1))/(dx^2))-D(1); 
S(1,2) = (-dK(1)/(2*dx))+(K(1)/(dx^2));
S(N-2,N-2) = ((-2*K(N-1))/(dx^2))-D(N-1); 
S(N-2,N-3) = (-dK(N-1)/(2*dx))+(K(N-1)/(dx^2));
for i = 2:N-3 
 S(i,i) = ((-2*K(i+1))/(dx^2))-D(i+1); 
 S(i,i-1) = (-dK(i+1)/(2*dx))+(K(i+1)/(dx^2)); 
 S(i,i+1) = (dK(i+1)/(2*dx))+(K(i+1)/(dx^2));
end
% -- solve the eigenvalue problem 
[V D] = eig(S);
for i = 1:N-2
 c(i) = D(i,i);
 v(:,i) = [0 V(:,i)' 0];
end
% -- the following section is for sorting the eigenvectors in descending
% order of the absolute value of their corresponding eigenvalues 
for i = 1:N-2
 crank(i) = 1;
 for j = 1:N-2
 if abs(c(i)) > abs(c(j))
 crank(i) = crank(i)+1;
 end
 end
end
for i = 1:N-2
 cs(crank(i)) = c(i);
 vs(:,crank(i)) = v(:,i);
end
% -- output the values of the first 3 eigenvalues and plot the
% corresponding eigenfunctions
eigen_values = cs(1:5)
plot(x,vs(:,1),x,vs(:,2),x,vs(:,3),x,vs(:,4),x,vs(:,5))
xlabel('x'),ylabel('G(x)'),title('First 5 Eignen Functions for Problem 1')
legend('1st eigf','2nd eigf','3rd eigf','4th eigf','5th eigf','Location','SouthEast')
% -- construct P(x) and determine an and u(x,t)
t = [0 0.01 0.05 0.2];
for i = 1:length(x)
    if x(i) <= 0.5
        Px(i) = 8*x(i)-16*(x(i)^2);
    else
        Px(i) = 0;
    end
end
for j = 1:length(t)
for i = 1:length(x)
for n = 1:99
    a(n) = trapz(x,(Px'.*vs(:,n)))/trapz(x,(vs(:,n).^2));
    y(i,n) = a(n)*vs(i,n)*exp(cs(n)*t(j));
end
u(j,i) = sum(y(i,:));
end
end
figure(2)
plot(x,u)















