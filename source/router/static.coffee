module.exports = (router) ->

  # /_static
  router.get '/_static/:page', (d) ->
    yield router.delay()
    d.send "require/#{d.data().page}", {}