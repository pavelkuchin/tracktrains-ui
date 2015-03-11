AUTH_EVENTS =
  'UNAUTHORIZED': 'unauthorized'
  'AUTHORIZED': 'authorized'

ALERTS_TYPE =
  'ERROR': 'danger'
  'SUCCESS': 'success'

angular
  .module('trackSeatsApp')
  .constant('AUTH_EVENTS', AUTH_EVENTS)
  .constant('ALERTS_TYPE', ALERTS_TYPE)
