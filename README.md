# conncalc

Computes functional connectivity maps and matrices for a specified set of ROIs.

## Inputs

- `removegm_niigz`, `keepgm_niigz`, `meanfmri_niigz`. Preprocessed fMRI data from 
  [connprep](https://github.com/baxpr/connprep). This may be supplied in atlas space or 
  subject native space. The first two are 4D time series, the last a single 3D image.

- `roi_niigz`.  ROI image. This may be an image existing within the container (see 
  `rois/README.md`). Or, it may be any supplied 
  image. In the latter case, `roilabel_csv` must also be supplied; this file must contain 
  Label and Region columns, or may be the STATS output of a slant assessor. The ROI
  image must be already be aligned with the T1 and the fMRI (though needn't be sampled to
  the same voxel grid or field of view) - no coregistration or warp is performed on any 
  of the images.

- `t1_niigz`. T1 image for the PDF report. Could be BIAS_??? from cat12.

- `mask_niigz`. Brain mask - will be binarized and dilated and used to exclude any clearly 
  ex-brain voxels in the stored connectivity maps. Supply 'none' to mask to the entire
  volume (i.e. no masking). Could be ICV_??? from cat12.
  
- `roidefinv_niigz`. Optional deformation from atlas space to native space. Supply this
  when the ROI image is in atlas space but the preprocessed fMRI are in native space.
  Could be DEF_INV from cat12. If this argument is not supplied, ROI and fMRI are assumed
  to be in the same space.
  
- `connmaps_out`. 'yes' or 'no' to choose whether to additionally store voxelwise 
  connectivity images for each ROI in the ROI image.

## Pipeline

- Resample the ROI image to match the fMRI voxel sampling, with or without a warp depending
  on the `roidefinv_niigz` parameter.
  
- Extract mean time series from the supplied fMRI for each ROI in the ROI image.

- Compute functional connectivity. The ROI-to-ROI connectivity matrix is computed, and also 
  voxelwise connectivity Z maps if requested.

  - `R`, the correlation coefficient
  - `Z`, the Fisher transformed correlation, `atanh(R) * sqrt(N-3)` where `N` is number of time points
  - `Vdf`, `Pdf`, `Zdf` autocorrelation-adjusted connectivity metrics from https://github.com/asoroosh/xDF
  
- Generate a PDF report and organize outputs for XNAT.

