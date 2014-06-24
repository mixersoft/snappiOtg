'use strict'

###*
 # @ngdoc function
 # @name snappiOtgApp.controller:HeaderCtrl
 # @description
 # # HeaderCtrl
 # Controller of the snappiOtgApp
###
angular.module('snappiOtgApp')
  .controller 'HeaderCtrl', ($scope, $aside, $location, $anchorScroll) ->

    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]

    $scope.menuAside = {
      title: 'Menu'
    }


    # $scope.menuAsideShow = ()->
    #   return menuAside.show() if menuAside?
    #   # find menuAside from markup
    #   angular.element document.getElementById('header').$scope().$show()

    return;
      

