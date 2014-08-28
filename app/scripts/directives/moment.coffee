'use strict'

###*
 # @ngdoc directive
 # @name snappiOtgApp.directive:otgMoment
 # @description
 # # otg-moment
###
angular.module('snappiOtgApp')
  # uses $q.promise to load src 
  .directive 'lazySrc', ()->
    return {
      restrict: 'A'
      scope: false
      link: (scope, element, attrs) ->
        uuidExt = attrs.lazySrc
        options = scope.options
        qGetSrc = scope.qGetSrc
        lorempixel = 'http://lorempixel.com/'+options.thumbnailSize+'/'+options.thumbnailSize+'?'+uuidExt
        element.attr('src', lorempixel)
        if uuidExt.length == 40
          qGetSrc(uuidExt).then (dataUrl)->
            console.log "return from lazy-src directive getSrc()"
            element.attr('src', dataUrl)

    }
  .directive 'otgMoment', [
    '$window'
    ($window)->
      options = defaults = {
        breakpoint: 480
        'col-xs': 
          btnClass: ''
          thumbnailSize: 58-2
          thumbnailLimit: null # (w-69)/thumbnailSize
        'col-sm':
          btnClass: 'btn-lg'
          thumbnailSize: 74-2
          thumbnailLimit: null # (w-88)/thumbnailSize
      }

      setSizes = (element)->
        # also $window.on 'resize'  
        w = element[0].parentNode.clientWidth
        console.log w
        if w < options.breakpoint
          cfg = _.clone options['col-xs']
          cfg.thumbnailLimit = (w-69)/cfg.thumbnailSize
        else # .btn-lg
          cfg = _.clone options['col-sm']
          cfg.thumbnailLimit = (w-88)/cfg.thumbnailSize

        whitespace = cfg.thumbnailLimit % 1
        console.log "whitespace=" + whitespace + ", pixels=" +(whitespace * cfg.thumbnailSize)
        if whitespace * cfg.thumbnailSize < 28 
          # leave room for .badge
          cfg.thumbnailLimit -= 1
        cfg.thumbnailLimit = Math.floor(cfg.thumbnailLimit)  
        console.log "thumbnailLimit=" + cfg.thumbnailLimit
        return cfg


      return {
        templateUrl: 'views/template/moment.tpl.html'
        restrict: 'EA'
        scope : 
          moments: '=otgModel'
          select: '=onSelect'
          qGetSrc: '=qGetSrc'   # this is a $q.promise
        # replace: true
        # require: ''
        link: (scope, element, attrs) ->
          # element.text 'this is the moment directive'
          scope.options = setSizes(element)
          return
        }
  ]
