# Copyright (c) 2013 Jordan Vincent. All rights reserved.

class Background

  # Map containing the tab ports
  ports: {}

  # The current state of the plugin
  state: {}

  defaultState:
    tabs:     []    # all the current tabs
    active:   true  # either the extension is active or not
    visible:  true  # state opened/closed of the bar
    fixed:    false # either the bar is fixed or not
    width:    200   # width of the bar
    tiny:     false # the tiny mode
    options:
      right:  false # true if the bar is positioned at the right

  constructor: ->

    # The current state of the plugin
    @state = _.cloneDeep(@defaultState)

    # Open storage
    LocalStorage.loadState (state) =>
      $.extend @state, state
      @refreshTab null

    # Connexion established
    chrome.extension.onConnect.addListener (port) =>
      tabId = port.sender.tab.id

      # Remove port when disconnected
      port.onDisconnect.addListener =>
        delete @ports[tabId]

      # Adding the port by its tab id
      @ports[tabId] = port

      # Init the tab
      @refreshTab(tabId)

      # Message listener
      port.onMessage.addListener (msg) =>
        @_tabMessageHandler(msg, tabId)

    # Messages between the popup and the background
    chrome.extension.onMessage.addListener (request, sender, sendResponse) =>
      @_popupMessageHandler(request, sender, sendResponse)

    # Refresh tab activated
    chrome.tabs.onActivated.addListener (activeInfo) =>
      @refreshTab(activeInfo.tabId)

    # Refresh tab updated (loading complete)
    chrome.tabs.onUpdated.addListener (activeInfo) =>
      @refreshTab(activeInfo.tabId)

  _tabMessageHandler: (msg, tabId) ->
    type = msg.type
    data = msg.data

    # Actions
    switch type
      when 'state'    then $.extend(@state, data.state)
      when 'new'      then chrome.tabs.create({})
      when 'close'    then chrome.tabs.remove(data.id)
      when 'activate' then chrome.tabs.update(data.id, {selected: true})
      when 'move'     then chrome.tabs.move data.id, index: data.index

    # Saving
    if type is 'state'
      LocalStorage.saveState(@state)

    # Refreshing
    if type in ['new','close']
      @refreshTab(tabId)

  _popupMessageHandler: (request, sender, sendResponse) ->
    if request.type is 'active'
      @state.active = request.active
      @refreshTab(null)
      LocalStorage.saveState(@state)

    sendResponse
      state: @state

  # Returns the current tab, null if not found
  # Params: - callback (function(tab))
  _getCurrentTab: (callback) ->
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
    if tabId is "undefined" or not tabId?
      @_getCurrentTab (tab) =>
        @_sendTabsTo(tab.id) if tab?
    else
      @_sendTabsTo(tabId)

  _sendTabsTo: (tabId) ->
    chrome.tabs.query
      #windowType:"normal",
      windowId: chrome.windows.WINDOW_ID_CURRENT
    , (tabs) =>
      @state.tabs = tabs
      @_sendStateTo(tabId)

  _sendStateTo: (tabId) ->
    # At the init, the port is not instantiated first
    return unless @ports[tabId]

    @ports[tabId].postMessage
      type: "state"
      data:
        state: @state

  getState: ->
    @state

window.Background = new Background