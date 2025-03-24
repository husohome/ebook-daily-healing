# Function to download a file
function Download-File {
    param (
        [string]$Url,
        [string]$OutputPath
    )
    
    Write-Host "Downloading $Url to $OutputPath..."
    Invoke-WebRequest -Uri $Url -OutFile $OutputPath
}

# Create fonts directory if it doesn't exist
if (-not (Test-Path "fonts")) {
    New-Item -ItemType Directory -Path "fonts"
}

# Download Source Serif Pro fonts
$sourceSerifUrls = @{
    "Regular" = "https://github.com/google/fonts/raw/main/ofl/sourceserifpro/SourceSerifPro-Regular.ttf"
    "Bold" = "https://github.com/google/fonts/raw/main/ofl/sourceserifpro/SourceSerifPro-Bold.ttf"
    "Italic" = "https://github.com/google/fonts/raw/main/ofl/sourceserifpro/SourceSerifPro-Italic.ttf"
    "BoldItalic" = "https://github.com/google/fonts/raw/main/ofl/sourceserifpro/SourceSerifPro-BoldItalic.ttf"
}

# Download Source Sans Pro fonts
$sourceSansUrls = @{
    "Regular" = "https://github.com/google/fonts/raw/main/ofl/sourcesanspro/SourceSansPro-Regular.ttf"
    "Bold" = "https://github.com/google/fonts/raw/main/ofl/sourcesanspro/SourceSansPro-Bold.ttf"
    "Italic" = "https://github.com/google/fonts/raw/main/ofl/sourcesanspro/SourceSansPro-Italic.ttf"
    "BoldItalic" = "https://github.com/google/fonts/raw/main/ofl/sourcesanspro/SourceSansPro-BoldItalic.ttf"
}

# Download Source Serif Pro fonts
foreach ($font in $sourceSerifUrls.GetEnumerator()) {
    Download-File -Url $font.Value -OutputPath "fonts/SourceSerifPro-$($font.Key).ttf"
}

# Download Source Sans Pro fonts
foreach ($font in $sourceSansUrls.GetEnumerator()) {
    Download-File -Url $font.Value -OutputPath "fonts/SourceSansPro-$($font.Key).ttf"
}

Write-Host "All fonts downloaded successfully!" 