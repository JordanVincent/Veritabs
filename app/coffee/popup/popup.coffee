
chrome.extension.sendMessage
  type: 'init'
, (response) ->
  active = response.state.active

  displayInfo(response.state.tabs)
  displayActive(active)

$('#t_activateBtn').click ->
  active = $(this).hasClass('active')
  newActive = not active

  chrome.extension.sendMessage
    type: 'active'
    active: newActive
  , ->
    displayActive(newActive, -> window.close())

displayActive = (active, callback) ->
  iconPostfix = if active then '' else 'off'

  if active
    $('#t_activateBtn').addClass('active')
    $('#t_activateBtn').html('Deactivate')
  else
    $('#t_activateBtn').removeClass('active')
    $('#t_activateBtn').html('Activate')

  chrome.browserAction.setIcon
    path:
      19: chrome.extension.getURL("img/icons/icon19#{iconPostfix}.png")
      38: chrome.extension.getURL("img/icons/icon38#{iconPostfix}.png")
    , ->
      callback.call() if callback

displayInfo = (tabs) ->
  if disabledOnActiveTab(tabs) then $('#t_info').show() else $('#t_info').hide()

activeTab = (tabs) ->
  i = 0
  i++ while i < tabs.length and not tabs[i].active
  tabs[i] if i < tabs.length and tabs[i].active

disabledOnActiveTab = (tabs) ->
  tab = activeTab(tabs)

  tab and
  ((tab.url.indexOf('chrome://') isnt -1) or
  tab.url.indexOf('chrome-extension://') isnt -1)