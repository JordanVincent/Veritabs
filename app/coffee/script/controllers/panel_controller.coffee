Veritabs.controller 'PanelController', ($scope, $window, Port) ->

  fullscreenEnabled = ->
    window.innerWidth is screen.width and
    window.innerHeight is screen.height

  $scope.fullscreenEnabled = fullscreenEnabled()
  $(window).on 'resize', ->
    $scope.$apply ->
      $scope.fullscreenEnabled = fullscreenEnabled()

  Port.connect().then (state) ->

    $scope.state = Port.state

    $scope.optionsUrl = chrome.extension.getURL("views/options.html")

    $scope.sortableOptions =
      axis: 'y'
      revert: 200
      placeholder: "t_item ui-sortable-placeholder"

      helper: (e, elt) ->
        clone = elt.clone()
        clone.width elt.width()
        clone

      stop: (e, ui) ->
        index = ui.item.index()
        tab   = $scope.state.tabs[index]

        Port.send 'move',
          id: tab.id
          index: index


    $scope.newTab = ->
      Port.send 'new'

    # Tab actions

    $scope.closeTab = (tab) ->
      Port.send 'close',
        id: tab.id

    $scope.activateTab = (tab) ->
      Port.send 'activate',
        id: tab.id

    $scope.refresh = ->
      Port.send 'state',
        state: $scope.state

    # Navigation

    $scope.navigatePrevious = ->
      $window.history.back()

    $scope.navigateNext = ->
      $window.history.forward()

    $scope.navigateReload = ->
      $window.location.reload()
