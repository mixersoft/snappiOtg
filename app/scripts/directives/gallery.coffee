'use strict'

###*
 # @ngdoc directive
 # @name snappiOtgApp.directive:otgGallery
 # @description
 # # gallery
###
angular.module('snappiOtgApp')
  .directive 'otgGallery', [
    '$window'
    ($window)->
      # copied from directives/moment.coffee, refactor
      options = defaults = {
        perpage: 10
        width: 320
        height: 240
      }
      

      return {
        templateUrl: 'views/template/gallery.tpl.html'
        restrict: 'EA'
        scope:
          moment: '=otgModel'
        link: (scope, element, attrs) ->
          scope.options = options
          scope.title = scope.day.key
          return
      }
  ]
