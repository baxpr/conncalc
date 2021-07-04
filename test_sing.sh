#!/bin/bash

singularity run --contain --cleanenv \
--home $(pwd)/INPUTS \
--bind INPUTS_JD:/INPUTS \
--bind OUTPUTS_JD:/OUTPUTS \
conncalc.simg \
roi_niigz /INPUTS/rois.nii.gz \
roilabel_csv rois-labels.csv \
removegm_niigz /INPUTS/filtered_removegm_noscrub_wadfmri.nii.gz \
keepgm_niigz /INPUTS/filtered_keepgm_noscrub_wadfmri.nii.gz \
meanfmri_niigz /INPUTS/wmeanadfmri.nii.gz \
brainmask_niigz /INPUTS/rwmask.nii.gz \
t1_niigz /INPUTS/wmt1.nii.gz \
connmaps_out no \
out_dir /OUTPUTS

