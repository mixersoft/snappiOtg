'use strict'

###*
 # @ngdoc function
 # @name onTheGoApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the onTheGoApp
###
angular.module('onTheGoApp')
  .controller 'MainCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
