'use strict'

###*
 # @ngdoc service
 # @name snappiOtgApp.appConfig
 # @description
 # # appConfig
 # Value in the snappiOtgApp.
###
angular.module('snappiOtgApp')
  .value 'appConfig', {
  	userid: null
  	debug: false
  	timeout: 
  		rest: 2000
  }
