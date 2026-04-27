% Spheres at some specific locations from
%
% Raichle ME. The restless brain. Brain Connect. 2011;1(1):3-12. doi:
% 10.1089/brain.2011.0019. PMID: 22432951; PMCID: PMC3621343.
%
% https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3621343/
%

radius = 6;

tag = 'HW_LPFC';

rois = table([],[],[],{},'VariableNames',{'x','y','z','Region'});
rois(end+1,:) = table(-50,+30,+36,{'DLPFC_L'});


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
Vroi.fname = [tag '.nii'];
spm_write_vol(Vroi,Yroi);
system(['gzip -f' tag '.nii']);

info = rois(:,{'Label','Region'});
writetable(info,[tag '-labels.csv'])
