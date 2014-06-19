'use strict'

###*
 # @ngdoc function
 # @name snappiOtgApp.controller:CommonCtrl
 # @description
 # # CommonCtrl
 # Controller of the snappiOtgApp
###
angular.module('snappiOtgApp')
  .controller 'CommonCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
