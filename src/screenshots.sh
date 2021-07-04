#!/bin/bash
#
# Create a bunch of screenshots to put in the PDF report.

# Set up freesurfer
. $FREESURFER_HOME/SetUpFreeSurfer.sh

# Set up FSL (we only use fslstats so no need for the full setup)
export FSLOUTPUTTYPE=NIFTI_GZ

# MNI space connectivity maps
ss_conn_mni.sh

# Make PDF pages
ss_combine.sh
