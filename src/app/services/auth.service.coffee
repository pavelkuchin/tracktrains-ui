###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  The service is supporting authentification procedure

  In constructor it requested session from server (session is current user object)
  if response is successful then session.user is current user object and session.authenticated is true
  if response is fail then authenticated is false and user is still empty object

  Methods:
    checkAuthentication() - return the session as promise
    signIn(email, password) - trying to sign in user to the system, resolve session if success
    signOut() - sign user out of the system, reset session if success
    resetSession() - reset the session, session.authenticated is false and session.user is empty object
###
class AuthService
  constructor: (@dataService, @$q, @$rootScope, AUTH_EVENTS) ->
    @session =
      authenticated: null
      user: {}

    @deferredSession = @$q.defer()

    if @session.authenticated == null
      @dataService.getSession()
      .success (data) =>
        @session.user = data
        @session.authenticated = true
        @deferredSession.resolve(@session)
      .error (data) =>
        @session.authenticated = false
        @deferredSession.resolve(@session)
    else
      @deferredSession.resolve(@session)

  checkAuthentication: () ->
    @deferredSession.promise

  signIn: (email, password) ->
    @dataService.signIn(email, password)
    .then () =>
      @session.authenticated = true
      @dataService.getSession()
    .then ({data}) =>
      @session.user = data
      @$rootScope.$emit(AUTH_EVENTS.AUTHENTICATED)
      @session

  signOut: () ->
    @dataService.signOut().then () =>
      @resetSession()
      @$rootScope.$emit(AUTH_EVENTS.UNAUTHENTICATED)
    @session

  resetSession: () ->
    @session.authenticated = false
    @session.user = {}

angular
  .module('trackSeatsApp')
  .service('AuthService', AuthService)

AuthService.$inject = [
  'DataService', '$q', '$rootScope', 'AUTH_EVENTS'
]
