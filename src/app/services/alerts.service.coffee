###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  The alert messages service

  The service intended to store and manage error and success messages

  The LayoutAlertsCtrl controllers directly access AlertsService.alerts.messages data structure
  in order to get current message (for now it displayed only one message)

  Methods:
    showAlerts(msg, type) - store message (LayoutAlertsCtrl will get it by link)
                            msg is a string message
                            type is a member of AlertsService.TYPE or ALERTS_TYPE
                            REPLACING existing message
    clearAlerts() - should clear all messages
###
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
