# Copyright (c) 2013 Jordan Vincent. All rights reserved.

# Init

chrome.extension.sendMessage
  type: "init"
, (response) ->
  active = response.state.active
  console.log response.state
  setAllowed response.state.tabs
  activate active

# Btn activate

$("#t_activateBtn").click ->
  active = $(this).hasClass("active")
  activate not active
  chrome.extension.sendMessage
    type: "active"
    active: not active
  , (response) ->
    window.close()

# Btn settings

$("#t_settingsBtn").click ->
  chrome.extension.sendMessage
    type: "settings"
    settings: true
  , (response) ->
    window.close()

# Activate or deactivate the extension
activate = (active) ->
  if active
    $("#t_activateBtn").addClass "active"
    $("#t_activateBtn").html "Deactivate"
    chrome.browserAction.setIcon
      path:
        19: chrome.extension.getURL("img/icons/icon19.png")
        38: chrome.extension.getURL("img/icons/icon38.png")
    , ->
      console.log "on"

  else
    $("#t_activateBtn").removeClass "active"
    $("#t_activateBtn").html "Activate"
    chrome.browserAction.setIcon
      path:
        19: chrome.extension.getURL("img/icons/icon19off.png")
        38: chrome.extension.getURL("img/icons/icon38off.png")
    , ->
      console.log "off"

setAllowed = (tabs) ->
  i = 0
  while i < tabs.length and not tabs[i].active
    i++
  if i < tabs.length and tabs[i].active and (tabs[i].url.indexOf("chrome://") isnt -1) or tabs[i].url.indexOf("chrome-extension://") isnt -1
    $("#t_info").show()
  else
    $("#t_info").hide()


