$root = app.dom.root
$bar = $ '#bar'
$mainer = $ '#mainer'
$footer = $ '#footer'

d = $mainer.data()

d.resize = ->
  height = window.innerHeight - $bar.height() - $footer.height()
  $mainer.css {height}

# init

do ->

  $root.on 'resize', -> d.resize()
  d.resize()