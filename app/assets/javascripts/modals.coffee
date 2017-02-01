# /* place remote modal logic here */

# modal javascript initialisation and implementation
$(document).on 'shown.bs.modal', ->

  $(".block-input").hide();
  $('.spinner').fadeOut(1000)
  # on remote form submit click
  $('#form-submit').click (e) ->
    $(".block-input").fadeIn(200)
    $('.spinner').show()
    return
  return