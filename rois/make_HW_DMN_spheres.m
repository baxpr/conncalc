% Spheres at some specific locations from
%
% Raichle ME. The restless brain. Brain Connect. 2011;1(1):3-12. doi:
% 10.1089/brain.2011.0019. PMID: 22432951; PMCID: PMC3621343.
%
% https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3621343/
%

radius = 6;

rois = table(-41,+16,+54,{'DLPFC_L'},'VariableNames',{'x','y','z','Region'});
rois(end+1,:) = table(+41,+16,+54,{'DLPFC_R'});
rois(end+1,:) = table(-34,+26,+02,{'ANTINS_L'});
rois(end+1,:) = table(+34,+26,+02,{'ANTINS_R'});
rois(end+1,:) = table(+00,-52,+27,{'DMN_PCC'});
rois(end+1,:) = table(-01,+54,+27,{'DMN_MPFC'});
rois(end+1,:) = table(-46,-66,+30,{'DMN_PAR_L'});
rois(end+1,:) = table(+49,-63,+33,{'DMN_PAR_R'});
rois(end+1,:) = table(-61,-24,-09,{'DMN_INFTEMP_L'});
rois(end+1,:) = table(+58,-24,-09,{'DMN_INFTEMP_R'});

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
Vroi.fname = 'HW_DMN_1.nii';
spm_write_vol(Vroi,Yroi);
system('gzip -f HW_DMN_1.nii');

info = rois(:,{'Label','Region'});
writetable(info,'HW_DMN_1-labels.csv')
