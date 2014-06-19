'use strict'

describe 'Controller: CommonCtrl', ->

  # load the controller's module
  beforeEach module 'snappiOtgApp'

  CommonCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    CommonCtrl = $controller 'CommonCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
