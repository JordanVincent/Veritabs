Options.controller 'SettingsController', ($scope) ->

  chrome.runtime.getBackgroundPage (backgroundWindow) ->
    $scope.$apply $scope.state = backgroundWindow.Background.getState()

    $scope.$watch 'state.options.right', (newV,oldV) ->
      console.log $scope.state.options.right, newV, oldV
