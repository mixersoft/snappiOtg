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


    menuAside = $aside {
      scope     : $scope
      # template: 'views/sidebar-menu.html'
      contentTemplate   : 'views/sidebar-menu.html'
      container : 'header.navbar'
      title     : 'aside menu'
      placement : 'left'
      animation : 'am-fade-and-slide-left'
      show      : false
    }

    menuAside.$promise.then ()->
      console.log "aside template loaded"


    $scope.menuAsideShow = ()->
      menuAside.show()

    return;
      

