describe 'LayoutNavigationCtrl', () ->
  beforeEach(module('trackSeatsApp'))

  beforeEach(inject((@$rootScope, $controller, $httpBackend,
                     @$q, @ALERTS_TYPE, @NAVIGATION) =>
    $httpBackend.when('GET', '/v1/user/session/').respond({})
    $httpBackend.when('GET', 'app/pages/landing/pages.landing.template.html')
      .respond({})

    @emptySessionStub =
      authorized: false
      user: {}

    @stubState = jasmine.createSpyObj('$state', ['go'])

    @stubAlertsService = jasmine.createSpyObj('AlertsService', ['showAlert'])
    @stubAlertsService.TYPE = @ALERTS_TYPE

    @stubAuthService = jasmine.createSpyObj('AuthService', [
      'checkAuthentication'
      'signIn'
      'signOut'
    ])

    @stubAuthService.checkAuthentication.and.returnValue(@$q.when(@emptySessionStub))

    @scope = $rootScope.$new()
    @controller = $controller('LayoutNavigationCtrl',
      $scope: @scope
      AuthService: @stubAuthService
      AlertsService: @stubAlertsService
      $state: @stubState
    )
    @$rootScope.$digest()
  ))

  describe 'controller.session', () =>
    it 'session equals to session object from @authService.checkAuthentication() call', () =>
      expect(@controller.session).toEqual({authorized: false, user: {}})

  describe 'controller.navCollapsed', () =>
    it 'navCollapsed is true when initialized', () =>
      expect(@controller.navCollapsed).toEqual(true)
    it 'navCollapsed is changed by controller.toggleNavCollapsed()', () =>
      @controller.toggleNavCollapsed()
      expect(@controller.navCollapsed).toEqual(false)
      @controller.toggleNavCollapsed()
      expect(@controller.navCollapsed).toEqual(true)

  describe 'controller.signIn', () =>
    it 'if email or/and password are empty then message should be displayed', () =>

      @controller.email = ''
      @controller.password = ''
      @controller.signIn()

      expect(@stubAlertsService.showAlert)
        .toHaveBeenCalledWith(
          "Please enter email and password.",
          @ALERTS_TYPE.ERROR,
          3000
        )

    it 'if email or/and password are invalid then message should be displayed
        and email/password cleared', () =>
      @stubAuthService.signIn.and.callFake () =>
        prom = @$q.defer()
        prom.reject()
        prom.promise

      email = 'wrong@email.here'
      password = 'wrongpassword'

      @controller.email = email
      @controller.password = password
      @controller.signIn()

      @$rootScope.$digest()

      expect(@stubAuthService.signIn)
        .toHaveBeenCalledWith(email, password)

      expect(@stubAlertsService.showAlert).toHaveBeenCalledWith(
        "User with this email/password has not been found.",
        @ALERTS_TYPE.ERROR,
        3000)

      expect(@controller.email).toEqual('')
      expect(@controller.password).toEqual('')

    it 'if email and password are correct then state should be
        changed to AUTHENTICATED_DEFAULT_STATE and email/password cleared', () =>
      @stubAuthService.signIn.and.callFake () =>
        prom = @$q.defer()
        prom.resolve()
        prom.promise

      email = 'correct@email.here'
      password = 'correct password'

      @controller.email = email
      @controller.password = password
      @controller.signIn()

      @$rootScope.$digest()

      expect(@stubAuthService.signIn)
        .toHaveBeenCalledWith(email, password)

      expect(@stubState.go)
        .toHaveBeenCalledWith(@NAVIGATION.AUTHENTICATED_DEFAULT_STATE)

      expect(@controller.email).toEqual('')
      expect(@controller.password).toEqual('')

  describe 'controller.signOut', () =>
    it 'Should call authService.signOut and
        then go to UNAUTHENTICATED_DEFAULT_STATE', () =>

      @controller.signOut()



      expect(@stubAuthService.signOut).toHaveBeenCalled()

      expect(@stubState.go)
        .toHaveBeenCalledWith(@NAVIGATION.UNAUTHENTICATED_DEFAULT_STATE)
