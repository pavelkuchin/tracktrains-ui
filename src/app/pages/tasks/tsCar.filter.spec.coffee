describe 'tsCarFilter', () ->
  beforeEach(module('trackSeatsApp'))

  beforeEach inject ($filter) =>
    @filter = $filter('tsCar')

  it 'Evaluate ANY to Any type of car', () =>
    expect(@filter('ANY')).toEqual('Any type of car')

  it 'Evaluate VIP to VIP car', () =>
    expect(@filter('VIP')).toEqual('VIP car')

  it 'Evaluate SLE to Sleeping car', () =>
    expect(@filter('SLE')).toEqual('Sleeping car')

  it 'Evaluate COM to Compartment car', () =>
    expect(@filter('COM')).toEqual('Compartment car')

  it 'Evaluate RB to Reserved-berths car', () =>
    expect(@filter('RB')).toEqual('Reserved-berths car')

  it 'Evaluate RS to Car with regular seats', () =>
    expect(@filter('RS')).toEqual('Car with regular seats')

  it 'Evaluate TC to Third-class car', () =>
    expect(@filter('TC')).toEqual('Third-class car')
