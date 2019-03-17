$ = require 'fire-keeper'
# return
module.exports = ->

  await $.lint_ [
    './source/**/*.coffee'
    './source/**/*.styl'
  ]