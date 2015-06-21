###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  Controller of the settings page.

  As User I should be able to change my password, invite friends,
  and delete my account.

  Methods:
    deleteAccount - call confirmation dialog and if user agrees to delete his account
                    account will be deleted. If an account was deleted succesfully then
                    emit UNAUTHENTICATED event (redirect to the landing page) and show
                    an appropriate message. If there is an error it will show an error message
    inviteFriend(email) - Send an invitation to the provided email and displays an success message if
                    message has been sent succesfully and an error message if message has not
                    been sent.
    changePassword(newPassword, confirmPassword) - if a new password and a confirmation of
                    a new password equals then displays confirmation dialog with password
                    field if user enters an password and clicks yes then send a request
                    to server to change a password.
    getValidationClass(field) - the method provides a css class related to the current field
                    state.
###
class PagesSettingsCtrl
  constructor: (@$rootScope, @session, @DialogsService, @DataService,
                @AlertsService, @$state, @AUTH_EVENTS) ->
    @userName = @session.user.email.split("@")[0]
    @invitesCounter = @session.user.invites_counter

  deleteAccount: () ->
    @DialogsService.confirmation(
      "Do you really want delete your account?",
      "Attention, there is no way to undo this action. The invitation will not be returned to the inviter."
    ).then () =>
      @DataService.deleteAccount(@session.user)
        .then () =>
          @$rootScope.$emit(@AUTH_EVENTS.UNAUTHENTICATED)
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
                             'AlertsService', '$state', 'AUTH_EVENTS']
