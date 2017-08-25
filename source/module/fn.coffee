# require

path = require 'path'

#

$$ = {}

###

  formatPath(source)
  get(url, [data])
  normalizePath(source)
  post(url, [data])
  require(source)
  token()

###

$$.formatPath = (source) ->
  source = switch $.type source
    when 'array' then source
    when 'string' then [source]
    else throw _error 'type'
  (_normalizePath src for src in source)

$$.get = co (url, data) ->

  if !~url.search '://'
    url = "#{app.path.api}#{url}"

  res = yield $.get url, data

  if !res?.data
    msg = res.info or 'API Server is DOWN'
    throw new Error msg

  # return
  res.data

$$.normalizePath = (source) ->

  if $.type(source) != 'string'
    return null

  src = source.replace /\\/g, '/'

  src = switch src[0]
    when '.' then src.replace /\./, app.path.base
    when '~' then src.replace /~/, app.path.home
    else src

  src = path.normalize src

  if path.isAbsolute src then return src
  else return "#{app.path.base}#{path.sep}#{src}"

$$.post = co (url, data) ->

  if !~url.search '://'
    url = "#{app.path.api}#{url}"

  res = yield $.post url, data

  if !res?.data
    msg = res.info or 'API Server is DOWN'
    throw new Error msg

  # return
  res.data

$$.require = (source) ->

  source = $$.normalizePath source

  require source

$$.token = -> Math.random().toString(36).substr(2)[...8]

module.exports = $$
