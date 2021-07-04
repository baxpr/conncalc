# mniconn

Computes functional connectivity maps and matrices for a specified set of ROIs.

## Inputs

- `removegm_niigz`, `keepgm_niigz`, `meanfmri_niigz`. Preprocessed fMRI data from [connprep](https://github.com/baxpr/connprep). This may be supplied in atlas space or subject native space, as long as the ROI image is in the same space.

- `roi_niigz`.  ROI image. This may be an image existing within the container (e.g. the MNI space 'AABHHIP_LR.nii.gz', see src/rois/README.md). Or, it may be any supplied image. In the latter case, `roilabel_csv` must also be supplied; this file must contain Label and Region columns, or may be the STATS output of a slant assessor.

- `t1_niigz`. T1 image for the PDF report.

## Pipeline

- Resample the ROI image to match the fMRI. It's assumed both are already aligned and in the same space as the ROI image.
- Extract mean time series from the supplied fMRI for each ROI in the ROI image.
- Compute functional connectivity: `R`, the correlation coefficient; and `Z`, the Fisher transformed correlation, `atanh(R) * sqrt(N-3)` where `N` is number of time points. The ROI-to_ROI matrix is computed, and also voxelwise connectivity maps.
- Generate a PDF report and organize outputs for XNAT.

