(($) ->
  window.Veritabs = angular.module('veritabs', ['ui.sortable'])

  Veritabs.constant 'TINY_WIDTH', 30

  Veritabs.config ($compileProvider) ->
     $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|chrome-extension):/)
     $compileProvider.aHrefSanitizationWhitelist(/^\s*(chrome-extension):/)

)(jQuery) # Allow using the $ tag