function [Z1,Z2,Z3] = puissancelisse (X, G, delta_f, alpha)


fe = 256;
fc_1 = 7.5;
fc_2 = 11;
fc_3 = 13.5;

[Y1] = filtre (X,G, delta_f, fe,fc_1);
[Y2] = filtre (X,G, delta_f, fe,fc_2);
[Y3] = filtre (X,G, delta_f, fe,fc_3);
   

figure
plot (Y1);
            
Z1 = zeros(size(Y1,1),1);
Z1(1) = Y1(1,1)^2;
Z2 = zeros(size(Y2,1),1);
Z2(1) = Y2(1,1)^2;
Z3 = zeros(size(Y3,1),1);
Z3(1) = Y3(1,1)^2;

for l = 2:size(Y1,1)
  Z1(l) = (1-alpha)*Y1(l)^2 + alpha * Z1(l-1);
  Z2(l) = (1-alpha)*Y2(l)^2 + alpha * Z2(l-1);
  Z3(l) = (1-alpha)*Y3(l)^2 + alpha * Z3(l-1);
end


%filtrage du signal avec fcoupure ~ 7 Hz 

b = (1/windowSize)*ones(1,windowSize);
a = 1;            
Z1 = filter(b,a,Z1);
Z2 = filter(b,a,Z2);
Z3 = filter(b,a,Z3);

