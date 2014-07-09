clear all
clc
r_t0=[12214.839; 10249.467; 2000]; % in kilometers
v_t0=[-3.448; 0.924; 0]; % km/s
rt_t0=[393.12; 4822.2; 0]; % km
vt_t0=[35.02; -5.765; 0]; % km/s
t = 2700; % s
u = 324859; 
% Step 1 finding orbital elements for target orbit
h=cross(rt_t0,vt_t0)
n=cross([0; 0; 1],h);
e_v=cross(vt_t0/u,h)-(rt_t0/norm(rt_t0));
e=norm(e_v)
E=((norm(vt_t0)^2)/2)-(u/norm(rt_t0));
a=-(u/(2*E))
p=(norm(h)^2)/2
i=acosd(dot((h/norm(h)),[0; 0; 1]))
rand1=dot([0; 1; 0],n);
if rand1<0
OMEGA=360-acosd(dot([1; 0; 0],(n/norm(n))))
else 
    OMEGA=acosd(dot([1; 0; 0],(n/norm(n))))
end
rand2=dot([0; 0; 1],e_v);
if rand2>0
    omega=acosd((dot(n,e_v))/(norm(n)*e))
else 
    omega=360-acosd((dot(n,e_v))/(norm(n)*e))
end
rand3=dot(rt_t0,vt_t0);
if rand3>0
    f=acosd((dot(rt_t0,e_v))/(norm(rt_t0)*e))
else
    f=360-acosd((dot(rt_t0,e_v))/(norm(rt_t0)*e))
end
%%
% step 2 finding the desired position of the target
% find E
M=(norm(n)*t)+(norm(n)*t);
E(1)=M;
for i=1:3
    E(i+1)=E(i)-((E(i)-e*sin(E(i))-E(1))/(1-e*cos(E(i))));
end
E=E(4)
f=2*atand((tan(E/2))/(sqrt((1-e)/(1+e))))
r=(a*(1-(e^2)))/(1+e*cosd(f))
% Step 3 find a for transition orbit
g=t;
c=norm(r_t0-r)
s=(c+norm(r_t0)+norm(rt_t0))/2
alpha=2*asin(sqrt(s/(2*a)))
beta=2*asin(sqrt((s-c)/(2*a)));
a_min=s/2;
a_max=100*a_min;
for i=1:40
   a=(a_max+a_min)/2;
   g=sqrt((a^3)/u)*(alpha-beta-(sin(alpha)-sin(beta)));
   if g>t
       a_min=a;
   else 
       a_max=a;
   end
end
a=a
% Step 4 calculate v
A=sqrt(u/(4*a))*cot(alpha/2)
B=sqrt(u/(4*a))*cot(beta/2)
u_1=r_t0/norm(r_t0)
u_2=rt_t0/norm(rt_t0)
u_c=(rt_t0-r_t0)/c
v_t0=(B+A)*u_c+(B-A)*u_1
vt_t0=(B+A)*u_c+(B-A)*u_2
v_tr=vt_t0-v_t0
d_v=v_tr-norm(vt_t0)
