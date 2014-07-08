function dstate=TPN_update(t,state)

ym    = state(1);
vmy   = state(2);
xm    = state(3);
vmx   = state(4);
yt    = state(5);
vty   = state(6);
xt    = state(7);
vtx   = state(8);
lam   = state(9);

N      = 4; 
vm_IC  = 3000; 
vt_IC  = 1000; 
% xm_IC  = 0;
% ym_IC  = 10000; 
% xt_IC  = 40000; 
% yt_IC  = 10000;   

L      = asin(((-1000)*sin(lam))/vm_IC);
HE     = atan2(vmy,vmx)-(L+lam);
Rtm    = [yt xt]-[ym xm];
Vtm    = [vty vtx]-[vmy vmx];
Vc     = vm_IC*cos(L+HE)+vt_IC*cos(lam);
lam_d  = (Rtm(2)*Vtm(1)-Rtm(1)*Vtm(2))/(norm(Rtm)^2);

dstate(1) = vm_IC*sin(lam+L+HE);
dstate(2) = N*Vc*lam_d*cos(lam);
dstate(3) = vm_IC*cos(lam+L+HE);
dstate(4) = N*Vc*lam_d*-sin(lam);
dstate(5) = 0;
dstate(6) = 0;
dstate(7) = -1000;
dstate(8) = 0;
dstate(9) = lam_d

dstate = [dstate(1); 
          dstate(2); 
          dstate(3); 
          dstate(4); 
          dstate(5); 
          dstate(6);
          dstate(7);
          dstate(8); 
          dstate(9)];
end