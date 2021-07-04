#!/bin/bash

# Fix imagemagick policy to allow PDF output. See https://usn.ubuntu.com/3785-1/
sed -i 's/rights="none" pattern="PDF"/rights="read | write" pattern="PDF"/' \
/etc/ImageMagick-6/policy.xml

# Run the compiled matlab  
bash ../bin/run_spm12.sh /usr/local/MATLAB/MATLAB_Runtime/v92 function mniconn \
wroi_niigz BNST_LR.nii.gz \
wremovegm_niigz ../INPUTS/filtered_removegm_noscrub_wadfmri.nii.gz \
wkeepgm_niigz ../INPUTS/filtered_keepgm_noscrub_wadfmri.nii.gz \
wmeanfmri_niigz ../INPUTS/wmeanadfmri.nii.gz \
wbrainmask_niigz ../INPUTS/rwmask.nii.gz \
wt1_niigz ../INPUTS/wmt1.nii.gz \
project UNK_PROJ \
subject UNK_SUBJ \
session UNK_SESS \
scan UNK_SCAN \
magick_path /usr/local/bin \
out_dir ../OUTPUTS
