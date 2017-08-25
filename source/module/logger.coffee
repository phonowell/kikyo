# require

log4js = require 'log4js'
logger = log4js.getLogger()

# function

$.log = (arg...) ->

  [type, msg] = switch arg.length
    when 1 then ['info', arg[0]]
    when 2 then arg
    else throw new Error 'invalid argument length'

  logger[type] msg

  # return
  msg

# return

module.exports = logger