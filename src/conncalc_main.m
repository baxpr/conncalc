function conncalc_main(inp)

% We know
warning('off','MATLAB:table:ModifiedAndSavedVarnames');

% Unzip images and copy to working location
disp('File prep   -----------------------------------------------------------------------')
F = prep_files(inp);

% SPM init
spm_jobman('initcfg');

% Resample ROI image to fMRI space
disp('ROI operations   ------------------------------------------------------------------')
[rroi_nii,rroi_csv] = resample_roi(F.roi_nii,F.meanfmri_nii,F.roi_csv,inp.out_dir);

% Extract ROI time series from preprocessed fMRI
roidata_removegm = extract_roidata(F.removegm_nii,rroi_nii,rroi_csv,inp.out_dir,'removegm');
roidata_keepgm = extract_roidata(F.keepgm_nii,rroi_nii,rroi_csv,inp.out_dir,'keepgm');

% Compute connectivity maps and matrices
disp('Connectivity   --------------------------------------------------------------------')
conncompute(roidata_removegm,F.removegm_nii,inp.out_dir,'removegm',inp.connmaps_out);
conncompute(roidata_keepgm,F.keepgm_nii,inp.out_dir,'keepgm',inp.connmaps_out);

% Mask files to a (lenient) brain mask to save space, if we made maps
if strcmp(inp.connmaps_out,'yes')
	mask_maps(inp.out_dir,F.mask_nii);
end

% Generate PDF report pages
disp('Make PDF pages  -------------------------------------------------------------------')
make_pdf_pages(inp.out_dir,F.meanfmri_nii,F.t1_nii,inp.label_info);

% Done with the matlab part
if isdeployed, exit, end

