Veritabs.directive 'resize', ->

  scope:
    state: '=resize'
    refreshFn: '&stop'

  link: (scope, element, attr) ->

    # Resizes the panel
    element.draggable

      helper: ''

      start: ->
        scope.$apply scope.state.resizing = true

      drag: (e, ui) ->

        if scope.state.options.right
          width = document.width - ui.offset.left

        else
          width = ui.position.left + 15
        scope.$apply scope.state.width = width

      stop: ->
        scope.$apply scope.state.resizing = false
        scope.refreshFn()
        

     