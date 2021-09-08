Goal: Tuto for Quentin to duplicate config MEDWEST60 and run an extension of GSL19.
Last update: 2021-07-26. Caution! This tuto might need some adjustements and fix.

* **Pre-requisites:**

  * In my .bashrc file on jean zay in 2020 for my MEDWEST60 experiments, i used : 

    ```
    # On JZAY 2020 for MEDWEST60 
    module load intel-all/19.0.4
    module load hdf5/1.8.21-mpi
    module load netcdf/4.7.2-mpi
    module load netcdf-fortran/4.5.2-mpi
    module load netcdf-cxx4/4.3.1-mpi
    ```

  * You need to install xios and DCM following instruction (and same version) as here: https://github.com/ocean-next/MEDWEST60/blob/main/src_config/making-of-Config.md

  *  When you need to change the paths  to your own in the instructions below, i mentionned it as a comment (#QUENTIN). Apart from that, all the files you'll need to copy or link from my space should be accessible on  : ```/gpfsstore/rech/egi/commun/MEDWEST60/MEDWEST60-GSL19-CONFIG``` 



* **Duplicate the config:**

  * Set the configcase number```KEXP=19```

  * Once the DCM is installed, apply ```dcm_mkconfdir_local MEDWEST60-GSL$KEXP``` in the terminal. This will prepare a bunch of directories according to the DCM/Jean-Marc organisation (see DCM doc for more explanation about this command)

  * Also create your run directory on $SCRATCH:  

    ```
    mkdir /gpfsscratch/rech/egi/regi915/MEDWEST60-GSL${KEXP} 
    # QUENTIN: replace egi/regi915 by your own location on jean zay 
    ```

    

* **Compile nemo code**

  * Go to your compilation directory:  

    ```
    cd /linkhome/rech/genige01/regi915/CONFIGS/CONFIG_MEDWEST60/MEDWEST60-GSL$KEXP
    # QUENTIN: replace genige01/regi915 by your own location on jean zay
    ```

  * link (or copy) the  "arch" file in the ARCH dir:

    ```
    cp /gpfsstore/rech/egi/commun/MEDWEST60/MEDWEST60-GSL19-CONFIG/ARCHFILE/arch-X64_JEANZAY_SLX.fcm .
    ```

  * Edit the makefile:

    ```
    CASE = GSL19
    CASEREF = GSL19
    
    # PREV_CONFIG  (type the full path or 'none' )
    PREV_CONFIG = /gpfsstore/rech/egi/commun/MEDWEST60/MEDWEST60-GSL19-CONFIG/CONFIG
    
    # REFONLY ( yes or no : if yes, only reference is used, not the drakkar customs)
    REFONLY = 'no'
    
    # MACHINE : name of architecture for compilation. Assume that a arch_${MACHINE}.fcm exists in ARCH 
    # to know available arch_xxx.fcm, use dcm_lsarch.ksh. You can edit/add your own arch_xxx.fcm in
    # CONF-CASE/ARCH/ directory
    MACHINE = X64_JEANZAY_SLX
    
    # NCOMPIL_PROC : number of procs to use for the compilation of the code.
    NCOMPIL_PROC = 20
    
    # set to 'use' the NEMO component required for this config, to anything else
    # in the actual state of NEMO, OPA and LIM must be set to use for correct compilation
    #           if notused
    OPA = 'use'
    LIM2 = 'notused'
    LIM3 = 'notused'
    TOP = 'notused'
    OFF = 'notused'
    TAM = 'notused'
    AGRIF = 'notused'
    SAS = 'notused'
    # if set to 'check' maintain an 'install_history' file giving 
    #  the date of install and the svn info of $HOMEDCM
    SVN = 'nocheck'
    GIT = 'check'
    
    ```

    

  * then apply: ```make copyconfigall```

  *  then compile: 

    ```
    make install && make
    ```

  * Note: the modules loaded when you compile NEMO should be the same as when you compile xios and when you then run an experiment (as for me, i used the modules mentionned above in the prerequisites).

    

* **Install your run directory (on $scratch):**

  * go to run dir: 

    ```
    cd /gpfsscratch/rech/egi/regi915/MEDWEST60-GSL${KEXP}
    # QUENTIN: replace egi/regi915 by your own location on jean zay 
    ```

  * To copy and make links to all necessary forcing and metric files: use this  script (edit and then run it in the run dir where to copy/link the files): ```/gpfsstore/rech/egi/commun/MEDWEST60/MEDWEST60-GSL19-CONFIG/FORCING/forcingfiles.sh```

    

  

* **Prepare restart files and directories:** 

  ```
  #!/bin/bash
    
  CONFIG="MEDWEST60"
  NAME="GSL19"
  EXPT='ens01'
  
  cd /gpfsstore/rech/egi/regi915/${CONFIG}/${CONFIG}-${NAME}-R/
  # QUENTIN: CHANGE PATH BELOW to YOUR OWN on jean zay
  
  # create in advance  the directories in which the next experiments will copy their restart files
  for rstnum in {9..19} ; do
          mkdir RST_OCE.${rstnum}
          mkdir RST_OCE.${rstnum}/${EXPT}
  done
  
  # Then in RST_OCE.9, you link to the last restart files created by my GSL19 experiment:
  cd RST_OCE.9/${EXPT}/
  ln -sf /gpfsstore/rech/egi/commun/MEDWEST60/${CONFIG}-${NAME}-CONFIG/RST/${EXPT}/RST_OCE.9/*.nc .
  ln -sf /gpfsstore/rech/egi/commun/MEDWEST60/${CONFIG}-${NAME}-CONFIG/RST/${EXPT}/RST_OCE.9/*.nc ..
  ```

  

* **Install the CTL directory (on $HOME):** (CTL is the directory where you have your bash scripts to run the simulation)

  * go to CTL dir:

    ```
    cd /linkhome/rech/genige01/regi915/RUNS/RUN_MEDWEST60/MEDWEST60-GSL${KEXP}/CTL
    # QUENTIN: CHANGE PATH BELOW to YOUR OWN on jean zay
    ```

  * copy xml files and namelists:

  ```
  #!/bin/bash
  # 
  
  # xml
  cp /gpfsstore/rech/egi/commun/MEDWEST60/MEDWEST60-GSL19-CONFIG/XML/*.xml .
  
  # namelist:
  cp /gpfsstore/rech/egi/commun/MEDWEST60/MEDWEST60-GSL19-CONFIG/NAMELISTS/namelist* .
  
  # script:
  # copy the script used to run my last experiment GSL19 (segment 9):
  cp /gpfsstore/rech/egi/commun/MEDWEST60/MEDWEST60-GSL19-CONFIG/SCRIPT/go_nemo_ens.MEDWEST60-GSL19-ens01.9.sh .
  
  # then duplicate to edit and use as your script for new experiment 
  cp go_nemo_ens.MEDWEST60-GSL19-ens01.9.sh go_nemo_ens.MEDWEST60-GSL19-ens01.sh
  ```
  Note that above are copied the xml files of the GSL19 experiment for consistency. If you want to use the same xml as for your experiment GSL21 with outputs at the timestep, you can get the files here: ```/gpfsstore/rech/egi/commun/MEDWEST60/MEDWEST60-GSL19-CONFIG/XML/XML-GSL21/```.

  

* Edit this script (`go_nemo_ens.MEDWEST60-GSL19-ens01.sh`) before running your new experiment. Basically, in your case you just need to edit the initial and end time parmeters. My last experiment with GSL10 was segment 9 (NSEG=9) from  2010-03-27 to 2010-04-06.  So your next experiment could be segment 10,  for the next 10 days (and recall that 1 day <-> 1080 timesteps):

  ```
  # time segment to run. 
  NSEG=10
  
  # initial time and end time in timesteps. Recall that 1 day <-> 1080 timesteps
  NIT000=00924481  # seg9 t0: 00913681, seg10 t0: 00924481
  NITrst=00924480 # NIT000 -1 (for restart links)
  
  NITEND=00935280  #seg9: 00924480
  NDATE0=20100406  # seg9 t0 date: 2010 03 27
  
  ```

* you'll also need to edit all the paths where to move the outputs of the simulation (see at the end of the script).


* then you're good to go! To run the experiment:

  ```
  sbatch go_nemo_ens.MEDWEST60-GSL19-ens01.sh
  ```

 
