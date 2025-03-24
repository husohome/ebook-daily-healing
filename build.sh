#!/bin/bash

# Create output directory
mkdir -p dist

# Convert SVG images to JPG for better compatibility
echo "Converting images..."
mkdir -p dist/images
convert assets/image/four_element_types.svg dist/images/four_element_types.jpg
convert assets/image/discovering_your_healing_types.svg dist/images/discovering_your_healing_types.jpg

# Generate EPUB
echo "Generating EPUB..."
pandoc \
  --metadata-file=book.yaml \
  --from markdown+yaml_metadata_block \
  --to epub3 \
  --toc \
  --toc-depth=3 \
  --epub-cover-image=dist/images/four_element_types.jpg \
  --css=styles.css \
  -o dist/self_healing_journey.epub \
  content/01_introduction/*.md \
  content/02_techniques/**/*.md \
  content/03_themes/**/*.md

# Generate PDF (for print version)
echo "Generating PDF..."
pandoc \
  --metadata-file=book.yaml \
  --from markdown+yaml_metadata_block \
  --template=template.tex \
  --pdf-engine=xelatex \
  --toc \
  --toc-depth=3 \
  -V documentclass=book \
  -V papersize=6in:9in \
  -V geometry:margin=0.75in \
  -o dist/self_healing_journey.pdf \
  content/01_introduction/*.md \
  content/02_techniques/**/*.md \
  content/03_themes/**/*.md

echo "Build complete! Check the dist/ directory for output files." 