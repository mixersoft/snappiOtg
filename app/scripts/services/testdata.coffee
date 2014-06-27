'use strict'

###*
 # @ngdoc service
 # @name snappiOtgApp.TEST_DATA
 # @description
 # # TEST_DATA
 # Value in the snappiOtgApp.
###
angular.module('snappiOtgApp')
  .value 'TEST_DATA', {
    photos: [0..24]
    cameraRoll:
      '2014-06-19':[19..20]
      '2014-06-14':[18]
      '2014-06-13':[14..17]
      '2014-06-11':[8..13]
      '2014-06-08':[5..7]
      '2014-06-07':[2..4]
      '2014-06-04':[1]
      '2014-06-03':[0]
      '2014-06-02':[21]
      '2014-06-01':[22]
      '2014-05-31':[23]
      '2014-05-30':[24]

      
    topPix:
      [1,2,5,8,9,10,11,16,20]


  }
