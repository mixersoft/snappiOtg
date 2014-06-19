'use strict'

###*
 # @ngdoc function
 # @name snappiOtgApp.controller:SettingsCtrl
 # @description
 # # SettingsCtrl
 # Controller of the snappiOtgApp
###
angular.module('snappiOtgApp')
  .controller 'SettingsCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
