Options.controller 'OptionsController', ($scope) ->

  chrome.runtime.getBackgroundPage (backgroundWindow) ->
    $scope.$apply $scope.state = backgroundWindow.Background.getState()

