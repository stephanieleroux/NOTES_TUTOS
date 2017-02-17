## Your first steps on CURIE - How to set up your environment

Last update: Dec. 2016.  


### 0. Prerequisites:
 * you have a login/password on CURIE.

 * You have created these two directories in your $HOMEDIR:
	
	```
	cd $HOMEDIR
	mkdir ~/TOOLS
	mkdir ~/TOOLS/bin
	```

### 1. Load modules 
 * Add these lines in your .bashrc file on CURIE:
	
	```
	module load hdf5/1.8.9_parallel
	module load netcdf/4.2_hdf5_parallel
	module load nco
	```


### 2. Install SVN tools from Jean-Marc


 * Copy tools from Jean-Marc's directory:
	
	```
	cp /ccc/cont003/home/gen0727/molines/bin/svn* ~/TOOLS/bin
	```

 * Change login name and path in EACH of these scripts. 
 * Add in your .bashrc:
	
	```
	export PATH=$PATH:~/TOOLS/bin
	```




### 3. Install CDFTOOLS
 * Go to  ~/TOOLS, then:

	```
	svnco CDFTOOLS/trunk CDFTOOLS
	```
 * then close the svn tunnel

	```
	svn_tun_kill
	```


 * Local setup: 

	```
	cd CDFTOOLS
	ln -sf Macrolib/macro.curie make.macro
	```

 * Edit make.macro: make sure this line indicates the path to ~/TOOLS/bin :
 
	```
	INSTALL=~/TOOLS/bin
	```
	
 * Compile the cdftools:

	```
	make all
	make install
	make clean
	```

 * Make sure that  cdftools (executables) have been copied to your  ~/TOOLS/bin 

	```
	ls ~/TOOLS/bin 
	```

 * Test:

	```
	cdfmoy
	```



### 4. Install Pyclim  (optional)
 * Go to  ~/TOOLS, then:
 
	```
	svnco soft-pyclim/trunk pyClim
	```

 * Local install : 
 
	```
	cd pyClim
	python setup.py install --home=~/TOOLS/
	```

 * Add $PYTHONPATH in your .bashrc:
	  
	```
	export PYTHONPATH=$PYTHONPATH:~/TOOLS/lib/python
	```

 * **IMPORTANT NOTE:** *In order to use the Pyclim nctools you need to load the modules r and python/2.7.8 (in that order). BEWARE that conflicts may exist between the module Python and other modules (about netcdf libraries) so it is safer to load the python module ONLY at times when you actually use python and python tools, and it is safer NOT to load python in you .bashrc (ask Jean-Marc for more info).*
 
	```
	module load r
	module load python/2.7.8
	```

 * Test the Pyclim tools: 
 
	```
	ncDtrend
	```

 * Because conflicts may exist between the module Python and other modules (about netcdf libraries) it might be wise to unload the python module when you're done with it:
	 
	```
	module unload python
	module unload r 
	```


### 5. How to work on Curie

 * Documentation on the CURIE website: [https://www-tgcc.ccc.cea.fr](https://www-tgcc.ccc.cea.fr)
 	 * To access this page you must open firefox from a  Meolkerg terminal (and you will be asked your login/password for CURIE to access the website). Or, directly from firefox on your local machine if your local machine has been declared to TGCC (ask JM).
	 * Or you can access the same documentation from a CURIE terminal by typing: 
```
Curie.info
```

 * Some useful CURIE commands:
	
	```
	# To check your disk quotas:
	ccc_quotas
	
	# To check the CPU allocation of your project:
	ccc_myproject
	
	# To submit a job :
	ccc_msub myscript.sh
	
	# To check the status of your submitted jobs:
	sq -u your_login_on_CURIE
	
	# To cancel a submitted job:
	ccc_mdel
	```

 * More info about CURIE on  Jean-Marc's pages on the OCCIPUT wiki here [(file system)](Technical/curie/FileSystem) and here [(job submission)](Technical/curie/Submission). 




