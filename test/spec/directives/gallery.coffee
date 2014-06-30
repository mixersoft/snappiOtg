'use strict'

describe 'Directive: gallery', ->

  # load the directive's module
  beforeEach module 'snappiOtgApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<gallery></gallery>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the gallery directive'
