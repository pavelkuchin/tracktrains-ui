describe 'DataService', () ->
  beforeEach(module('trackSeatsApp'))

  beforeEach inject (@DataService, @$httpBackend) =>

  it 'signIn', () =>
    login = 'test login'
    password = 'test password'
    @DataService.signIn(login, password)

    @$httpBackend.expectPOST('/v1/user/login/',
      login: login,
      password: password
    ).respond({})

  it 'signOut', () =>
    @DataService.signOut()

    @$httpBackend.expectPOST('/v1/user/logout/')

  it 'getSession', () =>
    @DataService.getSession()

    @$httpBackend.expectGET('/v1/user/session/')

  it 'getTasks', () =>
    @DataService.getTasks()

    @$httpBackend.expectGET('/v1/byrwtask/')

  it 'disableTask', () =>
    task =
      resource_uri: 'test_uri'

    @DataService.disableTask(task)

    @$httpBackend.expectPATCH('test_uri', {is_active: false})

  it 'enableTask', () =>
    task =
      resource_uri: 'test_uri'

    @DataService.enableTask(task)

    @$httpBackend.expectPATCH('test_uri', {is_active: true})

  it 'deleteTask', () =>
    task =
      resource_uri: 'test_uri'

    @DataService.deleteTask(task)

    @$httpBackend.expectDELETE('test_uri')

  it 'saveTask creates a new', () =>
    task =
      data: 'some data'

    @DataService.saveTask(task)

    @$httpBackend.expectPOST('/v1/byrwtask/', task)

  it 'saveTask modifies an existing', () =>
    task =
      resource_uri: 'test_uri'
      data: 'some data'

    @DataService.saveTask(task)

    @$httpBackend.expectPOST('test_uri', task)

  it 'getStation', () =>
    @DataService.getStation('test')

    @$httpBackend.expectGET('/v1/byrwgateway/station/test/')

  it 'getTrains', () =>
    @DataService.getTrain('10-10-2015', 'dep', 'dest', 'quer')

    @$httpBackend.expectGET('/v1/byrwgateway/train/?date=10-10-2015' +
                            '&departure_point=dep' +
                            '&destination_point=dest' +
                            '&query=quer')
