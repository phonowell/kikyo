$ = require 'fire-keeper'

class M

  ###
  bind()
  compile_(source, option = {})
  copy_(source)
  exclude()
  execute()
  reloadCss()
  watchCoffee()
  watchPug()
  watchStyl()
  watchYaml()
  ###

  bind: ->
    process.on 'uncaughtException', (e) ->
      $.i e.stack
    @ # return

  compile_: (source, option = {}) ->

    target = $.getDirname source
    .replace /\/source/, '/build'
    .replace /\/{2,}/g, '/'

    option.map ?= true
    option.minify ?= false

    await $.compile_ source, target, option

    @ # return

  copy_: (source) ->

    target = $.getDirname source
    .replace /\/source/, '/build'
    .replace /\/{2,}/g, '/'

    await $.copy_ source, target

    @ # return

  exclude: $.fn.excludeInclude

  execute: ->

    @bind()

    @watchCoffee()
    @watchPug()
    @watchStyl()
    @watchYaml()
    
    @reloadCss()

    @ # return

  reloadCss: ->
    $.reload './build/**/*.css'
    @ # return

  watchCoffee: ->

    base = './source/static/script'

    listSource = @exclude [
      "!#{base}/core.coffee"
      './source/**/*.coffee'
    ]
    $.watch listSource, (e) => await @compile_ e.path

    # ./source/static/script/core.coffee
    listSource = [
      "#{base}/core.coffee"
      "#{base}/include/**/*.coffee"
      "#{base}/require/**/*.coffee"
    ]
    $.watch listSource, => await @compile_ "#{base}/core.coffee"

    @ # return

  watchPug: ->
    $.watch './source/view/**/*.pug', (e) => await @copy_ e.path
    @ # return

  watchStyl: ->

    listSource = @exclude './source/**/*.styl'
    $.watch listSource, (e) => await @compile_ e.path

    # ./source/static/style/core.styl
    base = './source/static/style'
    $.watch "#{base}/include/**/*.styl", => await @compile_ "#{base}/core.styl"

    @ # return

  watchYaml: ->
    $.watch './secret/**/*.yaml', (e) => await @compile_ e.path
    @ # return

# return
module.exports = ->

  m = new M()
  m.execute()