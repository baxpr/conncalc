#!/bin/bash
#
# Create a bunch of screenshots to put in the PDF report.

# Set up freesurfer
. $FREESURFER_HOME/SetUpFreeSurfer.sh

# ROIs
ss_roi.sh

# Connectivity maps
ss_conn.sh

# Make PDF pages
ss_combine.sh
