class PagesTasksCtrl extends SecurePages
  constructor: (@dataService, @$q, @alertsService) ->
    @tasksList = []
    @initialTasksList

    dataService.getTasks().then ({data}) =>
      @initialTasksList = data.objects
      @tasksList = @__itemsToMatrix(@initialTasksList)

  save: (task) ->
    @dataService.saveTask(task).then () =>
      @alertsService.showAlert(
        "The task successfully saved!",
        @alertsService.TYPE.SUCCESS
      )

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
      @tasksList = @__itemsToMatrix(@initialTasksList)

  __itemsToMatrix: (items, itemsInRow = 4) ->
    result = []
    tmp = []
    for item, i in items
      if (i % itemsInRow) == 0 and tmp.length
        result.push tmp
        tmp = []
      tmp.push item
    if tmp.length
      result.push tmp
    result

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
      'T345 Gomel - Minsk (14:33)',
      'T564 Odessa - Minsk (15:42)',
      'B493 Kiev - Minsk (12:34)'
    ]

angular
  .module('trackSeatsApp')
  .controller('PagesTasksCtrl', PagesTasksCtrl)

PagesTasksCtrl.$inject = ['DataService', '$q', 'AlertsService']
