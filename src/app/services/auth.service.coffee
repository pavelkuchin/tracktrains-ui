class AuthService
  constructor: (@dataService, @$q, @$rootScope, @alertsService) ->
    @session =
      authenticated: null
      user: {}

    @deferred = @$q.defer()
    if @session.authenticated == null
      @dataService.getSession()
      .success (data) =>
        @session.user = data
        @session.authenticated = true
        @deferred.resolve(@session)
      .error (data) =>
        @session.authenticated = false
        @deferred.resolve(@session)
    else
      @deferred.resolve(@session)

  checkAuthentication: () ->
    @deferred.promise

  signIn: (email, password) ->
    @dataService.signIn(email, password)
    .then () =>
      @session.authenticated = true
      @dataService.getSession()
    .then ({data}) =>
      @session.user = data
      @$rootScope.$emit(AUTH_EVENTS.AUTHENTICATED)
      @session
    .catch () =>
      @alertsService.showAlert("Check your email and password.", @alertsService.TYPE.ERROR)

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
  'DataService', '$q', '$rootScope',
  'AlertsService'
]
