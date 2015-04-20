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
                            howLong parameter detemines how long a message will persist
                            if 0 then only user is able to close it.
    clearAlerts() - should clear all messages
###
class AlertsService
  constructor: (ALERTS_TYPE, @$timeout) ->
    @alerts =
      messages: []
    @TYPE = ALERTS_TYPE

  showAlert: (msg, type, howLong=0) ->
    msg = {msg: msg, type: type}
    @alerts.messages.push msg
    if howLong
      @$timeout( () =>
        _.remove(@alerts.messages, msg)
      ,
        howLong
      )

  clearAlerts: () ->
    @alerts.messages = []

angular
  .module('trackSeatsApp')
  .service('AlertsService', AlertsService)

AlertsService.$inject = ['ALERTS_TYPE', '$timeout']
