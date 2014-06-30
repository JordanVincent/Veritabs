Veritabs.directive 'show', ->

  scope:
    state: '=show'

  link: (scope, element, attr) ->

    $("html").mousemove (e) ->

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
      (
        scope.state.fixed or
        (
          (
            ( not scope.state.options.right and x is 0 ) or
            ( scope.state.options.right and x >= $(document).width() - 10 )
          ) and not scope.state.visible
        ) or scope.state.tiny
      ) and scope.state.active # TODO manage the scope.state.active better


    # Return true if the panel must close considering the value x of the mouse
    # Params: x (integer)
    mustClosePanel = (x) ->
      return false unless scope.state
      (
        (
          ( not scope.state.options.right and x > scope.state.width ) or
          ( scope.state.options.right and x < $(document).width() - scope.state.width )
        ) and not scope.state.fixed and not scope.state.resizing and scope.state.visible and not scope.state.tiny
      ) or not scope.state.active # TODO manage the scope.state.active better
