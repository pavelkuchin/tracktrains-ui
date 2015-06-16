describe 'PagesSettingsCtrl', () ->
  beforeEach(module('trackSeatsApp'))


  beforeEach(inject((@$rootScope, $controller, $httpBackend, @ALERTS_TYPE, @$q) =>
    $httpBackend.when('GET', '/v1/user/session/').respond({})
    $httpBackend.when('GET', 'app/pages/landing/pages.landing.template.html')
      .respond({})

    @stubAlertsService = jasmine.createSpyObj('AlertsService', ['showAlert'])
    @stubAlertsService.TYPE = @ALERTS_TYPE

    @stubDialogsService = jasmine.createSpyObj('DialogsService', [
      'confirmation',
      'confirmationWithPassword'
    ])

    @stubDataService = jasmine.createSpyObj('DataService', [
      'deleteAccount',
      'inviteFriend',
      'changePassword'
    ])

    @stubState = jasmine.createSpyObj('$state', [
      'reload'
    ])

    @stubSession =
      user:
        email: "stub@user"

    @scope = $rootScope.$new()
    @controller = $controller('PagesSettingsCtrl',
      $scope: @scope
      AlertsService: @stubAlertsService
      DataService: @stubDataService
      DialogsService: @stubDialogsService
      session: @stubSession
      $state: @stubState
    )
  ))


  describe 'controller.deleteAccount', () =>
    it 'should send a request to server, perform a logout and shows a message if method was calles
        and dialog was confirmed', () =>
      @stubDialogsService.confirmation.and.returnValue(@$q.when())
      @stubDataService.deleteAccount.and.returnValue(@$q.when())

      @controller.deleteAccount()

      @$rootScope.$digest()

      expect(@stubDialogsService.confirmation).toHaveBeenCalled()

      expect(@stubDataService.deleteAccount).toHaveBeenCalledWith(@stubSession.user)

      expect(@stubAlertsService.showAlert).toHaveBeenCalledWith(
        "Your account has been permanently removed. It was great to have you with us!"
        @ALERTS_TYPE.SUCCESS
      )

    it 'should not send a request to server if method was calles but a dialog was not confirmed', () =>
      @stubDialogsService.confirmation.and.callFake(() =>
        p = @$q.defer()
        p.reject('')
        p.promise
      )

      @controller.deleteAccount()

      @$rootScope.$digest()

      expect(@stubDialogsService.confirmation).toHaveBeenCalled()

    it 'should show error message if method was called and confirmed but request to server was failed', () =>
      @stubDialogsService.confirmation.and.returnValue(@$q.when())

      @stubDataService.deleteAccount.and.callFake(() =>
        p = @$q.defer()
        p.reject('')
        p.promise
      )

      @controller.deleteAccount()

      @$rootScope.$digest()

      expect(@stubDialogsService.confirmation).toHaveBeenCalled()

      expect(@stubDataService.deleteAccount).toHaveBeenCalledWith(@stubSession.user)

      expect(@stubAlertsService.showAlert).toHaveBeenCalledWith(
        "Something went wrong. Please try later."
        @ALERTS_TYPE.ERROR
      )


  describe 'controller.inviteFriend', () =>
    it 'should send a request to add a friend and shows a success message if method was called', () =>
      testEmail = 'test@test.ts'

      @stubDataService.inviteFriend.and.returnValue(@$q.when())

      @controller.inviteFriend(testEmail)

      @$rootScope.$digest()

      expect(@stubDataService.inviteFriend).toHaveBeenCalledWith(testEmail)

      expect(@stubState.reload).toHaveBeenCalled()

      expect(@stubAlertsService.showAlert).toHaveBeenCalledWith(
        "An invitation letter has been sent for #{testEmail}",
        @ALERTS_TYPE.SUCCESS,
        3000
      )

    it 'should show a fault message if method was called but result from server is negative', () =>
      testEmail = 'test@test.ts'
      testError =
        data: 'test error'

      @stubDataService.inviteFriend.and.callFake () =>
        p = @$q.defer()
        p.reject(testError)
        p.promise

      @controller.inviteFriend(testEmail)

      @$rootScope.$digest()

      expect(@stubDataService.inviteFriend).toHaveBeenCalledWith(testEmail)

      expect(@stubAlertsService.showAlert).toHaveBeenCalledWith(
        "An invitation letter has not been sent because of '#{testError.data}'"
        @ALERTS_TYPE.ERROR
      )


  describe 'controller.changePassword', () =>
    it 'should send a request to change a password and shows a message if user enter
        a new password and confirmed his action by enter the current password', () =>
      @stubDialogsService.confirmationWithPassword.and.returnValue(@$q.when('test'))
      @stubDataService.changePassword.and.returnValue(@$q.when())

      @controller.changePassword("new_password", "new_password")

      @$rootScope.$digest()

      expect(@stubDialogsService.confirmationWithPassword).toHaveBeenCalled()

      expect(@stubDataService.changePassword).toHaveBeenCalledWith("test", "new_password")

      expect(@stubState.reload).toHaveBeenCalled()

      expect(@stubAlertsService.showAlert).toHaveBeenCalledWith(
        "Password has been changed.",
        @ALERTS_TYPE.SUCCESS,
        3000
      )

    it 'should not send a request to change the password if origin and confiramtion are different', () =>
      @stubDialogsService.confirmationWithPassword.and.returnValue(@$q.when('test'))
      @stubDataService.changePassword.and.returnValue(@$q.when())

      @controller.changePassword("new_password", "incorrect_new_password")

      @$rootScope.$digest()

    it 'should send a request to change the password and if result is fail then error message should appear', () =>
      testError =
        data: "testError"

      @stubDialogsService.confirmationWithPassword.and.returnValue(@$q.when('test'))
      @stubDataService.changePassword.and.callFake () =>
        p = @$q.defer()
        p.reject(testError)
        p.promise

      @controller.changePassword("new_password", "new_password")

      @$rootScope.$digest()

      expect(@stubDialogsService.confirmationWithPassword).toHaveBeenCalled()

      expect(@stubDataService.changePassword).toHaveBeenCalledWith("test", "new_password")

      expect(@stubAlertsService.showAlert).toHaveBeenCalledWith(
        "Password has not been changed because of '#{testError.data}'"
        @ALERTS_TYPE.ERROR
      )


  describe 'controller.getValidationClass', () =>
    it 'should return nothing if field is clear (not dirty)', () =>
      fakeField =
        $dirty: false
        $error: {}

      result = @controller.getValidationClass(fakeField)

      expect(result).toBeUndefined()

    it 'should return "has-success" class if field is durty and $error object is clear', () =>
      fakeField =
        $dirty: true
        $error: {}

      result = @controller.getValidationClass(fakeField)

      expect(result).toEqual(["has-success"])

    it 'should return "has-error" class if field is durty and $error object is not clear', () =>
      fakeField =
        $dirty: true
        $error:
           testError: true

      result = @controller.getValidationClass(fakeField)

      expect(result).toEqual(["has-error"])
