# Copyright (c) 2013 Jordan Vincent. All rights reserved.

class Background

  constructor: ->

    # Map containing the ports
    @ports = {}

    # The current state of the plugin
    @state =
      tabs:     []    # all the current tabs
      active:   true  # either the extension is active or not
      visible:  true  # state opened/closed of the bar
      fixed:    false # either the bar is fixed or not
      width:    200   # width of the bar
      tiny:     false # the tiny mode
      options:
        right:  false # true if the bar is positioned at the right

    # Open storage
    @loadState =>
      @refreshTab null

    # Connexion established 
    chrome.extension.onConnect.addListener (port) =>

      # Remove port when disconnected
      port.onDisconnect.addListener =>
        delete @ports[port.sender.tab.id]

      # Adding the port by its tab id
      @ports[port.sender.tab.id] = port

      # Init the tab
      @refreshTab port.sender.tab.id

      # Message listener
      port.onMessage.addListener (msg) =>
        console.log msg

        type = msg.type
        data = msg.data

        # Actions
        switch type
          when 'state'    then $.extend @state, data. state
          when 'new'      then chrome.tabs.create {}
          when 'close'    then chrome.tabs.remove data.id
          when 'activate' then chrome.tabs.highlight tabs: [data.id]
          when 'move'     then chrome.tabs.move data.id, index: data.index

        # Saving
        if type is 'state'
          @saveState()  

    # Messages between the popup and the background
    chrome.extension.onMessage.addListener (request, sender, sendResponse) =>

      if request.type is "active"
        @state.active = request.active
        @refreshTab null
        @saveState()

      sendResponse state: @state

    # Refresh tab activated
    chrome.tabs.onActivated.addListener (activeInfo) =>
      @refreshTab activeInfo.tabId

    # Refresh tab updated (loading complete)
    chrome.tabs.onUpdated.addListener (activeInfo) =>
      @refreshTab activeInfo.tabId


  # Returns the current tab, null if not found
  # Params: - callback (function(tab)) 
  getCurrentTab: (callback) ->
    chrome.tabs.query
      active: true
      windowType: "normal"
      windowId: chrome.windows.WINDOW_ID_CURRENT

    , (tabs) =>
      tab = ((if tabs.length > 0 then tabs[0] else null))
      callback.call this, tab  if callback isnt "undefined"


  # Send a message to refresh the tab, if tabId is null, it refreshes the current tab
  # Params: tabId (integer) the tab to refresh
  refreshTab: (tabId) ->
    sendTabs = (tabId) =>
      chrome.tabs.query
        
        #windowType:"normal", 
        windowId: chrome.windows.WINDOW_ID_CURRENT
      , (tabs) =>
        @state.tabs = tabs
        
        # At the init, the port is not intentiated first
        if @ports[tabId]
          @ports[tabId].postMessage
            type: "state"
            data: 
              state: @state

    if tabId is "undefined" or not tabId?
      @getCurrentTab (tab) =>
        sendTabs tab.id  if tab?

    else
      sendTabs tabId

  # Local storage

  # TODO catch error
  # Save the state of the extension in local storage
  saveState: ->
  
    console.log chrome.storage
    chrome.storage.sync.set
      state: @state
    , ->
      if chrome.runtime.lastError
        console.error "error ?", chrome.runtime.lastError


  # TODO catch error
  # Load the state saved in local storage
  loadState: (callback) ->
    chrome.storage.sync.get "state", (items) =>
      if items and items.state
        currentTabs = @state.tabs
        state = items.state
        state.tabs = currentTabs
        state.visible = false # TODO remove...
        console.log state
        $.extend @state, state
        console.error(chrome.runtime.lastError) if chrome.runtime.lastError
        callback.call this  if callback isnt "undefined"



window.Background = new Background