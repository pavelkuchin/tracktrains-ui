describe 'AlertsService', () ->
  beforeEach(module('trackSeatsApp'))

  beforeEach inject (AlertsService) =>
    @AlertsService = AlertsService

  it 'Initially AlertsService.alerts.messages is empty', () =>
    expect(@AlertsService.alerts.messages).toEqual([])

  it 'The showAlert method should add message to AlertsService.alerts.messages', () =>
    @AlertsService.showAlert('test msg', 'test type')

    expect(@AlertsService.alerts.messages).toEqual([{msg: 'test msg', type: 'test type'}])

  it 'The clearAlerts method should clear all the alerts', () =>
    @AlertsService.showAlert('test msg', 'test type')

    expect(@AlertsService.alerts.messages).toEqual([{msg: 'test msg', type: 'test type'}])

    @AlertsService.clearAlerts()

    expect(@AlertsService.alerts.messages).toEqual([])
