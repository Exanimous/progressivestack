# return current controller
@getController = ->
  controller = $('body').data('controller')
  if controller == 'quota'
    controller = 'q'
  controller

# returns true if action origin was an html request
# else returns undefined
# used for controlling modal callback behaviour
@isHTMLAction = ->
  origin = $('body').data('html-action')
  origin

# attempts to return name of previous (or) new action
# will return index/edit/new
# useful for differentiating view actions from partials
@getAction = ->
  action = $('body').data('action')
  action
