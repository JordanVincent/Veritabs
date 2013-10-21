Veritabs.directive 'scroll', ->

  link: (scope, element, attr) ->

    element.on 'mousewheel.veritabs', (e) ->
      e.preventDefault()
      e.returnValue = false
      scrollBy e.originalEvent.wheelDeltaY

    # Scrolls the tab container of dy px
    # params: dy: the number of pixel to scroll, negative to the bottom, positive to the top
    scrollBy = (dy) ->
      posY = getTabContainer().position().top + dy
      scrollTo posY

    # Scrolls the tab container to y
    # params: y: the vertical position
    scrollTo = (y) ->
      h = element.height()
      H = getTabContainer().height()
      if y > 0 # Begining of the scroll
        y = 0
      else if H < h # No scroll needed
        y = 0
      else y = h - H  if H + y < h # End of the scroll
      getTabContainer().animate
        top: y
      ,
        queue: false
        duration: 200

    getTabContainer = ->
      element.find '#t_tabContainer'


