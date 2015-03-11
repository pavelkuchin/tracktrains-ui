class SecurePages
  constructor: (session, $state) ->
    @session = session

angular
  .module('trackSeatsApp')
  .controller('SecurePages', SecurePages)

SecurePages.$inject = ['session', '$state']
