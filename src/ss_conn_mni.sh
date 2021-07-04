#!/bin/bash

function connmap {
	# 1 IMG
	# 2 name
	# 3-5 x y z
	# connmap sZ_LHIPP_wremovegm.nii hipp -25 -20 -16

	freeview \
	  -v ${OUT}/wt1.nii \
	  -v ${OUT}/${1}:colormap=heat:heatscale=90,95,100:percentile=true \
	  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport sagittal \
	  -ras ${3} -18 18 \
	  -ss conn_mni_${2}_sag.png

  	freeview \
  	  -v ${OUT}/wt1.nii \
  	  -v ${OUT}/${1}:colormap=heat:heatscale=90,95,100:percentile=true \
  	  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport coronal \
  	  -ras 0 ${4} 18 \
  	  -ss conn_mni_${2}_cor.png

	freeview \
	  -v ${OUT}/wt1.nii \
	  -v ${OUT}/${1}:colormap=heat:heatscale=90,95,100:percentile=true \
	  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport axial \
	  -ras 0 -18 ${5} \
	  -ss conn_mni_${2}_axi.png

	montage -mode concatenate -title "${2}" -stroke white -fill white \
	  conn_mni_${2}_sag.png conn_mni_${2}_cor.png conn_mni_${2}_axi.png \
	  -tile 3x -quality 100 -background black -gravity center \
	  -border 10 -bordercolor black conn_mni_${2}.png
	  
	rm conn_mni_${2}_sag.png conn_mni_${2}_cor.png conn_mni_${2}_axi.png

}

cd ${OUT}

# Make images for each seed ROI
while IFS= read -r csvline; do
	roinum=$(echo "${csvline}" | cut -f 1 -d ,)
	if [[ "${roinum}" == "Label" ]] ; then continue ; fi
	roiname=$(echo "${csvline}" | cut -f 2 -d ,)
	minv=$(echo "${roinum} - 0.5" | bc -l)
	maxv=$(echo "${roinum} + 0.5" | bc -l)
	location=$(fslstats "${roi_nii}" -l $minv -u $maxv -c)
	echo Seed image ${r} ${roiname} ${minv} ${maxv} ${location}
	connmap "connmaps/Z_${roiname}_wremovegm.nii" "${roiname}" ${location}
done < "${roi_csv}"

# Combine into single pages, in sets of 4
montage -mode concatenate \
	conn_mni_*.png \
	-tile 1x4 -quality 100 -background black -gravity center \
	-border 10 -bordercolor white shot_conn_mni.png
