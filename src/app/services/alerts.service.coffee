class AlertsService
  constructor: (ALERTS_TYPE) ->
    @alerts =
      messages: []
    @TYPE = ALERTS_TYPE

  showAlert: (msg, type) ->
    @alerts.messages = [{msg: msg, type: type}]

  clearAlerts: () ->
    @alerts.messages = []

angular
  .module('trackSeatsApp')
  .service('AlertsService', AlertsService)

AlertsService.$inject = ['ALERTS_TYPE']
