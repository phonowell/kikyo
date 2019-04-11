$ = require 'fire-keeper'
fs = require 'fs'

# task

unless fs.existsSync './task'
  return

listFilename = fs.readdirSync './task'
for filename in listFilename

  unless ~filename.search /\.coffee/
    continue

  name = filename.replace /\.coffee/, ''

  do (name) -> $.task name, ->
    fn = require "./task/#{name}.coffee"
    fn()