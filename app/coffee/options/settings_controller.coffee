Options.controller 'SettingsController', ($scope) ->

  chrome.runtime.getBackgroundPage (backgroundWindow) ->
    $scope.$apply $scope.state = backgroundWindow.state

    $scope.$watchCollection 'state.options', ->
      backgroundWindow.DataStorage.saveState($scope.state)