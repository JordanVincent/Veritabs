Options.controller 'OptionsController', ($scope, $location) ->

  $scope.isActive = (route) ->
    route is $location.path()