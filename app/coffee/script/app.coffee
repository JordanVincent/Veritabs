# Copyright (c) 2013 Jordan Vincent. All rights reserved.
(($) ->

  window.Veritabs = angular.module('veritabs', [])

  Veritabs.constant 'TINY_WIDTH', 30

  Veritabs.config ($compileProvider) ->
     $compileProvider.imgSrcSanitizationWhitelist(/^\s*(https?|chrome-extension):/)
     $compileProvider.aHrefSanitizationWhitelist(/^\s*(chrome-extension):/)

)(jQuery) # Allow using the $ tag