class Item

  constructor: (data) ->

    {
      change = []
      direction = 0
      has = []
      id
      name
      status = []
      x, y
    } = data

    # validate

    # id
    unless id
      throw new Error 'invalid id'

    # name
    unless name
      throw new Error 'invalid name'

    # position
    [width, height] = app.cache.get 'size-world'
    unless 0 <= x < width and 0 <= y < height
      throw new Error "invalid position '#{x}, #{y}'"

    # direction
    unless 0 <= direction <= 3
      throw new Error "invalid direction '#{direction}'"

    # change
    unless 'array' == $.type change
      throw new Error "invalid change '#{change}'"

    # status
    unless 'array' == $.type status
      throw new Error "invalid status '#{status}'"

    # generate dom
    ($el = $ '<div>')
    .data {id}
    .appendTo app.dom '#world'

    # set data
    @data = {
      $el
      change
      direction
      has
      id
      name
      status
      x, y
    }

  ###
  addChange(name)
  addHas(listName)
  addStatus(listName)
  change()
  destroy(reason)
  get(key)
  hasStatus(name)
  isFirst()
  isSecond()
  isText()
  isZero()
  move(direction)
  render()
  set(data)
  ###

  addChange: (name) ->
    {change} = @get()
    change.push name
    change = _.uniq change
    @set {change}
    @ # return

  addHas: (listName) ->
    
    unless 'array' == $.type listName
      listName = [listName]
    
    {has} = @get()
    has = _.uniq [has..., listName...]
    @set {has}
    
    @ #return

  addStatus: (listName) ->
    
    unless 'array' == $.type listName
      listName = [listName]
    
    {status} = @get()
    status = _.uniq [status..., listName...]
    @set {status}
    
    @ #return

  change: ->

    {name, change} = @get()

    unless change.length
      return @
    if name in change
      return @set change: []

    {x, y, direction} = @get()

    @destroy 'change'

    # create
    for name in _.uniq change
      app.fn.addItem {
        direction
        name
        x, y
      }

    @ # return

  destroy: (reason) ->

    unless reason
      throw new Error "invalid reason '#{reason}'"

    {
      $el
      direction
      has
      id
      x, y
    } = @get()
    
    $el.remove()
    
    # using id then whole item on _.remove()
    # is much faster
    _.remove app.memory, (item) ->
      id == item.get 'id'

    # has
    unless reason in ['change', 'edit']
      for name in _.uniq has
        app.fn.addItem {
          direction
          name
          x, y
        }
    
    @ # return

  get: (key) ->
    unless key
      return @data
    @data[key]

  hasStatus: (name) ->
    {status} = @get()
    name in status

  isFirst: ->
    unless @isText()
      return false
    {name} = @get()
    name.toLowerCase() in app.dictionary.get 'first'

  isSecond: (id) ->
    unless @isText()
      return false
    {name} = @get()
    name.toLowerCase() in app.dictionary.get 'second'

  isText: ->
    {name} = @get()
    name != name.toLowerCase()

  isZero: ->
    unless @isText()
      return false
    {name} = @get()
    name.toLowerCase() in app.dictionary.get 'zero'

  move: (direction) ->
    
    # change direction
    listDirection = app.dictionary.get 'direction'
    index = _.indexOf listDirection, direction
    @set direction: index

    listItem = app.select.line @, direction
    for item in listItem

      {x, y} = item.get()

      switch direction
        when 'left' then x -= 1
        when 'right' then x += 1
        when 'up' then y -= 1
        when 'down' then y += 1

      item.set {x, y}
    
    @ # return

  render: ->

    {
      $el
      cache
      direction
      name
      status
      x, y
    } = @get()

    # diff
    stringState = $.parseString {
      direction
      name
      status
      x, y
    }
    if stringState == cache
      return @
    @set cache: stringState

    # render

    listClass = ['item']
    listClass.push "item-#{name}"

    listDirection = app.dictionary.get 'direction'
    listClass.push "direction-#{listDirection[direction]}"

    for key in status
      listClass.push "status-#{key}"

    size = app.cache.get 'size-unit'
    transform = "translate(#{x * size}px, #{y * size}px)"
    $el.attr
      class: _.uniq(listClass).join ' '
    .css {transform}
    
    @ # return

  set: (data) ->
    # important: _.assign(), not _.merge()
    _.assign @get(), data
    @ # return