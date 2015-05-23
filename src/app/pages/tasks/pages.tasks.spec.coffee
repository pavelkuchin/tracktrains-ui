describe 'PagesTasksCtrl', () ->
  beforeEach(module('trackSeatsApp'))

  beforeEach(inject((@$rootScope, $controller, DataService, $httpBackend,
                     @$q, @ALERTS_TYPE, @NAVIGATION) =>
    $httpBackend.when('GET', '/v1/user/session/').respond({})
    $httpBackend.when('GET', 'app/pages/landing/pages.landing.template.html')
      .respond({})

    @stubSession =
      user:
        resource_uri: 'not_real_user_resource_uri_just_for_test',
        tasks_limit: 4

    @stubAlertsService = jasmine.createSpyObj('AlertsService', ['showAlert'])
    @stubAlertsService.TYPE = @ALERTS_TYPE

    @stubDialogsService = jasmine.createSpyObj('DialogsService', ['confirmation'])

    @stubDataService = jasmine.createSpyObj('DataService', [
      'getTasks',
      'saveTask',
      'disableTask',
      'enableTask',
      'deleteTask',
      'getStation',
      'getTrain'
    ])

    @expectedInitialTasksList = [
        name: 'test1'
        departure_point: 'from_test'
        destination_point: 'to_test'
        somefield: 'test data'
        resource_uri: 'fake1'
      ,
        name: 'test2'
        departure_point: 'from_test'
        destination_point: 'to_test'
        somefield: 'test data'
        resource_uri: 'fake2'
      ,
        name: 'test3'
        departure_point: 'from_test'
        destination_point: 'to_test'
        somefield: 'test data'
        resource_uri: 'fake3'
      ,
        name: 'test4'
        departure_point: 'from_test'
        destination_point: 'to_test'
        somefield: 'test data'
        resource_uri: 'fake4'
      ,
        name: 'test5'
        departure_point: 'from_test'
        destination_point: 'to_test'
        somefield: 'test data'
        resource_uri: 'fake5'
      ,
        name: 'test6'
        departure_point: 'from_test'
        destination_point: 'to_test'
        somefield: 'test data'
        resource_uri: 'fake6'
      ,
        name: 'test7'
        departure_point: 'from_test'
        destination_point: 'to_test'
        somefield: 'test data'
        resource_uri: 'fake7'
      ,
        name: 'test8'
        departure_point: 'from_test'
        destination_point: 'to_test'
        somefield: 'test data'
        resource_uri: 'fake8'
    ]

    @expectedTasksList = [
      [
          name: 'test1'
          departure_point: 'from_test'
          destination_point: 'to_test'
          somefield: 'test data'
          resource_uri: 'fake1'
        ,
          name: 'test2'
          departure_point: 'from_test'
          destination_point: 'to_test'
          somefield: 'test data'
          resource_uri: 'fake2'
        ,
          name: 'test3'
          departure_point: 'from_test'
          destination_point: 'to_test'
          somefield: 'test data'
          resource_uri: 'fake3'
        ,
          name: 'test4'
          departure_point: 'from_test'
          destination_point: 'to_test'
          somefield: 'test data'
          resource_uri: 'fake4'
      ],
      [
          name: 'test5'
          departure_point: 'from_test'
          destination_point: 'to_test'
          somefield: 'test data'
          resource_uri: 'fake5'
        ,
          name: 'test6'
          departure_point: 'from_test'
          destination_point: 'to_test'
          somefield: 'test data'
          resource_uri: 'fake6'
        ,
          name: 'test7'
          departure_point: 'from_test'
          destination_point: 'to_test'
          somefield: 'test data'
          resource_uri: 'fake7'
        ,
          name: 'test8'
          departure_point: 'from_test'
          destination_point: 'to_test'
          somefield: 'test data'
          resource_uri: 'fake8'
      ]
    ]

    @stubDataService.getTasks.and.returnValue(@$q.when(
      data:
        objects: @expectedInitialTasksList
    ))

    @scope = $rootScope.$new()
    @controller = $controller('PagesTasksCtrl',
      $scope: @scope
      AlertsService: @stubAlertsService
      DataService: @stubDataService
      DialogsService: @stubDialogsService
      session: @stubSession
    )

  ))

  describe 'controller.constructor', () =>
    it 'tasksList and initialTasksList are empty arrays before answer from server', () =>
      expect(@controller.initialTasksList).toEqual([])
      expect(@controller.tasksList).toEqual([])

    it 'after server answered the initialTasksList has the data from server
        and tasksList has the data chunked by 4', () =>

      @$rootScope.$digest()

      expect(@stubDataService.getTasks).toHaveBeenCalled()
      expect(@controller.initialTasksList).toEqual(@expectedInitialTasksList)
      expect(@controller.tasksList).toEqual(@expectedTasksList)

  describe 'controller.createTask', () =>
    it 'controller.newTask is a properly initialized task object', () =>
      @controller.createTask()

      expect(@controller.newTask).toEqual(
        resource_uri: ''
        departure_date: ''
        departure_point: ''
        destination_point: ''
        train: ''
        car: 'ANY'
        seat: 'ANY'
        is_active: true
        owner: @stubSession.user.resource_uri
      )

    it 'controller.createNewTask is setted to true', () =>
      @controller.createTask()

      expect(@controller.createNewTask).toEqual(true)

    it 'controller.createNewTask shows and error if tasks count exceed the limit', () =>

      @$rootScope.$digest()

      @controller.createTask()

      expect(@stubAlertsService.showAlert).toHaveBeenCalledWith(
        "Sorry, but the current system limitation is no more then 4 tasks per user.",
        @ALERTS_TYPE.ERROR,
        3000
      )

      expect(@controller.createNewTask).toEqual(false)

  describe 'controller.save', () =>
    it 'dataService.saveTask(task) was called for edit and alert showed', () =>
      # Tatypie by default does not return created object back, lets emulate similar behavior
      @stubDataService.saveTask.and.returnValue(@$q.when())

      # We do not need the real structure for test, only name and resource_uri will
      # be enough
      testObj =
        name: 'test name'
        resource_uri: 'fake_task_resource'

      @controller.save(testObj)

      @$rootScope.$digest()

      expect(@stubDataService.saveTask).toHaveBeenCalledWith(testObj)
      expect(@stubAlertsService.showAlert).toHaveBeenCalledWith(
        "The task successfully saved!"
        @ALERTS_TYPE.SUCCESS,
        3000
      )

    it 'dataService.saveTask(task) was called for creating a new item and alert was showed', () =>
      # Tatypie by default does not return created object back, lets emulate similar behavior
      @stubDataService.saveTask.and.returnValue(@$q.when())

      # We do not need the real structure for test, only name and resource_uri will
      # be enough, resource_uri is empty string because this is a new object
      testObj =
        name: 'test name'
        somefield: 'test data'
        resource_uri: ''

      extInitialTasksList = angular.copy(@expectedInitialTasksList)
      extTasksList = angular.copy(@expectedTasksList)

      extInitialTasksList.push(testObj)
      extTasksList.push([testObj])

      @stubDataService.getTasks.and.returnValue(@$q.when(
        data:
          objects: extInitialTasksList
      ))

      @controller.save(testObj)

      @$rootScope.$digest()

      expect(@stubDataService.saveTask).toHaveBeenCalledWith(testObj)
      expect(@stubAlertsService.showAlert).toHaveBeenCalledWith(
        "The task successfully saved!"
        @ALERTS_TYPE.SUCCESS,
        3000
      )

      expect(@stubDataService.getTasks).toHaveBeenCalled()
      expect(@controller.initialTasksList).toEqual(extInitialTasksList)
      expect(@controller.tasksList).toEqual(extTasksList)


  describe 'controller.disable(task)', () =>
    it 'dataService.disableTask(task) call is success and task.is_active is true', () =>
      @stubDataService.disableTask.and.returnValue(@$q.when())

      task =
        name: 'test'
        resource_uri: 'test'
        is_active: true

      @controller.disable(task)

      @$rootScope.$digest()

      expect(@stubDataService.disableTask).toHaveBeenCalledWith(task)
      expect(task.is_active).toEqual(false)

    it 'dataService.disableTask(task) call is failed and task.is_active is not changed', () =>
      @stubDataService.disableTask.and.callFake(() =>
        p = @$q.defer()
        p.reject('')
        p.promise
      )

      task =
        name: 'test'
        resource_uri: 'test'
        is_active: true

      @controller.disable(task)

      @$rootScope.$digest()

      expect(@stubDataService.disableTask).toHaveBeenCalledWith(task)
      expect(task.is_active).toEqual(true)


  describe 'controller.enable(task)', () =>
    it 'dataService.enableTask(task) call is success and task.is_active is true', () =>
      @stubDataService.enableTask.and.returnValue(@$q.when())

      task =
        name: 'test'
        resource_uri: 'test'
        is_active: false

      @controller.enable(task)

      @$rootScope.$digest()

      expect(@stubDataService.enableTask).toHaveBeenCalledWith(task)
      expect(task.is_active).toEqual(true)

    it 'dataService.enableTask(task) call is failed and task.is_active is not changed', () =>
      @stubDataService.enableTask.and.callFake(() =>
        p = @$q.defer()
        p.reject('')
        p.promise
      )

      task =
        name: 'test'
        resource_uri: 'test'
        is_active: false

      @controller.enable(task)

      @$rootScope.$digest()

      expect(@stubDataService.enableTask).toHaveBeenCalledWith(task)
      expect(task.is_active).toEqual(false)


  describe 'controller.delete(task)', () =>
    it 'if dataService.deleteTask(task) succesfully completed then remove item
        from initialTasksList and re-chunk it to tasksList', () =>
      @stubDataService.deleteTask.and.returnValue(@$q.when())
      @stubDialogsService.confirmation.and.returnValue(@$q.when())

      deletedItem = angular.copy(@expectedInitialTasksList[0])

      @$rootScope.$digest()

      expect(@controller.initialTasksList[0].name).toEqual('test1')
      expect(@controller.tasksList[0][0].name).toEqual('test1')

      task = @expectedInitialTasksList[0]

      @controller.delete(task)

      @$rootScope.$digest()

      expect(@stubDialogsService.confirmation).toHaveBeenCalledWith(
        "Do you really want delete the task #{task.departure_point} - #{task.destination_point}"
      )
      expect(@stubDataService.deleteTask).toHaveBeenCalledWith(deletedItem)
      expect(@controller.initialTasksList[0].name).toEqual('test2')
      expect(@controller.tasksList[0][0].name).toEqual('test2')

    it 'if dataService.deleteTask(task) completed with error then initialTasksList
        and tasksList shall not be changed', () =>
      @stubDialogsService.confirmation.and.returnValue(@$q.when())
      @stubDataService.deleteTask.and.callFake(() =>
        p = @$q.defer()
        p.reject('')
        p.promise
      )

      deletedItem = angular.copy(@expectedInitialTasksList[0])

      @$rootScope.$digest()

      expect(@controller.initialTasksList[0].name).toEqual('test1')
      expect(@controller.tasksList[0][0].name).toEqual('test1')

      @controller.delete(@expectedInitialTasksList[0])

      @$rootScope.$digest()

      expect(@stubDialogsService.confirmation).toHaveBeenCalled()
      expect(@stubDataService.deleteTask).toHaveBeenCalledWith(deletedItem)
      expect(@controller.initialTasksList[0].name).toEqual('test1')
      expect(@controller.tasksList[0][0].name).toEqual('test1')

    it 'if dataService.deleteTask(task) but user pressed no in a confirmation dialog
        then the task should not be deleted.', () =>
      @stubDataService.deleteTask.and.returnValue(@$q.when())
      @stubDialogsService.confirmation.and.returnValue(@$q.when())

      deletedItem = angular.copy(@expectedInitialTasksList[0])

      @$rootScope.$digest()

      expect(@controller.initialTasksList[0].name).toEqual('test1')
      expect(@controller.tasksList[0][0].name).toEqual('test1')

      task = @expectedInitialTasksList[0]

      @controller.delete(task)

      @$rootScope.$digest()

      expect(@stubDialogsService.confirmation).toHaveBeenCalledWith(
        "Do you really want delete the task #{task.departure_point} - #{task.destination_point}"
      )
      expect(@stubDataService.deleteTask).toHaveBeenCalledWith(deletedItem)
      expect(@controller.initialTasksList[0].name).toEqual('test2')
      expect(@controller.tasksList[0][0].name).toEqual('test2')

    it 'if dataService.deleteTask(task) completed with error then initialTasksList
        and tasksList shall not be changed', () =>
      @stubDataService.deleteTask.and.returnValue(@$q.when())
      @stubDialogsService.confirmation.and.callFake(() =>
        p = @$q.defer()
        p.reject('')
        p.promise
      )

      deletedItem = angular.copy(@expectedInitialTasksList[0])

      @$rootScope.$digest()

      expect(@controller.initialTasksList[0].name).toEqual('test1')
      expect(@controller.tasksList[0][0].name).toEqual('test1')

      @controller.delete(@expectedInitialTasksList[0])

      @$rootScope.$digest()

      expect(@stubDialogsService.confirmation).toHaveBeenCalled()
      expect(@controller.initialTasksList[0].name).toEqual('test1')
      expect(@controller.tasksList[0][0].name).toEqual('test1')


  describe 'controller.getStation(station)', () =>
    it 'return list of names', () =>
      @stubDataService.getStation.and.returnValue(@$q.when(
        data:[
          name: 'test1'
          full_name: 'test1 full'
          code: '0'
        ,
          name: 'test2'
          full_name: 'test2 full'
          code: '1'
        ,
          name: 'test3'
          full_name: 'test3 full'
          code: '2'
        ]
      ))

      result = []

      stations = @controller.getStation('test')

      stations.then (data) ->
        result = data

      @$rootScope.$digest()

      expect(result).toEqual([
        name: 'test1'
        full_name: 'test1 full'
        code: '0'
      ,
        name: 'test2'
        full_name: 'test2 full'
        code: '1'
      ,
        name: 'test3'
        full_name: 'test3 full'
        code: '2'
      ])

  describe 'controller.getTrain(params)', () =>
    it 'return list of trains', () =>
      @stubDataService.getTrain.and.returnValue(@$q.when(
        data:[
          full_name: '123B HOMIEL-MINSK'
          code: '123B'
        ,
          full_name: '333C BREST-MINSK'
          code: '333C'
        ,
          full_name: '232A MINSK-GRODNO'
          code: '232A'
        ]
      ))

      result = []

      params =
        date: '10-10-2015'
        departure: 'HOMIEL'
        destination: 'MINSK'
        train: 'HO'

      trains = @controller.getTrains(params)

      trains.then (data) ->
        result = data

      @$rootScope.$digest()

      expect(result).toEqual([
        full_name: '123B HOMIEL-MINSK'
        code: '123B'
      ,
        full_name: '333C BREST-MINSK'
        code: '333C'
      ,
        full_name: '232A MINSK-GRODNO'
        code: '232A'
      ])
