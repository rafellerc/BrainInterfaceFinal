
function [alpha_opt] = optimalpha(B, X,seuil1, seuil2, seuil3)

addpath(genpath('/Users/heloisehuyghuesdespointes/Documents/TL-Approf.-BCI'));
fe = 256;
fc_1 = 7.5;
fc_2 = 11;
fc_3 = 13.5;
delta_f = 0.33; %Opt = 0.33
G = 0.56;  %Opt = 0.56
alpha = 0.01:0.005:1;


[Y1] = filtre (B,G,delta_f,fe,fc_1);
[Y2] = filtre (B,G,delta_f,fe,fc_2);
[Y3] = filtre (B,G,delta_f,fe,fc_3);

Z1 = zeros(size(Y1,1),1);
Z1(1) = Y1(1,1)^2;
Z2 = zeros(size(Y2,1),1);
Z2(1) = Y2(1,1)^2;
Z3 = zeros(size(Y3,1),1);
Z3(1) = Y3(1,1)^2;


for k=1:length(alpha)
    for i = 2:size(Y1,1)+1
        Z1(i) = (1-alpha(k))*Y1(i)^2 + alpha(k) * Z1(i-1);
        Z2(i) = (1-alpha(k))*Y2(i)^2 + alpha(k) * Z2(i-1);
        Z3(i) = (1-alpha(k))*Y3(i)^2 + alpha(k) * Z3(i-1);
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

    

    prediction = zeros(length(Z1)-1,199);
    
    for i = 36:length(Z1)-1
        
        est_amp_1 = max(abs(Z1(i-35:i)))/seuil1;
        est_amp_2 = max(abs(Z2(i-35:i)))/seuil2;
        est_amp_3 = max(abs(Z3(i-35:i)))/seuil3;
        
        if(est_amp_1<1 && est_amp_2<1 && est_amp_3<1)
            prediction(i,k) = 0;
        elseif(est_amp_1 > est_amp_2 && est_amp_1 > est_amp_3)
            prediction(i,k) = 3;
        elseif(est_amp_2 > est_amp_1 && est_amp_2 > est_amp_3)
            prediction(i,k) = 1;
        elseif(est_amp_3 > est_amp_1 && est_amp_3 > est_amp_2)
            prediction(i,k) = 2;
            
        end
    end
    


erreur(k) = erreurprediction(prediction(:,k),X(:,2));
end

[val_min,ind_min] = min(erreur);
alpha_opt = alpha(ind_min);
%%
%Valeurs obtenues par l'optimisation successive de alpha et des seuils pour
%herve002

% seuil1= 2.3358e-06; %herve002 optim_3seuilsbis alpha = 0,99 erreur = 12,71
% seuil2 = 1.4505e-06;
% seuil3 = 1.2756e-06;
% seuil1= 2.8862e-06; %herve002 optim_3seuilsbis alpha = 0,96  erreur = 11,1
% seuil2 = 1.7285e-06;
% seuil3 = 1.3574e-06;

% seuil1= 3.4898e-06; %herve002 optim_3seuilsbis alpha = 0,105  erreur = 11,5
% seuil2 = 2.0086e-06;
% seuil3 = 1.4407e-06;

% seuil1= 3.3325e-06; %herve002 optim_3seuilsbis alpha = 0,83  erreur = 11,4
% seuil2 = 1.9546e-06;
% seuil3 = 1.3930e-06;
% 
% seuil1= 3.4417e-06; %herve002 optim_3seuilsbis alpha = 0,675  erreur = 11,4
% seuil2 = 1.9929e-06;
% seuil3 = 1.4111e-06;

% seuil1= 3.3562e-06; %herve002 optim_3seuilsbis alpha = 0,81  erreur = 11,4
% seuil2 = 1.9634e-06;
% seuil3 = 1.3957e-06;
