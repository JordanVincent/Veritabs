Veritabs.controller 'PanelController', ($scope, Port) ->

    $scope.state = Port.state
    

    $scope.clickSettingsBtn = ->
    $scope.clickTinyModeBtn = ->
    $scope.clickResizeBtn = ->

    $scope.clickNewBtn = ->
      Port.send "new"

    $scope.clickFixBtn = ->

    $scope.closeTab = (tab) ->
      Port.send "close", 
        id: tab.id