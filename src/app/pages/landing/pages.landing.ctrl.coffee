###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  Controller of the landing page

  Landing page like static now, only action is redirect in constructor
  because I was not able to find better way in ui-router

  The logic is pretty straightforward, if user is authenticated then we
  have to redirect him/her to the NAVIGATION.AUTHENTICATED_DEFAULT_STATE

###
class PagesLandingCtrl
  constructor: (session, $state, @NAVIGATION) ->
    if session.authenticated
      $state.go(@NAVIGATION.AUTHENTICATED_DEFAULT_STATE)

angular
  .module('trackSeatsApp')
  .controller('PagesLandingCtrl', PagesLandingCtrl)

PagesLandingCtrl.$inject = ['session', '$state', 'NAVIGATION']
