###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  Controller of the settings page.

  As User I should be able to change my password, invite friends,
  and delete my account (?).
###
class PagesSettingsCtrl
  constructor: (@session) ->
    @userName = @session.user.email.split("@")[0]
    @invitesCounter = @session.user.invites_counter
    console.log(@invitesCounter)

  deleteAccount: () ->
    console.log("Delete this account.")

  inviteFriend: (email) ->
    console.log("Sent invitation to email #{email}")

  changePassword: (password, confirmPassword) ->
    console.log("Change password to #{password}, confirmation equals #{confirmPassword}")

  getValidationClass: (field) ->
    if field?.$dirty
      if _.isEmpty(field.$error)
        ["has-success"]
      else
        ["has-error"]

angular
  .module('trackSeatsApp')
  .controller('PagesSettingsCtrl', PagesSettingsCtrl)

PagesSettingsCtrl.$inject = ['session', 'AlertsService']
