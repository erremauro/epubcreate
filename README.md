# EPUB Create

**EPUB Create**, creates a [pandoc][1] directory structure for generating EPUBs.

## Creating the Project

```bash
./epubcreate <path>
```

Note that the `path` can also be a directory name (i.e. `./epubcreate new_book`). In this case the project directory will be created in your current working path.

## Directory Structure

The project will have the following structure:

```
.
├── EPUB
│   ├── fonts
│   │   ├── FFMetaPro-Normal.otf
│   │   ├── FFMetaSerifPro-Book.otf
│   │   ├── FFMetaSerifPro-BookBold.otf
│   │   ├── FFMetaSerifPro-BookItalic.otf
│   │   └── FFMetaSerifPro-LightItalic.otf
│   ├── media
│   │   └── cover.png
│   ├── styles
│   │   └── styles.css
│   └── text
│       └── 01_Chapter_1.md
├── Makefile
├── metadata.yaml
└── scripts
    └── build.sh
```

Pandoc build EPUBs according to its specific directory structure, which do not reflect the structure of your project. Therefore, in order to always have in mind the directory structure that the final EPUB will have, the EPUB project directory has been structured to replicate what pandoc will build inside final EPUB. For this reason is important to not make changes to this structure—in particular for `./EPUB/styles/styles.css` relative path—in order to build a well formatted EPUB.

1. Create your chapters in the `./EPUB/text` directory.
2. Place any media content (i.e. images) in the `./EPUB/media` directory
3. When using images in your text documents, specify their path from the root directory (i.e. `./EPUB/media/my_image.png`)
3. Place any font in the `./EPUB/fonts` directory and update the `./EPUB/styles/styles.css` file according to its *relative* path.

It may be useful to know that whatever name you give to your images in the media directory, they will be converted by pandoc to an increasing index number (except for `cover.png`).

## EPUB Metadata

Before building the EPUB, update the `metadata.yaml` file. Check the [pandoc documentation][2] for a list of the available metadata properties that can be specified for the EPUB.

Note that the `Author` and `Title` specfied in `metadata.yaml` will be used to generate the final EPUB name.

## Creating the Cover

Replace `./EPUB/media/cover.png` with your book cover. The `cover.png` provided with the project can also be used has a blank template to create your own cover.

## Building the EPUB

You can build the EPUB by running `make` in the root of your project directory. The EPUB will be created in the `./build` directory.

## Requirements

The `./scripts/build.sh` script relies on:

- [pandoc][1] to build the EPUB,
- [yq][3] to read the `metadata.yaml` and
- [epubcheck][4] to validate your EPUB. 

All these command-line tools will be automatically installed upon building your EPUB if they're not already installed on your system.


[1]: https://pandoc.org/ "Pandoc Website"
[2]: https://pandoc.org/MANUAL.html#metadata-variables "Pandoc Metadata"
[3]: https://github.com/mikefarah/yq "yq GitHub Page"
[4]: https://www.w3.org/publishing/epubcheck/ "EPUB Check Website"