class Controller

  ###
  map

  bind()
  init()
  send(key)
  ###

  map:
    cancel: [
      27 # esc
      8 # backspace
      81 # q
    ]
    confirm: [
      13 # enter
      32 # space
      69 # e
    ]
    down: [
      40 # down arrow
      83 # s
    ]
    left: [
      37 # left arrow
      65 # a
    ]
    reset: [
      82 # r
    ]
    right: [
      39 # right arrow
      68 # d
    ]
    undo: [
      90 # z
    ]
    up: [
      38 # up arrow
      87 # w
    ]

  bind: ->

    @$ipt.on 'keydown', (e) =>

      if e.altKey
        return
      if e.ctrlKey
        return
      if e.metaKey
        return
      if e.shiftKey
        return

      for key in _.keys @map
        unless e.which in @map[key]
          continue
        @send key

      @$ipt.val ''

    @ # return

  init: ->
    
    # input
    @$ipt = $ '#ipt-controller'
    unless @$ipt.length
      throw new Error 'invalid element'

    @$ipt.on 'blur', =>
      @$ipt.focus()
    .focus()

    # opt
    @$opt = $ '#stage'
    unless @$opt.length
      throw new Error 'invalid element'

    # bind()
    @bind()

    @ # return

  send: _.throttle (key) ->
    @$opt.triggerHandler key
    @ # return
  , 200, trailing: false