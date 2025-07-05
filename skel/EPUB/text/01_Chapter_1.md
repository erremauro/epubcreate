## Capter 1 – How to Format Your Book

Since the `h1` ("#" in markdown) tag is generally used for the Main Title of the book, begin each chapter using the `h2` ("##") tag.

Images in the `media` directory must be specified from the root directory path. For example:

![My Cover](./src/media/cover.png)

### Markdown Syntax

Check this [Markdown Guide][1] for a review of the syntax you can use to format your book.

### Layouts

Here's a list of custom helper formatting layout that might come in handy:

```html
<div class="centered no-indent pagebreak"></div>
```

* `.centered`: center the text
* `.no-indent`: removes the paragraph indentation
* `.pagebreak`: add a pagebreak *after* the element


[1]: https://www.markdownguide.org/ "Markdown Guide"
