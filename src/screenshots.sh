#!/bin/bash
#
# Create a bunch of screenshots to put in the PDF report.

# Set up freesurfer
. $FREESURFER_HOME/SetUpFreeSurfer.sh

# Set up FSL (we only use fslstats so no need for the full setup)
export FSLOUTPUTTYPE=NIFTI_GZ

# Connectivity maps
ss_conn.sh

# Make PDF pages
ss_combine.sh
