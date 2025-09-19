### Les données à comparer:
* mes simus NEMO Arctique sont à resolution 1/4° et dispos à fréquence journalière (moyenne journalière)
* le produit OSISAF-drift est dispo sur une grille de 75 km de resolution. Il fournit le déplacement dX et dY en 24h. Bien noter que ce  n’est pas exactement equivalent à la vitesse moyenne journalière du modèle mais c’est quand même ce que j’ai comparé. Le [usermanual d'OSISAF-drift est téléchargeable ici pour mieux comprendre la grille et le déplacement.](https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://osisaf-hl.met.no/sites/osisaf-hl/files/user_manuals/osisaf_pum_sea-ice-drift-lr_v1p9.pdf&ved=2ahUKEwjJ6OiTtuSPAxULTaQEHWvhKEQQFnoECB0QAQ&usg=AOvVaw1PHRtqB2eNrTa5UU98BkEI)
*  _Note:_ Ici le but est de comparer le module de drift sqrt(dX^2+dY^2) par 24h d’OSISAF au module de drift simulé (moyenne journalière). Pour comparer les module, pas besoin de se préoccuper de la rotation des vecteurs U,V de la grille NEMO à la grille OSISAF. Bien garder en tête que si on veut comparer chaque composante séparément, il faut gérer la rotation aussi !! La distortion des grilles par rapport au Nord géographique peut être importante dans la région Arctique.


### Processing
* J’ai d’abord dégradé la résolution des simulations d’un facteur 6 avec l’outil [`cdfdegrad`](https://github.com/meom-group/CDFTOOLS) pour approcher les 75 km d’OSISAF (12 km x 6 = 72 km). _Exemple de script [ici](https://github.com/stephanieleroux/NOTES_TUTOS/tree/master/SRC/compNANUK4-OSISAF-drift)._
_

* Ensuite j’ai regrillé les simus dégradées sur la grille OSISAF avec l’outil [Sosie](https://brodeau.github.io/sosie/) de Laurent Brodeau. _Exemple de script et namelist pour Sosie [ici](https://github.com/stephanieleroux/NOTES_TUTOS/tree/master/SRC/compNANUK4-OSISAF-drift)._

_Note:_ si on applique le regridding sur chacune des composantes de la vitesse plutôt que sur le module, il faut penser à la rotation des vecteurs lors du changement de grille. Il faudrait bidouiller un peu Sosie pour introduire l'angle de rotation qui n'est actuellement prévu dans Sosie que pour un regridding d'une grille regulière vers une grille NEMO.

### Outils et scripts
* [cdftools](https://github.com/meom-group/CDFTOOLS).
* [Sosie](https://brodeau.github.io/sosie/).
* Exemple de script et namelist pour Sosie [ici](https://github.com/stephanieleroux/NOTES_TUTOS/tree/master/SRC/compNANUK4-OSISAF-drift).
