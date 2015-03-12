class LayoutNavigationCtrl
  constructor: (@authService, @$state, @alertsService, @NAVIGATION) ->
    @navCollapsed = true
    @session = {}

    @email = ""
    @password = ""

    @authService.checkAuthentication().then (session) =>
      @session = session

  toggleNavCollapsed: () ->
    @navCollapsed = !@navCollapsed

  signIn: () ->
    if @email and @password
      @authService.signIn(@email, @password)
        .then () =>
          @$state.go(@NAVIGATION.AUTHENTICATED_DEFAULT_STATE)
        .finally () =>
          @email = ""
          @password = ""
    else
      @alertsService.showAlert(
        "Please enter email and password.",
        @alertsService.TYPE.ERROR
      )


  signOut: () ->
    @authService.signOut()
    @$state.go(@NAVIGATION.UNAUTHENTICATED_DEFAULT_STATE)

angular
  .module('trackSeatsApp')
  .controller('LayoutNavigationCtrl', LayoutNavigationCtrl)

LayoutNavigationCtrl.$inject = ['AuthService', '$state', 'AlertsService', 'NAVIGATION']
