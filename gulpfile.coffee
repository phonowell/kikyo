# require

$$ = require 'fire-keeper'
{$, _, Promise} = $$.library
co = Promise.coroutine

# function

exclude = (arg) ->

  list = switch $.type arg
    when 'array' then arg
    when 'string' then [arg]
    else throw new Error 'invalid argument type'

  _.uniq list.push '!**/include/**'

  # return
  list

# task

###

  build
  lib
  lint
  prepare
  server
  watch

###

$$.task 'build', co ->
  yield $$.compile './source/index.coffee', minify: false
  yield $$.copy './source/index.js', './'

$$.task 'lib', co ->

  base = './source/static/lib/script'

  yield $$.compile "#{base}/include/lib.coffee",
    minify: true
    bare: true

  yield $$.copy "#{base}/include/lib.js", base,
    suffix: '.min'

  yield $$.remove "#{base}/include/lib.js"

$$.task 'lint', co ->

  yield $$.task('kokoro')()

  yield $$.lint [
    './gulpfile.coffee'
    './source/**/*.coffee'
    './test/**/*.coffee'
  ]

$$.task 'prepare', co ->

  # secret

  yield $$.compile './secret/config.yml'

  # static

  source = exclude './source/**/*.styl'
  yield $$.compile source

  source = exclude './source/static/**/*.coffee'
  yield $$.compile source

  # server

  for key in 'module router'.split ' '
    source = exclude "./source/#{key}/**/*.coffee"
    yield $$.compile source,
      minify: false

  yield $$.compile './source/app.coffee',
    minify: false

$$.task 'server', ->
  $$.shell 'nodemon --delay 500ms --ignore source/static source/app.js'

$$.task 'watch', ->

  # yaml

  yaml = './secret/config.yml'

  deb = _.debounce ->
    $$.compile yaml
  , 1e3

  $$.watch yaml, deb

  # styl

  style = './source/static/core/style'

  deb = _.debounce ->
    $$.compile "#{style}/core.styl"
  , 1e3

  $$.watch "#{style}/include/*.styl", deb

  # coffee

  script = './source/static/core/script'

  deb = _.debounce ->
    $$.compile "#{script}/core.coffee"
  , 1e3

  $$.watch [
    "#{script}/core.coffee"
    "#{script}/include/*.coffee"
    "#{script}/model/*.coffee"
  ], deb

  source = exclude './source/static/**/*.coffee'
  $$.watch source, (e) -> $$.compile e.path, map: true

  source = exclude [
    './source/app.coffee'
    './source/module/**/*.coffee'
    './source/router/**/*.coffee'
  ]
  $$.watch source, (e) -> $$.compile e.path, minify: false

  # reload

  $$.reload './source/**/*.css'
