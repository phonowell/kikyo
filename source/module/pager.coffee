$$ = {}

###

  render(option)

###

$$.render = (option) ->

  p = $.extend
    page: 1 # page number
    count: 0 # post count
    size: 10 # page size
    long: 5
  , option

  if p.count <= p.size then return ''

  p.total or= Math.ceil(p.count / p.size)

  icon = (name) -> "<i class='icon icon-#{name}'></i>"
  $$ = (_p) ->
    $.parseTemp '<a class="$$ [class]" data-page="[page]" href="[href]">[content]</a>',
      class: _p.class
      page: _p.page
      content: _p.content
      href: $.parseTemp p.href,
        page: _p.page

  p.first = ''
  if p.page > 1
    p.first = $$
      class: '$$-last'
      page: 1
      content: icon 'skip-previous'

  p.last = ''
  if p.page != p.total
    p.last = $$
      class: '$$-first'
      page: p.total
      content: icon 'skip-next'

  p.fores = ''
  for i in [(p.page - 1)...(p.page - p.long)] by -1 when i >= 1
    p.fores = $$(
      class: '$$-hinds'
      page: i
      content: i
    ) + p.fores

  p.hinds = ''
  for i in [(p.page + 1)...(p.page + p.long)] by 1 when i <= p.total
    p.hinds += $$
      class: '$$-fores'
      page: i
      content: i

  p.here = ''
  if p.total > 0
    p.here = $$
      class: '$$-here active'
      page: p.page
      content: p.page

  p.hint = "<span class='hint'>#{p.page} / #{p.total}页</span>"

  # return

  [
    p.first
    p.fores
    p.here
    p.hinds
    p.last
    p.hint
  ].join ''

# return
module.exports = $$
