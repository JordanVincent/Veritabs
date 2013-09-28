Veritabs.directive 'tabHover', ->

  scope:
    state: '=tabHover'
    tab: '=ngModel'

  link: (scope, element, attr) ->

    element.hover (e) ->
      scope.$apply scope.tab.hover = scope.state.tiny

    , (e) ->
      scope.$apply scope.tab.hover = false

     