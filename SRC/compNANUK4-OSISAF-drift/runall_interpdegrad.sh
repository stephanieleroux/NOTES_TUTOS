#!/bin/bash
# stephanie.leroux@datlas.fr
#
# Process NEMO NANUK4 daily outputs to coarsen and regrid before comparison with sea ice OSISAF-drift observations
# It makes use of cdfdegrad for coarsening then Sosie for regridding.



# List of experiments to process

experiments=(
   SBLKEVP011 SABLEVP011  SBLKBBM021 SABLBBM021
)

# Parameters for coarsening 
factor=6
typ="T"
var="sivelo-t"

# NEMO mesh-mask file and link for cdftool
cf_lsm_src='/lustre/fsstor/projects/rech/cli/commun/NANUK4/NANUK4.L31-I/mesh_mask_NANUK4_L31_4.2.nc'
ln -sf ${cf_lsm_src} mesh_zgr.nc
ln -sf ${cf_lsm_src} mesh_hgr.nc
ln -sf ${cf_lsm_src} mask.nc

# Sosie executable for regridding
SOSIE_EXEC="sosie3.x"


#------------------------------------------
# Loop over experiments
for expe in "${experiments[@]}"; do

  cf_src="/lustre/fsstor/projects/rech/cli/commun/NANUK4/NANUK4_ICE_ABL-${expe}-S/00001201-00010800/001NANUK4_ICE_ABL-${expe}_1d_19970111_19970331_icemod.nc"
  echo ${cf_src}

  # file to process
  cf_out="001NANUK4_ICE_ABL-${expe}_1d_19970111_19970331_icemod_degraded_${factor}.nc"

  # preprocessing with ncap2 to get rid of depth dim before coarsening
  ln -sf ${cf_src} filin.nc
  ncap2 -s 'defdim("depth",1); depth[depth]=0.0' filin.nc filindep.nc
  
  # coarsening
  cdfdegrad -f filindep.nc -v $var -r $factor $factor -p $typ  -full  -o ${cf_out}
  cp ${cf_out} filindegraded.nc
  rm -f filin.nc filindep.nc

  # Prepare namelist for sosie (regridding)
  namelist_file_mod="namelist.interpdrift_moddeg_${expe}"
  # Replace <EXPE> in the template
  sed "s/<EXPE>/$expe/g" namelist.interpdrift_moddeg > "$namelist_file_mod"
  echo "Generated $namelist_file_moddegrad"

  # Run the SOSIE program with this namelist
  echo "Running SOSIE for $expe..."
  $SOSIE_EXEC -f "$namelist_file_mod"
  echo "Finished $expe"
  echo "--------------------------"


rm -fr filindegraded.nc

done

