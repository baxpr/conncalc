#!/bin/bash

echo Screenshots maps

function connmap {
	# 1 IMG
	# 2 name
	# 3-5 x y z
	# connmap sZ_LHIPP_removegm.nii hipp -25 -20 -16

	freeview \
	  -v ${out_dir}/t1.nii \
	  -v ${out_dir}/${1}:colormap=heat:heatscale=90,95,100:percentile=true \
	  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport sagittal \
	  -ras ${3} -18 18 \
	  -ss conn_${2}_sag.png

  	freeview \
  	  -v ${out_dir}/t1.nii \
  	  -v ${out_dir}/${1}:colormap=heat:heatscale=90,95,100:percentile=true \
  	  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport coronal \
  	  -ras 0 ${4} 18 \
  	  -ss conn_${2}_cor.png

	freeview \
	  -v ${out_dir}/t1.nii \
	  -v ${out_dir}/${1}:colormap=heat:heatscale=90,95,100:percentile=true \
	  -viewsize 400 400 --layout 1 --zoom 1.3 --viewport axial \
	  -ras 0 -18 ${5} \
	  -ss conn_${2}_axi.png

	montage -mode concatenate -title "${2}" -stroke white -fill white \
	  conn_${2}_sag.png conn_${2}_cor.png conn_${2}_axi.png \
	  -tile 3x -quality 100 -background black -gravity center \
	  -border 10 -bordercolor black conn_${2}.png
	  
	rm conn_${2}_sag.png conn_${2}_cor.png conn_${2}_axi.png

}

cd ${out_dir}

# Make images for each seed ROI. Bit of a hacky way to loop through lines of the
# ROI label file, but it works
while IFS= read -r csvline; do
	roinum=$(echo "${csvline}" | cut -f 1 -d ,)
	if [[ "${roinum}" == "Label" ]] ; then continue ; fi
	roiname=$(echo "${csvline}" | cut -f 2 -d ,)
    run_spm12.sh ${MATLAB_RUNTIME} function ctr_of_mass ${roi_nii} ${roinum} loc.txt
	location=$(cat loc.txt)
    rm loc.txt
	echo Seed image ${r} ${roiname} ${roinum} ${location}
	connmap "connmaps/Z_${roiname}_removegm.nii" "${roiname}" ${location}
done < "${rroi_csv}"

# Combine into single pages, in sets of 4
montage -mode concatenate \
	conn_*.png \
	-tile 1x4 -quality 100 -background black -gravity center \
	-border 10 -bordercolor white shot_conn.png

# Annotate
convert -density 300 -gravity Center shot_conn*.png \
  -background white -resize 1850x -extent 2050x2800 -bordercolor white -border 100 \
  -gravity SouthEast -background white -splice 0x15 -pointsize 9 \
  -annotate +25+25 "$(date)" \
  -gravity NorthWest -pointsize 12 -annotate +50+50 \
  "${label_info}" \
  page_conn.png
