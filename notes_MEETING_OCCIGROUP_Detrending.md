# Discussion about detrending strategies with OCCIPUT-like data
* 29/09, 2hrs
* Thierry P., Sally C., Ixelt G., Cyril G., Stephanie L.



## Why detrending?
#### -Motivations
* Make sure the spectral content is comparable in the case where we compute ratios of ensemble-std (intrinsic var.) and time-std (forced var.). [Ex: AMOC paper Leroux et al 2017]
* …

####  -Linear vs Non-linear? 
* One inconvenient of a linear detrending is that it will not remove the very-low variability that might exist in the data (larger than the time-window of the data) and this might add a bias in any time-statistics computed from the linearly-detrended data. 
 
#### -Each member separately vs all members ?
* Each member separately. Otherwise: residual trend/very-low frequency might remain in the signal.


## How? (technical)
#### -General methods and python doc:
- __Loess__: non-linear (polynomial) local regression fit. Choose nb of degrees of the polynomial. (default=2): import R package for Python (rp2). Doc: ```https://www.statsdirect.com/help/nonparametric_methods/loess.htm```.

- __Lowess__ : linear local regression fit (degree 1) : import statsmodels python package). Doc: ```http://www.statsmodels.org/devel/generated/statsmodels.nonparametric.smoothers_lowess.lowess.html```
 
#### -Tools and tutos from the group:
* On a simple timeseries:
	- On a simple time-series: Tuto and python script for Loess and Lanczos filter: [here on github (notebook python)](https://github.com/stephanieleroux/SHARED_NOTEBOOKS/blob/master/Demo_Loess_lanczos.ipynb)
	- On a simple synthetic time-series: Tuto comparing Loess and Lowess detrending: [here on github (notebook python)](https://github.com/stephanieleroux/SHARED_NOTEBOOKS/blob/master/Demo_comp_Loess_Lowess.ipynb)
* On 2-d fields (x-y):
	- Guillaume Serazin’s python tool (Loess, polynomial degree 2) from his python package [PyCLim](http://servforge.legi.grenoble-inp.fr/projects/soft-pyclim)
		- you can use as a package in your own python script,
		- or you can use as a __cdftool-like tool__: __```ncDtrend```__ in a shell script. 
		- Example of how to use ```ncDtrend``` (on CURIE): ``` /ccc/cont003/home/gen0727/lerouxst/SHARED/SCRIPTS/OHC/loessdtrend_OHC.sh```
* On 2-d fields (x-y), 5-day:
	- Trends computed from the annual mean fields (take spine). Remove from the 5d fields.
	- Example of how to use from Sally Close’s script (on CURIE):  ``` /ccc/cont003/home/gen0727/lerouxst/SHARED/SCRIPTS/SSH/detrend_from_annual_Sally.py```
	- Advantage: faster than ncDtrend since operating on the annual fields to retrieve the trends.


## Some other discussed questions:
* _How much do we loose of the intrinsic signal in the detrended part?_
	- The very-low frequency variability removed with the detrending processing might be significant compared to the remaining variability. It is often a question from reviewers. 
* _How to use/interpret the removed (detrended) part?_
	- See for example Serazin et al 2017 (OHC trends in GRL). In that case, make use of the trend from the climatological run to derive an estimate of the model drift to remove.
* _Do we want to set the first point for all members?_
	- Yes for plotting purposes if the goal is to illustrate the divergence of the members from a same starting point. 
	- But not really physically justified if  you are  processing monthly or annual time-mean outputs (in one month-, one-year- mean, the members have already diverged enough that the first value won’t e the same for all of them).

