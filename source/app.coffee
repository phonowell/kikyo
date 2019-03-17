$ = require 'fire-keeper'

express = require 'express'
pug = require 'pug'

# router
router = express()
router.settings['x-powered-by'] = false
router.listen 8080

# index
router.get '/', (req, res) ->

  fnPug = pug.compileFile './source/view/index.pug',
    cache: false
  
  html = fnPug()
  
  res.send html

# static
router.use '/static', express.static './build/static'