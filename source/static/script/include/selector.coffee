class Selector

  ###
  change(name)
  id(id)
  line(item, direction)
  name(name)
  nearby(item, direction)
  position(x, y)
  status(name)
  ###

  change: (name) ->
    listRes = []
    for item in app.memory
      unless name in item.get 'change'
        continue
      listRes.push item
    _.uniq listRes # return

  id: (id) ->
    _.find app.memory, (item) ->
      id == item.get 'id'

  line: (item, direction) ->
    listRes = [item]

    [width, height] = app.cache.get 'size-world'

    fnOut = (x, y) ->
      
      if direction == 'left'
        if x <= 0
          return true
        return false

      if direction == 'right'
        if x >= width - 1
          return true
        return false

      if direction == 'up'
        if y <= 0
          return true
        return false

      if direction == 'down'
        if y >= height - 1
          return true
        return false

    do fnLoop = =>

      itemLast = _.last listRes
    
      listItem = @nearby itemLast, direction
      _.remove listItem, (it) ->
        !(it.hasStatus 'push') and !(it.hasStatus 'stop')
      unless listItem.length
        {x, y} = itemLast.get()
        if fnOut x, y
          listRes = []
        return

      for it in listItem

        if it.hasStatus 'stop'
          listRes = []
          return

        unless it.hasStatus 'push'
          return
        
        listRes.push it

      fnLoop()

    listRes # return

  name: (name) ->
    listRes = []
    for item in app.memory
      unless name == item.get 'name'
        continue
      listRes.push item
    _.uniq listRes # return

  nearby: (item, direction) ->
    {x, y} = item.get()
    switch direction
      when 'left' then x--
      when 'right' then x++
      when 'up' then y--
      when 'down' then y++
      else throw new Error "invalid direction '#{direction}'"
    @position x, y # return

  position: (x, y) ->
    listRes = []
    for item in app.memory
      unless x == item.get().x and y == item.get().y
        continue
      listRes.push item
    _.uniq listRes # return

  status: (name) ->
    listRes = []
    for item in app.memory
      unless name in item.get 'status'
        continue
      listRes.push item
    _.uniq listRes # return