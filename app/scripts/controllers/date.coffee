'use strict'

###*
 # @ngdoc function
 # @name snappiOtgApp.controller:DateCtrl
 # @description
 # # DateCtrl
 # Controller of the snappiOtgApp
###
angular.module('snappiOtgApp')
  .controller 'DateCtrl', ($scope, $location, $dateParser) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]

    #.btn-lg=74, .btn=58
    options = defaults = {
      btnSize: 'btn-lg' 
      thumbnailSize: (74-2)
    }
    
    TEST_DATA = {
      '2014-06-14':[3]
      '2014-06-07':[1,4,5,8]
      '2014-06-08':[3,6,9,0]
      '2014-06-19':[2,3]
      '2014-06-11':[1,2,3,4,5,6,7,8,9,10,11]
      '2014-06-13':[4,2,3,1]
    }

    setSizes = ()->
      # also $window.on 'resize'  
      w = document.getElementById('date').clientWidth
      console.log w
      if w < 400
        # .btn
        options.btnSize = ''
        options.thumbnailSize = (58-2)
        options.thumbnailLimit = (w-69) / options.thumbnailSize
      else 
        # .btn-lg
        options.thumbnailLimit = (w-88) / options.thumbnailSize

      whitespace = options.thumbnailLimit % 1
      console.log "whitespace=" + whitespace + ", pixels=" +(whitespace * options.thumbnailSize)
      if whitespace * options.thumbnailSize < 28 
        # leave room for .badge
        options.thumbnailLimit -= 1
      options.thumbnailLimit = Math.floor(options.thumbnailLimit)  

      console.log "thumbnailLimit=" + options.thumbnailLimit
        
      return 

    parseMoments = (cameraRollDates)->
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
      setSizes()
      $scope.options = options
      $scope.cameraRollMoments = orderMomentsByDescendingKey parseMoments(TEST_DATA), 2

    
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






