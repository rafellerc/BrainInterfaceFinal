function [seuil1, seuil2, seuil3] = optim_3seuilsbis(B, X, alpha)

% addpath(genpath('/Users/Rafael/sir/TL-Approf.-BCI/obj'));
% addpath(genpath('/Users/Rafael/sir/'));
addpath(genpath('/Users/heloisehuyghuesdespointes/Documents/TL-Approf.-BCI'));

fe = 256;
fc_1 = 7.5;
fc_2 = 11;
fc_3 = 13.5;
delta_f = 0.33; %Opt = 0.33
G = 0.56;  %Opt = 0.56

[Y1] = filtre (B,G,delta_f,fe,fc_1);
[Y2] = filtre (B,G,delta_f,fe,fc_2);
[Y3] = filtre (B,G,delta_f,fe,fc_3);

Z1 = zeros(size(Y1,1),1);
Z1(1) = Y1(1,1)^2;
Z2 = zeros(size(Y2,1),1);
Z2(1) = Y2(1,1)^2;
Z3 = zeros(size(Y3,1),1);
Z3(1) = Y3(1,1)^2;

for i = 2:size(Y1,1)+1
    Z1(i) = (1-alpha)*Y1(i)^2 + alpha * Z1(i-1);
    Z2(i) = (1-alpha)*Y2(i)^2 + alpha * Z2(i-1);
    Z3(i) = (1-alpha)*Y3(i)^2 + alpha * Z3(i-1);
end

windowSize = 36;
b = (1/windowSize)*ones(1,windowSize);
a = 1;
Z1 = filter(b,a,Z1);
Z2 = filter(b,a,Z2);
Z3 = filter(b,a,Z3);

%On détermine la puissance du bruit, les 5 premières secondes,
%caractérisant l'absence de signal, le seuil en deça duquel on considère
%qu'aucun ordre n'est donné

bruit_1 = sum(Z1(1:5*256))/(5*256);
bruit_2 = sum(Z2(1:5*256))/(5*256);
bruit_3 = sum(Z3(1:5*256))/(5*256);

max_Z1 = max(abs(Z1));
max_Z2 = max(abs(Z2));
max_Z3 = max(abs(Z3));
seuil_1 = zeros(10,1);
seuil_2 = zeros(10,1);
seuil_3 = zeros(10,1);
seuil = zeros(10,3);


for i = 1:10
    seuil_1(i)=bruit_1+((max_Z1/10)*(i-1));
    seuil_2(i)=bruit_2+((max_Z2/10)*(i-1));
    seuil_3(i)=bruit_3+((max_Z3/10)*(i-1));
    seuil(i,1)=seuil_1(i);
    seuil(i,2)=seuil_2(i);
    seuil(i,3)=seuil_3(i);
    
end

prediction = zeros(length(Z1)-1,10);

for j=1:10
    for k = 1:10
        for l = 1:10
            for i = 36:length(Z1)-1
                
                est_amp_1 = max(abs(Z1(i-35:i)))/seuil(j,1);
                est_amp_2 = max(abs(Z2(i-35:i)))/seuil(k,2);
                est_amp_3 = max(abs(Z3(i-35:i)))/seuil(l,3);
                
                if(est_amp_1<1 && est_amp_2<1 && est_amp_3<1)
                    prediction(i,j) = 0;
                elseif(est_amp_1 > est_amp_2 && est_amp_1 > est_amp_3)
                    prediction(i,j) = 3;
                elseif(est_amp_2 > est_amp_1 && est_amp_2 > est_amp_3)
                    prediction(i,j) = 1;
                elseif(est_amp_3 > est_amp_1 && est_amp_3 > est_amp_2)
                    prediction(i,j) = 2;
                end
            end
            
        end
    end
    erreur(j) = erreurprediction(prediction(:,j),X(:,2));
    
end

[val_min,ind_min] = min(erreur);

seuil1 = seuil_1(ind_min);
seuil2 = seuil_2(ind_min);
seuil3 = seuil_3(ind_min);