# Copyright (c) 2013 Jordan Vincent. All rights reserved.

# Map containing the ports
ports = {}

# The current state of the plugin
state =
  tabs: []
  active: true # either the extension is active or not
  visible: true # state opened/closed of the bar
  fixed: false # either the bar is fixed or not
  width: 200 # Width of the bar
  settings: false # The settings page is open
  tiny: false # The tiny mode
  options:
    right: false # true if the bar is positioned at the right

# Open storage
loadState ->
  refreshTab null

# Connexion established 
chrome.extension.onConnect.addListener (port) ->

  # Remove port when disconnected
  port.onDisconnect.addListener ->
    delete ports[port.sender.tab.id]

  # Adding the port by its tab id
  ports[port.sender.tab.id] = port

  # Init the tab
  refreshTab port.sender.tab.id

  # Message listener
  port.onMessage.addListener (msg) ->

    # TODO cleaning
    if msg.type is "init"

    else if msg.type is "openSideBar"
      state.visible = true

    else if msg.type is "closeSideBar"
      state.visible = false

    else if msg.type is "close"
      chrome.tabs.remove msg.tabId

    else if msg.type is "activate"
      chrome.tabs.highlight
        tabs: [msg.tabIndex]
      , (window) ->

    else if msg.type is "new"
      chrome.tabs.create {}, ->

    else if msg.type is "move"
      chrome.tabs.move msg.tabId,
        index: msg.posIndex

    else if msg.type is "width"
      state.width = msg.width

    else if msg.type is "fix"
      state.fixed = msg.fixed

    else if msg.type is "tiny"
      state.tiny = msg.tiny

    else if msg.type is "settings"
      state.settings = msg.settings
      console.log state

    else state.options = msg.options  if msg.type is "settingsOptions"

    if msg.type is "width" or msg.type is "fix" or msg.type is "tiny" or msg.type is "settingsOptions"
      saveState()  
      # refreshTabs();

# Messages between the popup and the background
chrome.extension.onMessage.addListener (request, sender, sendResponse) ->

  if request.type is "active"
    state.active = request.active
    refreshTab null
    saveState()

  else if request.type is "settings"
    state.settings = request.settings
    refreshTab null

  else if request.type is "init"
    console.log() # Nothing
  sendResponse state: state



#
#chrome.extension.sendMessage({type: 'active', active:true}, function(response) {
#    console.log(response);
#});

# LISTENERS 

# Tab activated
chrome.tabs.onActivated.addListener (activeInfo) ->
  refreshTab activeInfo.tabId

# Window removed
#chrome.windows.onRemoved.addListener(function(windowId){
#
#    // If last window removed, we save the current state
#    chrome.windows.getAll(null, function(windows){
#        alert(windows);
#        if (windows.length <= 1){
#            saveState();
#        }
#    })  
#});

# Returns the current tab, null if not found
# Params: - callback (function(tab)) 
getCurrentTab = (callback) ->
  chrome.tabs.query
    active: true
    windowType: "normal"
    windowId: chrome.windows.WINDOW_ID_CURRENT
  , (tabs) ->
    tab = ((if tabs.length > 0 then tabs[0] else null))
    callback.call this, tab  if callback isnt "undefined"


# Send a message to refresh the tab, if tabId is null, it refreshes the current tab
# Params: tabId (integer) the tab to refresh
refreshTab = (tabId) ->
  sendTabs = (tabId) ->
    chrome.tabs.query
      
      #windowType:"normal", 
      windowId: chrome.windows.WINDOW_ID_CURRENT
    , (tabs) ->
      state.tabs = tabs
      
      # At the init, the port is not intentiated first
      if ports[tabId]
        ports[tabId].postMessage
          type: "refresh"
          state: state

  if tabId is "undefined" or not tabId?
    getCurrentTab (tab) ->
      sendTabs tab.id  if tab?

  else
    sendTabs tabId

# TODO catch error
# Save the state of the extension in local storage
saveState = ->
  state.settings = false
  chrome.storage.sync.set
    state: state
  , ->
    console.error "error ?", chrome.runtime.lastError


# TODO catch error
# Load the state saved in local storage
loadState = (callback) ->
  chrome.storage.sync.get "state", (items) ->
    if items and items.state
      currentTabs = state.tabs
      state = items.state
      state.tabs = currentTabs
      state.visible = false # TODO remove...
      console.log state
      console.error "error ?", chrome.runtime.lastError
      callback.call this  if callback isnt "undefined"









