'use strict'

###*
 # @ngdoc overview
 # @name snappiOtgApp
 # @description
 # # snappiOtgApp
 #
 # Main module of the application.
###
angular
  .module('snappiOtgApp', [
    'ngAnimate',
    'ngCookies',
    'ngResource',
    'ngRoute',
    'ngSanitize',
    'ngTouch'
    'mgcrea.ngStrap'
  ])
  .constant('version', 'v0.1.0')
  .config ($locationProvider, $routeProvider) ->
    $locationProvider.html5Mode  false
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/settings',
        templateUrl: 'views/settings.html'
        controller: 'SettingsCtrl'
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
      .otherwise
        redirectTo: '/'

