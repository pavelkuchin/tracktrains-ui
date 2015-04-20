describe 'AlertsService', () ->
  beforeEach(module('trackSeatsApp'))

  beforeEach inject (@AlertsService, @$timeout, $httpBackend) =>
    $httpBackend.when('GET', '/v1/user/session/').respond({})
    $httpBackend.when('GET', 'app/pages/landing/pages.landing.template.html')
      .respond({})

  it 'Initially AlertsService.alerts.messages is empty', () =>
    expect(@AlertsService.alerts.messages).toEqual([])

  it 'The showAlert method should add message to AlertsService.alerts.messages', () =>
    @AlertsService.showAlert('test msg', 'test type')

    expect(@AlertsService.alerts.messages).toEqual([{msg: 'test msg', type: 'test type'}])

  it 'The clearAlerts method should clear all the alerts', () =>
    @AlertsService.showAlert('test msg 1', 'test type')
    @AlertsService.showAlert('test msg 2', 'test type')

    expect(@AlertsService.alerts.messages[0]).toEqual({msg: 'test msg 1', type: 'test type'})
    expect(@AlertsService.alerts.messages[1]).toEqual({msg: 'test msg 2', type: 'test type'})

    @AlertsService.clearAlerts()

    expect(@AlertsService.alerts.messages).toEqual([])

  it 'The showAlert method should add messages in row one by one', () =>
    @AlertsService.showAlert('test msg 1', 'test type')
    @AlertsService.showAlert('test msg 2', 'test type')
    @AlertsService.showAlert('test msg 3', 'test type')

    expect(@AlertsService.alerts.messages[0]).toEqual({msg: 'test msg 1', type: 'test type'})
    expect(@AlertsService.alerts.messages[1]).toEqual({msg: 'test msg 2', type: 'test type'})
    expect(@AlertsService.alerts.messages[2]).toEqual({msg: 'test msg 3', type: 'test type'})

  it 'The showAlert method with howLong parameter should close message after timeout (ms)', () =>
    @AlertsService.showAlert('test msg 1', 'test type', 3000)

    expect(@AlertsService.alerts.messages[0]).toEqual({msg: 'test msg 1', type: 'test type'})

    @$timeout.flush()

    expect(@AlertsService.alerts.messages).toEqual([])
