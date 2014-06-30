# Copyright (c) 2013 Jordan Vincent. All rights reserved.

class Background
  state: window.state

  constructor: ->

    # Open storage
    DataStorage.loadState (state) =>
      $.extend(@state, state)
      TabsManager.refreshTab()

    # Messages between the popup and the background
    chrome.extension.onMessage.addListener (request, sender, sendResponse) =>
      @_popupMessageHandler(request, sender, sendResponse)

  _popupMessageHandler: (request, sender, sendResponse) ->
    if request.type is 'active'
      @state.active = request.active
      TabsManager.refreshTab()
      DataStorage.saveState(@state)

    sendResponse
      state: @state

window.Background = new Background