class LayoutNavigationCtrl
  constructor: (@authService, @$state, @alertsService) ->
    @navCollapsed = true
    @session = {}

    @email = ""
    @password = ""

    @authService.checkAuthorization().then (session) =>
      @session = session

  toggleNavCollapsed: () ->
    @navCollapsed = !@navCollapsed

  signIn: () ->
    if @email and @password
      @authService.signIn(@email, @password)
        .then () =>
          @$state.go('tasks')
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
    @$state.go('landing')

angular
  .module('trackSeatsApp')
  .controller('LayoutNavigationCtrl', LayoutNavigationCtrl)

LayoutNavigationCtrl.$inject = ['AuthService', '$state', 'AlertsService']
