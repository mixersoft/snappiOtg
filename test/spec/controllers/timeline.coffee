'use strict'

describe 'Controller: TimelineCtrl', ->

  # load the controller's module
  beforeEach module 'snappiOtgApp'

  TimelineCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    TimelineCtrl = $controller 'TimelineCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
