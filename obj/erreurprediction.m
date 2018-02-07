%%% Calcul de l'erreur entre 2 vecteurs de labels
%%%
%%% entr\'ees :
%%%   - v_prediction : vecteur contenant les labels predits
%%%   - v_verification : vecteurs contenant les labels permettant de
%%%   vérifier les labels
%%%
%%% sorties :
%%%   - erreur     : pourcentage d'erreur


function [erreur] = erreurprediction(v_prediction, v_verification)
v_erreur = (v_prediction ~= v_verification);
erreur =  sum(v_erreur)/length(v_verification)*100;
end