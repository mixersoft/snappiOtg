'use strict'

describe 'Controller: DateCtrl', ->

  # load the controller's module
  beforeEach module 'snappiOtgApp'

  DateCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    DateCtrl = $controller 'DateCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
