###
  The MIT License (MIT)
  Copyright (c) 2015 TrackSeats.info

  Controller of the tasks page

  Constructor initializes scope variables and fetches tasks list
  There are two variables that contain list of tasks
    the first one is initialTasksList
    the second one is tasksList
    Why do we have two? That's because we want to fill page as grid
    four items per line and the only way which I know to do it with ngRepeat
    is split it to chunks, the array of arrays where each array is line on the page
    BUT there is a problem when you need to remove one item from list, you can't
    just remove item from subarray because you in this way you need to shift all
    items in subarrays, in order to make clear a decided to store clear copy of tasks
    and chink them every time we user removes an item.

  Methods:
    createTask(): the goal of the method is to initialize newTask variable
                  and set the edit mode flag createNewTask
    save(task): perform a new and existing object save
                if save is successful then show alert
                (failures should be processed on global level)
                If it is an new task then we have to request
                tasks list again, refresh initialTasksList and then chunk
                tasks to tasksList
    disable(task): Disable selected task, call the dataService.disableTask method
                   and then if successful set task.is_active to false
    enable(task): Enable selected task, call the dataService.enableTask method
                  and then if successful set task.is_active to true
    delete(task): Delete the task, at first call dataService.deleteTask(task)
                  and then if successful remove task from initialTasksList and
                  chunk result to tasksList
    getCities(city): should return from server the list of cities with filter for 'city'
    getTrains(train): should return from server the list of trains with filter for 'train'
                      make sure that departure and destination cities are selected
                      at this point because list of trains are building based on journey route

###
class PagesTasksCtrl
  constructor: (@session, @dataService, @$q, @alertsService) ->
    @tasksList = []
    @initialTasksList = []

    @tasksFilter = ''

    @newTask = null
    @createNewTask = false

    @dataService.getTasks().then ({data}) =>
      @initialTasksList = data.objects
      @tasksList = _.chunk(@initialTasksList, 4)

  createTask: () ->
    @newTask =
      resource_uri: ''
      departure_date: ''
      departure_point: ''
      destination_point: ''
      train: ''
      car: 'ANY'
      seat: 'ANY'
      is_active: true
      owner: @session.user.resource_uri

    @createNewTask = true

  save: (task) ->
    @dataService.saveTask(task).then () =>
      @alertsService.showAlert(
        "The task successfully saved!",
        @alertsService.TYPE.SUCCESS
      )
      if not task.resource_uri
        @dataService.getTasks().then ({data}) =>
          @initialTasksList = data.objects
          @tasksList = _.chunk(@initialTasksList, 4)

  disable: (task) ->
    @dataService.disableTask(task).then () ->
      task.is_active = false

  enable: (task) ->
    @dataService.enableTask(task).then () ->
      task.is_active = true

  # TODO confirmation dialog
  delete: (task) ->
    @dataService.deleteTask(task).then () =>
      _.remove(@initialTasksList, task)
      @tasksList = _.chunk(@initialTasksList, 4)

  getCities: (city) ->
    cities = [
      'МИНСК',
      'ГОМЕЛЬ',
      'БРЕСТ',
      'МОГИЛЕВ',
      'ВИТЕБСК',
      'ГРОДНО'
    ]

  getTrains: (train) ->
    trains = [
      'T345',
      'T564',
      'B493'
    ]

angular
  .module('trackSeatsApp')
  .controller('PagesTasksCtrl', PagesTasksCtrl)

PagesTasksCtrl.$inject = ['session', 'DataService', '$q', 'AlertsService']
