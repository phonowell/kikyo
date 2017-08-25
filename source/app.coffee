# require

global.$ = require 'node-jquery-extend'
global._ = $._
global.Promise = require 'bluebird'
global.co = Promise.coroutine

# init

cwd = process.cwd()

# logger
#require "#{cwd}/source/module/logger"

# app
global.app = require "#{cwd}/source/module/app"

# app.fn
app.fn = require "#{app.path.base}/source/module/fn"

# router
app.fn.require './source/module/router'
