function conncalc(varargin)


%% Parse inputs
P = inputParser;

% ROI file. Two options:
%
%   (1) Filename with no path, e.g. 'ABHHIP_LR.nii.gz'. In this case the
%       file is assumed to exist in the container with a matching label file
%       present e.g. 'ABHHIP_LR-label.nii.gz'.
%
%   (2) Filename with path. In this case the file is provided as input and
%       the roilabel_csv must also be provided with ROI labels.
addOptional(P,'roi_niigz','ABHHIP_LR.nii.gz')
addOptional(P,'roilabel_csv','')

% Preprocessed fMRI, outputs from connprep. Same space as the ROI image.
addOptional(P,'removegm_niigz','');
addOptional(P,'keepgm_niigz','');
addOptional(P,'meanfmri_niigz','');

% T1, e.g. bias corrected T1 from cat12
addOptional(P,'t1_niigz','');

% Brain mask to avoid storing an entire volume of junk
addOptional(P,'mask_niigz','none');

% Smoothing to apply to connectivity maps
%addOptional(P,'fwhm','6');

% Output connectivity maps or no?
addOptional(P,'connmaps_out','yes')

% Subject info if on XNAT
addOptional(P,'label_info','');

% Where to store outputs
addOptional(P,'out_dir','/OUTPUTS');

% Parse
parse(P,varargin{:});
disp(P.Results)


%% Process
conncalc_main(P.Results);


%% Exit
if isdeployed
	exit
end

