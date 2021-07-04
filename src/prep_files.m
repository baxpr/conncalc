function [wremovegm_nii,wkeepgm_nii,wmeanfmri_nii,wt1_nii,wroi_nii,roi_csv] ...
	= prep_files(inp)

% Terrible hack with eval again to copy files to out_dir and unzip
for tag = {'wremovegm','wkeepgm','wmeanfmri','wt1'}
	disp(eval(['inp.' tag{1} '_niigz']))
	disp([inp.out_dir '/' tag{1} '.nii.gz'])
	copyfile(eval(['inp.' tag{1} '_niigz']),[inp.out_dir '/' tag{1} '.nii.gz']);
	system(['gunzip -f ' inp.out_dir '/' tag{1} '.nii.gz']);
	cmd = [tag{1} '_nii = [inp.out_dir ''/'' tag{1} ''.nii''];'];
	eval(cmd);
end

% And we'll grab the ROI file separately

if isempty(fileparts(inp.wroi_niigz))
	% Use an ROI file from container if no path provided
	wroi_niigz = fullfile(inp.out_dir,'roi.nii.gz');
	copyfile(which(inp.wroi_niigz),wroi_niigz);
	system(['gunzip -f ' wroi_niigz]);
	wroi_nii = strrep(wroi_niigz,'.gz','');
	[~,n2] = fileparts(wroi_nii);
	roi_csv = [n2 '-labels.csv'];
	copyfile(which(roi_csv),fullfile(inp.out_dir,roi_csv));
	roi_csv = fullfile(inp.out_dir,roi_csv); 
else
	% Otherwise use externally supplied ROI file
	wroi_niigz = fullfile(inp.out_dir,'roi.nii.gz');
	copyfile(inp.wroi_niigz,wroi_niigz);
	system(['gunzip -f ' wroi_niigz]);
	wroi_nii = strrep(wroi_niigz,'.gz','');
	[~,n2] = fileparts(wroi_nii);
	roi_csv = [n2 '-labels.csv'];
	copyfile(inp.wroilabel_csv,fullfile(inp.out_dir,roi_csv));
	roi_csv = fullfile(inp.out_dir,roi_csv);
end
