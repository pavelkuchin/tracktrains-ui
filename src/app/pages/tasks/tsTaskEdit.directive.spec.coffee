# Disabled because unittests for directives is extra efforts at the point
xdescribe 'tsTaskEdit', () ->
  beforeEach(module('trackSeatsApp'))

  beforeEach inject (@$compile, $rootScope, $httpBackend) =>
    $httpBackend.when('GET', '/v1/user/session/').respond({})
    @scope = $rootScope.$new()

  it 'The form has values that we set to model', () =>
    @scope.task =
      resource_uri: 'test_uri'
      departure_date: '15-11-2014'
      departure_point: 'Gomel'
      destination_point: 'Minsk'
      train: 'E451'
      car: 'ANY'
      seat: 'ANY'
      is_active: true
      owner: 'test_user'

    element = @$compile('<ts-task-edit task="task"></ts-task-edit>')(@scope)

    @scope.$digest()

    html = element.html()

    expect(html).toContain(@scope.task.departure_date)
    expect(html).toContain(@scope.task.departure_point)
    expect(html).toContain(@scope.task.destination_point)
    expect(html).toContain(@scope.task.train)
