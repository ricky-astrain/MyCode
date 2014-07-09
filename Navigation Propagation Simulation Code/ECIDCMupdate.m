function C_ECI_DCM = ECIDCMupdate(t,C,u,r_e,J2)

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

C_BodytoInertial = [C(1) C(2) C(3);
                    C(4) C(5) C(6);
                    C(7) C(8) C(9)];
           
wb_skew = [0 -wb(3) wb(2); wb(3) 0 -wb(1); -wb(2) wb(1) 0];

K = C_BodytoInertial*wb_skew;

C_ECI_DCM1 = [K(1,1); K(1,2); K(1,3); K(2,1); K(2,2); K(2,3); K(3,1); K(3,2); K(3,3)];

if t <= 75
    
    fx_ECI = (5e5)/((2e4)-(200*t));
    
else
    
    fx_ECI = 0;
    
end

fb = [fx_ECI; 0; 0];

fi = C_BodytoInertial*fb;

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

r_d = v_v;

v_d = fi+g_ECI;

C_ECI_DCM = [C_ECI_DCM1; r_d; v_d];

end