$ = require 'fire-keeper'

class M

  ###
  execute_()
  makeCore_()
  prepare_()
  ###

  execute_: ->
    # await @prepare_()
    await @makeCore_()
    @ # return

  makeCore_: ->

    # content
    base = './gurumin/script/include/lib'
    listModule = [
      'jquery-3.3.1'
      'jquery.transit.min'
      'lodash'
    ]
    content = (
      await $.read_ "#{base}/#{name}.js" for name in listModule
    ).join '\n\n'

    # compile
    pathTemp = './temp/lib.min.js'
    pathStatic = './source/static/script'
    await $.chain $
    .write_ pathTemp, content
    .compile_ pathTemp, pathStatic
    .remove_ pathTemp

    @ # return

  prepare_: ->
    await $.task('gurumin')()
    @ # return

# return
module.exports = ->

  m = new M()
  await m.execute_()