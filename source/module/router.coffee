# require

express = require 'express'
bodyParser = require 'body-parser'
helmet = require 'helmet'
pug = require 'pug'

ago = app.fn.require './source/module/ago'
pager = app.fn.require './source/module/pager'

# router

router = express()
router.use helmet()
router.use bodyParser.urlencoded extended: true
router.settings['x-powered-by'] = false # disabled 'x-powered-by: express'
router.listen app.port # port

$.info 'router', "router is listening on port #{app.port}."

# class

class Router

  constructor: (@req, @res) -> @

  ###

    ago()
    data(key)
    fail(msg, message, code)
    getPugSrc(src)
    pager()
    pug(src, data)
    redirect(url)
    send(arg)

  ###

  ago: ago

  data: (key) ->

    KEY = '__data__'

    @[KEY] or= _.merge {}, @req.body, @req.query, @req.params

    if !key then return @[KEY]
    @[KEY][key]

  fail: (msg, message, code) ->

    msg or= 'Unknown Error'
    message or= '你的浏览遇到了未知问题'
    code or= 500

    $.info 'error', msg
    @send 'error', code, {message}

  getPugSrc: (src) -> app.fn.normalizePath "./source/view/#{src}.pug"

  pager: pager

  pug: (src, data) ->

    cache = !app.isDebug

    compileTime = _.now()
    salt = app.salt
    startTime = app.startTime

    try pug.compileFile(@getPugSrc(src), {cache}) {$, compileTime, salt, startTime, data}
    catch err then @fail err

  redirect: (url) -> @res.redirect url

  send: (arg...) ->

    switch arg.length
      when 1 then @res.send arg[0]
      when 2 then @res.send @pug arg...
      when 3 then @res.status(arg[1]).send @pug arg[0], arg[2]

class Port

  ###

    delay(time)
    get(url, callback)
    require(list)

  ###

  delay: (time) ->
    new Promise (resolve) ->
      setTimeout ->
        resolve()
      , time or 0

  get: (url, callback) ->

    router.get url, (req, res) ->

      #$.info 'render', "#{req.path} started"

      st = _.now()
      r = new Router req, res
      cb = co callback

      cb r
      .then ->
        $.info 'render'
        , "#{req.path} done in '#{_.now() - st} ms'"
      .catch (err) ->
        $.info 'render'
        , "#{req.path} failed in '#{_.now() - st} ms'"
        r.fail err

  require: (list) ->

    list = switch $.type list
      when 'array' then list
      when 'string' then [list]
      else throw new Error 'invalid argument type'

    for src in list
      app.fn.require("./source/router/#{src}") @

# execute

p = new Port()

p.require [
  'index'
]

p.require 'static'
router.use '/static', express.static app.fn.normalizePath './source/static'

p.require 'error'
