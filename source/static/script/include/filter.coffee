class Filter

  ###
  first(listItem)
  second(listItem)
  status(listItem, name)
  text(listItem)
  zero(listItem)
  ###

  first: (listItem) ->
    listRes = []
    for item in listItem
      {name} = item.get()
      nameLow = name.toLowerCase()
      if name == nameLow
        continue
      unless nameLow in app.dictionary.get 'first'
        continue
      listRes.push item
    listRes # return

  second: (listItem) ->
    listRes = []
    for item in listItem
      {name} = item.get()
      nameLow = name.toLowerCase()
      if name == nameLow
        continue
      unless nameLow in app.dictionary.get 'second'
        continue
      listRes.push item
    listRes # return

  status: (listItem, name) ->
    listRes = []
    for item in listItem
      {status} = item.get()
      unless name in status
        continue
      listRes.push item
    listRes # return

  text: (listItem) ->
    listRes = []
    for item in listItem
      {name} = item.get()
      if name == name.toLowerCase()
        continue
      listRes.push item
    listRes # return

  zero: (listItem) ->
    listRes = []
    for item in listItem
      {name} = item.get()
      nameLow = name.toLowerCase()
      if name == nameLow
        continue
      unless nameLow in app.dictionary.get 'zero'
        continue
      listRes.push item
    listRes # return