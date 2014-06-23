'use strict'

###*
 # @ngdoc function
 # @name snappiOtgApp.controller:HeaderCtrl
 # @description
 # # HeaderCtrl
 # Controller of the snappiOtgApp
###
angular.module('snappiOtgApp')
  .controller 'HeaderCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
