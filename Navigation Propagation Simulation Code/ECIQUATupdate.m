function C_ECI_QUAT = ECIQUATupdate(t,C,u,r_e,J2)

if t <= 4
    
    q = 0;
    
elseif t <= 14
    
    q = -1.2;
    
elseif t <= 74
    
    q = (t-75)/50;
    
else
    
    q = 0;
    
end

wb = [0; 0; q; 0].*(pi/180);

Wb = [wb(1) -wb(2) -wb(3) -wb(4);
      wb(2)  wb(1) wb(4) -wb(3)
      wb(3) -wb(4) wb(1)  wb(2)
      wb(4)  wb(3) -wb(2) wb(1)];

q_BodytoInertial = [C(1); C(2); C(3); C(4)];

C_BodytoInertial = [C(1)^2+C(2)^2-C(3)^2-C(4)^2 2*(C(2)*C(3)-C(1)*C(4)) 2*(C(1)*C(3)+C(2)*C(4));
                    2*(C(2)*C(3)+C(1)*C(4)) C(1)^2-C(2)^2+C(3)^2-C(4)^2 2*(C(3)*C(4)-C(1)*C(2));
                    2*(C(2)*C(4)-C(1)*C(3)) 2*(C(1)*C(2)+C(3)*C(4)) C(1)^2-C(2)^2-C(3)^2+C(4)^2];

K = 0.5*Wb*q_BodytoInertial;

q_ECI_QUAT = [K(1); K(2); K(3); K(4)];

if t <= 75
    
    fx_ECI = (5e5)/((2e4)-(200*t));
    
else
    
    fx_ECI = 0;
    
end

fb = [fx_ECI; 0; 0];

fi = C_BodytoInertial*fb;

rx = C(5);
ry = C(6);
rz = C(7);
vx = C(8);
vy = C(9);
vz = C(10);

r_v = [rx;ry;rz];
v_v = [vx;vy;vz];
r = norm(r_v);

g_ECI = [(-u/r^2)*(1+(3/2*J2)*((r_e/r)^2)*(1-5*(rz/r)^2))*(rx/r);
         (-u/r^2)*(1+(3/2*J2)*((r_e/r)^2)*(1-5*(rz/r)^2))*(ry/r);
         (-u/r^2)*(1+(3/2*J2)*((r_e/r)^2)*(3-5*(rz/r)^2))*(rz/r)];

r_d = v_v;

v_d = fi+g_ECI;

C_ECI_QUAT = [q_ECI_QUAT; r_d; v_d];

end