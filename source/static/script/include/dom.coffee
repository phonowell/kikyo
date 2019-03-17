app.dom = (selector) ->

  unless selector
    return app.dom['__cache__']

  dom = app.dom['__cache__'][selector] or= $ selector
  unless dom.length
    throw new Error "invalid dom '#{selector}'"
  dom # return

app.dom['__cache__'] = {}