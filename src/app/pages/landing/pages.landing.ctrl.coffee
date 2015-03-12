class PagesLandingCtrl
  constructor: (session, $state, @NAVIGATION) ->
    if session.authenticated
      $state.go(@NAVIGATION.AUTHENTICATED_DEFAULT_STATE)

angular
  .module('trackSeatsApp')
  .controller('PagesLandingCtrl', PagesLandingCtrl)

PagesLandingCtrl.$inject = ['session', '$state', 'NAVIGATION']
