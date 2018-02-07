function [resultat] = SNR(Y1, Y2, Y3, labels)


fenetresignal1 = (labels == 3);
fenetresignal2 = (labels == 1);
fenetresignal3 = (labels == 2);

fenetrebruit1 = (labels ~= 3);
fenetrebruit2 = (labels ~= 1);
fenetrebruit3 = (labels ~= 2);


signal1 = sum(Y1.*fenetresignal1)/sum(fenetresignal1 == 1);
signal2 = sum(Y2.*fenetresignal2)/sum(fenetresignal2 == 1);
signal3 = sum(Y3.*fenetresignal3)/sum(fenetresignal3 == 1);

bruit1 = sum(Y1.*fenetrebruit1)/sum(fenetrebruit1 == 1);
bruit2 = sum(Y2.*fenetrebruit2)/sum(fenetrebruit2 == 1);
bruit3 = sum(Y3.*fenetrebruit3)/sum(fenetrebruit3 == 1);

SNR1 = signal1/bruit1;
SNR2 = signal2/bruit2;
SNR3 = signal3/bruit3;


resultat =(SNR1 + SNR2 + SNR3)/3;
end

