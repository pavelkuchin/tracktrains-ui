class LayoutNavigationCtrl
  constructor: (@authService, @$state) ->
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
      @email = ""
      @password = ""
      @$state.go('tasks')
    else
      console.log("Please enter email and password")

  signOut: () ->
    @authService.signOut()
    @$state.go('landing')

angular
  .module('trackSeatsApp')
  .controller('LayoutNavigationCtrl', LayoutNavigationCtrl)

LayoutNavigationCtrl.$inject = ['AuthService', '$state']
