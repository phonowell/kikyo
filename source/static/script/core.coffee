$stage = $ '#stage'

# jQuery
$.ajaxSetup
  cache: true

# app
window.app =

  startTimestamp: $.now()

# stage data
_.merge app, $stage.data()

# require

#=include ../../../gurumin/script/include/core/detect.coffee
#=include ../../../gurumin/script/include/core/data.coffee

#=include ../../../gurumin/script/include/core/$.cubicBezier.coffee
#=include ../../../gurumin/script/include/core/$.fn.animateBy.coffee
#=include ../../../gurumin/script/include/core/$.fn.onAnimationEnd.coffee
#=include ../../../gurumin/script/include/core/$.fn.switchClass.coffee
#=include ../../../gurumin/script/include/core/$.i.coffee
#=include ../../../gurumin/script/include/core/$.insertStyle.coffee
#=include ../../../gurumin/script/include/core/$.next.coffee
#=include ../../../gurumin/script/include/core/$.parseJson.coffee
#=include ../../../gurumin/script/include/core/$.parseString.coffee
#=include ../../../gurumin/script/include/core/$.parseTemp.coffee
#=include ../../../gurumin/script/include/core/$.require.coffee

# include

#=include include/check.coffee
#=include include/controller.coffee
#=include include/data.coffee
#=include include/dictionary.coffee
#=include include/dom.coffee
#=include include/editor.coffee
#=include include/filter.coffee
#=include include/fn.coffee
#=include include/info.coffee
#=include include/item.coffee
#=include include/rule.coffee
#=include include/selector.coffee

#=include include/level.coffee

# execute
#= include include/execute.coffee