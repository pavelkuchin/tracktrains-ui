class LayoutAlertsCtrl
  constructor: (alertsService) ->
    @alerts = alertsService.alerts
    @TYPE = ALERTS_TYPE

  closeAlert: (index) ->
    @alerts.messages.splice(index, 1)

angular
  .module('trackSeatsApp')
  .controller('LayoutAlertsCtrl', LayoutAlertsCtrl)

LayoutAlertsCtrl.$inject = ['AlertsService']
