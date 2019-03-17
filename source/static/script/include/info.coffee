$.info = (text) ->
  
  $layer = $ '#layer-info'
  unless $layer.length
    return text

  $br = $ '<br>'
  $info = $ '<span>'
  .text text
  .onAnimationEnd ->
    $br.remove()
    $info.remove()
  
  $br.appendTo $layer
  $info.appendTo $layer
  
  text # return