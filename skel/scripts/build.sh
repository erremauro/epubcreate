#!/bin/bash

# Function to install a package on Linux or macOS
install_package() {
    PACKAGE_NAME=$1
    LINUX_INSTALL_CMD=$2
    MAC_INSTALL_CMD=$3

    echo "$PACKAGE_NAME is not installed. Installing now..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux system (Debian/Ubuntu)
        sudo apt-get update
        eval "$LINUX_INSTALL_CMD"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS (Homebrew)
        if ! command -v brew &> /dev/null; then
            echo "Homebrew is not installed. Please install Homebrew first and rerun the script."
            exit 1
        fi
        eval "$MAC_INSTALL_CMD"
    else
        echo "Unsupported operating system. Please install $PACKAGE_NAME manually."
        exit 1
    fi

    # Check if the installation was successful
    if ! command -v "$PACKAGE_NAME" &> /dev/null; then
        echo "$PACKAGE_NAME installation failed. Exiting."
        exit 1
    fi

    echo "$PACKAGE_NAME installed successfully."
}

# Check if yq is installed, otherwise install it automatically
if ! command -v yq &> /dev/null; then
    install_package "yq" "sudo apt-get install -y yq" "brew install yq"
fi

# Check if epubcheck is installed, otherwise install it automatically
if ! command -v epubcheck &> /dev/null; then
    echo "epubcheck is not installed. Installing now..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux system (Debian/Ubuntu)
        sudo apt-get update
        sudo apt-get install -y default-jre wget unzip
        wget https://github.com/w3c/epubcheck/releases/download/v4.2.6/epubcheck-4.2.6.zip
        unzip epubcheck-4.2.6.zip -d epubcheck
        sudo mv epubcheck /opt/
        sudo ln -s /opt/epubcheck/epubcheck.jar /usr/local/bin/epubcheck
        sudo ln -s /usr/bin/java /usr/local/bin/java
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS (Homebrew)
        install_package "epubcheck" "" "brew install epubcheck"
    else
        echo "Unsupported operating system. Please install epubcheck manually."
        exit 1
    fi

    if ! command -v epubcheck &> /dev/null; then
        echo "epubcheck installation failed. Exiting."
        exit 1
    fi

    echo "epubcheck installed successfully."
fi

# Check if pandoc is installed, otherwise install it automatically
if ! command -v pandoc &> /dev/null; then
    install_package "pandoc" "sudo apt-get install -y pandoc" "brew install pandoc"
fi

# Check if the metadata.yaml file exists
if [ ! -f "metadata.yaml" ]; then
    echo "File 'metadata.yaml' not found!"
    exit 1
fi

# Usa yq per estrarre il valore di title > text
AUTHOR_TEXT=$(yq '.creator[] | select(.type == "author") | .text' metadata.yaml)
TITLE_TEXT=$(yq '.title[] | select(.type == "main") | .text' metadata.yaml)

echo "Removing build directory..."
rm -rf build
mkdir build

echo "Creating the file list..."
ls ./EPUB/text/*.md > filelist.txt

EPUB_FILE="./build/$AUTHOR_TEXT - $TITLE_TEXT.epub"

echo "Creating the final epub..."
pandoc $(cat filelist.txt) \
  --metadata-file=metadata.yaml \
  --css=./EPUB/styles/styles.css \
  --epub-cover-image=./EPUB/media/cover.png \
  --epub-embed-font=./EPUB/fonts/FFMetaPro-Normal.otf \
  --epub-embed-font=./EPUB/fonts/FFMetaSerifPro-Book.otf \
  --epub-embed-font=./EPUB/fonts/FFMetaSerifPro-BookBold.otf \
  --epub-embed-font=./EPUB/fonts/FFMetaSerifPro-BookItalic.otf \
  --epub-embed-font=./EPUB/fonts/FFMetaSerifPro-LightItalic.otf \
  -o "$EPUB_FILE"

echo "EPUB file generated: $EPUB_FILE"

echo "Validating EPUB with epubcheck..."
epubcheck "$EPUB_FILE"

echo "Done."
