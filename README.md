---
title: README.md
subtitle: Pandoc Markdown Settings
author: John D. Fisher
documentclass: scrartcl
classoption:
  - |
       DIV=classic
---

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

Pandoc v3.9.0.2 produced the current templates.

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

<!-- markdownlint-disable MD048 -->
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
<!-- markdownlint-enable MD048 -->

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

### pandoc.html5 and pandoc.tex

`templates/pandoc.html5` and `templates/pandoc.tex` are based on pandoc's
default HTML5 and LaTeX templates. Pandoc is Copyright © 2006-2024 John
MacFarlane and, except where otherwise noted, is released under the GNU General
Public License, version 2 or later (GPL-2.0-or-later).

* <https://github.com/jgm/pandoc>
* <https://pandoc.org/>

### Citation Style Language (CSL)

`csl/ieee.csl` is the IEEE citation style from the Zotero Style Repository,
by Michael Berkowitz and contributors. It is licensed under the Creative
Commons Attribution-ShareAlike 3.0 Unported License (CC BY-SA 3.0):

* <https://www.zotero.org/styles/ieee>
* <https://creativecommons.org/licenses/by-sa/3.0/>

## References

[Pandoc Wiki User Contributed Templates]: https://github.com/jgm/pandoc/wiki/User-contributed-templates
[gh-themes-magick]: https://github.com/tajmone/gh-themes-magick
[GitHub Pandoc HTML5 Template]: https://github.com/tajmone/pandoc-goodies/tree/master/templates/html5/github
[gist killercup 5917178]: https://gist.github.com/killercup/5917178
[Displaying code in a web page]: https://websemantics.uk/articles/displaying-code-in-web-pages/
[Posting Code Blocks on a WordPress Site]: https://css-tricks.com/posting-code-blocks-wordpress-site/
