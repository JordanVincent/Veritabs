Veritabs.service 'Port', ($q, $rootScope) ->

  isInit: false
  port:  {}
  state: {}

  # Port connexion
  connect: ->
    deferred = $q.defer()

    @port = chrome.extension.connect()
    @port.postMessage type: "init"

    # Message received
    @port.onMessage.addListener (msg) =>

      if msg.type is "state"
        angular.extend @state, @cleanState msg.data.state
        if @isInit
          $rootScope.$apply()
        else
          @isInit = true
          deferred.resolve @state

    # Reconnect the port when disconnected
    @port.onDisconnect.addListener (a) =>
      @connect()

    deferred.promise

  send: (type,data) ->
    @port.postMessage
      type: type
      data: data

  cleanState: (state) ->
    state.visible = false
    state