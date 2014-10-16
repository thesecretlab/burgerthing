ORIGINAL_ICON=$1

convert $ORIGINAL_ICON -resize 1024 Icon-1024.png
convert $ORIGINAL_ICON -resize 512 Icon-512.png

convert $ORIGINAL_ICON -resize 76 Icon-76.png
convert $ORIGINAL_ICON -resize 152 Icon-76@2x.png

convert $ORIGINAL_ICON -resize 72 Icon-72.png
convert $ORIGINAL_ICON -resize 144 Icon-72@2x.png
convert $ORIGINAL_ICON -resize 216 Icon-72@3x.png

convert $ORIGINAL_ICON -resize 120 Icon-60@2x.png
convert $ORIGINAL_ICON -resize 180 Icon-60@3x.png

convert $ORIGINAL_ICON -resize 57 Icon-57.png
convert $ORIGINAL_ICON -resize 114 Icon-57@2x.png
convert $ORIGINAL_ICON -resize 171 Icon-57@3x.png

convert $ORIGINAL_ICON -resize 50 Icon-50.png
convert $ORIGINAL_ICON -resize 100 Icon-50@2x.png

convert $ORIGINAL_ICON -resize 40 Icon-40.png
convert $ORIGINAL_ICON -resize 80 Icon-40@2x.png
convert $ORIGINAL_ICON -resize 120 Icon-40@3x.png

convert $ORIGINAL_ICON -resize 29 Icon-29.png
convert $ORIGINAL_ICON -resize 58 Icon-29@2x.png
convert $ORIGINAL_ICON -resize 87 Icon-29@3x.png


