###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  Alerts messages controller (Part of layout)
  All messages which you can send through AlertsService
  will be displayed between header and content sections

  Controller exposes:
    'alerts' - object like {messages: [{msg:'test', type: 'type'}]}
    'closeAlert(index)' - you should call it with right index in order to close
###
class LayoutAlertsCtrl
  constructor: (alertsService) ->
    @alerts = alertsService.alerts

  closeAlert: (index) ->
    @alerts.messages.splice(index, 1)

angular
  .module('trackSeatsApp')
  .controller('LayoutAlertsCtrl', LayoutAlertsCtrl)

LayoutAlertsCtrl.$inject = ['AlertsService']
