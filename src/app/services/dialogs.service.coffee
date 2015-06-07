###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  The dialogs service provides an interface to call different dialog
  (like confirmation dialog)

  Methods:
    confirmation(header, text) - this method opens a confirmation dialog
                                   that contains the text and header
                                   returns a resolved promise if it was accepted by user
                                   or rejected promise if user did reject it
###
class DialogsService
  constructor: (@$rootScope, @$modal) ->

  confirmation: (header, text) ->
    isolatedScope = @$rootScope.$new(true)
    isolatedScope.header = header
    isolatedScope.text = text

    @$modal.open(
      scope: isolatedScope
      templateUrl: 'app/services/dialogs.confirmation.template.html'
    ).result

  confirmationWithPassword: (header, text) ->
    isolatedScope = @$rootScope.$new(true)
    isolatedScope.header = header
    isolatedScope.text = text

    @$modal.open(
      scope: isolatedScope
      templateUrl: 'app/services/dialogs.confirmationWithPassword.template.html'
    ).result

angular
  .module('trackSeatsApp')
  .service('DialogsService', DialogsService)

DialogsService.$inject = ["$rootScope", "$modal"]
