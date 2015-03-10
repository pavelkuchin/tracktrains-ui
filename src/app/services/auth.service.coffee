class AuthService
  constructor: (@dataService, @sessionService, @$q, @$rootScope) ->
    @session = @sessionService.get()

  checkAuthorization: () ->
    deferred = @$q.defer()
    if @session.authorized == null
      @dataService.getSession()
      .success (data) =>
        @session.user = data
        @session.authorized = true
        deferred.resolve(@session)
      .error (data) =>
        @session.authorized = false
        deferred.resolve(@session)
    else
      deferred.resolve(@session)
    deferred.promise

  signIn: (email, password) ->
    @dataService.signIn(email, password)
    .then () =>
      @session.authorized = true
      @dataService.getSession()
    .then ({data}) =>
      @session.user = data
      @$rootScope.$emit(AUTH_EVENTS.AUTHORIZED)
    @session

  signOut: () ->
    @dataService.signOut().then () =>
      @resetSession()
      @$rootScope.$emit(AUTH_EVENTS.UNAUTHORIZED)
    @session

  resetSession: () ->
    @sessionService.reset()

angular
  .module('trackSeatsApp')
  .service('AuthService', AuthService)

AuthService.$inject = ['DataService', 'SessionService', '$q', '$rootScope']
