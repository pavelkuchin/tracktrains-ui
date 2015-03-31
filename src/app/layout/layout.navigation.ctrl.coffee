###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  Navigation controller (part of layout)
  is responsible for responsive menu support (collapsed menu)
                 appropriate menu representation (sign in form for unauthenticated)
                                                 (user menu for authenticated)
                 sign in and sign out actions

  Should expose:
  session variable like {authenticated: true, user: {see user resource}}
  toggleNavCollapsed method just toggle navCollapsed variable
  signIn method:
      check email and password variables and if empty then show alert
      if email and password are setted and call signIn method of authService
        if success then go to the AUTHENTICATED_DEFAULT_STATE
        if error then show alert
        should clear email and password at the end (for any result)
  signOut method:
      call authService.signOut method
      and then go to the UNAUTHENTICATED_DEFAULT_STATE
###
class LayoutNavigationCtrl
  constructor: (@authService, @$state, @alertsService, @NAVIGATION) ->
    @navCollapsed = true
    @session = {}

    @email = ''
    @password = ''

    @authService.checkAuthentication().then (session) =>
      @session = session

  toggleNavCollapsed: () ->
    @navCollapsed = !@navCollapsed

  signIn: () ->
    if @email and @password
      @authService.signIn(@email, @password)
        .then () =>
          @$state.go(@NAVIGATION.AUTHENTICATED_DEFAULT_STATE)
        .catch (reason) =>
          @alertsService.showAlert(
            'User with this email/password has not been found.',
            @alertsService.TYPE.ERROR
          )
        .finally () =>
          @email = ''
          @password = ''
    else
      @alertsService.showAlert(
        'Please enter email and password.',
        @alertsService.TYPE.ERROR
      )

  signOut: () ->
    @authService.signOut()
    @$state.go(@NAVIGATION.UNAUTHENTICATED_DEFAULT_STATE)

angular
  .module('trackSeatsApp')
  .controller('LayoutNavigationCtrl', LayoutNavigationCtrl)

LayoutNavigationCtrl.$inject = ['AuthService', '$state', 'AlertsService', 'NAVIGATION']
