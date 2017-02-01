# /*
  # Methods for ensuring correct HistoryState API funtionality
  # https://developer.mozilla.org/en-US/docs/Web/API/History_API
# */


# --Handle remote (ajax) link clicks
# append xhr status to url if required
# push link url (including status) to historyState API
# do not push DELETE actions
@OnRemoteLinkClick = ($content, $link) ->
  $content.on 'ajax:beforeSend', $link, (e, xhr, settings) ->
    $(".spinner").show()
    # never push delete actions to history
    if settings.type != 'DELETE'
      append = undefined
      url = settings.url
      if settings.url.indexOf('?') == -1
        append = '?'
      else
        append = '&'
      # append ajax flags
      settings.url += append + 'xhr=true'
      # push ajax url to history state
      history.pushState {}, '', url
    return

# --Render 500 error page on ajax (remote) load errors
@OnRemoteLinkError = ($content, $link) ->
  $content.on 'ajax:error', $link, (xhr, status, error) ->
    $.ajax
      type: 'GET'
      url: '/' + '500'
      dataType: 'html'
      data: {}
      success: (data) ->
        window.location.replace '/500'
        return
    return

# --Handle modal hidden bootstrap event
# suppress additional callbacks by passing lock == true
# if modal is based on html action use replaceState and ajax to update view
# else use the history back method
# handle notification fading
@OnModalHidden = (lock, $element) ->
  html_action = isHTMLAction()
  directory = getController()
  action = getAction()
  if html_action # modal was displayed via html action (via url)
    if lock == false and (action == 'new' or action == 'edit')
      history.pushState {}, '', $(this).attr('href')
    $.ajax
      type: 'GET'
      url: '/' + directory + '?fragment=true'
      dataType: 'html'
      data: {}
      success: (data) ->
        $element.html data
        return
    history.replaceState {}, '', '/' + directory
  else # modal origin was javascript
    if lock == false
      history.pushState(null, null, ('/' + directory));
  fadeOutNotification 2000
  return