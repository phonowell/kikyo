module.exports = (router) ->

  # /
  router.get '/', (d) ->

    yield router.delay()

    d.send 'index', {}
