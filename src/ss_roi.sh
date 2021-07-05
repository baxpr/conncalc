#!/usr/bin/env bash

# ROIs on t1 and mean fmri, axial slices +x / -y mm from center of mass of mean fmri

echo Screenshots ROI

thedate=$(date)

# Work in output directory
cd ${out_dir}

# Find center of mass of mean fmri
com=$(fslstats meanfmri -c)
XYZ=(${com// / })

# Axial slices to show, relative to COM in mm
for sl in -040 -030 -020 -010 000 010 020 030 040 050 060; do

    Z=$(echo "${XYZ[2]} + ${sl}" | bc -l)

    fsleyes render -of slice_fmri_${sl}.png \
        --scene ortho --worldLoc ${XYZ[0]} ${XYZ[1]} ${Z} \
        --layout horizontal --hideCursor --hideLabels --hidex --hidey \
        meanfmri --overlayType volume \
        roi --overlayType label --lut random_big --outline --outlineWidth 2

    fsleyes render -of slice_t1_${sl}.png \
        --scene ortho --worldLoc ${XYZ[0]} ${XYZ[1]} ${Z} \
        --layout horizontal --hideCursor --hideLabels --hidex --hidey \
        t1 --overlayType volume \
        roi --overlayType label --lut random_big --outline --outlineWidth 2

done

# Combine into single page
montage -mode concatenate slice_fmri_-0{4,3,2,1}*.png slice_fmri_0*.png \
    -tile 3x4 -quality 100 -background black -gravity center \
    -border 20 -bordercolor black page_fmri.png

convert \
    -size 2250x3000 xc:white -density 300 \
    -gravity center \( page_fmri.png -resize 2000x \) -composite \
    -gravity North -pointsize 12 -annotate +0+100 \
    "ROIs on mean fMRI" \
    -gravity SouthEast -pointsize 12 -annotate +100+100 "${thedate}" \
    -gravity NorthWest -pointsize 12 -annotate +100+200 "${label_info}" \
    page_fmri.png

montage -mode concatenate slice_t1_-0{4,3,2,1}*.png slice_t1_0*.png \
    -tile 3x4 -quality 100 -background black -gravity center \
    -border 20 -bordercolor black page_t1.png

convert \
    -size 2250x3000 xc:white -density 300 \
    -gravity center \( page_t1.png -resize 2000x \) -composite \
    -gravity North -pointsize 12 -annotate +0+100 \
    "ROIs on T1" \
    -gravity SouthEast -pointsize 12 -annotate +100+100 "${thedate}" \
    -gravity NorthWest -pointsize 12 -annotate +100+200 "${label_info}" \
    page_t1.png

