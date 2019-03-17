class Fn

  ###
  addItem(data)
  check(key)
  edit()
  execute()
  generateId()
  getNameFromList(listItem)
  resize()
  ###

  addItem: (data) ->

    {
      direction
      name
      x, y
    } = data

    id = @generateId()

    app.memory.push new Item {
      direction
      id
      name
      x, y
    }

    @ # return

  check: (key) ->

    switch key

      when 'change'

        app.check.defeat()
        app.check.hot()
        app.check.sink()

      when 'status'

        if app.check.isDefeated()
          $.info 'You are defeated.'
        if app.check.isDone()
          $.info 'Well done.'
          app.level.index++
          app.level.next()

      else throw new Error "invalid step '#{key}'"
        
    @ # return

  edit: ->
    (app.editor = new Editor()).init()
    @ # return

  execute: ->
    ts = $.now()

    app.fn.check 'change'

    # rule
    app.rule
    .prepare()
    .collect()
    .execute()

    # render all items
    for item in app.memory
      item.render()

    app.fn.check 'status'

    if (time = $.now() - ts) >= 5
      $.info "Slow: #{time} ms."
    @ # return

  generateId: ->
    # Math.random().toString(36).substr 2, 8
    n = app.cache.get 'index-item'
    app.cache.set 'index-item', n = (n or 0) + 1
    n # return

  getNameFromList: (listItem) ->
    (item.get().name for item in listItem).join ', '

  resize: ->
    $root = $ window
    $stage = $ '#stage'
    width = $root.width()
    height = $root.height()
    $stage.css {width, height}
    @ # return