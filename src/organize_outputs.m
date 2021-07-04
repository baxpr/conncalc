function organize_outputs(out_dir,rroi_nii,rroi_csv,connmaps_out)

% PDF
system(['cd ' out_dir ' && mkdir PDF && mv conncalc.pdf PDF']);


% Unsmoothed connmaps
if strcmp(connmaps_out,'yes')
	system(['cd ' out_dir ' && ' ...
		' mkdir ZMAPS_KEEPGM && ' ...
		' mv connmaps/Z_*_wkeepgm.nii ZMAPS_KEEPGM && ' ...
		' gzip ZMAPS_KEEPGM/*.nii']);
	
	system(['cd ' out_dir ' && ' ...
		' mkdir ZMAPS_REMOVEGM && ' ...
		' mv connmaps/Z_*_wremovegm.nii ZMAPS_REMOVEGM && ' ...
		' gzip ZMAPS_REMOVEGM/*.nii']);
end


% Conn matrix
system(['cd ' out_dir ' && mkdir RMATRIX && mv R_*.csv RMATRIX']);
system(['cd ' out_dir ' && mkdir ZMATRIX && mv Z_*.csv ZMATRIX']);
system(['cd ' out_dir ' && mkdir DFMATRIX && mv ?df_*.csv DFMATRIX']);


% ROI images
system(['cd ' out_dir ' && mkdir ROIS && cp ' rroi_nii ' ROIS && ' ...
	' gzip ROIS/*.nii']);


% Extracted ROI time series
system(['cd ' out_dir ' && mkdir ROIDATA && mv roidata_*.csv ROIDATA']);


% ROI spec
system(['cd ' out_dir ' && mkdir ROILABELS && ' ...
	' cp ' rroi_csv ' ROILABELS']);


% Computed brain mask
system(['cd ' out_dir ' && mkdir MASK && ' ...
	' cp mask.nii MASK && gzip MASK/*.nii']);
