#!/bin/bash

echo Screenshots maps

function connmap {

    local zmap=connmaps/Z_${roiname}_removegm.nii

    freeview \
        -v ${out_dir}/t1.nii \
        -v ${out_dir}/${zmap}:colormap=heat:heatscale=90,95,100:percentile=true \
        -viewsize 400 400 --layout 1 --zoom 1.2 --viewport sagittal \
        -ras ${seedloc[0]} ${maskloc[1]} ${maskloc[2]} \
        -ss conn_${roiname}_sag.png

    freeview \
        -v ${out_dir}/t1.nii \
        -v ${out_dir}/${zmap}:colormap=heat:heatscale=90,95,100:percentile=true \
        -viewsize 400 400 --layout 1 --zoom 1.2 --viewport coronal \
        -ras ${maskloc[0]} ${seedloc[1]} ${maskloc[2]} \
        -ss conn_${roiname}_cor.png         

    freeview \
        -v ${out_dir}/t1.nii \
        -v ${out_dir}/${zmap}:colormap=heat:heatscale=90,95,100:percentile=true \
        -viewsize 400 400 --layout 1 --zoom 1.2 --viewport axial \
        -ras ${maskloc[0]} ${maskloc[1]} ${seedloc[2]} \
        -ss conn_${roiname}_axi.png

	montage -mode concatenate -title "${roiname}" -stroke white -fill white \
        conn_${roiname}_sag.png conn_${roiname}_cor.png conn_${roiname}_axi.png \
        -tile 3x -quality 100 -background black -gravity center \
        -border 10 -bordercolor black conn_${roiname}.png
	  
	rm conn_${roiname}_sag.png conn_${roiname}_cor.png conn_${roiname}_axi.png

}

cd ${out_dir}

# Make images for each seed ROI. Bit of a hacky way to loop through lines of the
# ROI label file, but it works
run_spm12.sh ${MATLAB_RUNTIME} function ctr_of_mass rmask.nii ${roinum} ${out_dir}/loc.txt
maskloc=$(cat loc.txt) ; rm loc.txt ; maskloc=(${com// / })
while IFS= read -r csvline; do
    echo $csvline
	roinum=$(echo "${csvline}" | cut -f 1 -d ,)
	if [[ "${roinum}" == "Label" ]] ; then continue ; fi
	roiname=$(echo "${csvline}" | cut -f 2 -d ,)
    run_spm12.sh ${MATLAB_RUNTIME} function ctr_of_mass rroi.nii ${roinum} ${out_dir}/loc.txt
	seedloc=$(cat loc.txt) ; rm loc.txt ; seedloc=(${com// / })
	echo Seed image ${roinum} ${roiname} ${maskloc} ${seedloc}
	connmap
done < ${out_dir}/rroi-labels.csv

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
    -gravity NorthWest -pointsize 12 -annotate +50+50 "${label_info}" \
    page_conn.png
