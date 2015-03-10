class SecurePages
  constructor: (session, $state) ->
    @session = session

    console.log @session.authorized

angular
  .module('trackSeatsApp')
  .controller('SecurePages', SecurePages)

SecurePages.$inject = ['session', '$state']
