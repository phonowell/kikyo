$ = require 'fire-keeper'

# return
module.exports = ->

  await $.task('build')()

  await $.exec_ 'nodemon
  --delay 5000ms
  --watch build/app.js
  build/app.js'