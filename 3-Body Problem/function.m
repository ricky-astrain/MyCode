function [f] = hw52b(t,x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
u=0.012150829235347922;

r1=sqrt(((x(1)+u)^2)+(x(2)^2)+(x(3)^2));
r2=sqrt(((x(1)+u-1)^2)+(x(2)^2)+(x(3)^2));
f=zeros(6,1);
f(1)=x(4);
f(2)=x(5);
f(3)=x(6);


f(4)=2*x(5)+x(1)-(1-u)*((x(1)+u)/r1^3)-(u*((x(1)-1+u)/r2^3));
f(5)=-2*x(4)+x(2)-(1-u)*((x(2))/r1^3)-(u*((x(2))/r2^3));
f(6)=-(1-u)*((x(3))/r1^3)-(u*((x(3))/r2^3));
end


