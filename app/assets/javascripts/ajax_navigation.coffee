# /*
  # Ajax and HistoryState API navigation control and display logic
  # Designed for Bootstrap and JQuery
# */

document.addEventListener 'turbolinks:load', (event) ->
  $content = $('.main-content')
  $link = $('a')
  $dialog = $('#dialog')

  if history and history.pushState
    # --Handle ajax(remote) link clicks
    OnRemoteLinkClick $content, $link
    # --Handle error if ajax (remote) link fails to load
    OnRemoteLinkError $content, $link

    # --Handle historyState/redirect/partial logic after modal close
    $dialog.on 'hidden.bs.modal', (e) ->
      lock = $dialog.data('lock')
      OnModalHidden lock, $('.quota-index')
      setTitle(getController())
      return
  return

# Ensure that ajax actions can be tracked with analytics
$(document).ajaxComplete (e, xhr, settings) ->
  controller = getController()
  action = getAction()

  # Manually update CSRF data to response headers (support authentication with ajax)
  csrf_param = xhr.getResponseHeader('X-CSRF-Param')
  csrf_token = xhr.getResponseHeader('X-CSRF-Token')
  if csrf_param
    $('meta[name="csrf-param"]').attr 'content', csrf_param
  if csrf_token
    $('meta[name="csrf-token"]').attr 'content', csrf_token

  # Update google analytics for ajax actions
  if controller and (action == 'new' or action == 'edit' or action == 'index') and settings.type != 'DELETE'
    if GoogleAnalytics
      GoogleAnalytics.trackAjax()
  return

# --Listen for history state changes
if history and history.pushState
  # force close modal (with conditional ajax/historyState logic)
  # e.state is only present in js view actions (not html)
  window.addEventListener 'popstate', (e) ->
    html_action = isHTMLAction()
    directory = getController()
    state = e.state
    $dialog = $('#dialog')
    if !state
      modalCloseWithLock $dialog
    else
      if html_action
        modalCloseWithLock $dialog
        $.get document.location.href + '?xhr=true'
      else
        modalCloseWithLock $dialog
        path = document.location
        if path.pathname == '/' + directory
          $.get document.location.href + '?fragment=true'
        else
          # full index reload (required for outside requests)
          #enforce xhr
          $.get document.location.href + '?xhr=true'
    return

# --Supress modal-hide callback historyState logic
# prevents modal close/display bug in chrome
modalCloseWithLock = ($element) ->
  $element.data('lock', true)
  $element.modal 'hide'
  $element.data('lock', false)
  return

# --Force set page title
# required for handling historyState back actions and modal closing
# will be overridden by titles that are force set within .js views
setTitle = (directory) ->
  switch directory
    when 'quota' then document.title = 'Quota index | Progressivestack'
    when 'q' then document.title = 'Quota index | Progressivestack'
