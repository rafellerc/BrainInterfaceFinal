%%
%Filtrage par les filtres passe-bande et calcul de la puissance lissée : 
clear all
close all
% addpath(genpath('C:\Users\daviet_mat\TL-Approf.-BCI\obj'));
% addpath(genpath('C:\Users\daviet_mat\TL-Approf.-BCI\src'));
addpath(genpath('/Users/heloisehuyghuesdespointes/Documents/TL-Approf.-BCI'));

%Le signal B est la moyenne de la sortie des 2 électrodes
%Le signal X contient la sortie des électrodes et les labels des ordres
%donnés, obtenu par separerOrdres
B = load('herve002.txt');
X = load('herve002_labeled.txt'); 
delta_f = 0.33; %Opt = 0.33
G = 0.56;  %Opt = 0.56
alpha = 0.96; %Opt = 0.96

[Z1, Z2, Z3] = puissancelisse(X, G, delta_f, alpha);

%%
%Maximisation du SNR et choix de G et delta_f optimaux
clear all
close all
% addpath(genpath('C:\Users\daviet_mat\TL-Approf.-BCI\obj'));
% addpath(genpath('C:\Users\daviet_mat\TL-Approf.-BCI\src'));
addpath(genpath('/Users/heloisehuyghuesdespointes/Documents/TL-Approf.-BCI'));

%Le signal B est la moyenne de la sortie des 2 électrodes
%Le signal X contient la sortie des électrodes et les labels des ordres
%donnés, obtenu par separerOrdres
X = load('herve002_labeled.txt');

[Gopt, delta_fopt] = choixDfGain(X);

%%
%Optimisation des seuils avec alpha fixé
clear all
close all
% addpath(genpath('C:\Users\daviet_mat\TL-Approf.-BCI\obj'));
% addpath(genpath('C:\Users\daviet_mat\TL-Approf.-BCI\src'));
addpath(genpath('/Users/heloisehuyghuesdespointes/Documents/TL-Approf.-BCI'));

%Le signal B est la moyenne de la sortie des 2 électrodes
%Le signal X contient la sortie des électrodes et les labels des ordres
%donnés, obtenu par separerOrdres
B = load('herve002.txt');
X = load('herve002_labeled.txt');
alpha = 0.96; %Opt = 0.96

[seuil1, seuil2, seuil3] = optim_3seuilsbis(B, X, alpha);

%%
%Optimisation de alpha avec les seuils fixés 
clear all
close all
% addpath(genpath('C:\Users\daviet_mat\TL-Approf.-BCI\obj'));
% addpath(genpath('C:\Users\daviet_mat\TL-Approf.-BCI\src'));
addpath(genpath('/Users/heloisehuyghuesdespointes/Documents/TL-Approf.-BCI'));

%Le signal B est la moyenne de la sortie des 2 électrodes
%Le signal X contient la sortie des électrodes et les labels des ordres
%donnés, obtenu par separerOrdres
B = load('herve002.txt');
X = load('herve002_labeled.txt');
seuil1 = 2.8862e-06;
seuil2 = 1.7285e-06;
seuil3 = 1.3574e-06;

[alpha_opt] = optimalpha(B, X, seuil1, seuil2, seuil3);

%%
%Calcul des ordres prédits et de l'erreur de prédiction
clear all
close all
% addpath(genpath('C:\Users\daviet_mat\TL-Approf.-BCI\obj'));
% addpath(genpath('C:\Users\daviet_mat\TL-Approf.-BCI\src'));
addpath(genpath('/Users/heloisehuyghuesdespointes/Documents/TL-Approf.-BCI'));

%Le signal B est la moyenne de la sortie des 2 électrodes
%Le signal X contient la sortie des électrodes et les labels des ordres
%donnés, obtenu par separerOrdres
B = load('herve002.txt');
X = load('herve002_labeled.txt');
seuil1 = 2.8862e-06;
seuil2 = 1.7285e-06;
seuil3 = 1.3574e-06;
delta_f = 0.33; %Opt = 0.33
G = 0.56;  %Opt = 0.56
alpha = 0.96; %Opt = 0.96

[prediction] = commande_3seuils(X, seuil1, seuil2, seuil3 ,delta_f, G, alpha);
[erreur] = erreurprediction(prediction, X(:,2));


