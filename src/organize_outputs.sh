#!/usr/bin/env bash

cd "${out_dir}"

mkdir PDF
mv conncalc.pdf PDF

if [[ "${connmaps_out}" == "yes" ]] ; then

    mkdir ZMAPS_KEEPGM
    mv connmaps/Z_*_keepgm.nii
    gzip ZMAPS_KEEPGM/*.nii

    mkdir ZMAPS_REMOVEGM
    mv connmaps/Z_*_removegm.nii
    gzip ZMAPS_REMOVEGM/*.nii

fi

mkdir RMATRIX
mv R_*.csv RMATRIX

mkdir ZMATRIX
mv Z_*.csv ZMATRIX
 
mkdir DFMATRIX
mv ?df_*.csv DFMATRIX

mkdir ROIS
mv roi.nii ROIS
gzip ROIS/roi.nii

mkdir ROILABELS
mv roi-labels.csv ROILABELS

mkdir ROIDATA
mv roidata_*.csv ROIDATA

mkdir MASK
mv mask.nii MASK
gzip MASK/mask.nii
