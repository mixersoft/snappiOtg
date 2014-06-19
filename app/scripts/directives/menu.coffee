'use strict'

###*
 # @ngdoc directive
 # @name snappiOtgApp.directive:menu
 # @description
 # # menu
###
angular.module('snappiOtgApp')
  .directive('menu', ->
    template: '<div></div>'
    restrict: 'E'
    link: (scope, element, attrs) ->
      element.text 'this is the menu directive'
  )
