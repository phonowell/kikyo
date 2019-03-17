(app.controller = new Controller()).init()

app.memory = []
app.cache = new Data()
app.cache.set 'size-unit', 32

app.rule = new Rule()

app.check = new Checker()
app.editor = new Editor()
app.filter = new Filter()
app.select = new Selector()

app.fn = new Fn()

# stage
$(window).on 'resize', ->
  app.fn.resize()
app.fn.resize()

# toolkit
$ '#btn-import'
.on 'click', ->
  string = prompt 'Paste level data here.'
  unless string.length
    return
  app.level.init string

$ '#btn-export'
.on 'click', ->
  console.log app.editor.export()
  $.info 'View level data on console.'

$ '#btn-edit'
.on 'click', ->
  $el = $ @
  $el.toggleClass 'status-active'

  if $el.hasClass 'status-active'
    app.editor.bind()
  else
    app.editor.unbind()
    string = app.editor.export()
    app.level.init string

# level
(app.level = new Level())
.next()