#!/bin/bash
#
# Make PDF pages from screenshots

cd ${OUT}

# Connectivity maps
convert -density 300 -gravity Center shot_conn_mni*.png \
  -background white -resize 1850x -extent 2050x2800 -bordercolor white -border 100 \
  -gravity SouthEast -background white -splice 0x15 -pointsize 9 \
  -annotate +25+25 "$(date)" \
  -gravity NorthWest -pointsize 12 -annotate +50+50 \
  "${project} ${subject} ${session} ${scan}" \
  page_conn_mni.png
