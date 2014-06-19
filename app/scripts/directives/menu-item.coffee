'use strict'

###*
 # @ngdoc directive
 # @name snappiOtgApp.directive:menuItem
 # @description
 # # menuItem
###
angular.module('snappiOtgApp')
  .directive('menuItem', ->
    template: '<div></div>'
    restrict: 'E'
    link: (scope, element, attrs) ->
      element.text 'this is the menuItem directive'
  )
