class Rule

  ###
  addByHas(item)
  addByIs(item)
  collect()
  display()
  execute()
  executeChange()
  executeHas()
  executeStatus()
  getAdjoining(item, direction, listType)
  prepare()
  ###

  addByHas: (item) ->

    for direction in [
      ['left', 'right']
      ['up', 'down']
    ]

      listPrev = @getAdjoining item, direction[0], 'first'
      unless listPrev.length
        continue
      
      listNext = @getAdjoining item, direction[1], 'first'
      unless listNext.length
        continue

      item.addStatus 'active'
      for it in listPrev
        namePrev = it.get 'name'
        it.addStatus 'active'

        for it2 in listNext
          nameNext = it2.get 'name'
          it2.addStatus 'active'

          @has.push [namePrev, nameNext]

    @ # return

  addByIs: (item) ->

    for direction in [
      ['left', 'right']
      ['up', 'down']
    ]

      listPrev = @getAdjoining item, direction[0], 'first'
      unless listPrev.length
        continue
      
      listNext = @getAdjoining item, direction[1], ['first', 'second']
      unless listNext.length
        continue

      item.addStatus 'active'
      for it in listPrev
        namePrev = it.get 'name'
        it.addStatus 'active'

        for it2 in listNext
          nameNext = it2.get 'name'
          it2.addStatus 'active'

          if it2.isFirst()
            @change.push [namePrev, nameNext]
            continue

          if it2.isSecond()
            @status.push [namePrev, nameNext]
            continue

          throw new Error "invalid rule '#{namePrev} Is #{nameNext}'"

    @ # return

  collect: ->
    
    for item in app.select.name 'Is'
      @addByIs item
    for item in app.select.name 'Has'
      @addByHas item

    @ # return

  display: ->
    list = []
    for rule in @change
      [prev, next] = rule
      list.push "#{prev} Is #{next}"
    for rule in @status
      [prev, next] = rule
      list.push "#{prev} Is #{next}"
    for rule in @has
      [prev, next] = rule
      list.push "#{prev} Has #{next}"
    list.sort()
    $.i list.join '\n'
    @ # return

  execute: (listRule) ->

    # extra
    for item in app.memory

      # add push to Text
      if item.isText()
        item.addStatus ['push', 'text']

    @executeChange()
    @executeHas()
    @executeStatus()

    @ # return

  executeChange: ->

    for rule in @change

      [prev, next] = rule
      prev = prev.toLowerCase()
      next = next.toLowerCase()
      
      listItem = if prev == 'text'
        app.select.status 'text'
      else app.select.name prev
      
      for item in listItem
        item.addChange next
    
    # use a clone array
    # because item.change() may delete item(s) of the list
    for item in _.clone app.memory
      item.change()

    @ # return

  executeHas: ->

    for rule in @has

      [prev, next] = rule
      prev = prev.toLowerCase()
      next = next.toLowerCase()
      
      listItem = if prev == 'text'
        app.select.status 'text'
      else app.select.name prev
      
      for item in listItem
        item.addHas next

    @ # return

  executeStatus: ->

    for rule in @status

      [prev, next] = rule
      prev = prev.toLowerCase()
      next = next.toLowerCase()

      listItem = if prev == 'text'
        app.select.status 'text'
      else app.select.name prev

      for item in listItem
        item.addStatus next

    @ # return

  getAdjoining: (item, direction, listType) ->

    unless 'array' == $.type listType
      listType = [listType]

    listRes = []

    listItem = app.select.nearby item, direction

    unless listType.length
      return listItem

    for type in listType
      
      unless type in ['first', 'second', 'zero']
        throw new Error "invalid type '#{type}'"

      listRes = [
        listRes...
        (app.filter[type] listItem)...
      ]

    # return
    listRes

  prepare: ->

    # clear all items
    for item in app.memory
      item.set status: []

    # clear list
    @change = []
    @has = []
    @status = []

    @ # return