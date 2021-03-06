## Wrap Guide

The `wrap-guide` extension places a vertical line in each editor at a certain
column to guide your formatting, so lines do not exceed a certain width.

By default, the wrap-guide is placed at the value of `editor.preferredLineLength`
config setting. The 80th column is used as the fallback if the config value is
unset.

### Configuration

You can customize where the column is placed using the following config option:

```coffeescript
'wrap-guide':
  columns: [
    { pattern: '\.mm$', column: 200 }
    { pattern: '\.cc$', column: 120 }
    { scope: 'source.gfm', column: -1 }
  ]
```

The above config example would place the guide at the 200th column for paths
that end with `.mm`, place the guide at the 120th column for paths that end
with `.cc` and hide the guide for files that use the GitHub-Flavored Markdown
grammar.

You can configure the color and/or width of the line by adding the following
CSS/LESS to a custom stylesheet:

```css
.wrap-guide {
  width: 10px;
  background-color: red;
}
```
