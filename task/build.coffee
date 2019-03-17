$ = require 'fire-keeper'

class M

  ###
  exclude
  pathBuild
  
  clean_()
  compile_()
  copy_()
  execute_()
  ###

  exclude: $.fn.excludeInclude
  pathBuild: './build'

  clean_: ->
    await $.remove_ @pathBuild
    @ # return

  compile_: ->

    # lib
    await $.task('lib')()

    # styl
    listSource = @exclude './source/**/*.styl'
    await $.compile_ listSource, @pathBuild,
      base: './source'

    # coffee
    listSource = @exclude './source/**/*.coffee'
    await $.compile_ listSource, @pathBuild,
      base: './source'

    @ # return

  copy_: ->

    listExt = [
      '.css'
      '.gif'
      '.jpg'
      '.js'
      '.png'
      '.pug'
      '.ttf'
    ]
    listSource = ("./source/**/*#{ext}" for ext in listExt)
    await $.copy_ listSource, @pathBuild

    @ # return

  execute_: ->

    await $.chain @
    .clean_()
    .copy_()
    .compile_()
   
    @ # return


# return
module.exports = ->

  m = new M()
  await m.execute_()