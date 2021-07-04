function outfnames = prep_files(inp)

outfnames = struct();

% Copy files to out_dir and unzip
for tag = {'removegm','keepgm','meanfmri','t1','mask'}
	varname = [tag{1} '_niigz'];
	inputfile = inp.(varname);
	outputfile = fullfile(inp.out_dir,[tag{1} '.nii.gz']);
	copyfile(inputfile,outputfile);
	system(['gunzip -f ' outputfile]);
	outputfile = strrep(outputfile,'.nii.gz','.nii');
	outfnames.(varname) = outputfile;
end

% And we'll grab the ROI file separately so we can handle the in/out of
% container logic

if isempty(fileparts(inp.roi_niigz))
	% Use an ROI file from container if no path provided
	roi_niigz = fullfile(inp.out_dir,'roi.nii.gz');
	copyfile(which(inp.roi_niigz),roi_niigz);
	system(['gunzip -f ' roi_niigz]);
	outfnames.roi_nii = strrep(roi_niigz,'.nii.gz','.nii');
	[~,n2] = fileparts(roi_nii);
	outfnames.roi_csv = fullfile(inp.out_dir,'roi-labels.csv');
	copyfile(which([n2 '-labels.csv']),outfnames.roi_csv);
else
	% Otherwise use externally supplied ROI file
	roi_niigz = fullfile(inp.out_dir,'roi.nii.gz');
	copyfile(inp.roi_niigz,roi_niigz);
	system(['gunzip -f ' roi_niigz]);
	outfnames.roi_nii = strrep(roi_niigz,'.nii.gz','.nii');
	outfnames.roi_csv = fullfile(inp.out_dir,'roi-labels.vsv');
	copyfile(inp.roilabel_csv,outfnames.roi_csv);
end
