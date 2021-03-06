function C_ECEF_Euler = ECEFEULERupdate(t,C,w_e_v,u,r_e,J2)

if t <= 4
    
    q = 0;
    
elseif t <= 14
    
    q = -1.2;
    
elseif t <= 74
    
    q = (t-75)/50;
    
else
    
    q = 0;
    
end

wb = [0; q; 0].*(pi/180);
  
Euler_BtoF = [C(1); C(2); C(3)];

C_BodytoFixed = [cos(Euler_BtoF(2))*cos(Euler_BtoF(3)) -cos(Euler_BtoF(1))*sin(Euler_BtoF(3))+sin(Euler_BtoF(1))*sin(Euler_BtoF(2))*cos(Euler_BtoF(3)) sin(Euler_BtoF(1))*sin(Euler_BtoF(3))+cos(Euler_BtoF(1))*sin(Euler_BtoF(2))*cos(Euler_BtoF(3));
                 cos(Euler_BtoF(2))*sin(Euler_BtoF(3)) cos(Euler_BtoF(1))*cos(Euler_BtoF(3))+sin(Euler_BtoF(1))*sin(Euler_BtoF(2))*sin(Euler_BtoF(3)) -sin(Euler_BtoF(1))*cos(Euler_BtoF(3))+cos(Euler_BtoF(1))*sin(Euler_BtoF(2))*sin(Euler_BtoF(3));
                 -sin(Euler_BtoF(2)) cos(Euler_BtoF(2))*sin(Euler_BtoF(1)) cos(Euler_BtoF(1))*cos(Euler_BtoF(2))];
             
we = wb-[((C_BodytoFixed)'*w_e_v)];

K3 = (we(2)*sin(Euler_BtoF(1))+we(3)*cos(Euler_BtoF(1)))*sec(Euler_BtoF(2));
K2 = we(2)*cos(Euler_BtoF(1))-we(3)*sin(Euler_BtoF(1));
K1 = we(1)+(we(2)*sin(Euler_BtoF(1))+we(3)*cos(Euler_BtoF(1)))*tan(Euler_BtoF(2));

ECEF_Euler = [K1; K2; K3];

C_ECEFtoECI = [cos(w_e_v(3)*t) -sin(w_e_v(3)*t) 0; sin(w_e_v(3)*t) cos(w_e_v(3)*t) 0; 0 0 1];

w_i=C_ECEFtoECI*w_e_v;

if t <= 75
    
    fx_ECI = (5e5)/((2e4)-(200*t));
    
else
    
    fx_ECI = 0;
    
end

fb = [fx_ECI; 0; 0];

fi = C_ECEFtoECI*C_BodytoFixed*fb;

rx = C(4);
ry = C(5);
rz = C(6);
vx = C(7);
vy = C(8);
vz = C(9);

r_v = [rx;ry;rz];
v_v = [vx;vy;vz];
r = norm(r_v);

g_ECI = [(-u/r^2)*(1+(3/2*J2)*((r_e/r)^2)*(1-5*(rz/r)^2))*(rx/r);
         (-u/r^2)*(1+(3/2*J2)*((r_e/r)^2)*(1-5*(rz/r)^2))*(ry/r);
         (-u/r^2)*(1+(3/2*J2)*((r_e/r)^2)*(3-5*(rz/r)^2))*(rz/r)];

g_L_ECI = g_ECI-cross(w_i,cross(w_i,r_v));

r_d = v_v+cross(w_i,r_v);

v_d = fi+g_L_ECI-cross(w_i,v_v);

C_ECEF_Euler = [ECEF_Euler; r_d; v_d];

end