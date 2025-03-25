#!/bin/bash

# Create output directory
mkdir -p "dist/images"

# Check for required tools
if ! command -v pandoc &> /dev/null; then
    echo "Error: Pandoc is not installed. Please install it from https://pandoc.org/installing.html"
    exit 1
fi

if ! command -v magick &> /dev/null; then
    echo "Error: ImageMagick is not installed. Please install it from https://imagemagick.org/script/download.php"
    exit 1
fi

# Convert SVG images to JPG
echo "Converting images..."
for svg_file in assets/image/*.svg; do
    filename=$(basename "$svg_file" .svg)
    magick "$svg_file" "dist/images/$filename.jpg"
done

# Generate KDP-compatible EPUB
echo "Generating EPUB for KDP..."
pandoc \
    --metadata-file=book.yaml \
    --from markdown \
    --to epub3 \
    --toc \
    --toc-depth=3 \
    --css=styles.css \
    --output="dist/self_healing_journey.epub" \
    "content/01_introduction/01_welcome.md"

# Generate Print-ready PDF (KDP 6x9 format)
echo "Generating PDF for KDP Print..."
pandoc \
    --metadata-file=book.yaml \
    --from markdown \
    --template="templates/template.tex" \
    --pdf-engine=xelatex \
    --toc \
    --toc-depth=3 \
    --variable=geometry:paperwidth=6in \
    --variable=geometry:paperheight=9in \
    --variable=geometry:margin=0.75in \
    --variable=geometry:inner=0.875in \
    --variable=geometry:outer=0.625in \
    --output="dist/self_healing_journey.pdf" \
    "content/01_introduction/01_welcome.md"

echo "Build complete! Check the dist/ directory for output files."
echo
echo "Next steps for KDP publishing:"
echo "1. Go to kdp.amazon.com and sign in"
echo "2. Click '+ Create' and choose 'eBook'"
echo "3. Upload the EPUB file from dist/self_healing_journey.epub"
echo "4. For paperback, create a new title and upload the PDF from dist/self_healing_journey.pdf"
echo "5. Set your book's metadata, pricing, and territories"
echo

# No need for pause command in Unix/Linux 