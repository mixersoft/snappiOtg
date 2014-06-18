'use strict'

###*
 # @ngdoc function
 # @name snappiOtgApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the snappiOtgApp
###
angular.module('snappiOtgApp')
  .controller 'AboutCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
