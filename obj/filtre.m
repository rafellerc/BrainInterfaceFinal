function [Y] = filtre (X , G , delta_f,fe,fc)

a1 = -2*sqrt(1-(2*pi*G*delta_f)/fe)*cos(2*pi*fc/fe);
a2 = 1-(2*pi*G*delta_f)/fe;
b0 = (2*pi*G*delta_f/fe)*sin(2*pi*fc/fe);
B = b0;
A = [ 1, a1, a2 ];
Y = filter (B,A,X);
