'use strict'

###*
 # @ngdoc function
 # @name snappiOtgApp.controller:DateCtrl
 # @description
 # # DateCtrl
 # Controller of the snappiOtgApp
###
angular.module('snappiOtgApp')
  .controller 'DateCtrl', [
    '$scope'
    '$location'
    '$dateParser'
    'TEST_DATA'
    'snappiAssetsPicker'
    '$timeout'
    ($scope, $location, $dateParser, TEST_DATA, $snappiAssetsPicker, $timeout)->
      $scope.awesomeThings = [
        'HTML5 Boilerplate'
        'AngularJS'
        'Karma'
      ]



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


      ### expecting { 
        lastDate:
        assets: [
          id: UUID.ext
          data:
            DateTimeOriginal: date string
        ]
      } ###
      parseMomentsFrom_MapPhotos = (mappedPhotos)->
        DAY_MS = 24*60*60*1000 
        momentsObj = _.reduce mappedPhotos.assets, (result, o)->
            datetimeStr =  o.data?.DateTimeOriginal || ""
            date = datetimeStr[0..9].replace(/:/g,'-')
            if result[date]?
              result[date].push o.id
            else 
              result[date] = [ o.id ] 
            return result
          , {}

        return parseMomentsFrom_TestDataCameraRoll momentsObj   

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

          


      init = ()->
        if window.deviceReady
          $scope.mapPhotos() 
        else $scope.cameraRollMoments = orderMomentsByDescendingKey parseMomentsFrom_TestDataCameraRoll(TEST_DATA.cameraRoll), 2
        # console.log $scope.cameraRollMoments

      
      $scope.cameraRollMoments = null
      $scope.options = {}
      $scope.select = ($ev)->
        scope = this;
        target = $ev.currentTarget
        # target = target.parentNode while target.tagName != 'BUTTON'
        angular.element(target).toggleClass "selected"
        return

      $scope.goto = (target)->
        console.log target
        $location.path(target)  

      $scope.mapPhotos = ()->
        $snappiAssetsPicker.log "*** $scope.mapPhotos() ***" 
        $snappiAssetsPicker.mapPhotos().then (mappedPhotos)->
          console.log mappedPhotos
          $scope.cameraRollMoments = orderMomentsByDescendingKey parseMomentsFrom_MapPhotos(mappedPhotos), 2  
          return mappedPhotos

      $scope.getPreviewSrc = (uuidExt)->
        # console.log "getPreviewSrc clicked"
        # uuidExt = "A9A99265-C590-47C7-9A54-252F1684C46E.JPG"
        console.log "getPreviewSrc for uuidExt="+uuidExt
        return $snappiAssetsPicker.getPreviewSrc(uuidExt).then (o)->
          console.log "getPreviewSrc() DONE <<<<<<< dataURL="+o.dataURL.preview[0..50]
          return o.dataURL.preview


      init()
  ]






