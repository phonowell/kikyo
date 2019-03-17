class Level

  ###
  act(key)
  bindController()
  init(string)
  next()
  render()
  reset()
  ###

  act: (key) ->

    # wait
    if key == 'confirm'
      app.fn.execute()
      return @

    # reset
    if key == 'reset'
      return @reset()

    # move
    if key in app.dictionary.get 'direction'
      for item in app.select.status 'you'
        item.move key
      app.fn.execute()
      return @

    # undo
    if key == 'undo'
      $.info 'Not ready yet.'
      return @

    @ # return

  bindController: ->

    stringEvent = (app.dictionary.get 'event').join ' '

    $ '#stage'
    .off stringEvent
    .on stringEvent, (e) =>
      @act e.type

    @ # return

  next: ->
    @index or= 0

    if @index >= app.data.length
      @index = 0

    @init app.data[@index]
    @ # return

  init: (string = localStorage.getItem 'level') ->
    
    localStorage.setItem 'level', @source = string
    @reset()

    # message
    $.info 'Press WASD to move.'
    # $.info 'Press E to wait.'
    $.info 'Press Z to undo.'
    $.info 'Press R to reset.'

    @ # return

  render: ->
    
    # size
    [width, height] = @data.size
    size = app.cache.get 'size-unit'
    width *= size
    height *= size
    @$el.css {width, height}

    # init item
    for item in @data.item
      app.fn.addItem item

    @ # return

  reset: ->

    # memory
    app.memory = []

    # import data
    @data = app.editor.import @source

    # cache
    app.cache.set 'size-world', @data.size

    # element
    selector = '#world'
    @$el = $ selector
    unless @$el.length
      throw new Error "invalid element '#{selector}'"

    # controller
    @bindController()
    
    {title, background} = @data

    # title
    document.title = title

    # background
    unless background == 'transparent'
      @$el.css {background}

    # item
    @$el.empty()

    # render & execute
    @render()
    app.fn.execute()

    @ # return