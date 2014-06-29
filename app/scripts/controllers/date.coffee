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
    ($scope, $location, $dateParser, TEST_DATA) ->
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
        $scope.cameraRollMoments = orderMomentsByDescendingKey parseMomentsFrom_TestDataCameraRoll(TEST_DATA.cameraRoll), 2

      
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

      init()
  ]






