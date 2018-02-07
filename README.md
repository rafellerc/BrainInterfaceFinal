# BrainInterfaceFinal
Version délivrable du projet de Commande par Interface Cérébrale

##Télécharger le projet

Pour télécharger le code allez sur un terminal Linux, allez sur le répertoire où vous voulez mettre le projet et tapez:
> $ git clone https://github.com/rafellerc/BrainInterfaceFinal.git

##Faire tourner le programme Matlab
Pour faire tourner le code Matlab, il faut, au début de chaque section du code, remplacer le chemin par celui menant au répertoire BrainInterfaceFinal pour avoir accès aux enregistrements et aux fonctions.
par exemple :
addpath(genpath('/Users/heloisehuyghuesdespointes/Documents/BrainInterfaceFinal/obj’));

Les étapes d’optimisation décrites dans le rapport sont présentés sur le script « script_BCI.m »

#Commment Builder et Exécuter le programme ROS

D'abord on doit configurer l'environnement ROS, où la distribution <distro> est celle installé dans votre PC:  
> $ source /opt/ros/<distro>/setup.bash

Après, allez sur le répertoire du projet (normalement '/BrainInterfaceFinal'), allez sur BrainInterfaceFinal/ros_ws e buildez les packages avec catkin:
> $ catkin_make

