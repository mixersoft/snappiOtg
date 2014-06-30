'use strict'

###*
 # @ngdoc directive
 # @name snappiOtgApp.directive:thumbnail
 # @description
 # # thumbnail
###
angular.module('snappiOtgApp')
  .directive 'otgThumbnail', [
    '$window'
    ($window)->
      templateUrl: 'views/template/thumbnail.tpl.html'
      restrict: 'EA'
      scope : 
        photoId: '=otgPhotoId'
        options: '=otgOptions'
      # replace: true
      # require: ''
      link: (scope, element, attrs) ->
        # element.text 'this is the moment directive'
        options = scope.options
        scope.photo = {
          id: scope.photoId
          src: "http://lorempixel.com/"+options.width+"/"+options.height+"?"+scope.photoId
        }
        return
  ]  
