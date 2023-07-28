% Spheres from
%
% Raichle ME. The restless brain. Brain Connect. 2011;1(1):3-12. doi:
% 10.1089/brain.2011.0019. PMID: 22432951; PMCID: PMC3621343.
%
% https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3621343/
%

radius = 6;

rois = table([],[],[],{},'VariableNames',{'x','y','z','Region'});

rois(end+1,:) = table(+00,-52,+27,{'DMN_PostCing'});
rois(end+1,:) = table(-01,+54,+27,{'DMN_MedPref'});
rois(end+1,:) = table(-46,-66,+30,{'DMN_LatPar_L'});
rois(end+1,:) = table(+49,-63,+33,{'DMN_LatPar_R'});
rois(end+1,:) = table(-61,-24,-09,{'DMN_InfTemp_L'});
rois(end+1,:) = table(+58,-24,-09,{'DMN_InfTemp_R'});
rois(end+1,:) = table(+00,-12,+09,{'DMN_MDThal'});
rois(end+1,:) = table(-25,-81,-33,{'DMN_PostCereb_L'});
rois(end+1,:) = table(+25,-81,-33,{'DMN_PostCereb_R'});

rois(end+1,:) = table(-29,-09,+54,{'DAN_FEF_L'});
rois(end+1,:) = table(+29,-09,+54,{'DAN_FEF_R'});
rois(end+1,:) = table(-26,-66,+48,{'DAN_PostIPS_L'});
rois(end+1,:) = table(+26,-66,+48,{'DAN_PostIPS_R'});
rois(end+1,:) = table(-44,-39,+45,{'DAN_AntIPS_L'});
rois(end+1,:) = table(+41,-39,+45,{'DAN_AntIPS_R'});
rois(end+1,:) = table(-50,-66,-06,{'DAN_MT_L'});
rois(end+1,:) = table(+53,-63,-06,{'DAN_MT_R'});

rois(end+1,:) = table(+00,+24,+46,{'ECN_DorsMedPFC'});
rois(end+1,:) = table(-44,+45,+00,{'ECN_AntPFC_L'});
rois(end+1,:) = table(+44,+45,+00,{'ECN_AntPFC_R'});
rois(end+1,:) = table(-50,-51,+45,{'ECN_SupPar_L'});
rois(end+1,:) = table(+50,-51,+45,{'ECN_SupPar_R'});

rois(end+1,:) = table(+00,+21,+36,{'SN_DorsAntCing'});
rois(end+1,:) = table(-35,+45,+30,{'SN_AntPFC_L'});
rois(end+1,:) = table(+32,+45,+30,{'SN_AntPFC_R'});
rois(end+1,:) = table(-41,+03,+06,{'SN_Ins_L'});
rois(end+1,:) = table(+41,+03,+06,{'SN_Ins_R'});
rois(end+1,:) = table(-62,-45,+30,{'SN_LatPar_L'});
rois(end+1,:) = table(+62,-45,+30,{'SN_LatPar_R'});

rois(end+1,:) = table(-39,-26,+51,{'SS_MotCor_L'});
rois(end+1,:) = table(+38,-26,+48,{'SS_MotCor_R'});
rois(end+1,:) = table(+00,-21,+48,{'SS_SMA'});

rois(end+1,:) = table(-07,-83,+02,{'VS_V1_L'});
rois(end+1,:) = table(+07,-83,+02,{'VS_V1_R'});

rois(end+1,:) = table(-62,-30,+12,{'AS_A1_L'});
rois(end+1,:) = table(+59,-27,+15,{'AS_A1_R'});


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
Vroi.fname = 'Raichle2011.nii';
spm_write_vol(Vroi,Yroi);
system('gzip -f Raichle2011.nii');

info = rois(:,{'Label','Region','x','y','z'});
writetable(info,'Raichle2011-labels.csv')

