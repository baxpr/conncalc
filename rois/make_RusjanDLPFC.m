% Left DLPFC region from
%
% Rusjan PM, Barr MS, Farzan F, Arenovich T, Maller JJ, Fitzgerald PB,
% Daskalakis ZJ. Optimal transcranial magnetic stimulation coil placement
% for targeting the dorsolateral prefrontal cortex using novel magnetic
% resonance image-guided neuronavigation. Hum Brain Mapp. 2010
% Nov;31(11):1643-52. doi: 10.1002/hbm.20964. PMID: 20162598; PMCID:
% PMC6871247.
%
% https://pmc.ncbi.nlm.nih.gov/articles/PMC6871247/
%
% 8 mm sphere centered at MNI -50, +30, +36, with non-brain voxels masked
% out.

radius = 8;

tag = 'RusjanDLPFC';

rois = table([],[],[],{},'VariableNames',{'x','y','z','Region'});
rois(end+1,:) = table(-50,+30,+36,{'RusjanDLPFC_L'});


rois.Label = (1:height(rois))';

Vmask = spm_vol('/usr/local/fsl/data/standard/MNI152_T1_2mm_brain_mask.nii.gz');
Ymask = spm_read_vols(Vmask);

V = spm_vol(fullfile(spm('dir'),'canonical','avg152T1.nii'));
[Y,XYZ] = spm_read_vols(V);
Yroi = zeros(size(Y));

for r = 1:height(rois)
    
    dsq = ...
        (XYZ(1,:)-rois.x(r)).^2 + ...
        (XYZ(2,:)-rois.y(r)).^2 + ...
        (XYZ(3,:)-rois.z(r)).^2;
    keeps = dsq <= radius^2;
    Yroi(keeps) = r;
    
end

Yroi(Ymask(:)<0.5) = 0;

Vroi = rmfield(V,'private');
Vroi.pinfo(1:2) = [1 0];
Vroi.dt(1) = spm_type('uint16');
Vroi.fname = [tag '.nii'];
spm_write_vol(Vroi,Yroi);
system(['gzip -f ' tag '.nii']);

info = rois(:,{'Label','Region'});
writetable(info,[tag '-labels.csv'])
