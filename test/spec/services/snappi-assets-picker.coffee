'use strict'

describe 'Service: snappiAssetsPicker', ->

  # load the service's module
  beforeEach module 'snappiOtgApp'

  # instantiate service
  snappiAssetsPicker = {}
  beforeEach inject (_snappiAssetsPicker_) ->
    snappiAssetsPicker = _snappiAssetsPicker_

  it 'should do something', ->
    expect(!!snappiAssetsPicker).toBe true
