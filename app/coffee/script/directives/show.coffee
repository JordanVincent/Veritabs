Veritabs.directive 'show', ->

  scope:
    state: '=show'

  link: (scope, element, attr) ->

    $(document).mousemove (e) ->

      # Open
      if mustOpenPanel(e.pageX)
        scope.state.visible = true
        element.fadeIn()
        # port.postMessage type: "openSideBar"

      # Close
      else if mustClosePanel(e.pageX)
        scope.state.visible = false
        element.fadeOut()
        # port.postMessage type: "closeSideBar"

    # Return true if the panel must open considering the value x of the mouse
    # Params: x (integer)
    mustOpenPanel = (x) ->
      return false unless scope.state

      scope.state.active and # TODO manage the scope.state.active better
      fullscreenActive() and
      (
        scope.state.fixed or
        scope.state.tiny or
        (mouseInOpenArea(x) and not scope.state.visible)
      )

    # Return true if the panel must close considering the value x of the mouse
    # Params: x (integer)
    mustClosePanel = (x) ->
      return false unless scope.state

      not scope.state.active or # TODO manage the scope.state.active better
      fullscreenUnactive() or
      (
        mouseInCloseArea(x) and
        not scope.state.fixed and
        not scope.state.resizing and
        not scope.state.tiny and
        scope.state.visible
      )

    mouseInOpenArea = (x) ->
      right = scope.state.options.right

      (not right and x is 0) or
      (right and x >= $(document).width() - 10)

    mouseInCloseArea = (x) ->
      right = scope.state.options.right
      width = scope.state.width

      (not right and x > width) or
      (right and x < $(document).width() - width)

    fullscreenActive = ->
      fullscreenEnabled() or not scope.state.options.fullscreen

    fullscreenUnactive = ->
      not fullscreenEnabled() and scope.state.options.fullscreen

    fullscreenEnabled = ->
      window.innerWidth is screen.width and
      window.innerHeight is screen.height
