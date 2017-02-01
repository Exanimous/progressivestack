# /* place remote modal logic here */

# modal javascript initialisation and implementation
$(document).on 'shown.bs.modal', ->

  $('.spinner').fadeOut(1000)
  # on remote form submit click
  $('#form-submit').click (e) ->
    $('.spinner').show()
    return
  return