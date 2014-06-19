'use strict'

describe 'Directive: menu', ->

  # load the directive's module
  beforeEach module 'snappiOtgApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<menu></menu>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the menu directive'
