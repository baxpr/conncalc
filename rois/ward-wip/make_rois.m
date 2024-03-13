% Specific locations for HW project

% Initialize
V = spm_vol(fullfile(spm('dir'),'canonical','avg152T1.nii'));
[Y,XYZ] = spm_read_vols(V);
Yroi = zeros(size(Y));
V.dat = [];  % For orient check later

% A sphere
radius = 6;
sxyz = [-46 -66 +30];
slabel = 1;
dsq = ...
    (XYZ(1,:)-sxyz(1)).^2 + ...
    (XYZ(2,:)-sxyz(2)).^2 + ...
    (XYZ(3,:)-sxyz(3)).^2;
keeps = dsq <= radius^2;
Yroi(keeps) = slabel;
rois = table(slabel,{'ParSeed_L'},'VariableNames',{'Label','Region'});

% Custom ROIs
warning('off','MATLAB:table:RowsAddedExistingVars')
Ps = {
    'baselinecraving_cluster1.nii.gz'
    'baselinecraving_cluster2.nii.gz'
    'connectivitychange_cluster1.nii.gz'
    'connectivitychange_cluster2.nii.gz'
    'connectivitychange_cluster3.nii.gz'
    'connectivitychange_cluster4.nii.gz'
    'connectivitychange_cluster5.nii.gz'
    'connectivitychange_cluster6.nii.gz'
    'cravingchange_cluster1.nii.gz'
    'cravingchange_cluster2.nii.gz'
    'cravingchange_cluster3.nii.gz'
    'cravingchange_cluster4.nii.gz'
    'cravingchange_cluster5.nii.gz'
    };
tags = {
    'BCrave1'
    'BCrave2'
    'ConnChg1'
    'ConnChg2'
    'ConnChg3'
    'ConnChg4'
    'ConnChg5'
    'ConnChg6'
    'CraveChg1'
    'CraveChg2'
    'CraveChg3'
    'CraveChg4'
    'CraveChg5'
    };

k = 1;
for c = 1:numel(Ps)

    Vr = spm_vol(Ps{c});
    spm_check_orientations([V; Vr]);
    Yr = spm_read_vols(Vr);
    inds = Yr > 0;
    if any(Yroi(inds)>0)
        error('ROI overlap found')
    end
    k = k + 1;
    Yroi(inds) = k;
    rois.Label(end+1,1) = k;
    rois.Region{end} = tags{c};

end

% Write to file
Vroi = rmfield(V,'private');
Vroi.pinfo(1:2) = [1 0];
Vroi.dt(1) = spm_type('uint16');
Vroi.fname = 'HW_ParSeed.nii';
spm_write_vol(Vroi,Yroi);
system('gzip -f HW_ParSeed.nii');
writetable(rois,'HW_ParSeed-labels.csv')
