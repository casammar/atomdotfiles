path = require 'path'

oldWindowDimensions = {}

# Reload Functions Script Everytime
Object.defineProperty global, 'functions', get: ->
  delete require.cache[require.resolve('./functions')]
  require('./functions')

atom.workspace.observeTextEditors (editor) ->
  editor.onDidSave ->
    functions.onSave(editor)

atom.commands.add 'atom-workspace',
  'custom:wrap-with-strong': ->
    editor = atom.workspace.getActiveTextEditor()
    for selection in editor.getSelections()
      textToWrap = selection.getText()
      selection.insertText("<strong>#{textToWrap}</strong>")

  'custom:insert-numbers': ->
    editor = atom.workspace.getActiveTextEditor()
    count = 0
    for selection in editor.getSelections()
      count += 1
      selection.insertText("#{count}")

  'custom:insert-timestamp': ->
    now = new Date()
    atom.workspace.getActiveTextEditor().insertText(now.toISOString())

  'custom:open-todo-list': ->
    todoList = path.join(process.env.HOME, 'Dropbox/todo/todo.txt')
    atom.workspace.open(todoList)

  'custom:screenshot-prep': ->
    oldWindowDimensions = atom.getWindowDimensions()
    atom.setWindowDimensions('width': 1366, 'height': 768)

  'custom:screenshot-restore': ->
    atom.setWindowDimensions(oldWindowDimensions)

  'custom:throw-error': ->
    throw new Error
