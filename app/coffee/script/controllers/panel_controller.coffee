Veritabs.controller 'PanelController', ($scope, Port) ->

    Port.connect()
    $scope.state = Port.state

    $scope.$watch 'state', =>
      Port.send 'state', 
        state: $scope.state

    $scope.optionsUrl = chrome.extension.getURL("views/options.html")

    $scope.clickNewBtn = ->
      Port.send 'new'

    # Tab actions

    $scope.closeTab = (tab) ->
      console.log 'close'
      Port.send 'close', 
        id: tab.id

    $scope.activateTab = (tab) ->
      console.log 'activate'
      Port.send 'activate', 
        id: tab.id