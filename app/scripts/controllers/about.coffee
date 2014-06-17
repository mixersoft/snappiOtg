'use strict'

###*
 # @ngdoc function
 # @name onTheGoApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the onTheGoApp
###
angular.module('onTheGoApp')
  .controller 'AboutCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
