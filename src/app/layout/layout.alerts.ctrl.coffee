class LayoutAlertsCtrl
  constructor: (alertsService) ->
    @alerts = alertsService.alerts

  closeAlert: (index) ->
    @alerts.messages.splice(index, 1)

angular
  .module('trackSeatsApp')
  .controller('LayoutAlertsCtrl', LayoutAlertsCtrl)

LayoutAlertsCtrl.$inject = ['AlertsService']
