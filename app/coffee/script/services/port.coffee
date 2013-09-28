SellerApp.service 'Port', ($rootScope) ->

  @port = null

  @state =
    tabs:     [{},{}] # The current state of the plugin
    active:   true  # either the extension is active or not
    visible:  true  # State opened/closed of the bar
    fixed:    false # Either the bar is fixed or not
    width:    200   # Width of the bar
    resizing: false # Either the user is currently resizing the bar
    settings: false # The settings page is open
    tiny:     false # The tiny mode | deprecated
    options:
      right:  false # true if the bar is positioned at the right

  # Port connexion
  @init = ->
     
    @connect()

    # Message received
    port.onMessage.addListener (msg) =>
      console.log 'message', msg

      if msg.type is "state"
        $rootScope.$apply @state = msg.state
  
  @connect = ->
    @port = chrome.extension.connect()
    @port.postMessage type: "init"

    # Reconnect the port when disconnected
    @port.onDisconnect.addListener (a) =>
      @connect()

  @send = (type,options) ->
    @port.postMessage 
      type:    type
      options: options
