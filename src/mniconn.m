function mniconn(varargin)


%% Parse inputs
P = inputParser;

% ROI file, MNI space. Two options:
%
%   (1) Filename with no path, e.g. 'ABHHIP_LR.nii.gz'. In this case the
%       file is assumed to exist in the container with a matching label file
%       present e.g. 'ABHHIP_LR-label.nii.gz'.
%
%   (2) Filename with path. In this case the file is provided as input and
%       the wroilabel_csv must also be provided with ROI labels.
addOptional(P,'wroi_niigz','ABHHIP_LR.nii.gz')
addOptional(P,'wroilabel_csv','')

% Preprocessed fMRI, outputs from connprep. MNI space only
addOptional(P,'wremovegm_niigz','../INPUTS/filtered_removegm_noscrub_wadfmri.nii.gz');
addOptional(P,'wkeepgm_niigz','../INPUTS/filtered_keepgm_noscrub_wadfmri.nii.gz');
addOptional(P,'wmeanfmri_niigz','../INPUTS/wmeanadfmri.nii.gz');

% T1, e.g. bias corrected T1 from cat12
addOptional(P,'wt1_niigz','../INPUTS/wmt1.nii.gz');

% Smoothing to apply to connectivity maps
%addOptional(P,'fwhm','6');

% Output connectivity maps or no?
addOptional(P,'connmaps_out','yes')

% Subject info if on XNAT
addOptional(P,'project','UNK_PROJ');
addOptional(P,'subject','UNK_SUBJ');
addOptional(P,'session','UNK_SESS');
addOptional(P,'scan','UNK_SCAN');

% Change paths to match test environment if needed
addOptional(P,'magick_path','/usr/bin');
addOptional(P,'src_path','/opt/mniconn/src');
addOptional(P,'fsl_path','/usr/local/fsl/bin');
addOptional(P,'fs_path','/usr/local/freesurfer');

% Where to store outputs
addOptional(P,'out_dir','../OUTPUTS');

% Parse
parse(P,varargin{:});
disp(P.Results)


%% Process
mniconn_main(P.Results);


%% Exit
if isdeployed
	exit
end

