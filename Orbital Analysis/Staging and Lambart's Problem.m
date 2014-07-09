clc;
clear;

% set known values
m_0=15000;
m_l=1000;
m_s=2000;
% create symbolic variables
syms lambda m_02 m_03 

% create equations to solve
eq1=((m_02)/(m_0-(m_02)))-lambda;
eq2=(m_03/(m_02-m_03))-lambda;
eq3=(m_l/(m_03-m_l))-lambda;

% solve eq 1 for lambda in terms of m_02 and m_03
lambda_by_m2m3=solve(eq1, lambda);

% replace lambda in eq3 with lambda_m2m3 
eq3_m02m03=subs(eq3,lambda,lambda_by_m2m3);
% now we have eq3 in terms of m_02 and m_03 only

% solve new eq3_m02m03 for m_02 in terms of m_03
m02_by_m03=solve(eq3_m02m03,m_02);

% replace lambda in eq2 with lambda_by_m2m3
eq2_m02m03=subs(eq2,lambda,lambda_by_m2m3);
% now eq2 is in terms of only m_02 and m_03

% replace m02 in eq2_m02m03 with m03
eq2_m03=subs(eq2_m02m03,m_02,m02_by_m03);

% replace m_02 in equation 2 with m02_by_m03
m03_value=double(solve(eq2_m03));
%now we know the correct value of m_03




% replace m_03 with the known value in eq1 and eq2
eq1_2=((m_02+m03_value(1))/(m_0-(m_02+m03_value(1))))-lambda;
eq3_2=(m_l/(m03_value(1)-m_l))-lambda;

% solve for lambda in terms of m_02
lambda_2=solve(eq1_2,lambda);

% replace lambda with lambda_2 in eq3
eq3_3=subs(eq3_2,lambda,lambda_2);
% now that eq3 is only in terms of m_02, solve for m_02
m_02_value=double(solve(eq3_3));
%we now know the correct value for m_02


%now that we know the values of m_02 and m_03, solve for lambda in eq1
eq1_3=subs(eq1_2,m_02,m_02_value);
lambda_value=double(solve(eq1_3));

sprintf('\n\nlambda = %6.4g\nm_02   = %6.4g\nm_03   = %6.4g', lambda_value(1),m_02_value(1),m03_value(1))
%%
% part b
lambda = 0.8518;
m_02=3616;
m_03=2466;
e = 0.143;
m_s1=e*(m_0-m_02)
m_s2=e*(m_02-m_03)
m_s3=e*(m_03-m_l)
% part c
A=[1 1 1; 0 1 1; 0 0 1];
b=[m_0-m_s1-m_s2-m_s3-m_l; m_02-m_s2-m_s3-m_l; m_03-m_s3-m_l];
m_p=A\b;
m_p1=m_p(1)
m_p2=m_p(2)
m_p3=m_p(3)
% part d
c=3048
Z=(1+lambda)/(e+lambda)
d_v=2*c*log(Z)












