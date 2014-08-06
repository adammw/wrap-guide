{$, View} = require 'atom'

module.exports =
class WrapGuideView extends View
  @activate: ->
    atom.workspaceView.eachEditorView (editorView) ->
      if editorView.attached and editorView.getPane()
        editorView.underlayer.append(new WrapGuideView(editorView))

  @content: ->
    @div class: 'wrap-guide-container'

  initialize: (@editorView) ->
    @subscribe atom.config.observe 'editor.fontSize', callNow: false, => @updateGuide()
    @subscribe atom.config.observe 'editor.preferredLineLength', callNow: false, => @updateGuide()
    @subscribe atom.config.observe 'wrap-guide.columns', callNow: false, => @updateGuide()
    @subscribe @editorView, 'editor:path-changed', => @updateGuide()
    @subscribe @editorView, 'editor:min-width-changed', => @updateGuide()
    @subscribe @editorView.getEditor(), 'grammar-changed', => @updateGuide()
    @subscribe $(window), 'resize', => @updateGuide()

    @updateGuide()

  getDefaultColumn: ->
    atom.config.getPositiveInt('editor.preferredLineLength', 80)

  getGuideColumns: (path, scopeName) ->
    customColumns = atom.config.get('wrap-guide.columns')
    parseColumns = ->
      isNumeric = true
      for customColumn in customColumns
        if typeof customColumn isnt 'number'
          isNumeric = false
        if typeof customColumn is 'object'
          {pattern, scope, column, columns} = customColumn
          if pattern
            try
              regex = new RegExp(pattern)
            catch
              continue
            if regex.test(path)
              return if Array.isArray(columns) then columns else column
          else if scope
            if scope is scopeName
              return if Array.isArray(columns) then columns else column
          else
            return if Array.isArray(columns) then columns else column
      if isNumeric
        return customColumns
    columns = (parseColumns() if Array.isArray(customColumns)) || [ @getDefaultColumn() ]
    parseInt(column) for column in columns

  updateGuide: ->
    editor = @editorView.getEditor()
    columns = @getGuideColumns(editor.getPath(), editor.getGrammar().scopeName)
    charWidth = @editorView.charWidth
    negativeColumns = false
    html = columns.map (column) ->
      if column > 0
        columnWidth = charWidth * column
        "<div class=\"wrap-guide\" style=\"left: #{columnWidth}px\"></div>"
      else
        negativeColumns = true
    if negativeColumns
      @empty()
    else
      @html(html.join(''))
