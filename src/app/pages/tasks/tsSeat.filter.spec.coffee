describe 'tsSeatFilter', () ->
  beforeEach(module('trackSeatsApp'))

  beforeEach inject ($filter) =>
    @filter = $filter('tsSeat')

  it 'Evaluate ANY to Any type of seat', () =>
    expect(@filter('ANY')).toEqual('Any type of seat')

  it 'Evaluate B to Bottom place', () =>
    expect(@filter('B')).toEqual('Bottom place')

  it 'Evaluate T to Top place', () =>
    expect(@filter('T')).toEqual('Top place')

  it 'Evaluate BS to Bottom place by side', () =>
    expect(@filter('BS')).toEqual('Bottom place by side')

  it 'Evaluate TS to Top place by side', () =>
    expect(@filter('TS')).toEqual('Top place by side')
