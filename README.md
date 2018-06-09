---
title: Pandoc Markdown Settings
author: John D. Fisher
email: jdfenw@gmail.com
---
# Pandoc Markdown Settings

## Pandoc HTML5 Template

[Pandoc Wiki User Contributed Templates] lists two `HTML5` templates:

* [gh-themes-magick] is intended for converting a README.md file.
* [GitHub Pandoc HTML5 Template] provides a general purpose template but the
  code blocks have poor contrast with the available syntax highlighting. The embedded style-sheet is awkward to work with.

So we'll start with pandoc's default.html5 template and merge features from [GitHub Pandoc HTML5 Template] without the style sheet. An external style sheet from [gist killercup 5917178] provides a nice design and allows easy modification of the appearance of code-blocks. [Displaying code in a web page] and [Posting Code Blocks on a WordPress Site] provide insight into css styling.

Obtain pandoc's default HTML5 template and killercup's pandoc.css:

```{contenteditable="true" spellcheck="false" caption="bash" .bash}
# Extract pandoc default HTML5 template.
pandoc --print-default-template=html5 > default.html5

# Get killercup's pandoc.css
cd $TMP
git clone https://gist.github.com/5917178.git
cd -
cp $TMP/5917178/pandoc.css .
rm -rf $TMP/5917178
```

### GitHub Pandoc HTML5 Template

After some experimenting, the espresso theme has the best contrast.

```{caption="viml" .bash}
:Pandoc --to=html5 --css=pandoc.css --highlight-style=breezedark --toc --template=default.html5
```

The theme may be saved.

```{caption="bash" .bash}
pandoc --print-highlight-style=espresso > myespresso.theme
```

Pandoc generates the file using Unix EOL, but Windows requires Windows EOL
when reading the file, so convert the line endings accordingly. Reference the `.theme` file with a path, if it's not in the current directory.


```{caption="bash" .bash}
pandoc --standalone --to=html5 --highlight-style=myespresso.theme
```

```{caption="PowerShell" .powershell}
Get-ChildItem $PROFILE
```

## Caption Code Blocks

Pandoc uses `{...}` to add attributes to code blocks. This is useful for enabling editable content and providing a caption for css to style. Note that abbreviations like `contenteditable` does work, use `contenteditable="true"`.

```{contenteditable="true" spellcheck="false" caption="markdown" .markdown}
Compare the normal format:

    ```bash
       Your code here
    ```

to the meta-data version:

    ```{contenteditable="true" spellcheck="false" caption="bash" .bash}
       Your code here
    ```
```

<!--
## References
-->

[Pandoc Wiki User Contributed Templates]: https://github.com/jgm/pandoc/wiki/User-contributed-templates
[gh-themes-magick]: https://github.com/tajmone/gh-themes-magick
[GitHub Pandoc HTML5 Template]: https://github.com/tajmone/pandoc-goodies/tree/master/templates/html5/github
[Listing Captions With Delimited Code Blocks and Pandoc]: https://www.kartar.net/2012/12/listing-captions-with-delimited-code-blocks-and-pandoc/
[gist killercup 5917178]: https://gist.github.com/killercup/5917178
[Displaying code in a web page]: https://websemantics.uk/articles/displaying-code-in-web-pages/
[Posting Code Blocks on a WordPress Site]: https://css-tricks.com/posting-code-blocks-wordpress-site/
