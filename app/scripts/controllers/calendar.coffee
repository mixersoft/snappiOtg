'use strict'

###*
 # @ngdoc function
 # @name snappiOtgApp.controller:CalendarCtrl
 # @description
 # # CalendarCtrl
 # Controller of the snappiOtgApp
###



angular.module('snappiOtgApp')
  .config ($datepickerProvider)->
    angular.extend $datepickerProvider.defaults, {
      # trigger: 'click'
      iconLeft: 'fa fa-arrow-left'
      iconRight: 'fa fa-arrow-right'

    }
  .controller 'CalendarCtrl', ($scope, $location) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]


    $scope.todayDate = new Date()
    $scope.todayDate.setHours(0,0,0,0)
    $scope.fromDate = null;
    $scope.toDate = null;

    init = ()->
      return

    $scope.goto = (target)->
      console.log target
      $location.path(target)

    init()