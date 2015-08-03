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

# for ctrl-l indicator
indicator = "top"

# for toggle pane item previous index
# [paneIdx, itemIdx]
togglePaneItemCurrentIdx = [0,0]
togglePaneItemPrevIdx = [0,0]

atom.commands.add 'body',
  # to use ctrl-x 1
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

  # to use ctrl-l
  'user:move-cursor': (event) ->
    t = atom.workspace.getActiveTextEditor()
    cursorRows = []
    for c in t.cursors
      cursorRows.push(c.getScreenRow())
    switch indicator
      when "top"
        t.scrollToTop()
        t.scrollToScreenPosition([cursorRows[0], 0], {center: false})
        indicator = 0
      when "bottom"
        t.scrollToBottom()
        t.scrollToScreenPosition([cursorRows[cursorRows.length - 1], 0], {center: false})
        indicator = "top"
      else
        t.scrollToTop()
        t.scrollToScreenPosition([cursorRows[indicator], 0], {center: true})
        if cursorRows.length == indicator + 1
          indicator = "bottom"
        else
          indicator += 1
  # to use toggle pane item
  'user:toggle-pane-item': (event) ->
    prevPaneIdx = togglePaneItemPrevIdx[0]
    prevItemIdx = togglePaneItemPrevIdx[1]
    prevPane = atom.workspace.getPanes()[prevPaneIdx]
    prevPane.activate()
    prevPane.activateItemAtIndex(prevItemIdx)

atom.workspace.onDidChangeActivePaneItem ->
  activePane =  atom.workspace.getActivePane()
  activePaneIdx = atom.workspace.getPanes().indexOf(activePane)
  activeItemIdx = atom.workspace.getActivePane().getActiveItemIndex()

  unless togglePaneItemCurrentIdx[0] == activePaneIdx and togglePaneItemCurrentIdx[1] == activeItemIdx
    togglePaneItemPrevIdx = togglePaneItemCurrentIdx
    togglePaneItemCurrentIdx = [activePaneIdx, activeItemIdx]

# to use ctrl-k
atom.keymaps.keyBindings = atom.keymaps.keyBindings.filter (keyBinding) ->
  keyBinding.command.indexOf("term2:") != 0
