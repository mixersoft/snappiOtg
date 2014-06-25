'use strict'

describe 'Controller: CalendarCtrl', ->

  # load the controller's module
  beforeEach module 'snappiOtgApp'

  CalendarCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    CalendarCtrl = $controller 'CalendarCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
