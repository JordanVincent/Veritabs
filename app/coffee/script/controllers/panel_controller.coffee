Veritabs.controller 'PanelController', ($scope, Port) ->

    Port.connect().then (state) ->

      $scope.state = Port.state

      $scope.$watch 'state', =>
        Port.send 'state', 
          state: $scope.state

      $scope.optionsUrl = chrome.extension.getURL("views/options.html")

      $scope.sortableOptions =
        axis: 'y'
        revert: 300
        stop: (e, ui) ->
          index = ui.item.index()
          tab   = $scope.state.tabs[index]
          
          Port.send 'move', 
            id: tab.id
            index: index

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