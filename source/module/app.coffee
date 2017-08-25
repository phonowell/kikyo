$$ = {}

# start time
$$.startTime = _.now()
  
# path

$$.path =
  base: process.cwd()
  home: require('os').homedir()

# env & debug

env = $.trim process.env.NODE_ENV
$$.env = if env.length then env else 'development'
$$.isDebug = ($$.env == 'development')

# secret/config
# port
# salt

config = require "#{$$.path.base}/secret/config.json"
$$.port = config.port
$$.salt = config.salt

# error catch

process.on 'uncaughtException', (err) ->
  switch $.type err
    when 'error' then $.i err.stack
    else $.i err

# info
$.info 'project', "Project is running as '#{$$.env}'."

# return
module.exports = $$
