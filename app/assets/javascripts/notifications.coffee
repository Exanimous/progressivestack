$ ->
  $('.remove-notification').click ->
    event.preventDefault()
    $('.notifications-bar').fadeOut(1000)