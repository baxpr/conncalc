function ctr_of_mass(img_nii,roival)

V = spm_vol(img_nii);
[Y,XYZ] = spm_read_vols(V(1));
if roival > 0
	Y(Y(:)~=roival) = 0;
end
Y = repmat(Y(:)',3,1);
com = round(sum(Y.*XYZ,2) ./ sum(Y,2));
fprintf('%0.0f %0.0f %0.0f',com(1),com(2),com(3));
