% Spheres from
%
% Gordon EM et al. A somato-cognitive action network alternates with
% effector regions in motor cortex. Nature. 2023 May;617(7960):351-359.
% doi: 10.1038/s41586-023-05964-2. Epub 2023 Apr 19. PMID: 37076628; PMCID:
% PMC10172144.
%
% https://www.ncbi.nlm.nih.gov/pmc/articles/PMC10172144/

radius = 6;

rois = table({},[],[],[],'VariableNames',{'Region','x','y','z'});

% Inter-effectors (M1)
rois(end+1,:) = table({'M1_Sup_L'},  -19,-34,+59);
rois(end+1,:) = table({'M1_Sup_R'},  +20,-31,+58);
rois(end+1,:) = table({'M1_Mid_L'},  -38,-18,+44);
rois(end+1,:) = table({'M1_Mid_R'},  +40,-15,+43);
rois(end+1,:) = table({'M1_Inf_L'},  -54,-03,+14);
rois(end+1,:) = table({'M1_Inf_R'},  +56,-01,+16);

% Midline (cortex)
rois(end+1,:) = table({'SMA_L'},     -05,-07,+52);
rois(end+1,:) = table({'SMA_R'},     +05,-05,+49);
rois(end+1,:) = table({'PreSMA_L'},  -07,+01,+36);
rois(end+1,:) = table({'PreSMA_R'},  +06,+03,+36);

% Putamen
rois(end+1,:) = table({'Put_Post_L'},-28,-05,-01);
rois(end+1,:) = table({'Put_Post_R'},+28,-09,+03);

% Thalamus
rois(end+1,:) = table({'Thal_CM_L'}, -10,-21,+02);
rois(end+1,:) = table({'Thal_CM_R'}, +12,-20,+03);

% Cerebellum
rois(end+1,:) = table({'Cb_Dors_L'}, -09,-65,-18);
rois(end+1,:) = table({'Cb_Dors_R'}, +11,-61,-16);
rois(end+1,:) = table({'Cb_Vent_L'}, -23,-53,-54);
rois(end+1,:) = table({'Cb_Vent_R'}, +24,-59,-54);


rois.Label = (1:height(rois))';

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

Vroi = rmfield(V,'private');
Vroi.pinfo(1:2) = [1 0];
Vroi.dt(1) = spm_type('uint16');
Vroi.fname = 'Gordon2023_SCAN.nii';
spm_write_vol(Vroi,Yroi);
system('gzip -f Gordon2023_SCAN.nii');

info = rois(:,{'Label','Region','x','y','z'});
writetable(info,'Gordon2023_SCAN-labels.csv')

