function dstate=GUIDANCEupdate(t,state)

dstate=zeros(12,1);

N         = 4;

xm        = state(1);
ym        = state(2);
zm        = state(3);
vm_x      = state(4);
vm_y      = state(5);
vm_z      = state(6);
xt        = state(7);
yt        = state(8);
zt        = state(9);
vt_x      = state(10);
vt_y      = state(11);
vt_z      = state(12);

rm         = [xm;ym;zm];
vm         = [vm_x;vm_y;vm_z];
rt         = [xt;yt;zt];
vt         = [vt_x;vt_y;vt_z];

rtm        = rt-rm;
vtm        = vt-vm; 
eLOS       = rtm./norm(rtm); 
vc         = -dot(vtm,eLOS);
omegaLOS   = cross(rtm,vtm)./((norm(rtm)).^2);
  
atm        =4*9.81;
atd        = cross(vt/norm(vt),eLOS);
at         = atm*atd;
at_x       = at(1);
at_y       = at(2);
at_z       = at(3);

% at_x       = 0;
% at_y       = 0;
% at_z       = 0;

%am         = N.*vc.*(cross(omegaLOS,eLOS));
w          = 4000000;
tgo        = 21.3618-t;
am         = ((3*tgo)/((3/w)+(tgo^3))).*(rtm+vtm.*tgo);

if norm(am)>= 20*9.81
    am     = (20*9.81).*(am./norm(am));
end

am_x       = am(1);
am_y       = am(2);
am_z       = am(3);

dstate(1)  = vm_x;
dstate(2)  = vm_y;
dstate(3)  = vm_z;
dstate(4)  = am_x;
dstate(5)  = am_y;
dstate(6)  = am_z;
dstate(7)  = vt_x;
dstate(8)  = vt_y;
dstate(9)  = vt_z;
dstate(10) = at_x;
dstate(11) = at_y;
dstate(12) = at_z;
end


