%On calcule l'ordre donné au robot selon les 3 seuils des signaux
function [prediction] = commande_3seuils(entree, seuil_1, seuil_2, seuil_3 ,delta_f, G,alpha)

fe = 256;
fc_1 = 7.5;
fc_2 = 11;
fc_3 = 13.5;

%On filtre le signal d'entrée qui est la moyenne des voies
%enregistrées sur la BCI, par un banc de filtres passe-bande centrés sur
%7,5 Hz, 11 Hz et 13,5 Hz
[Y1] = filtre(entree,G,delta_f,fe,fc_1);
[Y2] = filtre(entree,G,delta_f,fe,fc_2);
[Y3] = filtre(entree,G,delta_f,fe,fc_3);

prediction = zeros(length(Y1),1);


Z1 = zeros(size(Y1,1),1);
Z1(1) = Y1(1,1)^2;
Z2 = zeros(size(Y2,1),1);
Z2(1) = Y2(1,1)^2;
Z3 = zeros(size(Y3,1),1);
Z3(1) = Y3(1,1)^2;

%On calcule la puissance lissée pour chaque signal
for i = 2:size(Y1,1)+1
    Z1(i) = (1-alpha)*Y1(i)^2 + alpha * Z1(i-1);
    Z2(i) = (1-alpha)*Y2(i)^2 + alpha * Z2(i-1);
    Z3(i) = (1-alpha)*Y3(i)^2 + alpha * Z3(i-1);
end


%filters the singal in with fcut ~ 7 Hz. To allow to get only the value
%corresponding to the amplitude
windowSize = 36; 
b = (1/windowSize)*ones(1,windowSize);
a = 1;

%And passes also through the abs function so as to not have zero mean in a
%period
Z1 = filter(b,a,abs(Z1));
Z2 = filter(b,a,abs(Z2));
Z3 = filter(b,a,abs(Z3));

bruit_1 = sum(Z1(1:5*256))/(5*256);
bruit_2 = sum(Z2(1:5*256))/(5*256);
bruit_3 = sum(Z3(1:5*256))/(5*256);

for i = 36:length(Y1)
    
    est_amp_1 = max(abs(Z1(i-35:i)))/seuil_1;
    est_amp_2 = max(abs(Z2(i-35:i)))/seuil_2;
    est_amp_3 = max(abs(Z3(i-35:i)))/seuil_3;    
    
    %On calcule la prédiction correspondante sur chaque fenêtre de temps, pour
    %chaque signal et pour les seuils déterminés par optim_3seuils
    if(est_amp_1<1 && est_amp_2<1 && est_amp_3<1)
        prediction(i) = 0;
    elseif(est_amp_1 > est_amp_2 && est_amp_1 > est_amp_3)
        prediction(i) = 3;
    elseif(est_amp_2 > est_amp_1 && est_amp_2 > est_amp_3)
        prediction(i) = 1;
    elseif(est_amp_3 > est_amp_2 && est_amp_3 > est_amp_1)
        prediction(i) = 2;
    end
end
 

end