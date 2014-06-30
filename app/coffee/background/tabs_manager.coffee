class TabsManager
  state: window.state

  # Map containing the tab ports
  ports: {}

  constructor: ->
    # Connexion established
    chrome.extension.onConnect.addListener (port) =>
      tabId = port.sender.tab.id

      @registerPort(tabId, port)

      # Remove port when disconnected
      port.onDisconnect.addListener =>
        @unregisterPort(tabId)

      @ports[tabId] = port

      @initTab(tabId)

      # Message listener
      port.onMessage.addListener (msg) =>
        @_tabMessageListener(msg, tabId)

    # Refresh tab activated
    chrome.tabs.onActivated.addListener (activeInfo) =>
      @refreshTab(activeInfo.tabId)

    # Refresh tab updated (loading complete)
    chrome.tabs.onUpdated.addListener (activeInfo) =>
      @refreshTab(activeInfo.tabId)

  registerPort: (tabId, port) ->
    @ports[tabId] = port

  unregisterPort: (tabId) ->
    delete @ports[tabId]

  initTab: (tabId) ->
    @refreshTab(tabId)

  _tabMessageListener: (msg, tabId) ->
    type = msg.type
    data = msg.data

    # Actions
    switch type
      when 'state'    then $.extend(@state, data.state)
      when 'new'      then chrome.tabs.create({})
      when 'close'    then chrome.tabs.remove(data.id)
      when 'activate' then chrome.tabs.update(data.id, {selected: true})
      when 'move'     then chrome.tabs.move(data.id, {index: data.index})

    # Saving
    if type is 'state'
      DataStorage.saveState(@state)

    # Refreshing
    if type in ['new','close']
      @refreshTab(tabId)

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

window.TabsManager = new TabsManager