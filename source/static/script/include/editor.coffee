class Editor

  ###
  bind()
  export()
  import(string)
  unbind()
  ###

  bind: ->

    nameLast = ''

    $world = app.dom '#world'

    # edit world
    $world.on 'contextmenu.edit', (e) ->

      e.preventDefault()
      e.stopPropagation()

      unless confirm 'Editor will empty all items, continue?'
        return

      {title, size, background} = app.level.data
      title = prompt 'Input title.', title
      unless title.length
        return $.info "Invalid title '#{title}'."

      [width, height] = size
      width = prompt 'Input width.', width
      unless width > 0
        return $.info "Invalid width '#{width}'."
      height = prompt 'Input height.', height
      unless height > 0
        return $.info "Invalid height '#{height}'."
      size = [width, height]

      background = prompt 'Input background.', background
      unless background.length
        return $.info "Invalid background '#{background}'."

      # set
      _.assign app.level.data, {title, size, background}

      # remove all item
      app.memory = []
      
      string = app.editor.export()
      app.level.init string

    # add
    $world.on 'click.edit', (e) ->

      e.preventDefault()
      e.stopPropagation()

      size = app.cache.get 'size-unit'
      x = e.offsetX // size
      y = e.offsetY // size

      name = prompt "Input item's name.", nameLast
      isValid = do ->
        unless name
          return false
        nameLow = name.toLowerCase()
        if nameLow in app.dictionary.get 'zero'
          return true
        if nameLow in app.dictionary.get 'first'
          return true
        if nameLow in app.dictionary.get 'second'
          return true
        false
      unless isValid
        return $.info "Invalid name '#{name}'."

      nameLast = name

      direction = 0

      app.fn.addItem {
        direction
        name
        x, y
      }

      item = _.last app.memory
      item.render()

    # edit
    $world.on 'contextmenu.edit', '.item', (e) ->

      e.preventDefault()
      e.stopPropagation()

      {id} = $(@).data()
      item = app.select.id id

      {direction} = item.get()

      direction = prompt "Input item's direction.", direction
      unless 0 <= direction <= 3
        return $.info "Invalid direction '#{direction}'."

      item
      .set {direction}
      .render()

    # remove
    $world.on 'click.edit', '.item', (e) ->
      
      e.preventDefault()
      e.stopPropagation()

      {id} = $(@).data()
      item = app.select.id id
      item.destroy 'edit'

    # message
    $.info 'Edit mode on.'
    $.info 'Right click empty to edit level.'
    $.info 'Click empty to add an item.'
    $.info 'Click an item to remove it.'
    $.info 'Right click an item to edit it.'
    
    @ # return

  export: ->

    listResult = []

    # title, size, background
    {title, size, background} = app.level.data
    listResult.push "Title #{title}"
    listResult.push "Size #{size.join 'x'}"
    listResult.push "Background #{background}"

    # item
    
    listName = []
    for item in app.memory
      {name} = item.get()
      listName.push name
    listName = _.uniq listName.sort()

    for name in listName
      listString = []
      
      listItem = app.select.name name
      listItem = _.sortBy listItem, ['data.x', 'data.y']
      
      for item in listItem
        {x, y, direction} = item.get()
        listString.push [x, y, direction].join ','
      
      string = listString.join ' '
      .replace /,0(?!,)/g, ''

      listSpace = string.match /\s/g
      if listSpace?.length > 5
        n = -5
        string = string
        .replace /\s/g, ->
          unless (n += 1) % 5
            '\n  '
          else ' '

      listSpace = string.match /\s/g
      listResult.push if listSpace?.length > 5
        "#{name}\n  #{string}"
      else "#{name} #{string}"

    listResult.join ';\n'

  import: (string) ->

    dataRes = {}

    string = string
    .replace /\r/g, ''
    .replace /\n/g, ''
    .replace /\s+/g, ' '
    .replace /;\s/g, ';'

    string = _.trim string, ' ,;'

    list = string.split ';'
    for line, i in list
      list[i] = line.split ' '

    # title
    dataRes.title = list[0][1...].join ' '

    # size
    [x, y] = list[1][1].split 'x'
    dataRes.size = [
      parseInt x
      parseInt y
    ]

    # background
    dataRes.background = list[2][1]

    # items
    dataItem = []
    list = list[3...]
    for line in list
      [name, listItem...] = line
      for item, i in listItem
        [x, y, direction] = item.split ','
        direction = (parseInt direction) or 0
        x = parseInt x
        y = parseInt y
        dataItem.push {
          direction
          name
          x, y
        }
    dataRes.item = dataItem

    dataRes # return

  unbind: ->

    app.dom '#world'
    .off '.edit'

    # message
    $.info 'Edit mode off.'

    @ # return