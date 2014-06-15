# Copyright (c) 2013 Jordan Vincent. All rights reserved.

window.Options = angular.module("options", ['ui.router'])

Options.config ($stateProvider, $urlRouterProvider) ->

  $urlRouterProvider.otherwise "/settings"

  $stateProvider
    .state('settings',
      url: '/settings'
      templateUrl: "partials/settings.html")
    .state('coming-soon',
      url: '/coming-soon'
      templateUrl: "partials/coming-soon.html")
    .state('credits',
      url: '/credits'
      templateUrl: "partials/credits.html")