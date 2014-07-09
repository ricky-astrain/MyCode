function C_ECEF_DCM = ECEFDCMupdate(t,C,w_e_v,u,r_e,J2)

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

C_BodytoFixed = [C(1) C(2) C(3);
                 C(4) C(5) C(6);
                 C(7) C(8) C(9)];
             
we = wb-((C_BodytoFixed)'*w_e_v);

we_skew = [0 -we(3) we(2); we(3) 0 -we(1); -we(2) we(1) 0];

K = C_BodytoFixed*we_skew;

C_ECEF_DCM1 = [K(1,1); K(1,2); K(1,3); K(2,1); K(2,2); K(2,3); K(3,1); K(3,2); K(3,3)];

C_ECEFtoECI = [cos(w_e_v(3)*t) -sin(w_e_v(3)*t) 0; sin(w_e_v(3)*t) cos(w_e_v(3)*t) 0; 0 0 1];

w_i=C_ECEFtoECI*w_e_v;

if t <= 75
    
    fx_ECI = (5e5)/((2e4)-(200*t));
    
else
    
    fx_ECI = 0;
    
end

fb = [fx_ECI; 0; 0];

fi = C_ECEFtoECI*C_BodytoFixed*fb;

rx = C(10);
ry = C(11);
rz = C(12);
vx = C(13);
vy = C(14);
vz = C(15);

r_v = [rx;ry;rz];
v_v = [vx;vy;vz];
r = norm(r_v);

g_ECI = [(-u/r^2)*(1+(3/2*J2)*((r_e/r)^2)*(1-5*(rz/r)^2))*(rx/r);
         (-u/r^2)*(1+(3/2*J2)*((r_e/r)^2)*(1-5*(rz/r)^2))*(ry/r);
         (-u/r^2)*(1+(3/2*J2)*((r_e/r)^2)*(3-5*(rz/r)^2))*(rz/r)];

g_L_ECI = g_ECI-cross(w_i,cross(w_i,r_v));

r_d = v_v+cross(w_i,r_v);

v_d = fi+g_L_ECI-cross(w_i,v_v);

C_ECEF_DCM = [C_ECEF_DCM1; r_d; v_d];

end