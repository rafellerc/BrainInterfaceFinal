# BrainInterfaceFinal
Version délivrable du projet de Commande par Interface Cérébrale

## Télécharger le projet

Pour télécharger le code allez sur un terminal Linux, allez sur le répertoire où vous voulez mettre le projet et tapez:
> $ git clone https://github.com/rafellerc/BrainInterfaceFinal.git

## Faire tourner le programme Matlab
Les codes matlab se trouvent dans le répertoire /BrainInterfaceFinal/matlab.
Pour faire tourner le code Matlab (qui est sur le fichier script_BCI.m), il faut, au début du code, remplacer le chemin par celui menant au répertoire BrainInterfaceFinal pour avoir accès aux enregistrements et aux fonctions.
par exemple :
addpath(genpath('/Users/heloisehuyghuesdespointes/Documents/BrainInterfaceFinal/matlab’));
Remplacez ce chemin par le votre.

Les étapes d’optimisation décrites dans le rapport sont présentés sur le script « script_BCI.m » et peuvent être exécutées une section à la fois en suivant le rapport.

## Commment Builder et Exécuter le programme ROS

D'abord on doit configurer l'environnement ROS, où la distribution <distro> est celle installé dans votre PC:  
> $ source /opt/ros/<distro>/setup.bash

Après, allez sur le répertoire du projet (normalement '/BrainInterfaceFinal'), allez sur BrainInterfaceFinal/ros_ws e buildez les packages avec catkin:
> $ catkin_make

Après la fin de la build, il faut être sûr que les fichier des noeuds sont exécutables, donc allez sur BrainInterfaceFinal/ros_ws/src/bci_robot/scripts et tapez:
> $ chmod +x bci_source.py signal_pro.py

La installation est complète. Pour faire exécuter le programme:
1) Ouvrez un nouveau terminal et faites tourner le noeud core du ROS:
> $ roscore

2) Connectez le robot khepera en prenant l'adresse IP du robot souhaité:
> $ ping khepera1.smart.metz.supelec.fr

  ou
> $ ping khepera2.smart.metz.supelec.fr

Avec cet adresse IP lancez le noeud:
> $ roslaunch kteams_node khepera_bringup.launch khepera_dns:=THE_IP_OF_THE_ROBOT

3) Dans un autre terminal exécutez le noeud /signal_pro:
> $ rosrun bci_robot signal_pro.py khepera

C'est le noeud qui reçoit les échantillons, les traite et envoie les messages au robot 

4) Finalement, dans un autre terminal exécutez le noeud /bci_source (comme décrit dans le rapport):
> $ rosrun bci_robot bci_source.py [full_path_to_data_file]

où ce chemin correspond à le path complet à un des fichiers data qui se trouvent dans /BrainInterfaceFinal/obj . Vous pouvez choisir "herve002_labeled.txt" par exemple.

Si vous n'avez pas le robot mais vous voulez tester le programme quand même, exécutez-le avec turtlesim. Pour le faire, suivez les mêmes pas, mais en '2)' lancez le noeud suivant:
> $ rosrun turtlesim turtlesim_node

et dans le pas '3)', tapez:
> $ rosrun bci_robot signal_pro.py turtle
