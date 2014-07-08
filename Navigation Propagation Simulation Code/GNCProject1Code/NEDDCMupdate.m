function C_NED_DCM = NEDDCMupdate(t,C,w_e_v,u,r_e,J2,f,C_fn)

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

C_BodytoNED = [C(1) C(2) C(3);
               C(4) C(5) C(6);
               C(7) C(8) C(9)];
           
wb_NED = wb; %C_BodytoNED*wb;
           
vn = C(10);
ve = C(11);
vd = C(12);

h = C(13);
lam = C(14);
L = C(15);

wN_IE = [w_e_v(3)*cos(C(15)); 0; -w_e_v(3)*sin(C(15))];

wN_EN = [C(14)*cos(C(15)); -C(15); -C(14)*sin(C(15))];

wB_NB = wb-((C_BodytoNED)')*((wN_IE+wN_EN));

wb_NED_skew = [0 -wb_NED(3) wb_NED(2); wb_NED(3) 0 -wb_NED(1); -wb_NED(2) wb_NED(1) 0];

K = C_BodytoNED*wb_NED_skew;

C_NED_DCM1 = [K(1,1); K(1,2); K(1,3); K(2,1); K(2,2); K(2,3); K(3,1); K(3,2); K(3,3)];

C_ECEFtoECI = [cos(w_e_v(3)*t) -sin(w_e_v(3)*t) 0; sin(w_e_v(3)*t) cos(w_e_v(3)*t) 0; 0 0 1];

if t <= 75
    
    fx_ECI = (5e5)/((2e4)-(200*t));
    
else
    
    fx_ECI = 0;
    
end

fb = [fx_ECI; 0; 0];

fe = C_BodytoNED*fb;

v_v = [vn;ve;vd];

e = sqrt(2*f-(f^2));
r_lam = r_e/sqrt(1-((e^2)*(sind(L)^2)));
r_L = (r_e*(1-(e^2)))/((1-((e^2)*(sind(L)^2)))^(3/2));

g0=9.780318*(1+((5.3024*(10^(-3)))*sin(L)^2)-((5.9*(10^(-6)))*sin(2*L)^2));

g=g0/((1+(h/r_e))^2);

vn_d = fe(1)+((vd*vn)/(r_L+h))-ve*sin((ve/(((r_lam+h)*cos(L)))+2*w_e_v(3)));
ve_d = fe(2)+((ve/(r_lam+h)*cos(L))+(2*w_e_v(3)))*(vn*sin(L)+vd*cos(L));
vd_d = fe(3)+g-((vn^2)/(r_L+h))-ve*cos(L)*(ve/(((r_lam+h)*cos(L)))+2*w_e_v(3));

v_d = [vn_d; ve_d; vd_d];

h_d = -vd;
lam_d = ve/((r_lam+h)*cos(L));
L_d = vn/(r_L+h);

geo_d = [h_d; lam_d; L_d];

C_NED_DCM = [C_NED_DCM1; v_d; geo_d];

end
    