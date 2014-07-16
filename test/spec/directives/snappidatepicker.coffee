'use strict'

describe 'Directive: snappiDatepicker', ->

  # load the directive's module
  beforeEach module 'snappiOtgApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<snappi-datepicker></snappi-datepicker>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the snappiDatepicker directive'
