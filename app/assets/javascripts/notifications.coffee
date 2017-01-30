$ ->
  $('.remove-notification').click ->
    event.preventDefault()
    $('.notifications-bar').fadeOut(1000)

  $('.accept-notification').click ->
    $('.notifications-bar').hide()