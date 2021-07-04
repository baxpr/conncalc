#!/bin/sh

# Binding fails with .. in paths so we move up a directory
cd ..

singularity run --cleanenv --contain \
  --home $(pwd)/INPUTS \
  --bind INPUTS:/INPUTS \
  --bind OUTPUTS:/OUTPUTS \
  --bind freesurfer_license.txt:/usr/local/freesurfer/license.txt \
  baxpr-mniconn-master-v1.0.1.simg \
  wroi_niigz BNST_LR.nii.gz \
  wremovegm_niigz /INPUTS/filtered_removegm_noscrub_wadfmri.nii.gz \
  wkeepgm_niigz /INPUTS/filtered_keepgm_noscrub_wadfmri.nii.gz \
  wmeanfmri_niigz /INPUTS/wmeanadfmri.nii.gz \
  wbrainmask_niigz /INPUTS/rwmask.nii.gz \
  wt1_niigz /INPUTS/wmt1.nii.gz \
  project UNK_PROJ \
  subject UNK_SUBJ \
  session UNK_SESS \
  scan UNK_SCAN \
  out_dir /OUTPUTS
