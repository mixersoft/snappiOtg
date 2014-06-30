'use strict'

###*
 # @ngdoc function
 # @name snappiOtgApp.controller:TimelineCtrl
 # @description
 # # TimelineCtrl
 # Controller of the snappiOtgApp
###
angular.module('snappiOtgApp')
  .controller 'TimelineCtrl', [
    '$scope'
    '$q', '$route', '$location',
    'TEST_DATA'
    ($scope, $q, $route, $location, TEST_DATA) ->
      $scope.awesomeThings = [
        'HTML5 Boilerplate'
        'AngularJS'
        'Karma'
      ]

      init = ()->
        # filter parse TEST_DATA.cameraRoll into moments
        moments = parseMomentsFrom_TestDataCameraRoll(TEST_DATA.cameraRoll)
        moments = filterMomentsForFavorites moments, TEST_DATA.topPix
        $scope.favoriteMoments = orderMomentsByDescendingKey moments, 2

        galleryId = $route.current.params.id || null
        console.log "timeline route.params.id="+galleryId
        $scope.showGallery = !!galleryId 
        if $scope.showGallery 
          # parse momeents and set scope for Gallery
          found = _.chain( $scope.favoriteMoments )
              .reduce (result, o)-> # flatten
                  return result.concat( o.value )
                , []
          if galleryId=='all'
            found = found.reduce (result, o)->
                  return result.concat o.value
                , []  
              .value()
            $scope.moment = if found.length then {key:'all', value:found } else {key: 'all', value:[]}
          else  
            found = found.where {key: galleryId}
              .value()
            $scope.moment = if found.length then found[0] else {key: galleryId, value:[]}
          console.log $scope.moment



      # expecting { `date`: [array of photoIds]}
      parseMomentsFrom_TestDataCameraRoll = (cameraRollDates)->
        DAY_MS = 24*60*60*1000 
        dates = _.keys cameraRollDates
        dates.sort()
        # console.log dates

        # cluster into moments
        _current = _last = null
        moments = _.reduce dates, (result, k)->
            date = if _.isDate(k) then k else new Date(k)
            if _current? 
              if date.setHours(0,0,0,0) == _last + DAY_MS # next day
                _last = date.setHours(0,0,0,0)
                _current.days[k] = cameraRollDates[k]
              else 
                _current = _last = null    

            if !_current?
              # ???: use $dateParser?
              _last = date.setHours(0,0,0,0)
              o = {}
              o[k] = cameraRollDates[k]
              _current = { label: k, days: o }
              result[_current.label] =  _current.days

            return result
          , {}
        console.log moments 
        return moments


      filterMomentsForFavorites = (moments, favorites)->
        copy = _.cloneDeep moments
        console.log "clone=" + JSON.stringify copy
        _.each moments, (v, k)->
          _.each v, (v2, k2)->
            found = _.intersection v2, favorites 
            if found.length
              copy[k][k2] = found
            else 
              delete copy[k][k2]
            return 
        return copy



        return _.intersection photoIds favorites  

            # reformat object as an array of {key:, value: }
      orderMomentsByDescendingKey = (o, levels=1)->
        keys = _.keys( o ).sort().reverse()
        recurse = levels - 1
        reversed = _.map keys, (k)->
          item = { key: k }
          item.value = if recurse > 0 then orderMomentsByDescendingKey( o[k], recurse ) else o[k]

          # console.log item
          return item
        console.log reversed if levels==2
        return reversed  




      $scope.galleryGlow = ()->
        return

      $scope.markPhotoForRemoval = (ev, i, action)->
        return

      $scope.isMarkedForRemoval = (i, id)->
        return

      $scope.removeMarkedPhotos = ()->
        return

      $scope.removeMarkedPhotoNow = (ev)->
        return

      $scope.share = (ev, type='social')->
        switch 'type'
          when 'server'
            console.log "server share"
          else 
            console.log "socialPlugin share"
        return

      $scope.goto = (ev, i, belongsTo)->
        return

      init()
  ]
