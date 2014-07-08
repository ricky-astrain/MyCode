function [rtm,isterminal,direction] = interception(t,state)

xm         = state(1);
ym         = state(2);
zm         = state(3);
xt         = state(7);
yt         = state(8);
zt         = state(9);

rm         = [xm;ym;zm];
rt         = [xt;yt;zt];
rtm        = rt-rm;  

isterminal = [1;1;1];   
direction  = -1;  