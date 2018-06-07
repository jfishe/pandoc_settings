# Pandoc Markdown Settings

## Pandoc HTML5 Template

[Pandoc Wiki User Contributed Templates] lists two `HTML5` templates:

* [gh-themes-magick] is intended for converting a README.md file.
* [GitHub Pandoc HTML5 Template] provides a general purpose template but the
  code blocks have poor contrast with the available syntax highlighting.

### GitHub Pandoc HTML5 Template

After some experimenting, the espresso theme has the best contrast.

```{caption="bash" .bash}
pandoc --standalone --to=html5 --highlight-style=espresso
```

The theme may be saved.

```{caption="bash" .bash}
pandoc --print-highlight-style=espresso > myespresso.theme
```

Pandoc generates the file using Unix EOL but on Windows requires Windows EOL
when reading the file, so convert the line endings accordingly. Reference the `.theme` file with a path, if it's not in the current directory.

```{caption="bash" .bash}
pandoc --standalone --to=html5 --highlight-style=myespresso.theme
```

```{caption="PowerShell" .powershell}
Get-ChildItem $PROFILE
```

## References

[Pandoc Wiki User Contributed Templates]: https://github.com/jgm/pandoc/wiki/User-contributed-templates
[gh-themes-magick]: https://github.com/tajmone/gh-themes-magick
[GitHub Pandoc HTML5 Template]: https://github.com/tajmone/pandoc-goodies/tree/master/templates/html5/github
