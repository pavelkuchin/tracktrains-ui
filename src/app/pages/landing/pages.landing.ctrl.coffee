class PagesLandingCtrl
  constructor: (session, $state) ->
    if session.authorized
      $state.go('tasks')

angular
  .module('trackSeatsApp')
  .controller('PagesLandingCtrl', PagesLandingCtrl)

PagesLandingCtrl.$inject = ['session', '$state']
