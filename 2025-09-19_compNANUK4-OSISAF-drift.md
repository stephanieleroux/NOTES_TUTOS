### Les données à comparer:
* mes simus NEMO Arctique sont au 1/4° et dispo à fréquence journalière (moyenne journalière)
* le produit OSISAF-drift est dispo sur une grille de 75 km de resolution. Il fournit le déplacement dX et dY en 24h. Bien noté que ce  n’est pas exactement equivalent à la vitesse moyenne journalière du modèle mais c’est quand même ce que j’ai comparé. 
*  _Note:_ Ici le but est de comparer le module de drift sqrt(dX^2+dY^2) par 24h d’OSISAF au module de drift simulé (moyenne journalière). Pour comparer les module, pas besoin de se préoccuper de la rotation des vecteurs U,V de la grille NEMO à la grille OSISAF. Bien garder en tête que si on veut comparer chaque composante séparément, il faut gérer la rotation aussi !! La distortion des grilles par rapport au Nord géographique peut être importante dans la région Arctique.


### Processing
* J’ai d’abord **dégradé la résolution des simulations d’un facteur 6 avec l’outil `cdfdegrad`** pour approcher les 75 km d’OSISAF (12 km x 6 = 72 km).

* Ensuite j’ai regrillé les simus dégradées sur la grille OSISAF avec l’outil Sosie de Laurent Brodeau.

### Scripts
* Exemple de [script ici](). Et [namelist pour Sosie ici]().
