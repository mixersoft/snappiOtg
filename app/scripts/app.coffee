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
      # .when '/',
      #   templateUrl: 'views/main.html'
      #   controller: 'MainCtrl'
      .when '/main',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl' 
      .when '/calendar',
        templateUrl: 'views/calendar.html'
        controller: 'CalendarCtrl' 
      .when '/date',
        templateUrl: 'views/date.html'
        controller: 'DateCtrl'   
      .when '/timeline',
        templateUrl: 'views/timeline.html'
        controller: 'TimelineCtrl'  
      .when '/timeline/gallery/:id',
        templateUrl: 'views/timeline.html'
        controller: 'TimelineCtrl'                          
      .when '/settings',
        templateUrl: 'views/settings.html'
        controller: 'SettingsCtrl'
      .when '/about',
        templateUrl: 'views/about.html'
        controller: 'AboutCtrl'
      .otherwise
        redirectTo: '/calendar'
  .run ($rootScope, $location, $anchorScroll, $timeout, $routeParams)->
    return

