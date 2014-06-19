'use strict'

describe 'Controller: SettingsctrlCtrl', ->

  # load the controller's module
  beforeEach module 'snappiOtgApp'

  SettingsctrlCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    SettingsctrlCtrl = $controller 'SettingsctrlCtrl', {
      $scope: scope
    }

  it 'should attach a list of awesomeThings to the scope', ->
    expect(scope.awesomeThings.length).toBe 3
