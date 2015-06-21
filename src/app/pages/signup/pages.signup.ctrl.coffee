###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  Controller of the signup page
###
class PagesSignupCtrl
  constructor: (@$state, @DataService, @AlertsService, @NAVIGATION) ->

  getValidationClass: (field) ->
    if field?.$dirty
      if _.isEmpty(field.$error)
        ["has-success"]
      else
        ["has-error"]

  registration: (passwordModel, confirmPasswordModel) ->
    invite = @$state.params.invite
    if passwordModel != confirmPasswordModel
      @AlertsService.showAlert(
        "Password and password confirmation are not equal."
        @AlertsService.TYPE.ERROR
      )
    else if not invite
      @AlertsService.showAlert(
        "Encrypted invitation does not found."
        @AlertsService.TYPE.ERROR
      )
    else
      @DataService.signup(invite, passwordModel)
      .then (data) =>
        console.log('data: ', data)
        @$state.go(@NAVIGATION.UNAUTHENTICATED_DEFAULT_STATE)
        @AlertsService.showAlert(
          "Welcome on board! Please enter your email and password above."
          @AlertsService.TYPE.SUCCESS
          3000
        )
      .catch (msg) =>
        @AlertsService.showAlert(
          "Something went wrong: #{msg.data}."
          @AlertsService.TYPE.ERROR
        )
angular
  .module('trackSeatsApp')
  .controller('PagesSignupCtrl', PagesSignupCtrl)

PagesSignupCtrl.$inject = ['$state', 'DataService', 'AlertsService', 'NAVIGATION']
