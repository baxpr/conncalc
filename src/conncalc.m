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
addOptional(P,'removegm_niigz','../INPUTS/filtered_removegm_noscrub_wadfmri.nii.gz');
addOptional(P,'keepgm_niigz','../INPUTS/filtered_keepgm_noscrub_wadfmri.nii.gz');
addOptional(P,'meanfmri_niigz','../INPUTS/wmeanadfmri.nii.gz');

% T1, e.g. bias corrected T1 from cat12
addOptional(P,'t1_niigz','../INPUTS/wmt1.nii.gz');

% Smoothing to apply to connectivity maps
%addOptional(P,'fwhm','6');

% Output connectivity maps or no?
addOptional(P,'connmaps_out','yes')

% Subject info if on XNAT
addOptional(P,'label_info','UNKNOWN SCAN');

% Change paths to match test environment if needed
addOptional(P,'magick_path','/usr/bin');
addOptional(P,'src_path','/opt/conncalc/src');
addOptional(P,'fsl_path','/usr/local/fsl/bin');
addOptional(P,'fs_path','/usr/local/freesurfer');

% Where to store outputs
addOptional(P,'out_dir','../OUTPUTS');

% Parse
parse(P,varargin{:});
disp(P.Results)


%% Process
conncalc_main(P.Results);


%% Exit
if isdeployed
	exit
end

