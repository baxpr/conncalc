function mniconn_main(inp)

% Unzip images and copy to working location
disp('File prep   -----------------------------------------------------------------------')
[wremovegm_nii,wkeepgm_nii,wmeanfmri_nii,wt1_nii,wroi_nii,roi_csv] ...
	= prep_files(inp);

% SPM init
spm_jobman('initcfg');

% Resample ROI image to fMRI space
disp('ROI operations   ------------------------------------------------------------------')
[rwroi_nii,roi_csv] = resample_roi(wroi_nii,wmeanfmri_nii,roi_csv,inp.out_dir);

% Extract ROI time series from preprocessed fMRI
roidata_removegm = extract_roidata(wremovegm_nii,rwroi_nii,roi_csv,inp.out_dir,'wremovegm');
roidata_keepgm = extract_roidata(wkeepgm_nii,rwroi_nii,roi_csv,inp.out_dir,'wkeepgm');

% Compute connectivity maps and matrices
disp('Connectivity   --------------------------------------------------------------------')
conncompute(roidata_removegm,wremovegm_nii,inp.out_dir,'wremovegm',inp.connmaps_out);
conncompute(roidata_keepgm,wkeepgm_nii,inp.out_dir,'wkeepgm',inp.connmaps_out);

% Mask files to a (lenient) brain mask to save space, if we made maps
if strcmp(inp.connmaps_out,'yes')
	mask_mni(inp.out_dir)
end

% Generate PDF report
disp('Make PDF   ------------------------------------------------------------------------')
make_pdf(inp.out_dir,wmeanfmri_nii,wt1_nii,rwroi_nii,roi_csv, ...
	inp.magick_path,inp.src_path,inp.fsl_path,inp.fs_path,inp.connmaps_out, ...
	inp.project,inp.subject,inp.session,inp.scan);

% Organize and clean up
disp('Organize outputs   ----------------------------------------------------------------')
organize_outputs(inp.out_dir,rwroi_nii,roi_csv,inp.connmaps_out);

