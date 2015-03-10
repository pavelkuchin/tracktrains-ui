class SessionService
  constructor: () ->
    @session =
      authorized: null
      user: {}

  get: () ->
    @session

  reset: () ->
    @session.authorized = false
    @session.user = {}

angular
  .module('trackSeatsApp')
  .service('SessionService', SessionService)
