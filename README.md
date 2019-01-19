---
title: README.md
subtitle: Pandoc Markdown Settings
author: John D. Fisher
documentclass: scrartcl
classoption:
  - |
       DIV=classic
---

# Pandoc Markdown Settings

## Pandoc HTML5 Template

[Pandoc Wiki User Contributed Templates] lists two `HTML5` templates:

* [gh-themes-magick] is intended for converting a README.md file.
* [GitHub Pandoc HTML5 Template] provides a general purpose template but the
  code blocks have poor contrast with the available syntax highlighting. The
  embedded style-sheet is awkward to work with.

So we'll start with pandoc's default.html5 template and merge features from
[GitHub Pandoc HTML5 Template] without the style sheet. An external style sheet
from [gist killercup 5917178] provides a nice design and allows easy
modification of the appearance of code-blocks. [Displaying code in a web page]
and [Posting Code Blocks on a WordPress Site] provide insight into css styling.

Obtain pandoc's default HTML5 template and killercup's pandoc.css:

```{contenteditable="true" spellcheck="false" caption="bash" .bash}
# Extract pandoc default HTML5 template.
pandoc --print-default-template=html5 > pandoc.html5

# Get killercup's pandoc.css
git clone https://gist.github.com/5917178.git $TMP/5917178
cp $TMP/5917178/pandoc.css .
rm -rf $TMP/5917178
```

### GitHub Pandoc HTML5 Template

After some experimenting, the `breezedark` theme has the best contrast.

```{contenteditable="true" spellcheck="false" caption="bash" .bash}
pandoc --to=html5 --css=templates/pandoc.css --highlight-style=breezedark \
  --toc --template=templates/pandoc.html5 --data-dir=.
  README.md --output=README.html
```

The theme may be saved.

```{contenteditable="true" spellcheck="false" caption="bash" .bash}
pandoc --print-highlight-style=breezedark > mybreezedark.theme
```

Pandoc generates the file using Unix EOL, but Windows requires Windows EOL
when reading the file, so convert the line endings accordingly. Reference the
`.theme` file with a path, if it's not in the current directory.

```{contenteditable="true" spellcheck="false" caption="bash" .bash}
pandoc --standalone --to=html5 --highlight-style=mybreezedark.theme
```

```{contenteditable="true" spellcheck="false" caption="PowerShell" .powershell}
Get-ChildItem $PROFILE
```

## Caption Code Blocks

Pandoc uses `{...}` to add attributes to code blocks. This is useful for
enabling editable content and providing a caption for css to style. Note that
abbreviations like `contenteditable` do work, use `contenteditable="true"`.

~~~{contenteditable="true" spellcheck="false" caption="markdown" .markdown}
Compare the normal format:

    ```bash
       Your code here
    ```

to the meta-data version:

    ```{contenteditable="true" spellcheck="false" caption="bash" .bash}
       Your code here
    ```
~~~

## Links and References

Inline references may be used when writing. `Pandoc` can
convert them to reference links and list them at the end of
the document. Include `--standalone` to preserve `YAML`
metadata.

```{contenteditable="true" spellcheck="false" caption="bash" .bash}
pandoc --standalone --reference-links --reference-location=document \
  --atx-headers --from=markdown --to=markdown README.md --output README1.md
```

## View HTML with Local HTTP Server

``` {contenteditable="true" spellcheck="false" caption="bash" .bash}
(python -m http.server --bind localhost &) &&
  "$BROWSER" http://localhost:8000/README.html
```

## Third Party Notices

### pandoc.html5

"GitHub HTML5 Pandoc Template" v2.2 — by John D. Fisher  
Copyright © John D. Fisher, 2018, MIT License (MIT).

The CSS from the original template has been removed to support using a modified
version of <https://gist.github.com/killercup/5917178>.

"GitHub HTML5 Pandoc Template" v2.1 — by Tristano Ajmone  
Copyright © Tristano Ajmone, 2017, MIT License (MIT). Project's home:

* <https://github.com/tajmone/pandoc-goodies>

The CSS in this template reuses source code taken from the following projects:

* GitHub Markdown CSS: Copyright © Sindre Sorhus, MIT License (MIT):
  <https://github.com/sindresorhus/github-markdown-css>

* Primer CSS: Copyright © 2016-2017 GitHub Inc., MIT License (MIT):
  <http://primercss.io/>

## References

[Pandoc Wiki User Contributed Templates]: https://github.com/jgm/pandoc/wiki/User-contributed-templates
[gh-themes-magick]: https://github.com/tajmone/gh-themes-magick
[GitHub Pandoc HTML5 Template]: https://github.com/tajmone/pandoc-goodies/tree/master/templates/html5/github
[Listing Captions With Delimited Code Blocks and Pandoc]: https://www.kartar.net/2012/12/listing-captions-with-delimited-code-blocks-and-pandoc/
[gist killercup 5917178]: https://gist.github.com/killercup/5917178
[Displaying code in a web page]: https://websemantics.uk/articles/displaying-code-in-web-pages/
[Posting Code Blocks on a WordPress Site]: https://css-tricks.com/posting-code-blocks-wordpress-site/
