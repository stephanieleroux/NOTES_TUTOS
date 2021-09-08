Ce tuto explique comment j'ai recombiné les outputs d'une simu MEDWEST60.

J'ai utilisé la version Laurent de l'outil de recombinaison NEMO. C'est un outil à compiler avec le `maketools` du DCM. :

* Copier ces fichiers depuis chez moi (la version _tr m'a été donnée par Laurent. Je crois que ça permet de mieux gérer la mémoire que l'outil standard quand on recombine de gros fichiers):

  ```
  cd /gpfsstore/rech/egi/commun/MEDWEST60/MEDWEST60-GSL19-CONFIG/LB_REBUILD/
  
  cp rebuild_nemo_tr_SLX.ksh /gpfswork/rech/egi/regi915/DEVGIT/NEMODRAK_release-3.6/NEMOREF/NEMOGCM/TOOLS/REBUILD_NEMO/
  
  cp rebuild_nemo_tr.f90 /gpfswork/rech/egi/regi915/DEVGIT/NEMODRAK_release-3.6/NEMOREF/NEMOGCM/TOOLS/REBUILD_NEMO/src/
  ```

* ```
  cd /gpfswork/rech/egi/regi915/DEVGIT/NEMODRAK_release-3.6/NEMOREF/NEMOGCM/TOOLS
  ```

  Dans ce repertoire normalement tu dois avoir un executable du DCM qui s'appelle `maketools` et  un lien vers ton fichier ARCH (.fcm). Si non, refais le lien, par exemple pour moi:

  ```
  ln -sf /linkhome/rech/genige01/regi915/CONFIGS/CONFIG_MEDWEST60/MEDWEST60-GSL01/ARCH/arch-X64_JEANZAY_SLX.fcm .
  ```

* Pour compiler l'outil:

  ```
  ./maketools -n REBUILD_NEMO -m X64_JEANZAY_SLX
  ```

  (modifier le -m en fonction du nom du fichier arch à utiliser)

  --> SI tout se passe bien, tu as un script .ksh et un executable .exe qui ont été créés dans le sous repertoire REBUILD_NEMO. Par exemple chez moi:

  ```
  regi915@jean-zay3:TOOLS>>ls REBUILD_NEMO/
  total 35
  drwxr-s--- 7 regi915 egi 4096 Sep  8 14:51 BLD
  -rwxr-x--- 1 regi915 egi 8507 Sep 27  2019 icb_combrest.py
  lrwxrwxrwx 1 regi915 egi  114 Sep  8 14:51 rebuild_nemo.exe -> /gpfswork/rech/egi/regi915/DEVGIT/NEMODRAK_release-3.6/NEMOREF/NEMOGCM/TOOLS/REBUILD_NEMO/BLD/bin/rebuild_nemo.exe
  -rwxr-x--- 1 regi915 egi 4632 Feb  6  2020 rebuild_nemo_SLX.ksh
  lrwxrwxrwx 1 regi915 egi  117 Sep  8 14:51 rebuild_nemo_tr.exe -> /gpfswork/rech/egi/regi915/DEVGIT/NEMODRAK_release-3.6/NEMOREF/NEMOGCM/TOOLS/REBUILD_NEMO/BLD/bin/rebuild_nemo_tr.exe
  lrwxrwxrwx 1 regi915 egi  118 Sep  8 14:51 rebuild_nemo_tr2.exe -> /gpfswork/rech/egi/regi915/DEVGIT/NEMODRAK_release-3.6/NEMOREF/NEMOGCM/TOOLS/REBUILD_NEMO/BLD/bin/rebuild_nemo_tr2.exe
  -rwxr-x--- 1 regi915 egi 2207 Feb  6  2020 rebuild_nemo_tr_SLX.ksh
  drwxr-s--- 3 regi915 egi 4096 Sep  8 14:46 src
  ```

  

* Ensuite pour utiliser cet outil:

  Tu te mets dans le repertoire où sont les fichiers à recombiner:

  ```
  TOOLDIR=/gpfswork/rech/egi/regi915/DEVGIT/NEMODRAK_release-3.6/NEMOREF/NEMOGCM/TOOLS/REBUILD_NEMO/
  
  NXIOS=30   # nombre de serveurs xios (ou nombre de fichiers à recombiner)
  CX=883     # taille du domaine en x
  CY=803     # taille du domaine en y
  DL=2       # deflation level (niveau de compression  je crois)
  
  ${TOOLDIR}rebuild_nemo_tr_SLX.ksh -d ${DL} -x ${CX} -y ${CY} ${FILIN} ${NXIOS}
  ```

  $FILIN est le  début du nom du fichier à recombiner (sans la fin du nom avec les chiffres  _xxxx.nc  ). Du coup moi pour traiter tous les fichiers je faisais une boucle du genre:

  ```
    for g in ${KK}MEDWEST60-${CONFCASE}-${eexp}_1h_2010*_${typ}* ; do
    # remove suffix (proc nb and .nc extension)
      FILIN=${g%%_0*.*}   
      ${TOOLDIR}rebuild_nemo_tr_SLX.ksh -d ${DL} -x ${CX} -y ${CY} ${FILIN} ${NXIOS}
     done
  ```

  Et tu peux aussi looper sur `KK`, sur `typ`, etc.

  
