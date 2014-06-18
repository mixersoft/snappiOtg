'use strict'

###*
 # @ngdoc function
 # @name snappiOtgApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the snappiOtgApp
###
angular.module('snappiOtgApp')
  .controller 'MainCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
