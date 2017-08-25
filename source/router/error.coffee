module.exports = (router) ->

  # /4xx
  router.get '/error/4xx', (d) ->

    yield router.delay()

    d.send 'error',
      message: '你访问的页面并不存在'

  # /5xx
  router.get '/error/5xx', (d) ->

    yield router.delay()

    d.send 'error',
      message: '你的浏览遇到了未知问题'

  # /404
  router.get '*', (d) ->

    yield router.delay()

    d.fail "#{d.req.path} not found", '你访问的页面并不存在', 404
