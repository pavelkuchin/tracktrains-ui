class PagesTasksCtrl extends SecurePages
  constructor: (@dataService) ->
    @tasksList = []
    @initialTasksList

    dataService.getTasks().then ({data}) =>
      @initialTasksList = data.objects
      @tasksList = @__itemsToMatrix(@initialTasksList)

  save: (task) ->
    console.log('Save: ', task)

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


angular
  .module('trackSeatsApp')
  .controller('PagesTasksCtrl', PagesTasksCtrl)

PagesTasksCtrl.$inject = ['DataService']
