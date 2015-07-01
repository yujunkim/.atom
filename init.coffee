# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

atom.commands.add 'body',
  'user:alone-pane': (event) ->
    panes = atom.workspace.getPanes()
    activePane = atom.workspace.getActivePane()
    activePanePaths = new Set
    for i in activePane.items
      activePanePaths.add(i.getPath())

    for p in atom.workspace.getPanes()
      if p != activePane
        haveToMove = []
        for i in p.items
          if i and i.getPath and not activePanePaths.has(i.getPath())
            activePanePaths.add(i.getPath())
            haveToMove.push(i)
        for i in haveToMove
          p.moveItemToPane(i, activePane)
        p.destroy()

atom.keymaps.keyBindings = atom.keymaps.keyBindings.filter (keyBinding) ->
  keyBinding.command.indexOf("term2:") != 0
