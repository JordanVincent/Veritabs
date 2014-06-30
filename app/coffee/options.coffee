# Copyright (c) 2013 Jordan Vincent. All rights reserved.

window.Options = angular.module('options', ['ngRoute'])

Options.config ($routeProvider) ->

  $routeProvider
    .when('/settings',
      templateUrl: 'partials/settings.html'
      controller: 'SettingsController')

    .when('/coming-soon',
      templateUrl: 'partials/coming-soon.html')

    .when('/about',
      templateUrl: 'partials/about.html')

    .otherwise({ redirectTo: '/settings' })