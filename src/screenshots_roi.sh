#!/usr/bin/env bash

# ROIs on t1 and mean fmri, axial slices +x / -y mm from center of mass of mean fmri

thedate=$(date)

# FSL init
PATH=${FSLDIR}/bin:${PATH}
. ${FSLDIR}/etc/fslconf/fsl.sh

# Work in output directory
cd ${OUT}

# Find center of mass of mean fmri
com=$(fslstats wmeanfmri -c)
XYZ=(${com// / })

# Axial slices to show, relative to COM in mm
for sl in -40 -30 -20 -10 +0 +10 +20 +30 +40 +50 +60; do

    fsleyes render -of slice_${sl}.png \
        --scene ortho --worldLoc ${XYZ[0]} ${XYZ[1]} $(echo "${XYZ[2]} + ${sl}" | bc -l) \
        --layout horizontal --hideCursor --hideLabels --hidex --hidey \
        wmeanfmri --overlayType volume \
        roi --overlayType label --lut random_big --outline --outlineWidth 2

    fsleyes render -of slice_${sl}.png \
        --scene ortho --worldLoc ${XYZ[0]} ${XYZ[1]} $(echo "${XYZ[2]} + ${sl}" | bc -l) \
        --layout horizontal --hideCursor --hideLabels --hidex --hidey \
        wt1 --overlayType volume \
        roi --overlayType label --lut random_big --outline --outlineWidth 2

done

# Combine into single PDF
${IMMAGDIR}/montage -mode concatenate slice_*.png \
-tile 4x3 -quality 100 -background black -gravity center \
-border 20 -bordercolor black page1.png


info_string="$PROJECT $SUBJECT $SESSION $SCAN"
${IMMAGDIR}/convert \
-size 2600x3365 xc:white \
-gravity center \( page1.png -resize 2400x \) -composite \
-gravity North -pointsize 48 -annotate +0+100 \
"ROIs on mean fMRI" \
-gravity SouthEast -pointsize 48 -annotate +100+100 "$thedate" \
-gravity NorthWest -pointsize 48 -annotate +100+200 "${info_string}" \
page1.png

