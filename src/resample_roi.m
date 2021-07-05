function [rroi_nii,rroi_csv] = resample_roi(roi_nii,meanfmri_nii,roi_csv,out_dir)

%% Resample ROI image

% Params. Critically, 0 order (nearest neighbor) interpolation
flags = struct('mask',true,'mean',false,'interp',0,'which',1, ...
	'wrap',[0 0 0],'prefix','r');

% Use SPM to reslice
spm_reslice_quiet({meanfmri_nii roi_nii},flags);

% Figure out the new filename
[p,n,e] = fileparts(roi_nii);
rroi_nii = fullfile(p,['r' n e]);


%% Get ROI labels in a standard format

% Load the ROI label file. Label the first two columns as Label and Region
% if matlab detects them as unlabeled.
roi_info = readtable(roi_csv);
if strcmp(roi_info.Properties.VariableNames{1},'Var1')
	roi_info.Properties.VariableNames{'Var1'} = 'Label';
	roi_info.Properties.VariableNames{'Var2'} = 'Region';
end

% If we got a slant STATS output, rename the appropriate columns
indR = strcmp(roi_info.Properties.VariableNames,'LabelName_BrainCOLOR_');
indL = strcmp(roi_info.Properties.VariableNames,'LabelNumber_BrainCOLOR_');
if sum(indR)==1 && sum(indL)==1
	roi_info.Properties.VariableNames{indR} = 'Region';
	roi_info.Properties.VariableNames{indL} = 'Label';
end

% Normalize ROI names
for h = 1:height(roi_info)
	roi_info.Region{h} = sprintf('r%04d_%s', ...
		roi_info.Label(h),regexprep(roi_info.Region{h},{'[%() ]+','_+$'},{'_', ''}));
end

% Drop any extra columns and save to file
roi_info = roi_info(:,{'Label','Region'});
[~,n,e] = fileparts(roi_csv);
rroi_csv = fullfile(out_dir,[n e]);
writetable(roi_info,rroi_csv)


