class Checker

  ###
  defeat()
  hot()
  isDefeated()
  isDone()
  sink()
  ###

  defeat: ->
    listItem = app.select.status 'you'
    for item in listItem
      {x, y} = item.get()
      isFloat = item.hasStatus 'float'
      listIt = app.select.position x, y
      for it in listIt
        if it.hasStatus 'defeat'
          if isFloat == it.hasStatus 'float'
            item.destroy 'defeat'
    @ # return

  hot: ->
    listItem = app.select.status 'melt'
    for item in listItem
      {x, y} = item.get()
      isFloat = item.hasStatus 'float'
      listIt = app.select.position x, y
      for it in listIt
        if it.hasStatus 'hot'
          if isFloat == it.hasStatus 'float'
            item.destroy 'melt'
    @ # return

  isDefeated: ->
    listItem = app.select.status 'you'
    unless listItem.length
      return true
    false

  isDone: ->
    listItem = app.select.status 'you'
    for item in listItem
      {x, y} = item.get()
      listIt = app.select.position x, y
      for it in listIt
        if it.hasStatus 'win'
          return true
    false

  sink: ->
    listItem = app.select.status 'sink'
    for item in listItem
      {x, y} = item.get()
      listIt = app.select.position x, y
      _.remove listIt, item
      for it in listIt
        if it.hasStatus 'float'
          continue
        item.destroy 'sink'
        it.destroy 'sink'
    @ # return