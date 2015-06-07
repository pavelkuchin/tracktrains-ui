###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  Controller of the settings page.

  As User I should be able to change my password, invite friends,
  and delete my account (?).
###
class PagesSettingsCtrl
  constructor: (@$rootScope, @session, @DialogsService, @DataService,
                @AlertsService, @AuthService, @$state, @AUTH_EVENTS) ->
    @userName = @session.user.email.split("@")[0]
    @invitesCounter = @session.user.invites_counter

  deleteAccount: () ->
    @DialogsService.confirmation(
      "Do you really want delete your account?",
      "Attention, there is no way to undo this action. The invite will not be returned to the inviter."
    ).then () =>
      @DataService.deleteAccount(@session.user)
        .then () =>
          @$rootScope.$emit(AUTH_EVENTS.UNAUTHENTICATED)
          @AlertsService.showAlert(
            "Your account has been permanently removed. It was great to have you with us!"
            @AlertsService.TYPE.SUCCESS
          )
        .catch (msg) =>
          @AlertsService.showAlert(
            "Something went wrong. Please try later."
            @AlertsService.TYPE.ERROR
          )

  inviteFriend: (email) ->
    @DataService.inviteFriend(email)
      .then () =>
        @$state.reload()
        @AlertsService.showAlert(
          "An invitation letter has been sent for #{email}",
          @AlertsService.TYPE.SUCCESS,
          3000
        )
      .catch (err) =>
        @AlertsService.showAlert(
          "An invitation letter has not been sent because of '#{err.data}'"
          @AlertsService.TYPE.ERROR
        )

  changePassword: (newPassword, confirmPassword) ->
    if newPassword == confirmPassword
      @DialogsService.confirmationWithPassword("Change Your Password", "Do you really want change your password?")
      .then (currentPassword) =>
        @DataService.changePassword(currentPassword, newPassword)
          .then () =>
            @$state.reload()
            @AlertsService.showAlert(
              "Password has been changed.",
              @AlertsService.TYPE.SUCCESS,
              3000
            )
          .catch (err) =>
            @AlertsService.showAlert(
              "Password has not been changed because of '#{err.data}'",
              @AlertsService.TYPE.ERROR
            )

  getValidationClass: (field) ->
    if field?.$dirty
      if _.isEmpty(field.$error)
        ["has-success"]
      else
        ["has-error"]

angular
  .module('trackSeatsApp')
  .controller('PagesSettingsCtrl', PagesSettingsCtrl)

PagesSettingsCtrl.$inject = ['$rootScope', 'session', 'DialogsService', 'DataService',
                             'AlertsService', 'AuthService', '$state', 'AUTH_EVENTS']
