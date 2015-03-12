AUTH_EVENTS =
  'UNAUTHENTICATED': 'unauthenticated'
  'AUTHENTICATED': 'authenticated'

ALERTS_TYPE =
  'ERROR': 'danger'
  'SUCCESS': 'success'

NAVIGATION =
  'AUTHENTICATED_DEFAULT_STATE': 'tasks'
  'UNAUTHENTICATED_DEFAULT_STATE': 'landing'

angular
  .module('trackSeatsApp')
  .constant('AUTH_EVENTS', AUTH_EVENTS)
  .constant('ALERTS_TYPE', ALERTS_TYPE)
  .constant('NAVIGATION', NAVIGATION)
