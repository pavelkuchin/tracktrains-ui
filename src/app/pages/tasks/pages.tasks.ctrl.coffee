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
