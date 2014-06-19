'use strict'

describe 'Service: appConfig', ->

  # load the service's module
  beforeEach module 'snappiOtgApp'

  # instantiate service
  appConfig = {}
  beforeEach inject (_appConfig_) ->
    appConfig = _appConfig_

  it 'should do something', ->
    expect(!!appConfig).toBe true
