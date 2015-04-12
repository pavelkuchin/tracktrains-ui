# Commented out because for now I can't find a way to implement the test for
# service with reference to another server which methods return promise
###
describe 'AuthService', () ->

  beforeEach(module('trackSeatsApp'))

  beforeEach inject ($q, @$rootScope, @AUTH_EVENTS, $httpBackend, $injector) =>
    $httpBackend.when('GET', '/v1/user/session/').respond({})
    $httpBackend.when('GET', 'app/pages/landing/pages.landing.template.html')
      .respond({})

    @stubDataService = jasmine.createSpyObj('DataService', [
      'getSession',
      'signIn',
      'signOut'
    ])

    @stubDataService.getSession.and.returnValue($q.when(
      login: 'test_login'
      data: 'It is not real user object'
    ))

    @stubDataService.signIn.and.returnValue($q.when())

    @stubDataService.signOut.and.returnValue($q.when())

    @service = $controller('AuthService',
      DataService: @stubDataService
    )

  it 'checkAuthentication returns session through promise with success', () =>
    session = @service.checkAuthentication()
    @$rootScope.$digest()

    except(@stubDataService.getSession).toHaveBeenCalled()

    expect(session.authenticated).toEqual(true)
    expect(session.user.login).toEqual('test_login')

  it 'signIn: dataService.signIn and dataService.getSession have been called,
      AUTH_EVENTS.AUTHENTICATED has been emitted', () =>

    session = @service.signIn('test_login', 'test_password')
    @$rootScope.$digest()

    expect(@stubDataService.signIn).toHaveBeenCalledWith('test_login', 'test_password')
    expect(@stubDataService.getSession).toHaveBeenCalled()
    #expect(@stubRootScope.$emit).toHaveBeenCalledWith(@AUTH_EVENTS.AUTHENTICATED)

    expect(session.authenticated).toEqual(true)
    expect(session.user.login).toEqual('test_login')

  it 'signOut: dataService.signOut() has been called, session was cleared,
      AUTH_EVENTS.UNAUTHENTICATED emitted', () =>

    @service.signOut()
    session = @service.checkAuthentication()
    @$rootScope.$digest()

    expect(@stubDataService.signOut).toHaveBeenCalled()
    #expect(@stubRootScope.$emit).toHaveBeenCalledWith(@AUTH_EVENTS.UNAUTHENTICATED)

    expect(session.authenticated).toEqula(false)
    expect(session.user).toEqual({})

  it 'resetSession: session has been cleared', () =>

    session = @service.checkAuthentication()
    @$rootScope.$digest()

    expect(session.authenticated).toEqual(true)
    expect(session.user.login).toEqual('test_login')

    @service.resetSession()
    @$rootScope.$digest()

    expect(session.authenticated).toEqual(false)
    expect(session.user).toEqual({})
###
