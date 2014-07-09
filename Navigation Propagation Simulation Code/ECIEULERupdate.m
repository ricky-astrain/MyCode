function C_ECI_Euler = ECIEULERupdate(t,C,u,r_e,J2)

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

Euler_BtoI = [C(1); C(2); C(3)];

C_BodytoInertial = [cos(Euler_BtoI(2))*cos(Euler_BtoI(3)) -cos(Euler_BtoI(1))*sin(Euler_BtoI(3))+sin(Euler_BtoI(1))*sin(Euler_BtoI(2))*cos(Euler_BtoI(3)) sin(Euler_BtoI(1))*sin(Euler_BtoI(3))+cos(Euler_BtoI(1))*sin(Euler_BtoI(2))*cos(Euler_BtoI(3));
                    cos(Euler_BtoI(2))*sin(Euler_BtoI(3)) cos(Euler_BtoI(1))*cos(Euler_BtoI(3))+sin(Euler_BtoI(1))*sin(Euler_BtoI(2))*sin(Euler_BtoI(3)) -sin(Euler_BtoI(1))*cos(Euler_BtoI(3))+cos(Euler_BtoI(1))*sin(Euler_BtoI(2))*sin(Euler_BtoI(3));
                    -sin(Euler_BtoI(2)) cos(Euler_BtoI(2))*sin(Euler_BtoI(1)) cos(Euler_BtoI(1))*cos(Euler_BtoI(2))];                    
     
K3 = (wb(2)*sin(Euler_BtoI(1))+wb(3)*cos(Euler_BtoI(1)))*sec(Euler_BtoI(2));
K2 = wb(2)*cos(Euler_BtoI(1))-wb(3)*sin(Euler_BtoI(1));
K1 = wb(1)+(wb(2)*sin(Euler_BtoI(1))+wb(3)*cos(Euler_BtoI(1)))*tan(Euler_BtoI(2));

ECI_Euler = [K1; K2; K3];

if t <= 75
    
    fx_ECI = (5e5)/((2e4)-(200*t));
    
else
    
    fx_ECI = 0;
    
end

fb = [fx_ECI; 0; 0];

fi = C_BodytoInertial*fb;

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

r_d = v_v;

v_d = fi+g_ECI;

C_ECI_Euler = [ECI_Euler; r_d; v_d];

end